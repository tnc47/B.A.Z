xpcall(function()
    local function loadModuleRaw(url) return loadstring(game:HttpGet(url))() end

    local baseUrl =
        "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/"
    local Eggs = loadModuleRaw(baseUrl .. "Eggs.lua")
    local Pets = loadModuleRaw(baseUrl .. "Pets.lua")
    local Island = loadModuleRaw(baseUrl .. "Island.lua")
    local Inventory = loadModuleRaw(baseUrl .. "Inventory.lua")
    local Utils = loadModuleRaw(baseUrl .. "Utils.lua")
    local RayfieldLibrary = loadModuleRaw(baseUrl .. "Dev/Gui.lua")

    local Window = RayfieldLibrary:CreateWindow({
        Name = "Rayfield Example Window",
        LoadingTitle = "Rayfield Interface Suite",
        Theme = 'Default',
        Icon = 0,
        LoadingSubtitle = "by Sirius",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil, -- Create a custom folder for your hub/game
            FileName = "Big Hub52"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Key System",
            Note = "No method of obtaining the key is provided",
            FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
            SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
            GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    })

end, function(err) warn("พบข้อผิดพลาด:", err) end)
