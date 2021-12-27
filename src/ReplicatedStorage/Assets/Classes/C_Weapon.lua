--WEAPONS CLASS

-- ** WEAPON REQUIREMENTS **
--[[

* an option script named "O_WeaponName" in ReplicatedStorage.Assets.Modules.Objects
* the name of the weapon listed in self.WeaponNames

* a model in ReplicatedStorage.Assets.Models.Weapons, named the weaponName
* a folder named GunComponents parented to the weapon model
* a Handle named "WeaponHandle" parented to the GunComponents folder
* hold, shoot, reload, equip, inspect animations in ReplicatedStorage.Assets.Animations.Weapons

]]


local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Modules")
local Springs = require(Modules:WaitForChild("Springs"))
local WeaponSkin = require(Modules:WaitForChild("Weapons"):WaitForChild("Skins"))
local Recoil = require(Modules:WaitForChild("Weapons"):WaitForChild("Recoil"))
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Animations = Assets:WaitForChild("Animations")
local Scripts = Assets:WaitForChild("Scripts")
local RemoteEvents = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local RemoteFunctions = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local hit_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("Hit")

local module = {}

--weapon variables

module.WeaponNames = {"AK47", "Glock-17", "Knife"}

function module.valid_weapon(weapon)
	for i, v in pairs(module.WeaponNames) do
		if v == weapon then return true end
	end
	return false
end

--weapon script functionality

function module.add(player, weapon) --adds specified weapon to player's inventory, cannot be called from a LocalScript.
									--the tool and weapon UI must be enabled from the script it is added from or else it will not be useable. (to prevent bugs an exploits)
	
	local ServerScriptService = game:GetService("ServerScriptService")
	local ServerAssets = ServerScriptService:WaitForChild("ServerAssets")
	
	local option_script
	local weapon_model
	
	--check if desired weapon is valid
	
		--name validation
		local function weapon_name_check(weapon)
		
			for i, v in pairs(module.WeaponNames) do
				if weapon == v then return true end
			end
		
			return false
		end
	
		if not weapon_name_check(weapon) then
			warn("CSX: Unable to verify weapon name " .. weapon .. " in ReplicatedStorage.Assets.WeaponNames.Scripts.Weapons.Classes.C_Weapon.WeaponNames")
			return
		end
	
		--model validation
		weapon_model = Assets:WaitForChild("Models"):WaitForChild("Weapons"):FindFirstChild(weapon)
		if not weapon_model then
			warn("CSX: Unable to verify weapon model in ReplicatedStorage.Assets.Models.Weapons. Weapon Name: " .. weapon)
			return
		end
	
		--option script validation
		option_script = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Modules"):WaitForChild("Options"):FindFirstChild("O_" .. weapon)
		if not option_script then
			warn("CSX: Unable to verify weapon object script in ServerScriptService.ServerAssets.Scripts.Weapons. WeaponName: " .. weapon)
			return
		end
	
	--initiate weapon-specific variables

	local local_script
	local server_script
	local info_ui

	if require(option_script).MELEE then

		local_script = Scripts:WaitForChild("Weapons"):WaitForChild("Local"):WaitForChild("Melee")
		server_script = Scripts:WaitForChild("Weapons"):WaitForChild("Server"):WaitForChild("Melee")
		
		--init weapon ui var
		info_ui = Assets:WaitForChild("UI"):WaitForChild("Weapons"):WaitForChild("MeleeInfo"):Clone()
		
	else

		local_script = Scripts:WaitForChild("Weapons"):WaitForChild("Local"):WaitForChild("Gun")
		server_script = Scripts:WaitForChild("Weapons"):WaitForChild("Server"):WaitForChild("Gun")
		
		--init weapon ui var
		info_ui = Assets:WaitForChild("UI"):WaitForChild("Weapons"):WaitForChild("GunInfo"):Clone()
		info_ui:WaitForChild("Frame"):WaitForChild("GunName").Text = weapon
		info_ui:WaitForChild("Frame"):WaitForChild("CurrentAmmo").Text = tostring(require(option_script).MAGAZINE_SIZE)
		info_ui:WaitForChild("Frame"):WaitForChild("TotalAmmo").Text = tostring(require(option_script).TOTAL_AMMO)
		
	end
	
	--create tool
	local tool = Instance.new("Tool")
	tool.Name = weapon
	tool.Parent = player.Backpack
	tool.RequiresHandle = false
	tool.Enabled = false
	
	--create weapon model
	local model = weapon_model:Clone()
	model.Name = weapon
	model.Parent = tool
	
	--weapon modules
	if require(option_script).SKINS then
		WeaponSkin.load(player, tool) --loads the weapon skin onto the model
	end
	
	--if require(option_script).STATS then
		
	--end
	
	--create weapon scripts
	local LS = local_script:Clone()
	local SS = server_script:Clone()
	
	LS.Name = "Local" .. weapon
	SS.Name = "Server"
	
	LS.Parent = tool
	SS.Parent = tool
	
	--create ammo files
	local Ammo = Instance.new("Folder")
	Ammo.Name = "Ammo"
	Ammo.Parent = tool
	
	local Magazine = Instance.new("NumberValue")
	Magazine.Name = "Magazine"
	Magazine.Value = require(option_script).MAGAZINE_SIZE
	Magazine.Parent = Ammo
	
	local TotalAmmo = Instance.new("NumberValue")
	TotalAmmo.Name = "TotalAmmo"
	TotalAmmo.Value = require(option_script).TOTAL_AMMO
	TotalAmmo.Parent = Ammo
	
	--create weapon UI
	info_ui.Name = weapon .. "Display"
	info_ui.Enabled = false
	info_ui.Parent = player.PlayerGui
	
	return tool, info_ui
end

--weapon tool functionality

local function weapon_transparency(a, model)
	local b
	if a then b = 1 else b = 0 end
	
	for i, v in pairs(model:GetDescendants()) do
		if not v.Name == "WeaponHandle" and not v.Name == "Sight" and v:IsA("BasePart") or v:IsA("MeshPart") then
			v.Transparency = b
		end
	end
	
end

function module.equip(tool, pullout, hold, vm)
	
	--display server model
	RemoteEvents:WaitForChild("Weapons"):WaitForChild("ConnectM6D"):FireServer(tool)
	
	--display client model
	local server_model = tool:WaitForChild(tool.Name)
	local client_model = server_model:Clone()
	
	--hide server model for player
	weapon_transparency(true, server_model)
	weapon_transparency(true, client_model)
	weapon_transparency(true, vm)
	
	client_model.Parent = vm:WaitForChild("Equipped")
	vm:WaitForChild("HumanoidRootPart"):WaitForChild("WeaponHandle").Part1 = client_model:WaitForChild("GunComponents"):WaitForChild("WeaponHandle")
	vm.Parent = workspace.CurrentCamera
	
	pullout:Play()
	task.wait(.1) --this gives the VM time to load to reduce bugginess
	weapon_transparency(false, client_model)
	weapon_transparency(false, vm)
	
	--play animations
	pullout.Stopped:Wait()
	--equipped sanity check
	if vm:WaitForChild("Equipped"):FindFirstChild(tool.Name) then
		hold:Play()
	end
	
end

function module.unequip(tool, pullout, hold, vm)
	
	pullout:Stop()
	hold:Stop()
	
	--undisplay server model
	RemoteEvents:WaitForChild("Weapons"):WaitForChild("DisconnectM6D"):FireServer(tool)
	
	--undisplay client model
	local server_model = tool:WaitForChild(tool.Name)
	local client_model = vm:WaitForChild("Equipped"):FindFirstChild(tool.Name)
	
	weapon_transparency(false, server_model)
	
	vm:WaitForChild("HumanoidRootPart"):WaitForChild("WeaponHandle").Part1 = nil
	if client_model then client_model:Destroy() end
	vm.Parent = player.Backpack
	
end

function module.shoot_gun(tool, accuracy, movement_inacc, jump_inacc, strafe_acc, base_damage, headshot_multiplier, fire_rate, travel_length, travel_speed, fire_animation, fire_sound, fire_sound_distance)

	local mouse = player:GetMouse()
	local cameraCF = camera.CFrame
	local hit = mouse.Hit.Position
	local damage = base_damage
	local hrp = player.Character:WaitForChild("HumanoidRootPart")
	
	--movement acc calculation
	local s
	local r
	local j
	
	--calculate movement speed
	if hrp.Velocity.magnitude < 9 then
		s = false
		r = false
	else
		
		if hrp.Velocity.magnitude > 9 and hrp.Velocity.magnitude < 12 then
			s = true
			r = false
		else
			r = true
			s = false
		end
		
	end
	
	--jump check
	local char = hrp.Parent
	local j_origin = hrp.Position
	local j_direction = Vector3.new(0, -5, 0)
	local j_params = RaycastParams.new()

	j_params.FilterType = Enum.RaycastFilterType.Blacklist
	j_params.FilterDescendantsInstances = {char}

	local result = workspace:Raycast(j_origin, j_direction, j_params)
	if not result then j = true end

	--final accuracy calculation
	if j then
		accuracy = accuracy * jump_inacc
		print('jumping')
	else
		
		if s then
			accuracy = accuracy / strafe_acc
			print('strafing')
		end

		if r then
			accuracy = accuracy * movement_inacc
			print('moving')
		end
		
	end
	
	--init ray
	local map = workspace:WaitForChild("Map")
	local mouse2d = Vector2.new(mouse.X, mouse.Y)
	
	--account for base accuracy
	local newTarget = mouse2d + Vector2.new((math.random(-accuracy.X, accuracy.X) * 0.1), (math.random(-accuracy.Y, accuracy.Y) * 0.1))
	
	--calculate recoiled bullet & recoil camera
	newTarget = Recoil.recoil_bullet(newTarget.X, newTarget.Y, camera)
	
	--fire ray from 2d point on screen, accounting for recoil accuracy
	local unitRay = camera:ScreenPointToRay(newTarget.X, newTarget.Y)
	local ray = Ray.new(unitRay.Origin, unitRay.Direction * travel_length)
	
	--wallbang ray
	local wall_part, wall_point = workspace:FindPartOnRayWithWhitelist(ray, {map})
	if wall_part and wall_point and wall_part.Parent == map:WaitForChild("BangableWalls") then
		damage = damage/50
		print('wallbang')
	end
	
	--hit detection ray
	local part, point = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, map:WaitForChild("BangableWalls"), workspace:WaitForChild("Temporary"):WaitForChild("Grenades"), map:WaitForChild("ClipBoxes")})
	if part and point then
		hit_event:FireServer(tool, damage, headshot_multiplier, travel_speed, part, point)
		print('hit event fired')
	end
	
	--play animation
	fire_animation:Play()
	
	--play sound client side
	local sound_clone = fire_sound:Clone()
	sound_clone.Parent = tool
	sound_clone:Play()
	Debris:AddItem(sound_clone, sound_clone.TimeLength)
	
	--play sound server side by detecting near by players, and invoking the PlaySound remote function
	for i, v in pairs(Players:GetPlayers()) do
		if v ~= player then
			--sanity check
			local hrp = v.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				--distance check
				if (hrp.Position - player.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= fire_sound_distance then
					RemoteFunctions:WaitForChild("PlaySound"):InvokeServer(v, fire_sound)
				end
			end
		end
	end
	
	--update ammo
	local ammo = tool:WaitForChild("Ammo")
	local curr = ammo:WaitForChild("Magazine")
	local total = ammo:WaitForChild("TotalAmmo")
	
	curr.Value = curr.Value - 1
	
	--fire rate
	task.wait(fire_rate)
	
end

function module.reload_gun(tool, mag_size, total_ammo, reload_animation, reload_time)
	
	--play reload sound(s)
	
	--play reload animation
	
	task.wait(reload_time)
	
	--calculate left over ammo
	
	local ammo = tool:WaitForChild("Ammo")
	local curr = ammo:WaitForChild("Magazine")
	local total = ammo:WaitForChild("TotalAmmo")
	
	--no ammo left in supply
	if total == 0 then
		--play empty clip noise
		return
	end
	
	--ammo needed to reload
	local need = mag_size - curr.Value
	
	--if we have more than enough ammo
	if need < total.Value then
		--max ammo in mag
		curr.Value = mag_size
		--subtract taken ammo
		total.Value = total_ammo - need
		
	--if we have exactly enough
	elseif need == total.Value then
		--max ammo in mag
		curr.Value = mag_size
		--remove all ammo
		total.Value = 0
		
	--not enough ammo
	elseif need > total.Value then
		--ammo is ammo left
		curr.Value = total.Value
		--remove all ammo
		total.Value = 0
	end
	
end

function module.aim_gun()
	
end

function module.first_attack_knife()
	
end

function module.second_attack_knife()
	
end

--weapon spring animations

module.RecoilSpring = Springs.new()
module.EquippingSpring = Springs.new()
module.BobbleSpring = Springs.new()
module.SwayingSpring = Springs.new()

local function shove(spring, dt, speed, x, y, z)
	spring:shove(Vector3.new(x, y, z) * dt * speed)
end

local function bob(addition)
	return math.sin(tick() * addition  * 1.3) * 0.5
end

function module:VisualizeFiring(dt, hrp, sway_speed, x, y, z, rx, ry, rz, firerate, firing)
	--set speed to configured speed
	if module.RecoilSpring.Speed ~= sway_speed then
		module.RecoilSpring.Speed = sway_speed
	end
	
	--firing sanity check
	if firing then
		
		--animation
		shove(self.RecoilSpring, dt, 60, x, y, z)
		--down animation
		task.delay(firerate, function()
			shove(self.RecoilSpring, dt, 60, -rx, -ry, -rz)
		end)
	end
	local recoil = self.RecoilSpring:update(dt)
	hrp.CFrame = hrp.CFrame:ToWorldSpace(CFrame.new(recoil.x, recoil.y, recoil.z))
end

function module:VisualizeEquipping(dt, hrp, mass, speed, equipping)
	--equipping sanity check
	if equipping then
		--set mass and speed to configured
		module.EquippingSpring.Mass = mass
		module.EquippingSpring.Speed = speed
		--up animation
		self.EquippingSpring:shove(Vector3.new(0, 0.13, 0) * dt * 30)
		task.wait(.1)
		self.EquippingSpring:shove(Vector3.new(0, -0.1, 0) * dt * 30)
	end
	local equip = self.EquippingSpring:update(dt)
	hrp.CFrame = hrp.CFrame:ToWorldSpace(CFrame.new(equip.x, equip.y, equip.z))
end

function module:VisualizeBobbing(dt, hrp, charHRP)
	local bobble = Vector3.new(bob(10), bob(5), bob(5))
	self.BobbleSpring:shove(bobble / 15 * (charHRP:WaitForChild("movementVelocity").Velocity.Magnitude) / 15)

	local UpdatedBobbleSpring = self.BobbleSpring:update(dt)
	hrp.CFrame = hrp.CFrame:ToWorldSpace(CFrame.new(UpdatedBobbleSpring.Y, UpdatedBobbleSpring.X, 0))
end

function module:VisualizeSway(dt, hrp)
	local MouseDelta = game:GetService("UserInputService"):GetMouseDelta()
	self.SwayingSpring:shove(Vector3.new(-MouseDelta.X  / 500), MouseDelta.Y / 200, 0)

	local UpdatedSwaySpring = self.SwayingSpring:update(dt)
	hrp.CFrame *= CFrame.new(UpdatedSwaySpring.X, UpdatedSwaySpring.Y, 0)
end

return module