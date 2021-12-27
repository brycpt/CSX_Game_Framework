--Glock-17 Skins Module Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

module.VALIDSKINS = {"Default"}

function module.find_skin(skin) --returns the skinned weapon model

	--validate skin model
	for i, v in pairs(module.VALIDSKINS) do

		if v == skin then

			local gun = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Weapons"):WaitForChild("Glock-17"):Clone()

			local skin_function = module[skin]
			if skin_function then
				return skin_function(gun)
			end
		end
	end

	return false
end

function module.Default(gun)

	gun:WaitForChild("Magazine").TextureID = "http://www.roblox.com/asset/?id=7001038127"
	gun:WaitForChild("Body").TextureID = "rbxassetid://8132945278"
	gun:WaitForChild("Bolt").TextureID = "http://www.roblox.com/asset/?id=7001042771"
	gun:WaitForChild("Body").Material = Enum.Material.SmoothPlastic
	gun:WaitForChild("Magazine").Material = Enum.Material.Metal
	

	return gun
end

return module
