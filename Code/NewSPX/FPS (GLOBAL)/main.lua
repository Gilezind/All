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

local Tab2 = Window:MakeTab({"Aimbot", "rocket"})

local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimEnabled = false
local showFov = false
local fovRadius = 100
local aimPart = "HumanoidRootPart"
local wallCheck = false
local teamCheck = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Filled = false

local function IsAlive(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function IsVisible(part)
    if not wallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(origin, direction, raycastParams)
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

local function GetClosestPlayer()
    local closest = nil
    local shortest = fovRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimPart) and IsAlive(player.Character) then
            if teamCheck and player.Team == LocalPlayer.Team then continue end

            local part = player.Character[aimPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)

            if onScreen and IsVisible(part) then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = fovRadius
    FOVCircle.Visible = showFov

    if aimEnabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[aimPart].Position)
        end
    end
end)

Tab2:AddSection("Main")

Tab2:AddToggle({
Name = "Enabled Aimbot",
Default = false,
Callback = function(state)
    aimEnabled = state
end
})

Tab2:AddSlider({
Name = "FOV",
Min = 1,
Max = 500,
Increase = 1,
Default = 100,
Callback = function(Value)
    fovRadius = Value
end
})

Tab2:AddSection("Others")

Tab2:AddDropdown({
Name = "Aimbot Area",
Options = {"Head", "Body", "Legs"},
Default = "Body",
Flag = "dropdown teste",
Callback = function(Value)
    if Value == "Head" then
        aimPart = "Head"
    elseif Value == "Body" then
        aimPart = "HumanoidRootPart"
    elseif Value == "Legs" then
        aimPart = "LeftFoot"
    end
end
})

Tab2:AddToggle({
Name = "Wall Check",
Default = false,
Callback = function(state)
    wallCheck = state
end
})

Tab2:AddToggle({
Name = "Team Check",
Default = false,
Callback = function(state)
    teamCheck = state
end
})

Tab2:AddToggle({
Name = "Show FOV",
Default = false,
Callback = function(state)
    showFov = state
end
})

local espEnabled = false
local boxEnabled = false
local lineEnabled = false
local eTeamCheck = false
local healthEnabled = false
local espColor = Color3.fromRGB(255,255,255)

local espCache = {}

local colors = {
    White = Color3.fromRGB(255,255,255),
    Red = Color3.fromRGB(255,0,0),
    Green = Color3.fromRGB(0,255,0),
    Blue = Color3.fromRGB(0,0,255),
    Yellow = Color3.fromRGB(255,255,0),
    Purple = Color3.fromRGB(170,0,255)
}

local function removeESP(player)
    if espCache[player] then
        for _,v in pairs(espCache[player]) do
            if v then
                pcall(function()
                    v:Remove()
                end)
            end
        end
        espCache[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    removeESP(player)

    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Filled = false

    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1

    local text = Drawing.new("Text")
    text.Visible = false
    text.Size = 13
    text.Center = true
    text.Outline = true

    espCache[player] = {
        Box = box,
        Line = line,
        Text = text
    }
end

for _,player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(function()
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = espCache[player]
            if not esp then
                createESP(player)
                esp = espCache[player]
            end

            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if espEnabled and character and hrp and humanoid and humanoid.Health > 0 then
                if eTeamCheck and player.Team == LocalPlayer.Team then
                    esp.Box.Visible = false
                    esp.Line.Visible = false
                    esp.Text.Visible = false
                    continue
                end

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local size = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0)).Y)
                    local width = math.abs(size / 2)

                    esp.Box.Size = Vector2.new(width, math.abs(size))
                    esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - math.abs(size) / 2)
                    esp.Box.Color = espColor
                    esp.Box.Visible = boxEnabled

                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Line.To = Vector2.new(pos.X, pos.Y)
                    esp.Line.Color = espColor
                    esp.Line.Visible = lineEnabled

                    if healthEnabled then
                        esp.Text.Text = tostring(math.floor(humanoid.Health))
                        esp.Text.Position = Vector2.new(pos.X, pos.Y - (math.abs(size) / 2) - 15)
                        esp.Text.Color = espColor
                        esp.Text.Visible = true
                    else
                        esp.Text.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Line.Visible = false
                    esp.Text.Visible = false
                end
            else
                if esp then
                    esp.Box.Visible = false
                    esp.Line.Visible = false
                    esp.Text.Visible = false
                end
            end
        end
    end
end)

local Tab3 = Window:MakeTab({"Esp", "eye"})

Tab3:AddSection("ESP")

Tab3:AddDropdown({
    Name = "ESP Color",
    Options = {"White", "Red", "Green", "Blue", "Yellow", "Purple"},
    Default = "White",
    Flag = "Dropdown",
    Callback = function(Value)
        espColor = colors[Value] or Color3.fromRGB(255,255,255)
    end
})

Tab3:AddToggle({
    Name = "Enabled ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
    end
})

Tab3:AddToggle({
    Name = "Enabled Box",
    Default = false,
    Callback = function(state)
        boxEnabled = state
    end
})

Tab3:AddToggle({
    Name = "Enabled Lines",
    Default = false,
    Callback = function(state)
        lineEnabled = state
    end
})

Tab3:AddSection("Others")

Tab3:AddToggle({
    Name = "Team Check",
    Default = false,
    Callback = function(state)
        eTeamCheck = state
    end
})

Tab3:AddToggle({
    Name = "Player Health",
    Default = false,
    Callback = function(state)
        healthEnabled = state
    end
})