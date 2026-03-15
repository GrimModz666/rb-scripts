-- Frosted UI Demo for people to be able to use my lib have fun GIVE CREDITS NO SKIDDING NIG
--===========================

-- Wait for player
local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat task.wait() until player and player:FindFirstChild("PlayerGui")

--===========================
-- Load Frosted UI
--===========================

local Menu = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/GrimModz666/rb-scripts/refs/heads/main/frostedui.lua"
))()

--===========================
-- Set Custom Menu Title
--===========================

local customTitle = "My Custom Frosted UI"

if Menu and Menu.SetTitle then
	Menu:SetTitle(customTitle)
end

--===========================
-- Create Tabs
--===========================

local mainTab = Menu:CreateTab("Main")
local secondTab = Menu:CreateTab("Second Tab")
local thirdTab = Menu:CreateTab("Third Tab")

--===========================
-- Safe Notify Helper
--===========================

local function notify(title,msg)
	title = tostring(title)
	msg = tostring(msg)

	if Menu and Menu.Notify then
		Menu:Notify(title,msg)
	else
		warn(title.." : "..msg)
	end
end

--===========================
-- MAIN TAB
--===========================

mainTab:CreateButton("Click Me", function()
	notify("Button Pressed","You pressed the Click Me button!")
end)

mainTab:CreateToggle("Toggle Example", function(state)
	notify("Toggle State",state)
end)

mainTab:CreateSlider("Slider Example", 0, 100, function(value)
	notify("Slider Value",value)
end)

mainTab:CreateButton("Unload UI", function()

	local player = game:GetService("Players").LocalPlayer
	local gui = player:FindFirstChild("PlayerGui")

	if gui then
		local frosted = gui:FindFirstChild("FrostedUI")
		if frosted then
			frosted:Destroy()
		end
	end

end)

--===========================
-- SECOND TAB
--===========================

secondTab:CreateButton("Second Tab Button", function()
	notify("Second Tab","Button clicked!")
end)

secondTab:CreateToggle("Second Toggle", function(state)
	notify("Second Toggle State",state)
end)

secondTab:CreateSlider("Second Tab Slider", 0, 50, function(val)
	notify("Second Slider Value",val)
end)

--===========================
-- THIRD TAB
--===========================

thirdTab:CreateButton("Third Tab Button", function()
	notify("Third Tab","This is the third tab button!")
end)

thirdTab:CreateToggle("Third Toggle", function(state)
	notify("Third Toggle State",state)
end)

thirdTab:CreateSlider("Third Slider", 10, 100, function(val)
	notify("Third Slider Value",val)
end)

--===========================
-- WELCOME NOTIFICATIONS
--===========================

task.wait(0.5)

notify("Welcome","UI loaded successfully")
notify("Tip","Press RightShift to open or close the menu")

--===========================
-- ACTIVATE FIRST TAB
--===========================

task.defer(function()

	if mainTab.Frame then
		mainTab.Frame.Visible = true
	end

	if secondTab.Frame then
		secondTab.Frame.Visible = false
	end

	if thirdTab.Frame then
		thirdTab.Frame.Visible = false
	end

end)
