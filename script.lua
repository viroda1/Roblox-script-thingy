--[[
    Viro Hub – The Strongest Battlegrounds (Ultimate Edition)
    – Cosmic terminal style (black + white outline, 5 stars with lines)
    – Full PC & mobile compatibility
    – Features: Auto Punch, Auto Dodge, Aimbot, WalkSpeed, JumpPower, Noclip, Fly, Fling, Anti-Fling, Teleports, Spawn Kill, ESP, No Fog, Full Bright, Infinite Yield, Rejoin, Reset
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VirtualInput = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

-- UI Parent (safe for both PC and mobile)
local guiParent = game.CoreGui
if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViroHubUltimate"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- ==================== COSMIC BACKGROUND (5 STARS + LINES) ====================
local cosmicCanvas = Instance.new("Frame")
cosmicCanvas.Size = UDim2.new(1, 0, 1, 0)
cosmicCanvas.BackgroundTransparency = 1
cosmicCanvas.ZIndex = 0
cosmicCanvas.Parent = screenGui

-- 5 stars only
local starPositions = {}
local lines = {}
local starCount = 5

-- Generate 5 fixed star positions (so they don't move)
for i = 1, starCount do
    starPositions[i] = {
        x = math.random(5, 95) / 100,  -- percentage of screen width
        y = math.random(5, 95) / 100,  -- percentage of screen height
        size = math.random(3, 5),
        alpha = math.random(40, 80) / 100
    }
end

-- Function to draw stars and lines (called on resize)
local function drawCosmic()
    -- Clear previous
    for _, line in ipairs(lines) do line:Destroy() end
    lines = {}
    for _, child in ipairs(cosmicCanvas:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local screenSize = Vector2.new(cosmicCanvas.AbsoluteSize.X, cosmicCanvas.AbsoluteSize.Y)
    if screenSize.X == 0 then return end

    -- Store actual pixel positions
    local starPixels = {}
    for i, pos in ipairs(starPositions) do
        starPixels[i] = Vector2.new(screenSize.X * pos.x, screenSize.Y * pos.y)
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, pos.size, 0, pos.size)
        star.Position = UDim2.new(0, starPixels[i].X - pos.size/2, 0, starPixels[i].Y - pos.size/2)
        star.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        star.BorderSizePixel = 0
        star.BackgroundTransparency = 1 - pos.alpha
        star.Parent = cosmicCanvas
    end

    -- Draw lines between close stars
    for i = 1, starCount do
        for j = i + 1, starCount do
            local dist = (starPixels[i] - starPixels[j]).Magnitude
            if dist < 250 then
                local line = Instance.new("Frame")
                line.Size = UDim2.new(0, dist, 0, 1)
                line.Position = UDim2.new(0, starPixels[i].X, 0, starPixels[i].Y)
                line.Rotation = math.deg(math.atan2(starPixels[j].Y - starPixels[i].Y, starPixels[j].X - starPixels[i].X))
                line.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                line.BackgroundTransparency = 0.4
                line.BorderSizePixel = 0
                line.Parent = cosmicCanvas
                table.insert(lines, line)
            end
        end
    end
end

-- Draw on resize and initial
UserInputService.WindowSizeChanged:Connect(drawCosmic)
drawCosmic()

-- ==================== UI ELEMENTS ====================
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -70, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
toggleButton.Text = "V"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 28
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 620)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -310)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "VIRO HUB – ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- Tab container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 44)
TabContainer.Position = UDim2.new(0, 0, 0, 44)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = mainFrame

-- Content container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -16, 1, -100)
ContentContainer.Position = UDim2.new(0, 8, 0, 94)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = mainFrame

-- Tabs
local tabs = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 104, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200,200,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = TabContainer
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            tab.btn.TextColor3 = Color3.fromRGB(200,200,220)
            tab.content.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        tabs[name].content.Visible = true
        currentTab = name
    end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.Parent = ContentContainer
    content.Visible = false
    tabs[name] = { btn = btn, content = content }
end

-- UI Helpers
local function addSection(tabName, title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -8, 0, 32)
    sec.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
    sec.Text = title
    sec.TextColor3 = Color3.fromRGB(255, 215, 0)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 14
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = tabs[tabName].content
    return sec
end

local function addToggle(tabName, labelText, callback, defaultState)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 76, 0, 30)
    toggle.Position = UDim2.new(1, -82, 0, 5)
    toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(200,200,220)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 12
    toggle.Parent = row

    local enabled = defaultState or false
    local function update()
        if enabled then
            toggle.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
            toggle.Text = "ON"
            toggle.TextColor3 = Color3.fromRGB(255,255,255)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(200,200,220)
        end
    end
    update()

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        if callback then callback(enabled) end
    end)
    return row
end

local function addSlider(tabName, labelText, minVal, maxVal, step, suffix, callback, defaultValue)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 62)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 70, 0, 20)
    valueLabel.Position = UDim2.new(1, -75, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -10, 0, 26)
    slider.Position = UDim2.new(0, 5, 0, 26)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    slider.AutoButtonColor = false
    slider.Text = ""
    slider.Parent = row

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minVal)/(maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local value = defaultValue
    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    slider.InputEnded:Connect(function() dragging = false end)
    slider.MouseMoved:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local localX = mousePos.X - sliderPos.X
            local percent = math.clamp(localX / slider.AbsoluteSize.X, 0, 1)
            value = minVal + (maxVal - minVal) * percent
            value = math.floor(value / step + 0.5) * step
            value = math.clamp(value, minVal, maxVal)
            fill.Size = UDim2.new((value - minVal)/(maxVal - minVal), 0, 1, 0)
            valueLabel.Text = tostring(value) .. suffix
            if callback then callback(value) end
        end
    end)
    return row
end

local function addButton(tabName, text, callback)
    local scroll = tabs[tabName].content
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 235, 245)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addPlayerDropdown(tabName, labelText, callback)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0, 140, 0, 32)
    dropdown.Position = UDim2.new(1, -145, 0, 6)
    dropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    dropdown.Text = "Select Player"
    dropdown.TextColor3 = Color3.fromRGB(200,200,220)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 12
    dropdown.Parent = row

    local selectedPlayer = nil
    dropdown.MouseButton1Click:Connect(function()
        local players = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(players, p.Name)
            end
        end
        -- Simple selection via input (for mobile, we'll use a textbox approach)
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0, 200, 0, 30)
        input.PlaceholderText = "Enter player name"
        input.Parent = row
        input:CaptureFocus()
        input.FocusLost:Connect(function()
            local target = Players:FindFirstChild(input.Text)
            if target then
                selectedPlayer = target
                dropdown.Text = target.Name
                if callback then callback(selectedPlayer) end
            end
            input:Destroy()
        end)
    end)

    return row
end

local function layoutTab(tabName)
    local frame = tabs[tabName].content
    local y = 0
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
            child.Position = UDim2.new(0, 5, 0, y)
            y = y + child.Size.Y.Offset + 5
        end
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, y + 12)
end

-- Create tabs
createTab("Combat")
createTab("Movement")
createTab("Fling")
createTab("Teleports")
createTab("Visuals")
createTab("Misc")

-- ==================== FEATURE IMPLEMENTATIONS ====================

-- Helper functions
local function setCharProp(prop, val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum[prop] = val end
end

-- ENFORCED MOVEMENT (fixes TSB resetting)
local currentWalkSpeed = 16
local currentJumpPower = 50
local walkSpeedEnabled = false
local jumpPowerEnabled = false

coroutine.wrap(function()
    while true do
        wait(0.5)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            if walkSpeedEnabled and hum.WalkSpeed ~= currentWalkSpeed then
                hum.WalkSpeed = currentWalkSpeed
            end
            if jumpPowerEnabled and hum.JumpPower ~= currentJumpPower then
                hum.JumpPower = currentJumpPower
            end
        end
    end
end)()

-- AUTO PUNCH / DODGE
local autoPunch = false
local autoDodge = false
local punchCd = false
local dodgeCd = false

coroutine.wrap(function()
    while true do
        if autoPunch or autoDodge then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local nearest, nearestDist = nil, 15
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = p.Character
                        end
                    end
                end
                if nearest then
                    if autoPunch and not punchCd and nearestDist < 8 then
                        if VirtualInput then
                            VirtualInput:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                            wait(0.1)
                            VirtualInput:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                        end
                        punchCd = true
                        wait(0.5)
                        punchCd = false
                    end
                    if autoDodge and not dodgeCd and nearestDist < 10 then
                        if VirtualInput then
                            VirtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                            wait(0.1)
                            VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        end
                        dodgeCd = true
                        wait(0.8)
                        dodgeCd = false
                    end
                end
            end
        end
        wait()
    end
end)()

-- AIMBOT
local aimbotEnabled = false
local aimbotPart = "Head"
local aimbotSmoothness = 0.4
local aimbotFOV = 180

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local targetPart = nil
    local nearestAngle = aimbotFOV
    local camCF = Camera.CFrame
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local part = p.Character:FindFirstChild(aimbotPart)
            if part then
                local screenPos, onScreen = camCF:WorldToScreenPoint(part.Position)
                if onScreen then
                    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local angle = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if angle < nearestAngle then
                        nearestAngle = angle
                        targetPart = part
                    end
                end
            end
        end
    end
    if targetPart then
        local targetCF = CFrame.lookAt(camCF.Position, targetPart.Position)
        Camera.CFrame = camCF:Lerp(targetCF, aimbotSmoothness)
    end
end)

-- NOCLIP / FLY
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyConnection
local noclipConnection

local function updateNoclip()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not noclipEnabled end
        end
    end
end

local function startNoclipLoop()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(updateNoclip)
end

local function startFly()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end
    hum.PlatformStand = true
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled then return end
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInput
