-- Raect/Hooks/useMemo.luau

local stateRegistry = {}

return function(component, factory, dependencies)
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

	local prev = registry.hooks[index]
	local hasChanged = true

	if prev and prev.dependencies and dependencies then
		hasChanged = false
		if #prev.dependencies == #dependencies then
			for i = 1, #dependencies do
				if prev.dependencies[i] ~= dependencies[i] then
					hasChanged = true
					break
				end
			end
		else
			hasChanged = true
		end
	end

	if hasChanged then
		local value = factory()
		registry.hooks[index] = {
			value = value,
			dependencies = dependencies,
		}
		return value
	end

	return prev.value
end
