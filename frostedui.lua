--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// MenuLib
local MenuLib = {}
MenuLib.Tabs = {}
MenuLib.Notifications = {}
MenuLib.ActiveTab = nil

--// ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 420)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,18)
mainFrame.Parent = gui

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

-- Beta Tag
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
local closedPosition = UDim2.new(0.5, -35, 0.5, -12)
betaTag.Position = closedPosition

-- Tab Buttons Container
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

-- Draggable
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
makeDraggable(betaTag)

-- Toggle
local isOpen = true
local function spinTo(position)
    TweenService:Create(betaTag, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = position,
        Rotation = betaTag.Rotation + 360
    }):Play()
end
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then
            mainFrame.Visible = false
            spinTo(closedPosition)
        else
            mainFrame.Visible = true
            task.wait()
            spinTo(betaTag.Position)
        end
        isOpen = not isOpen
    end
end)

--// Menu API
function MenuLib:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Buttons = {}
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

    tab.TabContent = Instance.new("Frame")
    tab.TabContent.Size = UDim2.new(1,0,1,0)
    tab.TabContent.BackgroundTransparency = 1
    tab.TabContent.Visible = false
    tab.TabContent.Parent = tabContainer

    function tab:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Parent = tab.TabContent
        button.Size = UDim2.new(1,0,0,42)
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

    -- Tab switching
    tab.TabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(MenuLib.Tabs) do
            t.TabContent.Visible = false
        end
        tab.TabContent.Visible = true
        MenuLib.ActiveTab = tab
    end)

    table.insert(MenuLib.Tabs, tab)
    return tab
end

-- Notifications
function MenuLib:Notify(title, text)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 100)
    notif.Position = UDim2.new(0.5, -125, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(35,35,35)
    notif.BorderSizePixel = 0
    notif.Parent = gui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,12)

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notif
    notifTitle.Size = UDim2.new(1, -20, 0, 30)
    notifTitle.Position = UDim2.new(0,10,0,10)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(240,240,240)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16

    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.Size = UDim2.new(1, -20, 0, 50)
    notifText.Position = UDim2.new(0,10,0,40)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(200,200,200)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14
    notifText.TextWrapped = true

    task.delay(5, function()
        notif:Destroy()
    end)
end

return MenuLib
