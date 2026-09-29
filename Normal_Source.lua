if not game:IsLoaded() then game.Loaded:Wait() end

local Players=game:GetService("Players")
local StarterGui=game:GetService("StarterGui")
local UserInputService=game:GetService("UserInputService")
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local CoreGui=game:GetService("CoreGui")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local LP=Players.LocalPlayer
local PlayerGui=LP:WaitForChild("PlayerGui")

local function GC()
    if gethui then local ok,h=pcall(gethui) if ok and h then return h end end
    return CoreGui or PlayerGui
end

for _,n in ipairs({"TungTungScreen","TungTung_TimeUI","TungTung_KeyUI","TungTung_Ended","TungTungLoading","TungTung_TeleFlash","TungTungIntro","TungTungPosTracker","TungTungAntiGuardCfg","TungTungFullBlack"}) do
    pcall(function() if PlayerGui:FindFirstChild(n) then PlayerGui[n]:Destroy() end end)
    pcall(function() if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end end)
end

local POS_A=Vector3.new(566.18,70.57,-362.39)
local POS_B=Vector3.new(543.79,70.57,-362.73)

local MoveEnabled=false
local IsMoving=false

local AntiHitEnabled=false
local IsAntiHitRunning=false
local ANTI_HIT_SPEED=0.005

local TeleportPoints={
    Vector3.new(500.62,241.28,-366.64),
    Vector3.new(504.45,155.80,-366.35),
    Vector3.new(508.30,70.28,-366.03),
    Vector3.new(513.86,70.28,-366.25),
    Vector3.new(519.43,70.28,-366.47),
    Vector3.new(524.32,70.28,-366.59),
    Vector3.new(529.22,70.28,-366.71),
    Vector3.new(538.01,70.28,-365.55),
    Vector3.new(546.80,70.28,-364.40)
}

local function getRoot()
    local char=LP.Character
    return char and char:FindFirstChild("HumanoidRootPart") or nil
end

local function getHumanoid()
    local char=LP.Character
    return char and char:FindFirstChildOfClass("Humanoid") or nil
end

local function hideJumpButtons(hide)
    local playerGui=LP:FindFirstChildOfClass("PlayerGui")
    for _,parent in ipairs({playerGui,CoreGui}) do
        if parent then
            for _,name in ipairs({"JumpButton","MobileJumpButton","Jump","JumpButtonMobile"}) do
                local ok,v=pcall(function() return parent:FindFirstChild(name,true) end)
                if ok and v and v:IsA("GuiObject") then
                    pcall(function() v.Visible=not hide end)
                end
            end
        end
    end
end

local SAVED_JUMP_POWER=nil
local SAVED_JUMP_HEIGHT=nil
local CONTROLS_LOCKED=false

local function getControls()
    local ok,result=pcall(function()
        local playerScripts=LP:FindFirstChild("PlayerScripts")
        local playerModule=playerScripts and playerScripts:FindFirstChild("PlayerModule")
        if not playerModule then return nil end
        return require(playerModule):GetControls()
    end)
    return ok and result or nil
end

local function lockControls()
    if CONTROLS_LOCKED then return end
    CONTROLS_LOCKED=true
    local controls=getControls()
    if controls then
        pcall(function() controls:Disable() end)
    end
    pcall(function() UserInputService.MouseBehavior=Enum.MouseBehavior.LockCenter end)
    hideJumpButtons(true)
end

local function unlockControls()
    if not CONTROLS_LOCKED then return end
    CONTROLS_LOCKED=false
    local controls=getControls()
    if controls then
        pcall(function() controls:Enable() end)
    end
    pcall(function() UserInputService.MouseBehavior=Enum.MouseBehavior.Default end)
    hideJumpButtons(false)
end

local function lockJump()
    local hum=getHumanoid()
    if not hum then return end
    if SAVED_JUMP_POWER==nil then SAVED_JUMP_POWER=hum.JumpPower end
    if SAVED_JUMP_HEIGHT==nil then SAVED_JUMP_HEIGHT=hum.JumpHeight end
    pcall(function() hum.JumpPower=0 end)
    pcall(function() hum.JumpHeight=0 end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,false) end)
end

local function unlockJump()
    local hum=getHumanoid()
    if not hum then return end
    if SAVED_JUMP_POWER~=nil then pcall(function() hum.JumpPower=SAVED_JUMP_POWER end) end
    if SAVED_JUMP_HEIGHT~=nil then pcall(function() hum.JumpHeight=SAVED_JUMP_HEIGHT end) end
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,true) end)
    SAVED_JUMP_POWER=nil
    SAVED_JUMP_HEIGHT=nil
end

local function walkTo(target)
    local root=getRoot()
    local hum=getHumanoid()
    if not root or not hum then return false end

    local baseSpeed=hum.WalkSpeed
    local moveSpeed=baseSpeed-math.random(2,4)
    if moveSpeed<1 then moveSpeed=1 end

    local reach=false

    local function alive()
        return getRoot()~=nil and getHumanoid()~=nil and hum.Health>0 and MoveEnabled
    end

    while alive() and not reach do
        local r=getRoot()
        if not r then break end
        local diff=target-r.Position
        local flatDiff=Vector3.new(diff.X,0,diff.Z)
        local dist=flatDiff.Magnitude
        if dist<=1.5 and math.abs(diff.Y)<=2 then
            reach=true
            break
        end
        local dir=flatDiff.Magnitude>0.01 and flatDiff.Unit or Vector3.zero
        local yDiff=diff.Y

        local velocity=Vector3.new(dir.X*moveSpeed,yDiff*2,dir.Z*moveSpeed)
        pcall(function()
            r.AssemblyLinearVelocity=velocity
        end)
        pcall(function()
            if dir.Magnitude>0.01 then
                r.CFrame=CFrame.lookAt(r.Position,r.Position+dir)
            end
        end)
        RunService.Heartbeat:Wait()
    end

    local r=getRoot()
    if r then
        pcall(function()
            r.AssemblyLinearVelocity=Vector3.new(0,r.AssemblyLinearVelocity.Y,0)
        end)
    end
    return reach
end

local function runRoute()
    if IsMoving then return end
    IsMoving=true
    lockJump()
    lockControls()

    if not walkTo(POS_A) then
        IsMoving=false
        unlockControls()
        unlockJump()
        return
    end
    if not walkTo(POS_B) then
        IsMoving=false
        unlockControls()
        unlockJump()
        return
    end

    unlockControls()
    unlockJump()
    IsMoving=false
end

local function TeleportRoute(character)
    if not character then return end
    local root=character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    IsAntiHitRunning=true
    for _,pos in ipairs(TeleportPoints) do
        if not AntiHitEnabled or not root.Parent then
            IsAntiHitRunning=false
            return
        end
        root.CFrame=CFrame.new(pos)
        task.wait(ANTI_HIT_SPEED)
    end
    IsAntiHitRunning=false
end

ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
    if player~=LP then return end
    if AntiHitEnabled and not IsAntiHitRunning then
        local char=LP.Character
        if char then
            task.spawn(function()
                TeleportRoute(char)
            end)
        end
    end
    if MoveEnabled then
        task.spawn(function()
            local t0=os.clock()
            while IsAntiHitRunning and os.clock()-t0<10 do
                RunService.Heartbeat:Wait()
            end
            runRoute()
        end)
    end
end)

local BypassProximityEnabled=false
local FAST_HOLD=0
local originalHold={}

local function ApplyBypassProximity()
    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if originalHold[obj]==nil then
                originalHold[obj]=obj.HoldDuration
            end
            pcall(function()
                obj.HoldDuration=FAST_HOLD
            end)
        end
    end
end

local function RestoreBypassProximity()
    for obj,hold in pairs(originalHold) do
        if obj and obj.Parent then
            pcall(function()
                obj.HoldDuration=hold
            end)
        end
    end
    table.clear(originalHold)
end

Workspace.DescendantAdded:Connect(function(obj)
    if not BypassProximityEnabled then return end
    if not obj:IsA("ProximityPrompt") then return end
    task.wait(0.1)
    if not BypassProximityEnabled or not obj.Parent then return end
    pcall(function()
        if originalHold[obj]==nil then
            originalHold[obj]=obj.HoldDuration
        end
        obj.HoldDuration=FAST_HOLD
    end)
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
    if BypassProximityEnabled and prompt and prompt:IsA("ProximityPrompt") then
        if originalHold[prompt]==nil then
            originalHold[prompt]=prompt.HoldDuration
        end
        pcall(function() prompt.HoldDuration=FAST_HOLD end)
    end
end)

local AntiRagdollEnabled=false
local antiRagdollConns={}
local antiRagdollHeartbeat=nil
local antiRagdollCharConns={}

local function arClearConns()
    for _,c in ipairs(antiRagdollConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(antiRagdollConns)
    for _,c in ipairs(antiRagdollCharConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(antiRagdollCharConns)
    if antiRagdollHeartbeat then
        antiRagdollHeartbeat:Disconnect()
        antiRagdollHeartbeat=nil
    end
end

local function arRestore(hum,char)
    if not hum or not hum.Parent then return end
    pcall(function()
        if hum.PlatformStand then hum.PlatformStand=false end
        if not hum.AutoRotate then hum.AutoRotate=true end
        if hum.Sit then hum.Sit=false end
        if hum.WalkSpeed==0 then hum.WalkSpeed=16 end
        if hum.JumpPower==0 then hum.JumpPower=50 end
        if hum.JumpHeight==0 then hum.JumpHeight=7.2 end
        if hum.Health<=0 then return end
        local state=hum:GetState()
        if state==Enum.HumanoidStateType.Physics
        or state==Enum.HumanoidStateType.FallingDown
        or state==Enum.HumanoidStateType.Ragdoll
        or state==Enum.HumanoidStateType.Dead then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
    end)
    if char then
        pcall(function()
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name=="Head" or part.Name=="Torso" or part.Name=="UpperTorso" or part.Name=="LowerTorso" or part.Name=="HumanoidRootPart" then
                        if part.Anchored then part.Anchored=false end
                        if part.CanCollide==false and part.Name~="HumanoidRootPart" then part.CanCollide=true end
                    end
                    for _,joint in ipairs(part:GetChildren()) do
                        if joint:IsA("Motor6D") and joint.Enabled==false then
                            joint.Enabled=true
                        end
                    end
                elseif part:IsA("BallSocketConstraint") or part:IsA("HingeConstraint")
                or part:IsA("NoCollisionConstraint") or part:IsA("RopeConstraint")
                or part:IsA("RodConstraint") or part:IsA("SpringConstraint")
                or part:IsA("UniversalConstraint") then
                    if part.Enabled then part.Enabled=false end
                end
            end
        end)
    end
end

local function arSetup(hum,char)
    if not hum then return end
    arRestore(hum,char)
    table.insert(antiRagdollConns,hum.StateChanged:Connect(function(_,newState)
        if not AntiRagdollEnabled then return end
        if newState==Enum.HumanoidStateType.Physics
        or newState==Enum.HumanoidStateType.FallingDown
        or newState==Enum.HumanoidStateType.Ragdoll then
            task.spawn(arRestore,hum,char)
        end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if not AntiRagdollEnabled then return end
        if hum.PlatformStand then task.spawn(arRestore,hum,char) end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("AutoRotate"):Connect(function()
        if not AntiRagdollEnabled then return end
        if not hum.AutoRotate then hum.AutoRotate=true end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if not AntiRagdollEnabled then return end
        if hum.Sit then hum.Sit=false end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if not AntiRagdollEnabled then return end
        if hum.WalkSpeed<1 then hum.WalkSpeed=16 end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if not AntiRagdollEnabled then return end
        if hum.JumpPower<1 then hum.JumpPower=50 end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if not AntiRagdollEnabled then return end
        if hum.JumpHeight<1 then hum.JumpHeight=7.2 end
    end))
    table.insert(antiRagdollConns,hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not AntiRagdollEnabled then return end
        if hum.Health<=0 then task.spawn(arRestore,hum,char) end
    end))
    local root=char:FindFirstChild("HumanoidRootPart")
    if root then
        table.insert(antiRagdollConns,root:GetPropertyChangedSignal("Anchored"):Connect(function()
            if not AntiRagdollEnabled then return end
            if root.Anchored then root.Anchored=false end
        end))
    end
    if char then
        table.insert(antiRagdollCharConns,char.DescendantAdded:Connect(function(obj)
            if not AntiRagdollEnabled then return end
            if obj:IsA("BasePart") then
                task.wait(0.05)
                pcall(function()
                    if obj.Name=="Head" or obj.Name=="Torso" or obj.Name=="UpperTorso" or obj.Name=="LowerTorso" then
                        if obj.Anchored then obj.Anchored=false end
                    end
                end)
            elseif obj:IsA("Motor6D") then
                task.wait(0.05)
                pcall(function()
                    if obj.Enabled==false then obj.Enabled=true end
                end)
            elseif obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint")
            or obj:IsA("NoCollisionConstraint") or obj:IsA("RopeConstraint")
            or obj:IsA("RodConstraint") or obj:IsA("SpringConstraint")
            or obj:IsA("UniversalConstraint") then
                task.wait(0.05)
                pcall(function()
                    if obj.Enabled then obj.Enabled=false end
                end)
            end
        end))
    end
end

local function arStart()
    if not antiRagdollHeartbeat then
        antiRagdollHeartbeat=RunService.Heartbeat:Connect(function()
            if not AntiRagdollEnabled then return end
            local char=LP.Character
            if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local state=hum:GetState()
            if hum.PlatformStand
            or state==Enum.HumanoidStateType.Physics
            or state==Enum.HumanoidStateType.FallingDown
            or state==Enum.HumanoidStateType.Ragdoll then
                arRestore(hum,char)
            end
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name=="Head" or part.Name=="Torso" or part.Name=="UpperTorso" or part.Name=="LowerTorso" then
                        if part.Anchored then part.Anchored=false end
                    end
                    for _,joint in ipairs(part:GetChildren()) do
                        if joint:IsA("Motor6D") and joint.Enabled==false then
                            joint.Enabled=true
                        end
                    end
                elseif part:IsA("BallSocketConstraint") or part:IsA("HingeConstraint")
                or part:IsA("NoCollisionConstraint") or part:IsA("RopeConstraint")
                or part:IsA("RodConstraint") or part:IsA("SpringConstraint")
                or part:IsA("UniversalConstraint") then
                    if part.Enabled then part.Enabled=false end
                end
            end
        end)
    end
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then arSetup(hum,char) end
    end
    table.insert(antiRagdollConns,LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        if not AntiRagdollEnabled then return end
        local hum=newChar:WaitForChild("Humanoid",5)
        if hum then
            arSetup(hum,newChar)
            arRestore(hum,newChar)
        end
    end))
end

local function arStop()
    arClearConns()
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
            end)
        end
    end
end

local TrapCleanerEnabled=false
local trapCleanerConn=nil
local TRAP_DROP_DISTANCE=100
local movedTraps={}

local function isPlayerTrap(obj)
    if not obj or not obj.Parent then return false end
    if not obj:IsA("BasePart") then return false end
    if obj.Name~="PlayerTrap" then return false end
    local parent=obj.Parent
    if parent and parent.Name=="Transient" then return true end
    return false
end

local function trapMove(obj)
    if not isPlayerTrap(obj) then return end
    if movedTraps[obj] then return end
    pcall(function()
        movedTraps[obj]=true
        obj.CanTouch=false
        obj.CanCollide=false
        obj.CFrame=obj.CFrame-Vector3.new(0,TRAP_DROP_DISTANCE,0)
        local hb=obj:FindFirstChild("Hitbox")
        if hb and hb:IsA("BasePart") then
            hb.CanTouch=false
            hb.CanCollide=false
            hb.CFrame=hb.CFrame-Vector3.new(0,TRAP_DROP_DISTANCE,0)
        end
    end)
end

local function trapScan()
    local transient=Workspace:FindFirstChild("Transient")
    if not transient then return end
    for _,obj in ipairs(transient:GetChildren()) do
        trapMove(obj)
    end
end

local function trapStart()
    trapScan()
    trapCleanerConn=Workspace.DescendantAdded:Connect(function(obj)
        if not TrapCleanerEnabled then return end
        if obj.Name~="PlayerTrap" then return end
        if not obj:IsA("BasePart") then return end
        task.wait(0.05)
        trapMove(obj)
    end)
end

local function trapStop()
    if trapCleanerConn then
        trapCleanerConn:Disconnect()
        trapCleanerConn=nil
    end
    table.clear(movedTraps)
end

local FixLagEnabled=false
local fixLagConns={}
local fixLagSaved={}
local fixLagDebounce=false
local fixLagAddedConn=nil

local function saveProp(obj,prop)
    if not fixLagSaved[obj] then fixLagSaved[obj]={} end
    if fixLagSaved[obj][prop]==nil then
        fixLagSaved[obj][prop]=obj[prop]
    end
end

local function clearVisualEffects()
    pcall(function()
        for _,obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect")
            or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
                saveProp(obj,"Enabled")
                obj.Enabled=false
            end
        end
    end)
end

local function restoreVisualEffects()
    pcall(function()
        for _,obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect")
            or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
                local saved=fixLagSaved[obj]
                if saved and saved.Enabled~=nil then
                    obj.Enabled=saved.Enabled
                end
            end
        end
    end)
end

local function optimizeObject(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            if obj.Material~=Enum.Material.Plastic and obj.Material~=Enum.Material.SmoothPlastic then
                saveProp(obj,"Material")
                obj.Material=Enum.Material.SmoothPlastic
            end
            if obj.Reflectance>0 then
                saveProp(obj,"Reflectance")
                obj.Reflectance=0
            end
            if obj.CastShadow then
                saveProp(obj,"CastShadow")
                obj.CastShadow=false
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if obj.Transparency<1 then
                saveProp(obj,"Transparency")
                obj.Transparency=1
            end
        elseif obj:IsA("Light") then
            if obj.Enabled then
                saveProp(obj,"Enabled")
                obj.Enabled=false
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            if obj.Enabled then
                saveProp(obj,"Enabled")
                obj.Enabled=false
            end
        end
    end)
end

local function optimizeWorkspace()
    if fixLagDebounce then return end
    fixLagDebounce=true
    task.spawn(function()
        pcall(function()
            saveProp(Workspace,"StreamingEnabled")
            Workspace.StreamingEnabled=false
        end)
        local count=0
        pcall(function()
            for _,obj in ipairs(Workspace:GetDescendants()) do
                count=count+1
                optimizeObject(obj)
                if count%500==0 then task.wait() end
            end
        end)
        fixLagDebounce=false
    end)
end

local function restoreWorkspace()
    pcall(function()
        for obj,props in pairs(fixLagSaved) do
            if obj then
                for prop,value in pairs(props) do
                    pcall(function() obj[prop]=value end)
                end
            end
        end
    end)
    table.clear(fixLagSaved)
end

local function fixLagStart()
    clearVisualEffects()
    optimizeWorkspace()
    if not fixLagAddedConn then
        fixLagAddedConn=Workspace.DescendantAdded:Connect(function(obj)
            if not FixLagEnabled then return end
            task.wait(0.05)
            if not FixLagEnabled or not obj.Parent then return end
            optimizeObject(obj)
        end)
    end
    table.insert(fixLagConns,LP.CharacterAdded:Connect(function()
        task.wait(1)
        if FixLagEnabled then
            clearVisualEffects()
        end
    end))
end

local function fixLagStop()
    for _,c in ipairs(fixLagConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(fixLagConns)
    if fixLagAddedConn then
        fixLagAddedConn:Disconnect()
        fixLagAddedConn=nil
    end
    restoreVisualEffects()
    restoreWorkspace()
end

getgenv().Tungtung_BypassEnabled=true
getgenv().Tungtung_AutoMove=false
getgenv().Tungtung_AntiHit=false
getgenv().Tungtung_BypassProximity=false
getgenv().Tungtung_FixLag=false

pcall(function()
    if hookfunction and getrawmetatable then
        local mt=getrawmetatable(game)
        if mt then
            local oldNamecall=mt.__namecall
            setreadonly(mt,false)
            mt.__namecall=newcclosure(function(self,...)
                local method=getnamecallmethod()
                if method=="Kick" then return nil end
                return oldNamecall(self,...)
            end)
            setreadonly(mt,true)
        end
    end
end)

task.spawn(function()
    task.wait(5)
    pcall(function()
        for _,obj in ipairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local name=string.lower(obj.Name)
                if name:find("detect") or name:find("cheat") or name:find("kick") or name:find("ban") or name:find("report") or name:find("flag") then
                    if getconnections then
                        for _,conn in ipairs(getconnections(obj.OnClientEvent)) do
                            pcall(function() conn:Disable() end)
                        end
                    end
                end
            end
        end
    end)
end)

local CONFIG_URL="https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Config"

local ok,raw=pcall(function() return game:HttpGet(CONFIG_URL.."?v="..tick(),true) end)
if not ok or not raw then warn("[CONFIG] fail") return end
local fn=loadstring(raw) if not fn then return end
local ok2,cfg=pcall(fn) if not ok2 or type(cfg)~="table" then return end

local SOCIAL_HANDLE,LOGO_ASSET=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local BRAND_NAME="Tungtung v3"
local NOTIF_NAME="Tungtung Hub"

local MainGui=Instance.new("ScreenGui")
MainGui.Name="TungTungIntro"
MainGui.ResetOnSpawn=false
MainGui.IgnoreGuiInset=true
MainGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
MainGui.DisplayOrder=2147483647
pcall(function() MainGui.Parent=GC() end)
if not MainGui.Parent then MainGui.Parent=PlayerGui end

local DarkOverlay=Instance.new("Frame")
DarkOverlay.Size=UDim2.fromScale(1,1)
DarkOverlay.BackgroundColor3=Color3.fromRGB(0,0,0)
DarkOverlay.BackgroundTransparency=1
DarkOverlay.BorderSizePixel=0
DarkOverlay.ZIndex=99
DarkOverlay.Parent=MainGui

local Card=Instance.new("Frame")
Card.AnchorPoint=Vector2.new(0.5,0.5)
Card.Position=UDim2.fromScale(0.5,0.54)
Card.Size=UDim2.fromOffset(340,200)
Card.BackgroundColor3=Color3.fromRGB(14,14,16)
Card.BackgroundTransparency=1
Card.ClipsDescendants=true
Card.ZIndex=100
Card.Parent=MainGui

local LoadingBgGradient=Instance.new("UIGradient")
LoadingBgGradient.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0.00,Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.28,Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.40,Color3.fromRGB(70,70,70)),
    ColorSequenceKeypoint.new(0.46,Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.54,Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.60,Color3.fromRGB(70,70,70)),
    ColorSequenceKeypoint.new(0.72,Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(1.00,Color3.fromRGB(0,0,0))
})
LoadingBgGradient.Rotation=0
LoadingBgGradient.Offset=Vector2.new(1.35,0)
LoadingBgGradient.Parent=Card

task.spawn(function()
    while MainGui.Parent and Card.Parent do
        LoadingBgGradient.Offset=Vector2.new(1.35,0)
        local sweep=TweenService:Create(LoadingBgGradient,TweenInfo.new(2.8,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Offset=Vector2.new(-1.35,0)})
        sweep:Play()
        sweep.Completed:Wait()
        LoadingBgGradient.Offset=Vector2.new(1.35,0)
        task.wait(0.18)
    end
end)

Instance.new("UICorner",Card).CornerRadius=UDim.new(0,14)

local CardStroke=Instance.new("UIStroke")
CardStroke.Color=Color3.fromRGB(255,255,255)
CardStroke.Transparency=1
CardStroke.Thickness=1.2
CardStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
CardStroke.Parent=Card

local Logo=Instance.new("ImageLabel")
Logo.AnchorPoint=Vector2.new(0.5,0)
Logo.Position=UDim2.new(0.5,0,0.12,0)
Logo.Size=UDim2.fromOffset(56,56)
Logo.BackgroundTransparency=1
Logo.Image=LOGO_ASSET
Logo.ImageTransparency=1
Logo.ScaleType=Enum.ScaleType.Fit
Logo.ZIndex=101
Logo.Parent=Card
Instance.new("UICorner",Logo).CornerRadius=UDim.new(0,10)

local Title=Instance.new("TextLabel")
Title.AnchorPoint=Vector2.new(0.5,0)
Title.Position=UDim2.new(0.5,0,0.43,0)
Title.Size=UDim2.new(0.9,0,0,24)
Title.BackgroundTransparency=1
Title.Text="TUNGTUNG"
Title.TextColor3=Color3.fromRGB(255,255,255)
Title.TextTransparency=1
Title.Font=Enum.Font.FredokaOne
Title.TextSize=20
Title.ZIndex=101
Title.Parent=Card

local DiscordText=Instance.new("TextLabel")
DiscordText.AnchorPoint=Vector2.new(0.5,0)
DiscordText.Position=UDim2.new(0.5,0,0.56,0)
DiscordText.Size=UDim2.new(0.9,0,0,18)
DiscordText.BackgroundTransparency=1
DiscordText.Text=BRAND_NAME.." • "..SOCIAL_HANDLE
DiscordText.TextColor3=Color3.fromRGB(160,160,165)
DiscordText.TextTransparency=1
DiscordText.Font=Enum.Font.FredokaOne
DiscordText.TextSize=12
DiscordText.ZIndex=101
DiscordText.Parent=Card

local ProgressBg=Instance.new("Frame")
ProgressBg.AnchorPoint=Vector2.new(0.5,0)
ProgressBg.Position=UDim2.new(0.5,0,0.76,0)
ProgressBg.Size=UDim2.new(0.78,0,0,5)
ProgressBg.BackgroundColor3=Color3.fromRGB(30,30,35)
ProgressBg.BackgroundTransparency=1
ProgressBg.BorderSizePixel=0
ProgressBg.ZIndex=101
ProgressBg.Parent=Card
Instance.new("UICorner",ProgressBg).CornerRadius=UDim.new(1,0)

local ProgressFill=Instance.new("Frame")
ProgressFill.Position=UDim2.new(0,0,0,0)
ProgressFill.Size=UDim2.new(0,0,1,0)
ProgressFill.BackgroundColor3=Color3.fromRGB(255,255,255)
ProgressFill.BackgroundTransparency=1
ProgressFill.BorderSizePixel=0
ProgressFill.ZIndex=102
ProgressFill.Parent=ProgressBg
Instance.new("UICorner",ProgressFill).CornerRadius=UDim.new(1,0)

local Status=Instance.new("TextLabel")
Status.AnchorPoint=Vector2.new(0.5,0)
Status.Position=UDim2.new(0.5,0,0.84,0)
Status.Size=UDim2.new(0.8,0,0,14)
Status.BackgroundTransparency=1
Status.Text="Initializing Tungtung Hub..."
Status.TextColor3=Color3.fromRGB(120,120,125)
Status.TextTransparency=1
Status.Font=Enum.Font.Gotham
Status.TextSize=11
Status.ZIndex=101
Status.Parent=Card

local tweenFast=TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
local tweenPop=TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

TweenService:Create(DarkOverlay,tweenFast,{BackgroundTransparency=0.45}):Play()
task.wait(0.07)

TweenService:Create(Card,tweenPop,{Position=UDim2.fromScale(0.5,0.5),BackgroundTransparency=0.05}):Play()
TweenService:Create(CardStroke,tweenFast,{Transparency=0.88}):Play()
task.wait(0.15)

TweenService:Create(Logo,tweenFast,{ImageTransparency=0}):Play()
TweenService:Create(Title,tweenFast,{TextTransparency=0}):Play()
TweenService:Create(DiscordText,tweenFast,{TextTransparency=0}):Play()
TweenService:Create(ProgressBg,tweenFast,{BackgroundTransparency=0}):Play()
TweenService:Create(ProgressFill,tweenFast,{BackgroundTransparency=0}):Play()
TweenService:Create(Status,tweenFast,{TextTransparency=0}):Play()

task.wait(0.25)

Status.Text="Loading scripts & assets..."
TweenService:Create(ProgressFill,TweenInfo.new(1.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(1,0,1,0)}):Play()

task.wait(1.1)

Status.Text="TUNGTUNG"
Status.TextColor3=Color3.fromRGB(255,255,255)

task.wait(0.7)

local tweenOut=TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In)

TweenService:Create(Card,tweenOut,{Position=UDim2.fromScale(0.5,0.46),BackgroundTransparency=1}):Play()
TweenService:Create(CardStroke,tweenOut,{Transparency=1}):Play()
TweenService:Create(DarkOverlay,tweenOut,{BackgroundTransparency=1}):Play()
TweenService:Create(Logo,tweenOut,{ImageTransparency=1}):Play()
TweenService:Create(Title,tweenOut,{TextTransparency=1}):Play()
TweenService:Create(DiscordText,tweenOut,{TextTransparency=1}):Play()
TweenService:Create(ProgressBg,tweenOut,{BackgroundTransparency=1}):Play()
TweenService:Create(ProgressFill,tweenOut,{BackgroundTransparency=1}):Play()
TweenService:Create(Status,tweenOut,{TextTransparency=1}):Play()

task.wait(0.45)

MainGui:Destroy()

local function ShowMainUI()
    local ScreenGui=Instance.new("ScreenGui")
    ScreenGui.Name="TungTungScreen"
    ScreenGui.ResetOnSpawn=false
    ScreenGui.IgnoreGuiInset=true
    ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder=99999
    pcall(function() ScreenGui.Parent=GC() end)
    if not ScreenGui.Parent then ScreenGui.Parent=PlayerGui end

    local floatBtn=Instance.new("ImageButton")
    floatBtn.Size=UDim2.fromOffset(48,48)
    floatBtn.Position=UDim2.new(0,15,0,110)
    floatBtn.BackgroundColor3=Color3.fromRGB(20,20,25)
    floatBtn.BorderSizePixel=0
    floatBtn.ScaleType=Enum.ScaleType.Fit
    floatBtn.Image=LOGO_ASSET
    floatBtn.ZIndex=10001
    floatBtn.Parent=ScreenGui
    Instance.new("UICorner",floatBtn).CornerRadius=UDim.new(1,0)
    local fS=Instance.new("UIStroke",floatBtn)
    fS.Thickness=2
    fS.Color=Color3.fromRGB(150,80,255)

    local panel=Instance.new("Frame")
    panel.Size=UDim2.fromOffset(300,310)
    panel.Position=UDim2.new(1,-315,0,15)
    panel.BackgroundColor3=Color3.fromRGB(12,12,16)
    panel.BorderSizePixel=0
    panel.ZIndex=5000
    panel.Parent=ScreenGui
    Instance.new("UICorner",panel).CornerRadius=UDim.new(0,12)
    local pG=Instance.new("UIGradient",panel)
    pG.Rotation=135
    pG.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(25,15,45)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(10,8,18))
    }
    local pS=Instance.new("UIStroke",panel)
    pS.Thickness=1.5
    pS.Color=Color3.fromRGB(130,60,255)

    local header=Instance.new("Frame")
    header.Size=UDim2.new(1,0,0,48)
    header.BackgroundTransparency=1
    header.ZIndex=5001
    header.Parent=panel

    local logo=Instance.new("ImageLabel")
    logo.Size=UDim2.fromOffset(32,32)
    logo.Position=UDim2.new(0,12,0,8)
    logo.BackgroundTransparency=1
    logo.ScaleType=Enum.ScaleType.Fit
    logo.Image=LOGO_ASSET
    logo.ZIndex=5002
    logo.Parent=header

    local title=Instance.new("TextLabel")
    title.Size=UDim2.new(1,-140,0,20)
    title.Position=UDim2.new(0,52,0,8)
    title.BackgroundTransparency=1
    title.Text=BRAND_NAME
    title.TextColor3=Color3.fromRGB(240,220,255)
    title.Font=Enum.Font.GothamBlack
    title.TextSize=15
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.ZIndex=5002
    title.Parent=header
    local tG=Instance.new("UIGradient",title)
    tG.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(253,230,138)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(200,150,255))
    }

    local sub=Instance.new("TextLabel")
    sub.Size=UDim2.new(1,-60,0,14)
    sub.Position=UDim2.new(0,52,0,28)
    sub.BackgroundTransparency=1
    sub.Text=SOCIAL_HANDLE
    sub.TextColor3=Color3.fromRGB(140,130,170)
    sub.Font=Enum.Font.GothamMedium
    sub.TextSize=10
    sub.TextXAlignment=Enum.TextXAlignment.Left
    sub.ZIndex=5002
    sub.Parent=header

    local content=Instance.new("Frame")
    content.Size=UDim2.new(1,-20,1,-58)
    content.Position=UDim2.new(0,10,0,50)
    content.BackgroundTransparency=1
    content.ZIndex=5001
    content.Parent=panel

    local function makeRow(y,labelText,getState,onToggle)
        local row=Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,44)
        row.Position=UDim2.new(0,0,0,y)
        row.BackgroundColor3=Color3.fromRGB(18,18,24)
        row.BorderSizePixel=0
        row.ZIndex=5002
        row.Parent=content
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
        local rG=Instance.new("UIGradient",row)
        rG.Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0,Color3.fromRGB(25,20,40)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(15,12,25))
        }
        local rS=Instance.new("UIStroke",row)
        rS.Thickness=1
        rS.Color=Color3.fromRGB(60,40,100)

        local lbl=Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,-80,1,0)
        lbl.Position=UDim2.new(0,14,0,0)
        lbl.BackgroundTransparency=1
        lbl.Text=labelText
        lbl.TextColor3=Color3.fromRGB(240,240,255)
        lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=12
        lbl.TextXAlignment=Enum.TextXAlignment.Left
        lbl.ZIndex=5003
        lbl.Parent=row

        local track=Instance.new("Frame")
        track.Size=UDim2.fromOffset(48,24)
        track.Position=UDim2.new(1,-60,0.5,-12)
        track.BackgroundColor3=getState() and Color3.fromRGB(130,80,255) or Color3.fromRGB(45,45,60)
        track.ZIndex=5003
        track.Parent=row
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

        local knob=Instance.new("Frame")
        knob.Size=UDim2.fromOffset(18,18)
        knob.Position=getState() and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        knob.BackgroundColor3=getState() and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,220)
        knob.ZIndex=5004
        knob.Parent=track
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

        local clickBtn=Instance.new("TextButton")
        clickBtn.Size=UDim2.new(1,0,1,0)
        clickBtn.BackgroundTransparency=1
        clickBtn.Text=""
        clickBtn.ZIndex=5005
        clickBtn.Parent=row

        clickBtn.MouseButton1Click:Connect(function()
            local isOn=onToggle()
            if isOn then
                TweenService:Create(track,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(130,80,255)}):Play()
                TweenService:Create(knob,TweenInfo.new(.2),{Position=UDim2.new(1,-21,0.5,-9),BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
            else
                TweenService:Create(track,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(45,45,60)}):Play()
                TweenService:Create(knob,TweenInfo.new(.2),{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(200,200,220)}):Play()
            end
        end)
    end

    makeRow(0,"Super Anti Hit",function() return AntiHitEnabled end,function()
        AntiHitEnabled=not AntiHitEnabled
        getgenv().Tungtung_AntiHit=AntiHitEnabled
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title=NOTIF_NAME,
                Text=AntiHitEnabled and "Anti-Hit ON" or "Anti-Hit OFF",
                Duration=2,
            })
        end)
        return AntiHitEnabled
    end)

    makeRow(48,"Bypass Proximity",function() return BypassProximityEnabled end,function()
        BypassProximityEnabled=not BypassProximityEnabled
        getgenv().Tungtung_BypassProximity=BypassProximityEnabled
        if BypassProximityEnabled then
            ApplyBypassProximity()
        else
            RestoreBypassProximity()
        end
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title=NOTIF_NAME,
                Text=BypassProximityEnabled and "Bypass Proximity ON" or "Bypass Proximity OFF",
                Duration=2,
            })
        end)
        return BypassProximityEnabled
    end)

    makeRow(96,"Anti Ragdoll",function() return AntiRagdollEnabled end,function()
        AntiRagdollEnabled=not AntiRagdollEnabled
        if AntiRagdollEnabled then
            arStart()
            local char=LP.Character
            if char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                arRestore(hum,char)
            end
        else
            arStop()
        end
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title=NOTIF_NAME,
                Text=AntiRagdollEnabled and "Anti-Ragdoll ON" or "Anti-Ragdoll OFF",
                Duration=2,
            })
        end)
        return AntiRagdollEnabled
    end)

    makeRow(144,"Trap Cleaner",function() return TrapCleanerEnabled end,function()
        TrapCleanerEnabled=not TrapCleanerEnabled
        if TrapCleanerEnabled then
            trapStart()
        else
            trapStop()
        end
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title=NOTIF_NAME,
                Text=TrapCleanerEnabled and "Trap Cleaner ON" or "Trap Cleaner OFF",
                Duration=2,
            })
        end)
        return TrapCleanerEnabled
    end)

    makeRow(192,"Fix Lag",function() return FixLagEnabled end,function()
        FixLagEnabled=not FixLagEnabled
        getgenv().Tungtung_FixLag=FixLagEnabled
        if FixLagEnabled then
            fixLagStart()
        else
            fixLagStop()
        end
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title=NOTIF_NAME,
                Text=FixLagEnabled and "Fix Lag ON" or "Fix Lag OFF",
                Duration=2,
            })
        end)
        return FixLagEnabled
    end)

    local dragging,dragStart,startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragStart=input.Position
            startPos=panel.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart
            panel.Position=UDim2.new(
                startPos.X.Scale,startPos.X.Offset+delta.X,
                startPos.Y.Scale,startPos.Y.Offset+delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)

    floatBtn.MouseButton1Click:Connect(function()
        panel.Visible=not panel.Visible
    end)
end

ShowMainUI()

print("[Tungtung v3] Loaded")
