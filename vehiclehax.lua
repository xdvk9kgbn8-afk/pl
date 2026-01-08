--!strict
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Initialize Global Variables (Default Settings)
_G.VehicleBoostEnabled = false
_G.VehicleBoostMultiplier = 1

RunService.Heartbeat:Connect(function(deltaTime)
    if not _G.VehicleBoostEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid.SeatPart then return end
    
    local seat = humanoid.SeatPart
    if seat:IsA("VehicleSeat") then
        local velocity = seat.AssemblyLinearVelocity
        local cf = seat.CFrame
        
        ------------------------------------------------------------
        -- 1. LATERAL TRACTION CONTROL (Anti-Slide)
        ------------------------------------------------------------
        -- Calculate how much the car is moving sideways (RightVector)
        local lateralVelocity = cf.RightVector:Dot(velocity)
        
        -- Apply a counter-force to cancel out the sliding.
        -- 0.15 is a "sweet spot": it allows minor drifting but stops the ice-skating effect.
        seat.AssemblyLinearVelocity -= cf.RightVector * (lateralVelocity * 0.2)

        ------------------------------------------------------------
        -- 2. ARTIFICIAL DOWNFORCE (Anti-Flip/Float)
        ------------------------------------------------------------
        -- High speeds in Roblox make cars "floaty." This nudges the car 
        -- downward to keep the wheels touching the ground for better grip.
        seat.AssemblyLinearVelocity -= Vector3.new(0, 0.5, 0)

        ------------------------------------------------------------
        -- 3. BOOST LOGIC
        ------------------------------------------------------------
        if math.abs(seat.Throttle) > 0 then
            local direction = cf.LookVector * seat.Throttle
            seat.AssemblyLinearVelocity += direction * _G.VehicleBoostMultiplier
        end
    end
end)

print("Global Vehicle Boost with Traction Control Loaded.")
