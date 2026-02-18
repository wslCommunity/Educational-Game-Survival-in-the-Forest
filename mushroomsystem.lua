-- ============= СЕРВЕРНЫЙ МЕНЕДЖЕР ГРИБОВ =============
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

print("🍄 ЗАПУСК СИСТЕМЫ ГРИБОВ")

-- Создаем RemoteEvents
local mushroomSystem = Instance.new("Folder")
mushroomSystem.Name = "MushroomSystem"
mushroomSystem.Parent = ReplicatedStorage

local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = mushroomSystem

local showMushroomUI = Instance.new("RemoteEvent")
showMushroomUI.Name = "ShowMushroomUI"
showMushroomUI.Parent = remoteEvents

local mushroomAction = Instance.new("RemoteEvent")
mushroomAction.Name = "MushroomAction"
mushroomAction.Parent = remoteEvents

-- Картинки грибов (ЗАМЕНИ ID!)
local mushroomImages = {
	"rbxassetid://1234567891", -- съедобный 1
	"rbxassetid://1234567892", -- съедобный 2
	"rbxassetid://1234567893", -- ядовитый 1
	"rbxassetid://1234567894", -- ядовитый 2
}

-- Обработка действий с грибами
mushroomAction.OnServerEvent:Connect(function(player, action, mushroom)
	if not mushroom or not mushroom.Parent then
		return
	end

	local data = mushroom:FindFirstChild("MushroomData")
	if not data then return end

	local isPoisonous = data:FindFirstChild("IsPoisonous")
	local imageId = data:FindFirstChild("ImageId")

	if action == "eat" then
		if isPoisonous and isPoisonous.Value then
			print("💀", player.Name, "съел ядовитый гриб")
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.Health = 0
					task.wait(1)
					player:LoadCharacter()
				end
			end
		else
			print("❤️", player.Name, "съел гриб +25 HP")
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.Health = math.min(humanoid.Health + 25, humanoid.MaxHealth)
				end
			end
		end
		mushroom:Destroy()

	elseif action == "take" then
		print("📦", player.Name, "забрал гриб")

		local inventory = player:FindFirstChild("Inventory")
		if not inventory then
			inventory = Instance.new("Folder")
			inventory.Name = "Inventory"
			inventory.Parent = player
		end

		local item = mushroom:Clone()
		item.Name = "MushroomItem_"..tostring(os.time())

		local prompt = item:FindFirstChild("ProximityPrompt", true)
		if prompt then
			prompt:Destroy()
		end

		item.Parent = inventory
		mushroom:Destroy()

	elseif action == "drop" then
		print("🗑️", player.Name, "выкинул гриб")
		mushroom:Destroy()
	end
end)

print("✅ Серверная часть готова")
