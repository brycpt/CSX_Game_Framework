local module = {}

module.valid_skins = {
	"Default_Default",
	"Default_BlueIce",
	
	"Karambit_Default",
	"Karambit_BlueIce",
}

function module.valid_skin(knifeName, skin)
	
	local s = knifeName .. "_" .. skin
	for i, v in pairs(module.valid_skins) do
		if v == s then
			return true
		else
			warn("Invalid knife skin " .. knifeName .. skin)
			return false	
		end
			
	end
	
end

local function get_parts(knife)
	local pt = {}
	
	for i, v in pairs(knife:WaitForChild("GunComponents"):WaitForChild("WeaponHandle"):GetChildren()) do
		table.insert(pt, 1, v)
	end
	
	for i, v in pairs(knife:WaitForChild("Blade"):GetChildren()) do
		table.insert(pt, 1, v)
	end
	
	return pt
end

function clearSa(knife)

	local parts = get_parts(knife)

	for i, v in pairs(parts) do
		local sa = v:FindFirstChild("SurfaceAppearance")
		if sa then sa:Destroy() end
	end

end

local function skin_defaultDefault(parts)
	for i, v in pairs(parts) do
		if v.Parent.Name == "Blade" and v:IsA("MeshPart") then
			if not v:IsA("BasePart") then
				v.TextureID = "rbxassetid://8094513209"
			end
		elseif v.Parent.Name == "WeaponHandle" and v:IsA("MeshPart") then
			v.TextureID = "rbxassetid://8094494523"
		end
	end
end

local function skin_defaultBlueIce(parts)
	for i, v in pairs(parts) do
		if v.Parent.Name == "Blade" then
			if v:IsA("MeshPart") then
				local sa = script:WaitForChild("Karambit_Default"):WaitForChild("Blade"):Clone()
				sa.Name = "BlueIce"
				sa.Parent = v
			end
		elseif v.Parent.Name == "WeaponHandle" then
			if v:IsA("MeshPart") then
				local sa = script:WaitForChild("Karambit_Default"):WaitForChild("Handle"):Clone()
				sa.Name = "BlueIce"
				sa.Parent = v
			end
		end
	end
end

local function skin_karambitDefault(parts)
	for i, v in pairs(parts) do
		if v.Parent.Name == "Blade" then
			if not v:IsA("BasePart") and not v:FindFirstChild("Default") then
				local sa = script:WaitForChild("Karambit_Default"):WaitForChild("Blade"):Clone()
				sa.Name = "Default"
				sa.Parent = v
			end
		elseif v.Parent.Name == "WeaponHandle" then
			if not v:IsA("BasePart") and not v:FindFirstChild("Default") then
				local sa = script:WaitForChild("Karambit_Default"):WaitForChild("Handle"):Clone()
				sa.Name = "Default"
				sa.Parent = v
			end
		end
	end
end

local function skin_karambitBlueIce(parts)
	
	for i, v in pairs(parts) do
		print(v)
		if v.Parent.Name == "WeaponHandle" then
			if not v:IsA("BasePart") and not v:FindFirstChild("Default") then
				local sa = script:WaitForChild("Karambit_Default"):WaitForChild("Handle"):Clone()
				sa.Name = "SurfaceAppearance"
				sa.Parent = v
			end
		elseif v.Parent.Name == "Blade" then
			local sa = script:WaitForChild("Karambit_BlueIce"):WaitForChild("BlueMarble"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v
			
			local part = script:WaitForChild("Karambit_BlueIce"):WaitForChild("BladePart"):Clone()
			part.Position = v.Position
			part.Parent = v.Parent
			
			local weld = Instance.new("Motor6D")
			weld.Parent = v
			weld.Part0 = v
			weld.Part1 = v.Parent:WaitForChild("BladePart")
		end
	end
	
end

local function skin_karambitGreenIce(parts)

	for i, v in pairs(parts) do
		print(v)
		if v.Parent.Name == "WeaponHandle" then
			if not v:IsA("BasePart") and not v:FindFirstChild("Default") then
				local sa = script:WaitForChild("Karambit_Default"):WaitForChild("Handle"):Clone()
				sa.Name = "SurfaceAppearance"
				sa.Parent = v
			end
		elseif v.Parent.Name == "Blade" then
			local sa = script:WaitForChild("Karambit_GreenIce"):WaitForChild("BlueMarble"):Clone()
			sa.Name = "SurfaceAppearance"
			sa.Parent = v

			local part = script:WaitForChild("Karambit_GreenIce"):WaitForChild("BladePart"):Clone()
			part.Position = v.Position
			part.Parent = v.Parent

			local weld = Instance.new("Motor6D")
			weld.Parent = v
			weld.Part0 = v
			weld.Part1 = v.Parent:WaitForChild("BladePart")
		end
	end

end

function set_skin(knifeName, skin, knife)

	local parts = get_parts(knife)

	clearSa(knife)
	
	if knifeName == "Default" then
		
		if skin == "Default" then
			skin_defaultDefault(parts)
		elseif skin == "BlueIce" then
			skin_defaultBlueIce(parts)
		end
 		
	elseif knifeName == "Karambit" then
		
		if skin == "Default" then
			skin_karambitDefault(parts)
		elseif skin == "BlueIce" then
			skin_karambitBlueIce(parts)
		elseif skin == "GreenIce" then
			skin_karambitGreenIce(parts)
		end
		
	end

end


module.set = function(knifeName, skin, knife)
	set_skin(knifeName, skin, knife)
end

return module
