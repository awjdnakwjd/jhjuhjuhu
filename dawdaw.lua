-- Debug prints for executor capabilities
print("Checking executor capabilities...")
print("Has writefile:", pcall(function() return writefile end))
print("Has readfile:", pcall(function() return readfile end))
print("Has isfile:", pcall(function() return isfile end))
print("Has setclipboard:", pcall(function() return setclipboard end))
print("Has getgenv:", pcall(function() return getgenv end))

-- Check required functions
local requiredFunctions = {
    ["writefile"] = false,
    ["readfile"] = false,
    ["isfile"] = false,
    ["setclipboard"] = false,
    ["getgenv"] = false
}

-- Check each function
for funcName, _ in pairs(requiredFunctions) do
    requiredFunctions[funcName] = pcall(function() return _G[funcName] end)
end

-- Load Fluent UI first for notifications
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Check if any required function is missing
local missingFunctions = {}
for funcName, exists in pairs(requiredFunctions) do
    if not exists then
        table.insert(missingFunctions, funcName)
    end
end

-- Show error if any functions are missing
if #missingFunctions > 0 then
    Fluent:Notify({
        Title = "Executor Error",
        Content = "Your executor is missing required functions: " .. table.concat(missingFunctions, ", "),
        Duration = 10
    })
    return
end

local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "bf03533f67ec458cbfdfe7a614d7f737"
local falseData = "4ba2910abf424ac2b5556ef260b77043"

KeyGuardLibrary.Set({
    publicToken = "207d147953c24c468ae87ac60724ad87",
    privateToken = "45d5ec44a217401daaf94c5cce006cf5",
    trueData = trueData,
    falseData = falseData,
})

local KeySystem = {}
KeySystem.X7_V3rf_St8 = false  -- Renamed from isPremium

-- UI untuk Key System
local key = ""

-- Fungsi untuk mengecek key biasa dan premium
function KeySystem.checkKey(key)
    -- Cek premium key terlebih dahulu
    local premiumResponse = KeyGuardLibrary.validatePremiumKey(key)
    if premiumResponse == trueData then
        print("Premium key is valid!")
        KeySystem.X7_V3rf_St8 = true
        KeySystem.Success090 = true
        getgenv().KeySystemResult = {Success090 = true}
        Fluent:Destroy()
        return true
    end
    
    -- Jika bukan premium, cek key biasa
    local response = KeyGuardLibrary.validateDefaultKey(key)
    if response == trueData then
        print("Regular key is valid!")
        KeySystem.X7_V3rf_St8 = false
        KeySystem.Success090 = true
        getgenv().KeySystemResult = {Success090 = true}
        Fluent:Destroy()
        return true
    end
    
    KeySystem.Success090 = false
    getgenv().KeySystemResult = {Success090 = false}
    return false
end

-- Update fungsi saveKey untuk menyimpan status premium
function KeySystem.saveKey(key)
    if key then
        local premiumResponse = KeyGuardLibrary.validatePremiumKey(key)
        local regularResponse = KeyGuardLibrary.validateDefaultKey(key)
        
        if premiumResponse == trueData or regularResponse == trueData then
            if not writefile then
                warn("writefile is not supported by your executor!")
                return false
            end
            
            local savedData = {
                key = key,
                timestamp = os.time(),
                X7_V3rf_St8 = (premiumResponse == trueData)  -- Renamed from isPremium
            }
            
            local success, err = pcall(function()
                writefile("LomuHubKey.txt", game:GetService("HttpService"):JSONEncode(savedData))
            end)
            
            if success then
                print(savedData.X7_V3rf_St8 and "Premium key saved!" or "Regular key saved!")
                return true
            else
                warn("Failed to save key:", err)
                return false
            end
        end
    end
    return false
end

-- Update fungsi loadSavedKey untuk mendukung premium
function KeySystem.loadSavedKey()
    if isfile("LomuHubKey.txt") then
        local success, savedData = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("LomuHubKey.txt"))
        end)
        
        if success and savedData and savedData.key then
            -- Cek status premium terlebih dahulu
            if savedData.X7_V3rf_St8 then  -- Renamed from isPremium
                local response = KeyGuardLibrary.validatePremiumKey(savedData.key)
                if response == trueData then
                    print("Saved Premium Key is valid!")
                    KeySystem.X7_V3rf_St8 = true
                    KeySystem.Success090 = true
                    getgenv().KeySystemResult = {Success090 = true}
                    Fluent:Destroy()
                    return true
                end
            else
                -- Cek key regular
                local response = KeyGuardLibrary.validateDefaultKey(savedData.key)
                if response == trueData then
                    print("Saved Regular Key is valid!")
                    KeySystem.X7_V3rf_St8 = false
                    KeySystem.Success090 = true
                    getgenv().KeySystemResult = {Success090 = true}
                    Fluent:Destroy()
                    return true
                end
            end
        end
    end
    KeySystem.Success090 = false
    getgenv().KeySystemResult = {Success090 = false}
    print("Key is invalid or not found!")
    return false
end

local Window = Fluent:CreateWindow({
    Title = "LomuHub",
    SubTitle = "Key System",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 280),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Add a Close callback to properly handle window closing
Window.OnClose = function()
    Fluent:Destroy()
end

local Tabs = {
    KeySys = Window:AddTab({ Title = "Verification", Icon = "shield-check" }),
}

-- Add welcome text
Tabs.KeySys:AddParagraph({
    Title = "Welcome!",
    Content = "Please enter your key below to access LomuHub"
})

local Entkey = Tabs.KeySys:AddInput("Input", {
    Title = "License Key",
    Default = "",
    Placeholder = "Paste your key here...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        key = Value
    end
})

-- Add buttons in a more organized way
local ButtonSection = Tabs.KeySys:AddSection("Actions")

local Getkey = ButtonSection:AddButton({
    Title = "🔑 Get Key Link",
    Description = "Click to copy key link to clipboard",
    Callback = function()
        setclipboard(KeyGuardLibrary.getLink())
        Fluent:Notify({
            Title = "Link Copied!",
            Content = "Key link has been copied to your clipboard",
            Duration = 3
        })
        Fluent:Notify({
            Title = "Info",
            Content = "Paste the link in your browser",
            Duration = 3
        })
    end
})

local Checkkey = ButtonSection:AddButton({
    Title = "✓ Verify Key",
    Description = "Verify and save your key",
    Callback = function()
        if KeySystem.checkKey(key) then
            if KeySystem.saveKey(key) then
                print("Key saved successfully!")
            else
                Fluent:Notify({
                    Title = "Failed to Save Key",
                    Content = "You might need to insert the key again After This",
                    Duration = 3
                })
            end
            
            Fluent:Notify({
                Title = "Success!",
                Content = KeySystem.X7_V3rf_St8 and "Premium key verified successfully!" or "Key verified successfully",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Invalid Key",
                Content = "Please check your key and try again",
                Duration = 3
            })
        end
    end
})

-- Add Discord button
local JoinDiscord = ButtonSection:AddButton({
    Title = "📱 Join Discord",
    Description = "Join our Discord community",
    Callback = function()
        setclipboard("https://discord.gg/Nwq42H5PhE")
        Fluent:Notify({
            Title = "Discord Link Copied!",
            Content = "Discord invite link has been copied to your clipboard",
            Duration = 3
        })
    end
})

Window:SelectTab(1)

-- Coba load saved key saat script pertama kali dijalankan
KeySystem.loadSavedKey()

return KeySystem
