return {
    -- Roots
    eggsFolder = workspace:FindFirstChild("PlayerBuiltBlocks"),

    -- Caches
    partCache = {},   -- BasePart / Decal / Texture state
    animCache = {},   -- playing animation tracks
    effectCache = {}, -- Particle/Beam/Trail/Light + special parts

    -- ===== Animations =====
    pauseEggAnimations = function(self)
        self.animCache = {}

        local folder = self.eggsFolder
        if not folder then return end

        for _, built in ipairs(folder:GetChildren()) do
            for _, ac in ipairs(built:GetDescendants()) do
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

    resumeEggAnimations = function(self)
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

    -- ===== Visibility (parts/decals/textures) =====
    hideEggs = function(self)
        local folder = self.eggsFolder
        if not folder then return end

        for _, built in ipairs(folder:GetChildren()) do
            for _, obj in ipairs(built:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local key = "Part::" .. obj:GetFullName()
                    self.partCache[key] = {
                        Instance = obj,
                        Properties = {
                            Transparency = obj.Transparency,
                            CanCollide   = obj.CanCollide,
                            Anchored     = obj.Anchored,
                            Color        = obj.Color,
                            Material     = obj.Material,
                        }
                    }
                    obj.Transparency = 1
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    local key = "Surface::" .. obj:GetFullName()
                    self.partCache[key] = {
                        Instance = obj,
                        Properties = {
                            Transparency = obj.Transparency,
                            Color3       = obj.Color3,
                            Texture      = obj.Texture,
                        }
                    }
                    obj.Transparency = 1
                end
            end
            task.wait(0.01)
        end
    end,

    showEggs = function(self)
        local folder = self.eggsFolder
        if not folder then return end

        for _, built in ipairs(folder:GetChildren()) do
            for _, obj in ipairs(built:GetDescendants()) do
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
                        warn("[EggsController.showEggs] Instance removed:", keyPart or keySurf)
                    end
                end
            end
        end

        self.partCache = {}
    end,

    -- ===== Effects (particles/lights & special parts) =====
    hideEggEffects = function(self)
        self.effectCache = {}

        local folder = self.eggsFolder
        if not folder then return end

        for _, built in ipairs(folder:GetChildren()) do
            for _, obj in ipairs(built:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail")
                    or obj:IsA("PointLight") or obj:IsA("SpotLight") then
                    table.insert(self.effectCache, {
                        Object  = obj,
                        Enabled = obj.Enabled,
                    })
                    obj.Enabled = false
                elseif obj:IsA("BasePart") and obj.Name == "Center" then
                    table.insert(self.effectCache, {
                        Object       = obj,
                        Transparency = obj.Transparency,
                    })
                    obj.Transparency = 1
                end
            end
            task.wait(0.01)
        end
    end,

    showEggEffects = function(self)
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
}
