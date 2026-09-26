local CONFIG_URL = "https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Config"
local TweenService=game:GetService("TweenService")
local CoreGui=game:GetService("CoreGui")
local Players,Lighting=game:GetService("Players"),game:GetService("Lighting")
local Workspace,PPS=game:GetService("Workspace"),game:GetService("ProximityPromptService")
local LP=Players.LocalPlayer

local function GC() if gethui then local ok,h=pcall(gethui) if ok and h then return h end end return CoreGui or LP:WaitForChild("PlayerGui") end

local ok,raw=pcall(function() return game:HttpGet(CONFIG_URL.."?v="..tick(),true) end)
if not ok or not raw then warn("[CONFIG] fail") return end
local fn=loadstring(raw) if not fn then return end
local ok2,cfg=pcall(fn) if not ok2 or type(cfg)~="table" then return end

local BRAND_NAME,SOCIAL_HANDLE,LOGO_ASSET=cfg.BRAND_NAME,cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local STEAL_HOLD,SCRIPT_URL=cfg.STEAL_HOLD,cfg.SCRIPT_URL

local LoadingGuiRef

local function ShowLoadingUI()
    local c=GC()
    if c:FindFirstChild("whoareyoufrom7_LoadingUI") then c.whoareyoufrom7_LoadingUI:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui") if pg and pg:FindFirstChild("whoareyoufrom7_LoadingUI") then pg.whoareyoufrom7_LoadingUI:Destroy() end
    local G=Instance.new("ScreenGui") G.Name="whoareyoufrom7_LoadingUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=2147483647
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end LoadingGuiRef=G
    local O=Instance.new("Frame") O.Size=UDim2.new(1,0,1,0) O.BackgroundColor3=Color3.fromRGB(0,0,0) O.BackgroundTransparency=.15 O.BorderSizePixel=0 O.ZIndex=1 O.Parent=G
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

ShowLoadingUI() task.wait(7)

local InitialGuis={}
local IsLaunching=false

local function TakeGuiSnapshot()
    table.clear(InitialGuis)
    for _,c in ipairs({GC(),LP:FindFirstChild("PlayerGui")}) do
        if c then for _,ch in ipairs(c:GetChildren()) do InitialGuis[ch]=true end end
    end
end

local function ApplyBranding()
    local tuned={}
    local function T(p) if tuned[p] then return end tuned[p]=true if p:IsA("ProximityPrompt") then p.HoldDuration=STEAL_HOLD p.RequiresLineOfSight=false pcall(function() p.MaxActivationDistance=math.max(p.MaxActivationDistance,25) end) end end
    for _,d in ipairs(Workspace:GetDescendants()) do T(d) end
    task.spawn(function() while getgenv().whoareyoufrom7_Active do task.wait(3) for _,d in ipairs(Workspace:GetDescendants()) do T(d) end for o in pairs(tuned) do if not o or not o.Parent then tuned[o]=nil end end end end)
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
    S() task.spawn(function() while getgenv().whoareyoufrom7_Active do task.wait(2) S() for o in pairs(hj) do if not o or not o.Parent then hj[o]=nil end end end end)
end

local function FormatTime(s)
    if s<0 then s=0 end
    local h,m,sc=math.floor(s/3600),math.floor((s%3600)/60),math.floor(s%60)
    if h>0 then return string.format("%02d:%02d:%02d",h,m,sc) end
    return string.format("%02d:%02d",m,sc)
end

local EndTime=os.time()+31536000

local function ShowStatusHUD()
    local c=GC()
    if c:FindFirstChild("whoareyoufrom7_StatusUI") then c.whoareyoufrom7_StatusUI:Destroy() end
    local G=Instance.new("ScreenGui") G.Name="whoareyoufrom7_StatusUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=9999
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local F=Instance.new("Frame") F.Size=UDim2.new(0,140,0,40) F.Position=UDim2.new(0,10,0,10) F.BackgroundColor3=Color3.fromRGB(15,10,20) F.BackgroundTransparency=.15 F.BorderSizePixel=0 F.Active=false F.Parent=G
    Instance.new("UICorner",F).CornerRadius=UDim.new(0,10)
    local S=Instance.new("UIStroke",F) S.Thickness=1.3 S.Color=Color3.fromRGB(168,85,247) S.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local D=Instance.new("Frame") D.Size=UDim2.new(0,6,0,6) D.Position=UDim2.new(0,8,0,8) D.BackgroundColor3=Color3.fromRGB(0,255,163) D.BorderSizePixel=0 D.Parent=F
    Instance.new("UICorner",D).CornerRadius=UDim.new(1,0)
    local Ti=Instance.new("TextLabel") Ti.Size=UDim2.new(1,-22,0,14) Ti.Position=UDim2.new(0,18,0,4) Ti.BackgroundTransparency=1 Ti.Text="WHOAREYOUFROM7" Ti.TextColor3=Color3.fromRGB(253,230,138) Ti.TextSize=9 Ti.Font=Enum.Font.GothamBlack Ti.TextXAlignment=Enum.TextXAlignment.Left Ti.Parent=F
    local M=Instance.new("TextLabel") M.Size=UDim2.new(1,-12,0,14) M.Position=UDim2.new(0,6,0,20) M.BackgroundTransparency=1 M.Text="PREMIUM" M.TextColor3=Color3.fromRGB(0,255,163) M.TextSize=9 M.Font=Enum.Font.GothamBold M.TextXAlignment=Enum.TextXAlignment.Left M.Parent=F
    local Tl=Instance.new("TextLabel") Tl.Size=UDim2.new(1,-12,0,14) Tl.Position=UDim2.new(0,6,0,26) Tl.BackgroundTransparency=1 Tl.Text="∞" Tl.TextColor3=Color3.fromRGB(0,255,163) Tl.TextSize=11 Tl.Font=Enum.Font.Code Tl.TextXAlignment=Enum.TextXAlignment.Left Tl.Parent=F
    task.spawn(function()
        while G.Parent do
            local r=EndTime-os.time() if r<0 then r=0 end
            Tl.Text=FormatTime(r)
            task.wait(1)
        end
    end)
end

local function LaunchTargetScript()
    if IsLaunching then return end IsLaunching=true
    if LoadingGuiRef and LoadingGuiRef.Parent then LoadingGuiRef:Destroy() LoadingGuiRef=nil end
    task.wait(.2) TakeGuiSnapshot() getgenv().whoareyoufrom7_Active=true
    task.spawn(function() pcall(function() script_key="Premium" loadstring(game:HttpGet(SCRIPT_URL))() end) end)
    task.wait(2) ApplyBranding() ApplyHook() IsLaunching=false
end

LaunchTargetScript()
ShowStatusHUD()
