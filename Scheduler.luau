-- Raect/Scheduler.luau
-- Batches updates to Roblox's Heartbeat for performance

local RunService = game:GetService("RunService")

local Scheduler = {}

local pendingUpdates = {}
local isBatching = false
local isScheduled = false

function Scheduler.batch(fn)
	if isBatching then
		fn()
		return
	end

	isBatching = true
	fn()
	isBatching = false

	if #pendingUpdates > 0 and not isScheduled then
		isScheduled = true
		RunService.Heartbeat:Once(function()
			isScheduled = false
			local updates = pendingUpdates
			pendingUpdates = {}

			for _, updateFn in ipairs(updates) do
				local success, err = pcall(updateFn)
				if not success then
					warn("RAECT Scheduler error:", err)
				end
			end
		end)
	end
end

function Scheduler.scheduleUpdate(fn)
	table.insert(pendingUpdates, fn)
end

return Scheduler