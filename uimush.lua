-- ============= КЛИЕНТСКИЙ UI ДЛЯ ГРИБОВ =============
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Получаем RemoteEvents
local mushroomSystem = ReplicatedStorage:WaitForChild("MushroomSystem")
local remoteEvents = mushroomSystem:WaitForChild("RemoteEvents")
local showMushroomUI = remoteEvents:WaitForChild("ShowMushroomUI")
local mushroomAction = remoteEvents:WaitForChild("MushroomAction")

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MushroomGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

local currentMushroom = nil

-- Функция создания UI
local function createUI(data)
	screenGui:ClearAllChildren()
	currentMushroom = data.Mushroom

	-- Затемнение
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.new(0, 0, 0)
	bg.BackgroundTransparency = 0.7
	bg.Parent = screenGui

	-- Главное окно
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 500, 0, 600)
	frame.Position = UDim2.new(0.5, -250, 0.5, -300)
	frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	frame.BorderSizePixel = 0
	frame.Parent = bg

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	-- Заголовок
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 70)
	title.BackgroundTransparency = 1
	title.Text = data.IsPoisonous and "☠️ ЯДОВИТЫЙ ГРИБ!" or "🍄 СЪЕДОБНЫЙ ГРИБ"
	title.TextColor3 = data.IsPoisonous and Color3.new(1, 0.3, 0.3) or Color3.new(0.3, 1, 0.3)
	title.TextSize = 32
	title.Font = Enum.Font.GothamBold
	title.Parent = frame

	-- Картинка
	local imageFrame = Instance.new("Frame")
	imageFrame.Size = UDim2.new(0.8, 0, 0, 350)
	imageFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
	imageFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	imageFrame.Parent = frame

	local imageCorner = Instance.new("UICorner")
	imageCorner.CornerRadius = UDim.new(0, 8)
	imageCorner.Parent = imageFrame

	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, -20, 1, -20)
	image.Position = UDim2.new(0, 10, 0, 10)
	image.BackgroundTransparency = 1
	image.Image = data.ImageId
	image.ScaleType = Enum.ScaleType.Fit
	image.Parent = imageFrame

	-- Кнопки
	local btnFrame = Instance.new("Frame")
	btnFrame.Size = UDim2.new(1, 0, 0, 100)
	btnFrame.Position = UDim2.new(0, 0, 0.75, 0)
	btnFrame.BackgroundTransparency = 1
	btnFrame.Parent = frame

	local function createButton(name, text, posX, color)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0.28, 0, 0, 50)
		btn.Position = UDim2.new(posX, 0, 0.2, 0)
		btn.BackgroundColor3 = color
		btn.Text = text
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 22
		btn.Font = Enum.Font.GothamBold
		btn.Parent = btnFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		return btn
	end

	local takeBtn = createButton("TakeButton", "ЗАБРАТЬ", 0.05, Color3.new(0.2, 0.5, 1))
	local eatBtn = createButton("EatButton", "СЪЕСТЬ", 0.36, Color3.new(0.2, 0.8, 0.2))
	local dropBtn = createButton("DropButton", "ВЫКИНУТЬ", 0.67, Color3.new(1, 0.3, 0.3))

	takeBtn.MouseButton1Click:Connect(function()
		mushroomAction:FireServer("take", currentMushroom)
		screenGui.Enabled = false
	end)

	eatBtn.MouseButton1Click:Connect(function()
		mushroomAction:FireServer("eat", currentMushroom)
		screenGui.Enabled = false
	end)

	dropBtn.MouseButton1Click:Connect(function()
		mushroomAction:FireServer("drop", currentMushroom)
		screenGui.Enabled = false
	end)

	-- Кнопка закрытия
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 36, 0, 36)
	closeBtn.Position = UDim2.new(1, -46, 0, 10)
	closeBtn.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.new(1, 1, 1)
	closeBtn.TextSize = 24
	closeBtn.Parent = frame

	closeBtn.MouseButton1Click:Connect(function()
		screenGui.Enabled = false
	end)

	screenGui.Enabled = true
end

-- Получаем сигнал от сервера
showMushroomUI.OnClientEvent:Connect(function(data)
	createUI(data)
end)

print("🎮 UI грибов загружен")
