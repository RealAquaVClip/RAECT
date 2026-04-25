-- Raect/createContext.luau
-- Context API for passing data through component tree

local createContext = {}

function createContext.new(defaultValue)
	local context = {
		_defaultValue = defaultValue,
		_provider = nil,
	}

	context.Provider = function(props)
		local element = require(script.createElement)("ContextProvider", {
			value = props.value,
			context = context,
		}, props.children)
		return element
	end

	context.Consumer = function(props)
		local element = require(script.createElement)("ContextConsumer", {
			context = context,
			render = props.render,
		})
		return element
	end

	return context
end

return createContext