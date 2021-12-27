game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		
		local weapon, ui = require(game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Classes"):WaitForChild("C_Weapon")).add(player, "AK47")
		weapon.Enabled = true
		
		local a, b = require(game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Classes"):WaitForChild("C_Weapon")).add(player, "Glock-17")
		a.Enabled = true
		
	end)
end)