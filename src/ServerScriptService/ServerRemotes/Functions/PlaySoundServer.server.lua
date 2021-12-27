--handles sever side play sound remote function

local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("PlaySound")

local function play_sound(parent, player, sound)
	print(player)
	print(sound)
	print(parent)
	remote:InvokeClient(player, sound, parent)
	--local clone = sound:Clone()
	--clone.Parent = parent
	--clone:Play()
	--game:GetService("Debris"):AddItem(clone, clone.TimeLength)
end

remote.OnServerInvoke = play_sound