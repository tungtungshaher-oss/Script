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

repeat task.wait() until game:IsLoaded() and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

local function SavePref(k,v)
    getgenv()["Tungtung_pref_"..k]=v
    pcall(function()
        if writefile and isfile and readfile then
            local d={}
            if isfile("Tungtung_prefs.json") then
                pcall(function() d=HttpService:JSONDecode(readfile("Tungtung_prefs.json")) end)
            end
            d[k]=v
            writefile("Tungtung_prefs.json",HttpService:JSONEncode(d))
        end
    end)
end

local function LoadPref(k)
    local ok,v=pcall(function()
        if readfile and isfile and isfile("Tungtung_prefs.json") then
            return HttpService:JSONDecode(readfile("Tungtung_prefs.json"))[k]
        end
        return nil
    end)
    if ok and v~=nil then return v end
    return getgenv()["Tungtung_pref_"..k]
end

local SavedLang=LoadPref("lang")
local SavedVersion=LoadPref("version")
local SavedNotice=LoadPref("notice")

local Lang=SavedLang or "vi"
local ChosenVersion=SavedVersion or 1
local SkipNotice=(SavedNotice==true)

local function T(vi,en) if Lang=="en" then return en else return vi end end
getgenv().Tungtung_Lang=Lang

local function ShowLanguagePicker()
    local c=GC()
    local G=Instance.new("ScreenGui") G.Name="Tungtung_LangUI" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=2147483647
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local Overlay=Instance.new("Frame") Overlay.Size=UDim2.new(1,0,1,0) Overlay.BackgroundColor3=Color3.fromRGB(0,0,0) Overlay.BackgroundTransparency=.6 Overlay.BorderSizePixel=0 Overlay.ZIndex=1 Overlay.Parent=G
    local Main=Instance.new("Frame") Main.Size=UDim2.new(0,360,0,240) Main.Position=UDim2.new(.5,-180,.5,-120) Main.BackgroundColor3=Color3.fromRGB(12,8,24) Main.BorderSizePixel=0 Main.ZIndex=2 Main.Parent=G
    Instance.new("UICorner",Main).CornerRadius=UDim.new(0,20)
    local Grad=Instance.new("UIGradient") Grad.Rotation=135
    Grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(25,15,45)),ColorSequenceKeypoint.new(1,Color3.fromRGB(15,10,30))} Grad.Parent=Main
    local Stroke=Instance.new("UIStroke",Main) Stroke.Thickness=2 Stroke.Color=Color3.fromRGB(168,85,247) Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local Title=Instance.new("TextLabel") Title.Size=UDim2.new(1,-20,0,28) Title.Position=UDim2.new(0,10,0,20) Title.BackgroundTransparency=1 Title.Text="LANGUAGE / NGÔN NGỮ" Title.TextColor3=Color3.fromRGB(253,230,138) Title.TextSize=16 Title.Font=Enum.Font.GothamBlack Title.ZIndex=3 Title.Parent=Main
    local Sub=Instance.new("TextLabel") Sub.Size=UDim2.new(1,-20,0,20) Sub.Position=UDim2.new(0,10,0,52) Sub.BackgroundTransparency=1 Sub.Text="Choose your language / Chọn ngôn ngữ" Sub.TextColor3=Color3.fromRGB(180,150,220) Sub.TextSize=11 Sub.Font=Enum.Font.Gotham Sub.ZIndex=3 Sub.Parent=Main
    local function MakeBtn(text,y,color)
        local b=Instance.new("TextButton") b.Size=UDim2.new(1,-40,0,48) b.Position=UDim2.new(0,20,0,y) b.BackgroundColor3=color b.Text=text b.TextColor3=Color3.fromRGB(255,255,255) b.TextSize=14 b.Font=Enum.Font.GothamBold b.BorderSizePixel=0 b.ZIndex=3 b.Parent=Main
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
        local st=Instance.new("UIStroke",b) st.Thickness=1.5 st.Color=Color3.fromRGB(120,90,180) st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        return b
    end
    local VIBtn=MakeBtn("TIẾNG VIỆT",95,Color3.fromRGB(124,92,255))
    local ENBtn=MakeBtn("ENGLISH",155,Color3.fromRGB(245,158,11))
    VIBtn.MouseButton1Click:Connect(function() Lang="vi" VIBtn.BackgroundColor3=Color3.fromRGB(50,200,100) task.wait(.15) G:Destroy() end)
    ENBtn.MouseButton1Click:Connect(function() Lang="en" ENBtn.BackgroundColor3=Color3.fromRGB(50,200,100) task.wait(.15) G:Destroy() end)
    while G.Parent do task.wait(.1) end
end

if not SavedLang then
    ShowLanguagePicker()
    SavePref("lang",Lang)
end

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
    local Title=Instance.new("TextLabel") Title.Size=UDim2.new(1,-20,0,26) Title.Position=UDim2.new(0,10,0,20) Title.BackgroundTransparency=1 Title.Text=T("CHỌN PHIÊN BẢN","CHOOSE VERSION") Title.TextColor3=Color3.fromRGB(253,230,138) Title.TextSize=18 Title.Font=Enum.Font.GothamBlack Title.ZIndex=3 Title.Parent=Main
    local Sub=Instance.new("TextLabel") Sub.Size=UDim2.new(1,-20,0,16) Sub.Position=UDim2.new(0,10,0,48) Sub.BackgroundTransparency=1 Sub.Text=T("Chọn script bạn muốn sử dụng","Choose your script") Sub.TextColor3=Color3.fromRGB(180,150,220) Sub.TextSize=11 Sub.Font=Enum.Font.Gotham Sub.ZIndex=3 Sub.Parent=Main
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
    local function Deselect(card, stroke) card:SetAttribute("selected", false) stroke.Color=Color3.fromRGB(80,60,120) stroke.Thickness=1.5 end
    local function Select(card, stroke, color) card:SetAttribute("selected", true) stroke.Color=color stroke.Thickness=2.5 end
    V1Card, V1Stroke = MakeVersionCard(80, "V1", T("Bản Cũ","Old"), T("Script gốc, ổn định","Original, stable"), Color3.fromRGB(124,92,255), function(card, stroke, color) ChosenVersion=1 Deselect(V2Card, V2Stroke) Select(card, stroke, color) end)
    V2Card, V2Stroke = MakeVersionCard(152, "V2", T("Script Mới","New"), T("Ổn định","Stable"), Color3.fromRGB(245,158,11), function(card, stroke, color) ChosenVersion=2 Deselect(V1Card, V1Stroke) Select(card, stroke, color) end)
    Select(V1Card, V1Stroke, Color3.fromRGB(124,92,255))
    local OKBtn=Instance.new("TextButton") OKBtn.Size=UDim2.new(1,-30,0,44) OKBtn.Position=UDim2.new(0,15,1,-58) OKBtn.BackgroundColor3=Color3.fromRGB(50,200,100) OKBtn.Text=T("XÁC NHẬN","CONFIRM") OKBtn.TextColor3=Color3.fromRGB(255,255,255) OKBtn.TextSize=14 OKBtn.Font=Enum.Font.GothamBlack OKBtn.BorderSizePixel=0 OKBtn.ZIndex=3 OKBtn.Parent=Main
    Instance.new("UICorner",OKBtn).CornerRadius=UDim.new(0,12)
    local OKStroke=Instance.new("UIStroke",OKBtn) OKStroke.Thickness=1.5 OKStroke.Color=Color3.fromRGB(100,255,150) OKStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local OKGrad=Instance.new("UIGradient") OKGrad.Rotation=90
    OKGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(34,197,94)),ColorSequenceKeypoint.new(1,Color3.fromRGB(22,163,74))} OKGrad.Parent=OKBtn
    OKBtn.MouseEnter:Connect(function() TweenService:Create(OKBtn,TweenInfo.new(.2),{Size=UDim2.new(1,-24,0,48),Position=UDim2.new(0,12,1,-60)}):Play() end)
    OKBtn.MouseLeave:Connect(function() TweenService:Create(OKBtn,TweenInfo.new(.2),{Size=UDim2.new(1,-30,0,44),Position=UDim2.new(0,15,1,-58)}):Play() end)
    OKBtn.MouseButton1Click:Connect(function() G:Destroy() end)
    while G.Parent do task.wait(.1) end
end

if not SavedVersion then
    ShowVersionPicker()
    SavePref("version",ChosenVersion)
end

if ChosenVersion==2 and not SkipNotice then
    local c=GC()
    local G=Instance.new("ScreenGui") G.Name="Tungtung_V2Notice" G.ResetOnSpawn=false G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling G.IgnoreGuiInset=true G.DisplayOrder=2147483646
    pcall(function() G.Parent=c end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local Overlay=Instance.new("Frame") Overlay.Size=UDim2.new(1,0,1,0) Overlay.BackgroundColor3=Color3.fromRGB(0,0,0) Overlay.BackgroundTransparency=.6 Overlay.BorderSizePixel=0 Overlay.ZIndex=1 Overlay.Parent=G
    local Main=Instance.new("Frame") Main.Size=UDim2.new(0,400,0,220) Main.Position=UDim2.new(.5,-200,.5,-110) Main.BackgroundColor3=Color3.fromRGB(12,8,24) Main.BorderSizePixel=0 Main.ZIndex=2 Main.Parent=G
    Instance.new("UICorner",Main).CornerRadius=UDim.new(0,20)
    local Grad=Instance.new("UIGradient") Grad.Rotation=135
    Grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(25,15,45)),ColorSequenceKeypoint.new(1,Color3.fromRGB(15,10,30))} Grad.Parent=Main
    local Stroke=Instance.new("UIStroke",Main) Stroke.Thickness=2 Stroke.Color=Color3.fromRGB(245,158,11) Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local Title=Instance.new("TextLabel") Title.Size=UDim2.new(1,-20,0,28) Title.Position=UDim2.new(0,10,0,18) Title.BackgroundTransparency=1 Title.Text=T("LƯU Ý QUAN TRỌNG","IMPORTANT NOTICE") Title.TextColor3=Color3.fromRGB(253,230,138) Title.TextSize=18 Title.Font=Enum.Font.GothamBlack Title.ZIndex=3 Title.Parent=Main
    local Msg1=Instance.new("TextLabel") Msg1.Size=UDim2.new(1,-20,0,50) Msg1.Position=UDim2.new(0,10,0,58) Msg1.BackgroundTransparency=1 Msg1.Text=T("Tương Tác Nhanh đã được bật.\nVui lòng KHÔNG bật trong Menu!","Quick Interaction is enabled.\nPlease do NOT enable it in the Menu!") Msg1.TextColor3=Color3.fromRGB(255,255,255) Msg1.TextSize=13 Msg1.Font=Enum.Font.GothamBold Msg1.TextWrapped=true Msg1.ZIndex=3 Msg1.Parent=Main
    local Msg2=Instance.new("TextLabel") Msg2.Size=UDim2.new(1,-20,0,50) Msg2.Position=UDim2.new(0,10,0,114) Msg2.BackgroundTransparency=1 Msg2.Text=T("Quick Interaction is enabled.\nPlease do not enable it in the Menu!","Tương Tác Nhanh đã được bật.\nVui lòng không bật trong Menu!") Msg2.TextColor3=Color3.fromRGB(180,150,220) Msg2.TextSize=11 Msg2.Font=Enum.Font.Gotham Msg2.TextWrapped=true Msg2.ZIndex=3 Msg2.Parent=Main
    local OKBtn=Instance.new("TextButton") OKBtn.Size=UDim2.new(1,-30,0,42) OKBtn.Position=UDim2.new(0,15,1,-56) OKBtn.BackgroundColor3=Color3.fromRGB(50,200,100) OKBtn.Text=T("ĐÃ HIỂU","GOT IT") OKBtn.TextColor3=Color3.fromRGB(255,255,255) OKBtn.TextSize=14 OKBtn.Font=Enum.Font.GothamBlack OKBtn.BorderSizePixel=0 OKBtn.ZIndex=3 OKBtn.Parent=Main
    Instance.new("UICorner",OKBtn).CornerRadius=UDim.new(0,10)
    local OKStroke=Instance.new("UIStroke",OKBtn) OKStroke.Thickness=1.5 OKStroke.Color=Color3.fromRGB(100,255,150) OKStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local OKGrad=Instance.new("UIGradient") OKGrad.Rotation=90
    OKGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(34,197,94)),ColorSequenceKeypoint.new(1,Color3.fromRGB(22,163,74))} OKGrad.Parent=OKBtn
    OKBtn.MouseButton1Click:Connect(function()
        SavePref("notice",true)
        G:Destroy()
    end)
    while G.Parent do task.wait(.1) end
end

local TRIAL_DURATION=cfg.TRIAL_DURATION or 600
local JSONBIN_KEY,JSONBIN_BIN=cfg.JSONBIN_KEY,cfg.JSONBIN_BIN
local JSONBIN_URL="https://api.jsonbin.io/v3/b/"..JSONBIN_BIN
local SOCIAL_HANDLE,LOGO_ASSET=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local STEAL_HOLD,KEY_DURATION=cfg.STEAL_HOLD,cfg.KEY_DURATION
local SPAM_COOLDOWN,SPAM_WINDOW,SPAM_MAX,BAN_DURATION=cfg.SPAM_COOLDOWN,cfg.SPAM_WINDOW,cfg.SPAM_MAX,cfg.BAN_DURATION
local SCRIPT_URL=cfg.SCRIPT_URL
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
    local Tt=Instance.new("TextLabel") Tt.Size=UDim2.new(1,-40,0,24) Tt.Position=UDim2.new(0,30,0,10) Tt.BackgroundTransparency=1 Tt.Text=T("ĐANG TẢI SCRIPT","LOADING SCRIPT") Tt.TextColor3=Color3.fromRGB(253,230,138) Tt.TextSize=15 Tt.Font=Enum.Font.GothamBlack Tt.TextXAlignment=Enum.TextXAlignment.Left Tt.ZIndex=3 Tt.Parent=C
    local Sub=Instance.new("TextLabel") Sub.Size=UDim2.new(1,-30,0,16) Sub.Position=UDim2.new(0,15,0,42) Sub.BackgroundTransparency=1 Sub.Text=T("Hoàn thành trong 6-10s","Completes in 6-10s") Sub.TextColor3=Color3.fromRGB(200,200,200) Sub.TextSize=11 Sub.Font=Enum.Font.Gotham Sub.TextXAlignment=Enum.TextXAlignment.Left Sub.ZIndex=3 Sub.Parent=C
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

local function SaveKeyDuration(dur)
    local t,now=GetBin(),os.time() local o=t[HWID] or {}
    t[HWID]={start=o.start or now,first_seen=o.first_seen or now,last_seen=now,username=USERNAME,userid=USERID,display="@"..USERNAME.." (ID: "..USERID..")",key_activated=true,expire=now+dur,spam_count=o.spam_count or 0}
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
    if e.spam_window_count>SPAM_MAX then e.banned_until=now+BAN_DURATION e.ban_reason="Spam GUI" e.spam_window_count=0 e.spam_window_start=now end
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
            if not InitialGuis[ch] and ch.Name~="Tungtung_GetKeyUI" and ch.Name~="Tungtung_ToastUI" and ch.Name~="Tungtung_InputBlocker" and ch.Name~="Tungtung_StatusUI" and ch.Name~="Tungtung_LoadingUI" and ch.Name~="Tungtung_ResetUI" and ch.Name~="Tungtung_VersionUI" and ch.Name~="Tungtung_LangUI" and ch.Name~="Tungtung_V2Notice" then
                pcall(function() ch:Destroy() end)
            end
        end end
    end
end

local function ApplyBranding()
    local tuned={}
    local function T2(p) if tuned[p] then return end tuned[p]=true if p:IsA("ProximityPrompt") then p.HoldDuration=STEAL_HOLD p.RequiresLineOfSight=false pcall(function() p.MaxActivationDistance=math.max(p.MaxActivationDistance,25) end) end end
    for _,d in ipairs(Workspace:GetDescendants()) do T2(d) end
    task.spawn(function() while getgenv().tungtung_active do task.wait(3) for _,d in ipairs(Workspace:GetDescendants()) do T2(d) end for o in pairs(tuned) do if not o or not o.Parent then tuned[o]=nil end end end end)
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
    task.spawn(function()
        pcall(function()
            if ChosenVersion==2 then
                V2_HOOK()
                task.spawn(function() loadstring(game:HttpGet(V2_URL))() end)
            else
                script_key="Trial"
                loadstring(game:HttpGet(SCRIPT_URL))()
            end
        end)
    end)
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
    if b then return end
    if IsGUIOpen then return end
    local now=os.time()
    if now-LastGUIOpen<SPAM_COOLDOWN then LogSpam() return end
    LastGUIOpen=now IsGUIOpen=true LogSpam()
    if CoreGui:FindFirstChild("Tungtung_GetKeyUI") then CoreGui.Tungtung_GetKeyUI:Destroy() end
    local G=Instance.new("ScreenGui") G.Name="Tungtung_GetKeyUI" G.ResetOnSpawn=false G.DisplayOrder=2147483647
    pcall(function() G.Parent=GC() end) if not G.Parent then G.Parent=LP:WaitForChild("PlayerGui") end
    local M=Instance.new("Frame") M.Size=UDim2.new(0,260,0,150) M.Position=UDim2.new(.5,-130,.5,-75) M.BackgroundColor3=Color3.fromRGB(15,12,22) M.BorderSizePixel=0 M.Parent=G
    Instance.new("UICorner",M).CornerRadius=UDim.new(0,14)
    local L=Instance.new("ImageLabel") L.Size=UDim2.new(0,40,0,40) L.Position=UDim2.new(0,10,0,10) L.BackgroundTransparency=1 L.Image=LOGO_ASSET L.Parent=M
    local Ti=Instance.new("TextLabel") Ti.Size=UDim2.new(1,-60,0,18) Ti.Position=UDim2.new(0,55,0,14) Ti.BackgroundTransparency=1 Ti.Text=BRAND_NAME Ti.TextColor3=Color3.fromRGB(253,230,138) Ti.TextSize=12 Ti.Font=Enum.Font.GothamBlack Ti.TextXAlignment=Enum.TextXAlignment.Left Ti.Parent=M
    local I=Instance.new("TextBox") I.Size=UDim2.new(1,-20,0,30) I.Position=UDim2.new(0,10,0,60) I.BackgroundColor3=Color3.fromRGB(22,14,32) I.TextColor3=Color3.fromRGB(254,243,199) I.PlaceholderColor3=Color3.fromRGB(147,112,175) I.PlaceholderText=T("Dán key...","Paste key...") I.Text="" I.TextSize=11 I.ClearTextOnFocus=false I.Parent=M
    Instance.new("UICorner",I).CornerRadius=UDim.new(0,8)
    local Ck=Instance.new("TextButton") Ck.Size=UDim2.new(1,-20,0,30) Ck.Position=UDim2.new(0,10,0,102) Ck.BackgroundColor3=Color3.fromRGB(245,158,11) Ck.Text=T("KÍCH HOẠT","ACTIVATE") Ck.TextColor3=Color3.fromRGB(22,14,3) Ck.TextSize=11.5 Ck.Font=Enum.Font.GothamBlack Ck.Parent=M
    Instance.new("UICorner",Ck).CornerRadius=UDim.new(0,8)
    local isC=false
    Ck.MouseButton1Click:Connect(function()
        if isC then return end isC=true PlayDeepBounce(Ck)
        Ck.Text=T("ĐANG KIỂM TRA...","CHECKING...") Ck.BackgroundColor3=Color3.fromRGB(150,100,20)
        task.wait(.4)
        local ek=string.gsub(I.Text,"%s+",""):gsub("%-","_")
        task.spawn(function()
            local bins=GetBin()
            local rec=bins["key_"..ek] or bins["key_"..string.upper(ek)] or bins["key_"..string.lower(ek)]
            if not rec then
                Ck.Text=T("KEY SAI","INVALID KEY") Ck.BackgroundColor3=Color3.fromRGB(180,50,50)
                task.wait(1.5) Ck.Text=T("KÍCH HOẠT","ACTIVATE") Ck.BackgroundColor3=Color3.fromRGB(245,158,11)
                isC=false
                return
            end
            if rec.used==true then
                Ck.Text=T("KEY ĐÃ DÙNG","KEY USED") Ck.BackgroundColor3=Color3.fromRGB(180,50,50)
                task.wait(1.5) Ck.Text=T("KÍCH HOẠT","ACTIVATE") Ck.BackgroundColor3=Color3.fromRGB(245,158,11)
                isC=false
                return
            end
            bins["key_"..rec.key].used=true
            bins["key_"..rec.key].used_at=os.time()
            bins["key_"..rec.key].used_by=USERNAME
            UpdateBin(bins)
            local dur=rec.duration or KEY_DURATION
            SaveKeyDuration(dur)
            currentMode="NORMAL"
            EndTime=os.time()+dur
            currentTrialRemaining=dur
            Ck.Text=T("THÀNH CÔNG","SUCCESS") Ck.BackgroundColor3=Color3.fromRGB(22,101,52)
            RemoveScreenLockdown()
            ShowLoadingUI()
            LaunchTargetScript() ShowStatusHUD()
            task.wait(.5) IsGUIOpen=false G:Destroy()
        end)
    end)
end

local function StartCountdown()
    task.spawn(function()
        while os.time()<EndTime do task.wait(1) end
        TerminateTargetScript() ApplyScreenLockdown() OpenKeySystemUI()
    end)
end

local function StartResetUI()
    task.spawn(function()
        getgenv().Tungtung_Lang=Lang
        local _show=getgenv().Tungtung_ShowReset
        if type(_show)=="string" then _show=_show:lower()~="false" end
        if _show==nil or _show==true then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/tungtungshaher-oss/Script/refs/heads/main/Reset_ui"))()
            end)
        end
    end)
end

local banned=IsBanned()
if banned then return end

local kt=GetKeyRemainingTime()
if kt and kt>0 then
    currentMode="NORMAL" currentTrialRemaining=kt EndTime=os.time()+kt
    ShowLoadingUI()
    LaunchTargetScript() ShowStatusHUD() StartCountdown() StartResetUI() return
end

local status,remaining=CheckTrialFromServer()
if status=="expired" then
    ApplyScreenLockdown()
    OpenKeySystemUI()
    return
elseif status=="premium" then
    currentMode="NORMAL" currentTrialRemaining=remaining EndTime=os.time()+remaining
    ShowLoadingUI()
    LaunchTargetScript() ShowStatusHUD() StartCountdown() StartResetUI() return
else
    currentMode="TRIAL" currentTrialRemaining=remaining EndTime=os.time()+remaining
    ShowLoadingUI()
    LaunchTargetScript() ShowStatusHUD() StartCountdown() StartResetUI()
end
