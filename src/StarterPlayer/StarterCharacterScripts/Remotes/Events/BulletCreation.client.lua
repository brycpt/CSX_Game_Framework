--Created by EPIXPLODE
--handles the client side creation of the bullet model for all players

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local bullet_create_client_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("CreateBullet")
local bullet_replicate_server_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("ReplicateBullet")

local function create_bullet(startpos, endpos, speed)
	
	--create bullet part
	local part = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Projectiles"):WaitForChild("Bullet"):Clone()
	part.Parent = workspace
	part.Position = startpos
	--grab updated part position
	local spos = part.CFrame.Position
	--bullet direction
	part.CFrame = CFrame.lookAt(spos, endpos)
	--bullet speed
	local tude = (spos - endpos).magnitude
	local tv = tude/speed
	--bullet animation tween
	local ti = TweenInfo.new(tv)
	local goal = {}
	goal.Position = endpos
	local tween = TweenService:Create(part, ti, goal)
	wait(.02) --wait debug so the bullet is shown starting at the tip of the weapon
	tween:Play()
	tween.Completed:Wait()
	part:Destroy()
	
end

--client side bullet creation
bullet_create_client_event.OnClientEvent:Connect(function(tool, pos, speed)
	--sanity checks
	if not tool then
		warn("Tool not equipped on server for bullet creation!")
		return end
	
	local vm = workspace.CurrentCamera:FindFirstChild("viewModel")
	if not vm then
		warn("Tool not equipped on client for bullet replication!")
		return
	end
	
	local vm_tool = vm:WaitForChild("Equipped"):FindFirstChild(tool.Name)
	if not vm_tool then
		warn("Tool not equipped on client Equipped Folder for bullet replication!")
		return
	end
	--start position is vm fire point
	local startpos = vm_tool:WaitForChild("GunComponents"):WaitForChild("WeaponHandle"):WaitForChild("FakeFirePoint").WorldPosition
	create_bullet(startpos, pos, speed)
	
end)

--server side bullet creation
bullet_replicate_server_event.OnClientEvent:Connect(function(tool, pos, speed)
	--start position is server model fire point
	local startpos = tool:WaitForChild(tool.Name):WaitForChild("GunComponents"):WaitForChild("WeaponHandle"):WaitForChild("FakeFirePoint").WorldPosition
	create_bullet(startpos, pos, speed)
end)