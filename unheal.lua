local Players = game:GetService("Players")

-- Функция для работы с персонажем
local function handleCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Отключаем регенерацию
	humanoid.HealthRegen = 0

	-- Создаем бесконечный цикл для уменьшения HP
	spawn(function()
		while true do
			if humanoid and humanoid.Parent then
				local currentHealth = humanoid.Health
				if currentHealth > 0 then
					-- Уменьшаем HP на 1
					humanoid.Health = currentHealth - 1
					print("HP:", humanoid.Health)
				end
			else
				break
			end
			wait(1)
		end
	end)
end

-- Обработка существующих игроков
for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		handleCharacter(player.Character)
	end
end

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
	print("Новый игрок:", player.Name)
	player.CharacterAdded:Connect(function(character)
		print("Новый персонаж для:", player.Name)
		handleCharacter(character)
	end)
end)
