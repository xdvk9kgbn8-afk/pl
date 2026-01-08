-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local speed = 60

-- Initialize the global variable
_G.noClipFly = _G.noClipFly or false

-- Movement helper
local function getMoveVector()
    local move = Vector3.new()
    if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
    if userInput:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
    if userInput:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
    if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
    return move
end

-- Main loop
runService.RenderStepped:Connect(function(deltaTime)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not root or not humanoid then return end

    if _G.noClipFly then
        -- Enable noclip & flight
        humanoid.PlatformStand = true
        root.Anchored = true

        -- Manual movement
        local move = getMoveVector()
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + move.Unit * speed * deltaTime
        end

        -- Disable collisions safely
        for _, part in pairs(char:GetDescendants()) do
            pcall(function() part.CanCollide = false end)
        end
    else
        -- Restore normal behavior
        humanoid.PlatformStand = false
        root.Anchored = false
    end
end)
