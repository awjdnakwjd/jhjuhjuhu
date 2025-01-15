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

-- Membuat properti Success090 yang akan digunakan oleh script games
function KeySystem.checkKey(key)
    local response = KeyGuardLibrary.validateDefaultKey(key)
    if response == trueData then
        KeySystem.Success090 = true
        getgenv().KeySystemResult = {Success090 = true}
        -- Simpan key jika valid
        KeySystem.saveKey(key)
        return true
    end
    KeySystem.Success090 = false
    getgenv().KeySystemResult = {Success090 = false}
    return false
end

-- Tambahkan fungsi untuk menyimpan key
function KeySystem.saveKey(key)
    if key then
        local response = KeyGuardLibrary.validateDefaultKey(key)
        if response == trueData then
            -- Simpan key yang valid
            local savedData = {
                key = key,
                timestamp = os.time()
            }
            writefile("LomuHubKey.txt", game:GetService("HttpService"):JSONEncode(savedData))
            return true
        end
    end
    return false
end

-- Tambahkan fungsi untuk memuat saved key
function KeySystem.loadSavedKey()
    if isfile("LomuHubKey.txt") then
        local success, savedData = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("LomuHubKey.txt"))
        end)
        
        if success and savedData and savedData.key then
            -- Validasi key yang tersimpan
            local response = KeyGuardLibrary.validateDefaultKey(savedData.key)
            if response == trueData then
                KeySystem.Success090 = true
                getgenv().KeySystemResult = {Success090 = true}
                print("Key is valid and has been loaded!")
                return true
            end
        end
    end
    KeySystem.Success090 = false
    getgenv().KeySystemResult = {Success090 = false}
    print("Key is invalid or not found!")
    return false
end

-- UI untuk Key System
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local key = ""

local Window = Fluent:CreateWindow({
    Title = "LomuHub",
    SubTitle = "Key System",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 280),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

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
    Title = "🔑 Get Key",
    Description = "Click to copy key link to clipboard",
    Callback = function()
        setclipboard(KeyGuardLibrary.getLink())
        Fluent:Notify({
            Title = "Link Copied!",
            Content = "Key link has been copied to your clipboard",
            Duration = 3
        })
    end
})

local Checkkey = ButtonSection:AddButton({
    Title = "✓ Verify Key",
    Description = "Verify and save your key",
    Callback = function()
        if KeySystem.checkKey(key) then
            Fluent:Notify({
                Title = "Success!",
                Content = "Key verified successfully",
                Duration = 3
            })
            task.wait(1)
            Window:Destroy()
        else
            Fluent:Notify({
                Title = "Invalid Key",
                Content = "Please check your key and try again",
                Duration = 3
            })
        end
    end
})

Window:SelectTab(1)

-- Coba load saved key saat script pertama kali dijalankan
KeySystem.loadSavedKey()

return KeySystem
