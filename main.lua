xpcall(function()
    local function loadModuleRaw(url)
        return loadstring(game:HttpGet(url))()
    end

    local baseUrl = "https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/"
    local Eggs      = loadModuleRaw(baseUrl .. "Eggs.lua")
    local Pets      = loadModuleRaw(baseUrl .. "Pets.lua")
    local Island    = loadModuleRaw(baseUrl .. "Island.lua")
    local Inventory = loadModuleRaw(baseUrl .. "Inventory.lua")
    local Utils     = loadModuleRaw(baseUrl .. "Utils.lua")
    local Rayfield  = loadModuleRaw(baseUrl .. "Dev/Gui.lua")

    -- หน้าต่างหลัก
    local Window = Rayfield:CreateWindow({
        Name = "QQ Utilities - Build A Zoo",
        Icon = "paw-print", -- ใช้ Lucide icon (หรือ 0 หากไม่ใช้)
        LoadingTitle = "กำลังโหลด UI",
        LoadingSubtitle = "โดยทีมพัฒนา QQ",
        ShowText = "เปิดเมนู QQ", -- สำหรับผู้ใช้มือถือ
        Theme = "Default",
        ToggleUIKeybind = "K",

        ConfigurationSaving = {
            Enabled = true,
            FolderName = "QQ_BUILD_A_ZOO",
            FileName = "utils_config"
        },

        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },

        KeySystem = false
    })

    -- แท็บหลัก
    local Tab = Window:CreateTab("เมนูหลัก", "menu")

    -- ส่วน: ควบคุมทั่วไป
    local Section = Tab:CreateSection("การควบคุมพื้นฐาน")

    local Button = Tab:CreateButton({
        Name = "ซื้อไข่ BasicEgg",
        Callback = function()
            Eggs:BuyEgg("BasicEgg")
        end
    })

    local Toggle = Tab:CreateToggle({
        Name = "เปิด/ปิด ระบบอัตโนมัติ",
        CurrentValue = false,
        Flag = "AutoFarm",
        Callback = function(state)
            print("AutoFarm เปิด:", state)
        end
    })

    local Slider = Tab:CreateSlider({
        Name = "จำนวนรอบฟาร์ม",
        Range = {1, 100},
        Increment = 1,
        Suffix = "รอบ",
        CurrentValue = 10,
        Flag = "FarmLoop",
        Callback = function(val)
            print("ตั้งค่าฟาร์มเป็น:", val)
        end
    })

    local Input = Tab:CreateInput({
        Name = "ชื่อตัวละคร",
        PlaceholderText = "กรอกชื่อ...",
        RemoveTextAfterFocusLost = false,
        Flag = "CharName",
        Callback = function(text)
            print("ชื่อตัวละคร:", text)
        end
    })

    local Dropdown = Tab:CreateDropdown({
        Name = "เลือกเกาะ",
        Options = {"Island_1", "Island_2", "Island_3"},
        CurrentOption = {"Island_1"},
        MultipleOptions = false,
        Flag = "Island",
        Callback = function(opts)
            print("เกาะที่เลือก:", opts[1])
        end
    })

    local Keybind = Tab:CreateKeybind({
        Name = "ตั้งคีย์ลัดปิด/เปิด UI",
        CurrentKeybind = "RightCtrl",
        HoldToInteract = false,
        Flag = "Hotkey",
        Callback = function()
            Rayfield:SetVisibility(not Rayfield:IsVisible())
        end
    })

    -- ป้ายข้อความ
    local Label = Tab:CreateLabel("สถานะ: พร้อมใช้งาน", "check", Color3.fromRGB(0, 255, 0), false)

    local Paragraph = Tab:CreateParagraph({
        Title = "คำแนะนำ",
        Content = "คุณสามารถตั้งค่าการฟาร์ม, ซื้อไข่, ปิด UI และปรับแต่งระบบต่าง ๆ ได้ที่เมนูนี้"
    })

    -- แจ้งเตือนเมื่อโหลดเสร็จ
    Rayfield:Notify({
        Title = "โหลดสำเร็จ!",
        Content = "โมดูลและเมนูทั้งหมดถูกโหลดเรียบร้อยแล้ว",
        Duration = 5,
        Image = "check"
    })

    -- แสดง UI โดยไม่ต้องกด
    Rayfield:SetVisibility(true)

end, function(err)
    warn("พบข้อผิดพลาด:", err)
end)
