local webhook = loadstring(game:HttpGet("https://pastebin.com/raw/AJQaXHck"))()
local WHITELIST_URL = "https://raw.githubusercontent.com/DrakonDev/.TheCleaner/refs/heads/main/resources/whitelist.lua"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

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

local Tab2 = Window:MakeTab({"Auto-Parry", "rocket"})

Tab2:AddSection({"Parry"})

local Balls = workspace:WaitForChild("Balls")

local Cooldown = tick()
local Parried = false
local Partied

local Connection = nil
local PreSimConnection = nil
local Enabled = false
local ChildAddedConnection = nil

local function GetBall()
    for _, Ball in ipairs(Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
end

local function ResetConnection()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

local function Parry()
    for i = 1, 25 do
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    end
end

local function IsTarget()
    local Ball = GetBall()

    return Ball
        and Ball:GetAttribute("target") == player.Name
        and player.Character
        and player.Character:FindFirstChild("Highlight")
end

local function Start()
    if Enabled then return end
    Enabled = true

    ChildAddedConnection = Balls.ChildAdded:Connect(function()
        if not Enabled then return end
        local Ball = GetBall()
        if not Ball then return end

        ResetConnection()

        Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
            Parried = false
        end)
    end)

    PreSimConnection = RunService.PreSimulation:Connect(function()
        if not Enabled then return end

        local Ball = GetBall()
        local HRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        if not Ball or not HRP then
            return
        end

        local Speed = Ball.zoomies.VectorVelocity.Magnitude
        local Distance = (HRP.Position - Ball.Position).Magnitude

        if IsTarget() and not Parried and Distance / Speed <= 0.60 then
            Parry()
            Parried = true
            Cooldown = tick()

            if (tick() - Cooldown) >= 1 then
                Partied = false
            end
        end
    end)
end

local function Stop()
    Enabled = false
    ResetConnection()

    if ChildAddedConnection then
        ChildAddedConnection:Disconnect()
        ChildAddedConnection = nil
    end

    if PreSimConnection then
        PreSimConnection:Disconnect()
        PreSimConnection = nil
    end
end

Tab2:AddToggle({
    Name = "Auto-Parry",
    Default = false,
    Callback = function(state)
        if state then
            Start()
        else
            Stop()
        end
    end
})

local speedActive = false
local connection
local defaultSpeed = humanoid.WalkSpeed

Tab2:AddToggle({
    Name = "Speed-Hack",
    Default = false,
    Callback = function(state)
        speedActive = state

        if state then
            connection = RunService.RenderStepped:Connect(function()
                humanoid.WalkSpeed = 100
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            humanoid.WalkSpeed = defaultSpeed
        end
    end
})