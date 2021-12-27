local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer
local module = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Menu"))
local menu = script.parent.Parent

module.open_page(player, menu, "Options")
module.close_page(player, menu, "Main")