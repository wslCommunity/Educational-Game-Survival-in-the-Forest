local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

print("🎮 GUI Script: Запускается красивый интерфейс")

-- Инвентарь игрока
inventory = {
	sticks = 0
}

-- Создаем красивый GUI
local function createBeautifulGUI()
	local playerGui = player:WaitForChild("PlayerGui")

	-- Удаляем старый GUI если есть
	local oldGUI = playerGui:FindFirstChild("InventoryGUI")
	if oldGUI then
		oldGUI:Destroy()
	end

	-- Основной GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InventoryGUI"
	screenGui.Parent = playerGui

	-- Главный контейнер
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 300, 0, 120)
	mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	mainFrame.BackgroundTransparency = 0.1
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	-- Закругленные углы
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	-- Тень
	local shadow = Instance.new("UIStroke")
	shadow.Color = Color3.fromRGB(0, 0, 0)
	shadow.Thickness = 2
	shadow.Transparency = 0.7
	shadow.Parent = mainFrame

	-- Заголовок
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	title.BackgroundTransparency = 0
	title.Text = "📦 ИНВЕНТАРЬ"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = mainFrame

	-- Закругления для заголовка
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = title

	-- Контейнер для палки
	local stickContainer = Instance.new("Frame")
	stickContainer.Name = "StickContainer"
	stickContainer.Size = UDim2.new(1, -20, 0, 60)
	stickContainer.Position = UDim2.new(0, 10, 0, 40)
	stickContainer.BackgroundTransparency = 1
	stickContainer.Parent = mainFrame

	-- Иконка палки
	local stickIcon = Instance.new("ImageLabel")
	stickIcon.Name = "StickIcon"
	stickIcon.Size = UDim2.new(0, 40, 0, 40)
	stickIcon.Position = UDim2.new(0, 0, 0, 10)
	stickIcon.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Коричневый
	stickIcon.BackgroundTransparency = 0
	stickIcon.Image = "rbxassetid://0" -- Можно заменить на свою текстуру
	stickIcon.Parent = stickContainer

	-- Закругления для иконки
	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 8)
	iconCorner.Parent = stickIcon

	-- Обводка иконки
	local iconStroke = Instance.new("UIStroke")
	iconStroke.Color = Color3.fromRGB(210, 180, 140) -- Бежевый
	iconStroke.Thickness = 2
	iconStroke.Parent = stickIcon

	-- Текст количества палок
	local sticksText = Instance.new("TextLabel")
	sticksText.Name = "SticksText"
	sticksText.Size = UDim2.new(0, 200, 0, 40)
	sticksText.Position = UDim2.new(0, 50, 0, 10)
	sticksText.BackgroundTransparency = 1
	sticksText.Text = "Палки: 0"
	sticksText.TextColor3 = Color3.fromRGB(255, 255, 255)
	sticksText.TextScaled = true
	sticksText.TextXAlignment = Enum.TextXAlignment.Left
	sticksText.Font = Enum.Font.GothamSemibold
	sticksText.Parent = stickContainer

	-- Анимация при изменении количества
	local function animatePickup()
		stickIcon.Size = UDim2.new(0, 45, 0, 45)
		stickIcon.Position = UDim2.new(0, -2.5, 0, 7.5)

		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		local tween = tweenService:Create(stickIcon, tweenInfo, {
			Size = UDim2.new(0, 40, 0, 40),
			Position = UDim2.new(0, 0, 0, 10)
		})

		tween:Play()
	end

	print("🎨 GUI: Красивый интерфейс создан")
	return sticksText, animatePickup
end

-- Функция для обновления интерфейса
local function updateInventoryUI(sticksText, animatePickup)
	if sticksText then
		sticksText.Text = "Палки: " .. inventory.sticks
		if animatePickup then
			animatePickup()
		end
	end
end

-- Функция подбора палки
local function pickupStick(stick, sticksText, animatePickup)
	if stick and stick:FindFirstChild("IsStick") then
		-- Увеличиваем счетчик палок
		inventory.sticks = inventory.sticks + 1

		-- Воспроизводим звук (можно добавить позже)
		print("🎯 Подобрал палку! Всего палок: " .. inventory.sticks)

		-- Удаляем палку из мира
		stick:Destroy()

		-- Обновляем интерфейс с анимацией
		updateInventoryUI(sticksText, animatePickup)

		return true
	end
	return false
end

-- Система подбора при клике
local function setupClickPickup(sticksText, animatePickup)
	mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if target and target:FindFirstChild("IsStick") then
			pickupStick(target, sticksText, animatePickup)
		end
	end)
end

-- Система автоматического подбора при приближении
local function setupProximityPickup(sticksText, animatePickup)
	while true do
		wait(0.5) -- Проверяем каждые 0.5 секунд

		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local playerPos = character.HumanoidRootPart.Position

			-- Проверяем все палки рядом
			for _, item in pairs(workspace:GetChildren()) do
				if item:IsA("Part") and item:FindFirstChild("IsStick") then
					local distance = (playerPos - item.Position).Magnitude
					if distance < 6 then -- Если ближе 6 studs
						if pickupStick(item, sticksText, animatePickup) then
							break -- Подобрали одну палку, выходим из цикла
						end
					end
				end
			end
		end
	end
end

-- Отладочная информация
local function printDebugInfo()
	print("🔍 Отладочная информация:")
	print("   - Инвентарь: " .. inventory.sticks .. " палок")

	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local playerPos = character.HumanoidRootPart.Position
		print("   - Позиция игрока: " .. tostring(playerPos))
	end

	-- Считаем палки в мире
	local stickCount = 0
	for _, item in pairs(workspace:GetChildren()) do
		if item:IsA("Part") and item:FindFirstChild("IsStick") then
			stickCount = stickCount + 1
		end
	end
	print("   - Палок в мире: " .. stickCount)
end

-- Основная инициализация
local function initialize()
	print("🚀 Запуск системы подбора...")

	-- Создаем GUI и получаем элементы управления
	local sticksText, animatePickup = createBeautifulGUI()

	-- Настраиваем систему подбора
	setupClickPickup(sticksText, animatePickup)

	-- Запускаем автоматический подбор
	spawn(function()
		setupProximityPickup(sticksText, animatePickup)
	end)

	-- Отладочная информация каждые 10 секунд
	spawn(function()
		while true do
			wait(10)
			printDebugInfo()
		end
	end)

	print("✅ Система подбора готова!")
	print("   - Кликай на палки чтобы подбирать")
	print("   - Или подходи близко к палкам")
end

-- Ждем когда игрок загрузится
if player.Character then
	initialize()
end

player.CharacterAdded:Connect(function(character)
	wait(1) -- Ждем полной загрузки персонажа
	initialize()
end)

print("🎮 GUI Script: Загрузка завершена")
