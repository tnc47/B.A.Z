local BuildAZoo = game:HttpGet("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Roblox/BuildAZoo.lua")
local BuildAZooFolder = loadstring(BuildAZoo)()

return {
    GetOwnerLand = function(self)
        return BuildAZooFolder.IslandName
    end,
    GetOwnerLandBelt = function(self)
        local EggInBelt = {}
        local IslandName = self:GetOwnerLand()
        if not IslandName then
            warn("Cannot find AssignedIslandName attribute for the local player.")
            return nil
        end

        local belt = workspace:WaitForChild("Art")
            :WaitForChild(IslandName)
            :WaitForChild("ENV")
            :WaitForChild("Conveyor")
            :WaitForChild("Conveyor1")
            :WaitForChild("Belt")

        for _, obj in ipairs(belt:GetChildren()) do
            local rootPart = obj:FindFirstChild("RootPart")
            local eggname = obj:GetAttribute("Type")
            if rootPart then
                local eggGUI = rootPart:FindFirstChild("GUI/EggGUI", true)
                if eggGUI then
                    for _, desc in ipairs(eggGUI:GetDescendants()) do
                        if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Name == "Mutate" then
                            EggInBelt[#EggInBelt + 1] = {
                                Name = eggname,
                                Mutate = desc.Text or 'none'
                            }
                        end
                    end
                end
            end
        end
        return EggInBelt
    end
}
