local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkinModules = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Skin")
local PlayerCache = ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players")
	
local Skin = {}

Skin.DefaultInventory = {
	AK = {
		Name = "AK47",
		Equipped = "Default",
		Inventory = {"Default"}
	},
	Glock = {
		Name = "Glock-17",
		Equipped = "Default",
		Inventory = {"Default"}
	},
	Knife = {
		Name = "Knife",
		Equipped = "Default_Default", --knifeName_knifeSkin
		Inventory = {
			Default = {
				Name = "Default",
				Skins = {"Default"},
			}
		}
	}
}

Skin.AdminInventory = {
	AK = {
		Name = "AK47",
		Equipped = "Default",
		Inventory = {"Default", "Gold"}
	},
	Glock = {
		Name = "Glock-17",
		Equipped = "Default",
		Inventory = {"Default","Lava"}
	},
	Knife = {
		Name = "Knife",
		Equipped = "Default_Default",
		Inventory = {
			Default = {
				Name = "Default",
				Skins = {"Default", "BlueIce"},
			},
			Karambit = {
				Name = "Karambit",
				Skins = {"Default", "BlueIce", "GreenIce"}
			}
		}
	}
}

Skin.get_inv = function(player)
	local DataStore2 = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("DataStore2"))
	local data = DataStore2("skin_inventory", player)
	local inv = data:Get(Skin.DefaultInventory)
	return data, inv
end

Skin.grab = function(player, weapon) --grab the currently equipped weapon skin
	local skin = ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon):WaitForChild("equipped_skin").Value
	
	return skin
end

Skin.add = function(player, weapon, skin, knifeSkin) -- if weapon == "Knife" then skin == knifeName
	
	local data, inv = Skin.get_inv(player)

	if weapon == "AK47" or weapon == "AK" then

		local ak = require(SkinModules:WaitForChild("AK47"))
		if ak.validSkin(skin) then
			
			for i, v in pairs(inv.AK.Inventory) do --check to see if has skin
				if skin == v then
					print("Skin already in inventory!")
					return false end
			end
			
			table.insert(inv.AK.Inventory, 1, skin)

			local sv = Instance.new("StringValue")
			sv.Name = "skin"
			sv.Value = skin
			sv.Parent = ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon)

			data:Set(inv)

			--print("Added AK .. " .. skin .. " to " .. player.Name .. " 's inventory!")
			
			return true
		end
	elseif weapon == "Glock" or weapon == "Glock17" or weapon == "Glock-17" then
		
		if weapon == "Glock" or weapon == "Glock17" then
			weapon = "Glock-17"
		end
		
		local ak = require(SkinModules:WaitForChild("Glock-17"))
		if ak.validSkin(skin) then
			
			for i, v in pairs(inv.Glock.Inventory) do --check to see if has skin
				if skin == v then
					--print("Skin already in inventory!")
					return false end
			end

			table.insert(inv.Glock.Inventory, 1, skin)

			local sv = Instance.new("StringValue")
			sv.Name = "skin"
			sv.Value = skin
			sv.Parent = ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon)

			data:Set(inv)

			--print("Added Glock .. " .. skin .. " to " .. player.Name .. " 's inventory!")
			
		end
	elseif weapon == "Knife" then
		
		local knife = require(SkinModules:WaitForChild("Knife"))
		if knife.validSkin(skin, knifeSkin) then
			
			if not inv[skin] then
				print(inv[skin]) --doesnt have knife
			end
			
			for i, v in pairs(inv[skin].Inventory) do
				if skin == v then
					--print("Skin already in inventory!")
					return false end
			end

			local sv = Instance.new("StringValue")
			sv.Name = "skin"
			sv.Value = skin .. "_" .. knifeSkin
			sv.Parent = ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon)

			data:Set(inv)
			
			--print("Added Knife .. " .. skin .. " to " .. player.Name .. " 's inventory!")
		else
			warn(skin .. "  | " .. knifeSkin .. " is invalid! Skin module")
			return
		end
		
	else
		warn(weapon .. " is invalid! Skin module")
		return
	end
end

Skin.set = function(player, weapon, skin, knifeSkin)
	--print(weapon .. " " .. skin)
	local data, inv = Skin.get_inv(player)
	
	if weapon == "AK47" then
		
		local ak = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Skin"):WaitForChild("AK47"))
		if ak.validSkin(skin) then
			local e = skin
			inv.AK.Equipped = e
		end
		
		data:Set(inv)
		
		ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon):WaitForChild("equipped_skin").Value = skin
		
		--print("Set AK .. " .. skin .. " to " .. player.Name .. " 's inventory!")
		
	elseif weapon == "Glock-17" then
		
		local gun = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Skin"):WaitForChild("Glock-17"))
		if gun.validSkin(skin) then
			local e = skin
			inv.Glock.Equipped = e
		end

		data:Set(inv)

		ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon):WaitForChild("equipped_skin").Value = skin
		
		--print("Added Glock .. " .. skin .. " to " .. player.Name .. " 's inventory!")
		
	elseif weapon == "Knife" then
		
		local gun = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Skin"):WaitForChild("Knife"))
		--print(skin)
		--print(knifeSkin)
		local e = skin .. "_" .. knifeSkin
		inv.Knife.Equipped = e
		data:Set(inv)
		ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players"):WaitForChild(player.Name):WaitForChild("SkinInventory"):WaitForChild(weapon):WaitForChild("equipped_skin").Value = e

			--print("Added Knife .. " .. skin .. " to " .. player.Name .. " 's inventory!")
		
	else
		warn ("Invalid weapon type in Skin module script!")
	end
	
end

Skin.has = function(player, weapon, skin) --checks to see if player has skin
	local DataStore2 = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("DataStore2"))
	print(weapon)
	print(skin)

	local data = DataStore2("skin_inventory", player)
	local inv = data:Get(Skin.DefaultInventory)

	if weapon == "Glock-17" then weapon = "Glock" end
	if weapon == "AK47" then weapon = "AK" end
	
	for i, v in pairs(inv[weapon].Inventory) do
		if v == skin then return true end
	end

	return false
end

return Skin
