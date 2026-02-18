local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local ORIGINAL_JUMP_POWER = 50  
local JUMP_DECREASE = 2        
local MIN_JUMP_POWER = 0      
       
local REGEN_DELAY = 100          

local function createStaminaGui(player)
	local gui = Instance.new("ScreenGui")
	gui.Name = "StaminaGui"

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 20)
	frame.Position = UDim2.new(0.5, -100, 0.9, 0)
	frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	frame.BorderSizePixel = 2
	frame.Parent = gui

	local bar = Instance.new("Frame")
	bar.Name = "StaminaBar"
	bar.Size = UDim2.new(1, 0, 1, 0)
	bar.BackgroundColor3 = Color3.new(0, 1, 0)
	bar.Parent = frame

	gui.Parent = player.PlayerGui
	return bar
end


local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		local staminaBar = createStaminaGui(player)
		local lastJumpTime = 0

	
		humanoid.JumpPower = ORIGINAL_JUMP_POWER

		humanoid.Jumping:Connect(function(active)
			if active then
				lastJumpTime = tick()
				local newJumpPower = math.max(MIN_JUMP_POWER, humanoid.JumpPower - JUMP_DECREASE)
				humanoid.JumpPower = newJumpPower
				local staminaPercent = (humanoid.JumpPower - MIN_JUMP_POWER) / (ORIGINAL_JUMP_POWER - MIN_JUMP_POWER)
				staminaBar.Size = UDim2.new(staminaPercent, 0, 1, 0)
				staminaBar.BackgroundColor3 = Color3.new(1 - staminaPercent, staminaPercent, 0)
			end
		end)


		RunService.Heartbeat:Connect(function(deltaTime)
			local timeSinceLastJump = tick() - lastJumpTime

			if timeSinceLastJump > REGEN_DELAY and humanoid.JumpPower < ORIGINAL_JUMP_POWER then
				local newJumpPower = math.min(ORIGINAL_JUMP_POWER, humanoid.JumpPower + REGEN_RATE * deltaTime)
				humanoid.JumpPower = newJumpPower

			
				local staminaPercent = (newJumpPower - MIN_JUMP_POWER) / (ORIGINAL_JUMP_POWER - MIN_JUMP_POWER)
				staminaBar.Size = UDim2.new(staminaPercent, 0, 1, 0)
				staminaBar.BackgroundColor3 = Color3.new(1 - staminaPercent, staminaPercent, 0)
			end
		end)
	end)
end


Players.PlayerAdded:Connect(onPlayerAdded)
