--creates viewmodel on character join

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local vm = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Viewmodels"):WaitForChild("viewModel"):Clone()
		vm.Parent = player.Backpack	
	end)
end)