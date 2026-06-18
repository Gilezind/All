local webhook = loadstring(game:HttpGet("https://pastebin.com/raw/AJQaXHck"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Marketplace = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local backpack = player.Backpack

local camera = Workspace:WaitForChild("Camera")
local PlayerGui = player.PlayerGui


local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character and character:FindFirstChild("HumanoidRootPart")
local userId = player.UserId

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local RE = ReplicatedStorage:WaitForChild("RE")

local WHITELIST_URL = "https://raw.githubusercontent.com/DrakonDev/.TheCleaner/refs/heads/main/resources/whitelist.lua"

local function kick(msg)
    player:Kick(msg)
end

local success, config = pcall(function()
    return loadstring(game:HttpGet(WHITELIST_URL))()
end)

if not success or type(config) ~= "table" then
    kick("Erro ao carregar whitelist config")
    return
end

if config.blacklist and config.blacklist[userId] then
    kick("❌ Você está na blacklist.")
    return
end

if config.working == true then

    local allowed =
        (config.whitelistOwner and config.whitelistOwner[userId]) or
        (config.whitelistAdmin and config.whitelistAdmin[userId]) or
        (config.whitelist and config.whitelist[userId])

    if not allowed then
        kick("🚫 Você não está na whitelist.")
        return
    end
end

local function Notify(text, icon)
    StarterGui:SetCore("SendNotification", {
        Title = "Sistema",
        Text = text,
        Duration = 3,
        Icon = icon or nil,
    })
end

local function UpdateReferences(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	backpack = player:WaitForChild("Backpack")
end

player.CharacterAdded:Connect(function(char)
	UpdateReferences(char)
	local hum = char:WaitForChild("Humanoid")
	hum.Died:Connect(function()
		character = nil
		humanoid = nil
		hrp = nil
	end)
end)

local libraly = loadstring(game:HttpGet("https://raw.githubusercontent.com/SpecterV5Fuctions/SpecterFuctionsV5/refs/heads/main/SpecterLibraly_V5"))()
local keybind = loadstring(game:HttpGet("https://pastebin.com/raw/YrWitRNA"))()

local Window = libraly:MakeWindow({
    Title = "SpecterX | Brookhaven",
    SubTitle = "By Specter",
    SaveFolder = "specterx"
})

Window:AddMinimizeButton({	
    Button = { Image = "rbxassetid://94800455817009", BackgroundTransparency = 0 }, 
    Corner = { CornerRadius = UDim.new(0, 5) },
})

local Tab1 = Window:MakeTab({"Main", "rocket"})

Tab1:AddDiscordInvite({
     Name = "SpecterX",
     Description = "Entre no nosso Discord e acompanhe todas as atualizações do SpecterX.",
     Logo = "rbxassetid://94800455817009",
     Invite = "https://discord.gg/hdTw8KGb4Y",
})

Tab1:AddSection({"Informaçao"})

local Info = Tab1:AddParagraph({
    "Hey, " ..player.Name .. "!"
})

local Info = Tab1:AddParagraph({
    "Todas as atualizações estão no Discord."
})

local PlayerCount = Tab1:AddParagraph({
    Title = "Jogadores online:",
    Desc = tostring(#Players:GetPlayers())
})

task.spawn(function()
    while true do
        PlayerCount:SetDesc(tostring(#Players:GetPlayers()))
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        PlayerCount:SetText("Jogadores online: " .. tostring(#Players:GetPlayers()))
        task.wait(0.5)
    end
end)

Players.PlayerAdded:Connect(function()
    PlayerCount:SetText("Jogadores online: " .. tostring(#Players:GetPlayers()))
end)

Players.PlayerRemoving:Connect(function()
    PlayerCount:SetText("Jogadores online: " .. tostring(#Players:GetPlayers()))
end)


local executorName = "Executor desconhecido"

if identifyexecutor then
    local success, result = pcall(identifyexecutor)
    if success and result then
        executorName = result
    end
end

local Info = Tab1:AddParagraph({
    "Executor: " .. executorName
})

local Tab2 = Window:MakeTab({"Player", "user"})

Tab2:AddSection({"Speed"})

local speedActual = nil
local jumpActual = nil

Tab2:AddSlider({
  Name = "Speed",
  Min = 1,
  Max = 1000,
  Increase = 1,
  Default = 17,
  Callback = function(Value)
    speedActual = Value
  end
})

local Button = Tab2:AddButton({"Aplicar Velocidade",function()
    if not character then return end
    if not humanoid then return end

    humanoid.WalkSpeed = speedActual
end
})

Tab2:AddSection({"Jump"})

Tab2:AddSlider({
  Name = "Jump",
  Min = 1,
  Max = 1000,
  Increase = 1,
  Default = 50,
  Callback = function(Value)
    jumpActual = Value
  end
})

Tab2:AddButton({"Aplicar Pulo",function()
    if not character then return end
    if not humanoid then return end

    humanoid.JumpPower = jumpActual
end
})

Tab2:AddSection({"Player Information"})

local startTime = os.clock()

local playerTemp = Tab2:AddParagraph({
    Title = "Tempo de uso:",
    Desc = "00:00:00"
})

local playerFPS = Tab2:AddParagraph({
    Title = "FPS:",
    Desc = "Fps: 0"
})

task.spawn(function()
    while true do
        local elapsed = math.floor(os.clock() - startTime)

                local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60

        local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)

        playerTemp:SetDesc(formattedTime)
        task.wait(1)
    end
end)

task.spawn(function()
    local lastTime = os.clock()
    local frames = 0

    RunService.RenderStepped:Connect(function()
        frames += 1
        local currentTime = os.clock()

        if currentTime - lastTime >= 1 then
            local fps = math.floor(frames / (currentTime - lastTime))
            playerFPS:SetDesc("FPS: " .. fps)

            frames = 0
            lastTime = currentTime
        end
    end)
end)

Tab2:AddSection({"No Clip"})

local noclipConnection
local savedStates = {}

local function applyNoClip()
	if not player.Character then return end
	
	for _, part in ipairs(player.Character:GetDescendants()) do
		if part:IsA("BasePart") then
			if savedStates[part] == nil then
				savedStates[part] = part.CanCollide
			end
			part.CanCollide = false
		end
	end
end

local function restoreCollision()
	for part, state in pairs(savedStates) do
		if part and part.Parent then
			part.CanCollide = state
		end
	end
	savedStates = {}
end

local function startNoClip()
	if noclipConnection then return end
	
	noclipConnection = RunService.Stepped:Connect(function()
		applyNoClip()
	end)
end

local function stopNoClip()
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
	
	restoreCollision()
end

Tab2:AddToggle({
	Name = "NoClip",
	Default = false,
	Callback = function(state)
		if state then
			startNoClip()
		else
			stopNoClip()
		end
	end
})

Tab2:AddSection({"Invisibilidade"})

Tab2:AddButton({"Ativar Invisibilidade", function(Value)
    loadstring(game:HttpGet("https://pastebin.com/raw/gJEmRtab"))()
end})

Tab2:AddButton({"Voltar normal", function(Value)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ResetCharacterAppearance"):FireServer()
end})

local Tab3 = Window:MakeTab({"Teleport", "map"})

local function teleportTo(position)
	if hrp then
		hrp.CFrame = CFrame.new(position)
	end
end

local locations = {
	{"Praça", Vector3.new(7.12, 3.30, 34.65)},
	{"Banco", Vector3.new(2.44, 3.50, 255.11)},
	{"Piscina da praça", Vector3.new(13.74, 3.87, 133.32)},
	{"Escola", Vector3.new(-305.96, 3.60, 212.04)},
	{"Hospital", Vector3.new(-304.59, 3.48, 24.01)},
	{"Delegacia", Vector3.new(-118.83, 3.49, 7.80)},
	{"Hotel", Vector3.new(249.18, 3.60, 215.39)},
	{"Lanchonete", Vector3.new(166.70, 4.50, 35.89)},
	{"Shopping", Vector3.new(161.21, 3.60, -168.92)},
	{"Creche", Vector3.new(-126.75, 3.60, 131.53)},
	{"Apartamento 1", Vector3.new(-42.31, 3.50, -121.11)},
	{"Apartamento 2", Vector3.new(-36.51, 19.00, -127.52)},
	{"Apartamento VIP", Vector3.new(-34.78, 35.00, -134.67)},
	{"Fliperama Arcade", Vector3.new(-168.92, 3.42, -125.58)},
	{"Prefeitura", Vector3.new(-354.94, 7.40, -104.12)},
	{"Corpo de Bombeiros", Vector3.new(-447.41, 3.50, -144.22)},
	{"Fazenda", Vector3.new(-846.09, 3.00, -438.49)}
}

for _, data in ipairs(locations) do
	local name = data[1]
	local position = data[2]

	Tab3:AddButton({name, function()
		teleportTo(position)
	end})
end

Tab3:AddSection({"Lugares Secretos"})

local secretLocations = {
	{"Passagem Subterrânea", Vector3.new(-92.76, -10.70, 263.66)},
	{"Sala das Câmeras", Vector3.new(-117.42, -27.50, 235.92)},
	{"Passagem Aquática", Vector3.new(10.67, -9.98, 187.02)},
	{"Passagem do Banco", Vector3.new(21.56, 25.90, 248.61)},
	{"Passagem do Hospital", Vector3.new(-340.49, 16.58, 70.68)},
	{"Casa Abandonada", Vector3.new(1035.85, 5.50, 54.20)}
}

for _, data in ipairs(secretLocations) do
	local name = data[1]
	local position = data[2]

	Tab3:AddButton({name, function()
		teleportTo(position)
	end})
end


local Tab4 = Window:MakeTab({"Esp", "eye"})

Tab4:AddSection({"ESP"})


local ESP_ENABLED = false
local BOX_ENABLED = false
local LINE_ENABLED = false

local menu = CoreGui:WaitForChild("redz Library V5")
local hub = menu:WaitForChild("Hub", true)

local menuOpen = hub.Visible

hub:GetPropertyChangedSignal("Visible"):Connect(function()
	menuOpen = hub.Visible
end)

local colors = {
    White = Color3.fromRGB(255,255,255),
	Red = Color3.fromRGB(255,0,0),
	Green = Color3.fromRGB(0,255,0),
	Blue = Color3.fromRGB(0,0,255),
	Yellow = Color3.fromRGB(255,255,0)
}

local SelectedColor = colors.Red
local Cache = {}

local function removeObjects(plr)
	local d = Cache[plr]
	if not d then return end
	if d.b then d.b:Destroy() end
	if d.h then d.h:Destroy() end
	if d.l then d.l:Remove() end
	Cache[plr] = nil
end

local function createESP(plr)
	local char = plr.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local attach = Instance.new("Attachment", root)
    attach.Name = "SpecterAttach"

	local bb = Instance.new("BillboardGui")
    bb.Name = "SpecterX_BGUI"
	bb.Size = UDim2.new(0,220,0,22)
	bb.StudsOffset = Vector3.new(0,2.5,0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = math.huge
	bb.Parent = attach

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextSize = 14
	txt.Font = Enum.Font.SourceSansBold
	txt.TextColor3 = SelectedColor
	txt.TextStrokeTransparency = 0
	txt.TextStrokeColor3 = Color3.new(0,0,0)
	txt.Parent = bb

	Cache[plr] = Cache[plr] or {}
	Cache[plr].b = bb
	Cache[plr].t = txt
end

local function createBox(plr)
	local char = plr.Character
	if not char then return end
	if Cache[plr] and Cache[plr].h then return end

	local h = Instance.new("Highlight")
    h.Name = "SpecterESP"
	h.FillTransparency = 1
	h.OutlineColor = SelectedColor
	h.Parent = char

	Cache[plr] = Cache[plr] or {}
	Cache[plr].h = h
end

local function createLinear(plr)
	if Cache[plr] and Cache[plr].l then return end
	local l = Drawing.new("Line")
	l.Thickness = 2
	l.Color = SelectedColor
	l.Visible = false

	Cache[plr] = Cache[plr] or {}
	Cache[plr].l = l
end

local function ensure(plr)
	if plr == player then return end
	if not plr.Character then return end

	if ESP_ENABLED and not (Cache[plr] and Cache[plr].b) then
		createESP(plr)
	end

	if BOX_ENABLED and not (Cache[plr] and Cache[plr].h) then
		createBox(plr)
	end

	if LINE_ENABLED and not (Cache[plr] and Cache[plr].l) then
		createLinear(plr)
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		removeObjects(plr)
	end)
end)

for _,plr in ipairs(Players:GetPlayers()) do
	if plr ~= player then
		plr.CharacterAdded:Connect(function()
			removeObjects(plr)
		end)
	end
end

Tab4:AddDropdown({
	Name = "Cor",
	Options = {"White","Green","Blue","Yellow","Red"},
	Default = "White",
	Callback = function(val)
		SelectedColor = colors[val]
		for _,d in pairs(Cache) do
			if d.t then d.t.TextColor3 = SelectedColor end
			if d.h then d.h.OutlineColor = SelectedColor end
			if d.l then d.l.Color = SelectedColor end
		end
	end
})

Tab4:AddToggle({
	Name = "Ativar ESP",
	Default = false,
	Callback = function(state)
		ESP_ENABLED = state
		if not state then
			for plr,_ in pairs(Cache) do
				if Cache[plr].b then Cache[plr].b:Destroy() Cache[plr].b = nil end
			end
		end
	end
})

Tab4:AddToggle({
	Name = "Ativar Box",
	Default = false,
	Callback = function(state)
		BOX_ENABLED = state
		if not state then
			for plr,_ in pairs(Cache) do
				if Cache[plr].h then Cache[plr].h:Destroy() Cache[plr].h = nil end
			end
		end
	end
})

Tab4:AddToggle({
	Name = "Ativar Linear",
	Default = false,
	Callback = function(state)
		LINE_ENABLED = state
		if not state then
			for plr,_ in pairs(Cache) do
				if Cache[plr].l then Cache[plr].l:Remove() Cache[plr].l = nil end
			end
		end
	end
})

RunService.RenderStepped:Connect(function()
	if not hrp then return end

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			ensure(plr)

			local char = plr.Character
			local d = Cache[plr]
			if char and d then
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					local dist = math.floor((hrp.Position - root.Position).Magnitude)

					if ESP_ENABLED and d.t and d.b then
						local hum = char:FindFirstChildOfClass("Humanoid")
						local seat = (hum and hum.SeatPart) and "SIM" or "NAO"
						d.t.Text = string.format("%s | %d | %s | %d",plr.Name,plr.AccountAge,seat,dist)
						d.t.TextColor3 = SelectedColor
					end

                    if d.l then
                        if LINE_ENABLED and not menuOpen then
                            local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                            local myScreenPos = camera:WorldToViewportPoint(hrp.Position)

                            if onScreen and screenPos.Z > 0 then
                                d.l.From = Vector2.new(myScreenPos.X, myScreenPos.Y)
                                d.l.To = Vector2.new(screenPos.X, screenPos.Y)
                                d.l.Color = SelectedColor
                                d.l.Visible = true
                            else
                                d.l.Visible = false
                            end
                        else
                            d.l.Visible = false
                        end
                    end


					if BOX_ENABLED and d.h then
						d.h.OutlineColor = SelectedColor
					end
				end
			end
		end
	end
end)

Tab4:AddSection({"ESP CAR"})

local CAR_ESP_ENABLED = false
local CarSelectedColor = colors.White
local CarCache = {}

local function getOwnerName(car, ownerObj)
	if ownerObj and ownerObj.Value and ownerObj.Value ~= "" then
		return ownerObj.Value
	end

	local parentName = ownerObj and ownerObj.Parent and ownerObj.Parent.Name or car.Name
	parentName = parentName:gsub("Car$", "")
	parentName = parentName:gsub("Horse$", "")

	return parentName
end

local function clearCar(car)
	local d = CarCache[car]
	if not d then return end
	if d.h then d.h:Destroy() end
	if d.b then d.b:Destroy() end
	CarCache[car] = nil
end

local function ensureCar(car)
	if CarCache[car] then return end

	local root = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
	local ownerObj = car:FindFirstChild("Owner")
	if not root or not ownerObj then return end

	local ownerName = getOwnerName(car, ownerObj)
	if ownerName == player.Name then return end

	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = CarSelectedColor
	highlight.Parent = car

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0,200,0,22)
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.MaxDistance = 100000
	billboard.Parent = root

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.TextScaled = true
	text.Font = Enum.Font.SourceSansBold
	text.TextStrokeTransparency = 0.3
	text.TextColor3 = CarSelectedColor
	text.Parent = billboard

	CarCache[car] = {h=highlight,b=billboard,t=text}
end

Tab4:AddToggle({
	Name="Ativar Car ESP",
	Default=false,
	Callback=function(v)
		CAR_ESP_ENABLED = v
		if not v then
			for car,_ in pairs(CarCache) do
				clearCar(car)
			end
		end
	end
})

Tab4:AddDropdown({
	Name="Car ESP Color",
	Options={"Red","Green","Blue","Yellow","White"},
	Default="White",
	Callback=function(v)
		CarSelectedColor = colors[v] or CarSelectedColor
		for _,d in pairs(CarCache) do
			if d.h then d.h.OutlineColor = CarSelectedColor end
			if d.t then d.t.TextColor3 = CarSelectedColor end
		end
	end
})

RunService.RenderStepped:Connect(function()
	if not CAR_ESP_ENABLED or not hrp then return end

	local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
	if not vehiclesFolder then return end

	for _,car in ipairs(vehiclesFolder:GetChildren()) do
		local ownerObj = car:FindFirstChild("Owner")

		if ownerObj then
			local ownerName = getOwnerName(car, ownerObj)

			if ownerName ~= player.Name then
				ensureCar(car)

				local d = CarCache[car]
				if d then
					local root = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
					if root then
						local dist = math.floor((hrp.Position - root.Position).Magnitude)
						d.t.Text = ownerName.." | "..dist
						d.h.OutlineColor = CarSelectedColor
						d.t.TextColor3 = CarSelectedColor
					end
				end
			else
				clearCar(car)
			end
		else
			clearCar(car)
		end
	end

	for car,_ in pairs(CarCache) do
		if not car or not car.Parent then
			clearCar(car)
		end
	end
end)

local Tab5 = Window:MakeTab({"Troll", "users"})

Tab5:AddSection({"View/Goto"})

local selectedPlayer
local viewing = false
local viewConnection

local function findPlayerByPartialName(partial)
    partial = partial:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            if plr.Name:lower():find(partial)
            or (plr.DisplayName or ""):lower():find(partial) then
                return plr
            end
        end
    end
end

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    if not viewing then
        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Custom
    end
end)

Tab5:AddTextBox({
    Name = "Nome do Jogador",
    PlaceholderText = "Ex: Specter",
    Callback = function(Value)
        local found = findPlayerByPartialName(Value)
        if found then
            selectedPlayer = found
            local ok, thumb = pcall(function()
                return Players:GetUserThumbnailAsync(found.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            Notify("Jogador selecionado: "..found.DisplayName, ok and thumb or nil)
        else
            Notify("Jogador não encontrado.")
        end
    end
})

local playerRemovingConnection

Tab5:AddToggle({
    Name = "View",
    Default = false,
    Callback = function(v)
        viewing = v

        if viewConnection then
            viewConnection:Disconnect()
            viewConnection = nil
        end

        if playerRemovingConnection then
            playerRemovingConnection:Disconnect()
            playerRemovingConnection = nil
        end

        if not v then
            camera.CameraSubject = humanoid
            viewing = false
            return
        end

        if not selectedPlayer or not Players:FindFirstChild(selectedPlayer.Name) then
            camera.CameraSubject = humanoid
            viewing = false
            Notify("Jogador invalido ou saiu do jogo.")
            return
        end

        playerRemovingConnection = Players.PlayerRemoving:Connect(function(plr)
            if plr == selectedPlayer then
                viewing = false
                camera.CameraSubject = humanoid

                if viewConnection then
                    viewConnection:Disconnect()
                    viewConnection = nil
                end

                Notify("Jogador saiu do jogo.")
            end
        end)

        viewConnection = RunService.RenderStepped:Connect(function()
            if selectedPlayer and selectedPlayer.Character then
                local targetHumanoid = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
                if targetHumanoid then
                    camera.CameraSubject = targetHumanoid
                end
            end
        end)
    end
})

Tab5:AddButton({
    Name = "Goto",
    Callback = function()
        if selectedPlayer
        and selectedPlayer.Character
        and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            character:PivotTo(selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0))
            Notify("Teleportado para: "..selectedPlayer.DisplayName)
        else
            Notify("Jogador não encontrado.")
        end
    end
})

Tab5:AddSection({"Fling Ball"})

local ServerBalls = Workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_SoccerBalls")
local toolRemote = RE:FindFirstChild("1Too1l")

local function FlingBall(target)
    local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") then
            toolRemote:InvokeServer("PickingTools", "SoccerBall")

            repeat task.wait()
            until backpack:FindFirstChild("SoccerBall")
        end

        backpack.SoccerBall.Parent = character

        repeat task.wait()
        until ServerBalls:FindFirstChild("Soccer" .. player.Name)

        character.SoccerBall.Parent = backpack

        return ServerBalls:FindFirstChild("Soccer" .. player.Name)
    end

    local Ball = ServerBalls:FindFirstChild("Soccer" .. player.Name) or GetBall()
    if not Ball then return end

    Ball.CanCollide = false
    Ball.Massless = true
    Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

    if target ~= player then
        local tchar = target.Character
        if tchar and tchar:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("Humanoid") then
            local troot = tchar.HumanoidRootPart
            local thum = tchar.Humanoid

            local oldBV = Ball:FindFirstChild("FlingPower")
            if oldBV then
                oldBV:Destroy()
            end

            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlingPower"
            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 9e9
            bv.Parent = Ball

            repeat
                if not Ball or not Ball.Parent then break end

                if troot.Velocity.Magnitude > 0 then
                    local pos = troot.Position + (troot.Velocity / 1.5)
                    Ball.CFrame = CFrame.new(pos)
                    Ball.Orientation += Vector3.new(45, 60, 30)
                else
                    for _, v in pairs(tchar:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide and not v.Anchored then
                            Ball.CFrame = v.CFrame
                            task.wait(1/6000)
                        end
                    end
                end

                task.wait(1/6000)
            until
                troot.Velocity.Magnitude > 1000
                or thum.Health <= 0
                or not tchar:IsDescendantOf(workspace)
                or target.Parent ~= game:GetService("Players")

            if Ball:FindFirstChild("FlingPower") then
                Ball.FlingPower:Destroy()
            end

            Ball.CanCollide = true
            Ball.Massless = false
            Ball.CustomPhysicalProperties = PhysicalProperties.new(1, 0.3, 0.5)
        end
    end
end

Tab5:AddButton({
    Name = "Fling Ball",
    Callback = function()
        if not selectedPlayer or not selectedPlayer.Character then
            Notify("Jogador Invalido.")
            return
        end
        FlingBall(selectedPlayer)
    end
})

Tab5:AddSection({"Couch"})

Tab5:AddButton({
Name = "Fling Couch",
Callback = function()
    if not selectedPlayer or not selectedPlayer.Character then
        return Notify("Jogador Invalido.")
    end

    local TCharacter = selectedPlayer.Character
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = TCharacter:FindFirstChild("HumanoidRootPart")

    if not THumanoid or not TRootPart then
        return Notify("Jogador Invalido.")
    end

    local OldPos = hrp.CFrame

    if toolRemote then
        toolRemote:InvokeServer("PickingTools", "Couch")
    end
    task.wait(0.3)

    local Couch = backpack:FindFirstChild("Couch")
    if not Couch then
        return warn("Couch não encontrado.")
    end
    humanoid:EquipTool(Couch)

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.1)

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    camera.CameraSubject = TCharacter:FindFirstChild("Head") or TRootPart

    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Velocity = Vector3.zero
    BV.Parent = hrp

    task.spawn(function()
        local angle = 0

        while THumanoid
        and THumanoid.Health > 0
        and TRootPart
        and TRootPart.Position.Y < 3000 do

            angle += 50
            local predicted = TRootPart.Position + (TRootPart.Velocity / 1.5)

            hrp.CFrame =
                CFrame.new(predicted + Vector3.new(0, 2, 0)) *
                CFrame.Angles(math.rad(angle), 0, 0)

            BV.Velocity =
                (TRootPart.Position - hrp.Position).Unit * 9e7
                + Vector3.new(0, 9e7, 0)

            task.wait()
        end

        BV:Destroy()

        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Velocity = Vector3.zero
                p.RotVelocity = Vector3.zero
            end
        end

        task.wait(0.1)
        hrp.Anchored = true
        task.wait(0.05)
        hrp.Anchored = false

        camera.CameraSubject = humanoid

        task.wait(0.2)
        local c = character:FindFirstChild("Couch")
        if c then c.Parent = backpack end
        if toolRemote then
            toolRemote:InvokeServer("PickingTools", "Couch")
            hrp.CFrame = OldPos
        end
    end)
end
})

Tab5:AddButton({ "Bring Couch", function()
    if not selectedPlayer or not selectedPlayer.Character then
        return Notify("Jogador Invalido.")
    end

    local TCharacter = selectedPlayer.Character
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = TCharacter:FindFirstChild("HumanoidRootPart")

    if not THumanoid or not TRootPart then
        return warn("Humanoid ou RootPart do alvo não encontrados.")
    end

    local OldPos = hrp.CFrame

    if toolRemote then
        toolRemote:InvokeServer("PickingTools", "Couch")
    end
    task.wait(0.3)

    local Couch = backpack:FindFirstChild("Couch")
    if Couch then
        humanoid:EquipTool(Couch)
    else
        return warn("Falha ao obter Couch.")
    end

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.1)

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    humanoid.PlatformStand = false
    camera.CameraSubject = TCharacter:FindFirstChild("Head") or TRootPart

    local BP = Instance.new("BodyPosition")
    BP.Name = "BringPosition"
    BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BP.P = 30000
    BP.D = 10
    BP.Position = hrp.Position
    BP.Parent = TRootPart

    task.spawn(function()
        local angle = 0
        local start = tick()

        while tick() - start < 5 do
            if not THumanoid or THumanoid.Health <= 0 then break end
            if THumanoid.Sit then break end

            angle += 50
            local predicted = TRootPart.Position + (TRootPart.Velocity / 1.5)

            hrp.CFrame =
                CFrame.new(predicted + Vector3.new(0, 2, 0)) *
                CFrame.Angles(math.rad(angle), 0, 0)

            BP.Position = hrp.Position + Vector3.new(2, 0, 0)
            task.wait()
        end

        BP:Destroy()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        camera.CameraSubject = humanoid

        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Velocity = Vector3.zero
                p.RotVelocity = Vector3.zero
            end
        end

        task.wait(0.1)
        hrp.Anchored = true
        hrp.CFrame = OldPos
        task.wait(0.01)
        hrp.Anchored = false

        task.wait(0.85)

        local couch = character:FindFirstChild("Couch")
        if couch then
            couch.Parent = backpack
        end

        task.wait(0.1)
        if toolRemote then
            toolRemote:InvokeServer("PickingTools", "Couch")
        end
    end)
end})

Tab5:AddButton({
    Name = "Kill Couch",
    Callback = function()
        local TargetPlayer = selectedPlayer
        if not TargetPlayer or not TargetPlayer.Character then
            Notify("Jogador Invalido.")
            return
        end

        local TCharacter = TargetPlayer.Character
        local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
        local TRootPart = TCharacter:FindFirstChild("HumanoidRootPart")

        if not THumanoid or not TRootPart then
            Notify("Jogador Invalido.")
            return
        end

        local OldCFrame = hrp.CFrame
        local SitCFrame = CFrame.new(145.51, -350.09, 21.58)

        task.wait(0.2)

        if toolRemote then
            toolRemote:InvokeServer("PickingTools", "Couch")
        end
        task.wait(0.3)

        local Couch = backpack:FindFirstChild("Couch")
        if Couch then
            humanoid:EquipTool(Couch)
        else
            warn("Couch não encontrado.")
            return
        end

        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.1)

        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid.PlatformStand = false
        camera.CameraSubject = TCharacter:FindFirstChild("Head") or TRootPart

        local BP = Instance.new("BodyPosition")
        BP.Name = "BringPosition"
        BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BP.P = 30000
        BP.D = 10
        BP.Position = hrp.Position
        BP.Parent = TRootPart

        task.spawn(function()
            local angle = 0
            local start = tick()

            while tick() - start < 5 do
                if not THumanoid or THumanoid.Health <= 0 then break end
                if THumanoid.Sit then break end

                angle += 50
                local predictPos = TRootPart.Position + (TRootPart.Velocity / 1.5)

                hrp.CFrame =
                    CFrame.new(predictPos + Vector3.new(0, 2, 0)) *
                    CFrame.Angles(math.rad(angle), 0, 0)

                BP.Position = hrp.Position + Vector3.new(2, 0, 0)
                task.wait()
            end

            BP:Destroy()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            camera.CameraSubject = humanoid

            for _, v in ipairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.zero
                    v.RotVelocity = Vector3.zero
                end
            end

            task.wait(0.1)
            hrp.CFrame = SitCFrame
            task.wait(0.3)

            local couch = character:FindFirstChild("Couch")
            if couch then
                couch.Parent = backpack
            end

            task.wait(0.1)
            if toolRemote then
                toolRemote:InvokeServer("PickingTools", "Couch")
            end

            task.wait(0.2)
            hrp.CFrame = OldCFrame
        end)
    end
})

Tab5:AddSection({ "Car" })

local function getBus()
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if not vehicles then return end
    return vehicles:FindFirstChild(player.Name .. "Car")
end

local function spawnAndSit()
    local vehicles = Workspace:FindFirstChild("Vehicles")
    if not vehicles then return end

    local pCar = getBus()

    if not pCar then
        hrp.CFrame = CFrame.new(-1267, 77, -1270)
        task.wait(0.5)

        local remote = ReplicatedStorage:FindFirstChild("RE")
        if remote and remote:FindFirstChild("1Ca1r") then
            remote["1Ca1r"]:FireServer("PickingCar", "Bus")
        end

        repeat
            task.wait()
            pCar = getBus()
        until pCar
    end

    local seat = pCar:WaitForChild("Seats"):WaitForChild("VehicleSeat")

    repeat
        task.wait()
        hrp.CFrame = seat.CFrame
    until humanoid.Sit

    return pCar
end

Tab5:AddButton({
    Name = "Fling bus",
    Callback = function()
        if not selectedPlayer then return end

        local oldPos = hrp.CFrame
        local pCar = spawnAndSit()
        if not pCar then return end

        local targetChar = selectedPlayer.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        local targetRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not targetChar or not targetHum or not targetRP then return end

        local angle = 0

        while pCar.Parent and targetRP.Parent do
            task.wait()
            angle += 150
            local rotation = CFrame.Angles(0, math.rad(angle), 0)
            local newPos = targetRP.Position + Vector3.new(0, 2, 0)
            pCar:SetPrimaryPartCFrame(CFrame.new(newPos) * rotation)
        end

        humanoid.Sit = false
        hrp.CFrame = oldPos
    end
})

Tab5:AddButton({
    Name = "Kill bus",
    Callback = function()
        if not selectedPlayer then return end

        local oldPos = hrp.CFrame
        local pCar = spawnAndSit()
        if not pCar then return end

        local targetChar = selectedPlayer.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        local targetRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not targetChar or not targetHum or not targetRP then return end

        while targetHum.Health > 0 do
            task.wait(0.05)
            local offset = targetRP.CFrame.LookVector * 12
            pCar:SetPrimaryPartCFrame(CFrame.new(targetRP.Position + offset))
        end

        pCar:SetPrimaryPartCFrame(CFrame.new(0, -500, 0))
        humanoid.Sit = false
        hrp.CFrame = oldPos
    end
})

Tab5:AddButton({
    Name = "Bring bus",
    Callback = function()
        if not selectedPlayer then return end

        local oldPos = hrp.CFrame
        local pCar = spawnAndSit()
        if not pCar then return end

        local targetChar = selectedPlayer.Character
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        local targetRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not targetChar or not targetHum or not targetRP then return end

        while not targetHum.Sit do
            task.wait()
            local offset = targetRP.CFrame.LookVector * 6
            pCar:SetPrimaryPartCFrame(CFrame.new(targetRP.Position + offset))
        end

        pCar:SetPrimaryPartCFrame(oldPos)
        humanoid.Sit = false
    end
})

local Tab6 = Window:MakeTab({"Avatar","shirt"})

local selectedPlayer,lastValidTarget
local copyType="Brookhaven"

local function safeCall(func, ...)
	local args = {...}

	while true do
		local success, result = pcall(func, unpack(args))

		if success and result ~= false then
			return result
		end

		task.wait(5)
	end
end

local function notifyPlayer(t)
	if not t then return end
	StarterGui:SetCore("SendNotification",{
		Title="Player Selecionado",
		Text=t.Name,
		Duration=5,
		Icon="rbxthumb://type=AvatarHeadShot&id="..t.UserId.."&w=150&h=150"
	})
end

local function findPlayerByName(text)
	if not text or text=="" then return end
	text=text:lower()
	local partial
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=player then
			local name=plr.Name:lower()
			local display=plr.DisplayName:lower()
			if name==text or display==text then
				return plr
			end
			if not partial and (name:find(text,1,true) or display:find(text,1,true)) then
				partial=plr
			end
		end
	end
	return partial
end

local function getClosestPlayer()
	local closest,shortest=nil,math.huge
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist=(plr.Character.HumanoidRootPart.Position-hrp.Position).Magnitude
			if dist<shortest then
				shortest=dist
				closest=plr
			end
		end
	end
	return closest
end

local function getRandomPlayer()
	local list={}
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=player then
			table.insert(list,plr)
		end
	end
	return #list>0 and list[math.random(1,#list)] or nil
end

local function wear(id)
	id = tonumber(id)

	if id and id ~= 0 then
		safeCall(Remotes.Wear.InvokeServer, Remotes.Wear, id)
		task.wait(1)
	end
end

local function clearAccessories()
	local char=player.Character
	if not char then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local desc=hum:GetAppliedDescription()
	if not desc then return end
	for _,acc in ipairs(desc:GetAccessories(true)) do
		if acc.AssetId and acc.AssetId~=0 then
            task.wait(1)
			wear(acc.AssetId)
		end
	end
end

local function resetBody()
	safeCall(Remotes.ChangeCharacterBody.InvokeServer,Remotes.ChangeCharacterBody,{0,0,0,0,0,0},"AllBlocky")
end

local function safeNum(v)
	return tonumber(v) or 0
end

local function applyBodyParts(desc,src)
	safeCall(Remotes.ChangeCharacterBody.InvokeServer,Remotes.ChangeCharacterBody,{
		safeNum(desc.Torso),
		safeNum(desc.RightArm),
		safeNum(desc.LeftArm),
		safeNum(desc.RightLeg),
		safeNum(desc.LeftLeg),
		safeNum(desc.Head)
	},src)
end

local function applyClothing(desc)
	for _,id in ipairs({desc.Shirt,desc.Pants,desc.GraphicTShirt,desc.Face}) do
		wear(id)
	end
end

local function applyAccessories(desc)
    for _,v in ipairs(desc:GetAccessories(true)) do
        wear(v.AssetId)
        task.wait(1)
    end
end

local function applyAnimations(desc, target)
	local usedDescription = false

	if desc then
		for _,id in ipairs({
			desc.IdleAnimation,
			desc.WalkAnimation,
			desc.RunAnimation,
			desc.JumpAnimation,
			desc.FallAnimation,
			desc.SwimAnimation
		}) do
			if id and id ~= 0 then
				wear(id)
				usedDescription = true
			end
		end
	end

	if not usedDescription and target and target.Character then
		local animate = target.Character:FindFirstChild("Animate")
		if animate then
			for _,folder in ipairs(animate:GetChildren()) do
				for _,anim in ipairs(folder:GetChildren()) do
					if anim:IsA("Animation") and anim.AnimationId then
						local id = anim.AnimationId:match("%d+")
						if id then
							wear(id)
						end
					end
				end
			end
		end
	end
end

local function applySkinFromCharacter(t)
	local bc=t.Character and t.Character:FindFirstChildOfClass("BodyColors")
	if bc and bc.HeadColor then
		Remotes.ChangeBodyColor:FireServer(tostring(bc.HeadColor))
	end
end

local function applySkinFromUserId(id)
	safeCall(function()
		local info=Players:GetCharacterAppearanceInfoAsync(id)
		if info.bodyColors and info.bodyColors.headColor then
			Remotes.ChangeBodyColor:FireServer(tostring(info.bodyColors.headColor))
		end
	end)
end

local function copyBrookhaven(t)
	if not t or not t.Character then return end
	local hum=t.Character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local desc=hum:GetAppliedDescription()
	resetBody()
	clearAccessories()
	task.wait(2)
	applyBodyParts(desc,"SpecterX")
	task.wait(2)
	applyClothing(desc)
    task.wait(2)
	applyAccessories(desc)
    task.wait(2)
	applyAnimations(desc)
    task.wait(2)
	applySkinFromCharacter(t)
end

local function copyOriginal(id)
	safeCall(function()
		local desc=Players:GetHumanoidDescriptionFromUserId(id)
		resetBody()
		clearAccessories()
		task.wait(2)
		applyBodyParts(desc,"SpecterHub")
        task.wait(2)
		applyClothing(desc)
        task.wait(2)
		applyAccessories(desc)
        task.wait(2)
		applyAnimations(desc)
        task.wait(2)
		applySkinFromUserId(id)
	end)
end

Tab6:AddSection({"Copy Avatar"})

Tab6:AddTextBox({
	Name="Escreva o nome do player",
	PlaceholderText="Ex: specter",
	Callback=function(v)
		if v=="" then v=lastValidTarget if not v then return end end
		local plr=findPlayerByName(v)
		if plr then
			selectedPlayer=plr
			lastValidTarget=plr.Name
			notifyPlayer(plr)
		else
			selectedPlayer=nil
		end
	end
})

Tab6:AddDropdown({
	Name="Copy Method",
	Options={"Brookhaven","Original Avatar"},
	Default="Brookhaven",
	Callback=function(o)
		copyType=o
	end
})

Tab6:AddButton({
	Name="Copiar avatar",
	Callback=function()
		if not selectedPlayer then return end
		if copyType=="Brookhaven" then
			copyBrookhaven(selectedPlayer)
		else
			copyOriginal(selectedPlayer.UserId)
		end
	end
})

Tab6:AddButton({
	Name="Copiar avatar mais próximo",
	Callback=function()
		local plr=getClosestPlayer()
		if not plr then return end
		notifyPlayer(plr)
		if copyType=="Brookhaven" then
			copyBrookhaven(plr)
		else
			copyOriginal(plr.UserId)
		end
	end
})

Tab6:AddButton({
	Name="Copiar avatar aleatório",
	Callback=function()
		local plr=getRandomPlayer()
		if not plr then return end
		notifyPlayer(plr)
		if copyType=="Brookhaven" then
			copyBrookhaven(plr)
		else
			copyOriginal(plr.UserId)
		end
	end
})