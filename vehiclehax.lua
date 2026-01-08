--!strict
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Initialize Global Variables (Default Settings)
_G.VehicleBoostEnabled = false
_G.VehicleBoostMultiplier = 1

RunService.Heartbeat:Connect(function(deltaTime)
    -- Check if the boost is enabled via the global variable
    if not _G.VehicleBoostEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid.SeatPart then return end
    
    local seat = humanoid.SeatPart
    if seat:IsA("VehicleSeat") then
        -- Only apply boost if the driver is actually pressing W (Throttle > 0)
        -- We check for Throttle > 0 (Forward) or Throttle < 0 (Backward)
        if math.abs(seat.Throttle) > 0 then
            
            -- Direction: seat.CFrame.LookVector (Forward) 
            -- We multiply by seat.Throttle so reversing also gets a boost
            local direction = seat.CFrame.LookVector * seat.Throttle
            
            -- Apply physical velocity boost using the global multiplier
            -- Using AssemblyLinearVelocity ensures we affect the entire connected car
            seat.AssemblyLinearVelocity += direction * _G.VehicleBoostMultiplier
        end
    end
end)

print("Global Vehicle Boost Loaded.")
print("Toggle: _G.VehicleBoostEnabled | Speed: _G.VehicleBoostMultiplier")
