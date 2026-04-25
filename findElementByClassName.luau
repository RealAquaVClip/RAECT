-- Raect/findElementByClassName.luau
-- Find a Roblox Instance by its ClassName in the tree

local function findElementByClassName(rootInstance, className)
	if not rootInstance then
		return nil
	end

	if rootInstance.ClassName == className then
		return rootInstance
	end

	for _, child in ipairs(rootInstance:GetChildren()) do
		local found = findElementByClassName(child, className)
		if found then
			return found
		end
	end

	return nil
end

return findElementByClassName