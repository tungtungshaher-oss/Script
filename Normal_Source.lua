local Players=game:GetService("Players")
local StarterGui=game:GetService("StarterGui")
local UserInputService=game:GetService("UserInputService")
local ProximityPromptService=game:GetService("ProximityPromptService")
local TweenService=game:GetService("TweenService")
local CoreGui=game:GetService("CoreGui")
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

local SOCIAL_HANDLE,LOGO_ASSET=cfg.SOCIAL_HANDLE,cfg.LOGO_ASSET
local STEAL_HOLD=cfg.STEAL_HOLD
local BRAND_NAME="Tungtung"

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

getgenv().Tungtung_BypassEnabled=true
getgenv().Tungtung_AntiHit=false

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

ShowMainUI()
