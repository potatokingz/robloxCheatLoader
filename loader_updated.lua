--[[
    Final Personalized Version for Potato King - V3 (FIXED & IMPROVED)
    - FIXED the game ID for "Grow a Garden" to ensure it is detected correctly.
    - All credits remain for "Potato King" and "https://potatoking.net".
    - Retains all previous features like animations, UI fixes, and other game support.
    - Added debounce to prevent GUI spam, improved error handling, and updated clipboard functionality.
    - Added a selection GUI for Blox Fruits Third Sea (Bounty Hunting vs. Redz).
    - Added a close button to the loading GUI for all games.
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

-- ### FIX: Corrected Game ID ###
local growAGardenIds = {
    [10321728347] = true -- Correct, verified Main Game ID
}


-- Roblox Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService") -- For modern clipboard access

-- Animation settings for consistency
local ANIM_SPEED = 0.4
local EASE_STYLE = Enum.EasingStyle.Quint
local EASE_DIR_IN = Enum.EasingDirection.Out
local EASE_DIR_OUT = Enum.EasingDirection.In

-- Debounce flag to prevent multiple GUI creations
local isGuiActive = false
local scriptLoadingThread = nil

-- Helper Functions
local function animateOutAndDestroy(gui)
    if not gui or not gui.Parent then return end
    isGuiActive = false
    local frame = gui:FindFirstChildOfClass("Frame")
    if frame then
        local endPos = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, -0.5, 0)
        TweenService:Create(frame, TweenInfo.new(ANIM_SPEED, EASE_STYLE, EASE_DIR_OUT), {Position = endPos, BackgroundTransparency = 1}):Play()
        task.wait(ANIM_SPEED)
    end
    gui:Destroy()
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

    button.MouseEnter:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {BackgroundColor3 = hoverColor, Size = size * 1.05}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {BackgroundColor3 = originalColor, Size = size}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {Size = size * 0.95}):Play()
    end)
    button.MouseButton1Up:Connect(function()
         TweenService:Create(button, hoverTweenInfo, {Size = size}):Play()
    end)

    button.MouseButton1Click:Connect(callback)

    return button
end

-- GUI Functions
local function showUnsupportedGui()
    if isGuiActive then return end
    isGuiActive = true
	clearGui("UnsupportedGameGUI")

	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "UnsupportedGameGUI"

	local frame = createStyledFrame(gui, UDim2.new(0, 500, 0, 310), UDim2.new(0.5, -250, -0.5, 0), UDim2.new(0.5, -250, 0.5, -155))

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 50)
	title.Position = UDim2.new(0, 0, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "Unsupported Game"
	title.Font = Enum.Font.FredokaOne
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 80, 80)

	local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
		animateOutAndDestroy(gui)
	end)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

	local statusBox = Instance.new("TextLabel", frame)
	statusBox.Size = UDim2.new(1, -40, 0, 30)
	statusBox.Position = UDim2.new(0.5, -230, 0, 120)
	statusBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	statusBox.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusBox.Font = Enum.Font.Code
	statusBox.TextSize = 16
	statusBox.Text = "Executed Infinite Yield"
	Instance.new("UICorner", statusBox).CornerRadius = UDim.new(0, 8)

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, -40, 0, 0)
	scroll.Position = UDim2.new(0.5, -230, 0, 160)
	scroll.BackgroundTransparency = 0.8
	scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 170)
	scroll.ScrollBarThickness = 4
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
	text.Size = UDim2.new(1, -10, 0, 170)
	text.Position = UDim2.new(0, 5, 0, 0)
	text.BackgroundTransparency = 1
	text.Font = Enum.Font.SourceSans
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextSize = 18
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextYAlignment = Enum.TextYAlignment.Top
	text.TextWrapped = true
	text.Text = "✅ Blox Fruits (All Seas)\n✅ Bedwars\n✅ Arsenal\n✅ MM2\n✅ Brookhaven\n✅ Baseplates\nMore Coming Soon! :D"

	pcall(function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-Yield-31802"))()
	end)
end

local function showTrollGui()
    if isGuiActive then return end
    isGuiActive = true
	clearGui("TrollPromptGUI")

	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "TrollPromptGUI"

	local frame = createStyledFrame(gui, UDim2.new(0, 450, 0, 220), UDim2.new(0.5, -225, 1.2, 0), UDim2.new(0.5, -225, 0.5, -110))

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -20, 0, 120)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = "You've entered a baseplate game.\nWould you like to load the Troll Scripts?"
	label.Font = Enum.Font.FredokaOne
	label.TextScaled = true
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextWrapped = true

	createButton(frame, "Load Troll Scripts", UDim2.new(0, 320, 0, 50), UDim2.new(0.5, -160, 0, 140), function()
        animateOutAndDestroy(gui)
		pcall(function()
			loadstring(game:HttpGet("https://pastebin.com/raw/BeD6acHx"))()
		end)
	end)

	local glow = Instance.new("UIStroke", frame)
	glow.Thickness = 3
	glow.Color = Color3.fromRGB(255, 0, 120)
	glow.Transparency = 1

    task.wait(ANIM_SPEED)
    local glowTween = TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.4})
    glowTween:Play()
    gui.Destroying:Connect(function() glowTween:Cancel() end)
end

local function createLoaderGui(titleText, creditText, scriptUrl)
    if isGuiActive then return end
    isGuiActive = true
    clearGui("CheatEngineLoader")

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "CheatEngineLoader"

    local frame = createStyledFrame(gui, UDim2.new(0, 420, 0, 200), UDim2.new(0.5, -210, -0.5, 0), UDim2.new(0.5, -210, 0.5, -100))

    local elementsToFade = {}

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -20, 0, 90)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Loading " .. titleText .. " Scripts..."
    title.Font = Enum.Font.FredokaOne
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextTransparency = 1
    table.insert(elementsToFade, title)
    
    local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
        if scriptLoadingThread then
            task.cancel(scriptLoadingThread)
            scriptLoadingThread = nil
        end
		animateOutAndDestroy(gui)
	end)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

    local credit = Instance.new("TextLabel", frame)
    credit.Size = UDim2.new(1, -20, 0, 30)
    credit.Position = UDim2.new(0, 10, 0, 105)
    credit.BackgroundTransparency = 1
    credit.Font = Enum.Font.SourceSans
    credit.Text = "Script by " .. creditText
    credit.TextColor3 = Color3.fromRGB(255, 255, 200)
    credit.TextScaled = true
    credit.TextTransparency = 1
    table.insert(elementsToFade, credit)

    local copyButton = createButton(frame, "Copy: https://potatoking.net", UDim2.new(0, 320, 0, 40), UDim2.new(0.5, -160, 0, 140), function()
        if UserInputService and UserInputService.SetClipboardAsync then
            pcall(UserInputService.SetClipboardAsync, UserInputService, "https://potatoking.net")
        end
        StarterGui:SetCore("SendNotification", { Title = "Copied!", Text = "Link copied to clipboard", Duration = 3 })
    end)
    copyButton.BackgroundTransparency = 1
    copyButton.TextTransparency = 1
    table.insert(elementsToFade, copyButton)

    task.wait(ANIM_SPEED)
    for _, element in ipairs(elementsToFade) do
        TweenService:Create(element, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        if element:IsA("GuiObject") then
            local targetTransparency = element.BackgroundColor3 == Color3.fromRGB(80, 80, 90) and 0 or 1
            TweenService:Create(element, TweenInfo.new(0.5), {BackgroundTransparency = targetTransparency}):Play()
        end
        task.wait(0.1)
    end

    task.wait(2)

    scriptLoadingThread = task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(scriptUrl, true))()
        end)
        pcall(function()
            print("executing scripts :D")
        end)
        scriptLoadingThread = nil
    end)


    title.Text = "Scripts loaded. Cheat responsibly."

    task.delay(1.5, function()
        if gui and gui.Parent then
            animateOutAndDestroy(gui)
        end
    end)
end

local function showBloxFruitsThirdSeaGui()
    if isGuiActive then return end
    isGuiActive = true
    clearGui("BloxFruitsThirdSeaGUI")

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "BloxFruitsThirdSeaGUI"

    local frame = createStyledFrame(gui, UDim2.new(0, 450, 0, 260), UDim2.new(0.5, -225, -0.5, 0), UDim2.new(0.5, -225, 0.5, -130))

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Third Sea Scripts"
    title.Font = Enum.Font.FredokaOne
    title.TextScaled = true
    title.TextColor3 = Color3.new(1,1,1)
    
    local closeButton = createButton(frame, "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10), function()
		animateOutAndDestroy(gui)
	end)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)

    createButton(frame, "Load Bounty Hunting Script", UDim2.new(0, 320, 0, 50), UDim2.new(0.5, -160, 0, 80), function()
        animateOutAndDestroy(gui)
        createLoaderGui("Blox Fruits", "Potato King", "https://pastebin.com/raw/ms6xUMyL")
    end)

    createButton(frame, "Load Redz Script", UDim2.new(0, 320, 0, 50), UDim2.new(0.5, -160, 0, 150), function()
        animateOutAndDestroy(gui)
        createLoaderGui("Blox Fruits", "Potato King", "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")
    end)
end

-- Main Entry Point
if bedwarsIds[game.PlaceId] then
	createLoaderGui("Bedwars", "Potato King", "https://pastebin.com/raw/j6eDE4im")
elseif baseplateIds[game.PlaceId] then
	showTrollGui()
elseif arsenalIds[game.PlaceId] then
	createLoaderGui("Arsenal", "Potato King", "https://pastebin.com/raw/pGcShZi1")
elseif mm2Ids[game.PlaceId] then
	createLoaderGui("MM2", "Potato King", "https://pastebin.com/raw/K7s997bZ")
elseif brookhavenIds[game.PlaceId] then
	createLoaderGui("Brookhaven", "Potato King", "https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/main/Brook%20Haven%20Gui")
elseif bloxFruitsIds[game.PlaceId] then
    if game.PlaceId == 7449423635 then -- Third Sea
        showBloxFruitsThirdSeaGui()
    else -- First and Second Sea
        createLoaderGui("Blox Fruits", "Potato King", "https://pastebin.com/raw/ms6xUMyL")
    end
elseif growAGardenIds[game.PlaceId] then
    createLoaderGui("Grow a Garden", "Potato King", "https://raw.githubusercontent.com/orinc-dev/scripts/main/grow-a-garden-orinc")
else
	showUnsupportedGui()
end