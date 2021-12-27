local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Menu"))
local queueing = false

script.Parent.MouseButton1Down:Connect(function()
	if not queueing then
		queueing = true

		local gui = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GUIs"):WaitForChild("Menu"):WaitForChild("Queuing"):Clone()
		gui.Name = "Queueing"
		gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

		ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Menu"):WaitForChild("Queue"):FireServer("Casual")
		
		script.Parent.Text = "LEAVE QUEUE"
		script.Parent.TextScaled = true
		script.Parent.BackgroundColor3 = Color3.new(0.666667, 0, 0)
	else
		queueing = false

		local gui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Queueing")
		if gui then gui:Destroy() end

		ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Menu"):WaitForChild("LeaveQueue"):FireServer("Casual")

		script.Parent.Text = "PLAY"
		script.Parent.TextScaled = false
		script.Parent.BackgroundColor3 = Color3.new(0, 1, 0)
	end
end)





