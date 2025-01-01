--[[
        d8b                   888      d8b              888             
        Y8P                   888      Y8P              888             
                              888                       888             
888d888 888 88888888 888  888 888  888 888      .d8888b 888888 888  888 
888P"   888    d88P  888  888 888 .88P 888     d88P"    888    `Y8bd8P' 
888     888   d88P   888  888 888888K  888     888      888      X88K   
888     888  d88P    Y88b 888 888 "88b 888 d8b Y88b.    Y88b.  .d8""8b. 
888     888 88888888  "Y88888 888  888 888 Y8P  "Y8888P  "Y888 888  888 
                                                                        
──────────────────────────────────R──────────────────────────────────────

 made by 
 - @3bvz
 - @xahfreestyle
]]--                                                   
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Drawing = Drawing or require("Drawing")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local isCameraLocked = false
local lockedTarget = nil
local fovCircle = Drawing.new("Circle")
local espBoxes = {}
fovCircle.Visible = getgenv().Settings.FOV.Enabled
fovCircle.Radius = getgenv().Settings.FOV.Size
fovCircle.Color = getgenv().Settings.FOV.Color
fovCircle.Thickness = 2
fovCircle.Filled = false 

local function updateFOVCircle()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
end

local function updateBoxESP()
    for _, line in pairs(espBoxes) do
        line:Remove()
    end
    espBoxes = {}

    if not getgenv().Settings.BoxESP.Enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")

            if rootPart and head then
                local rootScreenPos = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                local headScreenPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)

                local boxHeight = math.abs(headScreenPos.Y - rootScreenPos.Y)
                local boxWidth = boxHeight / 2
                local boxPosition = Vector2.new(rootScreenPos.X - boxWidth / 2, rootScreenPos.Y - boxHeight / 2)

                local topLine = Drawing.new("Line")
                topLine.From = boxPosition
                topLine.To = boxPosition + Vector2.new(boxWidth, 0)
                topLine.Color = getgenv().Settings.BoxESP.Color
                topLine.Thickness = 1
                topLine.Visible = true
                table.insert(espBoxes, topLine)

                local bottomLine = Drawing.new("Line")
                bottomLine.From = boxPosition + Vector2.new(0, boxHeight)
                bottomLine.To = boxPosition + Vector2.new(boxWidth, boxHeight)
                bottomLine.Color = getgenv().Settings.BoxESP.Color
                bottomLine.Thickness = 1
                bottomLine.Visible = true
                table.insert(espBoxes, bottomLine)

                local leftLine = Drawing.new("Line")
                leftLine.From = boxPosition
                leftLine.To = boxPosition + Vector2.new(0, boxHeight)
                leftLine.Color = getgenv().Settings.BoxESP.Color
                leftLine.Thickness = 1
                leftLine.Visible = true
                table.insert(espBoxes, leftLine)

                local rightLine = Drawing.new("Line")
                rightLine.From = boxPosition + Vector2.new(boxWidth, 0)
                rightLine.To = boxPosition + Vector2.new(boxWidth, boxHeight)
                rightLine.Color = getgenv().Settings.BoxESP.Color
                rightLine.Thickness = 1
                rightLine.Visible = true
                table.insert(espBoxes, rightLine)
            end
        end
    end
end

local function getPlayerUnderCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local character = player.Character
            local hitPart = character:FindFirstChild(getgenv().Settings.CameraLock.HitPart)

            if hitPart then
                local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(hitPart.Position)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                if distance < shortestDistance and distance <= getgenv().Settings.FOV.Size then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local function toggleCameraLock()
    isCameraLocked = not isCameraLocked
    if isCameraLocked then
        lockedTarget = getPlayerUnderCursor()
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter 
    else
        lockedTarget = nil
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default 
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == getgenv().Settings.CameraLock.ToggleKey then
        toggleCameraLock()
    end
end)

RunService.RenderStepped:Connect(function()
    updateFOVCircle()
    updateBoxESP()

    if isCameraLocked and lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild(getgenv().Settings.CameraLock.HitPart) then
        local targetPart = lockedTarget.Character[getgenv().Settings.CameraLock.HitPart]
        local predictedPosition = targetPart.Position + targetPart.Velocity * Vector3.new(getgenv().Settings.CameraLock.PredictionX, getgenv().Settings.CameraLock.PredictionY, 0)
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, predictedPosition)
    end
end)
