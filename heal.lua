local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HealthBarGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- Создаем основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "HealthBar"
MainFrame.Size = UDim2.new(0.3, 0, 0.03, 0) -- 30% ширины экрана, 3% высоты
MainFrame.Position = UDim2.new(0.35, 0, 0.02, 0) -- Позиция вверху по центру
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Тёмный фон
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Parent = ScreenGui

-- Создаем заполняющийся бар здоровья
local HealthFill = Instance.new("Frame")
HealthFill.Name = "Fill"
HealthFill.Size = UDim2.new(1, 0, 1, 0)
HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Начальный цвет (зеленый)
HealthFill.BorderSizePixel = 0
HealthFill.Parent = MainFrame

-- Создаем текст с процентами
local HealthText = Instance.new("TextLabel")
HealthText.Name = "Percentage"
HealthText.Size = UDim2.new(1, 0, 1, 0)
HealthText.BackgroundTransparency = 1
HealthText.Font = Enum.Font.GothamBold
HealthText.TextColor3 = Color3.fromRGB(255, 255, 255)
HealthText.TextStrokeTransparency = 0
HealthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
HealthText.TextScaled = true
HealthText.Text = "100%"
HealthText.Parent = MainFrame

-- Функция обновления здоровья
local function updateHealth(humanoid)
	local healthPercent = (humanoid.Health / humanoid.MaxHealth)

	-- Обновляем размер заполнения
	HealthFill.Size = UDim2.new(healthPercent, 0, 1, 0)

	-- Обновляем текст
	HealthText.Text = math.floor(healthPercent * 100) .. "%"

	-- Обновляем цвет в зависимости от количества здоровья
	if healthPercent > 0.5 then
		-- Зеленый -> Желтый
		local g = 255
		local r = 255 * (2 - 2 * healthPercent)
		HealthFill.BackgroundColor3 = Color3.fromRGB(r, g, 0)
	else
		-- Желтый -> Красный
		local r = 255
		local g = 255 * (2 * healthPercent)
		HealthFill.BackgroundColor3 = Color3.fromRGB(r, g, 0)
	end
end

-- Функция инициализации для нового персонажа
local function initializeHealthBar(char)
	local humanoid = char:WaitForChild("Humanoid")

	-- Обновляем при изменении здоровья
	humanoid.HealthChanged:Connect(function()
		updateHealth(humanoid)
	end)

	-- Начальное обновление
	updateHealth(humanoid)
end

-- Подключаем обработку для текущего и будущих персонажей
player.CharacterAdded:Connect(initializeHealthBar)
if player.Character then
	initializeHealthBar(player.Character)
end
