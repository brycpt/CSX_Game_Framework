local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local player_profile = game:GetService("ReplicatedStorage"):WaitForChild("Cache"):WaitForChild("Profiles"):WaitForChild(player.Name)
local profile_page = script.Parent:WaitForChild("Pages"):WaitForChild("Main"):WaitForChild("Profile")

local rank = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Rank"))
local Settings = require(workspace:WaitForChild("Settings"))

profile_page:WaitForChild("PlayerName").Text = player.Name

if not Settings.lobby or Settings.Lobby then
	--Do game menu stuff
end

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Menu"):WaitForChild("UpdateCoins").OnClientEvent:Connect(function(c)
	profile_page:WaitForChild("Coins").Text = tostring(c) .. " strafecoins"
end)

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Menu"):WaitForChild("UpdateRank").OnClientEvent:Connect(function(rank, elo, rank_imageID)
	profile_page:WaitForChild("RankImage").Image = rank_imageID
	profile_page:WaitForChild("Rank").Text = rank
	profile_page:WaitForChild("Elo").Text = elo
	
	if rank == "Silver" then
		profile_page:WaitForChild("Elo").TextColor3 = Color3.new(0.713725, 0.713725, 0.713725)
	elseif rank == "Gold" then
		profile_page:WaitForChild("Elo").TextColor3 = Color3.new(0.596078, 0.517647, 0.0784314)
	elseif rank == "Platinum" then
		profile_page:WaitForChild("Elo").TextColor3 = Color3.new(0.180392, 0.494118, 0.658824)
	elseif rank == "Diamond" then
		profile_page:WaitForChild("Elo").TextColor3 = Color3.new(0.65098, 0.435294, 0.65098)
	elseif rank == "League" then
		profile_page:WaitForChild("Elo").TextColor3 = Color3.new(0.333333, 0.333333, 0.498039)
	end
	
end)



player_profile:WaitForChild("PlayerStats"):WaitForChild("Elo").Changed:Connect(function(new)

	local rank_string = rank.get_rank(new)
	local rank_image = rank.get_rank_image(rank_string)

	profile_page:WaitForChild("Elo").Text = tostring(new)
	profile_page:WaitForChild("Rank").Text = rank_string
	profile_page:WaitForChild("RankImage").Image = rank_image

end)