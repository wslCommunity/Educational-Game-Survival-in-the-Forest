-- ServerScriptService/CampfireSystem.lua
local CampfireSystem = {}

-- ID костра в MarketplaceService (или ваш собственный объект)
local CAMPFIRE_ID = "rbxassetid://ВАШ_ID_МОДЕЛИ_КОСТРА"

-- Стоимость костра в палках
local CAMPFIRE_COST = 10

-- Ссылка на ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Создаем RemoteEvents
local BuyCampfireEvent = Instance.new("RemoteEvent")
BuyCampfireEvent.Name = "BuyCampfireEvent"
BuyCampfireEvent.Parent = ReplicatedStorage

local PlaceCampfireEvent = Instance.new("RemoteEvent")
PlaceCampfireEvent.Name = "PlaceCampfireEvent"
PlaceCampfireEvent.Parent = ReplicatedStorage

-- Функция для проверки наличия палок
local function hasEnoughSticks(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return false end

	local sticks = leaderstats:FindFirstChild("sticks")
	if not sticks then return false end

	return sticks.Value >= CAMPFIRE_COST
end

-- Функция для списания палок
local function deductSticks(player, amount)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return false end

	local sticks = leaderstats:FindFirstChild("sticks")
	if not sticks then return false end

	if sticks.Value >= amount then
		sticks.Value = sticks.Value - amount
		return true
	end
	return false
end

-- Обработка покупки костра
BuyCampfireEvent.OnServerEvent:Connect(function(player)
	if hasEnoughSticks(player) then
		if deductSticks(player, CAMPFIRE_COST) then
			-- Сохраняем информацию о покупке
			local playerData = {
				hasCampfire = true,
				player = player
			}

			-- Уведомляем клиента об успешной покупке
			BuyCampfireEvent:FireClient(player, true, "Костер успешно куплен!")

			-- Сохраняем данные игрока (можно использовать DataStore для сохранения между сессиями)
			CampfireSystem[player.UserId] = playerData
		else
			BuyCampfireEvent:FireClient(player, false, "Недостаточно палок!")
		end
	else
		BuyCampfireEvent:FireClient(player, false, "Недостаточно палок!")
	end
end)

-- Обработка размещения костра
PlaceCampfireEvent.OnServerEvent:Connect(function(player, position)
	if not CampfireSystem[player.UserId] or not CampfireSystem[player.UserId].hasCampfire then
		PlaceCampfireEvent:FireClient(player, false, "У вас нет костра для размещения!")
		return
	end

	-- Создаем костер
	local campfire = Instance.new("Part")
	campfire.Name = "Campfire"
	campfire.Size = Vector3.new(4, 1, 4)
	campfire.Position = position
	campfire.Anchored = true
	campfire.Material = Enum.Material.Slate
	campfire.BrickColor = BrickColor.new("Reddish brown")
	campfire.Parent = workspace

	-- Добавляем огонь
	local fire = Instance.new("Fire")
	fire.Size = 8
	fire.Heat = 10
	fire.Color = Color3.new(1, 0.5, 0)
	fire.SecondaryColor = Color3.new(1, 1, 0)
	fire.Parent = campfire

	-- Добавляем свечение
	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = 2
	pointLight.Range = 15
	pointLight.Color = Color3.new(1, 0.5, 0)
	pointLight.Parent = campfire

	-- Убираем костер из инвентаря игрока
	CampfireSystem[player.UserId].hasCampfire = false

	PlaceCampfireEvent:FireClient(player, true, "Костер успешно размещен!")
end)

-- Очистка данных при выходе игрока
Players.PlayerRemoving:Connect(function(player)
	CampfireSystem[player.UserId] = nil
end)

return CampfireSystem
