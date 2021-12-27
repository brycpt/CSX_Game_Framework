local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


local AK = {}

AK.valid_skins = {"Default", "RedPaint", "White", "Black", "BlueSeal", "Gold", "RedChip", "BlueLam"}

AK.validSkin = function(skin)
	for i, v in pairs(AK.valid_skins) do
		if skin == v then return true end
	end
	return false
end

function clearSa(gun)

	local mag = gun:WaitForChild("Magazine")
	local rifle = gun:WaitForChild("Rifle")
	local bolt = gun:WaitForChild("Bolt")

	local magSa = mag:FindFirstChild("SurfaceAppearance")
	local boltSa  = bolt:FindFirstChild("SurfaceAppearance")
	local rifleSa = rifle:FindFirstChild("SurfaceAppearance")

	if magSa then magSa:Destroy() end
	if boltSa then boltSa:Destroy() end
	if rifleSa then rifleSa:Destroy() end

end

function set_skin(skin, gun)
	--print(gun)
	--print(gun.Name)
	local mag = gun:WaitForChild("Magazine")
	local rifle = gun:WaitForChild("Rifle")
	local bolt = gun:WaitForChild("Bolt")
	local parts = {mag, rifle, bolt}
	
	clearSa(gun)
	if skin == "Default" then		
		mag.TextureID = "rbxassetid://3361236264"
		rifle.TextureID = "rbxassetid://3361236264"
		rifle.Material = Enum.Material.Wood
	elseif skin == "RedPaint" then
		table.remove(parts, 3)
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("RedPaint"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
		rifle.Material = Enum.Material.Glass
		rifle.Reflectance = .75
	elseif skin == "BlueSeal" then
		table.remove(parts, 3)
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("BlueSeal"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
		rifle.Material = Enum.Material.Metal
	elseif skin == "White" then
		mag.TextureID = "rbxassetid://3361234458"
		rifle.TextureID = "rbxassetid://3361234458"
		rifle.Material = Enum.Material.Metal
	elseif skin == "Black" then
		mag.TextureID = ""
		rifle.TextureID = "rbxassetid://2492896951"
		rifle.Material = Enum.Material.Wood
	elseif skin == "Gold" then
		table.remove(parts, 3)
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("Gold"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
		rifle.Material = Enum.Material.Metal
	elseif skin == "RedChip" then
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("RedChip"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
		rifle.Material = Enum.Material.Metal
	elseif skin == "BlueLam" then
		local bluelam = "rbxassetid://8132088162"
		for i, v in pairs(parts) do
			v.TextureID = bluelam
		end
		rifle.Material = Enum.Material.Wood
	elseif skin == "Ice" then
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("Ice"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
		rifle.Material = Enum.Material.Ice
	end
end

AK.set = function(skin, gun)
	--print(skin)
	--print(gun)
	if not AK.validSkin(skin) then
		warn("Invalid skin type setSkin")
		return end
	
	set_skin(skin, gun)
	
	return true
end

return AK
