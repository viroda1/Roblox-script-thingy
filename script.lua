--[[
    Viro Hub – The Strongest Battlegrounds
    Mobile-friendly version with floating V button and all original features
    – Tap V button (or press K on keyboard) to open/close menu
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VirtualInput = pcall(game.GetService, game, "VirtualInputManager") and game:GetService("VirtualInputManager") or nil

-- ==================== UI PARENT (MOBILE SAFE) ====================
local guiParent = game.CoreGui
if not guiParent then
    guiParent = LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViroHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent

-- ==================== FLOATING TOGGLE BUTTON (for mobile) ====================
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -70, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
toggleButton.Text = "V"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 28
toggleButton.BorderSizePixel = 0
toggleButton.Parent = ScreenGui

-- ==================== MAIN MENU ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false  -- start hidden
MainFrame.Parent = ScreenGui

-- Add gradient (optional)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15))
})
gradient.Parent = MainFrame

-- Title bar (draggable)
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

-- Tab container
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

-- Tabs table
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

-- Helper UI functions
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
    row.Size = UDim2.new(1, -10, 0, 40) -- slightly taller for touch
    row.BackgroundColor3 = Color3.fromRGB(15,15,25)
    row.BorderSizePixel = 0
    row.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 70, 0, 30)
    toggle.Position = UDim2.new(1, -75, 0, 5)
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

    return row
end

local function addSlider(tabName, section, name, min, max, step, suffix, flag, callback, defaultValue)
    local frame = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 65)
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
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(255,215,0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -10, 0, 25)
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

    return row
end

local function addButton(tabName, name, callback)
    local frame = tabs[tabName].content
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

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

-- ==================== FEATURE IMPLEMENTATIONS (from original script) ====================

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

-- Dropdown for aimbot part
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
        -- optional: implement F key spam if needed
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

-- Constellation background (must be defined before toggles)
local constellationCanvas = Instance.new("Frame")
constellationCanvas.Size = UDim2.new(1, 0, 1, 0)
constellationCanvas.BackgroundTransparency = 1
constellationCanvas.ZIndex = 0
constellationCanvas.Parent = ScreenGui

local stars = {}
local lines = {}
local constellationActive = true
local themeColor = Color3.fromRGB(255, 255, 255)

local function generateStars()
    for i = 1, 100 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, 2, 0, 2)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = themeColor
        star.BorderSizePixel = 0
        star.BackgroundTransparency = math.random(30, 80) / 100
        star.Parent = constellationCanvas
        table.insert(stars, star)
    end
end

local function drawLines()
    for _, line in ipairs(lines) do line:Destroy() end
    lines = {}
    if not constellationActive then return end
    for i = 1, #stars do
        for j = i+1, #stars do
            local posA = stars[i].AbsolutePosition
            local posB = stars[j].AbsolutePosition
            local dx, dy = posA.X - posB.X, posA.Y - posB.Y
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist < 150 then
                local line = Instance.new("Frame")
                line.Size = UDim2.new(0, dist, 0, 1)
                line.Position = UDim2.new(0, posA.X, 0, posA.Y)
                line.Rotation = math.deg(math.atan2(dy, dx))
                line.BackgroundColor3 = themeColor
                line.BackgroundTransparency = 0.5
                line.BorderSizePixel = 0
                line.Parent = constellationCanvas
                table.insert(lines, line)
            end
        end
    end
end

generateStars()
drawLines()
UserInputService.WindowSizeChanged:Connect(drawLines)

local function setConstellationActive(active)
    constellationActive = active
    constellationCanvas.Visible = active
    if active then drawLines() end
end

local function setTheme(purple)
    themeColor = purple and Color3.fromRGB(128,0,255) or Color3.fromRGB(255,255,255)
    for _, star in ipairs(stars) do star.BackgroundColor3 = themeColor end
    drawLines()
end

-- Toggles for constellation and theme
addToggle("Visuals", visSec, "Constellation Effect", "Constellation", function(val)
    setConstellationActive(val)
end, true)
addToggle("Visuals", visSec, "Purple Cosmic Theme", "PurpleTheme", function(val)
    setTheme(val)
    -- Also update UI accent for active tab
    for _, tab in pairs(tabs) do
        if tab.btn.BackgroundColor3 == Color3.fromRGB(128,0,255) then
            tab.btn.BackgroundColor3 = val and Color3.fromRGB(128,0,255) or Color3.fromRGB(30,30,50)
        end
    end
end, false)

-- ESP
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
Players.Pl
