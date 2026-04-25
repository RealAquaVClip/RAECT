-- Raect/createFragment.luau
-- Fragment component for grouping children without wrapper

local Fragment = {}
Fragment.__index = Fragment

function Fragment.new()
	return setmetatable({}, Fragment)
end

function Fragment:render()
	return nil -- Fragment renders nothing, children are rendered directly
end

return function(props)
	local fragment = {
		type = "Fragment",
		props = props or {},
		key = nil,
		ref = nil,
		children = {},
	}

	if props and props.children then
		fragment.children = props.children
		props.children = nil
	end

	return fragment
end