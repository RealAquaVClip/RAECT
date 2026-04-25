-- Raect/Hooks/useId.luau

local idCounter = 0

return function()
	idCounter = idCounter + 1
	return ":raect" .. idCounter .. ":"
end
