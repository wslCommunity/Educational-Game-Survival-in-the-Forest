-- Configuration
local cycleTimes = {
	sunrise = 1,  -- 1 minute
	afternoon = 5, -- 5 minutes
	sunset = 1,    -- 1 minute
	night = 3      -- 3 minutes
}

local healthLossPercentage = {
	day = 13,      -- 13% of remaining HP lost during the day
	night = 20     -- 20% of remaining HP lost during the night
}

-- Variables
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local currentCycle = "sunrise"
local cycleStartTime = os.time()

-- Function to update lighting based on the current cycle
local function updateLighting()
	if currentCycle == "sunrise" then
		-- Sunrise: Bright, warm lighting
		lighting.ClockTime = 6
		lighting.Brightness = 0.8
		lighting.Ambient = Color3.new(0.5, 0.5, 0.5) -- Neutral ambient light
		lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5) -- Neutral outdoor light
		lighting.GlobalShadows = true
	elseif currentCycle == "afternoon" then
		-- Afternoon: Bright, neutral lighting
		lighting.ClockTime = 12
		lighting.Brightness = 1
		lighting.Ambient = Color3.new(0.5, 0.5, 0.5) -- Neutral ambient light
		lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5) -- Neutral outdoor light
		lighting.GlobalShadows = true
	elseif currentCycle == "sunset" then
		-- Sunset: Dim, warm lighting
		lighting.ClockTime = 18
		lighting.Brightness = 0.6
		lighting.Ambient = Color3.new(0.5, 0.5, 0.5) -- Neutral ambient light
		lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5) -- Neutral outdoor light
		lighting.GlobalShadows = true
	elseif currentCycle == "night" then
		-- Night: Dark, no light
		lighting.ClockTime = 0
		lighting.Brightness = 0.1 -- Very dark
		lighting.Ambient = Color3.new(0.1, 0.1, 0.1) -- Dark ambient light
		lighting.OutdoorAmbient = Color3.new(0.1, 0.1, 0.1) -- Dark outdoor light
		lighting.GlobalShadows = false -- No shadows
	end
end
