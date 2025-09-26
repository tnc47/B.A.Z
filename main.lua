local function loadModuleRaw(name: string, url: string)
    local ok, raw = pcall(game.HttpGet, game, url)
    assert(ok and type(raw) == "string", ("[%s] download failed: %s"):format(name, tostring(raw)))
    local ok2, mod = pcall(loadstring(raw))
    assert(ok2 and type(mod) == "function", ("[%s] compile failed: %s"):format(name, tostring(mod)))
    local ok3, result = pcall(mod)
    assert(ok3, ("[%s] init failed: %s"):format(name, tostring(result)))
    return result
end

-- ===== Load all modules =====
local Gui      = loadModuleRaw("Rayfield",           "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/GUI/Rayfield.lua")
local Eggs     = loadModuleRaw("Eggs",               "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Eggs.lua")
local Pets     = loadModuleRaw("Pets",               "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Pets.lua")
local Island   = loadModuleRaw("Island",             "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Island.lua")
local Inventory= loadModuleRaw("Inventory",          "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Inventory.lua")
local Utils    = loadModuleRaw("Utils",              "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Utils.lua")

local Window = Gui:CreateWindow({
   Name = "FunScripts",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "FunScripts",
   LoadingSubtitle = "by Benjamin",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "FunscriptsGuiFF1"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key System",
      Subtitle = "To Verify your not a bot, Please type: Key1109888",
      Note = "Key is required to continue!", -- Use this to tell the user how to get a key
      FileName = "Keyforent1r11", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Key1109888"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
