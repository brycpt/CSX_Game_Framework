--updates ammo text and color

--wait(1) --give the gun time to load

local Players = game:GetService("Players")

--var
local player
local player_ammo
local tool
local gun_name
local frame
local current_ammo
local total_ammo
local current_ammo_text
local total_ammo_text

--start
local function init()
	player = Players.LocalPlayer
	
	gun_name = string.gsub(script.Parent.Name, "Display", "")
	
	tool = player.Backpack:FindFirstChild(gun_name)
	if not tool then
		tool = player.Character:WaitForChild(gun_name)
	end
	
	player_ammo = tool:WaitForChild("Ammo")
	current_ammo = player_ammo:WaitForChild("Magazine")
	total_ammo = player_ammo:WaitForChild("TotalAmmo")
	
	--verify and update ammo text upon initiate
	frame = script.Parent:WaitForChild("Frame")
	current_ammo_text = frame:WaitForChild("CurrentAmmo")
	current_ammo_text.Text = tostring(current_ammo.Value)
	total_ammo_text = frame:WaitForChild("TotalAmmo")
	total_ammo_text.Text = total_ammo.Value
end

init()

--heartbeat
game:GetService("RunService").RenderStepped:Connect(function()
	current_ammo_text.Text = tostring(current_ammo.Value)
	total_ammo_text.Text = tostring(total_ammo.Value)
end)

--color updaters
current_ammo_text:GetPropertyChangedSignal("Text"):Connect(function()
	if tonumber(current_ammo_text.Text) < 7 then
		current_ammo_text.TextColor3 = Color3.new(1, 0, 0)
	else
		current_ammo_text.TextColor3 = Color3.new(0, 0, 0)
	end
end)

total_ammo_text:GetPropertyChangedSignal("Text"):Connect(function()
	if tonumber(total_ammo_text.Text) <= 30 then
		total_ammo_text.TextColor3 = Color3.new(1, 0, 0)
	else
		total_ammo_text.TextColor3 = Color3.new(0, 0, 0)
	end
end)