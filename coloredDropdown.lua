local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

local shamanGui = game.CoreGui:WaitForChild("Shaman")

-- Cache for performance
local buttonsCache = {}

-- Function to get team color for a username
local function getTeamColor(username)
    local player = game.Players:FindFirstChild(username)
    if player and player.Team then
        return player.Team.TeamColor.Color
    end
    return Color3.new(1,1,1) -- default white
end

-- Initial cache population 
local function updateCache()
    buttonsCache = {}
    for _, desc in pairs(shamanGui:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Name == "ButtonText" and desc.Parent and desc.Parent.Name == "DropdownContainerButton" then
            table.insert(buttonsCache, desc)
        end
    end
end

updateCache() -- initial population

-- Monitor for new buttons being added
shamanGui.DescendantAdded:Connect(function(desc)
    if desc:IsA("TextLabel") and desc.Name == "ButtonText" and desc.Parent and desc.Parent.Name == "DropdownContainerButton" then
        table.insert(buttonsCache, desc)
    end
end)

-- Main loop: update text colors efficiently
RunService.Heartbeat:Connect(function()
    for _, buttonText in pairs(buttonsCache) do
        if buttonText and buttonText.Parent then
            local username = buttonText.Text
            buttonText.TextColor3 = getTeamColor(username)
        end
    end
end)
