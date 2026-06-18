local RunService = game:GetService("RunService") or game:FindFirstDescendant("RunService")
local Players = game:GetService("Players") or game:FindFirstDescendant("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or game:FindFirstDescendant("VirtualInputManager")

local player = Players.LocalPlayer

local Cooldown = tick()
local IsParried = false
local Connection = nil

local Partied

local function GetBall()
  for _, Ball in ipairs(workspace.Balls:GetChildren()) do
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
  for i = 1, 35 do
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
  end
end

local function isTarget(ball)
    if not ball then return false end
    return ball:GetAttribute("target") == player.Name
end

workspace.Balls.ChildAdded:Connect(function()
    local Ball = GetBall()
    if not Ball then return end
    ResetConnection()
    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        Parried = false
    end)
end)

RunService.PreSimulation:Connect(function()
    local Ball, HRP = GetBall(), player.Character.HumanoidRootPart
    if not Ball or not HRP then
        return
    end
    
    local Speed = Ball.zoomies.VectorVelocity.Magnitude
    local Distance = (HRP.Position - Ball.Position).Magnitude
    
    if isTarget(Ball) and not Parried and Distance / Speed <= 0.55 then
        Parry()
        Parried = true
        Cooldown = tick()
        
        if (tick() - Cooldown) >= 0.1 then
            Parried = false
        end
    end
end)

print("Loaded")