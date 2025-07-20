--[[
    Final Personalized Version for Potato King - V5 (URL FIX)
    - All credits remain for "Potato King" and "https://potatoking.net".
    - FIXED: Updated the URLs for the Redz Hub and Bounty Hunting scripts in the Blox Fruits selector.
    - Retains all previous features including the script selector, cancellable loaders, debounce, and error handling.
]]

-- Game ID Tables
local bedwarsIds = {
    [6872265039] = true, -- Lobby
    [8444591321] = true, -- Game (normal)
    [8560631822] = true, -- Game Mega
    [8560630086] = true, -- Game Micro
    [6872274481] = true, -- real
}

local baseplateIds = {
    [4483381587] = true,
    [17574618959] = true
}

local arsenalIds = {
    [286090429] = true
}

local mm2Ids = {
    [142823291] = true
}

local brookhavenIds = {
    [4924922222] = true
}

local bloxFruitsIds = {
    [2753915549] = true, -- First Sea
    [4442272183] = true, -- Second Sea
    [7449423635] = true  -- Third Sea
}

local growAGardenIds = {
    [10321728347] = true -- Correct, verified Main Game ID
}


-- Roblox Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Animation settings
local ANIM_SPEED = 0.4
local EASE_STYLE = Enum.EasingStyle.Quint
local EASE_DIR_IN = Enum.EasingDirection.Out
local EASE_DIR_OUT = Enum.EasingDirection.In

-- Debounce flag to prevent multiple GUIs
local isGuiActive = false

-- Helper Functions
local function animateOutAndDestroy(gui)
    if not gui or not gui:IsA("ScreenGui") or not gui.Parent then return end
    
    local frame = gui:FindFirstChildOfClass("Frame")
    if frame then
        local endPos = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, -1, 0)
        local tween = TweenService:Create(frame, TweenInfo.new(ANIM_SPEED, EASE_STYLE, EASE_DIR_OUT), {Position = endPos, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Wait()
    end
    gui:Destroy()
    isGuiActive = false -- Reset debounce flag
end

local function clearGui(name)
    local existing = CoreGui:FindFirstChild(name)
    if existing then
        animateOutAndDestroy(existing)
    end
end

local function createStyledFrame(parent, size, startPosition, endPosition)
    local frame = Instance.new("Frame", parent)
    frame.Size = size
    frame.Position = startPosition
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    })
    gradient.Rotation = 90
    
    TweenService:Create(frame, TweenInfo.new(ANIM_SPEED, EASE_STYLE, EASE_DIR_IN), {Position = endPosition, BackgroundTransparency = 0.1}):Play()

    return frame
end

local function createButton(parent, text, size, position, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = size
    button.Position = position
    local originalColor = Color3.fromRGB(80, 80, 90)
    button.BackgroundColor3 = originalColor
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    
    local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    local hoverColor = originalColor:Lerp(Color3.new(1,1,1), 0.2)

    button.MouseEnter:Connect(function() TweenService:Create(button, hoverTweenInfo, {BackgroundColor3 = hoverColor, Size = size * 1.05}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, hoverTweenInfo, {BackgroundColor3 = originalColor, Size = size}):Play() end)
    button.MouseButton1Down:Connect(function() TweenService:Create(button, hoverTweenInfo, {Size = size * 0.95}):Play() end)
    button.MouseButton1Up:Connect(function() TweenService:Create(button, hoverTweenInfo, {Size = size}):Play() end)
    
    if callback then button.MouseButton1Click:Connect(callback) end
    
    return button
end

local function secureLoadstring(url)
    local success, scriptContent = pcall(function() return game:HttpGet(url, true) end)
    
    if success and scriptContent then
        local success_load, err = pcall(loadstring(scriptContent))
        if not success_load then
            warn("Loadstring execution error:", err)
            StarterGui:SetCore("SendNotification", { Title = "Script Error", Text = "The script failed to execute.", Duration = 5 })
        end
    else
        warn("Failed to get script from URL:", url)
        StarterGui:SetCore("SendNotification", { Title = "Network Error", Text = "Could not load script. The source may be down.", Duration = 5 })
    end
end

-- GUI Functions

local function createLoaderGui(titleText, creditText, scriptUrl)
    if isGuiActive then return end
    isGuiActive = true
    clearGui("CheatEngineLoader")

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "CheatEngineLoader"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local isCancelled = false -- Flag to track if loading was cancelled

    local frame = createStyledFrame(gui, UDim2.new(0, 420, 0, 200), UDim2.new(0.5, -210, -0.5, 0), UDim2.new(0.5, -210, 0.5, -100))
    
    -- Close button to cancel loading
    local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
        isCancelled = true
        animateOutAndDestroy(gui)
    end)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    
    local elementsToFade = {}

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -50, 0, 90); title.Position = UDim2.new(0, 25, 0, 10)
    title.BackgroundTransparency = 1; title.Text = "Loading " .. titleText .. " Scripts..."
    title.Font = Enum.Font.FredokaOne; title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1); title.TextTransparency = 1
    table.insert(elementsToFade, title)

    local credit = Instance.new("TextLabel", frame)
    credit.Size = UDim2.new(1, -20, 0, 30); credit.Position = UDim2.new(0, 10, 0, 105)
    credit.BackgroundTransparency = 1; credit.Font = Enum.Font.SourceSans
    credit.Text = "Script by " .. creditText; credit.TextColor3 = Color3.fromRGB(255, 255, 200)
    credit.TextScaled = true; credit.TextTransparency = 1
    table.insert(elementsToFade, credit)

    local copyButton = createButton(frame, "Copy: https://potatoking.net", UDim2.new(0, 320, 0, 40), UDim2.new(0.5, -160, 0, 140), function()
        pcall(function() UserInputService:SetClipboardAsync("https://potatoking.net") end)
        StarterGui:SetCore("SendNotification", { Title = "Copied!", Text = "Link copied to clipboard", Duration = 3 })
    end)
    copyButton.BackgroundTransparency = 1; copyButton.TextTransparency = 1
    table.insert(elementsToFade, copyButton)

    task.wait(ANIM_SPEED)
    for _, element in ipairs(elementsToFade) do
        TweenService:Create(element, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        if element:IsA("TextButton") then
            TweenService:Create(element, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
        end
        task.wait(0.1)
    end
    
    task.wait(2)

    -- Only load the script if the user hasn't cancelled
    if not isCancelled then
        secureLoadstring(scriptUrl)
        title.Text = "Scripts loaded. Cheat responsibly."

        task.delay(1.5, function()
            -- Check if GUI still exists before trying to destroy it
            if gui and gui.Parent then
                animateOutAndDestroy(gui)
            end
        end)
    else
        print("Script loading cancelled by user.")
    end
end

local function showUnsupportedGui()
	if isGuiActive then return end; isGuiActive = true
	clearGui("UnsupportedGameGUI")
	
	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "UnsupportedGameGUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local frame = createStyledFrame(gui, UDim2.new(0, 500, 0, 310), UDim2.new(0.5, -250, -0.5, 0), UDim2.new(0.5, -250, 0.5, -155))

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 50); title.Position = UDim2.new(0, 0, 0, 10)
	title.BackgroundTransparency = 1; title.Text = "Unsupported Game"
	title.Font = Enum.Font.FredokaOne; title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 80, 80)

	local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
		animateOutAndDestroy(gui)
	end)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    
	local statusBox = Instance.new("TextLabel", frame)
	statusBox.Size = UDim2.new(1, -40, 0, 30); statusBox.Position = UDim2.new(0.5, -230, 0, 120)
	statusBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45); statusBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusBox.Font = Enum.Font.Code; statusBox.TextSize = 16; statusBox.Text = "Executed Infinite Yield"
	Instance.new("UICorner", statusBox).CornerRadius = UDim.new(0, 8)

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, -40, 0, 0); scroll.Position = UDim2.new(0.5, -230, 0, 160)
	scroll.BackgroundTransparency = 0.8; scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 170); scroll.ScrollBarThickness = 4
    scroll.ClipsDescendants = true
	Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 10)

    local scrollOpen = false
    local scrollTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic)
    
    local toggleButton = createButton(frame, "Show Supported Games", UDim2.new(0, 400, 0, 40), UDim2.new(0.5, -200, 0, 70), function()
        scrollOpen = not scrollOpen
        local goalSize = scrollOpen and UDim2.new(1, -40, 0, 130) or UDim2.new(1, -40, 0, 0)
        TweenService:Create(scroll, scrollTweenInfo, {Size = goalSize}):Play()
        toggleButton.Text = scrollOpen and "Hide Supported Games" or "Show Supported Games"
    end)

	local text = Instance.new("TextLabel", scroll)
	text.Size = UDim2.new(1, -10, 0, 170); text.Position = UDim2.new(0, 5, 0, 0)
	text.BackgroundTransparency = 1; text.Font = Enum.Font.SourceSans
	text.TextColor3 = Color3.new(1, 1, 1); text.TextSize = 18
	text.TextXAlignment = Enum.TextXAlignment.Left; text.TextYAlignment = Enum.TextYAlignment.Top
	text.TextWrapped = true
	text.Text = "✅ Blox Fruits (All Seas)\n✅ Bedwars\n✅ Arsenal\n✅ MM2\n✅ Brookhaven\n✅ Baseplates\nMore Coming Soon! :D"

	secureLoadstring("https://rawscripts.net/raw/Universal-Script-Infinite-Yield-31802")
end

local function showTrollGui()
	if isGuiActive then return end; isGuiActive = true
	clearGui("TrollPromptGUI")
	
	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "TrollPromptGUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local frame = createStyledFrame(gui, UDim2.new(0, 450, 0, 220), UDim2.new(0.5, -225, 1.2, 0), UDim2.new(0.5, -225, 0.5, -110))

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -20, 0, 120); label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1; label.Text = "You've entered a baseplate game.\nWould you like to load the Troll Scripts?"
	label.Font = Enum.Font.FredokaOne; label.TextScaled = true
	label.TextColor3 = Color3.new(1, 1, 1); label.TextWrapped = true

	createButton(frame, "Load Troll Scripts", UDim2.new(0, 320, 0, 50), UDim2.new(0.5, -160, 0, 140), function()
        animateOutAndDestroy(gui)
		secureLoadstring("https://pastebin.com/raw/BeD6acHx")
	end)

    local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
		animateOutAndDestroy(gui)
	end)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)

	local glow = Instance.new("UIStroke", frame)
	glow.Thickness = 3; glow.Color = Color3.fromRGB(255, 0, 120); glow.Transparency = 1
    
    task.wait(ANIM_SPEED)
    local glowTween = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.4})
    glowTween:Play()
    gui.Destroying:Connect(function() glowTween:Cancel() end)
end

local function showBloxFruitsGui()
    if isGuiActive then return end; isGuiActive = true
    clearGui("BloxFruitsSelectorGUI")
    
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "BloxFruitsSelectorGUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local frame = createStyledFrame(gui, UDim2.new(0, 480, 0, 260), UDim2.new(0.5, -240, -0.5, 0), UDim2.new(0.5, -240, 0.5, -130))

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 80); label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1; label.Text = "Blox Fruits Script Selector"
    label.Font = Enum.Font.FredokaOne; label.TextScaled = true
    label.TextColor3 = Color3.new(1, 1, 1); label.TextWrapped = true

    local btnSize = UDim2.new(0, 400, 0, 50)
    
    -- ### UPDATED URL ###
    createButton(frame, "Load Bounty Hunting Script", btnSize, UDim2.new(0.5, -200, 0, 100), function()
        animateOutAndDestroy(gui)
        createLoaderGui("Bounty Hunting", "Potato King", "https://pastebin.com/raw/ms6xUMyL")
    end)

    -- ### UPDATED URL ###
    createButton(frame, "Load Redz Hub", btnSize, UDim2.new(0.5, -200, 0, 170), function()
        animateOutAndDestroy(gui)
        createLoaderGui("Redz Hub", "Potato King", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")
    end)
    
    local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
        animateOutAndDestroy(gui)
    end)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end

-- Main Entry Point
if isGuiActive then
    print("Script halted: A GUI is already active.")
else
    if bedwarsIds[game.PlaceId] then
        createLoaderGui("Bedwars", "Potato King", "https://pastebin.com/raw/CbB2Jjvv")
    elseif baseplateIds[game.PlaceId] then
        showTrollGui()
    elseif arsenalIds[game.PlaceId] then
        createLoaderGui("Arsenal", "Potato King", "https://pastebin.com/raw/pGcShZi1")
    elseif mm2Ids[game.PlaceId] then
        createLoaderGui("MM2", "Potato King", "https://pastebin.com/raw/K7s997bZ")
    elseif brookhavenIds[game.PlaceId] then
        createLoaderGui("Brookhaven", "Potato King", "https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/main/Brook%20Haven%20Gui")
    elseif bloxFruitsIds[game.PlaceId] then
        showBloxFruitsGui() -- Show the selection menu for Blox Fruits
    elseif growAGardenIds[game.PlaceId] then
        createLoaderGui("Grow a Garden", "Potato King", "https://raw.githubusercontent.com/orinc-dev/scripts/main/grow-a-garden-orinc")
    else
        showUnsupportedGui()
    end
end
