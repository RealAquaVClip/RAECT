-- Raect/Portal.luau
-- lortal for rendering into different containers

local createElement = require(script.createElement)

local Portal = {}
Portal.__index = Portal

function Portal.new(target, children)
	local self = setmetatable({}, Portal)
	self._target = target
	self._children = children
	self._portalInstance = nil
	return self
end

function Portal:render()
	return createElement("Portal", {
		target = self._target,
		children = self._children,
	})
end

return Portal