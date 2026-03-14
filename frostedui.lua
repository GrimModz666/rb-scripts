-- ===========================
-- Frosted UI Library (Updated)
-- ===========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local MenuLib = {}
MenuLib.Tabs = {}
MenuLib.ActiveTab = nil
MenuLib.Notifications = {}

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
local contentLayout = Instance.new("UIListLayout", tabContainer)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0,8) -- spacing for buttons/toggles/sliders

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
-- Notification container
--==========================
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, 300, 0, 0)
notifContainer.Position = UDim2.new(1, -310, 1, -10)
notifContainer.BackgroundTransparency = 1
notifContainer.AnchorPoint = Vector2.new(0,1)
notifContainer.Parent = gui

-- Notification function
function MenuLib:Notify(title, text)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.BackgroundColor3 = Color3.fromRGB(35,35,35)
    notif.BorderSizePixel = 0
    notif.Parent = notifContainer
    notif.Position = UDim2.new(0,0,0,-(#notifContainer:GetChildren()*90))
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,10)

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notif
    notifTitle.Size = UDim2.new(1,-20,0,25)
    notifTitle.Position = UDim2.new(0,10,0,5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(240,240,240)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left

    local notifText = Instance.new("TextLabel")
    notifText.Parent = notif
    notifText.Size = UDim2.new(1,-20,0,45)
    notifText.Position = UDim2.new(0,10,0,30)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(200,200,200)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14
    notifText.TextWrapped = true
    notifText.TextXAlignment = Enum.TextXAlignment.Left

    -- Slide-in animation
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0,0,0,-(#notifContainer:GetChildren()*90))}):Play()

    -- Auto-destroy
    task.delay(5, function()
        notif:Destroy()
    end)
end

return MenuLib
