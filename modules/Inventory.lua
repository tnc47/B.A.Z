--!strict
local BuildAZoo = game:HttpGet("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Roblox/BuildAZoo.lua")
local BuildAZooFolder = loadstring(BuildAZoo)()

-- ====== Types ======
type MutsMap   = { [string]: number }
type EggEntry  = { allcount: number, name: Instance, data: MutsMap }
type ResultMap = { [string]: EggEntry }

-- ====== Helpers ======
local function trim(s: string): string
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeKey(s: string?): string?
	if not s then return nil end
	local cleaned = s:gsub("[%c]", " "):gsub("%s+", " ")
	cleaned = trim(cleaned)
	return (#cleaned > 0) and cleaned or nil
end

local function readText(obj: Instance?): string?
	if not obj then return nil end
	if obj:IsA("StringValue") then
		return obj.Value
	end
	if obj:IsA("NumberValue") or obj:IsA("IntValue") or obj:IsA("BoolValue") then
		return tostring((obj :: any).Value)
	end
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		local anyObj = obj :: any
		local t = anyObj.ContentText
		if t and #t > 0 then return t end
		return anyObj.Text
	end
	return nil
end

local function onlyDigits(str: string?): number?
	if not str then return nil end
	local s = tostring(str)
	local n = s:match("%-?%d+")
	return n and tonumber(n) or nil
end

local function isTemplateLike(inst: Instance): boolean
	if inst:GetAttribute("Template") == true then return true end
	local n = inst.Name:lower()
	return n == "item" or n:find("template") ~= nil
end

-- เช็กว่า GUI มองเห็นจริง (รวม parent chain)
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local function isActuallyVisible(gui: Instance): boolean
	if not gui or not gui:IsA("GuiObject") then return false end
	local cur: Instance? = gui
	while cur and cur ~= LP do
		if cur:IsA("GuiObject") and (cur.Visible == false) then
			return false
		end
		cur = cur.Parent
	end
	return (gui :: GuiObject).Visible == true
end

-- ====== Find roots ======
local function getStorageGui()
	local gui = BuildAZooFolder.LocalPlayer:WaitForChild("PlayerGui")
	local screenStorage = gui:WaitForChild("ScreenStorage")
	return gui, screenStorage
end

-- ====== MAIN: ดึงไข่ + รวมข้อมูลปุ่ม Muts ต่อไอเท็ม ======
-- รูปแบบคืนค่า:
-- {
--   [<EggName>] = {
--       allcount = <จำนวนไอเท็มชนิดนี้ทั้งหมดใน ScrollingFrame>,
--       name     = <Instance ของไอเท็มล่าสุดที่พบ>,
--       data     = { Diamond = n, Dino = n, Electirc = n, Fire = n, Golden = n, Night = n, Snow = n }
--   },
--   ...
-- }
local function GetEggFormInv(): ResultMap
	local _, screenStorage = getStorageGui()
	local frame   = screenStorage:WaitForChild("Frame")
	local content = frame:WaitForChild("Content")
	local sf      = content:WaitForChild("ScrollingFrame")

	local result: ResultMap = {}

	-- รายชื่อปุ่ม Muts ที่ต้องนับ (ใช้ชื่อให้ตรงกับ UI — คง "Electirc" ไว้ตามเกม)
	local mutsTargets = { "Diamond", "Dino", "Electirc", "Fire", "Golden", "Night", "Snow" }
	-- เผื่อบางที่สะกด Electric → Electirc
	-- local alias = { Electric = "Electirc" }

	local function ensureEntry(key: string, child: Instance): EggEntry
		local entry = result[key]
		if entry == nil then
			entry = {
				allcount = 0,
				name     = child,
				data     = {}
			}
			-- init 0 ให้ครบทุกคีย์เพื่อความคงที่ของ schema
			for _, t in ipairs(mutsTargets) do
				entry.data[t] = 0
			end
			result[key] = entry
		end
		-- อัพเดตอ้างอิง instance ล่าสุดไว้ให้ด้วย
		entry.name = child
		return entry
	end

	for _, child in ipairs(sf:GetChildren()) do
		if child:IsA("Frame") and not isTemplateLike(child) then
			local BTN = child:FindFirstChild("BTN")
			if BTN then
				-- ====== ชื่อไข่จาก Stat/NAME ======
				local Stat = BTN:FindFirstChild("Stat")
				local NAME = Stat and Stat:FindFirstChild("NAME") or nil
				local key: string? = nil
				if NAME then
					local valueObj = NAME:FindFirstChild("Value")
					local keyRaw = valueObj and readText(valueObj) or readText(NAME) or NAME.Name
					key = normalizeKey(keyRaw)
				end

				if key then
					local entry = ensureEntry(key, child)
					-- นับไอเท็มรวม 1 ชิ้น
					entry.allcount += 1

					-- ====== ดึง/นับปุ่ม Muts ใต้ BTN.Muts (เฉพาะที่ Visible จริง) ======
					local Muts = BTN:FindFirstChild("Muts")
					local isHave = false
					if Muts then
						for _, target in ipairs(mutsTargets) do
							local node = Muts:FindFirstChild(target)
							if node and node:IsA("GuiObject") and isActuallyVisible(node) then
								entry.data[target] = (entry.data[target] or 0) + 1
								isHave = true
							end
						end
					end
					if not isHave then
						entry.data["Normal"] = (entry.data["Normal"] or 0) + 1
					end
				end
			end
		end
	end

	return result
end

-- ====== อาหารเหมือนเดิม (คงไว้ตามของเดิม) ======
local function GetFoodFormInv()
	local _, screenStorage = getStorageGui()
	local frame = screenStorage:WaitForChild("Frame")
	local contentFood = frame:WaitForChild("ContentFood")
	local sf = contentFood:WaitForChild("ScrollingFrame")

	local result: { [string]: { count: number, name: Instance } } = {}

	for _, child in ipairs(sf:GetChildren()) do
		if child:IsA("Frame") and not isTemplateLike(child) then
			local BTN = child:FindFirstChild("BTN")
			if BTN then
				local Stat = BTN:FindFirstChild("Stat")
				if Stat then
					local NAME = Stat:FindFirstChild("NAME")
					local NUM  = Stat:FindFirstChild("NUM")

					if NAME and NUM then
						local nameVal = NAME:FindFirstChild("Value")
						local keyRaw = (nameVal and readText(nameVal)) or readText(NAME) or NAME.Name
						local key = normalizeKey(keyRaw)

						local numRaw = readText(NUM)
						local num = onlyDigits(numRaw) or 0

						if key then
							result[key] = { count = num, name = child }
						end
					end
				end
			end
		end
	end

	return result
end

return {
	GetEggFormInv  = GetEggFormInv,
	GetFoodFormInv = GetFoodFormInv,
}
