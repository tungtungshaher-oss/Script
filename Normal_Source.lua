local CONFIG_URL = "https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Config"
local TweenService,RunService=game:GetService("TweenService"),game:GetService("RunService")
local HttpService,CoreGui=game:GetService("HttpService"),game:GetService("CoreGui")
local Players,Lighting=game:GetService("Players"),game:GetService("Lighting")
local Workspace,PPS=game:GetService("Workspace"),game:GetService("ProximityPromptService")
local LP=Players.LocalPlayer

local function GC() if gethui then local ok,h=pcall(gethui) if ok and h then return h end end return CoreGui or LP:WaitForChild("PlayerGui") end

local ok,raw=pcall(function() return game:HttpGet(CONFIG_URL.."?v="..tick(),true) end)
if not ok or not raw then warn("[CONFIG] fail") return end
local fn=loadstring(raw) if not fn then return end
local ok2,cfg=pcall(fn) if not ok2 or type(cfg)~="table" then return end

local JSONBIN_KEY,JSONBIN_BIN=cfg.JSONBIN_KEY,cfg.JSONBIN_BIN
local JSONBIN_URL="https://api.jsonbin.io/v3/b/"..JSONBIN_BIN
local PASTEFY_TOKEN,LINK4M_TOKEN=cfg.PASTEFY_TOKEN,cfg.LINK4M_TOKEN
local SOCIAL_HANDLE,LOGO_ASSET=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local STEAL_HOLD,TRIAL_DURATION,KEY_DURATION=cfg.STEAL_HOLD,cfg.TRIAL_DURATION,cfg.KEY_DURATION
local SPAM_COOLDOWN,SPAM_WINDOW,SPAM_MAX,BAN_DURATION=cfg.SPAM_COOLDOWN,cfg.SPAM_WINDOW,cfg.SPAM_MAX,cfg.BAN_DURATION
local SCRIPT_URL=cfg.SCRIPT_URL
local BRAND_NAME="Tungtung"

local LoadingGuiRef

local function BringLoadingToFront()
    if LoadingGuiRef and LoadingGuiRef.Parent then
        LoadingGuiRef.DisplayOrder=2147483647
        LoadingGuiRef.Parent=GC()
    end
end

local function ShowLoadingUI()
    local c=GC()
    if c:FindFirstChild("Tungtung_LoadingUI") then c.Tungtung_LoadingUI:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui") if pg and pg:FindFirstChild("Tungtung_LoadingUI") then pg.Tungtung_LoadingUI:Destroy() end
    local G=Instance.new("ScreenGui") G.Name="Tungtung_LoadingUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=2147483647
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end LoadingGuiRef=G
    local O=Instance.new("Frame") O.Size=UDim2.new(1,0,1,0) O.BackgroundColor3=Color3.fromRGB(0,0,0) O.BackgroundTransparency=0 O.BorderSizePixel=0 O.ZIndex=1 O.Parent=G
    local C=Instance.new("Frame") C.Size=UDim2.new(0,340,0,110) C.Position=UDim2.new(.5,-170,.5,-55) C.BackgroundColor3=Color3.fromRGB(15,12,22) C.BorderSizePixel=0 C.ZIndex=2 C.Parent=G
    Instance.new("UICorner",C).CornerRadius=UDim.new(0,14)
    local S=Instance.new("UIStroke",C) S.Thickness=1.6 S.Color=Color3.fromRGB(168,85,247) S.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local D=Instance.new("Frame") D.Size=UDim2.new(0,8,0,8) D.Position=UDim2.new(0,15,0,18) D.BackgroundColor3=Color3.fromRGB(168,85,247) D.BorderSizePixel=0 D.ZIndex=3 D.Parent=C
    Instance.new("UICorner",D).CornerRadius=UDim.new(1,0)
    local T=Instance.new("TextLabel") T.Size=UDim2.new(1,-40,0,24) T.Position=UDim2.new(0,30,0,10) T.BackgroundTransparency=1 T.Text="⚡ ĐANG TẢI SCRIPT" T.TextColor3=Color3.fromRGB(253,230,138) T.TextSize=15 T.Font=Enum.Font.GothamBlack T.TextXAlignment=Enum.TextXAlignment.Left T.ZIndex=3 T.Parent=C
    local Sub=Instance.new("TextLabel") Sub.Size=UDim2.new(1,-30,0,16) Sub.Position=UDim2.new(0,15,0,40) Sub.BackgroundTransparency=1 Sub.Text="Vui lòng chờ trong giây lát..." Sub.TextColor3=Color3.fromRGB(200,200,200) Sub.TextSize=11 Sub.Font=Enum.Font.Gotham Sub.TextXAlignment=Enum.TextXAlignment.Left Sub.ZIndex=3 Sub.Parent=C
    local BB=Instance.new("Frame") BB.Size=UDim2.new(1,-30,0,6) BB.Position=UDim2.new(0,15,1,-30) BB.BackgroundColor3=Color3.fromRGB(30,20,40) BB.BorderSizePixel=0 BB.ZIndex=3 BB.Parent=C
    Instance.new("UICorner",BB).CornerRadius=UDim.new(1,0)
    local B=Instance.new("Frame") B.Size=UDim2.new(0,0,1,0) B.BackgroundColor3=Color3.fromRGB(168,85,247) B.BorderSizePixel=0 B.ZIndex=4 B.Parent=BB
    Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
    local TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-30,0,14) TL.Position=UDim2.new(0,15,1,-50) TL.BackgroundTransparency=1 TL.Text="7s" TL.TextColor3=Color3.fromRGB(168,85,247) TL.TextSize=10 TL.Font=Enum.Font.Code TL.TextXAlignment=Enum.TextXAlignment.Right TL.ZIndex=3 TL.Parent=C
    TweenService:Create(B,TweenInfo.new(7,Enum.EasingStyle.Linear),{Size=UDim2.new(1,0,1,0)}):Play()
    task.spawn(function() local s=tick() while tick()-s<7 do TL.Text=string.format("%.1fs",7-(tick()-s)) task.wait(.1) end end)
    task.delay(7,function()
        if G and G.Parent then
            TweenService:Create(O,TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=1}):Play()
            TweenService:Create(C,TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=1}):Play()
            task.wait(.5) G:Destroy() LoadingGuiRef=nil
        end
    end)
end

local InitialGuis,ScriptConnections,ActiveBlurEffect,InputBlockerScreen,OpenKeySystemUI={},{},nil,nil,nil
local IsGUIOpen,LastGUIOpen,IsLaunching=false,0,false

local function getHWID()
    if gethwid then local ok,h=pcall(gethwid) if ok and h then return tostring(h) end end
    if syn and syn.get_hwid then local ok,h=pcall(function() return syn.get_hwid() end) if ok and h then return tostring(h) end end
    local ok,cid=pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok and cid then return tostring(cid) end
    return tostring(LP.UserId).."_"..tostring(LP.AccountAge)
end
local HWID,USERNAME,USERID=getHWID(),LP.Name,LP.UserId

local function HttpReq(o) local f=(syn and syn.request) or (http and http.request) or http_request or request if f then return f(o) end return nil end

local function GetBin()
    local r=HttpReq({Url=JSONBIN_URL.."/latest",Method="GET",Headers={["X-Master-Key"]=JSONBIN_KEY}})
    if r and r.Body then local ok,d=pcall(function() return HttpService:JSONDecode(r.Body) end) if ok and d and d.record then return d.record end end
    return {}
end

local function UpdateBin(d)
    local r=HttpReq({Url=JSONBIN_URL,Method="PUT",Headers={["Content-Type"]="application/json",["X-Master-Key"]=JSONBIN_KEY},Body=HttpService:JSONEncode(d)})
    return r~=nil
end

local function CheckTrialFromServer()
    local t,now=GetBin(),os.time()
    if t[HWID] then
        local e=t[HWID] e.last_seen=now e.username=USERNAME e.userid=USERID e.display="@"..USERNAME.." (ID: "..USERID..")" UpdateBin(t)
        if e.key_activated and e.expire then local l=e.expire-now if l>0 then return "premium",l else return "expired",0 end end
        local s=e.start or now local r=TRIAL_DURATION-(now-s) if r<=0 then return "expired",0 end return "active",r
    else
        t[HWID]={start=now,first_seen=now,last_seen=now,username=USERNAME,userid=USERID,display="@"..USERNAME.." (ID: "..USERID..")",key_activated=false,spam_count=0}
        UpdateBin(t) return "started",TRIAL_DURATION
    end
end

local function SaveKeyToServer()
    local t,now=GetBin(),os.time() local o=t[HWID] or {}
    t[HWID]={start=o.start or now,first_seen=o.first_seen or now,last_seen=now,username=USERNAME,userid=USERID,display="@"..USERNAME.." (ID: "..USERID..")",key_activated=true,expire=now+KEY_DURATION,spam_count=o.spam_count or 0}
    return UpdateBin(t)
end

local function GetKeyRemainingTime()
    local t=GetBin()
    if t[HWID] and t[HWID].key_activated then local l=(t[HWID].expire or 0)-os.time() if l>0 then return l end end
    return nil
end

local function IsBanned()
    local t=GetBin()
    if t[HWID] then local b=t[HWID].banned_until if b and b>os.time() then return true,b end end
    return false,0
end

local function LogSpam()
    local t=GetBin() if not t[HWID] then return end
    local now=os.time() local e=t[HWID]
    e.spam_count=(e.spam_count or 0)+1 e.last_spam=now
    if not e.spam_window_start or (now-e.spam_window_start)>SPAM_WINDOW then e.spam_window_start=now e.spam_window_count=1
    else e.spam_window_count=(e.spam_window_count or 0)+1 end
    if e.spam_window_count>SPAM_MAX then e.banned_until=now+BAN_DURATION e.ban_reason="Spam GUI ("..e.spam_window_count.." lần trong "..SPAM_WINDOW.."s)" e.spam_window_count=0 e.spam_window_start=now end
    UpdateBin(t)
end

local function TakeGuiSnapshot()
    table.clear(InitialGuis)
    for _,c in ipairs({GC(),LP:FindFirstChild("PlayerGui")}) do
        if c then for _,ch in ipairs(c:GetChildren()) do InitialGuis[ch]=true end end
    end
end

local function ApplyScreenLockdown()
    if not ActiveBlurEffect then ActiveBlurEffect=Instance.new("BlurEffect") ActiveBlurEffect.Size=28 ActiveBlurEffect.Parent=Lighting end
    local ch=LP.Character
    if ch then
        local h=ch:FindFirstChildOfClass("Humanoid") local r=ch:FindFirstChild("HumanoidRootPart")
        if h then h.WalkSpeed=0 h.JumpPower=0 h.PlatformStand=true end
        if r then r.Anchored=true end
    end
    if not InputBlockerScreen then
        InputBlockerScreen=Instance.new("ScreenGui") InputBlockerScreen.Name="Tungtung_InputBlocker" InputBlockerScreen.ResetOnSpawn=false InputBlockerScreen.DisplayOrder=100
        pcall(function() InputBlockerScreen.Parent=GC() end)
        if not InputBlockerScreen.Parent then InputBlockerScreen.Parent=LP:WaitForChild("PlayerGui") end
        local sh=Instance.new("TextButton") sh.Size=UDim2.new(1,0,1,0) sh.BackgroundColor3=Color3.fromRGB(0,0,0) sh.BackgroundTransparency=.45 sh.Text="" sh.AutoButtonColor=false sh.Active=true sh.ZIndex=15 sh.Parent=InputBlockerScreen
    end
end

local function RemoveScreenLockdown()
    if ActiveBlurEffect then ActiveBlurEffect:Destroy() ActiveBlurEffect=nil end
    if InputBlockerScreen then InputBlockerScreen:Destroy() InputBlockerScreen=nil end
    local ch=LP.Character
    if ch then
        local h=ch:FindFirstChildOfClass("Humanoid") local r=ch:FindFirstChild("HumanoidRootPart")
        if h then h.WalkSpeed=16 h.JumpPower=50 h.PlatformStand=false end
        if r then r.Anchored=false end
    end
end

local function TerminateTargetScript()
    getgenv().tungtung_active=false
    for _,c in ipairs(ScriptConnections) do if typeof(c)=="RBXScriptConnection" and c.Connected then c:Disconnect() end end
    table.clear(ScriptConnections)
    for _,c in ipairs({GC(),LP:FindFirstChild("PlayerGui")}) do
        if c then for _,ch in ipairs(c:GetChildren()) do
            if not InitialGuis[ch] and ch.Name~="Tungtung_GetKeyUI" and ch.Name~="Tungtung_ToastUI" and ch.Name~="Tungtung_InputBlocker" and ch.Name~="Tungtung_StatusUI" and ch.Name~="Tungtung_LoadingUI" then
                pcall(function() ch:Destroy() end)
            end
        end end
    end
end

local function ApplyBranding()
    local tuned={}
    local function T(p) if tuned[p] then return end tuned[p]=true if p:IsA("ProximityPrompt") then p.HoldDuration=STEAL_HOLD p.RequiresLineOfSight=false pcall(function() p.MaxActivationDistance=math.max(p.MaxActivationDistance,25) end) end end
    for _,d in ipairs(Workspace:GetDescendants()) do T(d) end
    task.spawn(function() while getgenv().tungtung_active do task.wait(3) for _,d in ipairs(Workspace:GetDescendants()) do T(d) end for o in pairs(tuned) do if not o or not o.Parent then tuned[o]=nil end end end end)
    PPS.PromptButtonHoldBegan:Connect(function(p) pcall(function() if not p or not p.Parent then return end p.HoldDuration=STEAL_HOLD task.delay(STEAL_HOLD,function() if fireproximityprompt and p and p.Parent then pcall(function() fireproximityprompt(p) end) end end) end) end)
end

local function ApplyHook()
    local hj={}
    local function H(i)
        if hj[i] then return end hj[i]=true
        pcall(function()
            if i:IsA("TextLabel") or i:IsA("TextButton") then
                local function A() local r=i.Text:upper() if r:find("EQUINOZ") then i.Text=BRAND_NAME elseif r:find("VEUURTUMWE") or r:find("DISCORD.GG") then i.Text=SOCIAL_HANDLE end end
                A() i:GetPropertyChangedSignal("Text"):Connect(A)
            elseif i:IsA("ImageLabel") or i:IsA("ImageButton") then
                local p=i.Parent local pN=p and p.Name:lower() or "" local iN=i.Name:lower()
                local sg=i:FindFirstAncestorOfClass("ScreenGui") local tgt=false
                if sg then for _,s in ipairs(sg:GetDescendants()) do if (s:IsA("TextLabel") or s:IsA("TextButton")) and s.Text:upper():find("ANTI HIT") then tgt=true break end end end
                if tgt and (pN:find("logo") or pN:find("icon") or pN:find("toggle") or pN:find("btn") or iN:find("logo") or iN:find("icon") or i:IsA("ImageButton")) then
                    local function L() if LOGO_ASSET~="" and i.Image~=LOGO_ASSET then i.Image=LOGO_ASSET end end
                    L() i:GetPropertyChangedSignal("Image"):Connect(L)
                end
            end
        end)
    end
    local function S() for _,r in ipairs({GC(),gethui and gethui(),LP:FindFirstChild("PlayerGui")}) do if r then for _,d in ipairs(r:GetDescendants()) do H(d) end end end end
    S() task.spawn(function() while getgenv().tungtung_active do task.wait(2) S() for o in pairs(hj) do if not o or not o.Parent then hj[o]=nil end end end end)
end

local function FormatTime(s)
    if s<0 then s=0 end
    local h,m,sc=math.floor(s/3600),math.floor((s%3600)/60),math.floor(s%60)
    if h>0 then return string.format("%02d:%02d:%02d",h,m,sc) end
    return string.format("%02d:%02d",m,sc)
end

local currentTrialRemaining=TRIAL_DURATION
local currentMode="TRIAL"
local EndTime=os.time()+TRIAL_DURATION

local function ShowStatusHUD()
    local c=GC()
    if c:FindFirstChild("Tungtung_StatusUI") then c.Tungtung_StatusUI:Destroy() end
    local G=Instance.new("ScreenGui") G.Name="Tungtung_StatusUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=9998
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local F=Instance.new("Frame") F.Size=UDim2.new(0,140,0,40) F.Position=UDim2.new(0,10,0,10) F.BackgroundColor3=Color3.fromRGB(15,10,20) F.BackgroundTransparency=.15 F.BorderSizePixel=0 F.Active=false F.Parent=G
    Instance.new("UICorner",F).CornerRadius=UDim.new(0,10)
    local S=Instance.new("UIStroke",F) S.Thickness=1.3 S.Color=Color3.fromRGB(168,85,247) S.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local D=Instance.new("Frame") D.Size=UDim2.new(0,6,0,6) D.Position=UDim2.new(0,8,0,8) D.BackgroundColor3=Color3.fromRGB(0,255,163) D.BorderSizePixel=0 D.Parent=F
    Instance.new("UICorner",D).CornerRadius=UDim.new(1,0)
    local Ti=Instance.new("TextLabel") Ti.Size=UDim2.new(1,-22,0,14) Ti.Position=UDim2.new(0,18,0,4) Ti.BackgroundTransparency=1 Ti.Text="Tungtung" Ti.TextColor3=Color3.fromRGB(253,230,138) Ti.TextSize=9 Ti.Font=Enum.Font.GothamBlack Ti.TextXAlignment=Enum.TextXAlignment.Left Ti.Parent=F
    local M=Instance.new("TextLabel") M.Size=UDim2.new(1,-12,0,14) M.Position=UDim2.new(0,6,0,20) M.BackgroundTransparency=1 M.Text="TRIAL" M.TextColor3=Color3.fromRGB(245,158,11) M.TextSize=9 M.Font=Enum.Font.GothamBold M.TextXAlignment=Enum.TextXAlignment.Left M.Parent=F
    local Tl=Instance.new("TextLabel") Tl.Size=UDim2.new(1,-12,0,14) Tl.Position=UDim2.new(0,6,0,26) Tl.BackgroundTransparency=1 Tl.Text="10:00" Tl.TextColor3=Color3.fromRGB(0,255,163) Tl.TextSize=11 Tl.Font=Enum.Font.Code Tl.TextXAlignment=Enum.TextXAlignment.Left Tl.Parent=F
    task.spawn(function()
        while G.Parent do
            local r=EndTime-os.time() if r<0 then r=0 end currentTrialRemaining=r
            local col=Color3.fromRGB(245,158,11)
            if currentMode=="NORMAL" then col=Color3.fromRGB(0,255,163) D.BackgroundColor3=col
            else
                col=Color3.fromRGB(245,158,11) D.BackgroundColor3=col
                if r<=0 then D.BackgroundColor3=Color3.fromRGB(239,68,68) col=D.BackgroundColor3 end
            end
            M.Text=currentMode M.TextColor3=col Tl.Text=FormatTime(r) Tl.TextColor3=col
            task.wait(1)
        end
    end)
end

local function LaunchTargetScript()
    if IsLaunching then return end IsLaunching=true
    local k=GC():FindFirstChild("Tungtung_GetKeyUI") if k then k:Destroy() end
    task.wait(.2) TakeGuiSnapshot() getgenv().tungtung_active=true
    task.spawn(function() pcall(function() script_key="Trial" loadstring(game:HttpGet(SCRIPT_URL))() end) end)
    task.wait(2) ApplyBranding() ApplyHook() IsLaunching=false
end

local function PlayDeepBounce(b)
    local oS,oP=b.Size,b.Position
    local sS=UDim2.new(oS.X.Scale,oS.X.Offset-6,oS.Y.Scale,oS.Y.Offset-4)
    local sP=UDim2.new(oP.X.Scale,oP.X.Offset+3,oP.Y.Scale,oP.Y.Offset+2)
    local t1=TweenService:Create(b,TweenInfo.new(.08,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=sS,Position=sP})
    local t2=TweenService:Create(b,TweenInfo.new(.16,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=oS,Position=oP})
    t1:Play() t1.Completed:Connect(function() t2:Play() end)
end

OpenKeySystemUI=function()
    local b,bu=IsBanned()
    if b then local l=bu-os.time() print("[BANNED] còn "..math.floor(l/3600).."h "..math.floor((l%3600)/60).."m") return end
    if IsGUIOpen then return end
    local now=os.time()
    if now-LastGUIOpen<SPAM_COOLDOWN then print("[Anti-Spam] Đợi "..(SPAM_COOLDOWN-(now-LastGUIOpen)).."s") LogSpam() return end
    LastGUIOpen=now IsGUIOpen=true LogSpam()
    if CoreGui:FindFirstChild("Tungtung_GetKeyUI") then CoreGui.Tungtung_GetKeyUI:Destroy() end
    local G=Instance.new("ScreenGui") G.Name="Tungtung_GetKeyUI" G.ResetOnSpawn=false G.DisplayOrder=9999
    pcall(function() G.Parent=GC() end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local M=Instance.new("Frame") M.Size=UDim2.new(0,260,0,180) M.Position=UDim2.new(.5,-130,.5,-90) M.BackgroundColor3=Color3.fromRGB(15,12,22) M.BorderSizePixel=0 M.Parent=G
    Instance.new("UICorner",M).CornerRadius=UDim.new(0,14)
    local L=Instance.new("ImageLabel") L.Size=UDim2.new(0,40,0,40) L.Position=UDim2.new(0,10,0,10) L.BackgroundTransparency=1 L.Image=LOGO_ASSET L.Parent=M
    local Ti=Instance.new("TextLabel") Ti.Size=UDim2.new(1,-60,0,18) Ti.Position=UDim2.new(0,55,0,14) Ti.BackgroundTransparency=1 Ti.Text=BRAND_NAME Ti.TextColor3=Color3.fromRGB(253,230,138) Ti.TextSize=12 Ti.Font=Enum.Font.GothamBlack Ti.TextXAlignment=Enum.TextXAlignment.Left Ti.Parent=M
    local I=Instance.new("TextBox") I.Size=UDim2.new(1,-20,0,30) I.Position=UDim2.new(0,10,0,60) I.BackgroundColor3=Color3.fromRGB(22,14,32) I.TextColor3=Color3.fromRGB(254,243,199) I.PlaceholderColor3=Color3.fromRGB(147,112,175) I.PlaceholderText="Dán key..." I.Text="" I.TextSize=11 I.ClearTextOnFocus=false I.Parent=M
    Instance.new("UICorner",I).CornerRadius=UDim.new(0,8)
    local Gn=Instance.new("TextButton") Gn.Size=UDim2.new(1,-20,0,28) Gn.Position=UDim2.new(0,10,0,98) Gn.BackgroundColor3=Color3.fromRGB(124,92,255) Gn.Text="⚡ TẠO KEY" Gn.TextColor3=Color3.fromRGB(255,255,255) Gn.TextSize=11 Gn.Font=Enum.Font.GothamBlack Gn.Parent=M
    Instance.new("UICorner",Gn).CornerRadius=UDim.new(0,8)
    local Ck=Instance.new("TextButton") Ck.Size=UDim2.new(1,-20,0,30) Ck.Position=UDim2.new(0,10,0,132) Ck.BackgroundColor3=Color3.fromRGB(245,158,11) Ck.Text="✔ KÍCH HOẠT" Ck.TextColor3=Color3.fromRGB(22,14,3) Ck.TextSize=11.5 Ck.Font=Enum.Font.GothamBlack Ck.Parent=M
    Instance.new("UICorner",Ck).CornerRadius=UDim.new(0,8)
    local GK=nil
    Gn.MouseButton1Click:Connect(function()
        PlayDeepBounce(Gn) Gn.Text="⏳ ĐANG TẠO..." Gn.BackgroundColor3=Color3.fromRGB(80,60,150)
        task.spawn(function()
            local ch="0123456789ABCDEF" local k=""
            for i=1,16 do local n=math.random(1,#ch) k=k..string.sub(ch,n,n) end
            local key=string.format("%s_%s_%s_%s",string.sub(k,1,4),string.sub(k,5,8),string.sub(k,9,12),string.sub(k,13,16))
            local r=HttpReq({Url="https://pastefy.app/api/v2/paste",Method="POST",Headers={["Authorization"]="Bearer "..PASTEFY_TOKEN,["Content-Type"]="application/json"},Body=HttpService:JSONEncode({title="Key "..os.time(),content="KEY: "..key.."\nUser: @"..USERNAME.." ("..USERID..")",visibility="UNLISTED"})})
            local pu=nil
            if r and r.Body then local ok,d=pcall(function() return HttpService:JSONDecode(r.Body) end) if ok and d and d.success and d.paste and d.paste.id then pu="https://pastefy.app/"..d.paste.id end end
            if not pu then Gn.Text="❌ LỖI PASTEFY" Gn.BackgroundColor3=Color3.fromRGB(180,50,50) task.wait(2) Gn.Text="⚡ TẠO KEY" Gn.BackgroundColor3=Color3.fromRGB(124,92,255) return end
            local enc=HttpService:UrlEncode(pu.."/raw")
            local r2=HttpReq({Url="https://link4m.co/api-shorten/v2?api="..LINK4M_TOKEN.."&url="..enc,Method="GET",Headers={["User-Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36"}})
            local su=nil
            if r2 and r2.Body then local ok,d=pcall(function() return HttpService:JSONDecode(r2.Body) end) if ok and d and d.status=="success" then su=d.shortenedUrl end end
            if not su then Gn.Text="❌ LỖI LINK4M" Gn.BackgroundColor3=Color3.fromRGB(180,50,50) task.wait(2) Gn.Text="⚡ TẠO KEY" Gn.BackgroundColor3=Color3.fromRGB(124,92,255) return end
            GK=key if setclipboard then setclipboard(su) end
            Gn.Text="✅ ĐÃ COPY LINK!" Gn.BackgroundColor3=Color3.fromRGB(50,200,100)
            task.wait(2.5) Gn.Text="⚡ TẠO KEY" Gn.BackgroundColor3=Color3.fromRGB(124,92,255)
        end)
    end)
    local isC=false
    Ck.MouseButton1Click:Connect(function()
        if isC then return end isC=true PlayDeepBounce(Ck)
        Ck.Text="⏳ ĐANG KIỂM TRA..." Ck.BackgroundColor3=Color3.fromRGB(150,100,20)
        task.wait(.4)
        local ek=string.gsub(I.Text,"%s+",""):gsub("%-","_")
        if GK and string.lower(ek)==string.lower(GK) then
            SaveKeyToServer() currentMode="NORMAL" EndTime=os.time()+KEY_DURATION currentTrialRemaining=KEY_DURATION
            Ck.Text="✔ THÀNH CÔNG" Ck.BackgroundColor3=Color3.fromRGB(22,101,52)
            RemoveScreenLockdown() LaunchTargetScript() ShowStatusHUD()
            task.wait(.5) IsGUIOpen=false G:Destroy()
        else
            isC=false Ck.Text="❌ SAI KEY" Ck.BackgroundColor3=Color3.fromRGB(180,50,50)
            task.wait(1.5) Ck.Text="✔ KÍCH HOẠT" Ck.BackgroundColor3=Color3.fromRGB(245,158,11)
        end
    end)
end

local function StartCountdown()
    task.spawn(function()
        while os.time()<EndTime do task.wait(1) end
        TerminateTargetScript() ApplyScreenLockdown() OpenKeySystemUI()
    end)
end

local banned,banUntil=IsBanned()
if banned then
    local l=banUntil-os.time()
    print("[BANNED] Bị ban còn "..math.floor(l/3600).."h "..math.floor((l%3600)/60).."m")
    return
end

local kt=GetKeyRemainingTime()
if kt and kt>0 then
    ShowLoadingUI()
    task.wait(7)
    currentMode="NORMAL" currentTrialRemaining=kt EndTime=os.time()+kt
    LaunchTargetScript() ShowStatusHUD() StartCountdown() return
end

local status,remaining=CheckTrialFromServer()
if status=="expired" then
    ShowLoadingUI()
    task.wait(7)
    ApplyScreenLockdown() OpenKeySystemUI()
    return
elseif status=="premium" then
    ShowLoadingUI()
    task.wait(7)
    currentMode="NORMAL" currentTrialRemaining=remaining EndTime=os.time()+remaining
    LaunchTargetScript() ShowStatusHUD() StartCountdown() return
else
    ShowLoadingUI()
    task.wait(7)
    currentMode="TRIAL" currentTrialRemaining=remaining EndTime=os.time()+remaining
    LaunchTargetScript() ShowStatusHUD() StartCountdown()
end
