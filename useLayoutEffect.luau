-- Raect/Hooks/useLayoutEffect.luau

local stateRegistry = {}

return function(component, setup, dependencies)
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
		if #prevDeps == #dependencies then
			for i = 1, #dependencies do
				if prevDeps[i] ~= dependencies[i] then
					hasChanged = true
					break
				end
			end
		else
			hasChanged = true
		end
	end

	if hasChanged then
		-- Run synchronously (not scheduled)
		if registry.hooks[index] and registry.hooks[index].cleanup then
			registry.hooks[index].cleanup()
		end

		local cleanupFn = setup()
		registry.hooks[index] = {
			deps = dependencies or {},
			cleanup = cleanupFn,
		}

		if cleanupFn then
			table.insert(component._cleanups, cleanupFn)
		end
	else
		registry.hooks[index] = {
			deps = dependencies or {},
			cleanup = registry.hooks[index] and registry.hooks[index].cleanup,
		}
	end
end