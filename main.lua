xpcall(function ()
   local function loadModuleRaw(url: string)
      return loadstring(game:HttpGet(url))()
   end
   local Eggs     = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Eggs.lua")
   local Pets     = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Pets.lua")
   local Island   = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Island.lua")
   local Inventory= loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Inventory.lua")
   local Utils    = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Utils.lua")
   local Rayfield = loadModuleRaw("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Dev/Gui.lua")

   -- 1) สร้างหน้าต่างหลัก
   local Window = Rayfield:CreateWindow({
      Name = "QQ Utilities – Inventory Demo",
      LoadingTitle = "Inventory Grid Example",
      LoadingSubtitle = "Full usage sample",
      ConfigurationSaving = {
         Enabled = true,
         FolderName = "QQ_BUILD_A_ZOO",
         FileName = "inventory_demo"
      },
      Discord = { Enabled = false },
      KeySystem = false,
   })

   -- 2) สร้างแท็บสำหรับคลัง
   local TabInv  = Window:CreateTab("คลังไอเท็ม", 7743875964)  -- ใช้ asset id ไอคอนอะไรก็ได้
   local TabCtrl = Window:CreateTab("ควบคุม", 7743875964)

   -- 3) สร้างกริด + ไอเท็มตั้งต้น
   local items = {
      { id=1,  name="Basic Egg",    icon="rbxassetid://123", qty=12, rarity="common" },
      { id=2,  name="Ancient Egg",  icon="rbxassetid://456", qty=3,  rarity="epic" },
      { id=3,  name="Bone Dragon",  icon="rbxassetid://789", qty=1,  rarity="legendary", equipped=true },
      { id=4,  name="Orange",       icon="rbxassetid://101", qty=24, rarity="uncommon" },
      { id=5,  name="Honey",        icon="rbxassetid://102", qty=7,  rarity="rare" },
      { id=6,  name="Stone",        icon="rbxassetid://103", qty=58, rarity="common" },
   }

   local inv = TabInv:CreateInventoryGrid({
      Name        = "Inventory",
      Items       = items,
      ShowSearch  = true,
      ShowStats   = true,
      CellSize    = UDim2.new(0, 92, 0, 92),           -- ปรับขนาดช่อง
      CellPadding = UDim2.new(0, 8, 0, 8),

      -- เรียงลำดับเริ่มต้น: equipped > rarity > qty > name (ค่า default ก็เป็นแบบนี้)
      Sorter = function(a,b)
         local rorder = {common=1,uncommon=2,rare=3,epic=4,legendary=5,mythical=6}
         if (a.equipped or false) ~= (b.equipped or false) then return (a.equipped or false) end
         if (rorder[a.rarity or "common"] or 0) ~= (rorder[b.rarity or "common"] or 0) then
               return (rorder[a.rarity or "common"] or 0) > (rorder[b.rarity or "common"] or 0)
         end
         if (a.qty or 0) ~= (b.qty or 0) then return (a.qty or 0) > (b.qty or 0) end
         return (a.name or "") < (b.name or "")
      end,

      -- คลิกซ้าย = เลือก/ใส่ (equip) ถ้าเป็น egg ก็แจ้งเตือน
      OnClick = function(item)
         if item.equipped then
               item.equipped = false
               Rayfield:Notify({ Title="Unequip", Content="ถอด "..item.name, Duration=3 })
         else
               -- ยกเลิก equipped อื่น ๆ (ตัวอย่าง logic)
               for _, it in ipairs(items) do it.equipped = (it.id == item.id) end
               Rayfield:Notify({ Title="Equip", Content="ใส่ "..item.name, Duration=3 })
         end
         inv:UpdateItem(item.id, { equipped = item.equipped })
      end,

      -- คลิกขวา = เมนูด่วน (ตัวอย่าง: ขาย 1 ชิ้น)
      OnRightClick = function(item)
         if (item.qty or 0) > 0 then
               inv:UpdateQty(item.id, (item.qty or 0) - 1)
               Rayfield:Notify({ Title="ขายไอเท็ม", Content="ขาย 1x "..item.name.." (เหลือ "..((item.qty or 0)-1)..")", Duration=3 })
         end
      end,

      -- โฮเวอร์ = แสดงชื่อ/แรร์
      OnHover = function(item, isEnter)
         if isEnter then
               local r = tostring(item.rarity or "common")
               Rayfield:Notify({ Title=item.name, Content="แรร์: "..r.." | จำนวน: x"..tostring(item.qty or 1), Duration=2 })
         end
      end,
   })

   -- 4) ตัวอย่าง API ที่มีทั้งหมด
   -- 4.1) SetItems: เซ็ตทั้งรายการใหม่
   -- inv:SetItems({ ... })

   -- 4.2) AddItem: เพิ่มไอเท็มใหม่
   task.delay(2, function()
      inv:AddItem({ id=7, name="Myth Egg", icon="rbxassetid://999", qty=2, rarity="mythical" })
   end)

   -- 4.3) RemoveItem: ลบไอเท็มด้วย id
   task.delay(4, function()
      inv:RemoveItem(6) -- ลบ Stone
   end)

   -- 4.4) UpdateItem: แก้ไขฟิลด์บางส่วน (ชื่อ/แรร์/ไอคอน/สถานะ)
   task.delay(6, function()
      inv:UpdateItem(2, { name="Ancient Egg+", rarity="epic" })
   end)

   -- 4.5) UpdateQty: อัปเดตจำนวนแบบเร็ว (ไม่ rebuild ทั้งกริด)
   task.delay(8, function()
      inv:UpdateQty(1, 15) -- Basic Egg -> 15
   end)

   -- 4.6) SetFilter: ค้นหาแบบโปรแกรมมิ่ง
   task.delay(10, function()
      inv:SetFilter("egg") -- จะโชว์เฉพาะที่ text แมตช์
   end)

   -- 4.7) SortWith: เปลี่ยนกติกาการเรียง (ตัวอย่าง: เรียงตามจำนวนมาก→น้อย)
   task.delay(12, function()
      inv:SortWith(function(a,b) return (a.qty or 0) > (b.qty or 0) end)
   end)

   ----------------------------------------------------------------
   -- 5) ตัวอย่างการผูกกับปุ่ม/ท็อกเกิล/สไลเดอร์ในแท็บ "ควบคุม"
   ----------------------------------------------------------------

   -- 5.1) ปุ่มเติมของทดสอบ
   TabCtrl:CreateButton({
      Name = "เติม Basic Egg +5",
      Callback = function()
         for _, it in ipairs(items) do
               if it.id == 1 then
                  inv:UpdateQty(it.id, (it.qty or 0) + 5)
                  break
               end
         end
      end
   })

   -- 5.2) ท็อกเกิล Auto-sell commons (เดโม่ด้วยการกรอง + ขายเมื่อคลิกขวา)
   local autoSell = { enabled=false }
   TabCtrl:CreateToggle({
      Name = "Auto-sell (common)",
      CurrentValue = false,
      Callback = function(v)
         autoSell.enabled = v
         Rayfield:Notify({ Title="Auto-sell", Content = v and "ON" or "OFF", Duration=3 })
      end
   })

   -- สาธิตการขาย auto เมื่อจำนวนเกิน 20 และเป็น common (จำลอง event ภายใน)
   task.spawn(function()
      while task.wait(3) do
         if autoSell.enabled then
               for _, it in ipairs(items) do
                  if (it.rarity == "common") and (it.qty or 0) > 20 then
                     inv:UpdateQty(it.id, it.qty - 1)
                     Rayfield:Notify({ Title="Auto-sell", Content="ขายออโต้ 1x "..it.name.." (เหลือ "..(it.qty-1)..")", Duration=2 })
                  end
               end
         end
      end
   end)

   -- 5.3) สไลเดอร์ปรับขนาด Cell แบบทันใจ
   TabCtrl:CreateSlider({
      Name = "ขนาดช่อง (px)",
      Range = {64, 128},
      Increment = 4,
      Suffix = "px",
      CurrentValue = 92,
      Callback = function(px)
         -- อัปเดต cell size แล้วเซ็ตไอเท็มใหม่อีกรอบเพื่อ rebuild layout
         local new = {}
         for _, it in ipairs(items) do new[#new+1] = it end
         -- ปรับค่าใน grid โดยสร้าง grid ใหม่ (ทางลัด: ใช้ SetItems หลังแก้ GridSettings)
         -- หมายเหตุ: ถ้าต้องการแก้ CellSize ขณะรัน คุณสามารถ:
         --   1) สร้างกริดใหม่อีกตัว แล้ว inv = กริดใหม่นั้น, หรือ
         --   2) ในโค้ดเมธอด เพิ่ม API ปรับ CellSize แล้ว rebuild (ถ้าคุณอยากให้ผม patch เพิ่ม API นี้บอกได้)
         -- ที่นี่เราจะใช้วิธี recreate เร็ว ๆ:
         local filter = "" -- จำ filter เดิมไหม? ตัวอย่างนี้ล้างก่อน
         -- ทำลายกริดเดิม (เลี่ยง memory leak: ปกติเรียก Destroy UI node ที่สร้างเพิ่มเองด้วย)
         -- ทว่าในตัวอย่างนี้เราแค่สร้างกริดใหม่ทับ
         inv = TabInv:CreateInventoryGrid({
               Name        = "Inventory",
               Items       = new,
               ShowSearch  = true,
               ShowStats   = true,
               CellSize    = UDim2.new(0, px, 0, px),
               CellPadding = UDim2.new(0, 8, 0, 8),
               OnClick     = function(item)
                  item.equipped = not item.equipped
                  for _, it in ipairs(items) do
                     if it.id ~= item.id then it.equipped = false end
                  end
                  inv:UpdateItem(item.id, { equipped = item.equipped })
               end,
               OnRightClick = function(item)
                  if (item.qty or 0) > 0 then
                     inv:UpdateQty(item.id, (item.qty or 0) - 1)
                  end
               end,
         })
         inv:SetFilter(filter)
      end
   })

   -- 5.4) ดรอปดาวน์เปลี่ยนโหมดเรียง
   TabCtrl:CreateDropdown({
      Name = "โหมดเรียง",
      Options = {"ค่าเริ่มต้น","จำนวนมาก→น้อย","ชื่อ A→Z"},
      CurrentOption = {"ค่าเริ่มต้น"},
      MultipleOptions = false,
      Callback = function(opt)
         local pick = opt[1]
         if pick == "จำนวนมาก→น้อย" then
               inv:SortWith(function(a,b) return (a.qty or 0) > (b.qty or 0) end)
         elseif pick == "ชื่อ A→Z" then
               inv:SortWith(function(a,b) return (a.name or "") < (b.name or "") end)
         else
               inv:SortWith(nil) -- กลับไปใช้ Sorter เดิมที่กริดตั้งไว้
         end
      end
   })

   -- 5.5) อินพุตค้นหา (ซ้ำกับช่อง Search ในหัวกริด แต่บางคนอยากมีช่องค้นหาที่แท็บควบคุม)
   TabCtrl:CreateInput({
      Name = "ค้นหา (ซ้ำ)",
      PlaceholderText = "พิมพ์คำค้น...",
      Callback = function(text)
         inv:SetFilter(text or "")
      end
   })

   -- 6) ตัวอย่างสร้างอีกกริด (หมวดวัตถุดิบ) ในแท็บเดียวกัน
   local matGrid = TabInv:CreateInventoryGrid({
      Name = "Materials",
      Items = {
         { id="m1", name="Wood",   icon="rbxassetid://111", qty=40, rarity="common"   },
         { id="m2", name="Metal",  icon="rbxassetid://112", qty=12, rarity="uncommon" },
         { id="m3", name="Fiber",  icon="rbxassetid://113", qty=9,  rarity="rare"     },
      },
      ShowSearch = true, ShowStats = true,
      OnClick = function(it) Rayfield:Notify({Title="เลือกของ", Content=it.name, Duration=2}) end
   })

   -- 7) โหลด config เก่า (Rayfield มีฟังก์ชันในไฟล์แล้ว)
   Rayfield:LoadConfiguration()



end, print)