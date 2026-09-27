local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local UserInputService=game:GetService("UserInputService")
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local CoreGui=game:GetService("CoreGui")
local HttpService=game:GetService("HttpService")
local LP=Players.LocalPlayer
local PlayerGui=LP:WaitForChild("PlayerGui")

local CONFIG_URL="https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Config"

local function GC()
    if gethui then local ok,h=pcall(gethui) if ok and h then return h end end
    return CoreGui or PlayerGui
end

for _,n in ipairs({"TungTungScreen","TungTung_TimeUI","TungTung_KeyUI","TungTung_Ended","TungTungLoading"}) do
    pcall(function() if PlayerGui:FindFirstChild(n) then PlayerGui[n]:Destroy() end end)
    pcall(function() if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end end)
end

local ok,raw=pcall(function() return game:HttpGet(CONFIG_URL.."?v="..tick(),true) end)
if not ok or not raw then warn("[CONFIG] fail") return end
local fn=loadstring(raw) if not fn then return end
local ok2,cfg=pcall(fn) if not ok2 or type(cfg)~="table" then return end

local JSONBIN_KEY,JSONBIN_BIN=cfg.JSONBIN_KEY,cfg.JSONBIN_BIN
local JSONBIN_URL="https://api.jsonbin.io/v3/b/"..JSONBIN_BIN
local PASTEFY_TOKEN,LINK4M_TOKEN=cfg.PASTEFY_TOKEN,cfg.LINK4M_TOKEN
local SOCIAL_HANDLE,LOGO_ASSET=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local STEAL_HOLD,KEY_DURATION=cfg.STEAL_HOLD,cfg.KEY_DURATION
local TRIAL_DURATION=cfg.TRIAL_DURATION or 600
local END_TIMESTAMP=cfg.TEST_END_TIMESTAMP or 0
local BRAND_NAME="Tungtung"

if END_TIMESTAMP>0 and os.time()>=END_TIMESTAMP then
    local G=Instance.new("ScreenGui")
    G.Name="TungTung_Ended"
    G.ResetOnSpawn=false
    G.IgnoreGuiInset=true
    G.DisplayOrder=2147483647
    pcall(function() G.Parent=GC() end)
    if not G.Parent then G.Parent=PlayerGui end
    local Main=Instance.new("Frame")
    Main.Size=UDim2.new(0,320,0,120)
    Main.Position=UDim2.new(.5,-160,.5,-60)
    Main.BackgroundColor3=Color3.fromRGB(15,12,22)
    Main.BorderSizePixel=0
    Main.Parent=G
    Instance.new("UICorner",Main).CornerRadius=UDim.new(0,12)
    local S=Instance.new("UIStroke",Main)
    S.Thickness=1.5
    S.Color=Color3.fromRGB(200,50,50)
    local Title=Instance.new("TextLabel")
    Title.Size=UDim2.new(1,-20,0,36)
    Title.Position=UDim2.new(0,10,0,20)
    Title.BackgroundTransparency=1
    Title.Text="HẾT TRIAL"
    Title.TextColor3=Color3.fromRGB(239,68,68)
    Title.TextSize=20
    Title.Font=Enum.Font.GothamBlack
    Title.Parent=Main
    local Msg=Instance.new("TextLabel")
    Msg.Size=UDim2.new(1,-20,0,40)
    Msg.Position=UDim2.new(0,10,0,60)
    Msg.BackgroundTransparency=1
    Msg.Text="Trial đã hết.\nVui lòng quay lại sau."
    Msg.TextColor3=Color3.fromRGB(200,200,200)
    Msg.TextSize=12
    Msg.Font=Enum.Font.Gotham
    Msg.TextWrapped=true
    Msg.Parent=Main
    return
end

local function HttpReq(o) local f=(syn and syn.request) or (http and http.request) or http_request or request if f then return f(o) end return nil end
local function GetBin()
    local r=HttpReq({Url=JSONBIN_URL.."/latest",Method="GET",Headers={["X-Master-Key"]=JSONBIN_KEY}})
    if r and r.Body then
        local o,d=pcall(function() return HttpService:JSONDecode(r.Body) end)
        if o and d and d.record then return d.record end
    end
    return {}
end
local function UpdateBin(d)
    local r=HttpReq({Url=JSONBIN_URL,Method="PUT",Headers={["Content-Type"]="application/json",["X-Master-Key"]=JSONBIN_KEY},Body=HttpService:JSONEncode(d)})
    return r~=nil
end
local function getHWID()
    if gethwid then local o,h=pcall(gethwid) if o and h then return tostring(h) end end
    if syn and syn.get_hwid then local o,h=pcall(function() return syn.get_hwid() end) if o and h then return tostring(h) end end
    return tostring(LP.UserId).."_"..tostring(LP.AccountAge)
end
local HWID,USERNAME=getHWID(),LP.Name

local function CheckTrialFromServer()
    local t,now=GetBin(),os.time()
    if t[HWID] then
        local e=t[HWID]
        e.last_seen=now
        e.username=USERNAME
        e.userid=LP.UserId
        e.display="@"..USERNAME
        UpdateBin(t)
        if e.key_activated and e.expire then
            local l=e.expire-now
            if l>0 then return "premium",l else return "expired",0 end
        end
        local s=e.start or now
        local r=TRIAL_DURATION-(now-s)
        if r<=0 then return "expired",0 end
        return "active",r
    else
        t[HWID]={
            start=now,first_seen=now,last_seen=now,
            username=USERNAME,userid=LP.UserId,
            display="@"..USERNAME,
            key_activated=false,spam_count=0
        }
        UpdateBin(t)
        return "started",TRIAL_DURATION
    end
end

local LoadingGui=Instance.new("ScreenGui")
LoadingGui.Name="TungTungLoading"
LoadingGui.ResetOnSpawn=false
LoadingGui.IgnoreGuiInset=true
LoadingGui.DisplayOrder=2147483647
pcall(function() LoadingGui.Parent=GC() end)
if not LoadingGui.Parent then LoadingGui.Parent=PlayerGui end

local bg=Instance.new("Frame")
bg.Size=UDim2.new(1,0,1,0)
bg.BackgroundColor3=Color3.fromRGB(0,0,0)
bg.BorderSizePixel=0
bg.Parent=LoadingGui

local center=Instance.new("Frame")
center.Size=UDim2.new(0,320,0,120)
center.Position=UDim2.new(.5,-160,.5,-60)
center.BackgroundColor3=Color3.fromRGB(12,12,16)
center.BorderSizePixel=0
center.Parent=LoadingGui
Instance.new("UICorner",center).CornerRadius=UDim.new(0,12)

local st=Instance.new("UIStroke",center)
st.Thickness=1.5
st.Color=Color3.fromRGB(130,60,255)

local lg=Instance.new("ImageLabel")
lg.Size=UDim2.fromOffset(40,40)
lg.Position=UDim2.new(0,15,0,15)
lg.BackgroundTransparency=1
lg.ScaleType=Enum.ScaleType.Fit
lg.Image=LOGO_ASSET
lg.Parent=center

local lt=Instance.new("TextLabel")
lt.Size=UDim2.new(1,-70,0,22)
lt.Position=UDim2.new(0,62,0,15)
lt.BackgroundTransparency=1
lt.Text="ĐANG TẢI SCRIPT"
lt.TextColor3=Color3.fromRGB(240,220,255)
lt.Font=Enum.Font.GothamBlack
lt.TextSize=15
lt.TextXAlignment=Enum.TextXAlignment.Left
lt.Parent=center

local ls=Instance.new("TextLabel")
ls.Size=UDim2.new(1,-30,0,16)
ls.Position=UDim2.new(0,15,0,45)
ls.BackgroundTransparency=1
ls.Text="Hoàn thành trong 3s..."
ls.TextColor3=Color3.fromRGB(180,150,220)
ls.Font=Enum.Font.Gotham
ls.TextSize=11
ls.TextXAlignment=Enum.TextXAlignment.Left
ls.Parent=center

local barBg=Instance.new("Frame")
barBg.Size=UDim2.new(1,-30,0,6)
barBg.Position=UDim2.new(0,15,1,-25)
barBg.BackgroundColor3=Color3.fromRGB(30,20,40)
barBg.BorderSizePixel=0
barBg.Parent=center
Instance.new("UICorner",barBg).CornerRadius=UDim.new(1,0)

local bar=Instance.new("Frame")
bar.Size=UDim2.new(0,0,1,0)
bar.BackgroundColor3=Color3.fromRGB(130,80,255)
bar.BorderSizePixel=0
bar.Parent=barBg
Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

TweenService:Create(bar,TweenInfo.new(3,Enum.EasingStyle.Linear),{Size=UDim2.new(1,0,1,0)}):Play()
task.wait(3)
LoadingGui:Destroy()

getgenv().Tungtung_AntiHit=false
getgenv().Tungtung_BypassEnabled=true

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
    while getgenv().Tungtung_BypassEnabled do
        task.wait(0.1)
        pcall(function()
            local char=LP.Character
            if char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Teleporting,true) end
            end
        end)
    end
end)

task.spawn(function()
    while getgenv().Tungtung_BypassEnabled do
        task.wait(0.5)
        pcall(function()
            local char=LP.Character
            if char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if hum.WalkSpeed>20 then hum.WalkSpeed=16 end
                    if hum.JumpPower>55 then hum.JumpPower=50 end
                end
            end
        end)
    end
end)

task.spawn(function()
    task.wait(3)
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

local function TeleportRoute(character)
    if not character then return end
    local root=character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    IsAntiHitRunning=true
    for _,position in ipairs(TeleportPoints) do
        if not AntiHitEnabled or not root.Parent then
            IsAntiHitRunning=false
            return
        end
        root.CFrame=CFrame.new(position)
        task.wait(ANTI_HIT_SPEED)
    end
    IsAntiHitRunning=false
end

ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
    if player~=LP then return end
    if not AntiHitEnabled or IsAntiHitRunning then return end
    local character=LP.Character
    if not character then return end
    task.spawn(function() TeleportRoute(character) end)
end)

local function FormatTime(s)
    if s<0 then s=0 end
    local h=math.floor(s/3600)
    local m=math.floor((s%3600)/60)
    local sc=math.floor(s%60)
    if h>0 then return string.format("%02d:%02d:%02d",h,m,sc) end
    return string.format("%02d:%02d",m,sc)
end

local currentMode="TRIAL"
local EndTime=os.time()+TRIAL_DURATION
local TimeGui

local function ShowTimeUI()
    if TimeGui then pcall(function() TimeGui:Destroy() end) end
    TimeGui=Instance.new("ScreenGui")
    TimeGui.Name="TungTung_TimeUI"
    TimeGui.ResetOnSpawn=false
    TimeGui.IgnoreGuiInset=true
    TimeGui.DisplayOrder=9998
    pcall(function() TimeGui.Parent=GC() end)
    if not TimeGui.Parent then TimeGui.Parent=PlayerGui end

    local TF=Instance.new("Frame")
    TF.Size=UDim2.new(0,150,0,40)
    TF.Position=UDim2.new(0,10,0,10)
    TF.BackgroundColor3=Color3.fromRGB(15,10,20)
    TF.BackgroundTransparency=0.15
    TF.BorderSizePixel=0
    TF.Parent=TimeGui
    Instance.new("UICorner",TF).CornerRadius=UDim.new(0,10)
    local TS=Instance.new("UIStroke",TF)
    TS.Thickness=1.3
    TS.Color=Color3.fromRGB(168,85,247)
    local TD=Instance.new("Frame")
    TD.Size=UDim2.new(0,6,0,6)
    TD.Position=UDim2.new(0,8,0,8)
    TD.BackgroundColor3=Color3.fromRGB(0,255,163)
    TD.BorderSizePixel=0
    TD.Parent=TF
    Instance.new("UICorner",TD).CornerRadius=UDim.new(1,0)
    local TT=Instance.new("TextLabel")
    TT.Size=UDim2.new(1,-22,0,14)
    TT.Position=UDim2.new(0,18,0,4)
    TT.BackgroundTransparency=1
    TT.Text="TUNGTUNG"
    TT.TextColor3=Color3.fromRGB(253,230,138)
    TT.TextSize=9
    TT.Font=Enum.Font.GothamBlack
    TT.TextXAlignment=Enum.TextXAlignment.Left
    TT.Parent=TF
    local TM=Instance.new("TextLabel")
    TM.Size=UDim2.new(1,-12,0,14)
    TM.Position=UDim2.new(0,6,0,20)
    TM.BackgroundTransparency=1
    TM.Text="TRIAL"
    TM.TextColor3=Color3.fromRGB(245,158,11)
    TM.TextSize=9
    TM.Font=Enum.Font.GothamBold
    TM.TextXAlignment=Enum.TextXAlignment.Left
    TM.Parent=TF
    local TV=Instance.new("TextLabel")
    TV.Size=UDim2.new(1,-12,0,14)
    TV.Position=UDim2.new(0,6,0,26)
    TV.BackgroundTransparency=1
    TV.Text="00:00"
    TV.TextColor3=Color3.fromRGB(0,255,163)
    TV.TextSize=11
    TV.Font=Enum.Font.Code
    TV.TextXAlignment=Enum.TextXAlignment.Left
    TV.Parent=TF

    task.spawn(function()
        while TimeGui and TimeGui.Parent do
            local r=EndTime-os.time()
            if r<0 then r=0 end
            local col=Color3.fromRGB(245,158,11)
            if currentMode=="NORMAL" then
                col=Color3.fromRGB(0,255,163)
            end
            if r<=0 then
                col=Color3.fromRGB(239,68,68)
            end
            TD.BackgroundColor3=col
            TM.Text=currentMode
            TM.TextColor3=col
            TV.Text=FormatTime(r)
            TV.TextColor3=col
            task.wait(1)
        end
    end)
end

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
    panel.Size=UDim2.fromOffset(300,110)
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

    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,46)
    row.Position=UDim2.new(0,0,0,0)
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
    lbl.Text="Super Anti Hit ⚡"
    lbl.TextColor3=Color3.fromRGB(240,240,255)
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=12
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.ZIndex=5003
    lbl.Parent=row
    local track=Instance.new("Frame")
    track.Size=UDim2.fromOffset(48,24)
    track.Position=UDim2.new(1,-60,0.5,-12)
    track.BackgroundColor3=Color3.fromRGB(45,45,60)
    track.ZIndex=5003
    track.Parent=row
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame")
    knob.Size=UDim2.fromOffset(18,18)
    knob.Position=UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3=Color3.fromRGB(200,200,220)
    knob.ZIndex=5004
    knob.Parent=track
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local clickBtn=Instance.new("TextButton")
    clickBtn.Size=UDim2.new(1,0,1,0)
    clickBtn.BackgroundTransparency=1
    clickBtn.Text=""
    clickBtn.ZIndex=5005
    clickBtn.Parent=row
    local isOn=false
    clickBtn.MouseButton1Click:Connect(function()
        isOn=not isOn
        AntiHitEnabled=isOn
        getgenv().Tungtung_AntiHit=isOn
        if isOn then
            TweenService:Create(track,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(130,80,255)}):Play()
            TweenService:Create(knob,TweenInfo.new(.2),{Position=UDim2.new(1,-21,0.5,-9),BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
        else
            TweenService:Create(track,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(45,45,60)}):Play()
            TweenService:Create(knob,TweenInfo.new(.2),{Position=UDim2.new(0,3,0.5,-9),BackgroundColor3=Color3.fromRGB(200,200,220)}):Play()
        end
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title=BRAND_NAME,
                Text=isOn and "Anti-Hit ON" or "Anti-Hit OFF",
                Duration=2,
            })
        end)
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

local function ShowKeyUI()
    local KeyGui=Instance.new("ScreenGui")
    KeyGui.Name="TungTung_KeyUI"
    KeyGui.ResetOnSpawn=false
    KeyGui.IgnoreGuiInset=true
    KeyGui.DisplayOrder=9999
    pcall(function() KeyGui.Parent=GC() end)
    if not KeyGui.Parent then KeyGui.Parent=PlayerGui end

    local KF=Instance.new("Frame")
    KF.Size=UDim2.new(0,300,0,160)
    KF.Position=UDim2.new(0.5,-150,0.5,-80)
    KF.BackgroundColor3=Color3.fromRGB(15,12,22)
    KF.BorderSizePixel=0
    KF.Parent=KeyGui
    Instance.new("UICorner",KF).CornerRadius=UDim.new(0,14)
    local KS=Instance.new("UIStroke",KF)
    KS.Thickness=1.5
    KS.Color=Color3.fromRGB(168,85,247)

    local KL=Instance.new("ImageLabel")
    KL.Size=UDim2.fromOffset(36,36)
    KL.Position=UDim2.new(0,12,0,10)
    KL.BackgroundTransparency=1
    KL.ScaleType=Enum.ScaleType.Fit
    KL.Image=LOGO_ASSET
    KL.Parent=KF

    local KT=Instance.new("TextLabel")
    KT.Size=UDim2.new(1,-60,0,20)
    KT.Position=UDim2.new(0,55,0,14)
    KT.BackgroundTransparency=1
    KT.Text=BRAND_NAME
    KT.TextColor3=Color3.fromRGB(253,230,138)
    KT.TextSize=14
    KT.Font=Enum.Font.GothamBlack
    KT.TextXAlignment=Enum.TextXAlignment.Left
    KT.Parent=KF

    local KI=Instance.new("TextBox")
    KI.Size=UDim2.new(1,-20,0,32)
    KI.Position=UDim2.new(0,10,0,55)
    KI.BackgroundColor3=Color3.fromRGB(22,14,32)
    KI.TextColor3=Color3.fromRGB(254,243,199)
    KI.PlaceholderColor3=Color3.fromRGB(147,112,175)
    KI.PlaceholderText="Dán key..."
    KI.Text=""
    KI.TextSize=11
    KI.ClearTextOnFocus=false
    KI.Font=Enum.Font.Gotham
    KI.Parent=KF
    Instance.new("UICorner",KI).CornerRadius=UDim.new(0,8)

    local KG=Instance.new("TextButton")
    KG.Size=UDim2.new(0.48,0,0,34)
    KG.Position=UDim2.new(0,10,0,96)
    KG.BackgroundColor3=Color3.fromRGB(124,92,255)
    KG.Text="GET KEY"
    KG.TextColor3=Color3.fromRGB(255,255,255)
    KG.TextSize=11
    KG.Font=Enum.Font.GothamBold
    KG.BorderSizePixel=0
    KG.Parent=KF
    Instance.new("UICorner",KG).CornerRadius=UDim.new(0,8)

    local KA=Instance.new("TextButton")
    KA.Size=UDim2.new(0.48,0,0,34)
    KA.Position=UDim2.new(0.52,0,0,96)
    KA.BackgroundColor3=Color3.fromRGB(245,158,11)
    KA.Text="KÍCH HOẠT"
    KA.TextColor3=Color3.fromRGB(22,14,3)
    KA.TextSize=11
    KA.Font=Enum.Font.GothamBold
    KA.BorderSizePixel=0
    KA.Parent=KF
    Instance.new("UICorner",KA).CornerRadius=UDim.new(0,8)

    local GK=nil

    KG.MouseButton1Click:Connect(function()
        KG.Text="ĐANG TẠO..."
        KG.BackgroundColor3=Color3.fromRGB(80,60,150)
        task.spawn(function()
            local ch="0123456789ABCDEF"
            local k=""
            for i=1,16 do
                local n=math.random(1,#ch)
                k=k..string.sub(ch,n,n)
            end
            local key=string.format("%s_%s_%s_%s",string.sub(k,1,4),string.sub(k,5,8),string.sub(k,9,12),string.sub(k,13,16))
            local r=HttpReq({
                Url="https://pastefy.app/api/v2/paste",
                Method="POST",
                Headers={
                    ["Authorization"]="Bearer "..PASTEFY_TOKEN,
                    ["Content-Type"]="application/json"
                },
                Body=HttpService:JSONEncode({
                    title="Key "..os.time(),
                    content="KEY: "..key.."\nUser: @"..USERNAME,
                    visibility="UNLISTED"
                })
            })
            local pu=nil
            if r and r.Body then
                local o,d=pcall(function() return HttpService:JSONDecode(r.Body) end)
                if o and d and d.success and d.paste and d.paste.id then
                    pu="https://pastefy.app/"..d.paste.id
                end
            end
            if not pu then
                KG.Text="LỖI PASTEFY"
                KG.BackgroundColor3=Color3.fromRGB(180,50,50)
                task.wait(2)
                KG.Text="GET KEY"
                KG.BackgroundColor3=Color3.fromRGB(124,92,255)
                return
            end
            local enc=HttpService:UrlEncode(pu.."/raw")
            local r2=HttpReq({
                Url="https://link4m.co/api-shorten/v2?api="..LINK4M_TOKEN.."&url="..enc,
                Method="GET",
                Headers={["User-Agent"]="Mozilla/5.0"}
            })
            local su=nil
            if r2 and r2.Body then
                local o,d=pcall(function() return HttpService:JSONDecode(r2.Body) end)
                if o and d and d.status=="success" then
                    su=d.shortenedUrl
                end
            end
            if not su then
                KG.Text="LỖI LINK4M"
                KG.BackgroundColor3=Color3.fromRGB(180,50,50)
                task.wait(2)
                KG.Text="GET KEY"
                KG.BackgroundColor3=Color3.fromRGB(124,92,255)
                return
            end
            GK=key
            if setclipboard then setclipboard(su) end
            KG.Text="ĐÃ COPY LINK"
            KG.BackgroundColor3=Color3.fromRGB(50,200,100)
            task.wait(2.5)
            KG.Text="GET KEY"
            KG.BackgroundColor3=Color3.fromRGB(124,92,255)
        end)
    end)

    local isChecking=false

    KA.MouseButton1Click:Connect(function()
        if isChecking then return end
        isChecking=true
        KA.Text="ĐANG KIỂM TRA..."
        KA.BackgroundColor3=Color3.fromRGB(150,100,20)
        task.wait(0.4)
        local ek=string.gsub(KI.Text,"%s+",""):gsub("%-","_")
        if GK and string.lower(ek)==string.lower(GK) then
            pcall(function()
                local t=GetBin()
                local now=os.time()
                local o=t[HWID] or {}
                t[HWID]={
                    start=o.start or now,
                    first_seen=o.first_seen or now,
                    last_seen=now,
                    username=USERNAME,
                    userid=LP.UserId,
                    display="@"..USERNAME,
                    key_activated=true,
                    expire=now+KEY_DURATION,
                    spam_count=o.spam_count or 0
                }
                UpdateBin(t)
            end)
            KA.Text="THÀNH CÔNG"
            KA.BackgroundColor3=Color3.fromRGB(22,101,52)
            task.wait(1)
            KeyGui:Destroy()
            currentMode="NORMAL"
            EndTime=os.time()+KEY_DURATION
            ShowTimeUI()
            ShowMainUI()
            return
        end
        task.spawn(function()
            local bins=GetBin()
            local rec=bins["key_"..ek] or bins["key_"..string.upper(ek)] or bins["key_"..string.lower(ek)]
            if not rec then
                KA.Text="KEY SAI"
                KA.BackgroundColor3=Color3.fromRGB(180,50,50)
                task.wait(1.5)
                KA.Text="KÍCH HOẠT"
                KA.BackgroundColor3=Color3.fromRGB(245,158,11)
                isChecking=false
                return
            end
            if rec.used==true then
                KA.Text="KEY ĐÃ DÙNG"
                KA.BackgroundColor3=Color3.fromRGB(180,50,50)
                task.wait(1.5)
                KA.Text="KÍCH HOẠT"
                KA.BackgroundColor3=Color3.fromRGB(245,158,11)
                isChecking=false
                return
            end
            bins["key_"..rec.key].used=true
            bins["key_"..rec.key].used_at=os.time()
            bins["key_"..rec.key].used_by=USERNAME
            UpdateBin(bins)
            local dur=rec.duration or KEY_DURATION
            local t=GetBin()
            local now=os.time()
            local o=t[HWID] or {}
            t[HWID]={
                start=o.start or now,
                first_seen=o.first_seen or now,
                last_seen=now,
                username=USERNAME,
                userid=LP.UserId,
                display="@"..USERNAME,
                key_activated=true,
                expire=now+dur,
                spam_count=o.spam_count or 0
            }
            UpdateBin(t)
            KA.Text="THÀNH CÔNG"
            KA.BackgroundColor3=Color3.fromRGB(22,101,52)
            task.wait(1)
            KeyGui:Destroy()
            currentMode="NORMAL"
            EndTime=os.time()+dur
            ShowTimeUI()
            ShowMainUI()
        end)
    end)
end

local status,remaining=CheckTrialFromServer()
if status=="expired" then
    ShowKeyUI()
elseif status=="premium" then
    currentMode="NORMAL"
    EndTime=os.time()+remaining
    ShowTimeUI()
    ShowMainUI()
else
    currentMode="TRIAL"
    EndTime=os.time()+remaining
    ShowTimeUI()
    ShowMainUI()
end
