--[[
    Viro Hub – The Strongest Battlegrounds
    ENHANCED EDITION – Fixed WalkSpeed/JumpPower, better Noclip, + new features
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI Parent (safe for mobile/PC)
local guiParent = game.CoreGui
if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViroHubEnhanced"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Floating button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -70, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
toggleButton.Text = "V"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 28
toggleButton.Parent = screenGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "VIRO HUB – ENHANCED"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- Tab container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = mainFrame

-- Content container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -90)
ContentContainer.Position = UDim2.new(0, 10, 0, 85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = mainFrame

-- Tabs
local tabs = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = TabContainer
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
            tab.btn.TextColor3 = Color3.fromRGB(200,200,200)
            tab.content.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(128,0,255)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        tabs[name].content.Visible = true
        currentTab = name
    end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 5
    content.Parent = ContentContainer
    content.Visible = false
    tabs[name] = { btn = btn, content = content }
end

-- UI Helpers
local function addSection(tabName, title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -10, 0, 30)
    sec.BackgroundColor3 = Color3.fromRGB(25,25,40)
    sec.Text = title
    sec.TextColor3 = Color3.fromRGB(255,215,0)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 14
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = tabs[tabName].content
    return sec
end

local function addToggle(tabName, labelText, callback, defaultState)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(20,20,30)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
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

    local enabled = defaultState or false
    local function update()
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
    row.Size = UDim2.new(1, -10, 0, 60)
    row.BackgroundColor3 = Color3.fromRGB(20,20,30)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
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
    fill.Size = UDim2.new((defaultValue - minVal)/(maxVal - minVal), 0, 1, 0)
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
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
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
    frame.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- Create tabs
createTab("Combat")
createTab("Movement")
createTab("Visuals")
createTab("Misc")
createTab("Credits")

-- ==================== FEATURES ====================

-- MOVEMENT FIX (enforced loop)
local currentWalkSpeed = 16
local currentJumpPower = 50
local walkSpeedEnabled = false
local jumpPowerEnabled = false

local function enforceMovement()
    while true do
        wait(0.5) -- check twice per second
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

-- NOCLIP FIX (properly toggles collisions)
local noclipEnabled = false
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

-- AUTO PUNCH
local autoPunchEnabled = false
local punchCooldown = false
local hasVirtualInput = pcall(function() return game:GetService("VirtualInputManager") end)

local function autoPunchLoop()
    while autoPunchEnabled do
        if not punchCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local nearest, nearestDist = nil, 10
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
                    if hasVirtualInput then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                    punchCooldown = true
                    wait(0.5)
                    punchCooldown = false
                end
            end
        end
        wait()
    end
end

-- AUTO DODGE (presses F when enemy is within range)
local autoDodgeEnabled = false
local dodgeCooldown = false

local function autoDodgeLoop()
    while autoDodgeEnabled do
        if not dodgeCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local nearestDist = 12
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                        end
                    end
                end
                if nearestDist < 10 then
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
        wait()
    end
end

-- AIMBOT (smoother)
local aimbotEnabled = false
local aimbotPart = "Head"
local aimbotSmoothness = 0.3
local aimbotConnection

local function updateAimbot()
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
        local currentCF = Camera.CFrame
        local targetCF = CFrame.lookAt(currentCF.Position, targetPos)
        local newCF = currentCF:Lerp(targetCF, aimbotSmoothness)
        Camera.CFrame = newCF
    end
end
aimbotConnection = RunService.RenderStepped:Connect(updateAimbot)

-- ESP (Better)
local espEnabled = false
local espBoxes = {}
local function createESP(player)
    if not player.Character then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.3
    highlight.Parent = player.Character
    table.insert(espBoxes, highlight)
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
Players.PlayerRemoving:Connect(function(p)
    if p.Character then
        for _, box in ipairs(espBoxes) do
            if box.Parent == p.Character then box:Destroy() end
        end
    end
end)

-- FLY / NOCLIP (better)
local flyEnabled = false
local flySpeed = 50
local flyConnection
local function startFly()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end
    hum.PlatformStand = true
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

-- ==================== BUILD UI ====================
-- Combat tab
local combatSec = addSection("Combat", "Combat Features")
addToggle("Combat", "Auto Punch (Q)", function(val) autoPunchEnabled = val; if val then coroutine.wrap(autoPunchLoop)() end end, false)
addToggle("Combat", "Auto Dodge (F)", function(val) autoDodgeEnabled = val; if val then coroutine.wrap(autoDodgeLoop)() end end, false)
addToggle("Combat", "Aimbot", function(val) aimbotEnabled = val end, false)
addSlider("Combat", "Aimbot Smoothness", 0, 1, 0.05, "", function(v) aimbotSmoothness = v end, 0.3)
-- Aimbot target dropdown
local partRow = Instance.new("Frame")
partRow.Size = UDim2.new(1, -10, 0, 35)
partRow.BackgroundColor3 = Color3.fromRGB(20,20,30)
partRow.Parent = tabs["Combat"].content
local partLabel = Instance.new("TextLabel")
partLabel.Size = UDim2.new(0.5, -10, 1, 0)
partLabel.Position = UDim2.new(0, 5, 0, 0)
partLabel.BackgroundTransparency = 1
partLabel.Text = "Aimbot Target: Head"
partLabel.TextColor3 = Color3.fromRGB(220,220,220)
partLabel.Font = Enum.Font.Gotham
partLabel.TextSize = 12
partLabel.TextXAlignment = Enum.TextXAlignment.Left
partLabel.Parent = partRow
local partBtn = Instance.new("TextButton")
partBtn.Size = UDim2.new(0, 80, 0, 25)
partBtn.Position = UDim2.new(1, -85, 0, 5)
partBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
partBtn.Text = "Switch"
partBtn.TextColor3 = Color3.fromRGB(200,200,200)
partBtn.Font = Enum.Font.Gotham
partBtn.TextSize = 12
partBtn.Parent = partRow
partBtn.MouseButton1Click:Connect(function()
    if aimbotPart == "Head" then
        aimbotPart = "HumanoidRootPart"
        partLabel.Text = "Aimbot Target: Torso"
    else
        aimbotPart = "Head"
        partLabel.Text = "Aimbot Target: Head"
    end
end)

-- Movement tab
local moveSec = addSection("Movement", "Movement (Enforced)")
addToggle("Movement", "Custom WalkSpeed", function(val) walkSpeedEnabled = val end, false)
addSlider("Movement", "WalkSpeed", 16, 250, 1, "", function(v) currentWalkSpeed = v; if walkSpeedEnabled then setCharProp("WalkSpeed", v) end end, 16)
addToggle("Movement", "Custom JumpPower", function(val) jumpPowerEnabled = val end, false)
addSlider("Movement", "JumpPower", 50, 350, 5, "", function(v) currentJumpPower = v; if jumpPowerEnabled then setCharProp("JumpPower", v) end end, 50)
addToggle("Movement", "Noclip", function(val) noclipEnabled = val; startNoclipLoop() end, false)
addToggle("Movement", "Fly Mode", function(val)
    flyEnabled = val
    if val then
        startFly()
    else
        if flyConnection then flyConnection:Disconnect() end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end, false)
