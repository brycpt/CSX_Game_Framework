local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GuiRemotes = Remotes:WaitForChild("GUI")

local scoreBoard = script.Parent:WaitForChild("MF"):WaitForChild("ScoreBoard")
local images = scoreBoard:WaitForChild("Images")
local pThumbnail = images:WaitForChild("PlayerThumbnail")
local oPThumbnail = images:WaitForChild("OtherPlayerThumbnail")

local text = scoreBoard:WaitForChild("Text")
local playerScore = text:WaitForChild("PlayerScore")
local otherPlayerScore = text:WaitForChild("OtherPlayerScore")
local currentRound = text:WaitForChild("CurrentRound")
local timer = text:WaitForChild("Timer")

local player = Players.LocalPlayer
local userId = player.UserId

--Thumbnail Customization
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420

local playerThumbnail, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
pThumbnail.Image = playerThumbnail

local totalrounds =  tostring(ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Var"):WaitForChild("TotalRounds").Value)

playerScore.Text = "0"
otherPlayerScore.Text = "0"
currentRound.Text = "1/" .. totalrounds

local function getOtherPlayer(player)
	for i, v in pairs(Players:GetPlayers()) do
		if v ~= player then return v end
	end
	return false
end

print("work")

GuiRemotes:WaitForChild("OnAnimation").onClientEvent:Connect(function()
	wait(2)
	local ti = TweenInfo.new(2)
	
	local imageGoal = {}
	local textGoal = {}
	local boardGoal = {}
	
	textGoal.TextTransparency = 0
	
	imageGoal.ImageTransparency = 0
	imageGoal.BackgroundTransparency = .5
	
	boardGoal.BackgroundTransparency = .5
	
	for i, v in pairs(images:GetChildren()) do
		local t = TweenService:Create(v, ti, imageGoal)
		t:Play()
		
	end
	
	for i, v in pairs(text:GetChildren()) do
		local t = TweenService:Create(v, ti, textGoal)
		t:Play()
	end
	
	local t = TweenService:Create(scoreBoard, ti, boardGoal)
	t:Play()
	
end)

GuiRemotes:WaitForChild("Update_Scoreboard_Images").onClientEvent:Connect(function()
	local otherPlayer = getOtherPlayer(player)
	
	if otherPlayer then
		local otherPlayerUserID = otherPlayer.UserId
		local otherPlayerThumbnail, isReady = Players:GetUserThumbnailAsync(otherPlayerUserID, thumbType, thumbSize)
		oPThumbnail.Image = otherPlayerThumbnail
	end
	
	local playerThumbnail, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	pThumbnail.Image = playerThumbnail
	
end)

GuiRemotes:WaitForChild("Update_Score").onClientEvent:Connect(function(winner, score, curr)
	local text
	if player == winner then
		text = playerScore
	else
		text = otherPlayerScore
	end
	text.Text = tostring(score)
	currentRound.Text = tostring(curr) .. "/" .. totalrounds
end)

local function round(n)
	return math.ceil(n - .999)
end

ReplicatedStorage:WaitForChild("Cache"):WaitForChild("Var"):WaitForChild("TimerStatus").Changed:Connect(function(new)
	if new > 60 then
		
		local min = tostring(round(new/60))
		local sec = tostring(new - (min*60))
		
		if tonumber(sec) == 0 then
			sec = "00"
		elseif tonumber(sec) < 10 then
			sec = "0" .. sec
		end
		
		local t = min .. ": " .. sec
		timer.Text = t
		
	else
		timer.Text = tostring(new)
	end
end)