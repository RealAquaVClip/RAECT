-- Raect/Suspense.luau
-- suspense boundary for async operations

local createElement = require(script.createElement)
local Component = require(script.Component)

local SuspenseComponent = setmetatable({}, { __index = Component })
SuspenseComponent.__index = SuspenseComponent

function SuspenseComponent.new()
	local self = setmetatable(Component.new(), SuspenseComponent)
	self.state = {
		error = nil,
		hasError = false,
	}
	return self
end

function SuspenseComponent:componentDidCatch(error)
	if type(error) == "table" and type(error.andThen) == "function" then
		-- it a Promise
		self:setState({ hasError = true, error = error })
		error:andThen(function()
			self:setState({ hasError = false, error = nil })
		end):catch(function(err)
			warn("Suspense error:", err)
			self:setState({ hasError = false, error = nil })
		end)
	else
		-- rethrow errors
		error("Suspense caught non-Promise: " .. tostring(error))
	end
end

function SuspenseComponent:render()
	if self.state.hasError then
		return self.props.fallback
	end

	return self.props.children
end

local Suspense = {
	new = function(props)
		local element = createElement(SuspenseComponent, {
			fallback = props.fallback,
			children = props.children,
		})
		return element
	end,
}

return Suspense