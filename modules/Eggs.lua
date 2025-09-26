local function cacheAnimationTrack(animator, track, animCache)
    animCache[#animCache + 1] = {
        Animator = animator,
        Animation = track.Animation,
        TimePosition = track.TimePosition,
        IsLooped = track.Looped,
    }
end

local function cachePart(obj, partCache)
    local key = "Part::" .. obj:GetFullName()
    partCache[key] = {
        Instance = obj,
        Properties = {
            Transparency = obj.Transparency,
            CanCollide   = obj.CanCollide,
            Anchored     = obj.Anchored,
            Color        = obj.Color,
            Material     = obj.Material,
        }
    }
end

local function cacheSurface(obj, partCache)
    local key = "Surface::" .. obj:GetFullName()
    partCache[key] = {
        Instance = obj,
        Properties = {
            Transparency = obj.Transparency,
            Color3       = obj.Color3,
            Texture      = obj.Texture,
        }
    }
end

local function restoreProperties(inst, props)
    for propName, value in pairs(props) do
        pcall(function()
            inst[propName] = value
        end)
    end
end

local function cacheEffect(obj, effectCache)
    effectCache[#effectCache + 1] = {
        Object  = obj,
        Enabled = obj.Enabled,
    }
end

local function cacheCenter(obj, effectCache)
    effectCache[#effectCache + 1] = {
        Object       = obj,
        Transparency = obj.Transparency,
    }
end

local function getKeys(obj)
    local fullName = obj:GetFullName()
    return "Part::" .. fullName, "Surface::" .. fullName
end

return {
    -- Roots
    eggsFolder = ,

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
                            cacheAnimationTrack(animator, track, self.animCache)
                            track:Stop()
                        end
                    end
                end
            end
            -- Only wait once per built, not per descendant
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
            local descendants = built:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj:IsA("BasePart") then
                    cachePart(obj, self.partCache)
                    obj.Transparency = 1
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    cacheSurface(obj, self.partCache)
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
            local descendants = built:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                local keyPart, keySurf = getKeys(obj)
                local data = self.partCache[keyPart] or self.partCache[keySurf]
                if data then
                    local inst = data.Instance
                    local props = data.Properties
                    if inst and inst:IsDescendantOf(workspace) then
                        restoreProperties(inst, props)
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
            local descendants = built:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail")
                    or obj:IsA("PointLight") or obj:IsA("SpotLight") then
                    cacheEffect(obj, self.effectCache)
                    obj.Enabled = false
                elseif obj:IsA("BasePart") and obj.Name == "Center" then
                    cacheCenter(obj, self.effectCache)
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
