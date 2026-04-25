local Scheduler = require(script.Scheduler)
local NoopUpdateQueue = { isMounted = function() return false end }

local Component = {}
Component.__index = Component

function Component.new()
	local self = setmetatable({}, Component)

	self.props = {}
	self.state = {}
	self._instance = nil
	self._parent = nil
	self._pendingState = nil
	self._updater = NoopUpdateQueue
	self._isMounted = false
	self._cleanups = {}
	self.context = {}

	return self
end

function Component:init(props, context)
	self.props = props or {}
	self.context = context or {}

	if type(self.willInit) == "function" then
		self:willInit(self.props, self.context)
	end
end

function Component:setState(partialState, callback)
	self._pendingState = self._pendingState or {}
	
	if type(partialState) == "function" then
		partialState = partialState(self.state, self.props)
	end

	for key, value in partialState do
		self._pendingState[key] = value
	end

	if not self._isMounted then
		self:_applyPendingState()
		return
	end

	Scheduler.scheduleUpdate(function()
		self:_applyPendingState()
		if callback then
			callback()
		end
	end)
end

function Component:_applyPendingState()
	if not self._pendingState then return end

	for key, value in self._pendingState do
		self.state[key] = value
	end
	self._pendingState = nil
	self:forceUpdate()
end

function Component:forceUpdate()
	if self._isMounted and self._instance then
		local newInstance = self:render()
		local Reconciler = require(script.Reconciler)
		Reconciler.reconcile(self._instance, newInstance)
	end
end

function Component:render()
	return require(script.createElement)("Frame")
end

function Component:didMount()
	-- override in subclass
end

function Component:didUpdate(previousProps, previousState)
	-- override in subclass
end

function Component:willUnmount()
	for _, cleanup in ipairs(self._cleanups) do
		cleanup()
	end
end

function Component:shouldUpdate(nextProps, nextState): boolean
	return true
end

return Component