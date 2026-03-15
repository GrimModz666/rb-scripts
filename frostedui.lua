--// =========================
-- Frosted UI Library v2
-- Stable / Responsive
-- =========================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local MenuLib = {}
MenuLib.Tabs = {}
MenuLib.ActiveTab = nil

--=========================
-- Screen GUI
--=========================

local gui = Instance.new("ScreenGui")
gui.Name = "FrostedUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--=========================
-- Main Frame
--=========================

local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.fromScale(0.35,0.55)
mainFrame.Position = UDim2.fromScale(0.325,0.25)
mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mainFrame.BorderSizePixel = 0

Instance.new("UICorner",mainFrame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(100,160,255)
stroke.Thickness = 1.5

--=========================
-- Header (Drag Area)
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
-- BETA TAG
--=========================

local betaTag = Instance.new("TextLabel")
betaTag.Parent = header
betaTag.Size = UDim2.new(0,70,0,24)
betaTag.Position = UDim2.new(1,-80,0.5,-12)
betaTag.BackgroundColor3 = Color3.fromRGB(90,140,255)
betaTag.Text = "BETA"
betaTag.Font = Enum.Font.GothamBold
betaTag.TextSize = 12
betaTag.TextColor3 = Color3.new(1,1,1)
betaTag.BorderSizePixel = 0
Instance.new("UICorner",betaTag).CornerRadius = UDim.new(0,8)

--=========================
-- TAB BUTTON BAR
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

--=========================
-- TAB CONTAINER
--=========================

local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1,-20,1,-100)
tabContainer.Position = UDim2.new(0,10,0,90)
tabContainer.BackgroundTransparency = 1

--=========================
-- DRAG SYSTEM (HEADER ONLY)
--=========================

local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

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

		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

	end

end)

--=========================
-- TAB CREATION
--=========================

function MenuLib:CreateTab(name)

	local tab = {}
	tab.Name = name

	-- Tab Button

	local button = Instance.new("TextButton")
	button.Parent = tabButtonsFrame
	button.Size = UDim2.new(0,100,1,0)
	button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	button.Text = name
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextColor3 = Color3.fromRGB(240,240,240)
	button.BorderSizePixel = 0
	Instance.new("UICorner",button).CornerRadius = UDim.new(0,6)

	-- Tab Content

	local scroll = Instance.new("ScrollingFrame")
	scroll.Parent = tabContainer
	scroll.Size = UDim2.new(1,0,1,0)
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.ScrollBarThickness = 4
	scroll.BackgroundTransparency = 1
	scroll.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.Parent = scroll
	layout.Padding = UDim.new(0,8)

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

		scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)

	end)

	local function activate()

		for _,t in pairs(MenuLib.Tabs) do
			t.Content.Visible = false
		end

		scroll.Visible = true
		MenuLib.ActiveTab = tab

	end

	button.MouseButton1Click:Connect(activate)

	tab.Button = button
	tab.Content = scroll

	table.insert(MenuLib.Tabs,tab)

	if #MenuLib.Tabs == 1 then
		activate()
	end

	--=========================
	-- BUTTON
	--=========================

	function tab:CreateButton(text,callback)

		local btn = Instance.new("TextButton")
		btn.Parent = scroll
		btn.Size = UDim2.new(1,0,0,40)
		btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		btn.Text = text
		btn.Font = Enum.Font.GothamSemibold
		btn.TextSize = 16
		btn.TextColor3 = Color3.fromRGB(240,240,240)
		btn.BorderSizePixel = 0
		Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

		btn.MouseButton1Click:Connect(callback)

	end

	--=========================
	-- TOGGLE
	--=========================

	function tab:CreateToggle(text,callback)

		local frame = Instance.new("Frame")
		frame.Parent = scroll
		frame.Size = UDim2.new(1,0,0,40)
		frame.BackgroundTransparency = 1

		local label = Instance.new("TextLabel")
		label.Parent = frame
		label.Size = UDim2.new(0.7,0,1,0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.Font = Enum.Font.Gotham
		label.TextSize = 16
		label.TextColor3 = Color3.fromRGB(240,240,240)
		label.TextXAlignment = Enum.TextXAlignment.Left

		local toggle = Instance.new("TextButton")
		toggle.Parent = frame
		toggle.Size = UDim2.new(0,40,0,20)
		toggle.Position = UDim2.new(1,-50,0.5,-10)
		toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
		toggle.Text = ""
		toggle.BorderSizePixel = 0
		Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,6)

		local state = false

		toggle.MouseButton1Click:Connect(function()

			state = not state

			toggle.BackgroundColor3 =
				state and Color3.fromRGB(90,140,255)
				or Color3.fromRGB(60,60,60)

			callback(state)

		end)

	end

	--=========================
	-- SLIDER (NO DRAG BUG)
	--=========================

	function tab:CreateSlider(text,min,max,callback)

		local frame = Instance.new("Frame")
		frame.Parent = scroll
		frame.Size = UDim2.new(1,0,0,50)
		frame.BackgroundTransparency = 1

		local label = Instance.new("TextLabel")
		label.Parent = frame
		label.Size = UDim2.new(1,0,0,20)
		label.BackgroundTransparency = 1
		label.Text = text.." ["..min.."]"
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextColor3 = Color3.fromRGB(240,240,240)
		label.TextXAlignment = Enum.TextXAlignment.Left

		local bar = Instance.new("Frame")
		bar.Parent = frame
		bar.Size = UDim2.new(1,0,0,8)
		bar.Position = UDim2.new(0,0,0,30)
		bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
		bar.BorderSizePixel = 0
		Instance.new("UICorner",bar)

		local fill = Instance.new("Frame")
		fill.Parent = bar
		fill.Size = UDim2.new(0,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(90,140,255)
		fill.BorderSizePixel = 0
		Instance.new("UICorner",fill)

		local draggingSlider = false

		bar.InputBegan:Connect(function(input)

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				draggingSlider = true
			end

		end)

		bar.InputEnded:Connect(function(input)

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				draggingSlider = false
			end

		end)

		UIS.InputChanged:Connect(function(input)

			if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then

				local percent =
					math.clamp(
						(input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
						0,
						1
					)

				fill.Size = UDim2.new(percent,0,1,0)

				local value = math.floor(min + (max-min)*percent)

				label.Text = text.." ["..value.."]"

				callback(value)

			end

		end)

	end

	return tab

end

return MenuLib
