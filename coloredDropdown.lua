local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local shamanGui = game.CoreGui:WaitForChild("Shaman")

-- Cache buttons with their last known state
local buttonsCache = {}

local function getTeamColor(playerName)
    local player = Players:FindFirstChild(playerName)
    return (player and player.Team and player.Team.TeamColor.Color) or Color3.new(1,1,1)
end

-- Populate cache
local function addButton(button)
    buttonsCache[button] = {
        lastName = "",
        lastColor = Color3.new(1,1,1)
    }
end

local function updateCache()
    for _, desc in pairs(shamanGui:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Name == "ButtonText" and desc.Parent and desc.Parent.Name == "DropdownContainerButton" then
            if not buttonsCache[desc] then
                addButton(desc)
            end
        end
    end
end

updateCache()

-- Monitor new buttons
shamanGui.DescendantAdded:Connect(function(desc)
    if desc:IsA("TextLabel") and desc.Name == "ButtonText" and desc.Parent and desc.Parent.Name == "DropdownContainerButton" then
        addButton(desc)
    end
end)

-- Main loop: only update when necessary
RunService.Heartbeat:Connect(function()
    for button, state in pairs(buttonsCache) do
        if button and button.Parent then
            local username = button.Text
            if username ~= state.lastName then
                local color = getTeamColor(username)
                if color ~= state.lastColor then
                    button.TextColor3 = color
                    state.lastColor = color
                end
                state.lastName = username
            end
        end
    end
end)
