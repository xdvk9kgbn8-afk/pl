-- LocalScript (Place inside StarterPlayer -> StarterPlayerScripts)

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local c = workspace.CurrentCamera

local speed = 60
local lastUpdate = 0

-- Initialize the global variable
_G.noclipFlyEnabled = _G.noclipFlyEnabled or false

-- Function to handle player movement
local function getNextMovement(deltaTime)
    local nextMove = Vector3.new()

    -- Get the camera's forward and right directions
    local cameraCFrame = c.CFrame
    local cameraForward = cameraCFrame.LookVector
    local cameraRight = cameraCFrame.RightVector

    -- Calculate movement direction based on the camera orientation
    if userInput:IsKeyDown(Enum.KeyCode.W) then
        nextMove = nextMove + cameraForward
    end
    if userInput:IsKeyDown(Enum.KeyCode.S) then
        nextMove = nextMove - cameraForward
    end
    if userInput:IsKeyDown(Enum.KeyCode.A) then
        nextMove = nextMove - cameraRight
    end
    if userInput:IsKeyDown(Enum.KeyCode.D) then
        nextMove = nextMove + cameraRight
    end

    return nextMove * (speed * deltaTime)
end

-- Function to enable/disable noclip fly
local function updateNoClip()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    if _G.noclipFlyEnabled then
        humanoid.PlatformStand = true
        root.Anchored = true
    else
        humanoid.PlatformStand = false
        root.Anchored = false
    end
end

-- Main loop to handle movement while noclip is enabled
rs.RenderStepped:Connect(function(deltaTime)
    if _G.noclipFlyEnabled then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local move = getNextMovement(deltaTime)
            root.CFrame = root.CFrame + move
        end
    end
    updateNoClip()
end)
