-- KeyGuard Setup
local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "beb369ec4c664d358867c4daf2ea2bf2"
local falseData = "12455cf8e7c474b9f49482fd0fe3e30"

KeyGuardLibrary.Set({
    publicToken = "207d147953c24c468ae87ac60724ad87",
    privateToken = "45d5ec44a217401daaf94c5cce006cf5",
    trueData = trueData,
    falseData = falseData,
})

-- File handling functions
local function saveKey(key)
    writefile("LomuHubKey.txt", key)
end

local function loadKey()
    if isfile("LomuHubKey.txt") then
        return readfile("LomuHubKey.txt")
    end
    return nil
end

-- Create KeySystemUI table
local KeySystemUI = {}
KeySystemUI.Success090 = false

-- Check saved key first before creating UI
local savedKey = loadKey()
if savedKey then
    local response = KeyGuardLibrary.validateDefaultKey(savedKey)
    if response == trueData then
        KeySystemUI.Success090 = true
        return KeySystemUI
    else
        print("Key System: Saved key is invalid")
    end
end

-- Only create UI if no valid key found
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if game:GetService("RunService"):IsStudio() then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
else
    ScreenGui.Parent = game.CoreGui
end

-- Utility functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://7912134082"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Parent = parent
    return shadow
end

-- Fungsi untuk membuat window bisa di-drag
local function makeDraggable(window, dragObject)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local targetPosition = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        game:GetService("TweenService"):Create(window, tweenInfo, {
            Position = targetPosition
        }):Play()
    end
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateInput(input)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Fungsi untuk membuat window dengan style Fluent
local function createWindow(title, size)
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 330, 0, 420)
    window.Position = UDim2.new(0.5, -165, 0.5, -210)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.Active = true
    window.Draggable = false
    window.Parent = ScreenGui
    
    createCorner(window)
    createShadow(window)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    
    createCorner(titleBar, 8)
    
    -- MacBook style buttons container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(0, 70, 1, 0)
    buttonContainer.Position = UDim2.new(0, 10, 0, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = titleBar
    
    -- Close button (Red)
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 12, 0, 12)
    closeButton.Position = UDim2.new(0, 0, 0.5, -6)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
    closeButton.Text = ""
    closeButton.AutoButtonColor = false
    closeButton.Parent = buttonContainer
    createCorner(closeButton, 6)
    
    -- Minimize button (Yellow)
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 12, 0, 12)
    minimizeButton.Position = UDim2.new(0, 25, 0.5, -6)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
    minimizeButton.Text = ""
    minimizeButton.AutoButtonColor = false
    minimizeButton.Parent = buttonContainer
    createCorner(minimizeButton, 6)
    
    -- Maximize button (Green)
    local maximizeButton = Instance.new("TextButton")
    maximizeButton.Size = UDim2.new(0, 12, 0, 12)
    maximizeButton.Position = UDim2.new(0, 50, 0.5, -6)
    maximizeButton.BackgroundColor3 = Color3.fromRGB(39, 201, 63)
    maximizeButton.Text = ""
    maximizeButton.AutoButtonColor = false
    maximizeButton.Parent = buttonContainer
    createCorner(maximizeButton, 6)
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = title
    titleText.Size = UDim2.new(1, -90, 1, 0)
    titleText.Position = UDim2.new(0, 90, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamMedium
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close functionality
    closeButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Drag functionality (sama seperti sebelumnya)
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    return window
end

-- Fungsi untuk membuat button dengan style Fluent
local function createButton(parent, text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 120, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 15
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = false
    button.Parent = parent
    
    createCorner(button, 6)
    
    -- Efek hover dan click yang lebih smooth
    local tweenService = game:GetService("TweenService")
    local hoverInfo = TweenInfo.new(0.2)
    
    local defaultColor = Color3.fromRGB(0, 120, 255)
    local hoverColor = Color3.fromRGB(0, 140, 255)
    local clickColor = Color3.fromRGB(0, 100, 255)
    
    button.MouseEnter:Connect(function()
        tweenService:Create(button, hoverInfo, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        tweenService:Create(button, hoverInfo, {BackgroundColor3 = defaultColor}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        tweenService:Create(button, hoverInfo, {BackgroundColor3 = clickColor}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        tweenService:Create(button, hoverInfo, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    return button
end

-- Fungsi untuk membuat input field dengan style Fluent
local function createInput(parent, placeholder)
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(0, 250, 0, 40)
    inputContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    inputContainer.BorderSizePixel = 0
    inputContainer.ZIndex = 2
    inputContainer.Parent = parent
    inputContainer.ClipsDescendants = true
    
    createCorner(inputContainer, 6)
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 15
    input.Font = Enum.Font.Gotham
    input.ZIndex = 3
    input.Parent = inputContainer
    input.ClearTextOnFocus = false
    input.ClipsDescendants = true
    
    -- Tambahkan text wrapping
    input.TextWrapped = true
    input.TextXAlignment = Enum.TextXAlignment.Left
    
    return input
end

-- Deskripsi dengan multiple lines
local function createDescription(parent)
    -- Line 1: Discord info
    local descText1 = Instance.new("TextLabel")
    descText1.Size = UDim2.new(0, 250, 0, 20)
    descText1.Position = UDim2.new(0.5, -125, 0, 75)
    descText1.BackgroundTransparency = 1
    descText1.Text = "Join our Discord server to get your key"
    descText1.TextColor3 = Color3.fromRGB(180, 180, 180)
    descText1.TextSize = 14
    descText1.Font = Enum.Font.Gotham
    descText1.Parent = parent
    descText1.ZIndex = 2

    -- Line 2: Executor requirement
    local descText2 = Instance.new("TextLabel")
    descText2.Size = UDim2.new(0, 250, 0, 20)
    descText2.Position = UDim2.new(0.5, -125, 0, 95)
    descText2.BackgroundTransparency = 1
    descText2.Text = "Make sure your executor:"
    descText2.TextColor3 = Color3.fromRGB(180, 180, 180)
    descText2.TextSize = 14
    descText2.Font = Enum.Font.Gotham
    descText2.Parent = parent
    descText2.ZIndex = 2

    -- Line 3: Level 8
    local descText3 = Instance.new("TextLabel")
    descText3.Size = UDim2.new(0, 250, 0, 20)
    descText3.Position = UDim2.new(0.5, -125, 0, 115)
    descText3.BackgroundTransparency = 1
    descText3.Text = "• Has Level 8 Support"
    descText3.TextColor3 = Color3.fromRGB(180, 180, 180)
    descText3.TextSize = 14
    descText3.Font = Enum.Font.Gotham
    descText3.Parent = parent
    descText3.ZIndex = 2

    -- Line 4: UNC
    local descText4 = Instance.new("TextLabel")
    descText4.Size = UDim2.new(0, 250, 0, 20)
    descText4.Position = UDim2.new(0.5, -125, 0, 135)
    descText4.BackgroundTransparency = 1
    descText4.Text = "• 100% UNC Support"
    descText4.TextColor3 = Color3.fromRGB(180, 180, 180)
    descText4.TextSize = 14
    descText4.Font = Enum.Font.Gotham
    descText4.Parent = parent
    descText4.ZIndex = 2
end

-- Tambahkan copyright text
local function addCopyright(parent)
    local copyrightText = Instance.new("TextLabel")
    copyrightText.Size = UDim2.new(0, 250, 0, 20)
    copyrightText.Position = UDim2.new(0.5, -125, 0, 375)
    copyrightText.BackgroundTransparency = 1
    copyrightText.Text = "UI Made By: DaniXD"
    copyrightText.TextColor3 = Color3.fromRGB(100, 100, 100)
    copyrightText.TextSize = 12
    copyrightText.Font = Enum.Font.GothamMedium
    copyrightText.Parent = parent
    copyrightText.ZIndex = 2
end

-- Tambahkan fungsi untuk membuat icon Discord
local function createDiscordIcon()
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://11267183276" -- Discord icon ID
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    return icon
end

-- Modifikasi fungsi createDiscordButton
local function createDiscordButton(parent)
    local discordButton = Instance.new("TextButton")
    discordButton.Size = UDim2.new(0, 250, 0, 35)
    discordButton.Position = UDim2.new(0.5, -125, 0, 280)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.BorderSizePixel = 0
    discordButton.Text = "Discord"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 14
    discordButton.Font = Enum.Font.GothamBold
    discordButton.Parent = parent
    discordButton.ZIndex = 2
    
    createCorner(discordButton, 6)
    
    -- Hover effect
    local tweenService = game:GetService("TweenService")
    local hoverInfo = TweenInfo.new(0.2)
    
    local defaultColor = Color3.fromRGB(88, 101, 242)
    local hoverColor = Color3.fromRGB(71, 82, 196)
    
    -- Tambahkan fungsi click untuk copy Discord link
    discordButton.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/Nwq42H5PhE") -- Ganti dengan link Discord Anda
        
        -- Tampilkan notifikasi
        local notification = Instance.new("TextLabel")
        notification.Text = "Discord link copied to clipboard!"
        notification.Size = UDim2.new(0, 250, 0, 30)
        notification.Position = UDim2.new(0.5, -125, 0, 260)
        notification.BackgroundTransparency = 1
        notification.TextColor3 = Color3.fromRGB(39, 201, 63)
        notification.TextSize = 14
        notification.Font = Enum.Font.Gotham
        notification.Parent = parent
        notification.ZIndex = 2
        
        -- Hapus notifikasi setelah 3 detik
        game:GetService("Debris"):AddItem(notification, 3)
    end)
    
    discordButton.MouseEnter:Connect(function()
        tweenService:Create(discordButton, hoverInfo, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    discordButton.MouseLeave:Connect(function()
        tweenService:Create(discordButton, hoverInfo, {BackgroundColor3 = defaultColor}):Play()
    end)
    
    return discordButton
end

-- Fungsi untuk membuat notifikasi popup
local function createNotification(text, type)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotificationGui"
    notifGui.Parent = game.CoreGui
    
    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 220, 0, 45)
    container.Position = UDim2.new(1, 20, 0.9, 0)
    container.BackgroundTransparency = 1
    container.Parent = notifGui
    
    -- Notification frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    -- Add corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    -- Circle icon
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 8, 0, 8)
    circle.Position = UDim2.new(0, 10, 0.5, -4)
    circle.BackgroundColor3 = 
        type == "success" and Color3.fromRGB(39, 201, 63) or -- Hijau
        type == "error" and Color3.fromRGB(255, 69, 58) or   -- Merah
        Color3.fromRGB(0, 122, 255)                          -- Biru (default/info)
    circle.Parent = frame
    
    -- Make circle round
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = text
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Position = UDim2.new(0, 25, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = frame
    
    -- Instant appear and delayed disappear
    container.Position = UDim2.new(1, -240, 0.9, 0)
    
    task.delay(1, function()
        local slideOut = game:GetService("TweenService"):Create(container,
            TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 20, 0.9, 0)}
        )
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end)
end

-- Buat variabel window di scope yang bisa diakses
local window

-- Buat window hanya jika tidak ada key yang valid
window = createWindow("Key System V2")

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 250, 0, 35)
titleText.Position = UDim2.new(0.5, -125, 0, 45)
titleText.BackgroundTransparency = 1
titleText.Text = "Lomu Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.Parent = window
titleText.ZIndex = 2

-- Input container
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(0, 250, 0, 40)
inputContainer.Position = UDim2.new(0.5, -125, 0, 170)
inputContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
inputContainer.BorderSizePixel = 0
inputContainer.Parent = window
createCorner(inputContainer, 6)

-- Key input
local keyInput = createInput(inputContainer, "Enter key here...")
keyInput.Size = UDim2.new(1, -20, 1, 0)
keyInput.Position = UDim2.new(0, 10, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Button Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0, 250, 0, 35)
buttonContainer.Position = UDim2.new(0.5, -125, 0, 220)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = window

-- Check Key button (kiri)
local checkButton = createButton(buttonContainer, "Check Key", UDim2.new(0, 0, 0, 0))
checkButton.Size = UDim2.new(0, 120, 0, 35)
checkButton.BackgroundColor3 = Color3.fromRGB(59, 130, 246)

-- Get Key button (kanan)
local getKeyButton = createButton(buttonContainer, "Get Key", UDim2.new(1, -120, 0, 0))
getKeyButton.Size = UDim2.new(0, 120, 0, 35)
getKeyButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord blue color

-- Discord button
local discordButton = createDiscordButton(window)
discordButton.Position = UDim2.new(0.5, -125, 0, 280)
discordButton.Size = UDim2.new(0, 250, 0, 35)

-- Clear Saved Key sebagai button terpisah
local clearKeyButton = createButton(window, "Clear Saved Key", UDim2.new(0.5, -125, 0, 325))
clearKeyButton.Size = UDim2.new(0, 250, 0, 35)
clearKeyButton.BackgroundColor3 = Color3.fromRGB(220, 38, 38) -- Warna merah
clearKeyButton.Parent = window -- Memastikan button menjadi child langsung dari window

-- Description
createDescription(window)

-- Copyright
addCopyright(window)

-- Button functionality
checkButton.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    local response = KeyGuardLibrary.validateDefaultKey(key)
    
    if response == trueData then
        saveKey(key)
        createNotification("Key validation successful!", "success")
        wait(1)
        KeySystemUI.Success090 = true
        ScreenGui:Destroy()
    else
        createNotification("Invalid key!", "error")
        print("Key System: Invalid key entered")
        keyInput.Text = ""
        keyInput.PlaceholderText = "Enter key here..."
    end
end)

-- Add auto-fill for saved key
if savedKey then
    keyInput.Text = savedKey
    keyInput.PlaceholderText = "Saved key loaded"
end

getKeyButton.MouseButton1Click:Connect(function()
    setclipboard(KeyGuardLibrary.getLink())
    createNotification("Key link copied to clipboard!", "info")
end)

-- Add clear key option
clearKeyButton.MouseButton1Click:Connect(function()
    if isfile("LomuHubKey.txt") then
        delfile("LomuHubKey.txt")
        KeySystemUI.Success090 = false -- Reset status
        createNotification("Saved key cleared!", "error")
    else
        createNotification("No saved key found!", "info")
    end
end)

-- Set global variable for access
getgenv().KeySystemResult = KeySystemUI

return KeySystemUI
