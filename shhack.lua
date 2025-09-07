--[[
    sh-hack ESP Script
    Только учебный пример
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки ESP
local ESPSettings = {
    Enabled = true,
    TeamCheck = true,
    BoxColor = Color3.fromRGB(0, 255, 0),
    OutlineColor = Color3.fromRGB(0, 0, 0),
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "sh-hack_GUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Меню
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 220, 0, 150)
MenuFrame.Position = UDim2.new(0, 50, 0, -200)
MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "sh-hack"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MenuFrame

-- Кнопка ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 200, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 50)
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ESPButton.Text = "ESP: ON"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.Gotham
ESPButton.TextSize = 18
ESPButton.Parent = MenuFrame

ESPButton.MouseButton1Click:Connect(function()
    ESPSettings.Enabled = not ESPSettings.Enabled
    ESPButton.Text = ESPSettings.Enabled and "ESP: ON" or "ESP: OFF"
end)

-- Анимация открытия/закрытия INS
local MenuOpen = false
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MenuOpen = not MenuOpen
        if MenuOpen then
            MenuFrame:TweenPosition(UDim2.new(0, 50, 0, 50), "Out", "Sine", 0.5, true)
        else
            MenuFrame:TweenPosition(UDim2.new(0, 50, 0, -200), "In", "Sine", 0.5, true)
        end
    end
end)

-- ESP Box
local function CreateESPBox(player)
    local box = Instance.new("Frame")
    box.Name = player.Name .. "_ESP"
    box.BackgroundColor3 = ESPSettings.BoxColor
    box.BorderColor3 = ESPSettings.OutlineColor
    box.BorderSizePixel = 2
    box.AnchorPoint = Vector2.new(0.5, 0.5)
    box.Visible = true
    box.Parent = ScreenGui
    return box
end

local ESPBoxes = {}

RunService.RenderStepped:Connect(function()
    if not ESPSettings.Enabled then
        for _, box in pairs(ESPBoxes) do
            box.Visible = false
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
                if ESPBoxes[player] then
                    ESPBoxes[player].Visible = false
                end
            else
                if not ESPBoxes[player] then
                    ESPBoxes[player] = CreateESPBox(player)
                end

                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        ESPBoxes[player].Position = UDim2.new(0, pos.X, 0, pos.Y)
                        ESPBoxes[player].Size = UDim2.new(0, 60, 0, 120)
                        ESPBoxes[player].Visible = true
                    else
                        ESPBoxes[player].Visible = false
                    end
                else
                    ESPBoxes[player].Visible = false
                end
            end
        end
    end
end)
