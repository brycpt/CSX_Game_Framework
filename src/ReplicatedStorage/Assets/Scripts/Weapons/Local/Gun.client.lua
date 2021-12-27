--Created by EPIXPLODE
--Gun tool local script


local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")

local Assets = ReplicatedStorage:WaitForChild("Assets")
local Animations = Assets:WaitForChild("Animations")

local player
local char
local camera
local tool
local vm
local anim_controller
local weapon_option_script
local class_weapon
local weapon_name
local firing
local reloading
local equipped
local equipping
local firstshot
local mousedown
local fire_sound
local weapon_animations
local automatic
local hold_anim
local hold_track
local pullout_anim
local pullout_track
local fire_anim
local fire_track
local reload_anim
local reload_track
local base_damage
local headshot_multiplier
local travel_length
local travel_speed
local fire_sound_distance
local fire_rate
local fire_sway_speed
local fire_sway_x
local fire_sway_y
local fire_sway_z
local fire_recovery_sway_x
local fire_recovery_sway_y
local fire_recovery_sway_z
local equip_recovery_sway
local weapon_mass
local weapon_display
local movement_inacc
local jump_inacc
local strafe_acc
local accuracy
local ammo
local reload_time
local mag_size
local total_ammo

local function init()
	player = Players.LocalPlayer
	char = player.Character or player.CharacterAdded:Wait()
	camera = workspace.CurrentCamera
	tool = script.Parent
	vm = player.Backpack:WaitForChild("viewModel")
	anim_controller = vm:WaitForChild("AnimationController")
	
	weapon_name = string.gsub(script.Name, "Local", "") --replace "Local" with ""
	weapon_option_script = require(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Modules"):WaitForChild("Options"):WaitForChild("O_" .. weapon_name))
	class_weapon = require(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Classes"):WaitForChild("C_Weapon"))
	weapon_display = player.PlayerGui:WaitForChild(weapon_name .. "Display")
	
	firing = false
	reloading = false
	equipped = false
	equipping = false
	firstshot = true
	mousedown = false
	automatic = weapon_option_script.AUTOMATIC
	
	fire_sound = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sounds"):WaitForChild("Weapons"):WaitForChild(weapon_name):WaitForChild("Fire")
	
	weapon_animations = Animations:WaitForChild("Weapons"):WaitForChild(weapon_name)
	hold_anim = weapon_animations:WaitForChild("Hold")
	hold_track = anim_controller:LoadAnimation(hold_anim)
	pullout_anim = weapon_animations:WaitForChild("Pullout")
	pullout_track = anim_controller:LoadAnimation(pullout_anim)
	fire_anim = weapon_animations:WaitForChild("Fire")
	ammo = tool:WaitForChild("Ammo")
	base_damage = weapon_option_script.BASE_DAMAGE
	headshot_multiplier = weapon_option_script.HEADSHOT_MULTIPLIER
	travel_length = weapon_option_script.BULLET_TRAVEL_LENGTH
	travel_speed = weapon_option_script.BULLET_TRAVEL_SPEED
	fire_sound_distance = weapon_option_script.FIRE_SOUND_DISTANCE
	fire_track = anim_controller:LoadAnimation(fire_anim)
	fire_sway_speed = weapon_option_script.FIRE_SWAY_SPEED
	fire_sway_x = weapon_option_script.FIRE_SWAY_X
	fire_sway_y = weapon_option_script.FIRE_SWAY_Y
	fire_sway_z = weapon_option_script.FIRE_SWAY_Z
	fire_recovery_sway_x = weapon_option_script.FIRE_RECOVERY_SWAY_X
	fire_recovery_sway_y = weapon_option_script.FIRE_RECOVERY_SWAY_Y
	fire_recovery_sway_z = weapon_option_script.FIRE_RECOVERY_SWAY_Z
	reload_time = weapon_option_script.RELOAD_TIME
	reload_anim = weapon_animations:WaitForChild("Reload")
	reload_track = anim_controller:LoadAnimation(reload_anim)
	mag_size = weapon_option_script.MAGAZINE_SIZE
	total_ammo = weapon_option_script.TOTAL_AMMO
	equip_recovery_sway = weapon_option_script.EQUIP_SWAY_DOWN_DELAY
	fire_rate = weapon_option_script.FIRE_RATE
	weapon_mass = weapon_option_script.MASS
	accuracy = weapon_option_script.ACCURACY
	accuracy = Vector3.new(accuracy, accuracy, accuracy)
	strafe_acc = weapon_option_script.COUNTER_STRAFE_INCREMENT
	movement_inacc = weapon_option_script.MOVEMENT_INACCURACY
	jump_inacc = weapon_option_script.JUMPING_INACCURACY
	
	print("Initialized " .. weapon_name .. ", " .. player.Name .. ".")
end

local function update(dt)
	
	local hrp = vm:FindFirstChild("HumanoidRootPart")
	
	if hrp then
		
		if equipped or equipping then
			
			hrp.CFrame = camera.CFrame

			class_weapon:VisualizeBobbing(dt, hrp, char:WaitForChild("HumanoidRootPart"))
			class_weapon:VisualizeSway(dt, hrp)
			class_weapon:VisualizeFiring(dt, hrp, fire_sway_speed, fire_sway_x, fire_sway_y, fire_sway_z, fire_recovery_sway_x, fire_recovery_sway_y, fire_recovery_sway_z, fire_rate, firing)
			
		end
	end
end

init()

Run.RenderStepped:Connect(update)

tool.Equipped:Connect(function()
	
	weapon_display.Enabled = true
	equipping = true
	
	class_weapon.equip(tool, pullout_track, hold_track, vm)
	
	equipped = true
	equipping = false
end)

tool.Unequipped:Connect(function()
	weapon_display.Enabled = false
	class_weapon.unequip(tool, pullout_track, hold_track, vm)
	equipped = false
end)


--firing
tool.Activated:Connect(function()
	
	if automatic then mousedown = true end
	
	if equipped then
		
		while mousedown or firstshot do
			
			--sanity checks
			if firing then return end
			if ammo:WaitForChild("Magazine").Value <= 0 then
				--play empty clip noise
				return
			end
			
			firstshot = false
			firing = true
			class_weapon.shoot_gun(tool, accuracy, movement_inacc, jump_inacc, strafe_acc, base_damage, headshot_multiplier, fire_rate, travel_length, travel_speed, fire_track, fire_sound, fire_sound_distance)
			firing = false
		end
			
	end
	
	firstshot = true
	
end)

--mousedown ended registration
UserInputService.InputEnded:Connect(function(i, g)
	if i.UserInputType == Enum.UserInputType.MouseButton1 and not g then
		if automatic and mousedown then mousedown = false end
	end
end)

--reload input registration
UserInputService.InputBegan:Connect(function(i, g)
	if i.KeyCode == Enum.KeyCode.R and not g then
		
		--sanity checks
		if reloading then return end
		
		reloading = true
		
		class_weapon.reload_gun(tool, mag_size, total_ammo, reload_track, reload_time)
		
		reloading = false
		
	end
end)
