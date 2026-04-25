-- Raect/createRef.luau
-- Creates a ref object for direct instance access

local function createRef()
	return {
		current = nil,
	}
end

return createRef