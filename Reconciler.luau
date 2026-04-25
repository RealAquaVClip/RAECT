-- Raect/Reconciler.luau
-- Instance reconciliation engine

local Scheduler = require(script.Scheduler)

local Reconciler = {}

local ROOT_KEY = "_raectRoot"

-- mapping from element types to Roblox ClassNames
local ELEMENT_MAP = {
	ScreenGui = "ScreenGui",
	SurfaceGui = "SurfaceGui",
	BillboardGui = "BillboardGui",
	Frame = "Frame",
	ScrollingFrame = "ScrollingFrame",
	CanvasGroup = "CanvasGroup",
	ViewportFrame = "ViewportFrame",
	VideoFrame = "VideoFrame",
	TextLabel = "TextLabel",
	TextButton = "TextButton",
	TextBox = "TextBox",
	ImageLabel = "ImageLabel",
	ImageButton = "ImageButton",
	UIListLayout = "UIListLayout",
	UIGridLayout = "UIGridLayout",
	UIPageLayout = "UIPageLayout",
	UITableLayout = "UITableLayout",
	UIPadding = "UIPadding",
	UICorner = "UICorner",
	UIScale = "UIScale",
	UISizeConstraint = "UISizeConstraint",
	UITextSizeConstraint = "UITextSizeConstraint",
	UIAspectRatioConstraint = "UIAspectRatioConstraint",
	UIGradient = "UIGradient",
}

local PROPERTY_BLACKLIST = {
	Children = true,
	Parent = true,
	Name = true,
}

local EVENT_PREFIX_MAP = {
	Activated = "Activated",
	MouseButton1Click = "MouseButton1Click",
	MouseButton2Click = "MouseButton2Click",
	MouseEnter = "MouseEnter",
	MouseLeave = "MouseLeave",
	InputBegan = "InputBegan",
	InputEnded = "InputEnded",
	FocusLost = "FocusLost",
	Focused = "Focused",
	SelectionChanged = "SelectionChanged",
}

local function isEvent(propName)
	return EVENT_PREFIX_MAP[propName] ~= nil or
		propName:match("^On") ~= nil or
		propName:match("^Touch") ~= nil or
		propName:match("^Drag") ~= nil
end

local function createInstanceFromElement(element)
	-- check if it's a string element type
	if type(element.type) == "string" then
		local className = ELEMENT_MAP[element.type]
		if className then
			local instance = Instance.new(className)
			Reconciler._applyProps(instance, element.props)
			return instance
		else
			error("Unknown element type: " .. element.type)
		end
	end

	return nil
end

function Reconciler._applyProps(instance, props)
	if not props then return end

	for propName, propValue in pairs(props) do
		if PROPERTY_BLACKLIST[propName] then
			-- skip it
		elseif isEvent(propName) then
			-- connect event
			local eventName = propName:gsub("^On", "")
			local event = instance[eventName]
			if event then
				if instance._raectConnections then
					if instance._raectConnections[propName] then
						instance._raectConnections[propName]:Disconnect()
					end
				else
					instance._raectConnections = {}
				end

				instance._raectConnections[propName] = event:Connect(function(...)
					propValue(...)
				end)
			end
		else
			-- Set property
			pcall(function()
				instance[propName] = propValue
			end)
		end
	end
end

function Reconciler.reconcile(oldInstance, newElement)
	if not oldInstance or not newElement then
		return oldInstance
	end

	-- update props
	Reconciler._applyProps(oldInstance, newElement.props)

	-- reconcile children
	local oldChildren = oldInstance:GetChildren()
	local newChildren = {}

	if newElement.children then
		for _, childElement in ipairs(newElement.children) do
			table.insert(newChildren, childElement)
		end
	end

	-- filter out non-RAECT children
	local managedChildren = {}
	for _, child in ipairs(oldChildren) do
		if child:GetAttribute("_raectManaged") then
			table.insert(managedChildren, child)
		end
	end

	local maxLen = math.max(#managedChildren, #newChildren)

	for i = 1, maxLen do
		local oldChild = managedChildren[i]
		local newChildElement = newChildren[i]

		if oldChild and newChildElement then
			if oldChild.ClassName == ELEMENT_MAP[newChildElement.type] then
				Reconciler.reconcile(oldChild, newChildElement)
			else
				local newChild = Reconciler._buildInstance(newChildElement)
				if newChild then
					newChild.Parent = oldInstance
					oldChild:Destroy()
				end
			end
		elseif newChildElement then
			local newChild = Reconciler._buildInstance(newChildElement)
			if newChild then
				newChild.Parent = oldInstance
			end
		elseif oldChild then
			oldChild:Destroy()
		end
	end

	return oldInstance
end

function Reconciler._buildInstance(element)
	if not element then return nil end

	-- handle strin & gnumber children (convert to TextLabel)
	if type(element) == "string" or type(element) == "number" then
		local label = Instance.new("TextLabel")
		label.Text = tostring(element)
		label:SetAttribute("_raectManaged", true)
		return label
	end

	-- handle Fragment
	if element.type == "Fragment" then
		return nil -- fragment children are handled at parent level
	end

	-- handle component functions/classes
	if type(element.type) == "function" or type(element.type) == "table" then
		local component
		local props = element.props or {}
		
		if type(element.type) == "table" and element.type.new then
			component = element.type.new()
			component:init(props)
		elseif type(element.type) == "table" and element.type.render then
			component = element.type
			component.props = props
		elseif type(element.type) == "function" then
			local rendered = element.type(props)
			return Reconciler._buildInstance(rendered)
		end

		if component and component.render then
			local rendered = component:render()
			local instance = Reconciler._buildInstance(rendered)
			
			if component.didMount then
				Scheduler.scheduleUpdate(function()
					component:didMount()
				end)
			end

			if instance then
				instance:SetAttribute("_raectComponent", component)
			end

			return instance
		end

		return nil
	end

	-- handle string element types
	local className = ELEMENT_MAP[element.type]
	if not className then
		warn("Unknown RAECT element type:", element.type)
		return nil
	end

	local instance = Instance.new(className)
	instance:SetAttribute("_raectManaged", true)
	
	Reconciler._applyProps(instance, element.props)

	-- recursively build children
	if element.children then
		for _, childElement in ipairs(element.children) do
			local childInstance = Reconciler._buildInstance(childElement)
			if childInstance then
				childInstance.Parent = instance
			end
		end
	end

	return instance
end

function Reconciler.mount(element, parent)
	local instance = Reconciler._buildInstance(element)
	if instance and parent then
		instance.Parent = parent
	end
	return instance
end

function Reconciler.unmount(instance)
	if instance then
		-- clean up connections
		if instance._raectConnections then
			for _, conn in pairs(instance._raectConnections) do
				conn:Disconnect()
			end
		end

		-- recursively unmount children
		for _, child in ipairs(instance:GetChildren()) do
			Reconciler.unmount(child)
		end

		instance:Destroy()
	end
end

function Reconciler.update(instance, newElement)
	return Reconciler.reconcile(instance, newElement)
end

return Reconciler