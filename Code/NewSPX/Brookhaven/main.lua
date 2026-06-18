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

local RemoteColor = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1RPNam1eColo1r")
local RemoteText = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1RPNam1eTex1t")

local RGB_STATE = {name=false,bio=false}
local RGB_REMOTE = {
	name="PickingRPNameColor",
	bio="PickingRPBioColor"
}

local function startRGB(target)
	if RGB_STATE[target] then return end
	RGB_STATE[target] = true
	task.spawn(function()
		local h = 0
		while RGB_STATE[target] do
			h = (h + 0.01) % 1
			RemoteColor:FireServer(RGB_REMOTE[target], Color3.fromHSV(h,1,1))
			task.wait(0.05)
		end
	end)
end

local function stopRGB(target)
	RGB_STATE[target] = false
end

Tab6:AddSection({"RP RGB"})

local lastNameText,lastBioText="",""

Tab6:AddTextBox({
	Name="Nome RP",
	PlaceholderText="Digite o nome do RP...",
	Callback=function(v)
		if v~=lastNameText then
			lastNameText=v
			RemoteText:FireServer("RolePlayName",v)
		end
	end
})

Tab6:AddToggle({
	Name="Ativar RGB Nome",
	Default=false,
	Callback=function(v)
		if v then startRGB("name") else stopRGB("name") end
	end
})

Tab6:AddSection({"Bio RGB"})

Tab6:AddTextBox({
	Name="Bio RP",
	PlaceholderText="Digite a bio do RP...",
	Callback=function(v)
		if v~=lastBioText then
			lastBioText=v
			RemoteText:FireServer("RolePlayBio",v)
		end
	end
})

Tab6:AddToggle({
	Name="Ativar RGB Bio",
	Default=false,
	Callback=function(v)
		if v then startRGB("bio") else stopRGB("bio") end
	end
})

Tab6:AddSection({"Corpo RGB"})

local colors={"Bright red","Lime green","Bright blue","Bright yellow","Bright cyan","Hot pink","Royal purple","Really black","Really red","Institutional white","Pastel Blue","Neon orange"}

local bodyRGB=false

local function startBodyRGB()
	if bodyRGB then return end
	bodyRGB=true
	task.spawn(function()
		while bodyRGB do
			for _,c in ipairs(colors) do
				if not bodyRGB then break end
				Remotes.ChangeBodyColor:FireServer(c)
				task.wait(0.5)
			end
		end
	end)
end

local function stopBodyRGB()
	bodyRGB=false
end

Tab6:AddToggle({
	Name="Corpo RGB",
	Default=false,
	Callback=function(v)
		if v then startBodyRGB() else stopBodyRGB() end
	end
})

local selectedPlayer,lastValidTarget
local copyType="Brookhaven"

local function safeCall(f,...)
	pcall(f,...)
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
	id=tonumber(id)
	if id and id~=0 then
		safeCall(Remotes.Wear.InvokeServer,Remotes.Wear,id)
		task.wait(0.1)
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
	task.wait(1)
	applyBodyParts(desc,"SpecterX")
	task.wait(1)
	applyClothing(desc)
    task.wait(1)
	applyAccessories(desc)
    task.wait(1)
	applyAnimations(desc)
    task.wait(1)
	applySkinFromCharacter(t)
end

local function copyOriginal(id)
	safeCall(function()
		local desc=Players:GetHumanoidDescriptionFromUserId(id)
		resetBody()
		clearAccessories()
		task.wait(1)
		applyBodyParts(desc,"SpecterHub")
        task.wait(1)
		applyClothing(desc)
        task.wait(1)
		applyAccessories(desc)
        task.wait(1)
		applyAnimations(desc)
        task.wait(1)
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

Tab6:AddSection({"Catalogo"})

local body={Torso=nil,RightArm=nil,LeftArm=nil,RightLeg=nil,LeftLeg=nil,Head=nil}

local bodyMap={
	[27]="Torso",
	[28]="RightArm",
	[29]="LeftArm",
	[31]="RightLeg",
	[30]="LeftLeg",
	[17]="Head"
}

local function trySendBody()
	for _,v in pairs(body) do
		if not v then return end
	end
	Remotes.ChangeCharacterBody:InvokeServer({
		body.Torso,
		body.RightArm,
		body.LeftArm,
		body.RightLeg,
		body.LeftLeg,
		body.Head
	})
end

local function playEmote(id)
	local anim=Instance.new("Animation")
	anim.AnimationId="rbxassetid://"..id
	local track=humanoid:LoadAnimation(anim)
	track:Play()
end

local function apply(id)
	local info
	pcall(function()
		info=Marketplace:GetProductInfo(id)
	end)
	if not info then return end

	local t=info.AssetTypeId
	local name=info.Name:lower()

	if t==11 or t==12 or name:find("shirt") or name:find("pants") then
		return Remotes.WearShirt:InvokeServer(id)
	end

	if t==8 or t==41 or t==42 or t==43 then
		return Remotes.Wear:InvokeServer(id)
	end

	local part=bodyMap[t]
	if part then
		body[part]=id
		return trySendBody()
	end

	if t==61 or (t==24 and (name:find("emote") or name:find("dance"))) then
		if Remotes:FindFirstChild("PlayEmote") then
			Remotes.PlayEmote:FireServer(id)
		else
			playEmote(id)
		end
	end
end

local lastId

Tab6:AddTextBox({
	Name="Digite o ID",
	PlaceholderText="Ex: 123456789",
	Callback=function(v)
		lastId=tonumber(v)
	end
})

Tab6:AddButton({
	"Confirmar",
	function()
		if lastId then
			apply(lastId)
		end
	end
})

Tab6:AddSection({"Avatares"})

Tab6:AddSection({"Roleplay Names"})

Tab6:AddButton({"Specter - Oficial", function(Value)
loadstring(game:HttpGet("https://pastebin.com/raw/zE19LKjW"))()
end})

local Tab7 = Window:MakeTab({"House", "home"})

Tab7:AddSection({"House Manager"})

local looping = false
local currentTarget
local lastBan = {}
local COOLDOWN = 1

local function getPlayerByDisplayName(input)
	if not input or input == "" then return end
	input = input:lower()
	local partial
	
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local display = plr.DisplayName:lower()
			local name = plr.Name:lower()

			if display == input or name == input then
				return plr
			end

			if not partial then
				if display:find(input,1,true) or name:find(input,1,true) then
					partial = plr
				end
			end
		end
	end
	
	return partial
end

local function getPlayerHouse(plr)
	local lots = workspace:FindFirstChild("001_Lots")
	if not lots then return end
	local folder = lots:FindFirstChild(plr.Name.."House")
	if not folder then return end
	local picked = folder:FindFirstChild("HousePickedByPlayer")
	if not picked then return end
	return picked:FindFirstChild("HouseModel")
end

local function banPlayer(plr)
	if not plr or plr == player or plr.Parent ~= Players then return end
	
	if lastBan[plr] and tick() - lastBan[plr] < COOLDOWN then
		return
	end
	
	lastBan[plr] = tick()
	
	local house = getPlayerHouse(player)
	if not house then return end
	local remote = house:FindFirstChild("Permissions:Disallow")
	if remote then
		remote:FireServer(plr)
	end
end

local function unbanPlayer(plr)
	if not plr or plr.Parent ~= Players then return end
	
	local house = getPlayerHouse(player)
	if not house then return end
	local remote = house:FindFirstChild("Permissions:Allow")
	if remote then
		remote:FireServer(plr)
	end
end

Tab7:AddTextBox({
	Name="Escreva o nome do jogador",
	PlaceholderText="Ex: Specter",
	Callback=function(value)
		local plr = getPlayerByDisplayName(value)
		if plr then
			if plr == player then
				Notify("ERROR: VOCÊ NÃO PODE SE AUTO SELECIONAR!")
				currentTarget = nil
				return
			end
			currentTarget = plr
			Notify("Jogador selecionado: "..plr.DisplayName)
		else
			currentTarget = nil
		end
	end
})

Tab7:AddButton({
	"Banir o jogador",
	function()
		if currentTarget then
			banPlayer(currentTarget)
			Notify(currentTarget.Name.." foi banido.")
		else
			Notify("Nenhum jogador válido.")
		end
	end
})

Tab7:AddButton({
	"Desbanir o jogador",
	function()
		if currentTarget then
			unbanPlayer(currentTarget)
			Notify(currentTarget.Name.." foi desbanido.")
		else
			Notify("Nenhum jogador válido.")
		end
	end
})

Tab7:AddButton({
	"Banir todos da sua casa",
	function()
		for _,plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				banPlayer(plr)
				task.wait(0.15)
			end
		end
	end
})

Tab7:AddButton({
	"Desbanir todos da sua casa",
	function()
		for _,plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				unbanPlayer(plr)
				task.wait(0.15)
			end
		end
	end
})

Tab7:AddToggle({
	Name="Banir Todos jogadores em loop",
	Default=false,
	Callback=function(state)
		if looping == state then return end
		looping = state
		if looping then
			task.spawn(function()
				while looping do
					for _,plr in ipairs(Players:GetPlayers()) do
						if plr ~= player then
							banPlayer(plr)
							task.wait(0)
						end
					end
					task.wait(0)
				end
			end)
		end
	end
})

Tab7:AddToggle({
	Name="Banir Todos jogadores em loop",
	Default=false,
	Callback=function(state)
		if looping == state then return end
		looping = state
		if looping then
			task.spawn(function()
				while looping do
					for _,plr in ipairs(Players:GetPlayers()) do
						if plr ~= player then
							unbanPlayer(plr)
							task.wait(0)
						end
					end
					task.wait(0)
				end
			end)
		end
	end
})

local function UnbanAll()
	local lots = workspace:FindFirstChild("001_Lots")
	if not lots then return end
	for _,house in ipairs(lots:GetChildren()) do
		local picked = house:FindFirstChild("HousePickedByPlayer")
		if picked then
			local model = picked:FindFirstChild("HouseModel")
			if model then
				local banned = model:FindFirstChild("BannedBlock")
				if banned then
					for _,child in ipairs(banned:GetChildren()) do
						if child.Name:find("PropBlocker",1,true) then
							child:Destroy()
						end
					end
					banned:Destroy()
				end
			end
		end
	end
end

Tab7:AddSection({"Unban house"})

Tab7:AddToggle({
	Name="Auto Desbanir",
	Default=false,
	Callback=function(v)
        local toggleActive
		if toggleActive == v then return end
		toggleActive = v
		if toggleActive then
			connection = RunService.Heartbeat:Connect(UnbanAll)
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end
})

Tab7:AddButton({
	"Desbanir",
	function()
		UnbanAll()
	end
})

local Tab8 = Window:MakeTab({"Car", "car"})

Tab8:AddSection({"Modificar velocidade"})

local speed = nil
local turbo = nil

local function getVehicleType(playerName)
    local vehicleCar = Workspace.Vehicles:FindFirstChild(playerName .. "Car")
    if vehicleCar then
        return vehicleCar, "Car"
    end
    local vehicleHorse = workspace.Vehicles:FindFirstChild(playerName .. "Horse")
    if vehicleHorse then
        return vehicleHorse, "Horse"
    end
    return nil, nil
end

Tab8:AddTextBox({
    Name = "Escreva a velocidade",
    PlaceholderText = "Ex: 200",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            speed = num
            Notify("Velocidade salva:", speed)
        else
            Notify("Valor inválido para velocidade")
        end
    end
})

Tab8:AddTextBox({
    Name = "Escreva o turbo",
    PlaceholderText = "Ex: 20",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            turbo = num
            Notify("Turbo salvo:", turbo)
        else
            Notify("Valor inválido para turbo")
        end
    end
})

Tab8:AddButton({
    Name = "Aplicar Velocidade/Turbo",
    Callback = function()
        local vehicle, vType = getVehicleType(player.Name)
        if not vehicle then
            Notify("Veículo não encontrado para o jogador: " .. player.Name)
            return
        end
        local seats = vehicle:FindFirstChild("Seats")
        if not seats then
            Notify("Seats não encontrado!")
            return
        end
        local vehicleSeat = seats:FindFirstChild("VehicleSeat")
        if not vehicleSeat then
            Notify("VehicleSeat não encontrado!")
            return
        end
        if speed then
            local maxSpeed = vehicleSeat:FindFirstChild("MaxSpeed")
            if maxSpeed then
                maxSpeed.Value = speed
            else

            end
        else
            Notify("Velocidade não definida, não aplicando.")
        end
        if turbo then
            local turboObj = vehicleSeat:FindFirstChild("Turbo")
            if turboObj then
                turboObj.Value = turbo
                Notify("Turbo aplicado:", turbo)
            else
                Notify("Turbo não encontrado!")
            end
        else
            Notify("Turbo não definido, não aplicando.")
        end
    end
})

Tab8:AddSection({"Car Music (Gamepass)"})

local musicList = {
	["Alanwaad"] = "17422173467",
	["Amazing World"] = "72823279803174",
	["BARULHO DA CAMA"] = "126128443619187",
	["DOWN2KILL"] = "16190760285",
	["FUNK POCOYO"] = "121894195015892",
	["Geraçao"] = "119293698405737",
	["HR"] = "16190782181",
	["Is it The right thing"] = "76016469551489",
	["JUMPSTYLE"] = "76578817848504",
	["Liquid"] = "105663768150465",
	["PANCADÃO"] = "76312991186384",
	["MTG ASSOMBRA"] = "72855385972818",
	["MTG BAILAO"] = "129071695986627",
	["MTG BURIAL"] = "72064279451779",
	["MTG CASTELO"] = "133895272134570",
	["MTG CRISTAL"] = "103695219371872",
	["MTG DEIXA"] = "71774089837182",
	["MTG ENCANTA"] = "74258284867725",
	["MTG FIM DE SEMANA (Slowed)"] = "121389534393150",
	["MTG GLITCH"] = "80424205095272",
	["MTG PESADA"] = "113130963054466",
	["MTG RUGADA"] = "120342836549924",
	["MTG PAQUISTO"] = "99812493978684",
	["MTG VELA"] = "84438345224115",
	["PAI"] = "95046091312570",
	["Sou livre..."] = "121592654059575",
	["PHONK VISION"] = "96820165642825",
	["Pimetinha"] = "126932991289943",
	["Rock that body"] = "72678301552319",
	["FUNK TREMBALA"] = "137828639403630",
	["FUNK ENGENHA"] = "122367698779698",
	["Vem ch** minha *****"] = "112930367758222",
	["Tava aqui pensado"] = "82929658013383",
	["TOMA TOMA"] = "129098116998483",
	["Zum Zum"] = "92446612272052"
}

local musicId = nil
local isPlaying = false

local function getSortedKeys()
	local keys = {}
	for name in pairs(musicList) do
		table.insert(keys, name)
	end
	table.sort(keys)
	return keys
end

local musicEvents = {
	{
		remote = "1Player1sCa1r",
		args = function(id)
			return {"PickingCarMusicText", id}
		end
	},
	{
		remote = "1Player1sCa1r",
		args = function(id)
			return {"PickingVehicleMusicText", id, nil, true}
		end
	},
	{
		remote = "1NoMoto1rVehicle1s",
		args = function(id)
			return {"PickingScooterMusicText", id}
		end
	},
	{
		remote = "PlayerToolEvent",
		args = function(id)
			return {"ToolMusicText", id, nil, true}
		end
	}
}

local stopEvents = {
	{
		remote = "1Player1sCa1r",
		args = {"CarMusicStop", ""}
	},
	{
		remote = "1Player1sCa1r",
		args = {"PickingVehicleMusicText", "", nil, true}
	},
	{
		remote = "1NoMoto1rVehicle1s",
		args = {"PickingScooterMusicStop", ""}
	},
	{
		remote = "PlayerToolEvent",
		args = {"ToolMusicText", "", nil, true}
	},
}

function playMusic(id)
	for _, data in ipairs(musicEvents) do
		RE[data.remote]:FireServer(unpack(data.args(id)))
	end
end

function stopMusic()
	for _, data in ipairs(stopEvents) do
		RE[data.remote]:FireServer(unpack(data.args))
	end
end

Tab8:AddDropdown({
	Name = "Músicas:",
	Options = getSortedKeys(),
	Default = nil,
	Callback = function(Value)
		local id = musicList[Value]
		if not id then return end
		musicId = id
		if isPlaying then
			playMusic(musicId)
		end
	end
})

Tab8:AddTextBox({
	Name = "Escreva o ID",
	PlaceholderText = "Ex: 123456789",
	Callback = function(Value)
		musicId = Value
		if isPlaying and musicId ~= "" then
			playMusic(musicId)
		end
	end
})

Tab8:AddToggle({
	Name = "Tocar",
	Default = false,
	Callback = function(Value)
		isPlaying = Value
		if Value then
			if musicId and musicId ~= "" then
				playMusic(musicId)
			else
				Notify("Você precisa inserir um ID da música.")
			end
		else
			stopMusic()
		end
	end
})

Tab8:AddSection({"Boombox"})

local bRgbEnabled = false
local bRgbConnection
local rgbEnabled = false

local function startRGBBoombox()
	local bRemote = PlayerGui:WaitForChild("ToolGui"):WaitForChild("ToolSettings"):WaitForChild("Settings"):WaitForChild("PropsColor"):WaitForChild("SetColor")

	local hue = 0
	
	if bRgbConnection then
		bRgbConnection:Disconnect()
		bRgbConnection = nil
	end
	
	local function hasBoombox()
		return backpack:FindFirstChild("Boombox") 
			or (player.Character and player.Character:FindFirstChild("Boombox"))
	end
	
	if not hasBoombox() then
		return
	end
	
	bRgbConnection = RunService.RenderStepped:Connect(function(dt)
		if not hasBoombox() then
			bRgbConnection:Disconnect()
			bRgbConnection = nil
			return
		end
		
		hue += dt * 0.3
		if hue > 1 then
			hue = 0
		end

		local color = Color3.fromHSV(hue, 1, 1)
		bRemote:FireServer(color)
	end)
end


local function stopRGBBoombox()
    if bRgbConnection then
        bRgbConnection:Disconnect()
        bRgbConnection = nil
    end
end

Tab8:AddToggle({
    Name = "Boombox RGB",
    Default = false,
    Callback = function(state)
        rgbEnabled = state
        if state then
            startRGBBoombox()
        else
            stopRGBBoombox()
        end
    end
})

Tab8:AddSection({"Car Troll"})

local selectedVehicle = nil
local viewVehicleInitialized = false

Tab8:AddTextBox({
    Name = "Escreva o nome do carro",
    PlaceholderText = "Ex: Specter",
    Callback = function(value)
        local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then return end

        local inputName = string.lower(value)
        selectedVehicle = nil

        local matches = {}

        for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
            local vehicleName = string.lower(vehicle.Name)
            if vehicleName:find(inputName) and vehicleName:find(string.lower(player.Name)) then
                table.insert(matches, vehicle)
            end
        end

        if #matches == 0 then
            for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
                local vehicleName = string.lower(vehicle.Name)
                if vehicleName:find(inputName) then
                    table.insert(matches, vehicle)
                end
            end
        end

        if #matches > 0 then
            selectedVehicle = matches[math.random(1, #matches)]

            if not selectedVehicle.PrimaryPart then
                selectedVehicle.PrimaryPart = selectedVehicle:FindFirstChildWhichIsA("BasePart")
            end

            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = 'Selecionado: "' .. selectedVehicle.Name .. '" com sucesso',
                Duration = 5
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "Nenhum veículo encontrado.",
                Duration = 5
            })
        end
    end
})

Tab8:AddToggle({
    Name = "View Car",
    Default = false,
    Callback = function(state)
        if not viewVehicleInitialized then
            viewVehicleInitialized = true
            return
        end

        character = player.Character or player.CharacterAdded:Wait()

        if state then
            if selectedVehicle and selectedVehicle.Parent and selectedVehicle.PrimaryPart then
                camera.CameraSubject = selectedVehicle.PrimaryPart
                Notify("Visualizando o veículo.")
            else
                Notify("Nenhum veículo selecionado.")
            end
        else
            humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                camera.CameraSubject = humanoid
                Notify("Câmera voltou para o jogador.")
            end
        end
    end
})

Tab8:AddButton({
    Name = "Teleportar para veículo",
    Callback = function()
        if selectedVehicle and selectedVehicle.Parent and selectedVehicle.PrimaryPart then
            character = player.Character or player.CharacterAdded:Wait()
            character:SetPrimaryPartCFrame(selectedVehicle.PrimaryPart.CFrame * CFrame.new(0, 5, 0))

            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "Teleportado para o veículo: " .. selectedVehicle.Name,
                Duration = 5
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "Nenhum veículo selecionado ou veículo inválido.",
                Duration = 5
            })
        end
    end
})

Tab8:AddButton({
    Name = "Destruir veiculo (BETA)",
    Callback = function()
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        hrp = character:WaitForChild("HumanoidRootPart")

        if not (selectedVehicle and selectedVehicle.Parent and selectedVehicle.PrimaryPart and humanoid and hrp) then
            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "Nenhum veículo selecionado ou personagem inválido.",
                Duration = 5
            })
            return
        end

        local driverSeat = nil
        for _, descendant in ipairs(selectedVehicle:GetDescendants()) do
            if descendant:IsA("VehicleSeat") then
                driverSeat = descendant
                break
            end
        end

        if not driverSeat then
            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "VehicleSeat não encontrado dentro do veículo.",
                Duration = 5
            })
            return
        end

        if driverSeat.Occupant then
            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "O veículo já está ocupado. Aguarde ele ficar livre.",
                Duration = 5
            })
            return
        end

        local originalVehicleCFrame = selectedVehicle.PrimaryPart.CFrame
        task.wait(0.5)

        local elapsedTime = 0
        local seatTimeout = 10
        local seatTargetCFrame = driverSeat.CFrame * CFrame.new(0, 3, 0)

        repeat
            humanoid.Sit = true
            character:SetPrimaryPartCFrame(seatTargetCFrame)
            task.wait(0.1)
            elapsedTime += 0.1
        until humanoid.Sit or elapsedTime >= seatTimeout

        if not humanoid.Sit then
            StarterGui:SetCore("SendNotification", {
                Title = "Sistema",
                Text = "Não foi possível sentar automaticamente no VehicleSeat.",
                Duration = 5
            })
            return
        end

        local boundaryCFrame = CFrame.new(-60.71, 3525.05, 55063)

        selectedVehicle:SetPrimaryPartCFrame(boundaryCFrame)
        character:SetPrimaryPartCFrame(boundaryCFrame * CFrame.new(0, 5, 0))

        local exitTime = 0
        repeat
            humanoid.Jump = true
            character:SetPrimaryPartCFrame(boundaryCFrame * CFrame.new(5, 5, 0))
            task.wait(0.5)
            exitTime += 0.5
        until driverSeat.Occupant ~= humanoid or exitTime >= 5

        character:SetPrimaryPartCFrame(originalVehicleCFrame * CFrame.new(0, 3, 0))

        Notify("Veiculo deletado.")
    end
})

local Tab10 = Window:MakeTab({"Misc", "menu"})

Tab10:AddSection({"Audio ALL"})

    

Tab10:AddSection({"Lag all (Funciona apenas em alguns executores)"})

local ClashType = "Iphone"

Tab10:AddDropdown({
    Name = "Tipo de clash",
    Options = {"Iphone", "Bomb"},
    Default = "Iphone",
    Callback = function(Value)
        ClashType = Value
    end
})

local isClash = false
local savedPos

Tab10:AddToggle({
    Name = "Ativar Clash",
    Default = false,
    Callback = function(v)
        isClash = v

        if v then
            savedPos = hrp.CFrame

            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0

            local targetCFrame
            local clickDetector

            if ClashType == "Iphone" then
                targetCFrame = CFrame.new(
                    -116.97915649414062, 19.925275802612305, 254.1663055419922
                )

                clickDetector =
                    workspace.WorkspaceCom["001_CommercialStores"]
                    .CommercialStorage1.Store.Tools:GetChildren()[4].ClickDetector

            elseif ClashType == "Bomb" then
                targetCFrame = CFrame.new(
                    -141.4248809814453, -26.350610733032227, 243.15170288085938
                )

                clickDetector =
                    workspace.WorkspaceCom["001_CriminalWeapons"].GiveTools.Bomb.ClickDetector
            end

            hrp.CFrame = targetCFrame

            task.spawn(function()
                while isClash do
                    fireclickdetector(clickDetector)
                    task.wait(0.1)
                end
            end)

        else
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50

            if savedPos then
                hrp.CFrame = savedPos
            end
        end
    end
})

Tab10:AddSection({"Skybox"})

local EMOTE_ASSET_ID = 93224413172183

local SkyboxList = {
    ["Coolkid"] = 18512801325,
    ["Turbers"] = 16510932762
}

local SkyNames = {}
for name in pairs(SkyboxList) do
    table.insert(SkyNames, name)
end

local ChangeBody = {
    {
        100839513065432,
        134162178631486,
        112132665744785,
        134568824619589,
        119032106683081,
        112098331348331
    }
}

local SelectedShirtID = nil
local SkyboxActive = false
local OriginalShirtId = nil
local DefaultBody = nil
local SkyboxEmoteTrack = nil

local function RefreshCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    desc = humanoid:GetAppliedDescription()
end

local function PlaySkyboxEmote()
    if SkyboxEmoteTrack then
        SkyboxEmoteTrack:Stop()
        SkyboxEmoteTrack = nil
    end

    local ok, objs = pcall(function()
        return game:GetObjects("rbxassetid://" .. EMOTE_ASSET_ID)
    end)

    if ok and objs and objs[1] and objs[1]:IsA("Animation") then
        SkyboxEmoteTrack = humanoid:LoadAnimation(objs[1])
        SkyboxEmoteTrack.Priority = Enum.AnimationPriority.Action4
        SkyboxEmoteTrack.Looped = true
        SkyboxEmoteTrack:Play()
        SkyboxEmoteTrack:AdjustSpeed(0.001)
    end
end

local function StopSkyboxEmote()
    if SkyboxEmoteTrack then
        SkyboxEmoteTrack:Stop()
        SkyboxEmoteTrack = nil
    end
end

local function ApplySkybox()
    desc = humanoid:GetAppliedDescription()

    Remotes.ChangeCharacterBody:InvokeServer(unpack(ChangeBody))

    if SelectedShirtID and desc.Shirt ~= SelectedShirtID then
        Remotes.WearShirt:InvokeServer(SelectedShirtID)
    end

    PlaySkyboxEmote()
end

player.CharacterAdded:Connect(function()
    task.wait(0.4)
    RefreshCharacter()

    if SkyboxActive and SelectedShirtID then
        ApplySkybox()
    end
end)

Tab10:AddDropdown({
    Name = "Selecionar Skybox:",
    Options = SkyNames,
    Callback = function(value)
        SelectedShirtID = SkyboxList[value]
    end
})

Tab10:AddToggle({
    Name = "Skybox",
    Description = "Recomendo salvar o personagem antes de ligar.",
    Default = false,
    Callback = function(v)
        if v then
            RefreshCharacter()
            SkyboxActive = true

            desc = humanoid:GetAppliedDescription()
            OriginalShirtId = desc.Shirt

            DefaultBody = {
                {
                    desc.Torso,
                    desc.RightArm,
                    desc.LeftArm,
                    desc.RightLeg,
                    desc.LeftLeg,
                    desc.Head
                }
            }

            ApplySkybox()
        else
            SkyboxActive = false

            StopSkyboxEmote()

            desc = humanoid:GetAppliedDescription()

            if OriginalShirtId and desc.Shirt ~= OriginalShirtId then
                Remotes.WearShirt:InvokeServer(OriginalShirtId)
            end

            if DefaultBody then
                Remotes.ChangeCharacterBody:InvokeServer(unpack(DefaultBody))
            end
        end
    end
})

Tab10:AddSection({"Props"})

local propsCache
local propsFolder
local propsConnection
local dropdownConnection

local propsEnabled = false
local selectedValue = nil
local whitelist = {}
local lastList = {}

local function setupFolder()
    propsFolder = workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_TrafficCones")
end

setupFolder()

local function getPropsList()
    local list = {}
    if propsFolder then
        for _, v in ipairs(propsFolder:GetChildren()) do
            if v.Name ~= "Dont Delete" then
                table.insert(list, v.Name)
            end
        end
    end
    table.sort(list)
    return list
end

local function listsAreDifferent(a, b)
    if #a ~= #b then return true end
    for i = 1, #a do
        if a[i] ~= b[i] then
            return true
        end
    end
    return false
end

local pWhitelist = Tab10:AddDropdown({ 
    Name = "Selecionar Prop",
    Options = getPropsList(),
    Default = "",
    Flag = "props_select",
    Callback = function(Value)
        selectedValue = Value
    end
})

lastList = getPropsList()

dropdownConnection = RunService.Heartbeat:Connect(function()
    if not propsFolder or not propsFolder.Parent then
        setupFolder()
    end

    local newList = getPropsList()

    if listsAreDifferent(lastList, newList) then
        lastList = newList
        pWhitelist:Set(newList)
    end
end)

Tab10:AddButton({
    Name = "Salvar na Whitelist",
    Callback = function()
        if selectedValue and selectedValue ~= "" then
            if not table.find(whitelist, selectedValue) then
                table.insert(whitelist, selectedValue)
            end
        end
    end
})

Tab10:AddButton({
    Name = "Limpar Whitelist",
    Callback = function()
        whitelist = {}
    end
})

local DeletePropts = Tab10:AddToggle({
    Name = "Deletar todas as props (VISUAL)",
    Default = false,
    Callback = function(state)
        propsEnabled = state

        if propsEnabled then
            if not propsCache then
                propsCache = Instance.new("Folder")
                propsCache.Name = "Props_SpecterX"
                propsCache.Parent = ReplicatedStorage
            end

            if not propsConnection then
                propsConnection = RunService.Heartbeat:Connect(function()
                    if not propsEnabled then return end
                    if not propsFolder or not propsFolder.Parent then
                        setupFolder()
                    end

                    for _, v in ipairs(propsFolder:GetChildren()) do
                        if v.Name ~= "Dont Delete" and not table.find(whitelist, v.Name) then
                            v.Parent = propsCache
                        end
                    end
                end)
            end
        else
            if propsConnection then
                propsConnection:Disconnect()
                propsConnection = nil
            end

            if propsCache and propsFolder then
                for _, v in ipairs(propsCache:GetChildren()) do
                    v.Parent = propsFolder
                end
            end
        end
    end
})


local AntiLagSectin = Tab10:AddSection({"Anti-lag"})

Tab10:AddButton({
	Name = "Antilag",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/kfgSQYFM"))()
	end
})

local ServerSection = Tab10:AddSection({"Enter Server"})

local PlaceId = nil
local JobId = nil

Tab10:AddTextBox({ 
    Name = "Teleport Code:",  
    PlaceholderText = "Cole o código aqui", 
    Callback = function(Value)
        Value = Value:gsub("%s+", "")

        local pId = Value:match("TeleportToPlaceInstance%((%d+),")

        local jId = Value:match(',"([%w%-]+)"%)')

        if pId and jId then
            PlaceId = tonumber(pId)
            JobId = jId
        else
            PlaceId = nil
            JobId = nil
        end
    end
})

Tab10:AddButton({"Entrar",function()
        if not PlaceId or not JobId then
            Notify("Código inválido ou não detectado.")
            return
        end

        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId)
        end)

        if not success then
            Notify("Erro ao teleportar:", err)
        end
    end
})

Tab10:AddSection({ "Protection" })

Tab10:AddToggle({
    Name = "Anti-Hacker",
    Default = false,
    Callback = function(state)

        if _G.AntiHackConnection then
            _G.AntiHackConnection:Disconnect()
            _G.AntiHackConnection = nil
        end

        if state then
            _G.AntiHackConnection = RunService.Heartbeat:Connect(function()

                local playerBall = "Soccer" .. player.Name

                for _, obj in ipairs(ServerBalls:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local ignore = false
                        local current = obj

                        while current do
                            if current.Name == "Dont Delete" or current.Name == playerBall then
                                ignore = true
                                break
                            end
                            current = current.Parent
                        end

                        if not ignore then
                            obj.CanCollide = false
                        end
                    end
                end

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player then
                        local char = plr.Character
                        if char then
                            local couch = char:FindFirstChild("Couch")
                            if couch then
                                for _, v in ipairs(couch:GetDescendants()) do
                                    if v:IsA("Seat") or v:IsA("VehicleSeat") then
                                        v.Disabled = true
                                    end
                                end
                            end
                        end
                    end
                end

            end)
        end
    end
})

local antiSitConnection
local antiSitEnabled = false

Tab10:AddToggle({
    Name = "Anti-Sit",
    Default = false,
    Callback = function(state)
        antiSitEnabled = state

        local function applySit(char)
            local humanoid = char:WaitForChild("Humanoid")

            if antiSitEnabled then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                humanoid.Sit = false
            else
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            end
        end

        if state then
            if player.Character then
                applySit(player.Character)
            end

            if antiSitConnection then
                antiSitConnection:Disconnect()
            end

            antiSitConnection = player.CharacterAdded:Connect(applySit)
        else
            if antiSitConnection then
                antiSitConnection:Disconnect()
                antiSitConnection = nil
            end

            if player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                end
            end
        end
    end
})

Tab10:AddToggle({
    Name = "Anti-AFK",
    Default = true,
    Callback = function(state)
        if _G._AntiAFK then _G._AntiAFK:Disconnect() _G._AntiAFK = nil end
        if state then
            _G._AntiAFK = game:GetService("RunService").Heartbeat:Connect(function()
                RefreshCharacter()
                if character then
                    if hrp then
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0.00001)
                    end
                end
            end)
        end
    end
})

local Tab11 = Window:MakeTab({"Scripts", "scroll"})

Tab11:AddButton({"Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
end})

Tab11:AddButton({"Dex", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end})

Tab11:AddButton({"FE EMOTE", function(Value)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
end})

local SpecterSection = Tab11:AddSection({"Specter"})

Tab11:AddButton({"Black Hole - Specter", function(Value)
    loadstring(game:HttpGet("https://pastebin.com/raw/3L60nw07"))()
end})

Tab11:AddButton({"SpecterFly - Specter", function(Value)
    loadstring(game:HttpGet("https://pastebin.com/raw/wYg1Ftw1"))()
end})


Tab11:AddButton({"FreeCam - Specter ", function(Value)
    loadstring(game:HttpGet("https://pastebin.com/raw/fCpdfTqu"))()
end})

Tab11:AddButton({"ShiftLock - Specter", function(Value)
    loadstring(game:HttpGet("https://pastebin.com/raw/FLQ8735N"))()
end})