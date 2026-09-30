if not game:IsLoaded()then game.Loaded:Wait()end
local P=game:GetService("Players")local SG=game:GetService("StarterGui")local UI=game:GetService("UserInputService")local PP=game:GetService("ProximityPromptService")local T=game:GetService("TweenService")local R=game:GetService("RunService")local CG=game:GetService("CoreGui")local W=game:GetService("Workspace")local L=game:GetService("Lighting")local RS=game:GetService("ReplicatedStorage")local LP=P.LocalPlayer local PG=LP:WaitForChild("PlayerGui")
local function GC()if gethui then local o,h=pcall(gethui)if o and h then return h end end return CG or PG end
for _,n in ipairs{"TungTungScreen","TungTung_TimeUI","TungTung_KeyUI","TungTung_Ended","TungTungLoading","TungTung_TeleFlash","TungTungIntro","TungTungPosTracker","TungTungAntiGuardCfg","TungTungFullBlack","TungTungProxiLoad"}do pcall(function()if PG:FindFirstChild(n)then PG[n]:Destroy()end end)pcall(function()if CG:FindFirstChild(n)then CG[n]:Destroy()end end)end
for _,c in ipairs(getgenv().TungtungOldConns or{})do pcall(function()c:Disconnect()end)end getgenv().TungtungOldConns={}

local AH,IA=false,false
local HS=0.005

getgenv().SetAntiHit=function(v)
    AH=v==true
    getgenv().Tungtung_AntiHit=AH
    print("[AntiHit]",AH and"ON"or"OFF")
end
getgenv().SetAntiHitSpeed=function(v)
    HS=tonumber(v)or HS
    print("[AntiHit] Speed =",HS)
end

local TP={Vector3.new(500.62,241.28,-366.64),Vector3.new(504.45,155.80,-366.35),Vector3.new(508.30,70.28,-366.03),Vector3.new(513.86,70.28,-366.25),Vector3.new(519.43,70.28,-366.47),Vector3.new(524.32,70.28,-366.59),Vector3.new(529.22,70.28,-366.71),Vector3.new(538.01,70.28,-365.55),Vector3.new(546.80,70.28,-364.40)}

local function gR()local c=LP.Character return c and c:FindFirstChild("HumanoidRootPart")or nil end
local function gH()local c=LP.Character return c and c:FindFirstChildOfClass("Humanoid")or nil end

local JP,JH,CL=nil,nil,false
local function hJ(h)local pg=LP:FindFirstChildOfClass("PlayerGui")for _,p in ipairs{pg,CG}do if p then for _,n in ipairs{"JumpButton","MobileJumpButton","Jump","JumpButtonMobile"}do local o,v=pcall(function()return p:FindFirstChild(n,true)end)if o and v and v:IsA("GuiObject")then pcall(function()v.Visible=not h end)end end end end end
local function gC()local o,r=pcall(function()local ps=LP:FindFirstChild("PlayerScripts")local pm=ps and ps:FindFirstChild("PlayerModule")if not pm then return nil end return require(pm):GetControls()end)return o and r or nil end
local function lC()if CL then return end CL=true local c=gC()if c then pcall(function()c:Disable()end)end pcall(function()UI.MouseBehavior=Enum.MouseBehavior.LockCenter end)hJ(true)end
local function uC()if not CL then return end CL=false local c=gC()if c then pcall(function()c:Enable()end)end pcall(function()UI.MouseBehavior=Enum.MouseBehavior.Default end)hJ(false)end
local function lJ()local h=gH()if not h then return end if JP==nil then JP=h.JumpPower end if JH==nil then JH=h.JumpHeight end pcall(function()h.JumpPower=0 end)pcall(function()h.JumpHeight=0 end)pcall(function()h:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)end)end
local function uJ()local h=gH()if not h then return end if JP~=nil then pcall(function()h.JumpPower=JP end)end if JH~=nil then pcall(function()h.JumpHeight=JH end)end pcall(function()h:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)end)JP=nil JH=nil end

local function TR(c)if not c then return end local r=c:FindFirstChild("HumanoidRootPart")if not r then return end IA=true for _,p in ipairs(TP)do if not AH or not r.Parent then IA=false return end r.CFrame=CFrame.new(p)task.wait(HS)end IA=false end

-- ===== TUNGTUNG LOADING KHI PROXI BẮN RA =====
local function ShowProxiLoading()
    local SG2 = GC()
    pcall(function()
        local old = SG2:FindFirstChild("TungTungProxiLoad")
        if old then old:Destroy() end
    end)
    local BlackScreen = Instance.new("Frame")
    BlackScreen.Name = "TungTungProxiLoad"
    BlackScreen.Size = UDim2.fromScale(1, 1)
    BlackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlackScreen.BackgroundTransparency = 0
    BlackScreen.BorderSizePixel = 0
    BlackScreen.ZIndex = 2147483646
    BlackScreen.Parent = SG2
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0.42, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "TUNGTUNG HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 42
    Title.ZIndex = 2147483647
    Title.Parent = BlackScreen
    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, 0, 0, 20)
    Sub.Position = UDim2.new(0, 0, 0.42, 65)
    Sub.BackgroundTransparency = 1
    Sub.Text = "Loading..."
    Sub.TextColor3 = Color3.fromRGB(180, 180, 200)
    Sub.Font = Enum.Font.GothamMedium
    Sub.TextSize = 14
    Sub.ZIndex = 2147483647
    Sub.Parent = BlackScreen
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(0.6, 0, 0, 8)
    BarBg.Position = UDim2.new(0.2, 0, 0.85, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    BarBg.BorderSizePixel = 0
    BarBg.ZIndex = 2147483647
    BarBg.Parent = BlackScreen
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
    BarFill.BorderSizePixel = 0
    BarFill.ZIndex = 2147483647
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
    local PctText = Instance.new("TextLabel")
    PctText.Size = UDim2.new(1, 0, 0, 20)
    PctText.Position = UDim2.new(0, 0, 0.85, 12)
    PctText.BackgroundTransparency = 1
    PctText.Text = "0%"
    PctText.TextColor3 = Color3.fromRGB(200, 200, 220)
    PctText.Font = Enum.Font.GothamBold
    PctText.TextSize = 13
    PctText.ZIndex = 2147483647
    PctText.Parent = BlackScreen
    task.spawn(function()
        local duration = 0.6
        local startTime = tick()
        while true do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / duration, 0, 1)
            BarFill.Size = UDim2.new(progress, 0, 1, 0)
            PctText.Text = math.floor(progress * 100) .. "%"
            if progress >= 1 then break end
            task.wait()
        end
        task.wait(0.6)
        local tween = T:Create(BlackScreen, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        local tween2 = T:Create(Title, TweenInfo.new(0.25), {TextTransparency = 1})
        local tween3 = T:Create(Sub, TweenInfo.new(0.25), {TextTransparency = 1})
        local tween4 = T:Create(BarBg, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        local tween5 = T:Create(BarFill, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        local tween6 = T:Create(PctText, TweenInfo.new(0.25), {TextTransparency = 1})
        tween:Play() tween2:Play() tween3:Play() tween4:Play() tween5:Play() tween6:Play()
        tween.Completed:Wait()
        BlackScreen:Destroy()
    end)
end
-- ===== KẾT THÚC LOADING =====

PP.PromptTriggered:Connect(function(pr,pl)
    if pl~=LP then return end
    task.spawn(ShowProxiLoading)
    if AH and not IA then local c=LP.Character if c then task.spawn(function()TR(c)end)end end
end)

local BP=false local FH=0 local OH={}
local function AB()for _,o in ipairs(W:GetDescendants())do if o:IsA("ProximityPrompt")then if OH[o]==nil then OH[o]=o.HoldDuration end pcall(function()o.HoldDuration=FH end)end end end
local function RB()for o,h in pairs(OH)do if o and o.Parent then pcall(function()o.HoldDuration=h end)end end table.clear(OH)end
W.DescendantAdded:Connect(function(o)if not BP then return end if not o:IsA("ProximityPrompt")then return end task.wait(.1)if not BP or not o.Parent then return end pcall(function()if OH[o]==nil then OH[o]=o.HoldDuration end o.HoldDuration=FH end)end)
PP.PromptShown:Connect(function(p)if BP and p and p:IsA("ProximityPrompt")then if OH[p]==nil then OH[p]=p.HoldDuration end pcall(function()p.HoldDuration=FH end)end end)

local AR=false local ARC={}local ARCC={}local ARHB=nil local ARLastFix=0
local function aC()for _,c in ipairs(ARC)do pcall(function()c:Disconnect()end)end table.clear(ARC)for _,c in ipairs(ARCC)do pcall(function()c:Disconnect()end)end table.clear(ARCC)if ARHB then ARHB:Disconnect()ARHB=nil end end
local function aR(h,c)if not h or not h.Parent then return end if h.Health<=0 then return end pcall(function()if h.PlatformStand then h.PlatformStand=false end if not h.AutoRotate then h.AutoRotate=true end if h.Sit then h.Sit=false end if h.WalkSpeed==0 then h.WalkSpeed=16 end if h.JumpPower==0 then h.JumpPower=50 end if h.JumpHeight==0 then h.JumpHeight=7.2 end h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)h:SetStateEnabled(Enum.HumanoidStateType.Physics,false)h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)local s=h:GetState()if s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.FallingDown or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.Dead then h:ChangeState(Enum.HumanoidStateType.GettingUp)h:ChangeState(Enum.HumanoidStateType.Running)end end)if c then pcall(function()for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then if p.Anchored then p.Anchored=false end elseif p:IsA("Motor6D")then if not p.Enabled then p.Enabled=true end elseif p:IsA("BallSocketConstraint")or p:IsA("HingeConstraint")or p:IsA("RopeConstraint")or p:IsA("RodConstraint")or p:IsA("SpringConstraint")or p:IsA("UniversalConstraint")or p:IsA("NoCollisionConstraint")then local pn=p.Parent if pn and(pn.Name:lower():find("ragdoll")or pn.Name:lower():find("joint")or pn.Name:lower():find("constraint"))then pcall(function()p:Destroy()end)else pcall(function()p.Enabled=false end)end end end end)end end
local function aS(h,c)if not h then return end aR(h,c)table.insert(ARC,h.StateChanged:Connect(function(_,n)if not AR then return end if n==Enum.HumanoidStateType.Physics or n==Enum.HumanoidStateType.FallingDown or n==Enum.HumanoidStateType.Ragdoll then task.spawn(aR,h,c)end end))table.insert(ARC,h:GetPropertyChangedSignal("PlatformStand"):Connect(function()if not AR then return end if h.PlatformStand then task.spawn(aR,h,c)end end))table.insert(ARC,h:GetPropertyChangedSignal("AutoRotate"):Connect(function()if not AR then return end if not h.AutoRotate then h.AutoRotate=true end end))table.insert(ARC,h:GetPropertyChangedSignal("Sit"):Connect(function()if not AR then return end if h.Sit then h.Sit=false end end))table.insert(ARC,h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()if not AR then return end if h.WalkSpeed<1 then h.WalkSpeed=16 end end))table.insert(ARC,h:GetPropertyChangedSignal("JumpPower"):Connect(function()if not AR then return end if h.JumpPower<1 then h.JumpPower=50 end end))table.insert(ARC,h:GetPropertyChangedSignal("Health"):Connect(function()if not AR then return end if h.Health<=0 then task.spawn(aR,h,c)end end))local r=c:FindFirstChild("HumanoidRootPart")if r then table.insert(ARC,r:GetPropertyChangedSignal("Anchored"):Connect(function()if not AR then return end if r.Anchored then r.Anchored=false end end))end table.insert(ARCC,c.DescendantAdded:Connect(function(o)if not AR then return end task.wait(.03)if not AR or not o.Parent then return end if o:IsA("BasePart")then if o.Anchored then o.Anchored=false end elseif o:IsA("Motor6D")then if not o.Enabled then o.Enabled=true end elseif o:IsA("BallSocketConstraint")or o:IsA("HingeConstraint")or o:IsA("RopeConstraint")or o:IsA("RodConstraint")or o:IsA("SpringConstraint")or o:IsA("UniversalConstraint")or o:IsA("NoCollisionConstraint")then local pn=o.Parent if pn and(pn.Name:lower():find("ragdoll")or pn.Name:lower():find("joint")or pn.Name:lower():find("constraint"))then pcall(function()o:Destroy()end)else pcall(function()o.Enabled=false end)end end end))end
local function aSt()if not ARHB then ARHB=R.Heartbeat:Connect(function()if not AR then return end local nt=tick()if nt-ARLastFix<0.1 then return end ARLastFix=nt local c=LP.Character if not c then return end local h=c:FindFirstChildOfClass("Humanoid")if not h or h.Health<=0 then return end local s=h:GetState()if h.PlatformStand or s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.FallingDown or s==Enum.HumanoidStateType.Ragdoll then aR(h,c)end local r=c:FindFirstChild("HumanoidRootPart")if r and r.Anchored then r.Anchored=false end end)end local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid")if h then aS(h,c)end end table.insert(ARC,LP.CharacterAdded:Connect(function(nc)task.wait(.1)if not AR then return end local h=nc:WaitForChild("Humanoid",5)if h then aS(h,nc)aR(h,nc)end end))end
local function aSp()aC()local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid")if h then pcall(function()h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)h:SetStateEnabled(Enum.HumanoidStateType.Physics,true)h:SetStateEnabled(Enum.HumanoidStateType.Dead,true)end)end end end

local TC=false local TCC=nil local TD=100 local MT={}
local function iT(o)if not o or not o.Parent then return false end if not o:IsA("BasePart")then return false end if o.Name~="PlayerTrap"then return false end local p=o.Parent if p and p.Name=="Transient"then return true end return false end
local function tM(o)if not iT(o)then return end if MT[o]then return end pcall(function()MT[o]=true o.CanTouch=false o.CanCollide=false o.CanQuery=false o.CFrame=o.CFrame-Vector3.new(0,TD,0)local h=o:FindFirstChild("Hitbox")if h and h:IsA("BasePart")then h.CanTouch=false h.CanCollide=false h.CanQuery=false h.CFrame=h.CFrame-Vector3.new(0,TD,0)end end)end
local function tS()local t=W:FindFirstChild("Transient")if not t then return end for _,o in ipairs(t:GetChildren())do tM(o)end end
local function tSt()tS()TCC=W.DescendantAdded:Connect(function(o)if not TC then return end if o.Name~="PlayerTrap"then return end if not o:IsA("BasePart")then return end task.wait(.05)tM(o)end)end
local function tSp()if TCC then TCC:Disconnect()TCC=nil end table.clear(MT)end

local FL=false local FLC={}local FLS={}local FLD=false local FLA=nil
local function sP(o,p)if not FLS[o]then FLS[o]={}end if FLS[o][p]==nil then FLS[o][p]=o[p]end end
local function cV()pcall(function()for _,o in ipairs(L:GetChildren())do if o:IsA("BloomEffect")or o:IsA("BlurEffect")or o:IsA("ColorCorrectionEffect")or o:IsA("SunRaysEffect")or o:IsA("DepthOfFieldEffect")then sP(o,"Enabled")o.Enabled=false end end end)end
local function rV()pcall(function()for _,o in ipairs(L:GetChildren())do if o:IsA("BloomEffect")or o:IsA("BlurEffect")or o:IsA("ColorCorrectionEffect")or o:IsA("SunRaysEffect")or o:IsA("DepthOfFieldEffect")then local s=FLS[o]if s and s.Enabled~=nil then o.Enabled=s.Enabled end end end end)end
local function oO(o)pcall(function()if o:IsA("BasePart")then if o.Material~=Enum.Material.Plastic and o.Material~=Enum.Material.SmoothPlastic then sP(o,"Material")o.Material=Enum.Material.SmoothPlastic end if o.Reflectance>0 then sP(o,"Reflectance")o.Reflectance=0 end if o.CastShadow then sP(o,"CastShadow")o.CastShadow=false end elseif o:IsA("Decal")or o:IsA("Texture")then if o.Transparency<1 then sP(o,"Transparency")o.Transparency=1 end elseif o:IsA("Light")then if o.Enabled then sP(o,"Enabled")o.Enabled=false end elseif o:IsA("ParticleEmitter")or o:IsA("Trail")or o:IsA("Beam")or o:IsA("Fire")or o:IsA("Smoke")or o:IsA("Sparkles")then if o.Enabled then sP(o,"Enabled")o.Enabled=false end end end)end
local function oW()if FLD then return end FLD=true task.spawn(function()pcall(function()sP(W,"StreamingEnabled")W.StreamingEnabled=false end)local c=0 pcall(function()for _,o in ipairs(W:GetDescendants())do c=c+1 oO(o)if c%500==0 then task.wait()end end end)FLD=false end)end
local function rW()pcall(function()for o,ps in pairs(FLS)do if o then for p,v in pairs(ps)do pcall(function()o[p]=v end)end end end end)table.clear(FLS)end
local function fSt()cV()oW()if not FLA then FLA=W.DescendantAdded:Connect(function(o)if not FL then return end task.wait(.05)if not FL or not o.Parent then return end oO(o)end)end table.insert(FLC,LP.CharacterAdded:Connect(function()task.wait(1)if FL then cV()end end))end
local function fSp()for _,c in ipairs(FLC)do pcall(function()c:Disconnect()end)end table.clear(FLC)if FLA then FLA:Disconnect()FLA=nil end rV()rW()end

local AF=true local AS={}local AU={}local AD=setmetatable({},{__index=function()return function()end end})
local function aG()if type(getconnections)~="function"then return{}end local o,r=pcall(getconnections,LP.Idled)return o and type(r)=="table"and r or{}end
local function aSi()for _,c in ipairs(aG())do if pcall(function()c:Disable()end)then AS[#AS+1]=c end end end
local function aRe()local l=AS if#l==0 then l=aG()end for _,c in ipairs(l)do pcall(function()c:Enable()end)end table.clear(AS)end
local function aF()local out={}if type(getgc)~="function"or type(debug)~="table"or type(debug.getupvalues)~="function"then return out end local o,r=pcall(getgc,false)if not o or type(r)~="table"then return out end for _,f in ipairs(r)do if type(f)=="function"and islclosure(f)then local o2,s=pcall(debug.info,f,"s")if o2 and type(s)=="string"and string.find(s,"AntiAFK",1,true)then local o3,u=pcall(debug.getupvalues,f)if o3 and type(u)=="table"then for k,v in pairs(u)do if typeof(v)=="Instance"and v.ClassName=="TeleportService"then out[#out+1]={Fn=f,Index=k,Original=v}end end end end end end return out end
local function aP()for _,h in ipairs(aF())do local o,v=pcall(debug.getupvalue,h.Fn,h.Index)if o and typeof(v)=="Instance"then if pcall(debug.setupvalue,h.Fn,h.Index,AD)then AU[#AU+1]=h end end end end
local function aU()for _,h in ipairs(AU)do pcall(debug.setupvalue,h.Fn,h.Index,h.Original)end table.clear(AU)end
local function aE()aSi()if#AU==0 then aP()end end
task.spawn(function()while true do if AF then pcall(aE)end task.wait(600)end end)
task.spawn(function()task.wait(1)if AF then pcall(aE)end end)

getgenv().Tungtung_BypassEnabled=true
getgenv().Tungtung_AntiHit=false
getgenv().Tungtung_BypassProximity=false
getgenv().Tungtung_FixLag=false
getgenv().Tungtung_AntiAfk=true
getgenv().Tungtung_AntiRagdoll=false

pcall(function()if hookfunction and getrawmetatable then local mt=getrawmetatable(game)if mt then local on=mt.__namecall setreadonly(mt,false)mt.__namecall=newcclosure(function(s,...)local m=getnamecallmethod()if m=="Kick"then return nil end return on(s,...)end)setreadonly(mt,true)end end end)
task.spawn(function()task.wait(5)pcall(function()for _,o in ipairs(game:GetDescendants())do if o:IsA("RemoteEvent")or o:IsA("RemoteFunction")then local n=string.lower(o.Name)if n:find("detect")or n:find("cheat")or n:find("kick")or n:find("ban")or n:find("report")or n:find("flag")then if getconnections then for _,c in ipairs(getconnections(o.OnClientEvent))do pcall(function()c:Disable()end)end end end end end end)end)

local CU="https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Config"
local o,r=pcall(function()return game:HttpGet(CU.."?v="..tick(),true)end)if not o or not r then return end local f=loadstring(r)if not f then return end local o2,cfg=pcall(f)if not o2 or type(cfg)~="table"then return end
local SH,LA=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET local BN="Tungtung v3.1"local NN="Tungtung Hub"

local MG=Instance.new("ScreenGui")MG.Name="TungTungIntro"MG.ResetOnSpawn=false MG.IgnoreGuiInset=true MG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling MG.DisplayOrder=2147483647 pcall(function()MG.Parent=GC()end)if not MG.Parent then MG.Parent=PG end
local DO=Instance.new("Frame")DO.Size=UDim2.fromScale(1,1)DO.BackgroundColor3=Color3.fromRGB(0,0,0)DO.BackgroundTransparency=1 DO.BorderSizePixel=0 DO.ZIndex=99 DO.Parent=MG
local C=Instance.new("Frame")C.AnchorPoint=Vector2.new(.5,.5)C.Position=UDim2.fromScale(.5,.54)C.Size=UDim2.fromOffset(340,200)C.BackgroundColor3=Color3.fromRGB(14,14,16)C.BackgroundTransparency=1 C.ClipsDescendants=true C.ZIndex=100 C.Parent=MG
local LG=Instance.new("UIGradient")LG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(.28,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(.4,Color3.fromRGB(70,70,70)),ColorSequenceKeypoint.new(.46,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(.54,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(.6,Color3.fromRGB(70,70,70)),ColorSequenceKeypoint.new(.72,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))})LG.Rotation=0 LG.Offset=Vector2.new(1.35,0)LG.Parent=C
task.spawn(function()while MG.Parent and C.Parent do LG.Offset=Vector2.new(1.35,0)local s=T:Create(LG,TweenInfo.new(2.8,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Offset=Vector2.new(-1.35,0)})s:Play()s.Completed:Wait()LG.Offset=Vector2.new(1.35,0)task.wait(.18)end end)
Instance.new("UICorner",C).CornerRadius=UDim.new(0,14)
local CS=Instance.new("UIStroke")CS.Color=Color3.fromRGB(255,255,255)CS.Transparency=1 CS.Thickness=1.2 CS.ApplyStrokeMode=Enum.ApplyStrokeMode.Border CS.Parent=C
local LO=Instance.new("ImageLabel")LO.AnchorPoint=Vector2.new(.5,0)LO.Position=UDim2.new(.5,0,.12,0)LO.Size=UDim2.fromOffset(56,56)LO.BackgroundTransparency=1 LO.Image=LA LO.ImageTransparency=1 LO.ScaleType=Enum.ScaleType.Fit LO.ZIndex=101 LO.Parent=C Instance.new("UICorner",LO).CornerRadius=UDim.new(0,10)
local TI=Instance.new("TextLabel")TI.AnchorPoint=Vector2.new(.5,0)TI.Position=UDim2.new(.5,0,.43,0)TI.Size=UDim2.new(.9,0,0,24)TI.BackgroundTransparency=1 TI.Text="TUNGTUNG"TI.TextColor3=Color3.fromRGB(255,255,255)TI.TextTransparency=1 TI.Font=Enum.Font.FredokaOne TI.TextSize=20 TI.ZIndex=101 TI.Parent=C
local DT=Instance.new("TextLabel")DT.AnchorPoint=Vector2.new(.5,0)DT.Position=UDim2.new(.5,0,.56,0)DT.Size=UDim2.new(.9,0,0,18)DT.BackgroundTransparency=1 DT.Text=BN.." • "..SH DT.TextColor3=Color3.fromRGB(160,160,165)DT.TextTransparency=1 DT.Font=Enum.Font.FredokaOne DT.TextSize=12 DT.ZIndex=101 DT.Parent=C
local PBg=Instance.new("Frame")PBg.AnchorPoint=Vector2.new(.5,0)PBg.Position=UDim2.new(.5,0,.76,0)PBg.Size=UDim2.new(.78,0,0,5)PBg.BackgroundColor3=Color3.fromRGB(30,30,35)PBg.BackgroundTransparency=1 PBg.BorderSizePixel=0 PBg.ZIndex=101 PBg.Parent=C Instance.new("UICorner",PBg).CornerRadius=UDim.new(1,0)
local PF=Instance.new("Frame")PF.Position=UDim2.new(0,0,0,0)PF.Size=UDim2.new(0,0,1,0)PF.BackgroundColor3=Color3.fromRGB(255,255,255)PF.BackgroundTransparency=1 PF.BorderSizePixel=0 PF.ZIndex=102 PF.Parent=PBg Instance.new("UICorner",PF).CornerRadius=UDim.new(1,0)
local ST=Instance.new("TextLabel")ST.AnchorPoint=Vector2.new(.5,0)ST.Position=UDim2.new(.5,0,.84,0)ST.Size=UDim2.new(.8,0,0,14)ST.BackgroundTransparency=1 ST.Text="Initializing Tungtung Hub..."ST.TextColor3=Color3.fromRGB(120,120,125)ST.TextTransparency=1 ST.Font=Enum.Font.Gotham ST.TextSize=11 ST.ZIndex=101 ST.Parent=C
local tF=TweenInfo.new(.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)local tP=TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
T:Create(DO,tF,{BackgroundTransparency=.45}):Play()task.wait(.07)T:Create(C,tP,{Position=UDim2.fromScale(.5,.5),BackgroundTransparency=.05}):Play()T:Create(CS,tF,{Transparency=.88}):Play()task.wait(.15)T:Create(LO,tF,{ImageTransparency=0}):Play()T:Create(TI,tF,{TextTransparency=0}):Play()T:Create(DT,tF,{TextTransparency=0}):Play()T:Create(PBg,tF,{BackgroundTransparency=0}):Play()T:Create(PF,tF,{BackgroundTransparency=0}):Play()T:Create(ST,tF,{TextTransparency=0}):Play()task.wait(.25)ST.Text="Loading scripts & assets..."T:Create(PF,TweenInfo.new(1.1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(1,0,1,0)}):Play()task.wait(1.1)ST.Text="TUNGTUNG"ST.TextColor3=Color3.fromRGB(255,255,255)task.wait(.7)
local tO=TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In)T:Create(C,tO,{Position=UDim2.fromScale(.5,.46),BackgroundTransparency=1}):Play()T:Create(CS,tO,{Transparency=1}):Play()T:Create(DO,tO,{BackgroundTransparency=1}):Play()T:Create(LO,tO,{ImageTransparency=1}):Play()T:Create(TI,tO,{TextTransparency=1}):Play()T:Create(DT,tO,{TextTransparency=1}):Play()T:Create(PBg,tO,{BackgroundTransparency=1}):Play()T:Create(PF,tO,{BackgroundTransparency=1}):Play()T:Create(ST,tO,{TextTransparency=1}):Play()task.wait(.45)MG:Destroy()

local function SM()
	local SG2=Instance.new("ScreenGui")SG2.Name="TungTungScreen"SG2.ResetOnSpawn=false SG2.IgnoreGuiInset=true SG2.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG2.DisplayOrder=99999 pcall(function()SG2.Parent=GC()end)if not SG2.Parent then SG2.Parent=PG end

	local FB=Instance.new("ImageButton")FB.Size=UDim2.fromOffset(36,36)FB.Position=UDim2.new(0,10,0,90)FB.BackgroundColor3=Color3.fromRGB(20,20,25)FB.BorderSizePixel=0 FB.ScaleType=Enum.ScaleType.Fit FB.Image=LA FB.ZIndex=10001 FB.Parent=SG2 Instance.new("UICorner",FB).CornerRadius=UDim.new(1,0)local fS2=Instance.new("UIStroke",FB)fS2.Thickness=1.5 fS2.Color=Color3.fromRGB(150,80,255)

	local pn=Instance.new("Frame")pn.Size=UDim2.fromOffset(200,272)pn.Position=UDim2.new(1,-210,0,10)pn.BackgroundColor3=Color3.fromRGB(12,12,16)pn.BorderSizePixel=0 pn.ZIndex=5000 pn.Parent=SG2 Instance.new("UICorner",pn).CornerRadius=UDim.new(0,10)local pG=Instance.new("UIGradient",pn)pG.Rotation=135 pG.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(25,15,45)),ColorSequenceKeypoint.new(1,Color3.fromRGB(10,8,18))}local pS=Instance.new("UIStroke",pn)pS.Thickness=1 pS.Color=Color3.fromRGB(130,60,255)

	local hd=Instance.new("Frame")hd.Size=UDim2.new(1,0,0,32)hd.BackgroundTransparency=1 hd.ZIndex=5001 hd.Parent=pn
	local lg=Instance.new("ImageLabel")lg.Size=UDim2.fromOffset(22,22)lg.Position=UDim2.new(0,8,0,5)lg.BackgroundTransparency=1 lg.ScaleType=Enum.ScaleType.Fit lg.Image=LA lg.ZIndex=5002 lg.Parent=hd
	local tt=Instance.new("TextLabel")tt.Size=UDim2.new(1,-80,0,14)tt.Position=UDim2.new(0,36,0,5)tt.BackgroundTransparency=1 tt.Text=BN tt.TextColor3=Color3.fromRGB(240,220,255)tt.Font=Enum.Font.GothamBlack tt.TextSize=11 tt.TextXAlignment=Enum.TextXAlignment.Left tt.ZIndex=5002 tt.Parent=hd local tG=Instance.new("UIGradient",tt)tG.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(253,230,138)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,150,255))}
	local sb=Instance.new("TextLabel")sb.Size=UDim2.new(1,-40,0,10)sb.Position=UDim2.new(0,36,0,19)sb.BackgroundTransparency=1 sb.Text=SH sb.TextColor3=Color3.fromRGB(140,130,170)sb.Font=Enum.Font.GothamMedium sb.TextSize=8 sb.TextXAlignment=Enum.TextXAlignment.Left sb.ZIndex=5002 sb.Parent=hd

	local ct=Instance.new("Frame")ct.Size=UDim2.new(1,-12,1,-42)ct.Position=UDim2.new(0,6,0,36)ct.BackgroundTransparency=1 ct.ZIndex=5001 ct.Parent=pn

	local function mR(y,lt,gS,oT)
		local rw=Instance.new("Frame")rw.Size=UDim2.new(1,0,0,35)rw.Position=UDim2.new(0,0,0,y)rw.BackgroundColor3=Color3.fromRGB(18,18,24)rw.BorderSizePixel=0 rw.ZIndex=5002 rw.Parent=ct Instance.new("UICorner",rw).CornerRadius=UDim.new(0,8)local rG=Instance.new("UIGradient",rw)rG.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(25,20,40)),ColorSequenceKeypoint.new(1,Color3.fromRGB(15,12,25))}local rS=Instance.new("UIStroke",rw)rS.Thickness=1 rS.Color=Color3.fromRGB(60,40,100)
		local lb=Instance.new("TextLabel")lb.Size=UDim2.new(1,-56,1,0)lb.Position=UDim2.new(0,10,0,0)lb.BackgroundTransparency=1 lb.Text=lt lb.TextColor3=Color3.fromRGB(240,240,255)lb.Font=Enum.Font.GothamBold lb.TextSize=10 lb.TextXAlignment=Enum.TextXAlignment.Left lb.ZIndex=5003 lb.Parent=rw
		local tk=Instance.new("Frame")tk.Size=UDim2.fromOffset(38,18)tk.Position=UDim2.new(1,-46,.5,-9)tk.BackgroundColor3=gS()and Color3.fromRGB(130,80,255)or Color3.fromRGB(45,45,60)tk.ZIndex=5003 tk.Parent=rw Instance.new("UICorner",tk).CornerRadius=UDim.new(1,0)
		local kb=Instance.new("Frame")kb.Size=UDim2.fromOffset(14,14)kb.Position=gS()and UDim2.new(1,-17,.5,-7)or UDim2.new(0,2,.5,-7)kb.BackgroundColor3=gS()and Color3.fromRGB(255,255,255)or Color3.fromRGB(200,200,220)kb.ZIndex=5004 kb.Parent=tk Instance.new("UICorner",kb).CornerRadius=UDim.new(1,0)
		local cb=Instance.new("TextButton")cb.Size=UDim2.new(1,0,1,0)cb.BackgroundTransparency=1 cb.Text=""cb.ZIndex=5005 cb.Parent=rw
		cb.MouseButton1Click:Connect(function()local i=oT()if i then T:Create(tk,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(130,80,255)}):Play()T:Create(kb,TweenInfo.new(.2),{Position=UDim2.new(1,-17,.5,-7),BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()else T:Create(tk,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(45,45,60)}):Play()T:Create(kb,TweenInfo.new(.2),{Position=UDim2.new(0,2,.5,-7),BackgroundColor3=Color3.fromRGB(200,200,220)}):Play()end end)
	end

	mR(0,"Super Anti Hit",function()return AH end,function()AH=not AH getgenv().Tungtung_AntiHit=AH pcall(function()SG:SetCore("SendNotification",{Title=NN,Text=AH and"Anti-Hit ON"or"Anti-Hit OFF",Duration=2})end)return AH end)
	mR(38,"Bypass Proximity",function()return BP end,function()BP=not BP getgenv().Tungtung_BypassProximity=BP if BP then AB()else RB()end pcall(function()SG:SetCore("SendNotification",{Title=NN,Text=BP and"Bypass Proximity ON"or"Bypass Proximity OFF",Duration=2})end)return BP end)
	mR(76,"Anti Ragdoll",function()return AR end,function()AR=not AR getgenv().Tungtung_AntiRagdoll=AR if AR then aSt()local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid")aR(h,c)end else aSp()if ARHB then ARHB:Disconnect()ARHB=nil end aC()end pcall(function()SG:SetCore("SendNotification",{Title=NN,Text=AR and"Anti-Ragdoll ON"or"Anti-Ragdoll OFF",Duration=2})end)return AR end)
	mR(114,"Trap Cleaner",function()return TC end,function()TC=not TC if TC then tSt()else tSp()end pcall(function()SG:SetCore("SendNotification",{Title=NN,Text=TC and"Trap Cleaner ON"or"Trap Cleaner OFF",Duration=2})end)return TC end)
	mR(152,"Fix Lag",function()return FL end,function()FL=not FL getgenv().Tungtung_FixLag=FL if FL then fSt()else fSp()end pcall(function()SG:SetCore("SendNotification",{Title=NN,Text=FL and"Fix Lag ON"or"Fix Lag OFF",Duration=2})end)return FL end)
	mR(190,"Anti AFK",function()return AF end,function()AF=not AF getgenv().Tungtung_AntiAfk=AF if AF then pcall(aE)else aRe()aU()end pcall(function()SG:SetCore("SendNotification",{Title=NN,Text=AF and"Anti AFK ON"or"Anti AFK OFF",Duration=2})end)return AF end)

	local dg,ds,sp hd.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true ds=i.Position sp=pn.Position end end)UI.InputChanged:Connect(function(i)if dg and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-ds pn.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)end end)UI.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
	FB.MouseButton1Click:Connect(function()pn.Visible=not pn.Visible end)
end
SM()
