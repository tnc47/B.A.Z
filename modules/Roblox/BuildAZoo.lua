local Pets = workspace:FindFirstChild("Pets")
local PlayerBuiltBlocks = workspace:FindFirstChild("PlayerBuiltBlocks")
local Players = game:GetService("Players")
local IslandName = Players.LocalPlayer:GetAttribute("AssignedIslandName")
return {
    Players = Players,
    LocalPlayer = Players.LocalPlayer,
    IslandName = IslandName,
    Pets = Pets,
    PlayerBuiltBlocks = PlayerBuiltBlocks
}
