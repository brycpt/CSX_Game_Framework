--Made by EPIXPLODE

--[[ Pattern table index: 
{[1], [2], [3], [4], [5], [6], [7]}

[1] = bullet number
[2] = vector recoil up amount
[3] = vector recoil right amount
[4] = camera recoil up amount
[5] = camera recoil right amount
[6] = camera recoil down amount
[7] = camera recoil left amount (for the down part of the recoil)
[8] = camera recoil up lerp speed
[9] = camera recoil down lerp speed

]]

local TweenService = game:GetService("TweenService")
local Run = game:GetService("RunService")

local CF, CFANG = CFrame.new, CFrame.Angles

local selected = true
local player = game:GetService("Players").LocalPlayer
local curshots = 0
local lastclick = tick()

--SETTINGS
local recoil_reset = 0.22
local dcU = .15 --default cam up
local dcR = .01 --default cam right
local dcD = .17 --default cam down
local dcL = 0 --default cam left
local dU = .77
local dD = .7

local recoil_y_multiplier = 1 --how strong recoil pattern is
local recoil_x_multiplier = 1

--MODULE
local vecpattern = {
	{1, 0, 0, dcU, dcR, dcU, dcR, dU, dD},
	{2, .75, 0, dcU, dcR, dcU, dcR, dU, dD},
	{3, 1.5, 0, dcU, dcR, .16, dcR, dU, dD},
	{4, 2.25, .75, dcU, dcR, dcD, dcR, dU, dD},
	{5, 3, 1.5, dcU, dcR, dcD, dcR, dU, dD},
	{6, 4, 2.25, dcU, dcR, dcD, dcR, dU, dD},
	{7, 5, 3, dcU, dcR, dcD, dcR, dU, dD},
	{8, 6, 4, dcU, dcR, dcD, dcR, dU, dD},
	{9, 7, 4.5, dcU, dcR, dcD, dcR, dU, dD},
	{10, 7.5, 4.5, dcU, dcR, dcD, dcR, dU, dD},
	{11, 7.5, 4, dcU, dcR, dcD, dcR, dU, dD},
	{12, 7, 3, dcU, dcR, dcD, dcR, dU, dD},
	{13, 8, 2.25, dcU, dcR, dcD, dcR, dU, dD},
	{14, 7, 1.5, dcU, dcR, dcD, dcR, dU, dD},
	{15, 7, .75, dcU, dcR, dcD, dcR, dU, dD},
	{16, 7, 0, dcU, dcR, dcD, dcR, dU, dD},
	{17, 6, -1, dcU, dcR, dcD, dcR, dU, dD},
	{18, 5, -1.5, dcU, dcR, dcD, dcR, dU, dD},
	{19, 4, -3, dcU, dcR, dcD, dcR, dU, dD},
	{20, 4, -3, dcU, dcR, dcD, dcR, dU, dD},
	{21, 4, -3, dcU, dcR, dcD, dcR, dU, dD},
	{22, 5, -2, dcU, dcR, dcD, dcR, dU, dD},
	{23, 6, 0, dcU, dcR, dcD, dcR, dU, dD},
	{24, 7, 0, dcU, dcR, dcD, dcR, dU, dD},
	{25, 8, 0, dcU, dcR, dcD, dcR, dU, dD}
}

local Recoil = {}

local function rot(RotX, RotY, SmoothRot, Duration, Camera)--** DISCLAIMER: THIS IS NOT MADE BY ME, FOUND ON DEVFORUMS
	spawn(function()
		if SmoothRot then
			local TweenIndicator = nil
			local NewCode = math.random(-1e9, 1e9)
			if (not Camera:FindFirstChild("TweenCode")) then
				TweenIndicator = Instance.new("IntValue")
				TweenIndicator.Name = "TweenCode"
				TweenIndicator.Value = NewCode
				TweenIndicator.Parent = Camera
			else
				TweenIndicator = Camera.TweenCode
				TweenIndicator.Value = NewCode
			end
			local Step = math.min(1.5 / math.max(Duration, 0), 90)
			local X = 0
			while true do
				local NewX = X + Step
				X = (NewX > 90 and 90 or NewX)
				if TweenIndicator.Value ~= NewCode then break end
				if (not selected) then break end

				local CamRot = Camera.CoordinateFrame - Camera.CoordinateFrame.p
				local CamDist = (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude
				local NewCamCF = CF(Camera.Focus.p) * CamRot * CFANG(RotX / (90 / Step), RotY / (90 / Step), 0)
				Camera.CoordinateFrame = CF(NewCamCF.p, NewCamCF.p + NewCamCF.lookVector) * CF(0, 0, CamDist)

				if X == 90 then break end
				Run.RenderStepped:wait()
			end

			if TweenIndicator.Value == NewCode then
				TweenIndicator:Destroy()
			end
		else
			local CamRot = Camera.CoordinateFrame - Camera.CoordinateFrame.p
			local CamDist = (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude
			local NewCamCF = CF(Camera.Focus.p) * CamRot * CFANG(RotX, RotY, 0)
			Camera.CoordinateFrame = CF(NewCamCF.p, NewCamCF.p + NewCamCF.lookVector) * CF(0, 0, CamDist)
		end
	end)
end

local function calculate_camera(Camera, X, Y, dX, dY, upSpeed, downSpeed) -- camera based recoil
	
	local dX = -(X - .05)
	
	local rot = coroutine.create(function()
		rot(X, Y, true, upSpeed, Camera)
		wait(upSpeed)
		rot(-X, -Y, true, downSpeed, Camera)
	end)
	coroutine.resume(rot)
	
end

--calculates new bullet position based on recoil
local function calculate_vector2(X, Y, u, r)
	
	local player = game:GetService("Players").LocalPlayer
	local mult = 5 --global recoil multiplier
	--calculate new vector based on given X, Y and up, right variables
	local newx = (-r*mult) + X
	local newy = (-u*mult) + Y
	local new = Vector2.new(newx, newy)
	
	return new
end


--fire both recoils
Recoil.recoil_bullet = function(targetX, targetY, Camera)
	-- decide if reset or increase current recoil
	curshots = (tick() - lastclick >= recoil_reset and 1 or curshots + 1) 
	lastclick = tick()
	
	local new
	for i, v in pairs(vecpattern) do
		-- find the current recoil we're at	
		if curshots <= v[1] then 	
			print(v[1])
			
			--grab variables from vector recoil table
			local upAmount = v[2] * recoil_y_multiplier
			local rightAmount = v[3] * recoil_x_multiplier
			local camUp = .1 * v[4]
			local camRight = .1 * v[5]
			local camDown = .1 * v[6]
			local camLeft = .1 * v[7]
			local upSpeed = .1 * v[8]
			local downSpeed = .1 * v[9]
			
			--calculate new bullet location
			new = calculate_vector2(targetX, targetY, upAmount, rightAmount) --vector recoil
			
			--delay calculation of camera recoil so the bullet has time to fire
			task.delay(.05, function()
				calculate_camera(Camera, camUp, camRight, camDown, camLeft, upSpeed, downSpeed)
			end)
			
			break
		end
	end
	--print(new)
	return new
end

return Recoil
