--[[
    sh-hack ESP Script с красивой обводкой
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
    GlowIntensity = 10,
    OutlineThickness = 2,
}

-- Цвета
local CTColor = Color3.fromRGB(0, 100, 255)  -- Синий для контр-террористов
local TColor = Color3.fromRGB(255, 50, 50)   -- Красный для террористов

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "sh-hack_GUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Создание красивого меню
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 300, 0, 40)
MenuFrame.Position = UDim2.new(0, 50, 0, -200)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MenuFrame.BorderSizePixel = 0
MenuFrame.ClipsDescendants = true
MenuFrame.Parent = ScreenGui

-- Создание закругленных углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MenuFrame

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "sh-hack v1.0"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MenuFrame
Title.PaddingLeft = UDim.new(0, 15)

-- Контент меню (скрыт по умолчанию)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 110)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MenuFrame

-- Кнопка ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 10)
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ESPButton.Text = "ESP: ON"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.Gotham
ESPButton.TextSize = 16
ESPButton.Parent = ContentFrame

-- Закругление кнопки
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ESPButton

-- Переключатель проверки команды
local TeamCheckButton = Instance.new("TextButton")
TeamCheckButton.Size = UDim2.new(1, -20, 0, 40)
TeamCheckButton.Position = UDim2.new(0, 10, 0, 60)
TeamCheckButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
TeamCheckButton.Text = "Team Check: ON"
TeamCheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamCheckButton.Font = Enum.Font.Gotham
TeamCheckButton.TextSize = 16
TeamCheckButton.Parent = ContentFrame

-- Закругление кнопки
local TeamButtonCorner = Instance.new("UICorner")
TeamButtonCorner.CornerRadius = UDim.new(0, 6)
TeamButtonCorner.Parent = TeamCheckButton

-- Функции для кнопок
ESPButton.MouseButton1Click:Connect(function()
    ESPSettings.Enabled = not ESPSettings.Enabled
    ESPButton.Text = ESPSettings.Enabled and "ESP: ON" or "ESP: OFF"
    ESPButton.BackgroundColor3 = ESPSettings.Enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(80, 80, 100)
end)

TeamCheckButton.MouseButton1Click:Connect(function()
    ESPSettings.TeamCheck = not ESPSettings.TeamCheck
    TeamCheckButton.Text = ESPSettings.TeamCheck and "Team Check: ON" or "Team Check: OFF"
    TeamCheckButton.BackgroundColor3 = ESPSettings.TeamCheck and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(80, 80, 100)
end)

-- Анимация открытия/закрытия меню
local MenuOpen = false
local MenuTween

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuOpen = not MenuOpen
        
        if MenuTween then
            MenuTween:Cancel()
        end
        
        if MenuOpen then
            MenuFrame.Size = UDim2.new(0, 300, 0, 150)
            MenuTween = TweenService:Create(
                MenuFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 50, 0, 50)}
            )
        else
            MenuFrame.Size = UDim2.new(0, 300, 0, 40)
            MenuTween = TweenService:Create(
                MenuFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 50, 0, -200)}
            )
        end
        
        MenuTween:Play()
    end
end)

-- Создание обводки для игрока
local function CreateESPOutline(player)
    local outline = Drawing.new("Square")
    outline.Visible = false
    outline.Color = player.Team and player.Team.Name == "Counter Terrorists" and CTColor or TColor
    outline.Thickness = ESPSettings.OutlineThickness
    outline.Filled = false
    outline.Transparency = 1
    outline.ZIndex = 1
    
    return outline
end

local ESPOutlines = {}

-- Функция для обновления позиции и размера обводки
local function UpdateESPOutline(player, outline, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local head = character:FindFirstChild("Head")
    if not head then return false end
    
    -- Получаем позиции частей тела
    local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
    local headPos, headVis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    
    if not rootVis or not headVis then return false end
    
    -- Вычисляем размеры обводки
    local height = (rootPos.Y - headPos.Y) * 2
    local width = height * 0.6
    
    -- Устанавливаем позицию и размер
    outline.Size = Vector2.new(width, height)
    outline.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
    
    -- Устанавливаем цвет в зависимости от команды
    if player.Team then
        if player.Team.Name == "Counter Terrorists" then
            outline.Color = CTColor
        elseif player.Team.Name == "Terrorists" then
            outline.Color = TColor
        else
            outline.Color = Color3.fromRGB(255, 255, 255)
        end
    end
    
    return true
end

-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
    if not ESPSettings.Enabled then
        for _, outline in pairs(ESPOutlines) do
            outline.Visible = false
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
            if ESPOutlines[player] then
                ESPOutlines[player].Visible = false
            end
            continue
        end
        
        local character = player.Character
        if not character then
            if ESPOutlines[player] then
                ESPOutlines[player].Visible = false
            end
            continue
        end
        
        if not ESPOutlines[player] then
            ESPOutlines[player] = CreateESPOutline(player)
        end
        
        local success = UpdateESPOutline(player, ESPOutlines[player], character)
        ESPOutlines[player].Visible = success
    end
end)

-- Очистка при удалении игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPOutlines[player] then
        ESPOutlines[player]:Remove()
        ESPOutlines[player] = nil
    end
end)

-- Первоначальная настройка позиции меню
MenuFrame.Position = UDim2.new(0, 50, 0, -200)
