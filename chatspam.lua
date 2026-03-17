-- Frosted UI Demo
-- GIVE CREDITS NO SKIDDING
-- CHAT SPAMMER MADE IN MY UI DEMO
--===========================


local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat task.wait() until player and player:FindFirstChild("PlayerGui")

local success, Menu = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/GrimModz666/rb-scripts/refs/heads/main/frostedui.lua"))()
end)

if not success or not Menu then
	warn("Failed to load Frosted UI")
	return
end


local customTitle = "FrostedUI ChatSpam"
if Menu.SetTitle then
	Menu:SetTitle(customTitle)
end



local mainTab = Menu:CreateTab("Main")
local secondTab = Menu:CreateTab("Second Tab")
local thirdTab = Menu:CreateTab("Third Tab")


local function notify(title,msg)
	title = tostring(title)
	msg = tostring(msg)
	if Menu.Notify then
		Menu:Notify(title,msg)
	else
		warn(title.." : "..msg)
	end
end



local chatEnabled = false

local messages = {
	{ text = "come cop ultrainject", delay = 5 },
	{ text = "rn", delay = 6 },
	{ text = "1", delay = 7 },
	{ text = "2", delay = 8 },
}



task.spawn(function()
	local TextChatService = game:GetService("TextChatService")
	local channel = TextChatService.TextChannels:WaitForChild("RBXGeneral",10)

	while true do
		task.wait()
		if chatEnabled and channel then
			for _, msg in ipairs(messages) do
				if not chatEnabled then break end
				channel:SendAsync(msg.text)
				task.wait(msg.delay)
			end
		end
	end
end)




mainTab:CreateToggle("Chat Sender", function(state)
	chatEnabled = state
	notify("Chat", state and "Chat sender enabled" or "Chat sender disabled")
end)

for i = 1, 4 do
	mainTab:CreateTextbox("Message "..i, function(text)
		if messages[i] then messages[i].text = text end
	end)
end


for i = 1, 4 do
	mainTab:CreateSlider("Delay "..i,0,10,function(val)
		if messages[i] then messages[i].delay = val end
	end)
end


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
	local gui = player:FindFirstChild("PlayerGui")
	if gui then
		local frosted = gui:FindFirstChild("FrostedUI")
		if frosted then frosted:Destroy() end
	end
end)


secondTab:CreateButton("Second Tab Button", function()
	notify("Second Tab","Button clicked!")
end)

secondTab:CreateToggle("Second Toggle", function(state)
	notify("Second Toggle State",state)
end)

secondTab:CreateSlider("Second Tab Slider", 0, 50, function(val)
	notify("Second Slider Value",val)
end)



thirdTab:CreateButton("Third Tab Button", function()
	notify("Third Tab","This is the third tab button!")
end)

thirdTab:CreateToggle("Third Toggle", function(state)
	notify("Third Toggle State",state)
end)

thirdTab:CreateSlider("Third Slider", 10, 100, function(val)
	notify("Third Slider Value",val)
end)



task.wait(0.5)
notify("Welcome","UI loaded successfully")
notify("Tip","Press RightShift to open or close the menu")



task.defer(function()
	if mainTab.Frame then mainTab.Frame.Visible = true end
	if secondTab.Frame then secondTab.Frame.Visible = false end
	if thirdTab.Frame then thirdTab.Frame.Visible = false end
end)
