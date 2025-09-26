local BuildAZoo = game:HttpGet("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Roblox/BuildAZoo.lua")
local BuildAZooFolder = loadstring(BuildAZoo)()

-- helper อ่านค่า text/number จาก object
local function readValue(obj)
    if not obj then return nil end
    if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") then
        return tostring(obj.Value)
    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
        return obj.Text
    end
    return nil
end

local function GetInventoryFoodItems()
    local FoodData = {}
    local pg = BuildAZooFolder.LocalPlayer:WaitForChild("PlayerGui", 10)
    local screenStorage = pg and pg:FindFirstChild("ScreenStorage")
    if not screenStorage then return {} end

    local frame = screenStorage:FindFirstChild("Frame")
    if not frame then return {} end

    local content = frame:FindFirstChild("ContentFood")
    if not content then return {} end

    local scrollingFrame = content:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return {} end

    for _, item in ipairs(scrollingFrame:GetChildren()) do
        if item:IsA("Frame") or item:IsA("TextButton") or item:IsA("ImageButton") then
            local numObj = item:FindFirstChild("NUM", true)
            local val = readValue(numObj)
            if item.Name ~= 'Item' then
                FoodData[item.Name] = tonumber(val and val:gsub("x", "")) or 0
            end
        end
    end
    return FoodData
end

return {
    GetInventoryFoodItems = GetInventoryFoodItems
}
