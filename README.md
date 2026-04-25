# RAECT

React-style components for Roblox Luau. Hooks, state, props, the whole deal. Write UI that actually makes sense without fighting the Roblox API.

## Installation

1. Drag the RAECT folder into ReplicatedStorage
2. Require the main module:
```lua
local Raect = require(game.ReplicatedStorage.RAECT)
```

## Core Concepts

### createElement

The foundation of every UI element. Pass a Roblox class name string or a function component.

```lua
Raect.createElement("Frame", {
    Size = UDim2.new(0, 200, 0, 100),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
}, {
    Raect.createElement("TextLabel", {
        Text = "Hello RAECT",
        Size = UDim2.new(1, 0, 1, 0),
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
    }),
})
```

### Components

Function components use hooks for state and effects.

```lua
local function MyButton(props)
    local count, setCount = Raect.useState(0)
    local step, setStep = Raect.useState(1)

    return Raect.createElement("TextButton", {
        Text = "Clicked " .. tostring(count) .. " times",
        Size = UDim2.new(0, 150, 0, 40),
        BackgroundColor3 = Color3.fromRGB(50, 180, 50),
        TextColor3 = Color3.new(1, 1, 1),
        Activated = function()
            setCount(function(c) return c + step end)
        end,
    }, {
        Raect.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
    })
end
```

Class components work too, using `Component` as a base.

```lua
local Component = require(game.ReplicatedStorage.RAECT.Component)

local MyClassComponent = setmetatable({}, { __index = Component })

function MyClassComponent.new()
    local self = setmetatable(Component.new(), MyClassComponent)
    self.state = { count = 0 }
    return self
end

function MyClassComponent:render()
    return Raect.createElement("TextLabel", {
        Text = "Count: " .. tostring(self.state.count),
    })
end
```

### Hooks

**useState** — Local state for function components.

```lua
local count, setCount = Raect.useState(0)
setCount(5)                      -- direct value
setCount(function(c) return c + 1 end) -- updater function
```

**useReducer** — For complex state logic.

```lua
local function reducer(state, action)
    if action.type == "INCREMENT" then
        return { count = state.count + 1 }
    end
    return state
end

local state, dispatch = Raect.useReducer(reducer, { count = 0 })
dispatch({ type = "INCREMENT" })
```

### Mounting

```lua
local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
local app = Raect.createElement(MyApp)
Raect.mount(app, gui)
```

### Suspense & Lazy Loading

```lua
local myModal = Raect.lazy(function()
    return require(game.ReplicatedStorage.UI.MyModal)
end)

local function App()
    return Raect.createElement("Frame", {}, {
        Raect.createElement(SuspenseComponent, {
            fallback = Raect.createElement("TextLabel", { Text = "Loading..." }),
        }, {
            Raect.createElement(myModal),
        }),
    })
end
```

### Context

```lua
local ThemeContext = Raect.createContext({ theme = "dark" })

-- Provider
Raect.createElement(ThemeContext.Provider, {
    value = { theme = "light" },
}, {
    Raect.createElement(MyChildComponent),
})

-- Consumer
Raect.createElement(ThemeContext.Consumer, {
    render = function(value)
        return Raect.createElement("TextLabel", {
            Text = "Theme: " .. value.theme,
        })
    end,
})
```

### Children Utilities

```lua
local Children = require(game.ReplicatedStorage.RAECT.Children)

Children.map(children, function(child, index)
    return Raect.createElement("Frame", {}, { child })
end)

Children.forEach(children, function(child) print(child) end)
local count = Children.count(children)
local only = Children.only(children)
local arr = Children.toArray(children)
```

### Available Roblox Elements

Frame, ScrollingFrame, CanvasGroup, TextLabel, TextButton, TextBox, ImageLabel, ImageButton, ScreenGui, SurfaceGui, BillboardGui, VideoFrame, ViewportFrame, UIListLayout, UIGridLayout, UIPageLayout, UITableLayout, UIPadding, UICorner, UIScale, UISizeConstraint, UIAspectRatioConstraint, UIGradient

### Refs

```lua
local myRef = Raect.createRef()

Raect.createElement("TextBox", {
    Ref = myRef,
    Text = "type here",
})

-- later...
print(myRef.current.Text) -- "type here"
```

### Event Handling

Use Roblox event names directly as props:

```lua
Raect.createElement("TextButton", {
    Activated = function() print("clicked") end,
    MouseEnter = function() print("hover") end,
    FocusLost = function(rbx) print(rbx.Text) end,
})
```

### Key Props

Add `Key` to elements in lists for efficient reconciliation:

```lua
for _, item in ipairs(items) do
    Raect.createElement("Frame", { Key = item.id }, {
        Raect.createElement("TextLabel", { Text = item.name }),
    })
end
```

## Full Example

```lua
local Players = game:GetService("Players")
local Raect = require(script.Parent.RAECT)

local function Counter()
    local count, setCount = Raect.useState(0)
    local step, setStep = Raect.useState(1)

    return Raect.createElement("Frame", {
        Size = UDim2.new(0, 250, 0, 200),
        Position = UDim2.new(0.5, -125, 0.5, -100),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    }, {
        Raect.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Raect.createElement("TextLabel", {
            Text = tostring(count),
            Size = UDim2.new(1, 0, 0, 50),
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBlack,
            TextSize = 42,
            BackgroundTransparency = 1,
        }),
        Raect.createElement("TextButton", {
            Text = "+",
            Size = UDim2.new(0, 50, 0, 35),
            BackgroundColor3 = Color3.fromRGB(50, 180, 50),
            TextColor3 = Color3.new(1, 1, 1),
            Activated = function()
                setCount(function(c) return c + step end)
            end,
        }),
    })
end

local gui = Players.LocalPlayer:WaitForChild("PlayerGui")
local app = Raect.createElement(Counter)
Raect.mount(app, gui)
```
