-- Raect/PureComponent.luau
local Component = require(script.Component)

local PureComponent = setmetatable({}, { __index = Component })
PureComponent.__index = PureComponent

function PureComponent.new()
	return setmetatable(Component.new(), PureComponent)
end

local function shallowEqual(obj1, obj2)
	if obj1 == obj2 then return true end
	if type(obj1) ~= "table" or type(obj2) ~= "table" then return false end

	for key, value in obj1 do
		if obj2[key] ~= value then
			return false
		end
	end

	for key, _ in obj2 do
		if obj1[key] == nil then
			return false
		end
	end

	return true
end

function PureComponent:shouldUpdate(nextProps, nextState): boolean
	return not shallowEqual(self.props, nextProps) or not shallowEqual(self.state, nextState)
end

return PureComponent