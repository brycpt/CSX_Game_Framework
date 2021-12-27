--services & variables
local TweenService = game:GetService("TweenService")
local Settings = require(script.Parent:WaitForChild("Settings"))
local image = script.Parent:WaitForChild("ImageLabel")

--prepare image for animation
image.ImageTransparency = 1

--goals
local in_goal = {}
in_goal.ImageTransparency = 0

local out_goal = {}
out_goal.ImageTransparency = 1

--infos
local in_info = TweenInfo.new(Settings.FADE_IN_LENGTH, Enum.EasingStyle.Exponential)
local out_info = TweenInfo.new(Settings.FADE_OUT_LENGTH)

--tweens
local In = TweenService:Create(image, in_info, in_goal)
local Out = TweenService:Create(image, out_info, out_goal)

--animation
In:Play()
wait(Settings.DISPLAY_TIME)
Out:Play()

--destroy when finished
Out.Completed:Wait()
script.Parent:Destroy()