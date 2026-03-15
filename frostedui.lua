--// =========================
-- Frosted UI Library v4
-- Fully Fixed + Animated
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
-- GUI ROOT
--=========================

local gui = Instance.new("ScreenGui")
gui.Name = "FrostedUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--=========================
-- LOADING SCREEN
--=========================

local loader = Instance.new("Frame")
loader.Parent = gui
loader.Size = UDim2.fromScale(1,1)
loader.BackgroundColor3 = Color3.fromRGB(15,15,15)

local title = Instance.new("TextLabel")
title.Parent = loader
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,.35,0)
title.BackgroundTransparency = 1
title.Text = "Loading Frosted UI..."
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.new(1,1,1)

-- LOADING BAR

local barBG = Instance.new("Frame")
barBG.Parent = loader
barBG.Size = UDim2.new(0,350,0,10)
barBG.Position = UDim2.new(.5,-175,.45,0)
barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",barBG)

local barFill = Instance.new("Frame")
barFill.Parent = barBG
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(90,140,255)
Instance.new("UICorner",barFill)

TweenService:Create(
	barFill,
	TweenInfo.new(2),
	{Size = UDim2.new(1,0,1,0)}
):Play()

task.wait(2)

-- BUTTONS

local join = Instance.new("TextButton")
join.Parent = loader
join.Size = UDim2.new(0,180,0,40)
join.Position = UDim2.new(.5,-200,.55,0)
join.Text = "Join Discord"
join.Font = Enum.Font.GothamBold
join.TextSize = 16
join.BackgroundColor3 = Color3.fromRGB(90,140,255)
join.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",join)

join.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/yourserver")
end)

local continue = Instance.new("TextButton")
continue.Parent = loader
continue.Size = UDim2.new(0,180,0,40)
continue.Position = UDim2.new(.5,20,.55,0)
continue.Text = "Continue"
continue.Font = Enum.Font.GothamBold
continue.TextSize = 16
continue.BackgroundColor3 = Color3.fromRGB(50,50,50)
continue.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",continue)

continue.MouseButton1Click:Connect(function()
	loader:Destroy()
end)

repeat task.wait() until not loader.Parent

--=========================
-- LIBRARY TABLE
--=========================

local Menu = {}
Menu.Tabs = {}
Menu.Open = true

--=========================
-- MAIN FRAME
--=========================

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromScale(.35,.55)
main.Position = UDim2.fromScale(.325,.25)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
main.BorderSizePixel = 0
Instance.new("UICorner",main).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(100,160,255)

--=========================
-- HEADER
--=========================

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1,0,0,50)
header.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = header
titleLabel.Size = UDim2.new(1,-20,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Frosted UI"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

function Menu:SetTitle(t)
	titleLabel.Text = t
end

--=========================
-- BETA BADGE
--=========================

local beta = Instance.new("TextLabel")
beta.Parent = header
beta.Size = UDim2.new(0,70,0,24)
beta.Position = UDim2.new(1,-80,.5,-12)
beta.BackgroundColor3 = Color3.fromRGB(90,140,255)
beta.Text = "BETA"
beta.Font = Enum.Font.GothamBold
beta.TextSize = 12
beta.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",beta)

local function spin()
	TweenService:Create(
		beta,
		TweenInfo.new(.35),
		{Rotation = beta.Rotation + 360}
	):Play()
end

--=========================
-- NOTIFICATION SYSTEM
--=========================

local notifHolder = Instance.new("Frame")
notifHolder.Parent = gui
notifHolder.AnchorPoint = Vector2.new(1,1)
notifHolder.Position = UDim2.new(1,-20,1,-20)
notifHolder.Size = UDim2.new(0,250,0,200)
notifHolder.BackgroundTransparency = 1

local list = Instance.new("UIListLayout")
list.Parent = notifHolder
list.VerticalAlignment = Enum.VerticalAlignment.Bottom
list.Padding = UDim.new(0,6)

function Menu:Notify(title,msg)

	local n = Instance.new("Frame")
	n.Parent = notifHolder
	n.Size = UDim2.new(1,0,0,50)
	n.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner",n)

	local text = Instance.new("TextLabel")
	text.Parent = n
	text.Size = UDim2.new(1,-10,1,0)
	text.Position = UDim2.new(0,10,0,0)
	text.BackgroundTransparency = 1
	text.Text = title.." - "..msg
	text.TextColor3 = Color3.new(1,1,1)
	text.Font = Enum.Font.Gotham
	text.TextSize = 14
	text.TextWrapped = true

	task.delay(4,function()
		n:Destroy()
	end)

end

--=========================
-- OPEN/CLOSE MENU
--=========================

local function toggle()

	Menu.Open = not Menu.Open
	spin()

	if Menu.Open then

		main.Visible = true
		main.Size = UDim2.fromScale(.35,0)

		TweenService:Create(
			main,
			TweenInfo.new(.25,Enum.EasingStyle.Back),
			{Size = UDim2.fromScale(.35,.55)}
		):Play()

	else

		local t = TweenService:Create(
			main,
			TweenInfo.new(.2),
			{Size = UDim2.fromScale(.35,0)}
		)

		t:Play()

		t.Completed:Connect(function()
			main.Visible = false
		end)

	end

end

UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggle()
	end
end)

--=========================
-- TAB SYSTEM
--=========================

local tabButtons = Instance.new("Frame")
tabButtons.Parent = main
tabButtons.Size = UDim2.new(1,-20,0,40)
tabButtons.Position = UDim2.new(0,10,0,50)
tabButtons.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabButtons
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,10)

local container = Instance.new("Frame")
container.Parent = main
container.Size = UDim2.new(1,-20,1,-100)
container.Position = UDim2.new(0,10,0,90)
container.BackgroundTransparency = 1

function Menu:CreateTab(name)

	local tab = {}

	local button = Instance.new("TextButton")
	button.Parent = tabButtons
	button.Size = UDim2.new(0,100,1,0)
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	Instance.new("UICorner",button)

	local frame = Instance.new("Frame")
	frame.Parent = container
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1
	frame.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.Parent = frame
	layout.Padding = UDim.new(0,8)

	button.MouseButton1Click:Connect(function()

		for _,t in pairs(Menu.Tabs) do
			t.Frame.Visible = false
		end

		frame.Visible = true

	end)

	tab.Frame = frame
	table.insert(Menu.Tabs,tab)

	if #Menu.Tabs == 1 then
		frame.Visible = true
	end

	return tab

end

return Menu
