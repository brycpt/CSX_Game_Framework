local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

ReplicatedStorage:WaitForChild("Profiles"):WaitForChild(player.Name):WaitForChild("options"):WaitForChild("crosshair_scale").Changed:Connect(function(new)
	if new == "1" then
		script.Parent:WaitForChild("ImageLabel").Size = UDim2.new(0, 35, 0, 35)
	elseif new  == "2" then
		script.Parent:WaitForChild("ImageLabel").Size = UDim2.new(0, 50, 0, 50)
	elseif new  == "3" then
		script.Parent:WaitForChild("ImageLabel").Size = UDim2.new(0, 65, 0, 65)
	elseif new  == "4" then
		script.Parent:WaitForChild("ImageLabel").Size = UDim2.new(0, 80, 0, 80)
	end
end)