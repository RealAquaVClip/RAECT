-- Raect/Hooks/useState.luau

local Scheduler = require(script.Parent.Parent.Scheduler)

-- Hook state is stored globally per component instance during render
-- We use a registry keyed by component identity
local stateRegistry = {}

return function(component, initialState)
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
		registry.hooks[index] = {
			value = type(initialState) == "function" and initialState() or initialState,
		}
	end

	local hookState = registry.hooks[index]

	local setState = function(newValue)
		if type(newValue) == "function" then
			newValue = newValue(hookState.value)
		end

		if newValue ~= hookState.value then
			hookState.value = newValue
			Scheduler.scheduleUpdate(function()
				component:forceUpdate()
			end)
		end
	end

	return hookState.value, setState
end