local case = script.Parent.Parent:WaitForChild("ItemName").Value .. " Case"
local key = script.Parent.Parent:WaitForChild("ItemName").Value .. " Key"

local player = game:GetService("Players").LocalPlayer
local Menu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Menu"))

script.Parent.MouseButton1Down:Connect(function()
	if script.Parent.Parent.Parent:FindFirstChild(key) then
		
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("OpenCaseRequest"):FireServer(case, key)
		wait(.3)
		Menu.reset_inventory(player, player.PlayerGui:WaitForChild("Menu"))
		Menu.update_inventory(player, player.PlayerGui:WaitForChild("Menu"))
		player.PlayerGui:WaitForChild("Menu"):WaitForChild("Pages"):WaitForChild("Inventory").Visible = false
		
		--local caseframe = script.Parent.Parent.Parent

		--local key = caseframe:FindFirstChild(key)
		--if key then key:Destroy() end
		--script.Parent.Parent:Destroy()
	end
end)

