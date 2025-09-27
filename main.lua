xpcall(function ()
   local function loadModuleRaw(url)
      return loadstring(game:HttpGet(url))()
   end
   local Eggs     = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Eggs.lua")
   local Pets     = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Pets.lua")
   local Island   = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Island.lua")
   local Inventory= loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Inventory.lua")
   local Utils    = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Utils.lua")
   local Rayfield = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Dev/Gui.lua")

   local Window = Rayfield:CreateWindow({
      Name = "<- หมวดหมู่",
      LoadingTitle = "Arrayfield Interface Suite",
      LoadingSubtitle = "by Arrays",
      ConfigurationSaving = {
         Enabled = true,
         FolderName = nil, -- Create a custom folder for your hub/game
         FileName = "Arrayfield"
      },
      Discord = {
         Enabled = false,
         Invite = "sirius", -- The Discord invite code, do not include discord.gg/
         RememberJoins = true -- Set this to false to make them join the discord every time they load it up
      },
      KeySystem = false, -- Set this to true to use our key system
      KeySettings = {
         Title = "Arrayfield",
         Subtitle = "Key System",
         Note = "Join the discord (discord.gg/sirius)",
         FileName = "SiriusKey",
         SaveKey = false,
         GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
         Key = "Hello"
      }
   })


end, print)