-- Raect/Hooks/useReducer.luau

local Scheduler = require(script.Parent.Parent.Scheduler)
local stateRegistry = {}

return function(component, reducer, initialState, initializer)
	local key = component
	if not stateRegistry[key] then
		stateRegistry[key] = {
			hookIndex = 0,
			hooks = {},
		}
	end

	local registry = stateRegistry[key]
	local index = registry.hookIndex
	registry.hookIndex = registry.hookIndex + 1

	if registry.hooks[index] == nil then
		local state = initialState
		if initializer then
			state = initializer(initialState)
		end
		registry.hooks[index] = {
			value = state,
			reducer = reducer,
		}
	end

	local hookState = registry.hooks[index]

	local dispatch = function(action)
		hookState.value = hookState.reducer(hookState.value, action)
		Scheduler.scheduleUpdate(function()
			component:forceUpdate()
		end)
	end

	return hookState.value, dispatch
end