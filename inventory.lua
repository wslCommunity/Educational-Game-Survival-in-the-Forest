local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

print("1 - Скрипт запущен")

-- Создаем папку для палок в ServerStorage
local stickFolder = Instance.new("Folder")
stickFolder.Name = "Sticks"
stickFolder.Parent = ServerStorage

print("2 - Папка для палок создана в ServerStorage")

-- Модель палки
local function createStickModel()
	local stick = Instance.new("Part")
	stick.Name = "Stick"
	stick.Size = Vector3.new(0.5, 3, 0.5)
	stick.BrickColor = BrickColor.new("Brown")
	stick.Material = Enum.Material.Wood

	-- Делаем палку можно поднимать
	stick.CanCollide = true
	stick.Anchored = false

	return stick
end

print("3 - Функция создания палки готова")

-- Функция для получения случайной позиции в зоне спавна
local function getRandomPositionInSpawnArea()
	local spawnArea = workspace:FindFirstChild("Spawn Area")
	if not spawnArea then
		warn("Spawn Area не найдена! Использую позицию по умолчанию")
		return Vector3.new(0, 10, 0)
	end

	print("Найдена Spawn Area: " .. spawnArea.Name)
	print("Позиция Spawn Area: " .. tostring(spawnArea.Position))
	print("Размер Spawn Area: " .. tostring(spawnArea.Size))

	local size = spawnArea.Size
	local position = spawnArea.Position

	-- Генерируем случайные координаты внутри области
	local randomX = math.random(-size.X/2, size.X/2)
	local randomZ = math.random(-size.Z/2, size.Z/2)

	-- Поднимаем палку над землей
	local spawnPos = Vector3.new(
		position.X + randomX,
		position.Y + 3,
		position.Z + randomZ
	)

	print("Случайная позиция для палки: " .. tostring(spawnPos))
	return spawnPos
end

print("4 - Функция получения позиции готова")

-- Спавн одной палки
local function spawnStick()
	local stick = createStickModel()
	local position = getRandomPositionInSpawnArea()

	stick.Position = position

	-- Добавляем тэг для идентификации
	local tag = Instance.new("StringValue")
	tag.Name = "IsStick"
	tag.Value = "true"
	tag.Parent = stick

	-- Добавляем свечение для лучшей видимости
	local glow = Instance.new("PointLight")
	glow.Brightness = 0.5
	glow.Range = 8
	glow.Color = Color3.new(0.7, 0.5, 0.2)
	glow.Parent = stick

	-- Сохраняем копию в папку Sticks
	local stickCopy = stick:Clone()
	stickCopy.Parent = stickFolder

	-- Оригинал помещаем в workspace
	stick.Parent = workspace

	print("Палка создана на позиции: " .. tostring(position))
	print("Копия палки сохранена в папку Sticks")

	return stick
end

print("5 - Функция спавна одной палки готова")

-- Спавн нескольких палок
local function spawnMultipleSticks(count)
	print("Начинаю спавн " .. count .. " палок...")

	for i = 1, count do
		local stick = spawnStick()
		print("Палка " .. i .. " создана и сохранена в папку")
		wait(0.05)
	end

	-- Проверяем содержимое папки Sticks
	local stickCount = #stickFolder:GetChildren()
	print("В папке Sticks теперь " .. stickCount .. " объектов")

	print("Спавн " .. count .. " палок завершен!")
end

print("6 - Функция множественного спавна готова")

-- Основная инициализация
print("Начинаю инициализацию...")

-- Ждем немного перед первым спавном
wait(2)

-- Первоначальный спавн
spawnMultipleSticks(100)

print("Палки успешно заспавнены!")
print("Авто-респавн отключен")

-- Авто-респавн УБРАН по твоему требованию
