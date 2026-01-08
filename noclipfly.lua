--!strict
local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local speed = 60

-- Movement helper (Detects WASD input)
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
    
    local root = char:FindFirstChild("HumanoidRootPart") :: BasePart
    local humanoid = char:FindFirstChild("Humanoid") :: Humanoid
    if not root or not humanoid then return end

    -- Read from the global variable instead of a hotkey
    if _G.noClipFly == true then
        -- 1. Physics State
        humanoid.PlatformStand = true
        root.Anchored = true

        -- 2. Movement logic
        local move = getMoveVector()
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move.Unit * speed * deltaTime)
        end

        -- 3. Efficient Noclip (Sets collision group or state)
        -- Using Stepped/Heartbeat is better for collisions, but for a simple 
        -- cheat-style script, setting this state works:
        humanoid:ChangeState(Enum.HumanoidStateType.NoPhysics)
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        -- Return to normal if global is false or nil
        if root.Anchored then
            root.Anchored = false
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)
