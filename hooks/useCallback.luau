-- Raect/Hooks/useCallback.luau

local useMemo = require(script.useMemo)

return function(component, callback, dependencies)
	return useMemo(component, function()
		return callback
	end, dependencies)
end
