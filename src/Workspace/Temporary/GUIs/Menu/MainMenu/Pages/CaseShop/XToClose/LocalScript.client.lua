local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local module = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Menu"))
local menu = script.Parent.Parent.Parent.Parent
local button = script.Parent

button.MouseButton1Down:Connect(function()
	module.close_page(player, menu, "CaseShop")
	module.open_page(player, menu, "Shop")
end)

