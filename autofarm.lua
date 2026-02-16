local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local smuggling = workspace:WaitForChild("Smuggling")
local items = smuggling:WaitForChild("Items")
local bag = items:WaitForChild("Fake Designer Bag")
local watch = items:WaitForChild("Fake Watch")


local SELL_POS = Vector3.new(3146.6, 2.8, -184.2)
local FINAL_POS = Vector3.new(-1849.2, 1.56, -10.07) 


local farmRunning = false
local farmThread = nil

local function fixCamera()
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = hrp
end

local function tpToModel(model)
    local part = model:FindFirstChildWhichIsA("BasePart", true)
    if part then
        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
        fixCamera()
        task.wait(1.5)
    end
end

local function triggerPromptIn(model)
    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        print("🔔 Triggering prompt in model...")
        prompt:InputHoldBegin()
        task.wait((prompt.HoldDuration or 0) + 0.6)
        prompt:InputHoldEnd()
        task.wait(0.7)
    end
end

local function tpToPos(pos)
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) 
    fixCamera()
    task.wait(2.5)
end


local function triggerPromptNear(pos, actionName, isLaundry)
    print("🔍 [" .. actionName .. "] Searching near " .. tostring(pos))
    local searchRadius = isLaundry and 35 or 25 
    local holdExtra = isLaundry and 2.5 or 1.2 
    
    for i = 1, 5 do 
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local part = obj.Parent
                if part and part:IsA("BasePart") then
                    local distance = (part.Position - pos).Magnitude
                    if distance < searchRadius then
                        print("✅ [" .. actionName .. "] ACTIVATING at " .. tostring(part.Position) .. " (dist: " .. math.floor(distance) .. ")")
                        print("⏱️ Hold duration: " .. (obj.HoldDuration or 1) .. " + extra " .. holdExtra)
                        
                        obj:InputHoldBegin()
                        task.wait((obj.HoldDuration or 1) + holdExtra)
                        obj:InputHoldEnd()
                        
                        print("🎯 [" .. actionName .. "] HOLD COMPLETE!")
                        task.wait(isLaundry and 3 or 1.8) 
                        return true
                    end
                end
            end
        end
        print("⏳ [" .. actionName .. "] Retry " .. i .. "/5 (radius: " .. searchRadius .. ")")
        task.wait(1.5)
    end
    print("⚠️ [" .. actionName .. "] FAILED after 5 attempts")
    return false
end

local function doFullCycle()
    print("🚀 === CYCLE START ===")
    
    
    for i = 1, 3 do
        print("👜 Bag #" .. i)
        tpToModel(bag)
        triggerPromptIn(bag)
    end
    
    
    for i = 1, 3 do
        print("⌚ Watch #" .. i)
        tpToModel(watch)
        triggerPromptIn(watch)
    end
    
    
    print("💰 === SELLING ===")
    tpToPos(SELL_POS)
    local sellSuccess = triggerPromptNear(SELL_POS, "SELL", false)
    
    if sellSuccess then
        print("🧺 === LAUNDRY DIRTY MONEY (OPTIMIZED) ===")
        tpToPos(FINAL_POS) 
        local laundrySuccess = triggerPromptNear(FINAL_POS, "LAUNDRY", true) 
        
        if laundrySuccess then
            print("💵✅ DIRTY MONEY CLEANED!")
            task.wait(2)
        else
            print("⚠️ Laundry failed - RETRYING in next cycle")
        end
    end
    
    print("⏳ Cycle done - 5s cooldown\n")
    task.wait(5)
end

local function startFarm()
    farmThread = task.spawn(function()
        while farmRunning do
            pcall(doFullCycle)
        end
    end)
end

local function stopFarm()
    farmRunning = false
    if farmThread then task.cancel(farmThread) farmThread = nil end
end


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SmugglingFarmPro"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0.01, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true

local BGFrame = Instance.new("Frame")
BGFrame.Parent = MainFrame
BGFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
BGFrame.BorderSizePixel = 0
BGFrame.Size = UDim2.new(1, 0, 1, 0)

local BGCorner = Instance.new("UICorner")
BGCorner.CornerRadius = UDim.new(0, 20)
BGCorner.Parent = BGFrame

local BGGradient = Instance.new("UIGradient")
BGGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,40)), ColorSequenceKeypoint.new(0.7, Color3.fromRGB(15,15,30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))}
BGGradient.Rotation = 135
BGGradient.Parent = BGFrame

local OuterGlow = Instance.new("UIStroke")
OuterGlow.Parent = BGFrame
OuterGlow.Color = Color3.fromRGB(0, 255, 150)
OuterGlow.Thickness = 3
OuterGlow.Transparency = 0.6

-- HEADER (unchanged)
local Header = Instance.new("Frame")
Header.Parent = BGFrame
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.Position = UDim2.new(0, 12, 0, 12)
Header.Size = UDim2.new(1, -24, 0, 50)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(100,255,200)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,220,130))}
HeaderGradient.Rotation = 90
HeaderGradient.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🚀 Frosteds AUTO FARM PRO v4.1"
TitleLabel.TextColor3 = Color3.fromRGB(15, 15, 25)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 16, 0, 0)


local StatusContainer = Instance.new("Frame")
StatusContainer.Parent = BGFrame
StatusContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
StatusContainer.Position = UDim2.new(0, 16, 0, 72)
StatusContainer.Size = UDim2.new(1, -32, 0, 40)

local StatusCorner2 = Instance.new("UICorner")
StatusCorner2.CornerRadius = UDim.new(0, 10)
StatusCorner2.Parent = StatusContainer

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Color = Color3.fromRGB(255, 100, 100)
StatusStroke.Thickness = 1.5
StatusStroke.Transparency = 0.4
StatusStroke.Parent = StatusContainer

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusContainer
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.Text = "Status: STOPPED"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 16


local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = BGFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleButton.Position = UDim2.new(0, 16, 0, 122)
ToggleButton.Size = UDim2.new(1, -32, 0, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "▶️ START FARMING"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20

local ToggleCorner2 = Instance.new("UICorner")
ToggleCorner2.CornerRadius = UDim.new(0, 14)
ToggleCorner2.Parent = ToggleButton

local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(80,220,80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50,180,50))}
ToggleGradient.Parent = ToggleButton

local ToggleStroke2 = Instance.new("UIStroke")
ToggleStroke2.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke2.Thickness = 2.5
ToggleStroke2.Transparency = 0.3
ToggleStroke2.Parent = ToggleButton


local UnloadButton = Instance.new("TextButton")
UnloadButton.Parent = BGFrame
UnloadButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
UnloadButton.Position = UDim2.new(0, 16, 0, 198)
UnloadButton.Size = UDim2.new(1, -32, 0, 50)
UnloadButton.Font = Enum.Font.GothamBold
UnloadButton.Text = "UNLOAD SCRIPT"
UnloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnloadButton.TextSize = 16

local UnloadCorner2 = Instance.new("UICorner")
UnloadCorner2.CornerRadius = UDim.new(0, 14)
UnloadCorner2.Parent = UnloadButton

local UnloadGradient = Instance.new("UIGradient")
UnloadGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(240,90,90)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200,60,60))}
UnloadGradient.Parent = UnloadButton

local UnloadStroke2 = Instance.new("UIStroke")
UnloadStroke2.Color = Color3.fromRGB(255, 255, 255)
UnloadStroke2.Thickness = 2
UnloadStroke2.Transparency = 0.3
UnloadStroke2.Parent = UnloadButton


local function createProHover(button, hoverSize, normalSize)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, tweenInfo, {Size = hoverSize}):Play()
        TweenService:Create(button:FindFirstChild("UIStroke"), tweenInfo, {Thickness = 3.5, Transparency = 0.1}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, tweenInfo, {Size = normalSize}):Play()
        TweenService:Create(button:FindFirstChild("UIStroke"), tweenInfo, {Thickness = 2.5, Transparency = 0.3}):Play()
    end)
end

createProHover(ToggleButton, UDim2.new(1, -28, 0, 66), UDim2.new(1, -32, 0, 60))
createProHover(UnloadButton, UDim2.new(1, -28, 0, 56), UDim2.new(1, -32, 0, 50))


ToggleButton.MouseButton1Click:Connect(function()
    if not farmRunning then
        farmRunning = true
        startFarm()
        ToggleButton.Text = "⏹️ STOP FARMING"
        ToggleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255,100,100)), ColorSequenceKeypoint.new(1, Color3.fromRGB(230,70,70))}
        StatusLabel.Text = "Status: FARMING ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        StatusStroke.Color = Color3.fromRGB(0, 255, 100)
        print("▶️ Auto FARM STARTED")
    else
        stopFarm()
        ToggleButton.Text = "▶️ START FARMING"
        ToggleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(80,220,80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50,180,50))}
        StatusLabel.Text = "Status: STOPPED"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusStroke.Color = Color3.fromRGB(255, 100, 100)
    end
end)

UnloadButton.MouseButton1Click:Connect(function()
    stopFarm()
    ScreenGui:Destroy()
end)

print("🎮 Frosteds AutoFARM v4.1 LOADED!")
