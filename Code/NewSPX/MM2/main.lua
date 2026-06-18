local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fznkb2zo/.TheCleaner/refs/heads/main/lib/libraly.lua"))()

local Window = redzlib:MakeWindow({
	Title = "SpecterX | Murder Mystery 2",
	SubTitle = "By Specter",
	SaveFolder = "testando | redz lib v5.lua"
})

Window:AddMinimizeButton({
	Button = { Image = "rbxassetid://94800455817009", BackgroundTransparency = 0 },
	Corner = { CornerRadius = UDim.new(0, 5) },
})

local Tab1 = Window:MakeTab({"Um", "cherry"})

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title or "Notificação",
			Text = text or "Mensagem aqui",
			Duration = duration or 5
		})
	end)
end

local function getPlayerWithTool(toolName)
	for _, plr in ipairs(Players:GetPlayers()) do
		local tool =
			(plr.Backpack and plr.Backpack:FindFirstChild(toolName)) or
			(plr.Character and plr.Character:FindFirstChild(toolName))

		if tool and tool:IsA("Tool") then
			return plr
		end
	end
	return nil
end

local function createESP(character, color)
	if not character then return end
	if character:FindFirstChild("RoleESP") then return end

	local esp = Instance.new("Highlight")
	esp.Name = "RoleESP"
	esp.FillColor = color
	esp.OutlineColor = color
	esp.FillTransparency = 0.5
	esp.OutlineTransparency = 0
	esp.Parent = character
end

local function removeESP(character)
	if not character then return end
	local esp = character:FindFirstChild("RoleESP")
	if esp then
		esp:Destroy()
	end
end

local function revealRole(toolName, roleName)
	local plr = getPlayerWithTool(toolName)

	if plr then
		notify("Sistema", roleName .. ": " .. plr.Name, 4)
	else
		notify("Sistema", roleName .. " não encontrado", 4)
	end
end

Tab1:AddButton({
	Name = "Revelar assassino",
	Callback = function()
		revealRole("Knife", "Murder")
	end
})

Tab1:AddButton({
	Name = "Revelar Xerife",
	Callback = function()
		revealRole("Gun", "Xerife")
	end
})

local Section = Tab1:AddSection("Sla", "rocket")

Tab1:AddToggle({
	Name = "Revelar assassino (ESP)",
	Default = false,
	Callback = function(state)
		local plr = getPlayerWithTool("Knife")
		if plr and plr.Character then
			if state then
				createESP(plr.Character, Color3.fromRGB(255, 0, 0))
			else
				removeESP(plr.Character)
			end
		end
	end
})

Tab1:AddToggle({
	Name = "Revelar Xerife (ESP)",
	Default = false,
	Callback = function(state)
		local plr = getPlayerWithTool("Gun")
		if plr and plr.Character then
			if state then
				createESP(plr.Character, Color3.fromRGB(0, 170, 255))
			else
				removeESP(plr.Character)
			end
		end
	end
})
