local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local module = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Menu"))
local menu = script.Parent.Parent.Parent.Parent

script.Parent.MouseButton1Down:Connect(function()
	module.open_page(player, menu, "Play")
	module.close_page(player, menu, "Main")
end)