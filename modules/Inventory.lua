--!strict
local BuildAZoo = game:HttpGet("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Roblox/BuildAZoo.lua")
local BuildAZooFolder = loadstring(BuildAZoo)()

-- ====== Types ======
type ItemData = { count: number, name: Instance }
type ResultMap = { [string]: ItemData }

-- ====== Helpers ======
local function trim(s: string): string
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeKey(s: string?): string?
	if not s then return nil end
	-- ตัดช่องว่างหลายตัว -> ตัวเดียว, ลบ \r\n\t, แล้ว trim
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

-- แปลง text → number (รองรับ "x12", "12x", "Qty: 12", "(12)", "[12]" ฯลฯ)
local function onlyDigits(str: string?): number?
	if not str then return nil end
	local s = tostring(str)
	-- เอาเลขลบได้ (เผื่อบางเกมใส่ -1 เป็นตัวบอกสถานะ)
	local n = s:match("%-?%d+")
	return n and tonumber(n) or nil
end

local function isTemplateLike(inst: Instance): boolean
	-- กัน item template ตามชื่อ/attribute ทั่วไป
	if inst:GetAttribute("Template") == true then return true end
	local n = inst.Name:lower()
	return n == "item" or n:find("template") ~= nil
end

-- ====== Find roots ======
local function getStorageGui()
	local gui = BuildAZooFolder.LocalPlayer:WaitForChild("PlayerGui")
	local screenStorage = gui:WaitForChild("ScreenStorage")
	return gui, screenStorage
end

-- ====== Scanners ======

-- ดึงจำนวน "ไข่" จาก UI คลัง (ScreenStorage.Frame.Content.ScrollingFrame)
local function GetEggFormInv(): ResultMap
	local _, screenStorage = getStorageGui()
	local frame = screenStorage:WaitForChild("Frame")
	local content = frame:WaitForChild("Content")
	local sf = content:WaitForChild("ScrollingFrame")

	local result: ResultMap = {}

	for _, child in ipairs(sf:GetChildren()) do
		if child:IsA("Frame") and not isTemplateLike(child) then
			local BTN = child:FindFirstChild("BTN")
			if BTN then
				local Stat = BTN:FindFirstChild("Stat")
				if Stat then
					local NAME = Stat:FindFirstChild("NAME")
					if NAME then
						-- บางเกมจะมี Value เป็น TextLabel ภายใน NAME
						local valueObj = NAME:FindFirstChild("Value")
						local keyRaw = valueObj and readText(valueObj) or readText(NAME) or NAME.Name
						local key = normalizeKey(keyRaw)
						if key then
							local entry = result[key]
							if entry then
								entry.count += 1
							else
								result[key] = { count = 1, name = child }
							end
						end
					end
				end
			end
		end
	end

	return result
end

-- ดึงจำนวน "อาหาร" จาก UI คลัง (ScreenStorage.Frame.ContentFood.ScrollingFrame)
local function GetFoodFormInv(): ResultMap
	local _, screenStorage = getStorageGui()
	local frame = screenStorage:WaitForChild("Frame")
	local contentFood = frame:WaitForChild("ContentFood")
	local sf = contentFood:WaitForChild("ScrollingFrame")

	local result: ResultMap = {}

	for _, child in ipairs(sf:GetChildren()) do
		if child:IsA("Frame") and not isTemplateLike(child) then
			local BTN = child:FindFirstChild("BTN")
			if BTN then
				local Stat = BTN:FindFirstChild("Stat")
				if Stat then
					local NAME = Stat:FindFirstChild("NAME")
					local NUM  = Stat:FindFirstChild("NUM")

					if NAME and NUM then
						-- NAME อาจมี Value เป็น TextLabel หรือ StringValue
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
	GetEggFormInv = GetEggFormInv,
	GetFoodFormInv = GetFoodFormInv,
}
