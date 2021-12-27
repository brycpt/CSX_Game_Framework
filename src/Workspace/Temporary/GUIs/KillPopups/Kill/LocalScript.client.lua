local ts = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:FindFirstChild("Humanoid")
local text = script.Parent:WaitForChild('TextLabel')
local player_cache = ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Players")

local headshotTag
local weaponTag

if hum then
	headshotTag = hum:FindFirstChild("headshot_tag")
	weaponTag = hum:FindFirstChild("shooter_weapon_tag")
end

--Functions

local function NiceShot()
	
	local text = script.Parent:WaitForChild("TextLabel"):Clone()
	text.TextTransparency = 0
	text.Text = "Nice Shot!"
	text.Parent = script.Parent
	
	local ti = TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local goal1 = {}
	goal1.Position = UDim2.new(.525, 0, .525, 0)

	local tween = ts:Create(text, ti, goal1)

	return tween
end

local function Headshot()

	local text = script.Parent:WaitForChild("TextLabel"):Clone()
	text.TextTransparency = 0
	text.Text = "Headshot"
	text.Parent = script.Parent

	local ti = TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local goal1 = {}
	goal1.Position = UDim2.new(.525, 0, .525, 0)

	local tween = ts:Create(text, ti, goal1)

	return tween
end

--Stats Check

local gunstats = player_cache:WaitForChild(player.Name):FindFirstChild("Stats")

if not gunstats then
	warn("No gun stats folder in rep player cache!")	
	return
end

local roundstats = gunstats:FindFirstChild("Round")

if not roundstats then
	warn("No round stats folder in rep player cache!")	
	return
end

local totalshots = roundstats:FindFirstChild("TotalShots")

if totalshots and totalshots < 3 and headshotTag and headshotTag.Value then
	local tsTween = NiceShot()
	tsTween:Play()
	Headshot()
elseif totalshots and totalshots < 3 then
	NiceShot()
elseif headshotTag and headshotTag.Value then
	Headshot()
end

--[[

]]