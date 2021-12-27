local name = script.Parent:WaitForChild("Name")
local raritytext = script.Parent:WaitForChild("RarityText")
local gun = script.Parent:WaitForChild("GunName")
local skin = script.Parent:WaitForChild("SkinName")
local rarity = script.Parent:WaitForChild("Rarity")

local menu = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Menu")

local ts = game:GetService("TweenService")
local ti = TweenInfo.new(1)
local goal = {}
goal.ImageTransparency = 0

if not menu then return end

local tween = ts:Create(script.Parent:WaitForChild("Image"), ti, goal)
menu:WaitForChild("Pages"):WaitForChild("Inventory").Visible = false

wait(1)
name.Text = ".."
wait(1)
name.Text = "."
wait(1)

raritytext.Text = rarity.Value
name.Text = gun.Value  .. " | " .. skin.Value

if rarity.Value == "Special" then
	name.TextColor3 = Color3.new(1, 1, 0)
	raritytext.TextColor3 = Color3.new(1, 0.776471, 0.203922)
elseif rarity.Value == "Rare" then
	name.TextColor3 = Color3.new(1, 0, 0.498039)
	raritytext.TextColor3 = Color3.new(1, 0.333333, 0.498039)
elseif rarity.Value == "Uncommon" then
	name.TextColor3 = Color3.new(0, 0.333333, 1)
	raritytext.TextColor3 = Color3.new(0, 0, 1)
end

tween:Play()

script.Parent:WaitForChild("XToClose").MouseButton1Down:Connect(function()
	menu:WaitForChild("Pages"):WaitForChild("Inventory").Visible = true
	script.Parent:Destroy()
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.M or input.KeyCode == Enum.KeyCode.Escape then
		menu:WaitForChild("Pages"):WaitForChild("Inventory").Visible = true
		script.Parent:Destroy()
	end
end)