local Players = game:GetService("Players")
local Raect = require(script.Parent.Raect)

-- simple counter app
local function Counter()
	local count, setCount = Raect.useState(0)
	local step, setStep = Raect.useState(1)
	
	return Raect.createElement("Frame", {
		Size = UDim2.new(0, 250, 0, 200),
		Position = UDim2.new(0.5, -125, 0.5, -100),
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	}, {
		Raect.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
		
		Raect.createElement("UIListLayout", {
			Padding = UDim.new(0, 10),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		-- title
		Raect.createElement("TextLabel", {
			Text = "RAECT Counter",
			Size = UDim2.new(0, 200, 0, 30),
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBold,
			TextSize = 22,
			BackgroundTransparency = 1,
		}),

		-- count display
		Raect.createElement("TextLabel", {
			Text = tostring(count),
			Size = UDim2.new(0, 200, 0, 50),
			TextColor3 = count < 0 and Color3.new(1, 0.3, 0.3) or Color3.new(1, 1, 1),
			Font = Enum.Font.GothamBlack,
			TextSize = 42,
			BackgroundTransparency = 1,
		}),

		-- buttons row
		Raect.createElement("Frame", {
			Size = UDim2.new(0, 200, 0, 35),
			BackgroundTransparency = 1,
		}, {
			Raect.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),

			-- decrement
			Raect.createElement("TextButton", {
				Text = "-",
				Size = UDim2.new(0, 50, 0, 35),
				BackgroundColor3 = Color3.fromRGB(200, 50, 50),
				TextColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.GothamBold,
				TextSize = 20,
				Activated = function()
					setCount(function(c) return c - step end)
				end,
			}, {
				Raect.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
			}),

			-- increment
			Raect.createElement("TextButton", {
				Text = "+",
				Size = UDim2.new(0, 50, 0, 35),
				BackgroundColor3 = Color3.fromRGB(50, 180, 50),
				TextColor3 = Color3.new(1, 1, 1),
				Font = Enum.Font.GothamBold,
				TextSize = 20,
				Activated = function()
					setCount(function(c) return c + step end)
				end,
			}, {
				Raect.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
			}),
		}),

		-- step input
		Raect.createElement("Frame", {
			Size = UDim2.new(0, 200, 0, 30),
			BackgroundTransparency = 1,
		}, {
			Raect.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 5),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			
			Raect.createElement("TextLabel", {
				Text = "Step:",
				Size = UDim2.new(0, 35, 0, 25),
				TextColor3 = Color3.fromRGB(200, 200, 200),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BackgroundTransparency = 1,
			}),

			Raect.createElement("TextBox", {
				Text = tostring(step),
				Size = UDim2.new(0, 50, 0, 25),
				TextColor3 = Color3.new(1, 1, 1),
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				FocusLost = function(rbx)
					local num = tonumber(rbx.Text)
					if num then
						setStep(num)
					else
						rbx.Text = tostring(step)
					end
				end,
			}),
		}),

		-- reset button
		Raect.createElement("TextButton", {
			Text = "Reset",
			Size = UDim2.new(0, 80, 0, 30),
			BackgroundColor3 = Color3.fromRGB(80, 80, 80),
			TextColor3 = Color3.new(1, 1, 1),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			Activated = function()
				setCount(0)
				setStep(1)
			end,
		}, {
			Raect.createElement("UICorner", { CornerRadius = UDim.new(0, 5) }),
		}),
	})
end

-- mount it to the screen
local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
local app = Raect.createElement(Counter)
Raect.mount(app, gui)