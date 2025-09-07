--[[
    sh-hack ESP Menu
    developed by shadexqz
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ESP Settings
local ESPSettings = {
    Enabled = false,
    TeamCheck = true
}

-- GUI
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

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MenuFrame

-- Tabs bar
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

-- Tab buttons
local MainTabBtn = createTabButton("Main", 10)
local VisualsTabBtn = createTabButton("Visuals", 120)

-- Content frames
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

-- Main tab content
local MainLabel = Instance.new("TextLabel")
MainLabel.Size = UDim2.new(1, 0, 0, 30)
MainLabel.BackgroundTransparency = 1
MainLabel.Text = "in dev :)"
MainLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
MainLabel.Font = Enum.Font.Code
MainLabel.TextSize = 18
MainLabel.Parent = MainContent

-- Visuals tab content
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

-- Tab switching
MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    VisualsContent.Visible = false
end)

VisualsTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    VisualsContent.Visible = true
end)

-- Insert key toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
        MenuFrame.Visible = not MenuFrame.Visible
    end
end)

print("sh-hack menu loaded!")
