--// =========================
-- Frosted UI Library vBeta
-- Improved Version
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
gui.Parent = playerGui
gui.ResetOnSpawn = false

--=========================
-- LIBRARY
--=========================

local Menu = {}
Menu.Tabs = {}

--=========================
-- MAIN WINDOW
--=========================

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.fromScale(.35,.55)
main.Position = UDim2.fromScale(.33,.25)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.ClipsDescendants = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(90,140,255)
stroke.Thickness = 2

--=========================
-- HEADER
--=========================

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1,0,0,50)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1,-20,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Frosted UI vBeta"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

--=========================
-- BETA BADGE
--=========================

local beta = Instance.new("TextLabel")
beta.Parent = header
beta.Size = UDim2.new(0,60,0,24)
beta.Position = UDim2.new(1,-70,.5,-12)
beta.BackgroundColor3 = Color3.fromRGB(90,140,255)
beta.Text = "BETA"
beta.TextColor3 = Color3.new(1,1,1)
beta.Font = Enum.Font.GothamBold
beta.TextSize = 12

Instance.new("UICorner",beta)

local function spinBeta()

	TweenService:Create(
		beta,
		TweenInfo.new(.4,Enum.EasingStyle.Quart),
		{Rotation = beta.Rotation + 360}
	):Play()

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
		startPos = main.Position
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

		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

	end

end)

--=========================
-- OPEN CLOSE ANIMATION
--=========================

local open = true

local function toggleMenu()

	open = not open
	spinBeta()

	if open then

		main.Visible = true
		main.Size = UDim2.fromScale(.35,0)

		TweenService:Create(
			main,
			TweenInfo.new(.35,Enum.EasingStyle.Quint),
			{Size = UDim2.fromScale(.35,.55)}
		):Play()

	else

		local close = TweenService:Create(
			main,
			TweenInfo.new(.25,Enum.EasingStyle.Quad),
			{Size = UDim2.fromScale(.35,0)}
		)

		close:Play()

		close.Completed:Connect(function()
			main.Visible = false
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
-- NOTIFICATION SYSTEM
--=========================

local notifHolder = Instance.new("Frame")
notifHolder.Parent = gui
notifHolder.AnchorPoint = Vector2.new(1,1)
notifHolder.Position = UDim2.new(1,-20,1,-20)
notifHolder.Size = UDim2.new(0,300,0,200)
notifHolder.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout")
layout.Parent = notifHolder
layout.Padding = UDim.new(0,8)
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

function Menu:Notify(title,msg)

	local n = Instance.new("Frame")
	n.Parent = notifHolder
	n.Size = UDim2.new(1,0,0,60)
	n.BackgroundColor3 = Color3.fromRGB(25,25,25)

	Instance.new("UICorner",n)

	local label = Instance.new("TextLabel")
	label.Parent = n
	label.Size = UDim2.new(1,-20,1,-10)
	label.Position = UDim2.new(0,10,0,5)
	label.BackgroundTransparency = 1
	label.Text = title.." - "..msg
	label.TextColor3 = Color3.new(1,1,1)
	label.TextWrapped = true
	label.Font = Enum.Font.Gotham
	label.TextSize = 14

	local bar = Instance.new("Frame")
	bar.Parent = n
	bar.Position = UDim2.new(0,0,1,-4)
	bar.Size = UDim2.new(1,0,0,4)
	bar.BackgroundColor3 = Color3.fromRGB(90,140,255)

	TweenService:Create(
		bar,
		TweenInfo.new(4),
		{Size = UDim2.new(0,0,0,4)}
	):Play()

	n.Position = UDim2.new(1,300,0,0)

	TweenService:Create(
		n,
		TweenInfo.new(.35,Enum.EasingStyle.Quart),
		{Position = UDim2.new(0,0,0,0)}
	):Play()

	task.delay(4,function()
		n:Destroy()
	end)

end

--=========================
-- TAB SYSTEM
--=========================

local tabBar = Instance.new("Frame")
tabBar.Parent = main
tabBar.Size = UDim2.new(1,-20,0,45)
tabBar.Position = UDim2.new(0,10,0,60)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabBar
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,10)

local container = Instance.new("Frame")
container.Parent = main
container.Size = UDim2.new(1,-20,1,-120)
container.Position = UDim2.new(0,10,0,110)
container.BackgroundTransparency = 1

function Menu:CreateTab(name)

	local tab = {}

	local button = Instance.new("TextButton")
	button.Parent = tabBar
	button.Size = UDim2.new(0,120,1,0)
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(40,40,40)
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

--=========================
-- TOGGLE SWITCH
--=========================

	function tab:CreateToggle(text,callback)

		local holder = Instance.new("Frame")
		holder.Parent = frame
		holder.Size = UDim2.new(1,0,0,36)
		holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
		Instance.new("UICorner",holder)

		local label = Instance.new("TextLabel")
		label.Parent = holder
		label.Size = UDim2.new(.7,0,1,0)
		label.Position = UDim2.new(0,10,0,0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left

		local toggle = Instance.new("Frame")
		toggle.Parent = holder
		toggle.Size = UDim2.new(0,40,0,18)
		toggle.Position = UDim2.new(1,-50,.5,-9)
		toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner",toggle)

		local circle = Instance.new("Frame")
		circle.Parent = toggle
		circle.Size = UDim2.new(0,16,0,16)
		circle.Position = UDim2.new(0,1,0,1)
		circle.BackgroundColor3 = Color3.new(1,1,1)
		Instance.new("UICorner",circle)

		local state = false

		holder.InputBegan:Connect(function(input)

			if input.UserInputType == Enum.UserInputType.MouseButton1 then

				state = not state

				if state then

					TweenService:Create(circle,TweenInfo.new(.2),{
						Position = UDim2.new(1,-17,0,1)
					}):Play()

					toggle.BackgroundColor3 = Color3.fromRGB(90,140,255)

				else

					TweenService:Create(circle,TweenInfo.new(.2),{
						Position = UDim2.new(0,1,0,1)
					}):Play()

					toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)

				end

				callback(state)

			end

		end)

	end

return tab
end

return Menu
