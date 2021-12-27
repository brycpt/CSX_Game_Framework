local gun = script.Parent.Parent:WaitForChild("GunName")
local skin = script.Parent.Parent:WaitForChild("SkinName")
local knife = script.Parent.Parent:WaitForChild("KnifeName")

script.Parent.MouseButton1Down:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SetSkin"):FireServer(gun.Value, skin.Value, knife.Value)
	require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Menu")).close_menu(game:GetService("Players").LocalPlayer)
	print('worked')	
end)

