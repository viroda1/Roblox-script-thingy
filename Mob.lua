--[[
    mob.lua – Viro Hub Mobile
    Lightweight menu for The Strongest Battlegrounds
    – Tap V button to open/close
    – Auto punch, walkspeed, jump power, noclip
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Use PlayerGui (always safe on mobile)
local guiParent = LocalPlayer:WaitForChild("PlayerGui")

-- Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViroHubMobile"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Floating toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -70, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
toggleButton.Text = "V"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 28
toggleButton.Parent = screenGui

-- Main panel
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 450)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Title bar (draggable)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "VIRO MOBILE"
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
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Scrolling container
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.Parent = mainFrame

-- Helper: create a section title
local function addSection(text)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 30)
    sec.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    sec.Text = text
    sec.TextColor3 = Color3.fromRGB(255, 215, 0)
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 14
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = scroll
    return sec
end

-- Helper: add a toggle
local function addToggle(labelText, callback, defaultState)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 70, 0, 30)
    toggle.Position = UDim2.new(1, -75, 0, 5)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 12
    toggle.Parent = row

    local enabled = defaultState or false
    local function update()
        if enabled then
            toggle.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
            toggle.Text = "ON"
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
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

-- Helper: add a slider
local function addSlider(labelText, minVal, maxVal, step, suffix, callback, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 60)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    row.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -65, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -10, 0, 25)
    slider.Position = UDim2.new(0, 5, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
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
    slider.InputEnded:Connect(function()
        dragging = false
    end)
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

-- Helper: add a button
local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Layout function to set positions
local function layout()
    local y = 0
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child.Position = UDim2.new(0, 5, 0, y)
            y = y + child.Size.Y.Offset + 5
        elseif child:IsA("TextLabel") and child ~= titleText then -- sections
            child.Position = UDim2.new(0, 5, 0, y)
            y = y + child.Size.Y.Offset + 5
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- ==================== FEATURES ====================
local function setCharProp(prop, val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then hum[prop] = val end
end

-- Auto punch (simulates Q key using VirtualInputManager if available, else falls back to warning)
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

-- Noclip
local noclipEnabled = false
local noclipConnection
local function toggleNoclip(val)
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
end

-- ==================== BUILD UI ====================
addSection("Combat")
addToggle("Auto Punch", function(val)
    autoPunchEnabled = val
    if val then
        coroutine.wrap(autoPunchLoop)()
    end
end, false)

addSection("Movement")
addSlider("WalkSpeed", 16, 250, 1, "", function(v) setCharProp("WalkSpeed", v) end, 16)
addSlider("JumpPower", 50, 350, 5, "", function(v) setCharProp("JumpPower", v) end, 50)
addToggle("Noclip", function(val) toggleNoclip(val) end, false)

addSection("Utilities")
addButton("Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)
addButton("Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

addSection("Info")
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -10, 0, 80)
infoText.BackgroundTransparency = 1
infoText.Text = "Viro Hub Mobile\nAuto Punch: Tap V to toggle menu\nWorks on mobile executors"
infoText.TextColor3 = Color3.fromRGB(200,200,200)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 12
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = scroll

layout()

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
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- Toggle menu
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Keyboard support (K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Show a short notification
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 250, 0, 35)
notify.Position = UDim2.new(0.5, -125, 1, -40)
notify.BackgroundColor3 = Color3.fromRGB(20,20,30)
notify.Text = "Viro Mobile Loaded | Tap V"
notify.TextColor3 = Color3.fromRGB(255,215,0)
notify.Font = Enum.Font.Gotham
notify.TextSize = 12
notify.Parent = screenGui
wait(3)
notify:Destroy()

print("✅ Viro Mobile ready. Tap V button to open menu.")
