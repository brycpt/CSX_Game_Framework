--Created by EPIXPLODE
--Gun Weapon Server Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hit_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("Hit")
local create_bullet_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("CreateBullet")
local replicate_bullet_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("ReplicateBullet")

hit_event.OnServerEvent:Connect(function(player, tool, damage, headshot_multiplier, speed, part, point)
	--sanity checks
	if tool ~= script.Parent then return end
	if not part then return end
	
	--humamoid hit registration
	local hit_hum = part.Parent:FindFirstChild("Humanoid")
	local hum = player.Character:WaitForChild("Humanoid")
	if hit_hum and hum then
		--sanity checks
		if hit_hum.Health <= 0 then return end
		if hum.Health <= 0 then return end
		if not player.Character:FindFirstChild(tool.Name) then return end
		
		--headshot registration
		local headshot = false
		if part.Name == "Head" or part.Name == "HeadHB" then
			headshot = true
			damage = damage * headshot_multiplier
			
			local function play_hs_sound(sound)
				local clone = sound:Clone()
				clone.Parent = player.Character
				clone:Play()
				game:GetService("Debris"):AddItem(clone, clone.TimeLength)
			end
			
			play_hs_sound(ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sounds"):WaitForChild("Weapons"):WaitForChild("headshot"))
			play_hs_sound(ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sounds"):WaitForChild("Weapons"):WaitForChild("headshot1"))

		end
		
		hit_hum:TakeDamage(damage)
		
		--player killed registration
		if hit_hum.Health <= 0 then
			if headshot then
				local headshot_kill_gui = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Weapons"):WaitForChild("HeadshotKill"):Clone()
				headshot_kill_gui.Parent = player.PlayerGui
			end
		end
		
		--hitmarker
		local hitmarker
		if headshot then
			hitmarker = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Weapons"):WaitForChild("HeadshotHitmarker"):Clone()
		else
			hitmarker = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Weapons"):WaitForChild("BodyHitmarker"):Clone()
		end
		hitmarker.Parent = player.PlayerGui
		
		print('humanoid took: ' .. damage)
	end
	
	--bullet creation
	for i, v in pairs(game:GetService("Players"):GetPlayers()) do
		if v == player then
			create_bullet_event:FireClient(v, tool, point, speed)
		else
			replicate_bullet_event:FireClient(v, tool, point, speed)
		end
	end
	
	print('Hit Event')
end)