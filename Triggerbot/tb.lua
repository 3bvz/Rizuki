local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local isEnabled = true
local currentlyHighlighted = nil

local function highlightCharacter(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "PHighlight"
    highlight.FillColor = Color3.new(1, 0, 0) 
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1 
    highlight.Parent = character
end

local function removeHighlight(character)
    local highlight = character:FindFirstChild("NeonHighlight")
    if highlight then
        highlight:Destroy()
    end
end

local function isPlayerHit(hit)
    if hit and hit.Parent then
        local character = hit.Parent
        return Players:GetPlayerFromCharacter(character)
    end
    return nil
end

local function sendNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2, 
        Icon = "rbxassetid://91865098616901"
    })
end
sendNotification("RizukiTB", "Press 'Q' to toggle the triggerbot.", 2)

RunService.RenderStepped:Connect(function()
    if not isEnabled then
        if currentlyHighlighted then
            removeHighlight(currentlyHighlighted)
            currentlyHighlighted = nil
        end
        return
    end

    local mousePosition = Vector2.new(mouse.X, mouse.Y)
    local camera = workspace.CurrentCamera

    local rayOrigin = camera.CFrame.Position
    local rayDirection = (camera:ScreenPointToRay(mouse.X, mouse.Y)).Direction * 500

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localPlayer.Character} 
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if raycastResult then
        local hitPlayer = isPlayerHit(raycastResult.Instance)
        if hitPlayer and hitPlayer.Character then
            if currentlyHighlighted ~= hitPlayer.Character then
                if currentlyHighlighted then
                    removeHighlight(currentlyHighlighted)
                end
                highlightCharacter(hitPlayer.Character)
                currentlyHighlighted = hitPlayer.Character
            end
        else
            if currentlyHighlighted then
                removeHighlight(currentlyHighlighted)
                currentlyHighlighted = nil
            end
        end
    else
        if currentlyHighlighted then
            removeHighlight(currentlyHighlighted)
            currentlyHighlighted = nil
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        isEnabled = not isEnabled
        if isEnabled then
            sendNotification("Enabled", "The triggerbot is now active!", 2)
        else
            sendNotification("Disabled", "The triggerbot has been disabled.", 2)
            if currentlyHighlighted then
                removeHighlight(currentlyHighlighted)
                currentlyHighlighted = nil
            end
        end
    end
end)
