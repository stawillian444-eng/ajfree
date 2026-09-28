--// EXEC AJ
--// Narrower Compact Toggle Mode with Position & Script Saver

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local SCRIPT_FILE = "ExecAJ_SavedScript.txt"
local POSITION_FILE = "ExecAJ_Position.txt"

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "ExecAJ"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(250, 95) -- Narrower width (250px)
main.Position = UDim2.new(0.5, -125, 0.5, -47)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 80)
stroke.Thickness = 1
stroke.Parent = main

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(10, 7)
title.Size = UDim2.fromOffset(160, 20)
title.Text = "EXEC AJ — @rymogs"
title.TextColor3 = Color3.fromRGB(235, 235, 240)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(10, 26)
status.Size = UDim2.fromOffset(160, 15)
status.Text = "AUTO JOIN  ·  STANDBY"
status.TextColor3 = Color3.fromRGB(145, 145, 150)
status.Font = Enum.Font.Gotham
status.TextSize = 9
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

--==================================================
-- TOGGLE EDITOR BUTTON (</>)
--==================================================

local toggleButton = Instance.new("TextButton")
toggleButton.Position = UDim2.new(1, -35, 0, 7)
toggleButton.Size = UDim2.fromOffset(28, 22)
toggleButton.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "</>"
toggleButton.TextColor3 = Color3.fromRGB(190, 190, 200)
toggleButton.Font = Enum.Font.Code
toggleButton.TextSize = 11
toggleButton.AutoButtonColor = false
toggleButton.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton

--==================================================
-- SCRIPT EDITOR
--==================================================

local scriptBox = Instance.new("TextBox")
scriptBox.Position = UDim2.fromOffset(10, 47)
scriptBox.Size = UDim2.new(1, -20, 0, 130)
scriptBox.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
scriptBox.BorderSizePixel = 0
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true
scriptBox.TextWrapped = true
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.Text = ""
scriptBox.PlaceholderText = "PUT SCRIPT HERE..."
scriptBox.PlaceholderColor3 = Color3.fromRGB(105, 105, 115)
scriptBox.TextColor3 = Color3.fromRGB(220, 220, 225)
scriptBox.TextSize = 12
scriptBox.Font = Enum.Font.Code
scriptBox.Visible = false
scriptBox.Parent = main

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 7)
boxCorner.Parent = scriptBox

--==================================================
-- ACTIVATE
--==================================================

local activate = Instance.new("TextButton")
activate.Position = UDim2.fromOffset(10, 47)
activate.Size = UDim2.new(1, -20, 0, 38)
activate.BackgroundColor3 = Color3.fromRGB(235, 235, 242)
activate.BorderSizePixel = 0
activate.Text = "ACTIVATE"
activate.TextColor3 = Color3.fromRGB(20, 20, 23)
activate.Font = Enum.Font.GothamBold
activate.TextSize = 13
activate.AutoButtonColor = false
activate.Parent = main

local activateCorner = Instance.new("UICorner")
activateCorner.CornerRadius = UDim.new(0, 8)
activateCorner.Parent = activate

--==================================================
-- SAVE & LOAD SCRIPT
--==================================================

local function SaveScript()
	if type(writefile) ~= "function" then return end
	pcall(function() writefile(SCRIPT_FILE, scriptBox.Text) end)
end

task.spawn(function()
	if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
	local exists = false
	pcall(function() exists = isfile(SCRIPT_FILE) end)
	if exists then
		local success, saved = pcall(function() return readfile(SCRIPT_FILE) end)
		if success and type(saved) == "string" then
			scriptBox.Text = saved
			status.Text = "AUTO JOIN  ·  LOADED"
			task.wait(1.5)
			status.Text = "AUTO JOIN  ·  STANDBY"
		end
	end
end)

scriptBox.FocusLost:Connect(function()
	SaveScript()
end)

--==================================================
-- SAVE & LOAD POSITION
--==================================================

local function SavePosition()
	if type(writefile) ~= "function" then return end
	local pos = main.Position
	local data = tostring(pos.X.Scale)..","..tostring(pos.X.Offset)..","..tostring(pos.Y.Scale)..","..tostring(pos.Y.Offset)
	pcall(function() writefile(POSITION_FILE, data) end)
end

task.spawn(function()
	if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
	local exists = false
	pcall(function() exists = isfile(POSITION_FILE) end)
	if not exists then return end
	local success, data = pcall(function() return readfile(POSITION_FILE) end)
	if not success then return end
	local xScale, xOffset, yScale, yOffset = data:match("([^,]+),([^,]+),([^,]+),([^,]+)")
	if xScale and xOffset and yScale and yOffset then
		main.Position = UDim2.new(tonumber(xScale), tonumber(xOffset), tonumber(yScale), tonumber(yOffset))
	end
end)

--==================================================
-- TOGGLE EXPAND / COLLAPSE
--==================================================

local expanded = false

toggleButton.MouseButton1Click:Connect(function()
	expanded = not expanded

	if expanded then
		scriptBox.Visible = true
		main.Size = UDim2.fromOffset(250, 250)
		activate.Position = UDim2.fromOffset(10, 187)
		activate.Size = UDim2.new(1, -20, 0, 48)
	else
		scriptBox.Visible = false
		main.Size = UDim2.fromOffset(250, 95)
		activate.Position = UDim2.fromOffset(10, 47)
		activate.Size = UDim2.new(1, -20, 0, 38)
	end
end)

--==================================================
-- EXECUTE SCRIPT
--==================================================

activate.MouseButton1Click:Connect(function()
	local code = scriptBox.Text
	if code == "" then
		status.Text = "AUTO JOIN  ·  EMPTY"
		return
	end

	SaveScript()
	status.Text = "AUTO JOIN  ·  EXECUTING"

	if type(loadstring) ~= "function" then
		status.Text = "AUTO JOIN  ·  NO LOADSTRING"
		warn("This environment does not support loadstring.")
		return
	end

	local success, err = pcall(function() loadstring(code)() end)
	if success then
		status.Text = "AUTO JOIN  ·  EXECUTED"
	else
		status.Text = "AUTO JOIN  ·  ERROR"
		warn(err)
	end

	task.wait(2)
	status.Text = "AUTO JOIN  ·  STANDBY"
end)

--==================================================
-- HOVER & DRAGGING
--==================================================

activate.MouseEnter:Connect(function()
	activate.BackgroundColor3 = Color3.fromRGB(215, 215, 222)
end)

activate.MouseLeave:Connect(function()
	activate.BackgroundColor3 = Color3.fromRGB(235, 235, 242)
end)

local dragging = false
local dragStart
local startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
		SavePosition()
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)