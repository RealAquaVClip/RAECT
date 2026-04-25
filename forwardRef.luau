-- Raect/forwardRef.luau
-- Forward refs through components

local function forwardRef(renderFn)
	local component = {
		render = renderFn,
		forwardedRef = true,
	}
	
	return function(props, ref)
		return renderFn(props, ref)
	end
end

return forwardRef