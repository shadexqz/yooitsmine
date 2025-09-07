local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ESPSettings = {
    Enabled = false,
    TeamCheck = true
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "shhack_GUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 400, 0, 300)
MenuFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MenuFrame.BorderSizePixel = 0
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Visible = true
MenuFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MenuFrame

local TabsBar = Instance.new("Frame")
TabsBar.Size = UDim2.new(1, 0, 0, 30)
TabsBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TabsBar.BorderSizePixel = 0
TabsBar.Parent = MenuFrame

local function createTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.Code
    btn.TextSize = 16
    btn.Parent = TabsBar
    return btn
end

local MainTabBtn = createTabButton("Main", 10)
local VisualsTabBtn = createTabButton("Visuals", 120)

local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, -20, 1, -40)
MainContent.Position = UDim2.new(0, 10, 0, 40)
MainContent.BackgroundTransparency = 1
MainContent.Visible = true
MainContent.Parent = MenuFrame

local VisualsContent = Instance.new("Frame")
VisualsContent.Size = UDim2.new(1, -20, 1, -40)
VisualsContent.Position = UDim2.new(0, 10, 0, 40)
VisualsContent.BackgroundTransparency = 1
VisualsContent.Visible = false
VisualsContent.Parent = MenuFrame

local MainLabel = Instance.new("TextLabel")
MainLabel.Size = UDim2.new(1, 0, 0, 30)
MainLabel.BackgroundTransparency = 1
MainLabel.Text = "sh-hack"
MainLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
MainLabel.Font = Enum.Font.Code
MainLabel.TextSize = 18
MainLabel.Parent = MainContent

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(1, -20, 0, 40)
ESPButton.Position = UDim2.new(0, 10, 0, 10)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Font = Enum.Font.Code
ESPButton.TextSize = 16
ESPButton.Parent = VisualsContent

ESPButton.MouseButton1Click:Connect(function()
    ESPSettings.Enabled = not ESPSettings.Enabled
    ESPButton.Text = ESPSettings.Enabled and "ESP: ON" or "ESP: OFF"
    ESPButton.BackgroundColor3 = ESPSettings.Enabled and Color3.fromRGB(60, 100, 160) or Color3.fromRGB(40, 40, 55)
end)

local TeamCheckButton = Instance.new("TextButton")
TeamCheckButton.Size = UDim2.new(1, -20, 0, 40)
TeamCheckButton.Position = UDim2.new(0, 10, 0, 60)
TeamCheckButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TeamCheckButton.Text = "Team Check: ON"
TeamCheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamCheckButton.Font = Enum.Font.Code
TeamCheckButton.TextSize = 16
TeamCheckButton.Parent = VisualsContent

TeamCheckButton.MouseButton1Click:Connect(function()
    ESPSettings.TeamCheck = not ESPSettings.TeamCheck
    TeamCheckButton.Text = ESPSettings.TeamCheck and "Team Check: ON" or "Team Check: OFF"
    TeamCheckButton.BackgroundColor3 = ESPSettings.TeamCheck and Color3.fromRGB(60, 100, 160) or Color3.fromRGB(40, 40, 55)
end)

MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    VisualsContent.Visible = false
end)

VisualsTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    VisualsContent.Visible = true
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
        MenuFrame.Visible = not MenuFrame.Visible
    end
end)

local highlights = {}

local function createHighlight(player)
    if player == LocalPlayer then return end
    if highlights[player] then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.7
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.Parent = player.Character or player.CharacterAdded:Wait()
    highlights[player] = highlight
end

local function removeHighlight(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not ESPSettings.Enabled then
        for _, hl in pairs(highlights) do
            hl.Enabled = false
        end
        return
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createHighlight(player)
            local highlight = highlights[player]
            if highlight then
                highlight.Parent = player.Character
                highlight.Enabled = true
                if ESPSettings.TeamCheck and player.Team == LocalPlayer.Team then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                    highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                else
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)

print("sh-hack loaded")
