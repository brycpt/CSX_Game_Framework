script.Parent.Humanoid.HealthChanged:Connect(function(health)
	if health <= 0 then
		wait(.05)
		script.Parent.Humanoid.Health = 100
		print('respawned debug bot')
	end
end)