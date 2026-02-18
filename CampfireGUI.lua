-- StarterPlayer.StarterPlayerScripts.CampfireGUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyCampfireEvent = ReplicatedStorage:WaitForChild("BuyCampfireEvent")
local PlaceCampfireEvent = ReplicatedStorage:WaitForChild("PlaceCampfireEvent")

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CampfireMenu"
ScreenGui.Parent = PlayerGui

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Магазин костров"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Информация о стоимости
local CostLabel = Instance.new("TextLabel")
CostLabel.Size = UDim2.new(1, -20, 0, 30)
CostLabel.Position = UDim2.new(0, 10, 0, 50)
CostLabel.BackgroundTransparency = 1
CostLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CostLabel.Text = "Стоимость: 10 палок"
CostLabel.Font = Enum.Font.Gotham
CostLabel.TextSize = 16
CostLabel.Parent = MainFrame

-- Кнопка покупки
local BuyButton = Instance.new("TextButton")
BuyButton.Size = UDim2.new(1, -20, 0, 40)
BuyButton.Position = UDim2.new(0, 10, 0, 90)
BuyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyButton.Text = "Купить костер"
BuyButton.Font = Enum.Font.GothamBold
BuyButton.TextSize = 16
BuyButton.Parent = MainFrame

-- Кнопка размещения
local PlaceButton = Instance.new("TextButton")
PlaceButton.Size = UDim2.new(1, -20, 0, 40)
PlaceButton.Position = UDim2.new(0, 10, 0, 140)
PlaceButton.BackgroundColor3 = Color3.fromRGB(33, 150, 243)
PlaceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceButton.Text = "Разместить костер"
PlaceButton.Font = Enum.Font.GothamBold
PlaceButton.TextSize = 16
PlaceButton.Parent = MainFrame

-- Сообщение
local MessageLabel = Instance.new("TextLabel")
MessageLabel.Size = UDim2.new(1, -20, 0, 20)
MessageLabel.Position = UDim2.new(0, 10, 1, -30)
MessageLabel.BackgroundTransparency = 1
MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageLabel.Text = ""
MessageLabel.Font = Enum.Font.Gotham
MessageLabel.TextSize = 14
MessageLabel.Parent = MainFrame

-- Переменные
local hasCampfire = false

-- Функция для показа сообщения
local function showMessage(message, color)
	MessageLabel.Text = message
	MessageLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)

	-- Автоматическое скрытие сообщения через 3 секунды
	delay(3, function()
		if MessageLabel.Text == message then
			MessageLabel.Text = ""
		end
	end)
end

-- Обработка покупки костра
BuyButton.MouseButton1Click:Connect(function()
	BuyCampfireEvent:FireServer()
end)

-- Обработка размещения костра
PlaceButton.MouseButton1Click:Connect(function()
	if not hasCampfire then
		showMessage("Сначала купите костер!", Color3.fromRGB(255, 100, 100))
		return
	end

	-- Получаем позицию игрока
	local character = Player.Character
	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local position = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 5
			PlaceCampfireEvent:FireServer(position)
		end
	end
end)

-- Обработка ответов от сервера
BuyCampfireEvent.OnClientEvent:Connect(function(success, message)
	if success then
		hasCampfire = true
		showMessage(message, Color3.fromRGB(100, 255, 100))
		BuyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		BuyButton.Text = "Куплено"
		BuyButton.AutoButtonColor = false
	else
		showMessage(message, Color3.fromRGB(255, 100, 100))
	end
end)

PlaceCampfireEvent.OnClientEvent:Connect(function(success, message)
	if success then
		hasCampfire = false
		showMessage(message, Color3.fromRGB(100, 255, 100))
		BuyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
		BuyButton.Text = "Купить костер"
		BuyButton.AutoButtonColor = true
	else
		showMessage(message, Color3.fromRGB(255, 100, 100))
	end
end)

-- Открытие/закрытие меню по клавише (например, M)
local UserInputService = game:GetService("UserInputService")
local isMenuOpen = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.M then
		isMenuOpen = not isMenuOpen
		MainFrame.Visible = isMenuOpen
	end
end)

-- Закрытие меню при клике вне его
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if isMenuOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mousePos = UserInputService:GetMouseLocation()
		local absolutePosition = MainFrame.AbsolutePosition
		local absoluteSize = MainFrame.AbsoluteSize

		if mousePos.X < absolutePosition.X or mousePos.X > absolutePosition.X + absoluteSize.X or
			mousePos.Y < absolutePosition.Y or mousePos.Y > absolutePosition.Y + absoluteSize.Y then
			isMenuOpen = false
			MainFrame.Visible = false
		end
	end
end)
