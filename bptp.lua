--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--// Teleport Locations
local locations = {
    ["Buy"] = Vector3.new(-1832.8, 3.3, -4.2),
    ["Sell"] = Vector3.new(3146.6, 2.8, -184.2),
    ["Ammo"] = Vector3.new(-1829.9, 3.3, -25.1),
}

--// Last Position Tracking
local lastPosition = nil
local hasSavedPosition = false

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 360, 0, 380)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(100,160,255)
stroke.Thickness = 1.5

-- Title
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Teleport Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

-- BETA Tag
local betaTag = Instance.new("TextButton")
betaTag.Parent = gui
betaTag.Size = UDim2.new(0, 70, 0, 24)
betaTag.BackgroundColor3 = Color3.fromRGB(90,140,255)
betaTag.Text = "BETA"
betaTag.Font = Enum.Font.GothamBold
betaTag.TextSize = 12
betaTag.TextColor3 = Color3.new(1,1,1)
betaTag.BorderSizePixel = 0
Instance.new("UICorner", betaTag).CornerRadius = UDim.new(0,8)

-- Closed position (default)
local closedPosition = UDim2.new(0.5, -35, 0.5, -12)
betaTag.Position = closedPosition

-- Layout container
local container = Instance.new("Frame")
container.Parent = mainFrame
container.Size = UDim2.new(1, -20, 1, -130)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Save current position as last position (ONLY called before teleport)
local function saveLastPosition()
    if character and character:FindFirstChild("HumanoidRootPart") then
        lastPosition = character.HumanoidRootPart.CFrame
        hasSavedPosition = true
    end
end

-- Teleport function
local function teleportTo(pos)
    if character and character:FindFirstChild("HumanoidRootPart") then
        saveLastPosition() -- Save EXACT position before teleporting
        character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Button creator
local function createButton(text, callback, isUnload)
    local button = Instance.new("TextButton")
    button.Parent = container
    button.Size = UDim2.new(1, 0, 0, 42)
    button.BackgroundColor3 = isUnload and Color3.fromRGB(120,40,40) or Color3.fromRGB(35,35,35)
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(240,240,240)
    button.BorderSizePixel = 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

    local buttonStroke = Instance.new("UIStroke", button)
    buttonStroke.Color = Color3.fromRGB(60,60,60)
    buttonStroke.Thickness = 1

    button.MouseButton1Click:Connect(callback)
end

-- Create location buttons
for name, pos in pairs(locations) do
    createButton(name, function()
        teleportTo(pos)
    end)
end

-- Return to last position button
createButton("Return to Last", function()
    if hasSavedPosition and character and character:FindFirstChild("HumanoidRootPart") and lastPosition then
        character.HumanoidRootPart.CFrame = lastPosition
    end
end)

createButton("Unload Menu", function()
    gui:Destroy()
end, true)

-- Credit
local credit = Instance.new("TextLabel")
credit.Parent = mainFrame
credit.Size = UDim2.new(1, 0, 0, 25)
credit.Position = UDim2.new(0, 0, 1, -28)
credit.BackgroundTransparency = 1
credit.Text = "Made by frostedflakes666"
credit.Font = Enum.Font.Gotham
credit.TextSize = 13
credit.TextColor3 = Color3.fromRGB(150,150,150)

-- Dragging System
local function makeDraggable(frame, onMove)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            if onMove then onMove() end
        end
    end)
end

-- Open position calculation
local function getOpenPosition()
    return UDim2.new(0, mainFrame.AbsolutePosition.X + mainFrame.AbsoluteSize.X - 80, 0, mainFrame.AbsolutePosition.Y + 12)
end

-- Spin animation
local function spinTo(position)
    TweenService:Create(betaTag, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = position,
        Rotation = betaTag.Rotation + 360
    }):Play()
end

-- Toggle logic
local isOpen = true

makeDraggable(mainFrame, function()
    if isOpen then
        betaTag.Position = getOpenPosition()
    end
end)

makeDraggable(betaTag, function()
    if not isOpen then
        closedPosition = betaTag.Position
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    task.wait(1)
    if hasSavedPosition and lastPosition then
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = lastPosition
    end
end)

-- Toggle with Right Shift
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then
            mainFrame.Visible = false
            spinTo(closedPosition)
        else
            mainFrame.Visible = true
            task.wait()
            spinTo(getOpenPosition())
        end
        isOpen = not isOpen
    end
end)
