-- ✅ Grow a Garden – Mutation Machine ESP Premium UI

local Players      = game:GetService("Players")
local workspace    = game:GetService("Workspace")
local Debris       = game:GetService("Debris")
local UserInput    = game:GetService("UserInputService")
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

-- 🎯 Accurate pet mutation data (from Grow a Garden Wiki)
local mutations = {
    { name="Shiny",    weight=31.15, rarity="Common",     color=Color3.fromRGB(180,180,180) },
    { name="Inverted", weight=15.58, rarity="Uncommon",   color=Color3.fromRGB(90,170,255) },
    { name="Frozen",   weight=9.35,  rarity="Rare",       color=Color3.fromRGB(0,200,255) },
    { name="Windy",    weight=9.35,  rarity="Rare",       color=Color3.fromRGB(100,255,255) },
    { name="Golden",   weight=6.23,  rarity="Epic",       color=Color3.fromRGB(255,215,0) },
    { name="Mega",     weight=6.23,  rarity="Epic",       color=Color3.fromRGB(255,140,0) },
    { name="Tiny",     weight=6.23,  rarity="Epic",       color=Color3.fromRGB(200,140,255) },
    { name="Tranquil", weight=3.12,  rarity="Legendary",  color=Color3.fromRGB(120,255,200) },
    { name="IronSkin", weight=3.12,  rarity="Legendary",  color=Color3.fromRGB(200,200,200) },
    { name="Radiant",  weight=3.12,  rarity="Legendary",  color=Color3.fromRGB(255,255,160) },
    { name="Rainbow",  weight=3.12,  rarity="Legendary",  color=Color3.fromRGB(255,80,255) },
    { name="Shocked",  weight=3.12,  rarity="Legendary",  color=Color3.fromRGB(255,255,100) },
    { name="Ascended", weight=0.31,  rarity="Mythic",     color=Color3.fromRGB(255,50,50) },
}

-- 🎲 Weighted random picker
local function getRandomMutation()
    local total = 0
    for _, m in ipairs(mutations) do total += m.weight end
    local pick = math.random() * total
    local sum = 0
    for _, m in ipairs(mutations) do
        sum += m.weight
        if pick <= sum then return m end
    end
    return mutations[#mutations]
end

-- 🎰 GUI Creation
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "MutationMachineUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,180)
frame.Position = UDim2.new(0.5,-150,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "🌟 Mutation Panel Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,255,140)

local mutationLabel = Instance.new("TextLabel", frame)
mutationLabel.Position = UDim2.new(0,0,0.35,0)
mutationLabel.Size = UDim2.new(1,0,0.3,0)
mutationLabel.BackgroundTransparency = 1
mutationLabel.Font = Enum.Font.GothamBold
mutationLabel.TextSize = 22
mutationLabel.TextColor3 = Color3.new(1,1,1)
mutationLabel.Text = "Press ROLL"

local rollBtn = Instance.new("TextButton", frame)
rollBtn.Position = UDim2.new(0.1,0,0.65,0)
rollBtn.Size = UDim2.new(0.8,0,0.15,0)
rollBtn.Text = "🎲 ROLLBY"
rollBtn.Font = Enum.Font.GothamBold
rollBtn.TextSize = 18
rollBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
rollBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", rollBtn).CornerRadius = UDim.new(0,8)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.new(0.1,0,0.82,0)
toggleBtn.Size = UDim2.new(0.8,0,0.12,0)
toggleBtn.Text = "Auto-Roll: ON"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)

local autoRoll = true
toggleBtn.MouseButton1Click:Connect(function()
    autoRoll = not autoRoll
    toggleBtn.Text = autoRoll and "Auto-Roll: ON" or "Auto-Roll: OFF"
    toggleBtn.BackgroundColor3 = autoRoll and Color3.fromRGB(50,200,100) or Color3.fromRGB(180,50,50)
end)

-- 🪄 Show ESP above mutation machine
local function updateESP(text, color)
    local NPCS = workspace:FindFirstChild("NPCS")
    local machine = NPCS and NPCS:FindFirstChild("PetMutationMachine")
    if not machine then return end
    local base = machine:FindFirstChildWhichIsA("BasePart")
    if not base then return end

    local old = machine:FindFirstChild("MutationESP")
    if old then old:Destroy() end

    local esp = Instance.new("BillboardGui", machine)
    esp.Name = "MutationESP"
    esp.Adornee = base
    esp.Size = UDim2.new(0,200,0,60)
    esp.StudsOffset = Vector3.new(0,4,0)
    esp.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel", esp)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.TextColor3 = color
    lbl.Text = text
end

-- ✨ Sparkle when Ascended hit
local function sparkle()
    local NPCS = workspace:FindFirstChild("NPCS")
    local machine = NPCS and NPCS:FindFirstChild("PetMutationMachine")
    if not machine then return end

    local emitter = Instance.new("ParticleEmitter", machine)
    emitter.Color = ColorSequence.new(Color3.fromRGB(255,50,50))
    emitter.LightEmission = 1
    emitter.Rate = 150
    emitter.Lifetime = NumberRange.new(1)
    emitter.Speed = NumberRange.new(2)
    emitter.Size = NumberSequence.new(0.7)
    Debris:AddItem(emitter, 2)
end

-- 🔁 Rolling logic
local isRolling = false
local function rollOnce()
    local m = getRandomMutation()
    local txt = m.name.." ["..m.rarity.."]"
    mutationLabel.Text = txt
    mutationLabel.TextColor3 = m.color
    updateESP(txt, m.color)
    if m.name == "Ascended" then sparkle() end
    return m.name
end

local function startRoll()
    if isRolling then return end
    isRolling = true
    coroutine.wrap(function()
        repeat
            local res = rollOnce()
            wait(0.1)
        until res == "Ascended" or not autoRoll
        isRolling = false
    end)()
end

rollBtn.MouseButton1Click:Connect(startRoll)
