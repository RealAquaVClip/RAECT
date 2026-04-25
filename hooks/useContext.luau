-- Raect/Hooks/useContext.luau

return function(component, context)
	-- Walk up the component tree to find Provider
	-- This is simplified - real impl would traverse parent components
	if component.context and component.context[context] then
		return component.context[context]
	end

	return context._defaultValue or nil
end
