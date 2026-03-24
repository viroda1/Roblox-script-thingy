--[[
    Viro Hub – The Strongest Battlegrounds (PC Optimized)
    – Dedicated PC version with larger UI, keyboard shortcuts, and full feature set
    – Features: Auto Punch, Auto Dodge, Aimbot, WalkSpeed, JumpPower, Noclip, Fly, Fling, Anti-Fling, Teleports, Spawn Kill, ESP, No Fog, Full Bright, Infinite Yield, Rejoin, Reset
    – Press K to toggle menu
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VirtualInput = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

-- UI Parent
local guiParent = game.CoreGui
if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViroHubPC"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- ==================== UI ELEMENTS (LARGER FOR PC) ====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 700)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -350)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "VIRO HUB – PC EDITION"
titleText.TextColor3 = Color3.fromRGB(255, 215, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 20
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
minimizeBtn.Position = UDim2.new(1, -88, 0, 6)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 22
minimizeBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- Tab container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 48)
TabContainer.Position = UDim2.new(0, 0, 0, 48)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = mainFrame

-- Content container
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -110)
ContentContainer.Position = UDim2.new(0, 10, 0, 104)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = mainFrame

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 32)
statusBar.Position = UDim2.new(0, 0, 1, -32)
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
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- Tabs
local tabs = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
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
    sec.Size = UDim2.new(1, -8, 0, 35)
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
    row.Size = UDim2.new(1, -8, 0, 42)
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
    toggle.Size = UDim2.new(0, 80, 0, 32)
    toggle.Position = UDim2.new(1, -86, 0, 5)
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
        wait(1.5)
        statusText.Text = currentTab .. " tab | Press K to hide/show menu"
    end)
    return row
end

local function addSlider(tabName, labelText, minVal, maxVal, step, suffix, callback, defaultValue)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 65)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
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
    btn.Size = UDim2.new(1, -8, 0, 42)
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

local function addPlayerDropdown(tabName, labelText, callback)
    local scroll = tabs[tabName].content
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 46)
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
    dropdown.Size = UDim2.new(0, 150, 0, 34)
    dropdown.Position = UDim2.new(1, -155, 0, 6)
    dropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    dropdown.Text = "Select Player"
    dropdown.TextColor3 = Color3.fromRGB(200,200,220)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 12
    dropdown.Parent = row

    local selectedPlayer = nil
    dropdown.MouseButton1Click:Connect(function()
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0, 200, 0, 32)
        input.PlaceholderText = "Enter player name"
        input.Parent = row
        input:CaptureFocus()
        input.FocusLost:Connect(function()
            local target = Players:FindFirstChild(input.Text)
            if target then
                selectedPlayer = target
                dropdown.Text = target.Name
                if callback then callback(selectedPlayer) end
                statusText.Text = "Selected: " .. target.Name
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
            y = y + child.Size.Y.Offset + 6
        end
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, y + 15)
end

-- Create tabs
createTab("Combat")
createTab("Movement")
createTab("Fling")
createTab("Teleports")
createTab("Visuals")
createTab("Misc")

-- ==================== FEATURE IMPLEMENTATIONS ====================

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
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame + move * flySpeed / 100)
    end)
end

-- FLING
local flingEnabled = false
local flingPower = 100
local flingTarget = nil
local flingConnection

local function startFling()
    if flingConnection then flingConnection:Disconnect() end
    flingConnection = RunService.RenderStepped:Connect(function()
        if not flingEnabled or not flingTarget or not flingTarget.Character then return end
        local targetRoot = flingTarget.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            targetRoot.Velocity = Vector3.new(
                math.random(-flingPower, flingPower),
                math.random(flingPower/2, flingPower),
                math.random(-flingPower, flingPower)
            )
        end
    end)
end

-- ANTI-FLING
local antiFlingEnabled = false
local antiFlingConnection

local function startAntiFling()
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    antiFlingConnection = RunService.RenderStepped:Connect(function()
        if not antiFlingEnabled then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if root and hum and hum.Health > 0 then
            if root.Velocity.Y > 80 or root.Velocity.Y < -80 then
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
            end
        end
    end)
end

-- SPAWN KILL
local spawnKillEnabled = false
local spawnKillConnection

local function startSpawnKill()
    if spawnKillConnection then spawnKillConnection:Disconnect() end
    spawnKillConnection = RunService.RenderStepped:Connect(function()
        if not spawnKillEnabled then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn")
                if spawnLocation then
                    p.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
                    wait(0.1)
                    if VirtualInput then
                        VirtualInput:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        wait(0.1)
                        VirtualInput:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                end
            end
        end
        wait(2)
    end)
end

-- TP FUNCTIONS
local function tpToPlayer(target)
    local char = LocalPlayer.Character
    local targetChar = target.Character
    if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end

local function bringToMe(target)
    local char = LocalPlayer.Character
    local targetChar = target.Character
    if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        targetChar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end

local function flingAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Velocity = Vector3.new(
                math.random(-150, 150),
                math.random(100, 200),
                math.random(-150, 150)
            )
        end
    end
end

-- ESP
local espEnabled = false
local espObjects = {}
local function refreshESP()
    for _, obj in ipairs(espObjects) do obj:Destroy() end
    espObjects = {}
    if not espEnabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 70, 70)
            highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
            highlight.FillTransparency = 0.55
            highlight.OutlineTransparency = 0.3
            highlight.Parent = p.Character
            table.insert(espObjects, highlight)
        end
    end
end
Players.PlayerAdded:Connect(function(p) if espEnabled then p.CharacterAdded:Connect(refreshESP) refreshESP() end end)
Players.PlayerRemoving:Connect(refreshESP)

-- ==================== BUILD UI ====================

-- Combat tab
local combatSec = addSection("Combat", "COMBAT")
addToggle("Combat", "Auto Punch (Q)", function(v) autoPunch = v end, false)
addToggle("Combat", "Auto Dodge (F)", function(v) autoDodge = v end, false)
addToggle("Combat", "Aimbot", function(v) aimbotEnabled = v end, false)
addSlider("Combat", "Aimbot Smoothness", 0, 1, 0.05, "", function(v) aimbotSmoothness = v end, 0.4)
addSlider("Combat", "Aimbot FOV", 30, 360, 5, "°", function(v) aimbotFOV = v end, 180)

local targetRow = Instance.new("Frame")
targetRow.Size = UDim2.new(1, -8, 0, 44)
targetRow.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
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
targetBtn.Position = UDim2.new(1, -95, 0, 6)
targetBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
targetBtn.Text = "Switch"
targetBtn.TextColor3 = Color3.fromRGB(200,200,220)
targetBtn.Font = Enum.Font.Gotham
targetBtn.TextSize = 12
targetBtn.Parent = targetRow
targetBtn.MouseButton1Click:Connect(function()
    aimbotPart = aimbotPart == "Head" and "HumanoidRootPart" or "Head"
    targetLabel.Text = aimbotPart == "Head" and "Aimbot Target: Head" or "Aimbot Target: Torso"
end)

-- Movement tab
local moveSec = addSection("Movement", "MOVEMENT")
addToggle("Movement", "Custom WalkSpeed", function(v) walkSpeedEnabled = v end, false)
addSlider("Movement", "WalkSpeed", 16, 250, 1, "", function(v) currentWalkSpeed = v; if walkSpeedEnabled then setCharProp("WalkSpeed", v) end end, 16)
addToggle("Movement", "Custom JumpPower", function(v) jumpPowerEnabled = v end, false)
addSlider("Movement", "JumpPower", 50, 350, 5, "", function(v) currentJumpPower = v; if jumpPowerEnabled then setCharProp("JumpPower", v) end end, 50)
addToggle("Movement", "Noclip", function(v) noclipEnabled = v; startNoclipLoop() end, false)
addToggle("Movement", "Fly Mode", function(v)
    flyEnabled = v
    if v then startFly() elseif flyConnection then flyConnection:Disconnect() local char = LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); if hum then hum.PlatformStand = false end end
end, false)
addSlider("Movement", "Fly Speed", 20, 200, 5, "", function(v) flySpeed = v end, 50)

-- Fling tab
local flingSec = addSection("Fling", "FLING & ANTI-FLING")
addToggle("Fling", "Fling Target", function(v) flingEnabled = v; if v then startFling() elseif flingConnection then flingConnection:Disconnect() end end, false)
addSlider("Fling", "Fling Power", 50, 300, 10, "", function(v) flingPower = v end, 100)
addPlayerDropdown("Fling", "Select Target", function(p) flingTarget = p end)
addButton("Fling", "Fling All Players", function() flingAll() end)
addToggle("Fling", "Anti-Fling (Self)", function(v) antiFlingEnabled = v; if v then startAntiFling() elseif antiFlingConnection then antiFlingConnection:Disconnect() end end, false)

-- Teleports tab
local teleSec = addSection("Teleports", "TELEPORTS")
addPlayerDropdown("Teleports", "Teleport To", function(p) tpToPlayer(p) end)
addPlayerDropdown("Teleports", "Bring To You", function(p) bringToMe(p) end)
addButton("Teleports", "Teleport to Spawn", function()
    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn")
    if spawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
    end
end)
addToggle("Teleports", "Spawn Kill (Auto)", function(v) spawnKillEnabled = v; if v then startSpawnKill() elseif spawnKillConnection then spawnKillConnection:Disconnect() end end, false)

-- Visuals tab
local visSec = addSection("Visuals", "VISUALS")
addToggle("Visuals", "ESP (Highlight)", function(v) espEnabled = v; refreshESP() end, false)
addToggle("Visuals", "No Fog", function(v)
    local lighting = game:GetService("Lighting")
    if v then lighting.FogEnd = 100000; lighting.FogStart = 100000 else lighting.FogEnd = 100000; lighting.FogStart = 0 end
end, false)
addToggle("Visuals", "Full Bright", function(v)
    local lighting = game:GetService("Lighting")
    if v then lighting.Brightness = 2; lighting.ExposureCompensation = 2 else lighting.Brightness = 1; lighting.ExposureCompensation = 0 end
end, false)

-- Misc tab
local miscSec = addSection("Misc", "UTILITIES")
addButton("Misc", "Rejoin Game", function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)
addButton("Misc", "Reset Character", function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end end)
addButton("Misc", "Infinite Yield", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
addButton("Misc", "Chat Spam (Viro Hub x3)", function()
    for i = 1, 3 do
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Viro Hub PC 🔥", "All")
        wait(0.5)
    end
end)

-- Credits tab
local creditsSec = addSection("Credits", "VIRO HUB PC")
local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -10, 0, 180)
creditsText.Position = UDim2.new(0, 5, 0, 40)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Viro Hub – PC Optimized Edition\n\nFeatures:\n• Auto Punch / Dodge / Aimbot\n• WalkSpeed / JumpPower (Enforced)\n• Noclip / Fly\n• Fling (Target / All) & Anti-Fling\n• Teleports (To Player / Bring / Spawn)\n• Spawn Kill (Auto)\n• ESP / No Fog / Full Bright\n• Rejoin / Reset / Infinite Yield\n\nPress K to toggle menu"
creditsText.TextColor3 = Color3.fromRGB(200,200,220)
creditsText.Font = Enum.Font.Gotham
creditsText.TextSize = 12
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.Parent = tabs["Credits"].content

-- Layout all tabs
layoutTab("Combat")
layoutTab("Movement")
layoutTab("Fling")
layoutTab("Teleports")
layoutTab("Visuals")
layoutTab("Misc")
layoutTab("Credits")

-- Select first tab
tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
tabs["Combat"].btn.TextColor3 = Color3.fromRGB(255,255,255)
tabs["Combat"].content.Visible = true

-- Dragging
local dragging = false
local dragStart, frameStart
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- Minimize
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentContainer.Visible = not minimized
    TabContainer.Visible = not minimized
    statusBar.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 600, 0, 48) or UDim2.new(0, 600, 0, 700)
    minimizeBtn.Text = minimized and "+" or "−"
end)

-- Toggle menu with K
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Notification
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 340, 0, 42)
notify.Position = UDim2.new(0.5, -170, 1, -55)
notify.BackgroundColor3 = Color3.fromRGB(20,20,35)
notify.Text = "VIRO HUB PC | Press K to open menu"
notify.TextColor3 = Color3.fromRGB(255,215,0)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 14
notify.Parent = screenGui
TweenService:Create(notify, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = UDim2.new(0.5, -170, 1, -15)}):Play()
wait(3)
notify:Destroy()

print("✅ Viro Hub PC loaded. Press K to open menu.")