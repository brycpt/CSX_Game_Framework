--handles client side play sound remote function

local function play_sound(sound, parent)
	local clone = sound:Clone()
	clone.Parent = parent
	clone:Play()
	game:GetService("Debris"):AddItem(clone, clone.TimeLength)
end

local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("PlaySound")

remote.OnClientInvoke = play_sound