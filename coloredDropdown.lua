local Players = game:GetService("Players")
local shamanGui = game.CoreGui:WaitForChild("Shaman")

local buttonsCache = {}

-- Helper: get team color for a username
local function getTeamColor(playerName)
    local player = Players:FindFirstChild(playerName)
    return (player and player.Team and player.Team.TeamColor.Color) or Color3.new(1,1,1)
end

-- Update the text color of a button
local function updateButtonColor(button)
    if button and button.Parent then
        local username = button.Text
        button.TextColor3 = getTeamColor(username)
    end
end

-- Add a button to cache and attach hover events
local function addButton(button)
    if buttonsCache[button] then return end
    buttonsCache[button] = true

    -- Update color on hover
    if button:IsA("TextLabel") then
        button.MouseEnter:Connect(function()
            updateButtonColor(button)
        end)
        button.MouseLeave:Connect(function()
            updateButtonColor(button)
        end)
    end
end

-- Initial scan
for _, desc in pairs(shamanGui:GetDescendants()) do
    if desc.Name == "ButtonText" and desc.Parent and desc.Parent.Name == "DropdownContainerButton" then
        addButton(desc)
    end
end

-- Listen for new buttons dynamically
shamanGui.DescendantAdded:Connect(function(desc)
    if desc.Name == "ButtonText" and desc.Parent and desc.Parent.Name == "DropdownContainerButton" then
        addButton(desc)
    end
end)

-- Periodically update all buttons (every 3 seconds)
while true do
    for button in pairs(buttonsCache) do
        updateButtonColor(button)
    end
    task.wait(3) -- adjust the interval as needed
end
