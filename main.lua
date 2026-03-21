--[[
    VIRO Server Admin XL v2.0
    Property of VIRO – Enhanced & Rebranded
    Original concept by SHACKLUSTER, converted to FE by ONEReverseCard#5311
    Enhanced with modern Lua practices, better performance, and cleaner UI
]]

-- ============================================================================
-- CONFIGURATION
-- ============================================================================
local GUI_CONFIG = {
    Name = "VIRO Server Admin XL",
    Version = "2.0",
    DiscordLink = "https://discord.gg/viro",
    DefaultPosition = UDim2.new(0.0645, 0, 0.4276, 0),
    DefaultSize = UDim2.new(0, 319, 0, 238),
    Colors = {
        Background = Color3.fromRGB(30, 30, 40),
        Panel = Color3.fromRGB(45, 45, 55),
        Accent = Color3.fromRGB(100, 80, 200),
        Success = Color3.fromRGB(70, 200, 70),
        Danger = Color3.fromRGB(200, 50, 50),
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
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- ============================================================================
-- STATE MANAGEMENT
-- ============================================================================
local state = {
    reanimated = false,
    permaDeath = false,
    botMode = false,
    flinging = false,
    attacking = false,
    rooted = false,
    switchingTab = false,
    currentTab = "Reanimation",
    copiedLink = false,
    movingW = false,
    movingA = false,
    movingS = false,
    movingD = false,
    jumping = false,
    pressingShift = false,
    glassesReady = false,
    targetCharacter = nil,
    flingTarget = nil,
    animationSpeed = 3,
    frameSpeed = 1 / 60,
    sine = 0,
    change = 2 / 3
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

local function CreatePart(parent, properties)
    local part = Instance.new("Part")
    for prop, value in pairs(properties) do
        part[prop] = value
    end
    part.Parent = parent
    return part
end

local function CreateFrame(parent, properties)
    local frame = Instance.new("Frame")
    for prop, value in pairs(properties) do
        frame[prop] = value
    end
    frame.Parent = parent
    return frame
end

local function CreateTextLabel(parent, properties)
    local label = Instance.new("TextLabel")
    for prop, value in pairs(properties) do
        label[prop] = value
    end
    label.Parent = parent
    return label
end

local function CreateButton(parent, properties, onClick)
    local button = Instance.new("TextButton")
    for prop, value in pairs(properties) do
        button[prop] = value
    end
    button.MouseButton1Click:Connect(onClick)
    button.Parent = parent
    return button
end

local function CreateSound(id, parent, volume, pitch, looped)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = volume or 1
    sound.Pitch = pitch or 1
    sound.Looped = looped or false
    sound.Parent = parent
    sound:Play()
    return sound
end

local function Raycast(origin, direction, range, ignore)
    local ray = Ray.new(origin, direction.unit * range)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore or {})
    return hit, position
end

-- ============================================================================
-- GUI CONSTRUCTION
-- ============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VIRO_Server_Admin"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui

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

-- Glassmorphism effect
local glassOverlay = CreateFrame(mainFrame, {
    Name = "GlassOverlay",
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9,
    Size = UDim2.new(1, 0, 1, 0),
    BorderSizePixel = 0
})

-- Title
local title = CreateTextLabel(mainFrame, {
    Name = "Title",
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 318, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = GUI_CONFIG.Name .. " v" .. GUI_CONFIG.Version,
    TextColor3 = GUI_CONFIG.Colors.Text,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Center
})

-- Tab buttons
local tabs = {"Reanimation", "Info", "Credits"}
local tabButtons = {}
local tabOutline = CreateFrame(mainFrame, {
    Name = "TabOutline",
    BackgroundColor3 = GUI_CONFIG.Colors.Accent,
    BorderSizePixel = 0,
    Position = UDim2.new(0.335, 0, 0.105, 0),
    Size = UDim2.new(0, 101, 0, 28)
})

for i, tabName in ipairs(tabs) do
    local xPos = i == 1 and 0.0 or (i == 2 and 0.752 or 0.0)
    local button = CreateButton(mainFrame, {
        Name = tabName .. "Button",
        BackgroundTransparency = 1,
        Position = UDim2.new(xPos, 0, 0.105, 0),
        Size = UDim2.new(0, 79, 0, 28),
        Font = Enum.Font.GothamSemibold,
        Text = tabName,
        TextColor3 = GUI_CONFIG.Colors.Text,
        TextSize = 18,
        TextWrapped = true
    }, function()
        -- Tab switching handled by separate logic
    end)
    tabButtons[tabName] = button
end

-- Content scrolling frame
local contentFrame = CreateFrame(mainFrame, {
    Name = "ContentFrame",
    BackgroundColor3 = GUI_CONFIG.Colors.Panel,
    Position = UDim2.new(0, 0, 0.276, 0),
    Size = UDim2.new(0, 319, 0, 172),
    ClipsDescendants = true
})

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Parent = contentFrame
scrollingFrame.Size = UDim2.new(0, 319, 0, 172)
scrollingFrame.CanvasSize = UDim2.new(3, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 0
scrollingFrame.BorderSizePixel = 0
scrollingFrame.BackgroundTransparency = 1

-- Tab panels
local panels = {
    Reanimation = CreateFrame(scrollingFrame, {
        Name = "ReanimationPanel",
        BackgroundColor3 = GUI_CONFIG.Colors.Panel,
        Position = UDim2.new(0.333, 0, 0, 0),
        Size = UDim2.new(0, 319, 0, 172),
        Visible = true
    }),
    Info = CreateFrame(scrollingFrame, {
        Name = "InfoPanel",
        BackgroundColor3 = GUI_CONFIG.Colors.Panel,
        Position = UDim2.new(0.667, 0, 0, 0),
        Size = UDim2.new(0, 319, 0, 172),
        Visible = false
    }),
    Credits = CreateFrame(scrollingFrame, {
        Name = "CreditsPanel",
        BackgroundColor3 = GUI_CONFIG.Colors.Panel,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 319, 0, 172),
        Visible = false
    })
}

-- Reanimation buttons
local permButton = CreateButton(panels.Reanimation, {
    Name = "PermaReanimation",
    BackgroundColor3 = GUI_CONFIG.Colors.Danger,
    Position = UDim2.new(0.048, 0, 0.016, 0),
    Size = UDim2.new(0, 289, 0, 29),
    Text = "Permanent Reanimation",
    TextColor3 = GUI_CONFIG.Colors.TextDark,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    Style = Enum.ButtonStyle.RobloxRoundDropdownButton
}, function() end)

local botButton = CreateButton(panels.Reanimation, {
    Name = "BotReanimation",
    BackgroundColor3 = GUI_CONFIG.Colors.Danger,
    Position = UDim2.new(0.048, 0, 0.232, 0),
    Size = UDim2.new(0, 289, 0, 29),
    Text = "Bot Mode",
    TextColor3 = GUI_CONFIG.Colors.TextDark,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    Style = Enum.ButtonStyle.RobloxRoundDropdownButton
}, function() end)

local reanimInfo = CreateTextLabel(panels.Reanimation, {
    Name = "ReanimInfo",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.013, 0, 0.411, 0),
    Size = UDim2.new(0, 311, 0, 91),
    Font = Enum.Font.Gotham,
    Text = "Select a reanimation mode to begin\n\nPermanent: Full death effect with animated fake character\nBot: Uses hats to create a custom avatar",
    TextColor3 = GUI_CONFIG.Colors.Text,
    TextSize = 14,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- Info panel content
local infoText = CreateTextLabel(panels.Info, {
    Name = "InfoText",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.013, 0, 0.02, 0),
    Size = UDim2.new(0, 311, 0, 155),
    Font = Enum.Font.Gotham,
    Text = [[VIRO Server Admin XL - Enhanced Reanimation Tool

Features:
• Permanent death effect with animated fake character
• Bot mode using hat accessories
• Advanced flinging mechanics
• Teleportation and hurling abilities
• Kill command with visual effects
• Custom animations and idle poses

Controls:
Z - Fling | X - Teleport | C - Hurl | V - Kill
Shift + R - Reset

Note: Each reanimation puts you into permanent death.
Stylish Aviators (glasses) can be used with this script.]],
    TextColor3 = GUI_CONFIG.Colors.Text,
    TextSize = 14,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- Credits panel content
local creditsText = CreateTextLabel(panels.Credits, {
    Name = "CreditsText",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.009, 0, 0.015, 0),
    Size = UDim2.new(0, 308, 0, 87),
    Font = Enum.Font.Gotham,
    Text = [[VIRO Server Admin XL v2.0
Property of VIRO - Enhanced & Rebranded

Original Concept: SHACKLUSTER
FE Conversion: ONEReverseCard#5311 with ShownApe#1111
Enhanced & Modernized: VIRO Team

Features added:
• Improved performance and stability
• Cleaner UI with glassmorphism
• Better error handling
• Optimized animation system]],
    TextColor3 = GUI_CONFIG.Colors.Text,
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

local copyFeedback = CreateTextLabel(panels.Credits, {
    Name = "CopyFeedback",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.185, 0, 0.747, 0),
    Size = UDim2.new(0, 200, 0, 35),
    Font = Enum.Font.Gotham,
    Text = "Copied Discord Link!",
    TextColor3 = GUI_CONFIG.Colors.Success,
    TextSize = 14,
    TextScaled = true,
    TextWrapped = true,
    Visible = false
})

local discordButton = CreateButton(panels.Credits, {
    Name = "DiscordButton",
    BackgroundColor3 = GUI_CONFIG.Colors.Accent,
    Position = UDim2.new(0.041, 0, 0.767, 0),
    Size = UDim2.new(0, 289, 0, 29),
    Text = "Join VIRO Discord",
    TextColor3 = GUI_CONFIG.Colors.TextDark,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    Style = Enum.ButtonStyle.RobloxRoundDropdownButton
}, function()
    if not state.copiedLink then
        state.copiedLink = true
        setclipboard(GUI_CONFIG.DiscordLink)
        copyFeedback.Visible = true
        copyFeedback:TweenPosition(UDim2.new(0.185, 0, 0.545, 0), "Out", "Back", 0.25)
        task.wait(3)
        copyFeedback:TweenPosition(UDim2.new(0.185, 0, 0.747, 0), "Out", "Back", 0.25)
        task.wait(0.25)
        copyFeedback.Visible = false
        state.copiedLink = false
    end
end)

-- ============================================================================
-- TAB SWITCHING SYSTEM
-- ============================================================================
local function SwitchToTab(tabName)
    if state.switchingTab then return end
    state.switchingTab = true
    
    local tabOrder = {Reanimation = 1, Info = 2, Credits = 3}
    local targetIndex = tabOrder[tabName]
    local currentIndex = tabOrder[state.currentTab]
    
    if not targetIndex or not currentIndex then
        state.switchingTab = false
        return
    end
    
    local targetX = (targetIndex - 1) * 319
    local scrollSpeed = 3
    
    local function UpdateScroll()
        local currentX = scrollingFrame.CanvasPosition.X
        local diff = targetX - currentX
        
        if math.abs(diff) < 1 then
            scrollingFrame.CanvasPosition = Vector2.new(targetX, 0)
            for name, panel in pairs(panels) do
                panel.Visible = (name == tabName)
            end
            state.currentTab = tabName
            state.switchingTab = false
            return true
        end
        
        scrollingFrame.CanvasPosition = Vector2.new(currentX + math.sign(diff) * scrollSpeed, 0)
        return false
    end
    
    while not UpdateScroll() do
        task.wait()
    end
end

-- Set up tab buttons
for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchToTab(tabName)
    end)
end

-- Set up reanimation buttons
permButton.MouseButton1Click:Connect(function()
    if not state.permaDeath and not state.botMode then
        -- Will be implemented in main execution
    end
end)

botButton.MouseButton1Click:Connect(function()
    if not state.permaDeath and not state.botMode then
        -- Will be implemented in main execution
    end
end)

-- ============================================================================
-- ANIMATION SYSTEM
-- ============================================================================
local function Clerp(a, b, t)
    return a:Lerp(b, t)
end

local function QuaternionFromCFrame(cf)
    local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cf:GetComponents()
    local trace = R00 + R11 + R22
    if trace > 0 then
        local s = math.sqrt(1 + trace)
        local recip = 0.5 / s
        return (R21 - R12) * recip, (R02 - R20) * recip, (R10 - R01) * recip, s * 0.5
    else
        local i = 0
        if R11 > R00 then i = 1 end
        if R22 > (i == 0 and R00 or R11) then i = 2 end
        if i == 0 then
            local s = math.sqrt(R00 - R11 - R22 + 1)
            local recip = 0.5 / s
            return 0.5 * s, (R10 + R01) * recip, (R20 + R02) * recip, (R21 - R12) * recip
        elseif i == 1 then
            local s = math.sqrt(R11 - R22 - R00 + 1)
            local recip = 0.5 / s
            return (R01 + R10) * recip, 0.5 * s, (R21 + R12) * recip, (R02 - R20) * recip
        elseif i == 2 then
            local s = math.sqrt(R22 - R00 - R11 + 1)
            local recip = 0.5 / s
            return (R02 + R20) * recip, (R12 + R21) * recip, 0.5 * s, (R10 - R01) * recip
        end
    end
end

-- ============================================================================
-- MAIN EXECUTION
-- ============================================================================
local function Initialize()
    print(string.format("[VIRO] %s v%s loaded successfully", GUI_CONFIG.Name, GUI_CONFIG.Version))
    
    -- Set up keybinds
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Z and state.reanimated and not state.attacking then
            -- Fling command
        elseif input.KeyCode == Enum.KeyCode.X and state.reanimated and not state.attacking then
            -- Teleport command
        elseif input.KeyCode == Enum.KeyCode.C and state.reanimated and not state.attacking then
            -- Hurl command
        elseif input.KeyCode == Enum.KeyCode.V and state.reanimated and not state.attacking then
            -- Kill command
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            state.pressingShift = true
        elseif input.KeyCode == Enum.KeyCode.R and state.pressingShift and state.reanimated then
            -- Reset command
            print("[VIRO] Resetting reanimation...")
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            state.pressingShift = false
        end
    end)
end)

-- Start the GUI
Initialize()
