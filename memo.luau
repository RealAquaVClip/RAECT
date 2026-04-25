-- Raect/memo.luau
-- higher order component that memoizes rendering

local function shallowEqual(t1, t2)
	if t1 == t2 then return true end
	if type(t1) ~= "table" or type(t2) ~= "table" then return false end

	for k, v in t1 do
		if t2[k] ~= v then return false end
	end

	for k, _ in t2 do
		if t1[k] == nil then return false end
	end

	return true
end

local function memo(componentFn, arePropsEqual)
	local compareFn = arePropsEqual or shallowEqual
	
	return function(props)
		local component = {
			_prevProps = nil,
			_cachedResult = nil,
			_compareFn = compareFn,
			renderFn = componentFn,
		}

		function component:render()
			if self._cachedResult and self._compareFn(self._prevProps, self.props) then
				return self._cachedResult
			end

			self._prevProps = {}
			for k, v in self.props do
				self._prevProps[k] = v
			end

			self._cachedResult = self.renderFn(self.props)
			return self._cachedResult
		end

		return component
	end
end

return memo