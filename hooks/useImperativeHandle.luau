-- Raect/Hooks/useImperativeHandle.luau

local stateRegistry = {}

return function(component, ref, createHandle, dependencies)
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

	local prevDeps = registry.hooks[index]
	local hasChanged = true

	if prevDeps and dependencies then
		hasChanged = false
		for i = 1, #dependencies do
			if prevDeps[i] ~= dependencies[i] then
				hasChanged = true
				break
			end
		end
	end

	if hasChanged and ref then
		registry.hooks[index] = dependencies
		ref.current = createHandle()
	end
end
