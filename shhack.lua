--[[
    sh-hack ESP (Highlight version)
    developed by shadexqz
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Настройки
local ESPSettings = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 1500
}

-- Цвета
local CTColor = Color3.fromRGB(0, 150, 255) -- Свои (синие)
local TColor = Color3.fromRGB(255, 50, 50)  -- Враги (красные)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "shhack_GUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Главное меню
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 280, 0, 160)
MenuFrame.Position = UDim2.new(0, 50, 0, 50)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MenuFrame.BorderSizePixel = 0
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MenuFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Title.Text = "sh-hack ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.Parent = MenuFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Кнопка ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 50)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.Code
ESPButton.TextSize = 16
ESPButton.Parent = MenuFrame

local ESPBtnCorner = Instance.new("UICorner")
ESPBtnCorner.CornerRadius = UDim.new(0, 8)
ESPBtnCorner.Parent = ESPButton

ESPButton.MouseButton1Click:Connect(function()
    ESPSettings.Enabled = not ESPSettings.Enabled
    ESPButton.Text = ESPSettings.Enabled and "ESP: ON" or "ESP: OFF"
    ESPButton.BackgroundColor3 = ESPSettings.Enabled and Color3.fromRGB(50, 90, 140) or Color3.fromRGB(40, 40, 55)
end)

-- Кнопка TeamCheck
local TeamCheckButton = Instance.new("TextButton")
TeamCheckButton.Size = UDim2.new(1, -20, 0, 40)
TeamCheckButton.Position = UDim2.new(0, 10, 0, 100)
TeamCheckButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TeamCheckButton.Text = "Team Check: ON"
TeamCheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamCheckButton.Font = Enum.Font.Code
TeamCheckButton.TextSize = 16
TeamCheckButton.Parent = MenuFrame

local TeamBtnCorner = Instance.new("UICorner")
TeamBtnCorner.CornerRadius = UDim.new(0, 8)
TeamBtnCorner.Parent = TeamCheckButton

TeamCheckButton.MouseButton1Click:Connect(function()
    ESPSettings.TeamCheck = not ESPSettings.TeamCheck
    TeamCheckButton.Text = ESPSettings.TeamCheck and "Team Check: ON" or "Team Check: OFF"
    TeamCheckButton.BackgroundColor3 = ESPSettings.TeamCheck and Color3.fromRGB(50, 90, 140) or Color3.fromRGB(40, 40, 55)
end)

-- Подпись снизу
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.BackgroundTransparency = 1
Footer.Text = "developed by shadexqz"
Footer.TextColor3 = Color3.fromRGB(160, 160, 160)
Footer.Font = Enum.Font.Code
Footer.TextSize = 12
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Parent = MenuFrame

-- ========== ESP через Highlight ==========
local ESPObjects = {}

local function CreateHighlight(player)
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = game:GetService("CoreGui")
    ESPObjects[player] = highlight
    return highlight
end

local function UpdateHighlight(player)
    if not player.Character then return end
    if not ESPObjects[player] then
        CreateHighlight(player)
    end

    local highlight = ESPObjects[player]
    highlight.Adornee = player.Character

    -- Цвет в зависимости от команды
    if player.Team == LocalPlayer.Team and ESPSettings.TeamCheck then
        highlight.FillColor = CTColor
        highlight.OutlineColor = CTColor
    else
        highlight.FillColor = TColor
        highlight.OutlineColor = TColor
    end
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        if ESPSettings.Enabled then
            UpdateHighlight(player)
            if ESPObjects[player] then
                ESPObjects[player].Enabled = true
            end
        else
            if ESPObjects[player] then
                ESPObjects[player].Enabled = false
            end
        end
    end
end)

-- Удаление ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end)

print("sh-hack ESP (Highlight) loaded!")
