xpcall(function()
    local function loadModuleRaw(url) return loadstring(game:HttpGet(url))() end
    local Eggs = loadModuleRaw(
                     "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Eggs.lua")
    local Pets = loadModuleRaw(
                     "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Pets.lua")
    local Island = loadModuleRaw(
                       "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Island.lua")
    local Inventory = loadModuleRaw(
                          "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Inventory.lua")
    local Utils = loadModuleRaw(
                      "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Utils.lua")
    local Rayfield = loadModuleRaw(
                         "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Dev/Gui.lua")

    local Window = Rayfield:CreateWindow({
        Name = "Rayfield Example Window",
        Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Rayfield Interface Suite",
        LoadingSubtitle = "by Sirius",
        ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
        Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

        ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil, -- Create a custom folder for your hub/game
            FileName = "Big Hub"
        },

        Discord = {
            Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
            Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },

        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
            Title = "Untitled",
            Subtitle = "Key System",
            Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
            FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
            SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
            GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    })

    local Tab = Window:CreateTab("Tab Example", 4483362458) -- Title, Image
    local Section = Tab:CreateSection("Section Example")
    Section:Set("Section Example")
    local Divider = Tab:CreateDivider()
    Divider:Set(false) -- Whether the divider's visibility is to be set to true or false.
    Rayfield:SetVisibility(false)
    Rayfield:IsVisible()

    Rayfield:Notify({
        Title = "Notification Title",
        Content = "Notification Content",
        Duration = 6.5,
        Image = 4483362458
    })

    local Button = Tab:CreateButton({
        Name = "Button Example",
        Callback = function()
            -- The function that takes place when the button is pressed
        end
    })

    Button:Set("Button Example")

    local Toggle = Tab:CreateToggle({
        Name = "Toggle Example",
        CurrentValue = false,
        Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place when the toggle is pressed
            -- The variable (Value) is a boolean on whether the toggle is true or false
        end
    })
    Toggle:Set(false)

    local ColorPicker = Tab:CreateColorPicker({
        Name = "Color Picker",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place every time the color picker is moved/changed
            -- The variable (Value) is a Color3fromRGB value based on which color is selected
        end
    })

    local Slider = Tab:CreateSlider({
        Name = "Slider Example",
        Range = {0, 100},
        Increment = 10,
        Suffix = "Bananas",
        CurrentValue = 10,
        Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place when the slider changes
            -- The variable (Value) is a number which correlates to the value the slider is currently at
        end
    })

    Slider:Set(10) -- The new slider integer value

    local Input = Tab:CreateInput({
        Name = "Input Example",
        CurrentValue = "",
        PlaceholderText = "Input Placeholder",
        RemoveTextAfterFocusLost = false,
        Flag = "Input1",
        Callback = function(Text)
            -- The function that takes place when the input is changed
            -- The variable (Text) is a string for the value in the text box
        end
    })

    Input:Set("New Text") -- The new input text value

    local Dropdown = Tab:CreateDropdown({
        Name = "Dropdown Example",
        Options = {"Option 1", "Option 2"},
        CurrentOption = {"Option 1"},
        MultipleOptions = false,
        Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Options)
            -- The function that takes place when the selected option is changed
            -- The variable (Options) is a table of strings for the current selected options
        end
    })

    Dropdown:Refresh({"New Option 1", "New Option 2"}) -- The new list of options

    Dropdown:Set({"Option 2"}) -- "Option 2" will now be selected

    local Keybind = Tab:CreateKeybind({
        Name = "Keybind Example",
        CurrentKeybind = "Q",
        HoldToInteract = false,
        Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Keybind)
            -- The function that takes place when the keybind is pressed
            -- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
        end
    })

    Keybind:Set("RightCtrl") -- Keybind (string)

    local Label = Tab:CreateLabel("Label Example", 4483362458,
                                  Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
    local Label = Tab:CreateLabel("Label Example", "rewind")
    Label:Set("Label Example", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
    local Paragraph = Tab:CreateParagraph({
        Title = "Paragraph Example",
        Content = "Paragraph Example"
    })
    Paragraph:Set({Title = "Paragraph Example", Content = "Paragraph Example"})

end, print)
