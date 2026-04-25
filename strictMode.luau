-- Raect/StrictMode.luau
-- Development mode warnings and double-invocation checks

local StrictMode = {}
StrictMode.__index = StrictMode

function StrictMode.new(props)
	local self = setmetatable({}, StrictMode)
	self._children = props.children
	self._warnedHooks = {}
	return self
end

function StrictMode:render()
	if game:GetService("RunService"):IsStudio() then
		-- Double-invoke effects in dev mode
		-- This is handled at the reconciler level
		return self._children
	end
	return self._children
end

return StrictMode