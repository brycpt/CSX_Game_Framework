--handles weapon connect, disconnect motor events

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvents = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local WeaponRemotes = RemoteEvents:WaitForChild("Weapons")

WeaponRemotes:WaitForChild("ConnectM6D").OnServerEvent:Connect(function(player, tool)
	local char = player.Character or player.CharacterAdded:Wait()
	local handle = tool:WaitForChild(tool.Name):WaitForChild("GunComponents"):WaitForChild("WeaponHandle")
	char:WaitForChild("HumanoidRootPart"):WaitForChild("WeaponGrip").Part1 = handle
end)

WeaponRemotes:WaitForChild("DisconnectM6D").OnServerEvent:Connect(function(player, tool)
	local char = player.Character or player.CharacterAdded:Wait()
	local grip = char:WaitForChild("HumanoidRootPart"):WaitForChild("WeaponGrip")
	grip.Part1 = nil
end)