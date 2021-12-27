local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Glock = {}

Glock.valid_skins = {"Default", "RedPaint", "Gold", "BlueSeal", "Lava", "GoldLink", "BlueMarble"}
function Glock.validSkin(skin)
	for i, v in pairs(Glock.valid_skins) do
		if skin == v then return true end
	end
	return false
end

local blackbody = "http://www.roblox.com/asset/?id=7001040481"

function clearSa(gun)
	
	local mag = gun:WaitForChild("magazine")
	local body = gun:WaitForChild("body")
	local bolt = gun:WaitForChild("bolt")
	local parts = {mag, body, bolt}
	
	for i, v in pairs(parts) do
		local sa = v:FindFirstChild("SurfaceAppearance")
		if sa then sa:Destroy() end
	end
	
end

function set_skin(skin, gun)
	
	local mag = gun:WaitForChild("magazine")
	local body = gun:WaitForChild("body")
	local bolt = gun:WaitForChild("bolt")
	local parts = {mag, body, bolt}
	
	clearSa(gun)
	if skin == "Default" then
		mag.TextureID = "http://www.roblox.com/asset/?id=7001038127"
		bolt.TextureID = "http://www.roblox.com/asset/?id=7001042771"
		body.TextureID = "rbxassetid://8132945278"
	elseif skin == "RedPaint" then
		local sa = script:WaitForChild("RedPaint"):Clone()
		sa.Name = "SurfaceAppearance"
		sa.Parent = bolt
		body.TextureID = "http://www.roblox.com/asset/?id=7001040481"
		bolt.Material = Enum.Material.Glass
		bolt.Reflectance = .75
	elseif skin == "BlueSeal" then
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("BlueSeal"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
	elseif skin == "Gold" then
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("Gold"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
	elseif skin == "Lava" then
		table.remove(parts, 2)
		for i, v in pairs(parts) do
			local sa = script:WaitForChild("Lava"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
		body.TextureID = blackbody
	elseif skin == "GoldLink" then
		local sa = script:WaitForChild("GoldLink"):Clone()
		sa.Name = "SurfaceAppearance"
		sa.Parent = bolt
		
		body.TextureID = blackbody
	elseif skin == "BlueMarble" then
		for i, v in  pairs(parts) do
			local sa = script:WaitForChild("BlueMarble"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
		end
	end
	
end


Glock.set = function(skin, gun)
	if Glock.validSkin(skin) then
		set_skin(skin, gun)
	else
		warn("Invalid skin for glock. " .. skin)
	end
end

return Glock
