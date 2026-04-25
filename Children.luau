-- Raect/Children.luau
-- Utilities for working with children

local Children = {}

function Children.map(children, fn)
	if type(children) ~= "table" then
		return nil
	end

	local result = {}
	for i, child in ipairs(children) do
		result[i] = fn(child, i)
	end
	return result
end

function Children.forEach(children, fn)
	if type(children) ~= "table" then
		return
	end

	for i, child in ipairs(children) do
		fn(child, i)
	end
end

function Children.count(children)
	if type(children) ~= "table" then
		return 0
	end
	return #children
end

function Children.only(children)
	if type(children) ~= "table" or #children ~= 1 then
		error("Children.only expects exactly one child")
	end
	return children[1]
end

function Children.toArray(children)
	if type(children) ~= "table" then
		return { children }
	end

	local arr = {}
	for i, child in ipairs(children) do
		arr[i] = child
	end
	return arr
end

return Children