--// =========================
-- Frosted UI Library v3.2
-- Professional Loader Edition
-- =========================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--=========================
-- DOUBLE INJECTION FIX
--=========================

local existing = playerGui:FindFirstChild("FrostedUI")
if existing then
	existing:Destroy()
end

--=========================
-- GUI
--=========================

local gui = Instance.new("ScreenGui")
gui.Name = "FrostedUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--=========================
-- LOADER SCREEN
--=========================

local loader = Instance.new("Frame")
loader.Parent = gui
loader.Size = UDim2.fromScale(1,1)
loader.BackgroundColor3 = Color3.fromRGB(15,15,15)

local loadingText = Instance.new("TextLabel")
loadingText.Parent = loader
loadingText.Size = UDim2.new(1,0,0,40)
loadingText.Position = UDim2.new(.5,-150,.45,-20)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading Frosted UI..."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 28
loadingText.TextColor3 = Color3.new(1,1,1)

--=========================
-- SPINNER
--=========================

local spinner = Instance.new("Frame")
spinner.Parent = loader
spinner.Size = UDim2.new(0,40,0,40)
spinner.Position = UDim2.new(.5,-20,.45,40)
spinner.BackgroundColor3 = Color3.fromRGB(90,140,255)
spinner.BorderSizePixel = 0
Instance.new("UICorner",spinner).CornerRadius = UDim.new(1,0)

task.spawn(function()
	while loader.Parent do
		spinner.Rotation += 6
		task.wait()
	end
end)

--=========================
-- LOADING BAR
--=========================

local barBG = Instance.new("Frame")
barBG.Parent = loader
barBG.Size = UDim2.new(0,350,0,10)
barBG.Position = UDim2.new(.5,-175,.55,0)
barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBG.BorderSizePixel = 0
Instance.new("UICorner",barBG)

local barFill = Instance.new("Frame")
barFill.Parent = barBG
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(90,140,255)
barFill.BorderSizePixel = 0
Instance.new("UICorner",barFill)

TweenService:Create(
	barFill,
	TweenInfo.new(2,Enum.EasingStyle.Quad),
	{Size = UDim2.new(1,0,1,0)}
):Play()

task.wait(2)

--=========================
-- BUTTONS AFTER LOAD
--=========================

local discordButton = Instance.new("TextButton")
discordButton.Parent = loader
discordButton.Size = UDim2.new(0,180,0,40)
discordButton.Position = UDim2.new(.5,-200,.65,0)
discordButton.Text = "Join Discord"
discordButton.Font = Enum.Font.GothamBold
discordButton.TextSize = 16
discordButton.BackgroundColor3 = Color3.fromRGB(90,140,255)
discordButton.TextColor3 = Color3.new(1,1,1)
discordButton.BorderSizePixel = 0
Instance.new("UICorner",discordButton)

local continueButton = Instance.new("TextButton")
continueButton.Parent = loader
continueButton.Size = UDim2.new(0,180,0,40)
continueButton.Position = UDim2.new(.5,20,.65,0)
continueButton.Text = "Continue"
continueButton.Font = Enum.Font.GothamBold
continueButton.TextSize = 16
continueButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
continueButton.TextColor3 = Color3.new(1,1,1)
continueButton.BorderSizePixel = 0
Instance.new("UICorner",continueButton)

discordButton.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/yourserver")
end)

continueButton.MouseButton1Click:Connect(function()
	loader:Destroy()
end)

-- Wait until continue pressed
repeat task.wait() until not loader.Parent

--=========================
-- LIBRARY TABLE
--=========================

local MenuLib = {}
MenuLib.Tabs = {}
MenuLib.Open = true

--=========================
-- MAIN FRAME
--=========================

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.fromScale(.35,.55)
mainFrame.Position = UDim2.fromScale(.325,.25)
mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mainFrame.BorderSizePixel = 0

Instance.new("UICorner",mainFrame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(100,160,255)
stroke.Thickness = 1.5

--=========================
-- HEADER
--=========================

local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1,0,0,50)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1,-20,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

function MenuLib:SetTitle(text)
	title.Text = text
end

--=========================
-- BETA BADGE
--=========================

local betaTag = Instance.new("TextLabel")
betaTag.Parent = header
betaTag.Size = UDim2.new(0,70,0,24)
betaTag.Position = UDim2.new(1,-80,.5,-12)
betaTag.BackgroundColor3 = Color3.fromRGB(90,140,255)
betaTag.Text = "BETA"
betaTag.Font = Enum.Font.GothamBold
betaTag.TextSize = 12
betaTag.TextColor3 = Color3.new(1,1,1)
betaTag.BorderSizePixel = 0
Instance.new("UICorner",betaTag)

local function spinBeta()
	local tween = TweenService:Create(
		betaTag,
		TweenInfo.new(.35,Enum.EasingStyle.Quad),
		{Rotation = betaTag.Rotation + 360}
	)
	tween:Play()
end

--=========================
-- DRAGGING
--=========================

local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--=========================
-- RIGHT SHIFT TOGGLE
--=========================

local function toggleMenu()

	MenuLib.Open = not MenuLib.Open
	spinBeta()

	if MenuLib.Open then

		mainFrame.Visible = true
		mainFrame.Size = UDim2.fromScale(.35,.55)

	else

		local closeTween = TweenService:Create(
			mainFrame,
			TweenInfo.new(.2),
			{Size = UDim2.fromScale(.35,0)}
		)

		closeTween:Play()

		closeTween.Completed:Connect(function()
			mainFrame.Visible = false
		end)

	end
end

UIS.InputBegan:Connect(function(input,gp)

	if gp then return end

	if input.KeyCode == Enum.KeyCode.RightShift then
		toggleMenu()
	end

end)

--=========================
-- TAB SYSTEM
--=========================

local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Parent = mainFrame
tabButtonsFrame.Size = UDim2.new(1,-20,0,40)
tabButtonsFrame.Position = UDim2.new(0,10,0,50)
tabButtonsFrame.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabButtonsFrame
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,10)

local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1,-20,1,-100)
tabContainer.Position = UDim2.new(0,10,0,90)
tabContainer.BackgroundTransparency = 1

--=========================
-- CREATE TAB
--=========================

function MenuLib:CreateTab(name)

	local tab = {}

	local button = Instance.new("TextButton")
	button.Parent = tabButtonsFrame
	button.Size = UDim2.new(0,100,1,0)
	button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	button.Text = name
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextColor3 = Color3.fromRGB(240,240,240)
	button.BorderSizePixel = 0
	Instance.new("UICorner",button)

	local content = Instance.new("Frame")
	content.Parent = tabContainer
	content.Size = UDim2.new(1,0,1,0)
	content.BackgroundTransparency = 1
	content.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.Parent = content
	layout.Padding = UDim.new(0,8)

	local function activate()
		for _,t in pairs(MenuLib.Tabs) do
			t.Content.Visible = false
		end
		content.Visible = true
	end

	button.MouseButton1Click:Connect(activate)

	tab.Content = content
	table.insert(MenuLib.Tabs,tab)

	if #MenuLib.Tabs == 1 then
		activate()
	end

	return tab
end

return MenuLib
