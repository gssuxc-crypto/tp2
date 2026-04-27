local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local teleporting = false -- 🔒 флаг

-- 🔍 строгий поиск двери через FindFirstChild
local function getLastRoomDoor()
	local roomsFolder = workspace:WaitForChild("rooms")
	local rooms = roomsFolder:GetChildren()
	if #rooms == 0 then return nil end

	local lastRoom = rooms[#rooms]

	-- ❗ ИЩЕМ ТОЛЬКО ПРЯМОГО РЕБЁНКА комнаты
	local door = lastRoom:FindFirstChild("door")

	if door and door:IsA("BasePart") then
		return door
	end

	return nil
end
-- 🎮 нажатие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if teleporting then return end
	
	if input.KeyCode == Enum.KeyCode.Z then
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		
		local door = getLastRoomDoor()
		if not door then
			warn("Door not found!")
			return
		end

		teleporting = true
		hrp.Anchored = true

		-- ✅ корректный offset
		local offset = Vector3.new(0, 0, 2)
		local targetCFrame = door.CFrame + offset

		local tween = TweenService:Create(
			hrp,
			TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{CFrame = targetCFrame}
		)

		tween:Play()

		tween.Completed:Connect(function()
			hrp.Anchored = false
			teleporting = false
		end)
	end
end)
