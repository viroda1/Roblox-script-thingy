--[[
    VIRO Server Admin XL v2.0
    Property of VIRO – Ultimate Roblox Utility
    A complete, modern, and feature-rich script for Roblox.
    Features: Noclip, Fly, Speed, Jump, ESP, Kill Nearest, Gamepass Giver, and more.
]]

-- ============================================================================
-- CONFIGURATION
-- ============================================================================
local GUI_CONFIG = {
    Name = "VIRO Server Admin XL",
    Version = "2.0",
    DiscordLink = "https://discord.gg/viro",
    DefaultPosition = UDim2.new(0.0645, 0, 0.4276, 0),
    DefaultSize = UDim2.new(0, 450, 0, 500), -- Larger for more features
    Colors = {
        Background = Color3.fromRGB(20, 20, 30),
        Panel = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(100, 80, 200),
        Success = Color3.fromRGB(70, 200, 70),
        Danger = Color3.fromRGB(200, 50, 50),
        Warning = Color3.fromRGB(255, 165, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(0, 0, 0)
    }
}

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

-- ============================================================================
-- STATE MANAGEMENT
-- ============================================================================
local state = {
    noclip = false,
    fly = false,
    flySpeed = 50,
    speedBoost = 16,
    jumpPower = 50,
    espEnabled = false,
    aimbot = false,
    killNearest = false,
    gamepassGiver = false,
    teleportToMouse = false,
    infiniteJump = false,
    autoClicker = false,
    autoClickDelay = 0.1,
    espBoxes = {},
    espNames = {},
    currentTab = "Movement",
    switchingTab = false
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================
local function TweenObject(obj, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[direction or "Out"])
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

local function CreateFrame(parent, properties)
    local frame = Instance.new("Frame")
    for prop, value in pairs(properties) do frame[prop] = value end
    frame.Parent = parent
    return frame
end

local function CreateTextLabel(parent, properties)
    local label = Instance.new("TextLabel")
    for prop, value in pairs(properties) do label[prop] = value end
    label.Parent = parent
    return label
end

local function CreateButton(parent, properties, onClick)
    local button = Instance.new("TextButton")
    for prop, value in pairs(properties) do button[prop] = value end
    button.MouseButton1Click:Connect(onClick)
    button.Parent = parent
    return button
end

local function CreateSlider(parent, properties, onChange)
    local frame = CreateFrame(parent, {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Name = "SliderFrame"
    })
    local label = CreateTextLabel(frame, {
        Text = properties.Name,
        TextColor3 = GUI_CONFIG.Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })
    local valueLabel = CreateTextLabel(frame, {
        Text = tostring(properties.Default),
        TextColor3 = GUI_CONFIG.Colors.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })
    local slider = CreateFrame(frame, {
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 1, -5),
        BackgroundColor3 = GUI_CONFIG.Colors.Panel,
        BorderSizePixel = 0
    })
    local fill = CreateFrame(slider, {
        Size = UDim2.new(properties.Default / (properties.Max - properties.Min), 0, 1, 0),
        BackgroundColor3 = GUI_CONFIG.Colors.Accent,
        BorderSizePixel = 0
    })
    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local newValue = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            newValue = math.clamp(newValue, 0, 1)
            fill.Size = UDim2.new(newValue, 0, 1, 0)
            local value = properties.Min + (properties.Max - properties.Min) * newValue
            value = math.floor(value * 100) / 100
            valueLabel.Text = tostring(value)
            onChange(value)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newValue = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            newValue = math.clamp(newValue, 0, 1)
            fill.Size = UDim2.new(newValue, 0, 1, 0)
            local value = properties.Min + (properties.Max - properties.Min) * newValue
            value = math.floor(value * 100) / 100
            valueLabel.Text = tostring(value)
            onChange(value)
        end
    end)
    frame.Parent = parent
    return frame
end

local function CreateToggle(parent, text, default, callback)
    local frame = CreateFrame(parent, {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Name = "ToggleFrame"
    })
    local label = CreateTextLabel(frame, {
        Text = text,
        TextColor3 = GUI_CONFIG.Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })
    local toggle = CreateFrame(frame, {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -45, 0.5, -10),
        BackgroundColor3 = default and GUI_CONFIG.Colors.Success or GUI_CONFIG.Colors.Danger,
        BorderSizePixel = 0
    })
    local knob = CreateFrame(toggle, {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(default and 0.55 or 0.05, 0, 0.05, 0),
        BackgroundColor3 = GUI_CONFIG.Colors.Text,
        BorderSizePixel = 0
    })
    local active = default
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            active = not active
            toggle.BackgroundColor3 = active and GUI_CONFIG.Colors.Success or GUI_CONFIG.Colors.Danger
            knob:TweenPosition(UDim2.new(active and 0.55 or 0.05, 0, 0.05, 0), "Out", "Quad", 0.1, true)
            callback(active)
        end
    end)
    frame.Parent = parent
    return frame
end

-- ============================================================================
-- GUI CONSTRUCTION
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VIRO_Server_Admin"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local mainFrame = CreateFrame(screenGui, {
    Name = "MainFrame",
    Active = true,
    BackgroundColor3 = GUI_CONFIG.Colors.Panel,
    Position = GUI_CONFIG.DefaultPosition,
    Size = GUI_CONFIG.DefaultSize,
    Draggable = true,
    BorderSizePixel = 0,
    BackgroundTransparency = 0.05
})

-- Glassmorphism overlay
local glassOverlay = CreateFrame(mainFrame, {
    Name = "GlassOverlay",
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9,
    Size = UDim2.new(1, 0, 1, 0),
    BorderSizePixel = 0
})

-- Title bar
local title = CreateTextLabel(mainFrame, {
    Name = "Title",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 35),
    Font = Enum.Font.GothamBold,
    Text = GUI_CONFIG.Name .. " v" .. GUI_CONFIG.Version,
    TextColor3 = GUI_CONFIG.Colors.Text,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Center
})

-- Tabs
local tabs = {"Movement", "Combat", "Visuals", "Player", "Misc"}
local tabButtons = {}
local tabOutline = CreateFrame(mainFrame, {
    Name = "TabOutline",
    BackgroundColor3 = GUI_CONFIG.Colors.Accent,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0.07, 0),
    Size = UDim2.new(0, 80, 0, 28)
})

local contentFrame = CreateFrame(mainFrame, {
    Name = "ContentFrame",
    BackgroundColor3 = GUI_CONFIG.Colors.Panel,
    Position = UDim2.new(0, 0, 0.14, 0),
    Size = UDim2.new(1, 0, 1, -0.14),
    ClipsDescendants = true
})

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Parent = contentFrame
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.CanvasSize = UDim2.new(#tabs, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 0
scrollingFrame.BorderSizePixel = 0
scrollingFrame.BackgroundTransparency = 1

local panels = {}
for i, tabName in ipairs(tabs) do
    panels[tabName] = CreateFrame(scrollingFrame, {
        Name = tabName .. "Panel",
        BackgroundColor3 = GUI_CONFIG.Colors.Panel,
        Position = UDim2.new((i-1)/#tabs, 0, 0, 0),
        Size = UDim2.new(1/#tabs, 0, 1, 0),
        Visible = i == 1
    })
end

-- Tab buttons
for i, tabName in ipairs(tabs) do
    local xPos = (i-1) * (1 / #tabs)
    local button = CreateButton(mainFrame, {
        Name = tabName .. "Button",
        BackgroundTransparency = 1,
        Position = UDim2.new(xPos, 0, 0.07, 0),
        Size = UDim2.new(1/#tabs, 0, 0, 28),
        Font = Enum.Font.GothamSemibold,
        Text = tabName,
        TextColor3 = GUI_CONFIG.Colors.Text,
        TextSize = 14,
        TextWrapped = true
    }, function()
        if state.switchingTab then return end
        state.switchingTab = true
        local targetIndex = i
        local targetX = (targetIndex - 1) * (#tabs * 100) -- Approx width per tab
        scrollingFrame:TweenPosition(UDim2.new(-targetX / (scrollingFrame.AbsoluteSize.X or 400), 0, 0, 0), "Out", "Quad", 0.3, true)
        for name, panel in pairs(panels) do
            panel.Visible = (name == tabName)
        end
        tabOutline:TweenPosition(UDim2.new(xPos, 0, 0.07, 0), "Out", "Quad", 0.3, true)
        state.currentTab = tabName
        task.wait(0.3)
        state.switchingTab = false
    end)
    tabButtons[tabName] = button
end

-- ============================================================================
-- FEATURE IMPLEMENTATIONS
-- ============================================================================

-- Noclip
local noclipConnection
local function toggleNoclip(enable)
    if enable then
        noclipConnection = RunService.Stepped:Connect(function()
            if state.noclip then
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Fly
local flyBodyVelocity
local function toggleFly(enable)
    if enable then
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Parent = hrp
        local flyConnection
        flyConnection = RunService.RenderStepped:Connect(function()
            if not state.fly or not player.Character then
                flyConnection:Disconnect()
                if flyBodyVelocity then flyBodyVelocity:Destroy() end
                return
            end
            local direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0, 1, 0) end
            direction = direction.Unit * state.flySpeed
            flyBodyVelocity.Velocity = direction
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
        end)
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end

-- Speed
local function setSpeed(value)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end
end

-- Jump Power
local function setJumpPower(value)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = value end
    end
end

-- Infinite Jump
local infiniteJumpConnection
local function toggleInfiniteJump(enable)
    if enable then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
    end
end

-- Kill Nearest Player
local function killNearest()
    local nearest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local mag = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                nearest = plr
            end
        end
    end
    if nearest and nearest.Character then
        nearest.Character:BreakJoints()
    end
end

-- ESP
local espObjects = {}
local function updateESP()
    for _, obj in ipairs(espObjects) do obj:Destroy() end
    espObjects = {}
    if not state.espEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = root
                box.Size = Vector3.new(3, 5, 3)
                box.Color3 = GUI_CONFIG.Colors.Danger
                box.Transparency = 0.5
                box.ZIndex = 0
                box.Parent = root
                table.insert(espObjects, box)
                
                local nameTag = Instance.new("BillboardGui")
                nameTag.Adornee = root
                nameTag.Size = UDim2.new(0, 100, 0, 30)
                nameTag.StudsOffset = Vector3.new(0, 2.5, 0)
                nameTag.Parent = root
                local textLabel = Instance.new("TextLabel", nameTag)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = plr.Name
                textLabel.TextColor3 = GUI_CONFIG.Colors.Text
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                table.insert(espObjects, nameTag)
            end
        end
    end
end

-- Auto Clicker
local autoClickConnection
local function toggleAutoClicker(enable)
    if enable then
        autoClickConnection = RunService.Stepped:Connect(function()
            if state.autoClicker then
                local target = mouse.Target
                if target then
                    target:Click()
                end
                task.wait(state.autoClickDelay)
            end
        end)
    else
        if autoClickConnection then autoClickConnection:Disconnect() end
    end
end

-- Gamepass Giver (local simulation)
local function giveGamepass(passId)
    -- This only changes local appearance, not actual purchase
    local success, result = pcall(function()
        local MarketplaceService = game:GetService("MarketplaceService")
        local owned = MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
        if not owned then
            -- Simulate ownership by overriding UserOwnsGamePassAsync for this script
            local mt = getrawmetatable(game)
            local old = mt.__index
            setreadonly(mt, false)
            mt.__index = function(self, key)
                if key == "UserOwnsGamePassAsync" then
                    return function(_, userId, id)
                        if id == passId and userId == player.UserId then
                            return true
                        end
                        return old(self, key)(self, userId, id)
                    end
                end
                return old(self, key)
            end
            setreadonly(mt, true)
            print("[VIRO] Gamepass " .. passId .. " simulated!")
        else
            print("[VIRO] You already own this gamepass.")
        end
    end)
    if not success then
        warn("[VIRO] Gamepass simulation failed: " .. tostring(result))
    end
end

-- Teleport to Mouse
local function teleportToMouse()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
    end
end

-- ============================================================================
-- UI POPULATION
-- ============================================================================

-- Movement Tab
CreateToggle(panels.Movement, "Noclip", false, function(val) state.noclip = val; toggleNoclip(val) end)
CreateToggle(panels.Movement, "Fly", false, function(val) state.fly = val; toggleFly(val) end)
CreateSlider(panels.Movement, { Name = "Fly Speed", Min = 10, Max =
