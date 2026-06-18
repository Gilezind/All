local webhook = loadstring(game:HttpGet("https://pastebin.com/raw/AJQaXHck"))()

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local userId = player.UserId

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

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

local function UpdateReferences(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
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
    Title = "SpecterX | Blox Fruits",
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

Tab1:AddParagraph({
    "Hey, " ..player.Name .. "!"
})

Tab1:AddParagraph({
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

Tab1:AddParagraph({
    "Executor: " .. executorName
})

