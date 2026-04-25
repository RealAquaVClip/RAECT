-- the core createElement (h) function

local createFragment = require(script.createFragment)

local function createElement(elementType, props, children)
	if elementType == nil then
		error("createElement: elementType cannot be nil")
	end

	local element = {
		type = elementType,
		props = props or {},
		key = nil,
		ref = nil,
		children = {},
	}

	if props then
		element.key = props.Key or props.key
		props.Key = nil
		props.key = nil

		element.ref = props.Ref or props.ref
		props.Ref = nil
		props.ref = nil
	end

	-- handle children parameter
	if children then
		if type(children) == "table" then
			-- check if it's an array
			if #children > 0 then
				for _, child in ipairs(children) do
					table.insert(element.children, child)
				end
			else
				table.insert(element.children, children)
			end
		else
			-- Single child
			table.insert(element.children, children)
		end
	end

	return element
end

-- JSX-like aliases
createElement.Fragment = createFragment

return createElement