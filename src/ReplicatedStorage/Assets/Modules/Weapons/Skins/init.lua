--Weapon Skins class module

--must be called before weapon scripts are made

--define rarity types
--define rarities

--each gun that will be skinned will need a module script parented to this module script
--the module script will contain information and functions for each skin

local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Classes = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Classes")

local module = {}

module.csx_skin_inventory_default = {
		
	AK47 = {
		equipped_skin = "Default",
		inventory = {"Default"}
	},
		
	Glock17 = {
		equipped_skin = "Default",
		inventory = {"Default"}
	}
	
}

function module.grab(player, weapon) --grabs the player's current equipped weapon skin from datastore
	
	local ServerScriptService = game:GetService("ServerScriptService")
	local ServerModules = ServerScriptService:WaitForChild("ServerAssets"):WaitForChild("Modules")
	local DataStore2 = require(ServerModules:WaitForChild("DataStore2"))
	
	local C_Weapon = require(Classes:WaitForChild("C_Weapon"))
	local data = DataStore2("csx_skin_inventory", player)
	local inventory = data:Get(module.csx_skin_inventory_default)
	
	--valid weapon sanity check
	if not C_Weapon.valid_weapon(weapon) then
		warn("CSX Weapons Class: Could not validate " .. weapon .. " module script in ReplicatedStorage.Assets.Classes.C_Weapon")
		return
	end
	
	--check if player is missing any new weapons
	weapon = string.gsub(weapon, "-", "") --get rid of any dashes in the name
	local weapon_table = inventory[weapon]
	if not weapon_table then
		
		--create a new dictionary
		local new_table = {
			equipped_skin = "Default",
			inventory = {"Default"}
		}
		--assign the dictionary to the weapon name string in the inventory
		inventory[weapon] = new_table
		--set the inventory
		data:Set(inventory)
		
		print("Created " .. weapon .. " weapon dictionary for " .. player.Name .. " csx_skin_inventory!")
	end
	
	local skin = weapon_table["equipped_skin"]
	
	return skin
end

function module.set(player, tool, skin_name, weapon_name) --sets the tool's model skin
	
	--validate weapon
	
	local weapon_skins = script:FindFirstChild("SM_" .. weapon_name)
	
	if not weapon_skins then
		warn("CSX Skins Module: Could not find " .. "SM_" .. weapon_name .. " module script in ReplicatedStorage.Modules.Weapons.Skins")
		return
	end
	
	--validate skin and grab model
	
	local model = require(weapon_skins).find_skin(skin_name)
	
	if not model then
		warn("CSX Skins Module: Incorrect skin name " .. weapon_name .. " | " .. skin_name .. "!")
		return
	end
	
	--replace the default model
	tool:WaitForChild(tool.Name):Destroy()
	model.Name = tool.Name
	model.Parent = tool
	
	print("Set skin successfully")
	
	return model
	
end

function module.load(player, tool) --grab and set
	
	local skin = module.grab(player, tool.Name)
	local model = module.set(player, tool, skin, tool.Name)
	
	return model
end

return module
