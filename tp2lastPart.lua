local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Получение HRP
local function getRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end

-- Проверка: есть ли anchored части в Character
local function hasAnchoredInCharacter()
	local char = player.Character
	if not char then return true end

	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Anchored == true then
			return true
		end
	end

	return false
end

-- Получение последней части в EntityTween
local function getLastPart()
	local folder = workspace:WaitForChild("EntityTween")
	local parts = {}

	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(parts, obj)
		end
	end

	if #parts == 0 then return nil end
	return parts[#parts]
end

-- Телепорт
local function teleport()
	-- ❗ блокировка если Character имеет Anchored части
	if hasAnchoredInCharacter() then
		return
	end

	local root = getRoot()
	if not root then return end

	local targetPart = getLastPart()
	if not targetPart then return end

	local forwardOffset = 2
	local offsetCFrame = targetPart.CFrame * CFrame.new(-forwardOffset, 0, 0)

	root.CFrame = offsetCFrame
end

-- Нажатие R
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.R then
		teleport()
	end
end)
