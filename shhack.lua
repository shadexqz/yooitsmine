--[[
    sh-hack Premium ESP Script
    Только учебный пример
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки ESP
local ESPSettings = {
    Enabled = true,
    TeamCheck = true,
    GlowIntensity = 0.8,
    OutlineThickness = 2,
    MaxDistance = 1000
}

-- Цвета
local CTColor = Color3.fromRGB(0, 150, 255)  -- Синий для контр-террористов
local TColor = Color3.fromRGB(255, 50, 50)   -- Красный для террористов

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "sh-hack_Premium_GUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Создание красивого хакерского меню
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 320, 0, 40)
MenuFrame.Position = UDim2.new(0, 50, 0, 50)
MenuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MenuFrame.BorderSizePixel = 0
MenuFrame.ClipsDescendants = true
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Parent = ScreenGui

-- Эффект переливающегося заголовка
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 255))
})
TitleGradient.Rotation = 90

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "sh-hack v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MenuFrame
Title.PaddingLeft = UDim.new(0, 15)
Title.ZIndex = 2
Title.UIGradient = TitleGradient

-- Анимация градиента
spawn(function()
    while true do
        for i = 0, 360, 2 do
            if Title and Title.UIGradient then
                Title.UIGradient.Rotation = i
            end
            wait(0.05)
        end
    end
end)

-- Контент меню
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 180)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MenuFrame

-- Разделитель
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 40)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Divider.BorderSizePixel = 0
Divider.Parent = MenuFrame

-- Кнопка ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 10)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ESPButton.Text = "ESP: ON"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.Code
ESPButton.TextSize = 16
ESPButton.Parent = ContentFrame

-- Переключатель проверки команды
local TeamCheckButton = Instance.new("TextButton")
TeamCheckButton.Size = UDim2.new(1, -20, 0, 40)
TeamCheckButton.Position = UDim2.new(0, 10, 0, 60)
TeamCheckButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TeamCheckButton.Text = "Team Check: ON"
TeamCheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamCheckButton.Font = Enum.Font.Code
TeamCheckButton.TextSize = 16
TeamCheckButton.Parent = ContentFrame

-- Слайдер для интенсивности свечения
local GlowIntensityLabel = Instance.new("TextLabel")
GlowIntensityLabel.Size = UDim2.new(1, -20, 0, 20)
GlowIntensityLabel.Position = UDim2.new(0, 10, 0, 110)
GlowIntensityLabel.BackgroundTransparency = 1
GlowIntensityLabel.Text = "Glow Intensity: " .. ESPSettings.GlowIntensity
GlowIntensityLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
GlowIntensityLabel.Font = Enum.Font.Code
GlowIntensityLabel.TextSize = 14
GlowIntensityLabel.TextXAlignment = Enum.TextXAlignment.Left
GlowIntensityLabel.Parent = ContentFrame

local GlowSlider = Instance.new("Frame")
GlowSlider.Size = UDim2.new(1, -20, 0, 5)
GlowSlider.Position = UDim2.new(0, 10, 0, 135)
GlowSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
GlowSlider.BorderSizePixel = 0
GlowSlider.Parent = ContentFrame

local GlowSliderFill = Instance.new("Frame")
GlowSliderFill.Size = UDim2.new(ESPSettings.GlowIntensity, 0, 1, 0)
GlowSliderFill.Position = UDim2.new(0, 0, 0, 0)
GlowSliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
GlowSliderFill.BorderSizePixel = 0
GlowSliderFill.Parent = GlowSlider

local GlowSliderButton = Instance.new("TextButton")
GlowSliderButton.Size = UDim2.new(0, 15, 0, 15)
GlowSliderButton.Position = UDim2.new(ESPSettings.GlowIntensity, 0, 0, -5)
GlowSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlowSliderButton.Text = ""
GlowSliderButton.Parent = GlowSlider

-- Функции для кнопок
ESPButton.MouseButton1Click:Connect(function()
    ESPSettings.Enabled = not ESPSettings.Enabled
    ESPButton.Text = ESPSettings.Enabled and "ESP: ON" or "ESP: OFF"
    ESPButton.BackgroundColor3 = ESPSettings.Enabled and Color3.fromRGB(40, 80, 120) or Color3.fromRGB(40, 40, 50)
end)

TeamCheckButton.MouseButton1Click:Connect(function()
    ESPSettings.TeamCheck = not ESPSettings.TeamCheck
    TeamCheckButton.Text = ESPSettings.TeamCheck and "Team Check: ON" or "Team Check: OFF"
    TeamCheckButton.BackgroundColor3 = ESPSettings.TeamCheck and Color3.fromRGB(40, 80, 120) or Color3.fromRGB(40, 40, 50)
end)

-- Функция для слайдера
local function updateGlowIntensity(value)
    ESPSettings.GlowIntensity = math.clamp(value, 0.1, 1)
    GlowIntensityLabel.Text = "Glow Intensity: " .. string.format("%.1f", ESPSettings.GlowIntensity)
    GlowSliderFill.Size = UDim2.new(ESPSettings.GlowIntensity, 0, 1, 0)
    GlowSliderButton.Position = UDim2.new(ESPSettings.GlowIntensity, 0, 0, -5)
end

local sliding = false
GlowSliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = GuiService:GetGuiInset().X + GlowSlider.AbsolutePosition.X
        local relative = (input.Position.X - pos) / GlowSlider.AbsoluteSize.X
        updateGlowIntensity(relative)
    end
end)

-- Создание 3D glow обводки для игрока
local function CreateESPOutline(player)
    local outline = Drawing.new("Square")
    outline.Visible = false
    outline.Color = player.Team and player.Team.Name == "Counter Terrorists" and CTColor or TColor
    outline.Thickness = ESPSettings.OutlineThickness
    outline.Filled = false
    outline.Transparency = 1
    outline.ZIndex = 1
    
    -- Создаем эффект свечения с помощью нескольких контуров
    local glowLayers = {}
    for i = 1, 3 do
        local glow = Drawing.new("Square")
        glow.Visible = false
        glow.Color = player.Team and player.Team.Name == "Counter Terrorists" and CTColor or TColor
        glow.Thickness = ESPSettings.OutlineThickness + (i * 1.5)
        glow.Filled = false
        glow.Transparency = 0.8 - (i * 0.2)
        glow.ZIndex = 0
        table.insert(glowLayers, glow)
    end
    
    return {
        main = outline,
        glow = glowLayers
    }
end

local ESPOutlines = {}

-- Функция для обновления позиции и размера обводки
local function UpdateESPOutline(player, outline, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local head = character:FindFirstChild("Head")
    if not head then return false end
    
    -- Проверка расстояния
    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                     (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0)
    
    if distance > ESPSettings.MaxDistance then
        return false
    end
    
    -- Получаем позиции частей тела
    local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
    local headPos, headVis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    
    if not rootVis or not headVis then return false end
    
    -- Вычисляем размеры обводки
    local height = (rootPos.Y - headPos.Y) * 2.2
    local width = height * 0.6
    
    -- Устанавливаем позицию и размер
    outline.main.Size = Vector2.new(width, height)
    outline.main.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
    
    -- Обновляем glow слои
    for i, glow in ipairs(outline.glow) do
        glow.Size = Vector2.new(width + (i * 4), height + (i * 4))
        glow.Position = Vector2.new(rootPos.X - (width/2) - (i * 2), rootPos.Y - (height/2) - (i * 2))
    end
    
    -- Устанавливаем цвет в зависимости от команды
    local outlineColor
    if player.Team then
        if player.Team.Name == "Counter Terrorists" then
            outlineColor = CTColor
        elseif player.Team.Name == "Terrorists" then
            outlineColor = TColor
        else
            outlineColor = Color3.fromRGB(255, 255, 255)
        end
    else
        outlineColor = Color3.fromRGB(255, 255, 255)
    end
    
    outline.main.Color = outlineColor
    for _, glow in ipairs(outline.glow) do
        glow.Color = outlineColor
        glow.Transparency = 1 - ESPSettings.GlowIntensity
    end
    
    return true
end

-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
    if not ESPSettings.Enabled then
        for _, outline in pairs(ESPOutlines) do
            outline.main.Visible = false
            for _, glow in ipairs(outline.glow) do
                glow.Visible = false
            end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
            if ESPOutlines[player] then
                ESPOutlines[player].main.Visible = false
                for _, glow in ipairs(ESPOutlines[player].glow) do
                    glow.Visible = false
                end
            end
            continue
        end
        
        local character = player.Character
        if not character then
            if ESPOutlines[player] then
                ESPOutlines[player].main.Visible = false
                for _, glow in ipairs(ESPOutlines[player].glow) do
                    glow.Visible = false
                end
            end
            continue
        end
        
        if not ESPOutlines[player] then
            ESPOutlines[player] = CreateESPOutline(player)
        end
        
        local success = UpdateESPOutline(player, ESPOutlines[player], character)
        ESPOutlines[player].main.Visible = success
        for _, glow in ipairs(ESPOutlines[player].glow) do
            glow.Visible = success
        end
    end
end)

-- Очистка при удалении игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPOutlines[player] then
        ESPOutlines[player].main:Remove()
        for _, glow in ipairs(ESPOutlines[player].glow) do
            glow:Remove()
        end
        ESPOutlines[player] = nil
    end
end)

-- Уведомление о загрузке
print("sh-hack Premium ESP loaded! Press Insert to toggle menu")
