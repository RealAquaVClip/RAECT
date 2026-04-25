-- Raect/Hooks/useRef.luau

local stateRegistry = {}

return function(component, initialValue)
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
		registry.hooks[index] = { current = initialValue }
	end

	return registry.hooks[index]
end
