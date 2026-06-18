local webhook = loadstring(game:HttpGet("https://pastebin.com/raw/AJQaXHck"))()
local WHITELIST_URL = "https://raw.githubusercontent.com/DrakonDev/.TheCleaner/refs/heads/main/resources/whitelist.lua"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local backpack = player.Backpack
local userId = player.UserId

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character and character:FindFirstChild("HumanoidRootPart")

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

local Tab2 = Window:MakeTab({"None", "rocket"})

local coinsFolder = workspace:WaitForChild("spawnedCoins"):WaitForChild("Valley")

local farming = false
local connection
local currentIndex = 1
local coins = {}

local delayTime = 0.3
local lastTeleport = 0
local savedCFrame

local fSpeed = humanoid.WalkSpeed
local fJump = humanoid.JumpPower

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist
rayParams.FilterDescendantsInstances = {character}

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	rayParams.FilterDescendantsInstances = {character}
end)

local function refreshCoins()
	table.clear(coins)
	for _, v in ipairs(coinsFolder:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(coins, v)
		end
	end
end

local function keepAboveGround(position)
	local ray = workspace:Raycast(position, Vector3.new(0, -200, 0), rayParams)
	if ray then
		return Vector3.new(position.X, ray.Position.Y + 1, position.Z)
	end
	return position
end

local function stabilize()
	humanoid:ChangeState(Enum.HumanoidStateType.Running)
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
end

local function startFarm()
	if farming then return end
	farming = true

	savedCFrame = character:GetPivot()

	refreshCoins()
	currentIndex = 1
	lastTeleport = 0

	connection = RunService.PreSimulation:Connect(function()
		if not farming then return end
		if tick() - lastTeleport < delayTime then return end
		lastTeleport = tick()

		if #coins == 0 then
			refreshCoins()
			return
		end

		local coin = coins[currentIndex]
		if not coin or not coin.Parent then
			refreshCoins()
			currentIndex = 1
			return
		end

		local adjustedPosition = keepAboveGround(coin.Position)
		character:PivotTo(CFrame.new(adjustedPosition))

		stabilize()

        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0

		currentIndex += 1
		if currentIndex > #coins then
			currentIndex = 1
		end
	end)
end

local function stopFarm()
	if not farming then return end
	farming = false

    humanoid.WalkSpeed = fSpeed
    humanoid.JumpPower = fJump

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if savedCFrame then
		character:PivotTo(savedCFrame)
	end

	stabilize()
end

Tab2:AddToggle({
	Name = "Auto Farm",
	Default = false,
	Callback = function(state)
		if state then
			startFarm()
		else
			stopFarm()
		end
	end
})

local function getOwnedIslands()
    local owned = {}
    local folder = player:WaitForChild("foundIslands")

    for _, island in ipairs(folder:GetChildren()) do
        owned[island.Name] = true
    end

    return owned, #folder:GetChildren()
end

local function unlockIslands()
    local ownedTable, ownedCount = getOwnedIslands()
    local unlockFolder = Workspace:WaitForChild("islandUnlockParts")

    local totalIslands = #unlockFolder:GetChildren()

    if ownedCount > totalIslands then
        return
    end

    if ownedCount == totalIslands then
        return
    end

    for _, islandPart in ipairs(unlockFolder:GetChildren()) do
        if not ownedTable[islandPart.Name] and islandPart:IsA("BasePart") then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = islandPart.CFrame
                task.wait(0.3)
            end
        end
    end
end

Tab2:AddButton({
	Name = "Unlock All Island",
	Default = false,
	Callback = function()
		unlockIslands()
	end
})

local function getLastIsland()
    local unlockFolder = Workspace:WaitForChild("islandUnlockParts")

    local highestIsland = nil
    local highestY = -math.huge

    for _, island in ipairs(unlockFolder:GetChildren()) do
        if island:IsA("BasePart") then
            
            -- Raycast para cima
            local rayOrigin = island.Position
            local rayDirection = Vector3.new(0, 1000, 0) -- 1000 studs pra cima
            
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            rayParams.FilterDescendantsInstances = {island}
            
            local result = Workspace:Raycast(rayOrigin, rayDirection, rayParams)

            -- Se não bater em nada acima
            if not result then
                local yPos = island.Position.Y
                
                if yPos > highestY then
                    highestY = yPos
                    highestIsland = island
                end
            end
        end
    end

    return highestIsland
end

local function teleportToLastIsland()
    local island = getLastIsland()
    if not island then
        warn("No valid island found.")
        return
    end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = island.CFrame + Vector3.new(0, 5, 0)
    end
end

Tab2:AddButton({
    Name = "TP LAST ISLAND",
    Callback = function()
        teleportToLastIsland()
    end
})