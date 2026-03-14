-- ===========================
-- Frosted UI Library
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
-- Loading & Credits Screen
--==========================
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 400, 0, 200)
loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
loadingFrame.BorderSizePixel = 0
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0,15)
loadingFrame.Parent = gui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -20, 0, 50)
loadingText.Position = UDim2.new(0,10,0,20)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading Menu..."
loadingText.TextColor3 = Color3.fromRGB(240,240,240)
loadingText.TextSize = 20
loadingText.Font = Enum.Font.GothamBold
loadingText.Parent = loadingFrame

-- Progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0,0,0,20)
progressBar.Position = UDim2.new(0,10,0,90)
progressBar.BackgroundColor3 = Color3.fromRGB(90,140,255)
progressBar.BorderSizePixel = 0
progressBar.Parent = loadingFrame
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0,10)

-- Buttons
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0,180,0,40)
discordButton.Position = UDim2.new(0.5,-90,0,140)
discordButton.BackgroundColor3 = Color3.fromRGB(70,120,250)
discordButton.TextColor3 = Color3.new(1,1,1)
discordButton.Font = Enum.Font.GothamBold
discordButton.Text = "Join Discord"
discordButton.BorderSizePixel = 0
discordButton.Visible = false
Instance.new("UICorner", discordButton).CornerRadius = UDim.new(0,12)
discordButton.Parent = loadingFrame

local okButton = discordButton:Clone()
okButton.Position = UDim2.new(0.5,-90,0,140)
okButton.Text = "Continue"
okButton.Parent = loadingFrame

-- Load animation
for i=0,1,0.02 do
    progressBar.Size = UDim2.new(i,0,0,20)
    task.wait(0.02)
end
discordButton.Visible = true
okButton.Visible = true

discordButton.MouseButton1Click:Connect(function()
    local url = "https://discord.gg/YOURINVITE"
    if syn and syn.request then
        syn.request({Url = url, Method = "GET"})
    else
        setclipboard(url)
    end
end)

local finishedLoading = false
okButton.MouseButton1Click:Connect(function()
    finishedLoading = true
    loadingFrame:Destroy()
end)

repeat task.wait() until finishedLoading

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

-- Tabs Container
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Parent = mainFrame
tabButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
tabButtonsFrame.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.Padding = UDim.new(0,10)

-- Sliding indicator
local sliderIndicator = Instance.new("Frame")
sliderIndicator.Size = UDim2.new(0, 100, 0, 4)
sliderIndicator.Position = UDim2.new(0,0,1,-4)
sliderIndicator.BackgroundColor3 = Color3.fromRGB(90,140,255)
sliderIndicator.BorderSizePixel = 0
sliderIndicator.Parent = tabButtonsFrame
Instance.new("UICorner", sliderIndicator).CornerRadius = UDim.new(0,2)

-- Tab Content Container
local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1, -20, 1, -120)
tabContainer.Position = UDim2.new(0,10,0,100)
tabContainer.BackgroundTransparency = 1

-- Add UIListLayout for tab content
local tabContentLayout = Instance.new("UIListLayout")
tabContentLayout.FillDirection = Enum.FillDirection.Vertical
tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
tabContentLayout.Padding = UDim.new(0, 8)
tabContentLayout.Parent = tabContainer

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

-- Toggle main menu with RightShift
local isOpen = true
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            TweenService:Create(betaTag, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = betaTag.Rotation + 360}):Play()
        end
    end
end)

--==========================
-- Notification Container
--==========================
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, 260, 0, 500)
notifContainer.Position = UDim2.new(1, -270, 1, -510)
notifContainer.AnchorPoint = Vector2.new(0,0)
notifContainer.BackgroundTransparency = 1
notifContainer.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.FillDirection = Enum.FillDirection.Vertical
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifContainer

--==========================
-- Menu API
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

    -- Content frame
    tab.TabContent = Instance.new("Frame")
    tab.TabContent.Size = UDim2.new(1,0,1,0)
    tab.TabContent.BackgroundTransparency = 1
    tab.TabContent.Visible = false
    tab.TabContent.Parent = tabContainer

    -- Add UIListLayout for this tab content
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 8)
    layout.Parent = tab.TabContent

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

    -- Toggle, Slider, Input, Keybind APIs stay the same (copy your existing code here)...
    -- [KEEP YOUR TOGGLE, SLIDER, INPUT, KEYBIND FUNCTIONS AS-IS]

    -- Tab switching
    tab.TabButton.MouseButton1Click:Connect(function()
        for i,t in ipairs(MenuLib.Tabs) do
            t.TabContent.Visible = false
        end
        tab.TabContent.Visible = true
        MenuLib.ActiveTab = tab
        TweenService:Create(sliderIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,tab.TabButton.AbsolutePosition.X - tabButtonsFrame.AbsolutePosition.X,1,-4)}):Play()
    end)

    table.insert(MenuLib.Tabs, tab)
    return tab
end

-- Notification
function MenuLib:Notify(title, text)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 80)
    notif.BackgroundColor3 = Color3.fromRGB(35,35,35)
    notif.BorderSizePixel = 0
    notif.Parent = notifContainer
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,12)

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notif
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0,10,0,5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(240,240,240)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left

    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.Size = UDim2.new(1, -20, 0, 40)
    notifText.Position = UDim2.new(0,10,0,25)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(200,200,200)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14
    notifText.TextWrapped = true

    -- Tween for fade-in
    notif.Position = notif.Position + UDim2.new(0, 0, 0, 50)
    notif.Transparency = 1
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = notif.Position - UDim2.new(0, 0, 0, 50)}):Play()

    -- Auto destroy
    task.delay(5, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = notif.Position + UDim2.new(0, 0, 0, 50)}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

return MenuLib
