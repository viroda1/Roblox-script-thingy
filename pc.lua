--[[
    Viro Hub – The Strongest Battlegrounds (PC Optimized)
    – Keyboard shortcuts (K to toggle, arrow keys for sliders)
    – Smooth aimbot with configurable FOV
    – Auto Punch, Auto Dodge, Fly, Noclip, ESP, and more
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI Parent
local guiParent = game.CoreGui
if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViroHubPC"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Main frame (larger for PC)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 650)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 12))
})
gradient.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "VIRO HUB – PC EDITION"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -80, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
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
TabContainer.Size = UDim2.new(1, 0, 0, 45)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = mainFrame

-- Content container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -100)
ContentContainer.Position = UDim2.new(0, 10, 0, 95)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = mainFrame

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 1, -30)
statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Ready | Press K to toggle menu"
statusText.TextColor3 = Color3.fromRGB(150, 150, 180)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 11
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- Tabs
local tabs = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 1, 0)
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
        statusText.Text = name .. " tab | Press K to hide/show menu"
    end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 8
    content.Parent = ContentContainer
    content.Visible = false
    tabs[name] = { btn = btn, content = content }
end

-- UI Helpers
local function addSection(tabName, title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -10, 0, 35)
    sec.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
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
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
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
    toggle.Size = UDim2.new(0, 80, 0, 32)
    toggle.Position = UDim2.new(1, -85, 0, 5)
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
        statusText.Text = labelText .. ": " .. (enabled and "ON" or "OFF")
        wait(1)
        statusText.Text = currentTab .. " tab | Press K to hide/show menu"
    end)
    return row
end

local function addSlider(tabName, labelText, minVal, maxVal, step, suffix, callback, defaultValue)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 65)
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 22)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 70, 0, 22)
    valueLabel.Position = UDim2.new(1, -75, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -10, 0, 28)
    slider.Position = UDim2.new(0, 5, 0, 28)
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
            statusText.Text = labelText .. ": " .. tostring(value)
        end
    end)
    return row
end

local function addButton(tabName, text, callback)
    local scroll = tabs[tabName].content
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 235, 245)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(function()
        callback()
        statusText.Text = "Executed: " .. text
        wait(1.5)
        statusText.Text = currentTab .. " tab | Press K to hide/show menu"
    end)
    return btn
end

local function layoutTab(tabName)
    local frame = tabs[tabName].content
    local y = 0
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
            child.Position = UDim2.new(0, 5, 0, y)
            y = y + child.Size.Y.Offset + 6
        end
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, y + 15)
end

-- Create tabs
createTab("Combat")
createTab("Movement")
createTab("Visuals")
createTab("Misc")
createTab("Credits")

-- ==================== FEATURES ====================

-- Helper
local function setCharProp(prop, val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum[prop] = val end
end

-- ENFORCED MOVEMENT
local currentWalkSpeed = 16
local currentJumpPower = 50
local walkSpeedEnabled = false
local jumpPowerEnabled = false

local function enforceMovement()
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
end
coroutine.wrap(enforceMovement)()

-- AUTO PUNCH / DODGE
local autoPunchEnabled = false
local autoDodgeEnabled = false
local punchCooldown = false
local dodgeCooldown = false
local hasVirtualInput = pcall(function() return game:GetService("VirtualInputManager") end)

local function autoCombatLoop()
    while true do
        if autoPunchEnabled or autoDodgeEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local nearest, nearestDist = nil, 15
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = player.Character
                        end
                    end
                end
                if nearest then
                    if autoPunchEnabled and not punchCooldown and nearestDist < 8 then
                        if hasVirtualInput then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                            wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                        end
                        punchCooldown = true
                        wait(0.5)
                        punchCooldown = false
                    end
                    if autoDodgeEnabled and not dodgeCooldown and nearestDist < 10 then
                        if hasVirtualInput then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                            wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        end
                        dodgeCooldown = true
                        wait(0.8)
                        dodgeCooldown = false
                    end
                end
            end
        end
        wait()
    end
end
coroutine.wrap(autoCombatLoop)()

-- AIMBOT
local aimbotEnabled = false
local aimbotPart = "Head"
local aimbotSmoothness = 0.4
local aimbotFOV = 180
local aimbotConnection

local function updateAimbot()
    if not aimbotEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPart = nil
    local nearestAngle = aimbotFOV
    local cameraCF = Camera.CFrame
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(aimbotPart)
            if part then
                local screenPos, onScreen = cameraCF:WorldToScreenPoint(part.Position)
                if onScreen then
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local angle = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if angle < nearestAngle then
                        nearestAngle = angle
                        targetPart = part
                    end
                end
            end
        end
    end
    
    if targetPart then
        local targetPos = targetPart.Position
        local targetCF = CFrame.lookAt(cameraCF.Position, targetPos)
        local newCF = cameraCF:Lerp(targetCF, aimbotSmoothness)
        Camera.CFrame = newCF
    end
end
aimbotConnection = RunService.RenderStepped:Connect(updateAimbot)

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
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
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
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame + move * flySpeed / 100)
    end)
end

-- ESP (Highlight)
local espEnabled = false
local espObjects = {}
local function refreshESP()
    for _, obj in ipairs(espObjects) do obj:Destroy() end
    espObjects = {}
    if not espEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.55
            highlight.OutlineTransparency = 0.3
            highlight.Parent = player.Character
            table.insert(espObjects, highlight)
        end
    end
end
Players.PlayerAdded:Connect(function(p)
    if espEnabled and p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() refreshESP() end)
        refreshESP()
    end
end)
Players.PlayerRemoving:Connect(function() refreshESP() end)

-- ==================== BUILD UI ====================

-- Combat Tab
local combatSec = addSection("Combat", "COMBAT")
addToggle("Combat", "Auto Punch (Q)", function(v) autoPunchEnabled = v end, false)
addToggle("Combat", "Auto Dodge (F)", function(v) autoDodgeEnabled = v end, false)
addToggle("Combat", "Aimbot", function(v) aimbotEnabled = v end, false)
addSlider("Combat", "Aimbot Smoothness", 0, 1, 0.05, "", function(v) aimbotSmoothness = v end, 0.4)
addSlider("Combat", "Aimbot FOV", 30, 360, 5, "°", function(v) aimbotFOV = v end, 180)
-- Aimbot target
local targetRow = Instance.new("Frame")
targetRow.Size = UDim2.new(1, -10, 0, 42)
targetRow.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
targetRow.Parent = tabs["Combat"].content
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.6, -10, 1, 0)
targetLabel.Position = UDim2.new(0, 5, 0, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Aimbot Target: Head"
targetLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 13
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = targetRow
local targetBtn = Instance.new("TextButton")
targetBtn.Size = UDim2.new(0, 90, 0, 32)
targetBtn.Position = UDim2.new(1, -95, 0, 5)
targetBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
targetBtn.Text = "Switch"
targetBtn.TextColor3 = Color3.fromRGB(200,200,220)
targetBtn.Font = Enum.Font.Gotham
targetBtn.Te
