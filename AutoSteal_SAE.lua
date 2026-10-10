-- ============================================================
-- AUTO STEAL — STEAL AN EGG (Standalone)
-- Draggable GUI | On/Off Toggle | Auto Move + Steal Loop
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local Workspace   = game:GetService("Workspace")

-- ── Wait for character ──────────────────────────────────────
if not localPlayer.Character then
    localPlayer.CharacterAdded:Wait()
end

-- ── State ───────────────────────────────────────────────────
local State = {
    AutoSteal   = false,
    StealBusy   = false,
    Status      = "🔴 Off",
    Steals      = 0,
    MoveBusy    = false,
}

local stealThread  = nil
local connections  = {}

-- ── Helpers ─────────────────────────────────────────────────
local function isAlive()
    local char = localPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local function getRootPart()
    local char = localPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function teleportTo(position, offset)
    local root = getRootPart()
    if not root then return false end
    local target = position + Vector3.new(0, offset or 4, 0)
    local ok = pcall(function()
        root.CFrame = CFrame.new(target)
        root.AssemblyLinearVelocity = Vector3.zero
    end)
    return ok
end

-- ── Find all available eggs in Workspace ────────────────────
-- Logic mirrors: fns.fn420 / yM — scans Workspace.Eggs folders
-- for SpawnedEgg models with an EggLootPrompt ProximityPrompt
local function getEggPosition(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model.Position end
    local ok, cf = pcall(function() return model:GetPivot() end)
    if ok and typeof(cf) == "CFrame" then return cf.Position end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then return d.Position end
    end
    return nil
end

local function findEggPrompt(model)
    if not model then return nil end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d:HasTag("EggLootPrompt") then
            return d
        end
    end
    return nil
end

local function getBasePart(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then return d end
    end
    return nil
end

local function scanEggs()
    local eggs = {}
    local eggsFolder = Workspace:FindFirstChild("Eggs")
    if not eggsFolder then return eggs end

    for _, zone in ipairs(eggsFolder:GetChildren()) do
        if zone:IsA("Folder") then
            for _, child in ipairs(zone:GetChildren()) do
                -- child is SpawnedEgg model directly or contains one
                local spawnedEgg
                if child:IsA("Model") and child.Name == "SpawnedEgg" then
                    spawnedEgg = child
                else
                    local found = child:FindFirstChild("SpawnedEgg")
                    if found and found:IsA("Model") then
                        spawnedEgg = found
                    end
                end

                if spawnedEgg then
                    local prompt    = findEggPrompt(spawnedEgg)
                    local basePart  = getBasePart(spawnedEgg)
                    local position  = getEggPosition(spawnedEgg)

                    -- prompt must exist and be Enabled (mirrors Dt_4.Enabled check)
                    if prompt and prompt.Enabled and position then
                        table.insert(eggs, {
                            Model    = spawnedEgg,
                            Prompt   = prompt,
                            Position = position,
                            Zone     = zone.Name,
                        })
                    end
                end
            end
        end
    end
    return eggs
end

-- ── Pick closest egg (mirrors fns.fn235 / xY) ───────────────
local function pickClosestEgg(eggs)
    local root = getRootPart()
    if not root then return nil, 0 end
    local best, bestDist
    for _, egg in ipairs(eggs) do
        local dist = (egg.Position - root.Position).Magnitude
        if not bestDist or dist < bestDist then
            best, bestDist = egg, dist
        end
    end
    return best, bestDist or 0
end

-- ── Fire ProximityPrompt (mirrors x5 / fn1252) ──────────────
local function firePrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then
        return false
    end
    if type(fireproximityprompt) ~= "function" then
        return false
    end
    return (pcall(fireproximityprompt, prompt))
end

-- ── Move to egg and steal it ────────────────────────────────
local function stealEgg(egg)
    if not egg or not egg.Prompt or not egg.Prompt.Enabled then
        return false
    end

    -- Teleport close to egg (mirrors yI — moves HumanoidRootPart)
    local reached = teleportTo(egg.Position, 3)
    if not reached then return false end

    -- Brief settle so server registers position
    task.wait(0.25)

    -- Confirm prompt still valid after move
    if not egg.Prompt or not egg.Prompt.Enabled or not egg.Prompt.Parent then
        return false
    end

    -- Fire the loot prompt (mirrors x5 / fireproximityprompt)
    local fired = firePrompt(egg.Prompt)
    if fired then
        task.wait(0.4)
        State.Steals += 1
        return true
    end
    return false
end

-- ── Status updater (set on GUI label) ───────────────────────
local StatusLabel  -- filled in after GUI build

local function setStatus(text)
    State.Status = text
    if StatusLabel then
        StatusLabel.Text = text
    end
end

-- ── Main steal loop (mirrors main steal while isAlive() loop)─
local function stealLoop()
    -- mirrors: stealWorkerAlive gate + isAlive check each beat
    while State.AutoSteal and isAlive() do

        -- Check inventory / carry state (simplified — no server data)
        if not State.AutoSteal then break end

        -- Scan eggs this tick
        local eggs = scanEggs()

        if #eggs == 0 then
            -- No eggs available this scan, wait and retry
            setStatus("🟡 Waiting for eggs...")
            task.wait(1)
        else
            -- Pick closest (mirrors normalStealTargetAvailable + xY)
            local target, dist = pickClosestEgg(eggs)

            if not target then
                setStatus("🟡 No target found")
                task.wait(1)
            else
                local zoneName = target.Zone or "?"
                setStatus(("🎯 Moving → %s (%.0f studs)"):format(zoneName, dist))

                State.StealBusy = true
                local success = stealEgg(target)
                State.StealBusy = false

                if success then
                    setStatus(("✅ Stolen! Total: %d"):format(State.Steals))
                    task.wait(0.6)   -- mirrors yd.interval default 0.6s
                else
                    setStatus("⚠️ Steal failed, retrying...")
                    task.wait(0.5)
                end
            end
        end

        RunService.Heartbeat:Wait()
    end

    -- Loop exited
    State.StealBusy = false
    if not State.AutoSteal then
        setStatus("🔴 Off")
    end
end

-- ── Toggle Auto Steal (mirrors AutoStealToggle:OnChanged) ────
local function setAutoSteal(enabled)
    State.AutoSteal = enabled

    if enabled then
        if not isAlive() then
            State.AutoSteal = false
            setStatus("❌ Character not alive")
            return
        end
        setStatus("🟡 Waiting for target...")
        -- Cancel previous thread if any
        if stealThread then
            task.cancel(stealThread)
            stealThread = nil
        end
        stealThread = task.spawn(stealLoop)
    else
        State.AutoSteal = false
        if stealThread then
            task.cancel(stealThread)
            stealThread = nil
        end
        setStatus("🔴 Off")
    end
end

-- ── Watch for death → stop steal (mirrors onAutoStealDeath) ──
do
    local function watchChar(character)
        local hum = character:WaitForChild("Humanoid", 5)
        if not hum then return end
        hum.Died:Connect(function()
            if State.AutoSteal then
                setStatus("💀 Died — paused")
                State.AutoSteal = false
                if stealThread then
                    task.cancel(stealThread)
                    stealThread = nil
                end
                -- Auto-resume after respawn (mirrors death recovery)
                task.delay(3, function()
                    if not State.AutoSteal then
                        -- do not auto-resume; let user re-toggle
                        setStatus("🔴 Off (respawned)")
                    end
                end)
            end
        end)
    end

    if localPlayer.Character then
        task.spawn(watchChar, localPlayer.Character)
    end
    connections[#connections + 1] = localPlayer.CharacterAdded:Connect(function(char)
        task.spawn(watchChar, char)
    end)
end

-- ════════════════════════════════════════════════════════════
-- GUI
-- ════════════════════════════════════════════════════════════
local guiParent = nil
pcall(function()
    local hui = gethui and gethui()
    if hui then guiParent = hui end
end)
if not guiParent then
    pcall(function() guiParent = game:GetService("CoreGui") end)
end
if not guiParent then
    guiParent = localPlayer:WaitForChild("PlayerGui")
end

-- Destroy old instance if re-executing
local old = guiParent:FindFirstChild("AutoStealGUI")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "AutoStealGUI"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Parent          = guiParent

-- ── Main Frame ───────────────────────────────────────────────
local MainFrame = Instance.new("Frame")
MainFrame.Name              = "MainFrame"
MainFrame.Size              = UDim2.new(0, 260, 0, 160)
MainFrame.Position          = UDim2.new(0.5, -130, 0.05, 0)
MainFrame.BackgroundColor3  = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel   = 0
MainFrame.ClipsDescendants  = true
MainFrame.Parent            = ScreenGui

-- rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent       = MainFrame

-- thin accent border
local stroke = Instance.new("UIStroke")
stroke.Color      = Color3.fromRGB(120, 80, 255)
stroke.Thickness  = 1.5
stroke.Parent     = MainFrame

-- ── Title bar (drag handle) ──────────────────────────────────
local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 20, 50)
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 2
TitleBar.Parent           = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent       = TitleBar

-- cover bottom corners of title bar
local titleCoverBottom = Instance.new("Frame")
titleCoverBottom.Size              = UDim2.new(1, 0, 0, 10)
titleCoverBottom.Position          = UDim2.new(0, 0, 1, -10)
titleCoverBottom.BackgroundColor3  = Color3.fromRGB(28, 20, 50)
titleCoverBottom.BorderSizePixel   = 0
titleCoverBottom.ZIndex            = 2
titleCoverBottom.Parent            = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size              = UDim2.new(1, -40, 1, 0)
TitleLabel.Position          = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text              = "🥚 Auto Steal — SAE"
TitleLabel.TextColor3        = Color3.fromRGB(200, 180, 255)
TitleLabel.Font              = Enum.Font.GothamBold
TitleLabel.TextSize          = 14
TitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
TitleLabel.ZIndex            = 3
TitleLabel.Parent            = TitleBar

-- close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size              = UDim2.new(0, 28, 0, 28)
CloseBtn.Position          = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3  = Color3.fromRGB(180, 50, 70)
CloseBtn.Text              = "✕"
CloseBtn.TextColor3        = Color3.fromRGB(255, 255, 255)
CloseBtn.Font              = Enum.Font.GothamBold
CloseBtn.TextSize          = 14
CloseBtn.BorderSizePixel   = 0
CloseBtn.ZIndex            = 4
CloseBtn.Parent            = TitleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent       = CloseBtn

-- ── Body ─────────────────────────────────────────────────────
local Body = Instance.new("Frame")
Body.Name             = "Body"
Body.Size             = UDim2.new(1, 0, 1, -36)
Body.Position         = UDim2.new(0, 0, 0, 36)
Body.BackgroundTransparency = 1
Body.Parent           = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding         = UDim.new(0, 8)
layout.FillDirection   = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment   = Enum.VerticalAlignment.Top
layout.SortOrder       = Enum.SortOrder.LayoutOrder
layout.Parent          = Body

local padding = Instance.new("UIPadding")
padding.PaddingTop    = UDim.new(0, 10)
padding.PaddingLeft   = UDim.new(0, 12)
padding.PaddingRight  = UDim.new(0, 12)
padding.Parent        = Body

-- ── Status Label ─────────────────────────────────────────────
StatusLabel = Instance.new("TextLabel")
StatusLabel.Name              = "StatusLabel"
StatusLabel.Size              = UDim2.new(1, 0, 0, 28)
StatusLabel.BackgroundColor3  = Color3.fromRGB(30, 30, 40)
StatusLabel.Text              = "🔴 Off"
StatusLabel.TextColor3        = Color3.fromRGB(200, 200, 220)
StatusLabel.Font              = Enum.Font.Gotham
StatusLabel.TextSize          = 13
StatusLabel.TextXAlignment    = Enum.TextXAlignment.Center
StatusLabel.BorderSizePixel   = 0
StatusLabel.LayoutOrder       = 1
StatusLabel.ZIndex            = 2
StatusLabel.Parent            = Body

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent       = StatusLabel

-- ── Steals counter ───────────────────────────────────────────
local CountLabel = Instance.new("TextLabel")
CountLabel.Name              = "CountLabel"
CountLabel.Size              = UDim2.new(1, 0, 0, 22)
CountLabel.BackgroundTransparency = 1
CountLabel.Text              = "Steals: 0"
CountLabel.TextColor3        = Color3.fromRGB(150, 150, 180)
CountLabel.Font              = Enum.Font.Gotham
CountLabel.TextSize          = 12
CountLabel.TextXAlignment    = Enum.TextXAlignment.Center
CountLabel.LayoutOrder       = 2
CountLabel.ZIndex            = 2
CountLabel.Parent            = Body

-- update counter each second
task.spawn(function()
    while ScreenGui.Parent do
        CountLabel.Text = ("Steals this session: %d"):format(State.Steals)
        task.wait(1)
    end
end)

-- ── Toggle Button ────────────────────────────────────────────
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name             = "ToggleBtn"
ToggleBtn.Size             = UDim2.new(1, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
ToggleBtn.Text             = "▶  Auto Steal: OFF"
ToggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font             = Enum.Font.GothamBold
ToggleBtn.TextSize         = 14
ToggleBtn.BorderSizePixel  = 0
ToggleBtn.LayoutOrder      = 3
ToggleBtn.ZIndex           = 2
ToggleBtn.Parent           = Body

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent       = ToggleBtn

local function updateToggleVisual(on)
    if on then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
        ToggleBtn.Text             = "⏹  Auto Steal: ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
        ToggleBtn.Text             = "▶  Auto Steal: OFF"
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    local newState = not State.AutoSteal
    updateToggleVisual(newState)
    setAutoSteal(newState)
end)

-- ── Close button handler ─────────────────────────────────────
CloseBtn.MouseButton1Click:Connect(function()
    setAutoSteal(false)
    ScreenGui:Destroy()
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
end)

-- ════════════════════════════════════════════════════════════
-- DRAG LOGIC (mirrors standard Roblox drag pattern)
-- ════════════════════════════════════════════════════════════
do
    local dragging     = false
    local dragStart    = nil
    local startPos     = nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = MainFrame.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        MainFrame.Position = newPos
    end)
end

-- ════════════════════════════════════════════════════════════
-- CLEANUP on unload (if script is re-run)
-- ════════════════════════════════════════════════════════════
if getgenv then
    local prev = getgenv().__AutoStealSAE_Unload
    if type(prev) == "function" then
        pcall(prev)
    end
    getgenv().__AutoStealSAE_Unload = function()
        setAutoSteal(false)
        pcall(function() ScreenGui:Destroy() end)
        for _, c in ipairs(connections) do
            pcall(function() c:Disconnect() end)
        end
        getgenv().__AutoStealSAE_Unload = nil
    end
end

print("[AutoSteal-SAE] Loaded. Toggle the GUI to start.")
