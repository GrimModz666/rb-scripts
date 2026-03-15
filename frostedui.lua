-- ===========================
-- Frosted UI Library vBeta (Complete)
-- ===========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local MenuLib = {}
MenuLib.Tabs = {}
MenuLib.ActiveTab = nil

--// ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

--==========================
-- Main Menu Frame
--==========================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,18)
mainFrame.Parent = gui
mainFrame.Visible = true

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(100,160,255)
stroke.Thickness = 1.5

-- Title
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

function MenuLib:SetTitle(newTitle)
    title.Text = newTitle
end

-- Beta Tag (Top-right of menu, moves with menu)
local betaTag = Instance.new("TextLabel")
betaTag.Parent = mainFrame
betaTag.Size = UDim2.new(0, 70, 0, 24)
betaTag.Position = UDim2.new(1, -80, 0, 10) -- top-right
betaTag.BackgroundColor3 = Color3.fromRGB(90,140,255)
betaTag.Text = "BETA"
betaTag.Font = Enum.Font.GothamBold
betaTag.TextSize = 12
betaTag.TextColor3 = Color3.new(1,1,1)
betaTag.BorderSizePixel = 0
Instance.new("UICorner", betaTag).CornerRadius = UDim.new(0,8)

-- Tab Buttons (flush under menu title)
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Parent = mainFrame
tabButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
tabButtonsFrame.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.Padding = UDim.new(0,10)

-- Tab Content Container
local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1, -20, 1, -120)
tabContainer.Position = UDim2.new(0,10,0,100)
tabContainer.BackgroundTransparency = 1

-- Draggable function (ignores sliders)
local function makeDraggable(frame)
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
        end
    end)
end
makeDraggable(mainFrame)

--==========================
-- Menu API (Tabs, Buttons, Toggles, Sliders, Inputs, Dropdowns, Keybinds)
--==========================
function MenuLib:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Buttons = {}

    -- Tab button
    tab.TabButton = Instance.new("TextButton")
    tab.TabButton.Parent = tabButtonsFrame
    tab.TabButton.Size = UDim2.new(0, 100, 1, 0)
    tab.TabButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
    tab.TabButton.Text = name
    tab.TabButton.Font = Enum.Font.GothamBold
    tab.TabButton.TextColor3 = Color3.fromRGB(240,240,240)
    tab.TabButton.TextSize = 14
    tab.TabButton.BorderSizePixel = 0
    Instance.new("UICorner", tab.TabButton).CornerRadius = UDim.new(0,6)

    -- Tab content
    tab.TabContent = Instance.new("Frame")
    tab.TabContent.Size = UDim2.new(1,0,1,0)
    tab.TabContent.BackgroundTransparency = 1
    tab.TabContent.Visible = false
    tab.TabContent.Parent = tabContainer

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0,8)
    layout.Parent = tab.TabContent

    -- Tab switching
    local function activateTab()
        for _, t in ipairs(MenuLib.Tabs) do
            t.TabContent.Visible = false
        end
        tab.TabContent.Visible = true
        MenuLib.ActiveTab = tab
    end

    tab.TabButton.MouseButton1Click:Connect(activateTab)
    table.insert(MenuLib.Tabs, tab)

    if #MenuLib.Tabs == 1 then
        activateTab()
    end

    -- Button API
    function tab:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Parent = tab.TabContent
        button.Size = UDim2.new(1,0,0,40)
        button.BackgroundColor3 = Color3.fromRGB(35,35,35)
        button.Text = text
        button.Font = Enum.Font.GothamSemibold
        button.TextSize = 16
        button.TextColor3 = Color3.fromRGB(240,240,240)
        button.BorderSizePixel = 0
        Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = Color3.fromRGB(60,60,60)
        stroke.Thickness = 1
        button.MouseButton1Click:Connect(callback)
        table.insert(tab.Buttons, button)
    end

    -- Toggle API
    function tab:CreateToggle(text, callback)
        local frame = Instance.new("Frame")
        frame.Parent = tab.TabContent
        frame.Size = UDim2.new(1,0,0,40)
        frame.BackgroundTransparency = 1

        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Parent = frame
        toggleLabel.Size = UDim2.new(0.7,0,1,0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(240,240,240)
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 16
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local toggleButton = Instance.new("TextButton")
        toggleButton.Parent = frame
        toggleButton.Size = UDim2.new(0,40,0,20)
        toggleButton.Position = UDim2.new(0.75,0,0.25,0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
        toggleButton.Text = ""
        toggleButton.BorderSizePixel = 0
        Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0,6)

        local state = false
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            toggleButton.BackgroundColor3 = state and Color3.fromRGB(90,140,255) or Color3.fromRGB(60,60,60)
            callback(state)
        end)
    end

    -- Slider API (slider drag does not move menu)
    function tab:CreateSlider(text, min, max, callback)
        local frame = Instance.new("Frame")
        frame.Parent = tab.TabContent
        frame.Size = UDim2.new(1,0,0,40)
        frame.BackgroundTransparency = 1

        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Parent = frame
        sliderLabel.Size = UDim2.new(0.5,0,1,0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text.." [0]"
        sliderLabel.TextColor3 = Color3.fromRGB(240,240,240)
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 16
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = frame
        sliderFrame.Size = UDim2.new(0.45,0,0.3,0)
        sliderFrame.Position = UDim2.new(0.5,0,0.35,0)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
        sliderFrame.BorderSizePixel = 0
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,6)

        local dragging = false
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X)/sliderFrame.AbsoluteSize.X,0,1)
                sliderFrame.Size = UDim2.new(relativeX,0,0.3,0)
                local value = math.floor(min + (max-min)*relativeX)
                sliderLabel.Text = text.." ["..value.."]"
                callback(value)
            end
        end)
    end

    return tab
end

return MenuLib
