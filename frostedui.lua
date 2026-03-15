--// =========================
-- Frosted UI Library vBeta
-- Fully Fixed & Updated
-- =========================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
-- LOADING SCREEN
--=========================

local loadingScreen = Instance.new("Frame")
loadingScreen.Parent = gui
loadingScreen.Size = UDim2.fromScale(1,1)
loadingScreen.BackgroundColor3 = Color3.fromRGB(15,15,15)

local loadLabel = Instance.new("TextLabel")
loadLabel.Parent = loadingScreen
loadLabel.Size = UDim2.fromScale(1,0.1)
loadLabel.Position = UDim2.fromScale(0,0.4)
loadLabel.Text = "Loading UI..."
loadLabel.Font = Enum.Font.GothamBold
loadLabel.TextSize = 36
loadLabel.TextColor3 = Color3.fromRGB(255,255,255)
loadLabel.BackgroundTransparency = 1

--=========================
-- LOADING PROGRESS BAR
--=========================

local progressBG = Instance.new("Frame")
progressBG.Parent = loadingScreen
progressBG.Size = UDim2.new(0,300,0,8)
progressBG.Position = UDim2.new(0.5,-150,0.48,0)
progressBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",progressBG)

local progressBar = Instance.new("Frame")
progressBar.Parent = progressBG
progressBar.Size = UDim2.new(0,0,1,0)
progressBar.BackgroundColor3 = Color3.fromRGB(90,140,255)
Instance.new("UICorner",progressBar)

task.spawn(function()
	local tween = TweenService:Create(
		progressBar,
		TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
		{Size = UDim2.new(1,0,1,0)}
	)
	tween:Play()
end)

local discordBtn = Instance.new("TextButton")
discordBtn.Parent = loadingScreen
discordBtn.Size = UDim2.new(0,200,0,50)
discordBtn.Position = UDim2.new(0.5,-100,0.55,0)
discordBtn.Text = "Join Discord"
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 18
discordBtn.TextColor3 = Color3.new(1,1,1)
discordBtn.BackgroundColor3 = Color3.fromRGB(90,140,255)
Instance.new("UICorner",discordBtn)

local continueBtn = Instance.new("TextButton")
continueBtn.Parent = loadingScreen
continueBtn.Size = UDim2.new(0,200,0,50)
continueBtn.Position = UDim2.new(0.5,-100,0.65,0)
continueBtn.Text = "Continue"
continueBtn.Font = Enum.Font.GothamBold
continueBtn.TextSize = 18
continueBtn.TextColor3 = Color3.new(1,1,1)
continueBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner",continueBtn)

discordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/YuZswmnmAw")
end)

local loaded = Instance.new("BindableEvent")

continueBtn.MouseButton1Click:Connect(function()
	loaded:Fire()
end)

loaded.Event:Wait()
loadingScreen:Destroy()

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

function Menu:SetTitle(txt)
	title.Text = txt
end

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
	TweenService:Create(beta,TweenInfo.new(.4,Enum.EasingStyle.Quart),{Rotation = beta.Rotation + 360}):Play()
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
-- OPEN/CLOSE
--=========================

local open = true
local function toggleMenu()
	open = not open
	spinBeta()
	if open then
		main.Visible = true
		main.Size = UDim2.fromScale(.35,0)
		TweenService:Create(main,TweenInfo.new(.35,Enum.EasingStyle.Quint),{Size=UDim2.fromScale(.35,.55)}):Play()
	else
		local close = TweenService:Create(main,TweenInfo.new(.25,Enum.EasingStyle.Quad),{Size=UDim2.fromScale(.35,0)})
		close:Play()
		close.Completed:Connect(function() main.Visible=false end)
	end
end

UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode==Enum.KeyCode.RightShift then
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
	label.Font = Enum.Font.Gotham
	label.TextWrapped = true
	label.TextSize = 14

	local bar = Instance.new("Frame")
	bar.Parent = n
	bar.Position = UDim2.new(0,0,1,-4)
	bar.Size = UDim2.new(1,0,0,4)
	bar.BackgroundColor3 = Color3.fromRGB(90,140,255)

	TweenService:Create(bar,TweenInfo.new(4),{Size=UDim2.new(0,0,0,4)}):Play()

	n.Position = UDim2.new(1,300,0,0)
	TweenService:Create(n,TweenInfo.new(.35,Enum.EasingStyle.Quart),{Position=UDim2.new(0,0,0,0)}):Play()

	task.delay(4,function() n:Destroy() end)
end

--=========================
-- TAB SCROLLER
--=========================

local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Parent = main
tabScroll.Size = UDim2.new(1,-20,0,45)
tabScroll.Position = UDim2.new(0,10,0,60)
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollBarThickness = 2
tabScroll.CanvasSize = UDim2.new(0,0,0,0)
tabScroll.ScrollingDirection = Enum.ScrollingDirection.X

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabScroll
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,10)

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tabScroll.CanvasSize = UDim2.new(0,tabLayout.AbsoluteContentSize.X+10,0,0)
end)

local container = Instance.new("Frame")
container.Parent = main
container.Size = UDim2.new(1,-20,1,-120)
container.Position = UDim2.new(0,10,0,110)
container.BackgroundTransparency = 1

--=========================
-- CREATE TAB FUNCTION
--=========================

function Menu:CreateTab(name)
	local tab = {}

	local button = Instance.new("TextButton")
	button.Parent = tabScroll
	button.Size = UDim2.new(0,120,1,0)
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(40,40,40)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	Instance.new("UICorner",button)

	local frame = Instance.new("ScrollingFrame")
	frame.Parent = container
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.ScrollBarThickness = 4
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local layout = Instance.new("UIListLayout")
	layout.Parent = frame
	layout.Padding = UDim.new(0,8)

	button.MouseButton1Click:Connect(function()
		for _,t in pairs(Menu.Tabs) do
			t.Frame.Visible=false
		end
		frame.Visible=true
	end)

	tab.Frame = frame
	table.insert(Menu.Tabs,tab)
	if #Menu.Tabs==1 then frame.Visible=true end

	-- BUTTON
	function tab:CreateButton(text,callback)
		local b = Instance.new("TextButton")
		b.Parent = frame
		b.Size = UDim2.new(1,0,0,36)
		b.Text = text
		b.BackgroundColor3 = Color3.fromRGB(35,35,35)
		b.TextColor3 = Color3.new(1,1,1)
		b.Font = Enum.Font.Gotham
		b.TextSize = 14
		Instance.new("UICorner",b)
		b.MouseButton1Click:Connect(callback)
	end

	-- TOGGLE
	function tab:CreateToggle(text,callback)

		local holder = Instance.new("TextButton")
		holder.Parent = frame
		holder.Size = UDim2.new(1,0,0,36)
		holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
		holder.Text = ""
		Instance.new("UICorner",holder)

		local label = Instance.new("TextLabel")
		label.Parent = holder
		label.Size = UDim2.new(1,-50,1,0)
		label.Position = UDim2.new(0,10,0,0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.Gotham
		label.TextColor3 = Color3.new(1,1,1)
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left

		local toggleBtn = Instance.new("Frame")
		toggleBtn.Parent = holder
		toggleBtn.Size = UDim2.new(0,24,0,24)
		toggleBtn.Position = UDim2.new(1,-34,0,6)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner",toggleBtn)

		local active=false
		local function updateToggle()
			toggleBtn.BackgroundColor3=active and Color3.fromRGB(90,140,255) or Color3.fromRGB(60,60,60)
		end

		holder.MouseButton1Click:Connect(function()
			active = not active
			updateToggle()
			callback(active)
		end)

		updateToggle()
	end

	-- SLIDER
	function tab:CreateSlider(text,min,max,callback)

		local holder = Instance.new("Frame")
		holder.Parent = frame
		holder.Size = UDim2.new(1,0,0,50)
		holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
		Instance.new("UICorner",holder)

		local label = Instance.new("TextLabel")
		label.Parent = holder
		label.Size = UDim2.new(1,-20,0,20)
		label.Position = UDim2.new(0,10,0,2)
		label.BackgroundTransparency = 1
		label.Text = text.." : "..min
		label.Font = Enum.Font.Gotham
		label.TextColor3 = Color3.new(1,1,1)
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left

		local bar = Instance.new("Frame")
		bar.Parent = holder
		bar.Position = UDim2.new(0,10,1,-18)
		bar.Size = UDim2.new(1,-20,0,6)
		bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner",bar)

		local fill = Instance.new("Frame")
		fill.Parent = bar
		fill.Size = UDim2.new(0,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(90,140,255)
		Instance.new("UICorner",fill)

		local dragging=false

		local function update(x)
			local pos = math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			fill.Size = UDim2.new(pos,0,1,0)

			local val = math.floor(min + (max-min)*pos)
			label.Text = text.." : "..val

			if callback then
				callback(val)
			end
		end

		bar.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 then
				dragging=true
				update(i.Position.X)
			end
		end)

		bar.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 then
				dragging=false
			end
		end)

		UIS.InputChanged:Connect(function(i)
			if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
				update(i.Position.X)
			end
		end)

	end

	-- DROPDOWN
	function tab:CreateDropdown(text,options,callback)

		local holder = Instance.new("Frame")
		holder.Parent = frame
		holder.Size = UDim2.new(1,0,0,36)
		holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
		Instance.new("UICorner",holder)

		local button = Instance.new("TextButton")
		button.Parent = holder
		button.Size = UDim2.new(1,-10,1,0)
		button.Position = UDim2.new(0,5,0,0)
		button.Text = text
		button.BackgroundTransparency = 1
		button.TextColor3 = Color3.new(1,1,1)
		button.Font = Enum.Font.Gotham
		button.TextSize = 14

		local list = Instance.new("Frame")
		list.Parent = holder
		list.Position = UDim2.new(0,0,1,0)
		list.Size = UDim2.new(1,0,0,0)
		list.BackgroundColor3 = Color3.fromRGB(30,30,30)
		list.ClipsDescendants=true
		Instance.new("UICorner",list)

		local layout = Instance.new("UIListLayout")
		layout.Parent = list

		local open=false

		for _,opt in pairs(options) do
			local o = Instance.new("TextButton")
			o.Parent = list
			o.Size = UDim2.new(1,0,0,30)
			o.Text = opt
			o.BackgroundColor3 = Color3.fromRGB(40,40,40)
			o.TextColor3 = Color3.new(1,1,1)
			o.Font = Enum.Font.Gotham
			o.TextSize = 14

			o.MouseButton1Click:Connect(function()
				button.Text = text..": "..opt
				callback(opt)
				open=false
				list.Size = UDim2.new(1,0,0,0)
			end)
		end

		button.MouseButton1Click:Connect(function()
			open = not open
			if open then
				list.Size = UDim2.new(1,0,0,#options*30)
			else
				list.Size = UDim2.new(1,0,0,0)
			end
		end)

	end

	return tab
end

return Menu
