-- Raect/ErrorBoundary.luau
-- error boundary component

local Component = require(script.Component)
local createElement = require(script.createElement)

local ErrorBoundaryComponent = setmetatable({}, { __index = Component })
ErrorBoundaryComponent.__index = ErrorBoundaryComponent

function ErrorBoundaryComponent.new()
	local self = setmetatable(Component.new(), ErrorBoundaryComponent)
	self.state = {
		hasError = false,
		errorInfo = nil,
	}
	return self
end

function ErrorBoundaryComponent:componentDidCatch(errorInfo)
	self:setState({
		hasError = true,
		errorInfo = errorInfo,
	})

	if self.props.onError then
		self.props.onError(errorInfo)
	end
end

function ErrorBoundaryComponent:render()
	if self.state.hasError then
		if self.props.fallback then
			if type(self.props.fallback) == "function" then
				return self.props.fallback(self.state.errorInfo)
			end
			return self.props.fallback
		end
		
		return createElement("TextLabel", {
			Text = "Something went wrong.",
			Size = UDim2.new(1, 0, 1, 0),
			TextColor3 = Color3.new(1, 0, 0),
		})
	end

	return self.props.children
end

local ErrorBoundary = {
	new = function(props)
		return createElement(ErrorBoundaryComponent, props)
	end,
}

return ErrorBoundary