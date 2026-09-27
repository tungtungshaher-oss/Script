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

repeat task.wait() until game:IsLoaded() and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

local ChosenVersion=1

local V2_HOOK = function()
    local CONFIG = {
        ["Various Hub"] = "Tungtung Hub",
        ["ANTI-HIT"] = "ĐÓNG BĂNG BOT",
        ["INSTANT PROMPT"] = "TƯƠNG TÁC NHANH",
        ["EXECUTE  •  ALL IN ONE SCRIPT"] = "TUNGTUNG - ALL IN ONE",
        ["EXECUTE • ALL IN ONE SCRIPT"] = "TUNGTUNG - ALL IN ONE",
        ["ON"] = "BẬT",
        ["OFF"] = "TẮT",
    }
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local function GC() if gethui then local ok, h = pcall(gethui) if ok and h then return h end end return CoreGui or LP:WaitForChild("PlayerGui") end
    local hijacked = {}
    local function hookElement(inst)
        if hijacked[inst] then return end
        if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
        hijacked[inst] = true
        local function apply()
            pcall(function()
                local txt = inst.Text
                for k, v in pairs(CONFIG) do
                    if txt == k then inst.Text = v return end
                end
            end)
        end
        apply()
        pcall(function() inst:GetPropertyChangedSignal("Text"):Connect(apply) end)
    end
    local function scanAll()
        local roots = {GC(), LP:FindFirstChild("PlayerGui")}
        for _, root in ipairs(roots) do
            if root then for _, d in ipairs(root:GetDescendants()) do hookElement(d) end end
        end
    end
    getgenv().Tungtung_HookEnabled = true
    local lastScan = 0
    RunService.Heartbeat:Connect(function()
        if not getgenv().Tungtung_HookEnabled then return end
        local now = tick()
        if now - lastScan < 0.5 then return end
        lastScan = now
        scanAll()
    end)
end

local function ShowVersionPicker()
    local c=GC()
    local G=Instance.new("ScreenGui") G.Name="Tungtung_VersionUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=2147483646
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local Overlay=Instance.new("Frame") Overlay.Size=UDim2.new(1,0,1,0) Overlay.BackgroundColor3=Color3.fromRGB(0,0,0) Overlay.BackgroundTransparency=.6 Overlay.BorderSizePixel=0 Overlay.ZIndex=1 Overlay.Parent=G
    local Main=Instance.new("Frame") Main.Size=UDim2.new(0,360,0,300) Main.Position=UDim2.new(.5,-180,.5,-150) Main.BackgroundColor3=Color3.fromRGB(12,8,24) Main.BorderSizePixel=0 Main.ZIndex=2 Main.Parent=G
    Instance.new("UICorner",Main).CornerRadius=UDim.new(0,20)
    local Grad=Instance.new("UIGradient") Grad.Rotation=135
    Grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(25,15,45)),ColorSequenceKeypoint.new(1,Color3.fromRGB(15,10,30))} Grad.Parent=Main
    local Stroke=Instance.new("UIStroke",Main) Stroke.Thickness=2 Stroke.Color=Color3.fromRGB(168,85,247) Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local StrokeGrad=Instance.new("UIGradient") StrokeGrad.Rotation=45
    StrokeGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(253,230,138)),ColorSequenceKeypoint.new(.5,Color3.fromRGB(168,85,247)),ColorSequenceKeypoint.new(1,Color3.fromRGB(6,182,212))} StrokeGrad.Parent=Stroke
    local Title=Instance.new("TextLabel") Title.Size=UDim2.new(1,-20,0,26) Title.Position=UDim2.new(0,10,0,20) Title.BackgroundTransparency=1 Title.Text="CHỌN PHIÊN BẢN" Title.TextColor3=Color3.fromRGB(253,230,138) Title.TextSize=18 Title.Font=Enum.Font.GothamBlack Title.ZIndex=3 Title.Parent=Main
    local TitleGrad=Instance.new("UIGradient") TitleGrad.Rotation=0
    TitleGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(253,230,138)),ColorSequenceKeypoint.new(1,Color3.fromRGB(245,158,11))} TitleGrad.Parent=Title
    local Sub=Instance.new("TextLabel") Sub.Size=UDim2.new(1,-20,0,16) Sub.Position=UDim2.new(0,10,0,48) Sub.BackgroundTransparency=1 Sub.Text="Chọn script bạn muốn sử dụng" Sub.TextColor3=Color3.fromRGB(180,150,220) Sub.TextSize=11 Sub.Font=Enum.Font.Gotham Sub.ZIndex=3 Sub.Parent=Main
    local function MakeVersionCard(y, icon, title, desc, color, onClick)
        local Card=Instance.new("TextButton") Card.Size=UDim2.new(1,-30,0,64) Card.Position=UDim2.new(0,15,0,y) Card.BackgroundColor3=Color3.fromRGB(25,18,45) Card.Text="" Card.AutoButtonColor=false Card.BorderSizePixel=0 Card.ZIndex=3 Card.Parent=Main
        Instance.new("UICorner",Card).CornerRadius=UDim.new(0,12)
        local CStroke=Instance.new("UIStroke",Card) CStroke.Thickness=1.5 CStroke.Color=Color3.fromRGB(80,60,120) CStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        local Gradient=Instance.new("UIGradient") Gradient.Rotation=0
        Gradient.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(30,20,55)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,14,40))} Gradient.Parent=Card
        local IconLbl=Instance.new("TextLabel") IconLbl.Size=UDim2.new(0,50,1,0) IconLbl.Position=UDim2.new(0,8,0,0) IconLbl.BackgroundTransparency=1 IconLbl.Text=icon IconLbl.TextSize=26 IconLbl.Font=Enum.Font.GothamBlack IconLbl.ZIndex=4 IconLbl.Parent=Card
        local NameLbl=Instance.new("TextLabel") NameLbl.Size=UDim2.new(1,-70,0,24) NameLbl.Position=UDim2.new(0,64,0,10) NameLbl.BackgroundTransparency=1 NameLbl.Text=title NameLbl.TextColor3=color NameLbl.TextSize=15 NameLbl.Font=Enum.Font.GothamBlack NameLbl.TextXAlignment=Enum.TextXAlignment.Left NameLbl.ZIndex=4 NameLbl.Parent=Card
        local DescLbl=Instance.new("TextLabel") DescLbl.Size=UDim2.new(1,-70,0,18) DescLbl.Position=UDim2.new(0,64,0,34) DescLbl.BackgroundTransparency=1 DescLbl.Text=desc DescLbl.TextColor3=Color3.fromRGB(180,150,220) DescLbl.TextSize=10 DescLbl.Font=Enum.Font.Gotham DescLbl.TextXAlignment=Enum.TextXAlignment.Left DescLbl.ZIndex=4 DescLbl.Parent=Card
        Card.MouseEnter:Connect(function() CStroke.Color=color CStroke.Thickness=2 TweenService:Create(Card,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(35,25,60)}):Play() end)
        Card.MouseLeave:Connect(function() if not Card:GetAttribute("selected") then CStroke.Color=Color3.fromRGB(80,60,120) CStroke.Thickness=1.5 TweenService:Create(Card,TweenInfo.new(.2),{BackgroundColor3=Color3.fromRGB(25,18,45)}):Play() end end)
        Card.MouseButton1Click:Connect(function() onClick(Card, CStroke, color) end)
        return Card, CStroke
    end
    local V1Card, V1Stroke
    local V2Card, V2Stroke
    local function Deselect(card, stroke)
        card:SetAttribute("selected", false)
        stroke.Color=Color3.fromRGB(80,60,120) stroke.Thickness=1.5
    end
    local function Select(card, stroke, color)
        card:SetAttribute("selected", true)
        stroke.Color=color stroke.Thickness=2.5
    end
    V1Card, V1Stroke = MakeVersionCard(80, "V1", "Bản Cũ", "Script gốc, ổn định", Color3.fromRGB(124,92,255), function(card, stroke, color) ChosenVersion=1 Deselect(V2Card, V2Stroke) Select(card, stroke, color) end)
    V2Card, V2Stroke = MakeVersionCard(152, "V2", "Script Mới", "Ổn định", Color3.fromRGB(245,158,11), function(card, stroke, color) ChosenVersion=2 Deselect(V1Card, V1Stroke) Select(card, stroke, color) end)
    ChosenVersion=1
    Select(V1Card, V1Stroke, Color3.fromRGB(124,92,255))
    local OKBtn=Instance.new("TextButton") OKBtn.Size=UDim2.new(1,-30,0,44) OKBtn.Position=UDim2.new(0,15,1,-58) OKBtn.BackgroundColor3=Color3.fromRGB(50,200,100) OKBtn.Text="XÁC NHẬN" OKBtn.TextColor3=Color3.fromRGB(255,255,255) OKBtn.TextSize=14 OKBtn.Font=Enum.Font.GothamBlack OKBtn.BorderSizePixel=0 OKBtn.ZIndex=3 OKBtn.Parent=Main
    Instance.new("UICorner",OKBtn).CornerRadius=UDim.new(0,12)
    local OKStroke=Instance.new("UIStroke",OKBtn) OKStroke.Thickness=1.5 OKStroke.Color=Color3.fromRGB(100,255,150) OKStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local OKGrad=Instance.new("UIGradient") OKGrad.Rotation=90
    OKGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(34,197,94)),ColorSequenceKeypoint.new(1,Color3.fromRGB(22,163,74))} OKGrad.Parent=OKBtn
    OKBtn.MouseEnter:Connect(function() TweenService:Create(OKBtn,TweenInfo.new(.2),{Size=UDim2.new(1,-24,0,48),Position=UDim2.new(0,12,1,-60)}):Play() end)
    OKBtn.MouseLeave:Connect(function() TweenService:Create(OKBtn,TweenInfo.new(.2),{Size=UDim2.new(1,-30,0,44),Position=UDim2.new(0,15,1,-58)}):Play() end)
    OKBtn.MouseButton1Click:Connect(function() G:Destroy() end)
    while G.Parent do task.wait(.1) end
end

ShowVersionPicker()

local SOCIAL_HANDLE,LOGO_ASSET=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local STEAL_HOLD,SCRIPT_URL=cfg.STEAL_HOLD,cfg.SCRIPT_URL
local V2_URL=cfg.V2_LOADER_URL or "https://flowauth.net/v1/loaders/02a9ed204f6b2fbff70b6d171251a3f7.lua"
local BRAND_NAME="Tungtung"

local LoadingGuiRef

local function ShowLoadingUI()
    local c=GC()
    if c:FindFirstChild("Tungtung_LoadingUI") then c.Tungtung_LoadingUI:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui") if pg and pg:FindFirstChild("Tungtung_LoadingUI") then pg.Tungtung_LoadingUI:Destroy() end
    local LOAD_TIME=math.random(6,10)
    local G=Instance.new("ScreenGui") G.Name="Tungtung_LoadingUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=2147483647
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end LoadingGuiRef=G
    local O=Instance.new("Frame") O.Size=UDim2.new(1,0,1,0) O.BackgroundColor3=Color3.fromRGB(0,0,0) O.BackgroundTransparency=0 O.BorderSizePixel=0 O.ZIndex=1 O.Parent=G
    local C=Instance.new("Frame") C.Size=UDim2.new(0,340,0,120) C.Position=UDim2.new(.5,-170,.5,-60) C.BackgroundColor3=Color3.fromRGB(15,12,22) C.BorderSizePixel=0 C.ZIndex=2 C.Parent=G
    Instance.new("UICorner",C).CornerRadius=UDim.new(0,14)
    local S=Instance.new("UIStroke",C) S.Thickness=1.6 S.Color=Color3.fromRGB(168,85,247) S.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local D=Instance.new("Frame") D.Size=UDim2.new(0,8,0,8) D.Position=UDim2.new(0,15,0,18) D.BackgroundColor3=Color3.fromRGB(168,85,247) D.BorderSizePixel=0 D.ZIndex=3 D.Parent=C
    Instance.new("UICorner",D).CornerRadius=UDim.new(1,0)
    local T=Instance.new("TextLabel") T.Size=UDim2.new(1,-40,0,24) T.Position=UDim2.new(0,30,0,10) T.BackgroundTransparency=1 T.Text="ĐANG TẢI SCRIPT" T.TextColor3=Color3.fromRGB(253,230,138) T.TextSize=15 T.Font=Enum.Font.GothamBlack T.TextXAlignment=Enum.TextXAlignment.Left T.ZIndex=3 T.Parent=C
    local Sub=Instance.new("TextLabel") Sub.Size=UDim2.new(1,-30,0,16) Sub.Position=UDim2.new(0,15,0,42) Sub.BackgroundTransparency=1 Sub.Text="Hoàn thành trong 6-10s" Sub.TextColor3=Color3.fromRGB(200,200,200) Sub.TextSize=11 Sub.Font=Enum.Font.Gotham Sub.TextXAlignment=Enum.TextXAlignment.Left Sub.ZIndex=3 Sub.Parent=C
    local BB=Instance.new("Frame") BB.Size=UDim2.new(1,-30,0,6) BB.Position=UDim2.new(0,15,1,-30) BB.BackgroundColor3=Color3.fromRGB(30,20,40) BB.BorderSizePixel=0 BB.ZIndex=3 BB.Parent=C
    Instance.new("UICorner",BB).CornerRadius=UDim.new(1,0)
    local B=Instance.new("Frame") B.Size=UDim2.new(0,0,1,0) B.BackgroundColor3=Color3.fromRGB(168,85,247) B.BorderSizePixel=0 B.ZIndex=4 B.Parent=BB
    Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
    local TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-30,0,14) TL.Position=UDim2.new(0,15,1,-50) TL.BackgroundTransparency=1 TL.Text=LOAD_TIME.."s" TL.TextColor3=Color3.fromRGB(168,85,247) TL.TextSize=10 TL.Font=Enum.Font.Code TL.TextXAlignment=Enum.TextXAlignment.Right TL.ZIndex=3 TL.Parent=C
    TweenService:Create(B,TweenInfo.new(LOAD_TIME,Enum.EasingStyle.Linear),{Size=UDim2.new(1,0,1,0)}):Play()
    task.spawn(function() local s=tick() while tick()-s<LOAD_TIME do local left=LOAD_TIME-(tick()-s) TL.Text=string.format("%.1fs",left) task.wait(.1) end end)
    task.delay(LOAD_TIME,function()
        if G and G.Parent then
            TweenService:Create(O,TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=1}):Play()
            TweenService:Create(C,TweenInfo.new(.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=1}):Play()
            task.wait(.5) G:Destroy() LoadingGuiRef=nil
        end
    end)
end

ShowLoadingUI()

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
    local M=Instance.new("TextLabel") M.Size=UDim2.new(1,-12,0,14) M.Position=UDim2.new(0,6,0,20) M.BackgroundTransparency=1 M.Text="PREMIUM" M.TextColor3=Color3.fromRGB(0,255,163) M.TextSize=9 M.Font=Enum.Font.GothamBold M.TextXAlignment=Enum.TextXAlignment.Left M.Parent=F
    local Tl=Instance.new("TextLabel") Tl.Size=UDim2.new(1,-12,0,14) Tl.Position=UDim2.new(0,6,0,26) Tl.BackgroundTransparency=1 Tl.Text="∞" Tl.TextColor3=Color3.fromRGB(0,255,163) Tl.TextSize=11 Tl.Font=Enum.Font.Code Tl.TextXAlignment=Enum.TextXAlignment.Left Tl.Parent=F
end

local function LaunchTargetScript()
    if IsLaunching then return end IsLaunching=true
    task.wait(.2) TakeGuiSnapshot() getgenv().tungtung_active=true
    task.spawn(function()
        pcall(function()
            if ChosenVersion==2 then
                V2_HOOK()
                task.spawn(function()
                    loadstring(game:HttpGet(V2_URL))()
                end)
            else
                script_key="Premium"
                loadstring(game:HttpGet(SCRIPT_URL))()
            end
        end)
    end)
    task.wait(2) ApplyBranding() ApplyHook() IsLaunching=false
end

local function StartResetUI()
    task.spawn(function()
        local _show=getgenv().Tungtung_ShowReset
        if type(_show)=="string" then _show=_show:lower()~="false" end
        if _show==nil or _show==true then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Reset_ui"))()
            end)
        end
    end)
end

LaunchTargetScript()
ShowStatusHUD()
StartResetUI()
