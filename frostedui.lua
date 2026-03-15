--// =========================
-- Frosted UI Library vBeta
-- FULL FIXED VERSION
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

function Menu:SetTitle(text)
	if Menu._title then
		Menu._title.Text = text
	end
end

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
Menu._title = title

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
-- RIGHTSHIFT TOGGLE
--=========================

local open = true

local function toggleMenu()

	open = not open

	if open then
		main.Visible = true
	else
		main.Visible = false
	end

end

UIS.InputBegan:Connect(function(input,gp)

	if gp then return end

	if input.KeyCode == Enum.KeyCode.RightShift then
		toggleMenu()
	end

end)

--=========================
-- NOTIFICATIONS
--=========================

local notifHolder = Instance.new("Frame")
notifHolder.Parent = gui
notifHolder.AnchorPoint = Vector2.new(1,1)
notifHolder.Position = UDim2.new(1,-20,1,-20)
notifHolder.Size = UDim2.new(0,300,0,200)
notifHolder.BackgroundTransparency = 1

local notifLayout = Instance.new("UIListLayout")
notifLayout.Parent = notifHolder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0,6)

function Menu:Notify(title,msg)

	local frame = Instance.new("Frame")
	frame.Parent = notifHolder
	frame.Size = UDim2.new(1,0,0,50)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner",frame)

	local text = Instance.new("TextLabel")
	text.Parent = frame
	text.Size = UDim2.new(1,-10,1,-10)
	text.Position = UDim2.new(0,5,0,5)
	text.BackgroundTransparency = 1
	text.Text = title.." - "..msg
	text.TextWrapped = true
	text.TextColor3 = Color3.new(1,1,1)
	text.Font = Enum.Font.Gotham
	text.TextSize = 14

	task.delay(4,function()
		frame:Destroy()
	end)

end

--=========================
-- TAB BAR
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

--=========================
-- TAB CONTAINER (SCROLL FIX)
--=========================

local container = Instance.new("ScrollingFrame")
container.Parent = main
container.Size = UDim2.new(1,-20,1,-120)
container.Position = UDim2.new(0,10,0,110)
container.CanvasSize = UDim2.new(0,0,5,0)
container.ScrollBarThickness = 5
container.BackgroundTransparency = 1

--=========================
-- CREATE TAB
--=========================

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
-- BUTTON
--=========================

	function tab:CreateButton(text,callback)

		local button = Instance.new("TextButton")
		button.Parent = frame
		button.Size = UDim2.new(1,0,0,36)
		button.BackgroundColor3 = Color3.fromRGB(35,35,35)
		button.Text = text
		button.TextColor3 = Color3.new(1,1,1)
		button.Font = Enum.Font.Gotham
		button.TextSize = 14
		Instance.new("UICorner",button)

		button.MouseButton1Click:Connect(callback)

	end

--=========================
-- TOGGLE
--=========================

	function tab:CreateToggle(text,callback)

		local button = Instance.new("TextButton")
		button.Parent = frame
		button.Size = UDim2.new(1,0,0,36)
		button.BackgroundColor3 = Color3.fromRGB(35,35,35)
		button.Text = text
		button.TextColor3 = Color3.new(1,1,1)
		button.Font = Enum.Font.Gotham
		button.TextSize = 14
		Instance.new("UICorner",button)

		local state=false

		button.MouseButton1Click:Connect(function()

			state=not state
			callback(state)

		end)

	end

--=========================
-- SLIDER
--=========================

	function tab:CreateSlider(text,min,max,callback)

		local holder = Instance.new("Frame")
		holder.Parent = frame
		holder.Size = UDim2.new(1,0,0,40)
		holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
		Instance.new("UICorner",holder)

		local label = Instance.new("TextLabel")
		label.Parent = holder
		label.Size = UDim2.new(1,0,0,20)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 14

		local bar = Instance.new("Frame")
		bar.Parent = holder
		bar.Size = UDim2.new(1,-10,0,6)
		bar.Position = UDim2.new(0,5,1,-12)
		bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
		Instance.new("UICorner",bar)

		local fill = Instance.new("Frame")
		fill.Parent = bar
		fill.Size = UDim2.new(0,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(90,140,255)
		Instance.new("UICorner",fill)

		bar.InputBegan:Connect(function(input)
			if input.UserInputType==Enum.UserInputType.MouseButton1 then
				local x=(input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
				fill.Size=UDim2.new(x,0,1,0)
				local val=math.floor(min+(max-min)*x)
				callback(val)
			end
		end)

	end

return tab
end

return Menu
