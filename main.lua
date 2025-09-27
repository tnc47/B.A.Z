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

    local Tab = Window:CreateTab("Tab Example", 'key-round') -- Title, Image
    local Tab2 = Window:CreateTab("Tab Example 2", 4483362458) -- Title, Image

    local Section = Tab2:CreateSection("Section")

    local ColorPicker = Tab2:CreateColorPicker({
        Name = "Color Picker",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "ColorPicfsefker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place every time the color picker is moved/changed
            -- The variable (Value) is a Color3fromRGB value based on which color is selected
        end
    })

    local Slider = Tab2:CreateSlider({
        Name = "Slider Example",
        Range = {0, 100},
        Increment = 10,
        Suffix = "Bananas",
        CurrentValue = 40,
        Flag = "Slidefefsr1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place when the slider changes
            -- The variable (Value) is a number which correlates to the value the slider is currently at
        end
    })

    local Input = Tab2:CreateInput({
        Name = "Input Example",
        CurrentValue = '',
        PlaceholderText = "Input Placeholder",
        Flag = 'dawdawd',
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            -- The function that takes place when the input is changed
            -- The variable (Text) is a string for the value in the text box
        end
    })

    -- RayfieldLibrary:Notify({Title = "Rayfield Interface", Content = "Welcome to Rayfield. These - are the brand new notification design for Rayfield, with custom sizing and Rayfield calculated wait times.", Image = 4483362458})

    local Section = Tab:CreateSection("Section Example")

    local Button = Tab:CreateButton({
        Name = "Change Theme",
        Callback = function()
            -- The function that takes place when the button is pressed
            Window.ModifyTheme('DarkBlue')
        end
    })

    local Toggle = Tab:CreateToggle({
        Name = "Toggle Example",
        CurrentValue = false,
        Flag = "Toggle1adwawd", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place when the toggle is pressed
            -- The variable (Value) is a boolean on whether the toggle is true or false
        end
    })

    local ColorPicker = Tab:CreateColorPicker({
        Name = "Color Picker",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "ColorPicker1awd", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
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
        CurrentValue = 40,
        Flag = "Slider1dawd", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
            -- The function that takes place when the slider changes
            -- The variable (Value) is a number which correlates to the value the slider is currently at
        end
    })

    local Input = Tab:CreateInput({
        Name = "Input Example",
        CurrentValue = "Helo",
        PlaceholderText = "Adaptive Input",
        RemoveTextAfterFocusLost = false,
        Flag = 'Input1',
        Callback = function(Text)
            -- The function that takes place when the input is changed
            -- The variable (Text) is a string for the value in the text box
        end
    })

    local thoptions = {}
    for themename, theme in pairs(RayfieldLibrary.Theme) do
        table.insert(thoptions, themename)
    end

    local Dropdown = Tab:CreateDropdown({
        Name = "Theme",
        Options = thoptions,
        CurrentOption = {"Default"},
        MultipleOptions = false,
        Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Options)
            -- Window.ModifyTheme(Options[1])
            -- The function that takes place when the selected option is changed
            -- The variable (Options) is a table of strings for the current selected options
        end
    })

    Window.ModifyTheme({
        TextColor = Color3.fromRGB(50, 55, 60),
        Background = Color3.fromRGB(240, 245, 250),
        Topbar = Color3.fromRGB(215, 225, 235),
        Shadow = Color3.fromRGB(200, 210, 220),

        NotificationBackground = Color3.fromRGB(210, 220, 230),
        NotificationActionsBackground = Color3.fromRGB(225, 230, 240),

        TabBackground = Color3.fromRGB(200, 210, 220),
        TabStroke = Color3.fromRGB(180, 190, 200),
        TabBackgroundSelected = Color3.fromRGB(175, 185, 200),
        TabTextColor = Color3.fromRGB(50, 55, 60),
        SelectedTabTextColor = Color3.fromRGB(30, 35, 40),

        ElementBackground = Color3.fromRGB(210, 220, 230),
        ElementBackgroundHover = Color3.fromRGB(220, 230, 240),
        SecondaryElementBackground = Color3.fromRGB(200, 210, 220),
        ElementStroke = Color3.fromRGB(190, 200, 210),
        SecondaryElementStroke = Color3.fromRGB(180, 190, 200),

        SliderBackground = Color3.fromRGB(200, 220, 235), -- Lighter shade
        SliderProgress = Color3.fromRGB(70, 130, 180),
        SliderStroke = Color3.fromRGB(150, 180, 220),

        ToggleBackground = Color3.fromRGB(210, 220, 230),
        ToggleEnabled = Color3.fromRGB(70, 160, 210),
        ToggleDisabled = Color3.fromRGB(180, 180, 180),
        ToggleEnabledStroke = Color3.fromRGB(60, 150, 200),
        ToggleDisabledStroke = Color3.fromRGB(140, 140, 140),
        ToggleEnabledOuterStroke = Color3.fromRGB(100, 120, 140),
        ToggleDisabledOuterStroke = Color3.fromRGB(120, 120, 130),

        DropdownSelected = Color3.fromRGB(220, 230, 240),
        DropdownUnselected = Color3.fromRGB(200, 210, 220),

        InputBackground = Color3.fromRGB(220, 230, 240),
        InputStroke = Color3.fromRGB(180, 190, 200),
        PlaceholderColor = Color3.fromRGB(150, 150, 150)
    })

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

    local Label = Tab:CreateLabel("Label Example")

    local Label2 = Tab:CreateLabel("Warning", 4483362458,
                                   Color3.fromRGB(255, 159, 49), true)

    local Paragraph = Tab:CreateParagraph({
        Title = "Paragraph Example",
        Content = "Paragraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph Example"
    })

end, function(err) warn("พบข้อผิดพลาด:", err) end)
