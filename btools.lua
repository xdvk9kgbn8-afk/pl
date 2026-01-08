--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local SELECTION_COLOR = Color3.fromRGB(0, 255, 255)

local function createTool(name: string, onActivated: (Instance?) -> ())
	local tool = Instance.new("Tool")
	tool.Name = name
	tool.RequiresHandle = false
	tool.Parent = Player.Backpack

	local selection = Instance.new("SelectionBox")
	selection.Name = "BToolSelection"
	selection.Color3 = SELECTION_COLOR
	selection.LineThickness = 0.05
	selection.Parent = Player.PlayerGui 

	RunService.RenderStepped:Connect(function()
		if tool.Parent == Player.Character then
			local target = Mouse.Target
			if target and target:IsA("BasePart") and not target:IsDescendantOf(Player.Character) then
				selection.Adornee = target
			else
				selection.Adornee = nil
			end
		else
			selection.Adornee = nil
		end
	end)

	tool.Activated:Connect(function()
		onActivated(Mouse.Target)
	end)
	
	return tool
end

----------------------------------------------------------------
-- TOOL DEFINITIONS
----------------------------------------------------------------

-- 1. DELETE
createTool("Delete", function(target)
	if target and target:IsA("BasePart") and target.Name ~= "Baseplate" then
		target:Destroy()
	end
end)

-- 2. CLONE
createTool("Clone", function(target)
	if target and target:IsA("BasePart") and target.Archivable then
		local clone = target:Clone()
		clone.Parent = target.Parent
		clone.CFrame = target.CFrame * CFrame.new(0, target.Size.Y + 2, 0)
	end
end)

-- 3. MOVE (Hold-to-Drag Logic)
local moveTool = createTool("Move", function() end) -- Empty func, we use Mouse events instead
local movingPart: BasePart? = nil
local moveConn: RBXScriptConnection? = nil

moveTool.Equipped:Connect(function()
	local downConn, upConn

	downConn = Mouse.Button1Down:Connect(function()
		local target = Mouse.Target
		if target and target:IsA("BasePart") and target.Name ~= "Baseplate" then
			movingPart = target
			
			-- Start the drag loop
			moveConn = RunService.RenderStepped:Connect(function()
				if movingPart and movingPart.Parent then
					local pos = Mouse.Hit.Position
					-- 1 stud grid snapping
					movingPart.Position = Vector3.new(math.round(pos.X), pos.Y + (movingPart.Size.Y/2), math.round(pos.Z))
				end
			end)
		end
	end)

	upConn = Mouse.Button1Up:Connect(function()
		if moveConn then
			moveConn:Disconnect()
			moveConn = nil
		end
		movingPart = nil
	end)

	-- Cleanup if tool is unequipped while dragging
	moveTool.Unequipped:Wait()
	downConn:Disconnect()
	upConn:Disconnect()
	if moveConn then moveConn:Disconnect() end
end)
