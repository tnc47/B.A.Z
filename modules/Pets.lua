local petsFolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/tnc47/B.A.Z/refs/heads/main/modules/Roblox/BuildAZoo.lua"))().Pets

return {
    petsFolder = petsFolder,

    -- Cache ต่าง ๆ
    partCache = {},
    animCache = {},
    effectCache = {},

    -- ซ่อน Pet ทั้งหมด
    hidePets = function(self)
        for _, pet in ipairs(self.petsFolder:GetChildren()) do
            for _, obj in ipairs(pet:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local key = "Part::" .. obj:GetFullName()
                    self.partCache[key] = {
                        Instance = obj,
                        Properties = {
                            Transparency = obj.Transparency,
                            CanCollide = obj.CanCollide,
                            Anchored = obj.Anchored,
                            Color = obj.Color,
                            Material = obj.Material,
                        }
                    }
                    obj.Transparency = 1
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    local key = "Surface::" .. obj:GetFullName()
                    self.partCache[key] = {
                        Instance = obj,
                        Properties = {
                            Transparency = obj.Transparency,
                            Color3 = obj.Color3,
                            Texture = obj.Texture,
                        }
                    }
                    obj.Transparency = 1
                end
            end
            task.wait(0.01)
        end
    end,

    -- แสดง Pet กลับมา
    showPets = function(self)
        for _, pet in ipairs(self.petsFolder:GetChildren()) do
            for _, obj in ipairs(pet:GetDescendants()) do
                local keyPart = "Part::" .. obj:GetFullName()
                local keySurf = "Surface::" .. obj:GetFullName()

                local data = self.partCache[keyPart] or self.partCache[keySurf]
                if data then
                    local inst = data.Instance
                    local props = data.Properties
                    if inst and inst:IsDescendantOf(workspace) then
                        for propName, value in pairs(props) do
                            pcall(function()
                                inst[propName] = value
                            end)
                        end
                    else
                        warn("[showPets] Instance removed:", keyPart or keySurf)
                    end
                end
            end
        end
        self.partCache = {}
    end,

    -- หยุด Animation
    pausePetAnimations = function(self)
        self.animCache = {}
        for _, pet in ipairs(self.petsFolder:GetChildren()) do
            for _, ac in ipairs(pet:GetDescendants()) do
                if ac:IsA("AnimationController") then
                    local animator = ac:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            table.insert(self.animCache, {
                                Animator = animator,
                                Animation = track.Animation,
                                TimePosition = track.TimePosition,
                                IsLooped = track.Looped,
                            })
                            track:Stop()
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end,

    -- เล่น Animation ต่อ
    resumePetAnimations = function(self)
        for _, data in ipairs(self.animCache) do
            local animator = data.Animator
            local anim = data.Animation
            if animator and anim then
                local ok, track = pcall(function()
                    return animator:LoadAnimation(anim)
                end)
                if ok and track then
                    track.Looped = data.IsLooped
                    track:Play()
                    track.TimePosition = data.TimePosition
                end
            end
            task.wait(0.01)
        end
        self.animCache = {}
    end,

    -- ซ่อน Effect
    hidePetEffects = function(self)
        self.effectCache = {}
        for _, pet in ipairs(self.petsFolder:GetChildren()) do
            for _, obj in ipairs(pet:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
                    table.insert(self.effectCache, {
                        Object = obj,
                        Enabled = obj.Enabled,
                    })
                    obj.Enabled = false
                elseif obj:IsA("BasePart") and obj.Name == "Center" then
                    table.insert(self.effectCache, {
                        Object = obj,
                        Transparency = obj.Transparency,
                    })
                    obj.Transparency = 1
                end
            end
            task.wait(0.01)
        end
    end,

    -- แสดง Effect
    showPetEffects = function(self)
        for _, data in ipairs(self.effectCache) do
            local obj = data.Object
            if obj and obj:IsDescendantOf(workspace) then
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.Transparency = data.Transparency or 0
                    else
                        obj.Enabled = data.Enabled
                    end
                end)
            end
            task.wait(0.01)
        end
        self.effectCache = {}
    end,

    -- เคลม Coin
    claimPetCoins = function(self)
        for _, pet in ipairs(self.petsFolder:GetChildren()) do
            local root = pet:FindFirstChild("RootPart")
            if not root then
                return false
            end
            local re = root:FindFirstChild("RE")
            if not re or not re.FireServer then
                return false
            end
            pcall(function()
                re:FireServer("Claim")
            end)
        end
    end
}
