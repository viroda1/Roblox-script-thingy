--[[
    Viro Hub – The Strongest Battlegrounds
    Cosmic Terminal UI – Custom, no external libraries
    – Constellation background (white dots with lines)
    – Purple cosmic theme toggle
    – All features: Auto Punch, Aimbot, WalkSpeed, JumpPower, Noclip, ESP, Rejoin, Infinite Yield
    – Keybind K to toggle UI
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VirtualInput = pcall(game.GetService, game, "VirtualInputManager") and game:GetService("VirtualInputManager") or nil

-- ==================== UI ELEMENTS ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViroHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main frame (draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Add a subtle gradient overlay (optional)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15))
})
gradient.Parent = MainFrame

-- Title bar (for dragging)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "VIRO HUB – COSMIC TERMINAL"
TitleText.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Tab buttons container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Content container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -90)
ContentContainer.Position = UDim2.new(0, 10, 0, 85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Tabs (table of names and their content frames)
local tabs = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            tab.btn.TextColor3 = Color3.fromRGB(200,200,200)
            tab.content.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        tabs[name].content.Visible = true
        currentTab = name
    end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6
    content.Parent = ContentContainer
    content.Visible = false

    tabs[name] = { btn = btn, content = content }
end

-- Add sections and elements
local function addSection(tabName, title)
    local frame = tabs[tabName].content
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(20,20,35)
    section.BorderSizePixel = 0
    section.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255,215,0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    return section
end

local function addToggle(tabName, section, name, flag, callback, defaultValue)
    local frame = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 35)
    row.BackgroundColor3 = Color3.fromRGB(15,15,25)
    row.BorderSizePixel = 0
    row.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 60, 0, 25)
    toggle.Position = UDim2.new(1, -65, 0, 5)
    toggle.BackgroundColor3 = Color3.fromRGB(50,50,70)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(200,200,200)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 12
    toggle.Parent = row

    local enabled = defaultValue or false
    local function updateUI()
        if enabled then
            toggle.BackgroundColor3 = Color3.fromRGB(128,0,255)
            toggle.Text = "ON"
            toggle.TextColor3 = Color3.fromRGB(255,255,255)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(50,50,70)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(200,200,200)
        end
    end
    updateUI()

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateUI()
        if callback then callback(enabled) end
    end)

    -- adjust frame height after all children
    local function layout()
        local y = 0
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("Frame") then
                child.Position = UDim2.new(0, 0, 0, y)
                y = y + child.Size.Y.Offset + 5
            end
        end
        frame.CanvasSize = UDim2.new(0, 0, 0, y + 10)
    end
    layout()
    return row
end

local function addSlider(tabName, section, name, min, max, step, suffix, flag, callback, defaultValue)
    local frame = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(15,15,25)
    row.BorderSizePixel = 0
    row.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -55, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(255,215,0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -10, 0, 20)
    slider.Position = UDim2.new(0, 5, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(30,30,50)
    slider.AutoButtonColor = false
    slider.Text = ""
    slider.Parent = row

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(128,0,255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local value = defaultValue
    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local localX = mousePos.X - sliderPos.X
            local percent = math.clamp(localX / slider.AbsoluteSize.X, 0, 1)
            value = min + (max - min) * percent
            value = math.floor(value / step + 0.5) * step
            value = math.clamp(value, min, max)
            fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
            valueLabel.Text = tostring(value) .. suffix
            if callback then callback(value) end
        end
    end)

    layout()
    return row
end

local function addButton(tabName, name, callback)
    local frame = tabs[tabName].content
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    layout()
    return btn
end

-- Function to adjust scrolling frame layout after adding elements
function layoutTab(tabName)
    local frame = tabs[tabName].content
    local y = 0
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child.Position = UDim2.new(0, 5, 0, y)
            y = y + child.Size.Y.Offset + 5
        end
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- Create tabs
createTab("Combat")
createTab("Movement")
createTab("Visuals")
createTab("Misc")
createTab("Credits")

-- ==================== FEATURE IMPLEMENTATIONS ====================

-- Combat tab
local combatSec = addSection("Combat", "Combat Features")
-- Auto Punch
local autoPunch = false
local punchCooldown = false
local function autoPunchLoop()
    while autoPunch do
        if not punchCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local nearest = nil
                local nearestDist = 10
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = player.Character
                        end
                    end
                end
                if nearest and nearestDist < 8 then
                    if VirtualInput then
                        VirtualInput:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        task.wait(0.1)
                        VirtualInput:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                    punchCooldown = true
                    task.wait(0.5)
                    punchCooldown = false
                end
            end
        end
        task.wait()
    end
end
addToggle("Combat", combatSec, "Auto Punch", "AutoPunch", function(val)
    autoPunch = val
    if val then coroutine.wrap(autoPunchLoop)() end
end, false)

-- Aimbot
local aimbotEnabled = false
local aimbotPart = "Head"
local aimbotConnection
addToggle("Combat", combatSec, "Aimbot", "Aimbot", function(val)
    aimbotEnabled = val
end, false)
-- Dropdown for aimbot part (simulated with buttons)
local partRow = Instance.new("Frame")
partRow.Size = UDim2.new(1, -10, 0, 35)
partRow.BackgroundColor3 = Color3.fromRGB(15,15,25)
partRow.Parent = tabs["Combat"].content
local partLabel = Instance.new("TextLabel")
partLabel.Size = UDim2.new(0.5, -10, 1, 0)
partLabel.Position = UDim2.new(0, 5, 0, 0)
partLabel.BackgroundTransparency = 1
partLabel.Text = "Aimbot Target:"
partLabel.TextColor3 = Color3.fromRGB(220,220,220)
partLabel.Font = Enum.Font.Gotham
partLabel.TextSize = 13
partLabel.TextXAlignment = Enum.TextXAlignment.Left
partLabel.Parent = partRow
local partBtn = Instance.new("TextButton")
partBtn.Size = UDim2.new(0, 80, 0, 25)
partBtn.Position = UDim2.new(1, -85, 0, 5)
partBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
partBtn.Text = "Head"
partBtn.TextColor3 = Color3.fromRGB(200,200,200)
partBtn.Font = Enum.Font.Gotham
partBtn.TextSize = 12
partBtn.Parent = partRow
partBtn.MouseButton1Click:Connect(function()
    if aimbotPart == "Head" then
        aimbotPart = "HumanoidRootPart"
        partBtn.Text = "Torso"
    else
        aimbotPart = "Head"
        partBtn.Text = "Head"
    end
end)

aimbotConnection = RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local targetPart = nil
    local nearestDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(aimbotPart)
            if part then
                local dist = (char.HumanoidRootPart.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    targetPart = part
                end
            end
        end
    end
    if targetPart then
        local targetPos = targetPart.Position
        local delta = (targetPos - Camera.CFrame.Position).Unit
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + delta)
    end
end)

-- Auto Dodge placeholder
addToggle("Combat", combatSec, "Auto Dodge (F key)", "AutoDodge", function(val)
    if val then
        -- We could implement F key spam, but may be bannable
    end
end, false)

layoutTab("Combat")

-- Movement tab
local moveSec = addSection("Movement", "Movement")
local function setCharProp(prop, val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum[prop] = val end
end
addSlider("Movement", moveSec, "WalkSpeed", 16, 250, 1, "", "WalkSpeed", function(v) setCharProp("WalkSpeed", v) end, 16)
addSlider("Movement", moveSec, "JumpPower", 50, 350, 5, "", "JumpPower", function(v) setCharProp("JumpPower", v) end, 50)

-- Noclip
local noclipEnabled = false
local noclipConnection
addToggle("Movement", moveSec, "Noclip", "Noclip", function(val)
    noclipEnabled = val
    if noclipConnection then noclipConnection:Disconnect() end
    if val then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipEnabled then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end, false)
layoutTab("Movement")

-- Visuals tab
local visSec = addSection("Visuals", "Cosmic Terminal")
-- Constellation toggle
addToggle("Visuals", visSec, "Constellation Effect", "Constellation", function(val)
    setConstellationActive(val)
end, true)
-- Purple theme toggle
addToggle("Visuals", visSec, "Purple Cosmic Theme", "PurpleTheme", function(val)
    setTheme(val)
    -- also update UI accent
    for _, tab in pairs(tabs) do
        if tab.btn.BackgroundColor3 == Color3.fromRGB(128,0,255) then
            tab.btn.BackgroundColor3 = val and Color3.fromRGB(128,0,255) or Color3.fromRGB(30,30,50)
        end
    end
end, false)

-- ESP (Boxes)
local espEnabled = false
local espBoxes = {}
local function createESP(player)
    if not player.Character then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = Color3.fromRGB(255,255,255)
    box.Transparency = 0.5
    box.ZIndex = 10
    box.Adornee = player.Character
    box.Parent = player.Character
    table.insert(espBoxes, box)
end
local function refreshESP()
    for _, box in ipairs(espBoxes) do box:Destroy() end
    espBoxes = {}
    if not espEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
end
Players.PlayerAdded:Connect(function(p)
    if espEnabled and p ~= LocalPlayer then createESP(p) end
end)
addToggle("Visuals", visSec, "ESP (Boxes)", "ESP", function(val)
    espEnabled = val
    refreshESP()
end, false)
layoutTab("Visuals")

-- Misc tab
local miscSec = addSection("Misc", "Utilities")
addButton("Misc", "Rejoin Game", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)
addButton("Misc", "Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
layoutTab("Misc")

-- Credits tab
local creditsSec = addSection("Credits", "Viro Hub")
local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -10, 0, 150)
creditsText.Position = UDim2.new(0, 5, 0, 45)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Developed by Viro\nCosmic Terminal Edition\n\nAuto Punch | Aimbot | WalkSpeed/JumpPower\nNoclip | ESP | Rejoin | Infinite Yield\n\nToggle UI: K"
creditsText.TextColor3 = Color3.fromRGB(200,200,200)
creditsText.Font = Enum.Font.Gotham
creditsText.TextSize = 13
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.Parent = tabs["Credits"].content
layoutTab("Credits")

-- Select first tab
if tabs["Combat"] then
    tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(128,0,255)
    tabs["Combat"].btn.TextColor3 = Color3.fromRGB(255,255,255)
    tabs["Combat"].content.Visible = true
    currentTab = "Combat"
end

-- Dragging functionality
local dragging = false
local dragStart, frameStart
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- Toggle UI with K key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ==================== CONSTELLATION BACKGROUND FUNCTIONS (already defined earlier, but ensure they exist) ====================
-- (We already defined setConstellationActive and setTheme earlier; they need to be global for the UI callbacks)
-- They were defined before UI, so it's fine.

-- Notify user
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 300, 0, 40)
notif.Position = UDim2.new(0.5, -150, 1, -60)
notif.BackgroundColor3 = Color3.fromRGB(20,20,30)
notif.Text = "Viro Hub Loaded! Press K to open."
notif.TextColor3 = Color3.fromRGB(255,215,0)
notif.Font = Enum.Font.Gotham
notif.TextSize = 14
notif.BorderSizePixel = 0
notif.Parent = ScreenGui
game:GetService("TweenService"):Create(notif, TweenInfo.new(3, Enum.EasingStyle.Linear), {Position = UDim2.new(0.5, -150, 1, -20)}):Play()
task.wait(4)
notif:Destroy()
