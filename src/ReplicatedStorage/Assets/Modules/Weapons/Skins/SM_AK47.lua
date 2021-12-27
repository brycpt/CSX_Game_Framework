--AK47 Skins Module Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

module.VALIDSKINS = {"Default", "White", "Black"}

function module.find_skin(skin) --returns the skinned weapon model
	
	--validate skin model
	for i, v in pairs(module.VALIDSKINS) do

		if v == skin then
			
			local gun = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Weapons"):WaitForChild("AK47"):Clone()

			local skin_function = module[skin]
			if skin_function then
				return skin_function(gun)
			end
		end
	end

	return false
end

function module.Default(gun)
	
	gun:WaitForChild("Magazine").TextureID = "rbxassetid://3361236264"
	gun:WaitForChild("Rifle").TextureID = "rbxassetid://3361236264"
	gun:WaitForChild("Rifle").Material = Enum.Material.Wood
	
	return gun
end

function module.White(gun)
	
	gun:WaitForChild("Magazine").TextureID = "rbxassetid://3361234458"
	gun:WaitForChild("Rifle").TextureID = "rbxassetid://3361234458"
	gun:WaitForChild("Rifle").Material = Enum.Material.Metal
	
end

function module.Black(gun)
	
	gun:WaitForChild("Magazine").TextureID = ""
	gun:WaitForChild("Rifle").TextureID = "rbxassetid://2492896951"
	gun:WaitForChild("Rifle").Material = Enum.Material.Wood
	
end

return module
