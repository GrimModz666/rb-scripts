local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
-- i made it for fun lol its basically like ur a npc you can go fuck off and the script will take care of the rest this is v1
humanoid.WalkSpeed = 16

local function getRandomPosition()
    local angle = math.random() * math.pi * 2
    local distance = math.random(20, 50)
    return rootPart.Position + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
end

local function moveToPosition(targetPos)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })
    
    path:ComputeAsync(rootPart.Position, targetPos)
    
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, waypoint in pairs(waypoints) do
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait(2)
        end
    else
        humanoid:MoveTo(targetPos)
    end
end

spawn(function()
    while character.Parent do
        wait(3)
        local target = getRandomPosition()
        moveToPosition(target)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
end)
