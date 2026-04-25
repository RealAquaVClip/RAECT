-- Raect/lazy.luau
-- lazy loading for components

local Suspense = require(script.Suspense)

local function lazy(importFn)
	local loadedComponent = nil
	local loadPromise = nil

	return function(props)
		if loadedComponent then
			return loadedComponent(props)
		end

		if not loadPromise then
			loadPromise = importFn()
			loadPromise:andThen(function(module)
				if type(module) == "function" then
					loadedComponent = module
				elseif type(module) == "table" and module.default then
					loadedComponent = module.default
				else
					loadedComponent = module
				end
			end)
		end

		-- throw promise for Suspense to catch
		error(loadPromise)
	end
end

return lazy