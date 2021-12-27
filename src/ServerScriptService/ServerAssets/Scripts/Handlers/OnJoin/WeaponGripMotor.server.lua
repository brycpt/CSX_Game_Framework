--creates weapon grip motor on join

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(c)
		local hrp = c:FindFirstChild("HumanoidRootPart")
		if hrp then
			local motor = Instance.new("Motor6D")
			motor.Name = "WeaponGrip"
			motor.Parent = hrp
			motor.Part0 = hrp
		end
	end)
end)