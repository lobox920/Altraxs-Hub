------Functions---------------------------------------------------
_G.AutoRobATM = false
_G.AutoLockpick = false
_G.AutoSafe = false
_G.CarEspColor = Color3.fromRGB(0,0,255)
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local humr = char:WaitForChild("HumanoidRootPart")
local Main = plr.PlayerGui:WaitForChild("GameMenus")
local ATM = Main:WaitForChild("ATM"):WaitForChild("Hacking")

local ClientObjects = workspace:WaitForChild("ClientObjects")

local vfolder = workspace.Vehicles
local HouseRobbery = workspace:WaitForChild("HouseRobbery")
local EnterableBuildings = workspace:WaitForChild("EnterableBuildings")

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeamsF = game:GetService("Teams")
local CivilianTeam = TeamsF:WaitForChild("Civilian")
local PoliceTeam = TeamsF:WaitForChild("Police")
local SheriffTeam = TeamsF:WaitForChild("Sheriff")

if ReplicatedStorage:FindFirstChild("GameAnalyticsr") then
    ReplicatedStorage:WaitForChild("GameAnalyticsError"):Destroy()
end
if ReplicatedStorage:FindFirstChild("GameAnalytics") then
    ReplicatedStorage:WaitForChild("GameAnalytics"):Destroy()
end
plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    humr = newChar:WaitForChild("HumanoidRootPart")
end)

local ToolStore = EnterableBuildings:WaitForChild("ToolStore_InteriorParts")
local GunStore = EnterableBuildings:WaitForChild("GunStore_InteriorParts")
local JewelryStore = EnterableBuildings:WaitForChild("JewelryStore_InteriorParts")

plr.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "GameMenus" then
        Main = child
    end
end)


local SafePart = Instance.new("Part")
SafePart.Anchored = true
SafePart.Size = Vector3.new(416,4,416)
SafePart.Position = Vector3.new(0,1000,0)
SafePart.Parent = game.Workspace.CurrentCamera
SafePart.Name =  game:GetService("HttpService"):GenerateGUID(true)

local function CenterMouse()
    local ScreenSize = plr.PlayerGui.GameMenus.AbsoluteSize
    local X = math.floor(ScreenSize.X / 2)
    local Y = math.floor(ScreenSize.Y / 2)
    mousemoveabs(X,Y)
end
local function Click()
    CenterMouse()
    mouse1click()
end
local canclick = true
local SelectingCode = ATM.SelectingCode
ATM.CycleFrame.DescendantAdded:Connect(function(child)
    local success, errorr = pcall(function()
        if child:IsA("TextLabel") then
            local StartTime = tick()
            child:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
                if child.Text == SelectingCode.Text and child.BackgroundTransparency == 0 and child.BackgroundColor3 ~= Color3.fromRGB(0,0,0) then
                    if canclick and _G.AutoRobATM then
                        canclick = false
                        Click()
                        spawn(function()
                            task.wait(0.3)
                            canclick = true
                        end)
                    end
                end
            end)
        end
        if not success then
            print(errormessage)
        end
    end)
end)
local Lockpick = Main:WaitForChild("Lockpick")
local InCd = false
Lockpick.DescendantAdded:Connect(function(child)
    if child:IsA("Frame") then
        if tonumber(child.Name) then
            repeat task.wait() until Lockpick:FindFirstChild("Pick")
            task.wait(0.5)
            local Pick = Lockpick:WaitForChild("Pick")
            local TargetLock = child
    
            local RedLine = Pick:WaitForChild("RedLine")

            child.Changed:Connect(function()
                local ChildPos = child.Position.Y.Scale
                local RedLinePos = RedLine.Position.Y.Scale
                if ChildPos <= RedLinePos and ChildPos >= RedLinePos - 0.04 or ChildPos >= RedLinePos and ChildPos <= RedLinePos + 0.04 then
                    if _G.AutoLockpick and not InCd then
                        Click()
                        task.wait(0.5)
                        InCd = false
                    end
                end
            end)
        end
    end
end)
Main.Safe.ChildAdded:Connect(function(child)
    local success, errormessage = pcall(function()
        if child:IsA("Frame") and child.Name == "Safe" then
            task.wait(2)
            repeat
                local success, message = pcall(function()
                    local Rotation = child.Dial.Rotation
                    local TargetNumber = tonumber(SafeUI.Top2.TargetNum.Text)

                    local CurrentNumber = (math.abs(Rotation) % 360)/36*10
                    if Rotation > 0 then
                        CurrentNumber = 100 - CurrentNumber
                    end
                    if math.abs(CurrentNumber - TargetNumber) <= 1 then
                        if _G.AutoSafe then
                            Click()
                            task.wait(1)
                        end
                    end
                end)
                task.wait(0.0005)
            until SafeUI.Position ~= UDim2.new(0.5, 0, 0.5, 0)
        end
    end)
    if not success then
        print(errormessage)
    end
end)
HouseRobbery.ChildAdded:Connect(function(child)
    if child:IsA("BasePart") and child.Name == "Bill" then
        repeat task.wait() until _G.AutoPickUpCashFromHouse
        if _G.AutoPickUpCashFromHouse then
            ReplicatedStorage.Houses.StealItem:FireServer(child)
        end
    end
end)


---------------Script Insides----------------------------------------
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
    Name = "Altraxs Hub",
    LoadingTitle = "We are Homiesexuals",
    LoadingSubtitle = "by lobox920#9889 and Awaken#6969",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, 
       FileName = "Altraxs Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "sirius", 
       RememberJoins = false 
    },
    KeySystem = false, 
    KeySettings = {
       Title = "Altraxs Hub",
       Subtitle = "HomieSexuals",
       Note = "Join the discord https://discord.gg/3dPPvsVAy4",
       FileName = "YourSonWatchesGayShit",
       SaveKey = true,
       GrabKeyFromSite = true, 
       Key = "Hello"
    }
})


local Tab = Window:CreateTab("Farming", 7072707588) 

Rayfield:Notify({
   Title = "Informations",
   Content = "We are not responsible if your account get banned!",
   Duration = 10,
   Image = 4483362458,
   Actions = { -- Notification Buttons
},
})


local Toggle = Tab:CreateToggle({
    Name = "Auto ATM",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.AutoRobATM = Value
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Auto Lockpick",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.AutoLockpick = Value
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Auto Safe",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.AutoSafe = Value
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Auto Auto PickUp Cash From House",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.AutoPickUpCashFromHouse = Value
    end,
})

local Tab = Window:CreateTab("Player", 7072724538)

local Button = Tab:CreateButton({
    Name = "Invisible",
    Callback = function()
     if char then
         if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char:FindFirstChild("LowerTorso") then
             if char:WaitForChild("Humanoid").Sit then
                 Rayfield:Notify({
                     Title = "Error",
                     Content = "You cannot do that while being sit!",
                     Duration = 6.5,
                     Image = 4483362458,
                 })
             else
                 local humr = char:WaitForChild("HumanoidRootPart")
                 local lastPos = humr.CFrame
                 humr.CFrame = SafePart.CFrame * CFrame.new(0,5,0)
                 task.wait(0.3)
     
                 char:WaitForChild("LowerTorso"):Destroy()
                 task.wait(0.3)
                 humr.CFrame = lastPos
             end
         else
            Rayfield:Notify({
                Title = "Error",
                Content = "You need to have LowerTorso to be invisible!",
                Duration = 6.5,
                Image = 4483362458,
            })
            end
        end
    end,
})

local Tab = Window:CreateTab("Visual / Combat", 7072715317)

Tab:CreateButton({
    Name = "ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Police | Sheriff ESP",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.PoliceESP = Value
        while _G.PoliceESP do task.wait(0.2)
            for i, player in pairs(Players:GetChildren()) do
                if player ~= plr then -- Not the local player :p
                    local pchar = player.Character
                    if pchar ~= nil then
                        if player.Team == SheriffTeam or player.Team == PoliceTeam then
                            if not pchar:FindFirstChild("Highlight") then
                                local Highlight = Instance.new("Highlight")
                                Highlight.FillColor = player.TeamColor.Color
                                Highlight.FillTransparency = 0.3
                                Highlight.OutlineColor = player.TeamColor.Color
                                Highlight.Parent = pchar
                            end
                        else
                            if pchar:FindFirstChild("Highlight") then
                                pchar:WaitForChild("Highlight"):Destroy()
                            end
                        end
                    end
                end
            end
        end -- End
        for i, player in pairs(Players:GetChildren()) do
            if player ~= plr then -- Not the local player :p
                local pchar = player.Character
                if pchar ~= nil then
                    if player.Team == SheriffTeam or player.Team == PoliceTeam then
                        if pchar:FindFirstChild("Highlight") then
                            pchar:WaitForChild("Highlight"):Destroy()
                        end
                    end
                end
            end
        end
    end,
})


local Toggle = Tab:CreateToggle({
    Name = "Car ESP",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.CarEsp = Value
        while _G.CarEsp do task.wait()
            for i,v in pairs(vfolder:GetChildren()) do
                local OwnerOfTheVehicle = v:WaitForChild("Control_Values"):WaitForChild("Owner").Value
                if v:FindFirstChildOfClass("VehicleSeat") and Players:FindFirstChild(OwnerOfTheVehicle) then
                    local player = Players:WaitForChild(OwnerOfTheVehicle)
                    if not v:FindFirstChild("Highlight") and player ~= plr then
                        local Highlight = Instance.new("Highlight")
                        Highlight.FillColor = player.TeamColor.Color
                        Highlight.FillTransparency = 0.3
                        Highlight.OutlineColor = player.TeamColor.Color
                        Highlight.Parent = v
                    end
                end
            end
        end
        for i,v in pairs(vfolder:GetChildren()) do
            if v:FindFirstChildOfClass("VehicleSeat") then
                if v:FindFirstChild("Highlight") then
                    v:WaitForChild("Highlight"):Destroy()
                end
            end
        end
    end,
})


local Tp = Window:CreateTab("Teleports", 7072718631) 

Tp:CreateButton({
    Name = "Safe Zone",
    Callback = function()
        if char then
            if char:FindFirstChild("HumanoidRootPart") then
                char:WaitForChild("HumanoidRootPart").CFrame = SafePart.CFrame
            end
        end
    end,
})

Tp:CreateButton({
    Name = "Goto Waypoint",
    Callback = function()
        if ClientObjects:FindFirstChild("OverheadCustomWaypointMarker") then
            if char:FindFirstChild("HumanoidRootPart") then
                char:WaitForChild("HumanoidRootPart").CFrame = ClientObjects:WaitForChild("OverheadCustomWaypointMarker").CFrame * CFrame.new(0,5,0)
            end
        end
    end,
})

Tp:CreateButton({
    Name = "Goto ATM",
    Callback = function()
        for _, v in ipairs(game:GetService("Workspace").ATMs:GetChildren()) do
            if v:FindFirstChild("ClickPart") then
                if char then
                    humr.CFrame = v.WorldPivot*CFrame.new(0,0,5)
                end
            end
        end
    end,
})

local Dropdown = Tp:CreateDropdown({
    Name = "Goto Stores/Enterable Buildings",
    Options = {"None","Tool Store","Gun Store","Jewelry Store"},
    CurrentOption = "None",
    Flag = "Dropdown1",
    Callback = function(Option)
        spawn(function()
            local Tweeninfo = TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if Option == "Tool Store" then
                repeat
                    task.wait()
                    TweenService:Create(humr, Tweeninfo, {CFrame = ToolStore["Tool Store Interior"].WorldPivot}):Play()
                until
                ToolStore:FindFirstChild("CenterOfInterior")
                task.wait(0.2)
                humr.CFrame = CFrame.new(-435.892303, 24.5480385, -707.300598, -0.852639973, 4.98279249e-08, -0.522498846, 6.98856653e-08, 1, -1.8678298e-08, 0.522498846, -5.24410453e-08, -0.852639973)

            elseif Option == "Gun Store" then
                repeat
                    task.wait()
                    TweenService:Create(humr, Tweeninfo, {CFrame = GunStore["GunSore_Interior"].WorldPivot}):Play()
                until
                GunStore:FindFirstChild("CenterOfInterior")
                task.wait(0.2)
                humr.CFrame = CFrame.new(-1222.29126, 23.239994, -193.104797, 0.00848470908, -9.77858772e-09, -0.999963999, 4.9501776e-09, 1, -9.73693748e-09, 0.999963999, -4.86738427e-09, 0.00848470908)
            elseif Option == "Jewelry Store" then
                repeat
                    task.wait()
                    TweenService:Create(humr, Tweeninfo, {CFrame = JewelryStore["JewelryInterior"].WorldPivot}):Play()
                until
                JewelryInterior:FindFirstChild("CenterOfInterior")
                task.wait(0.2)
                humr.CFrame = CFrame.new(-460.767151, 23.9868279, -444.967896, -0.999995232, -2.92526217e-08, 0.00308740465, -2.92346485e-08, 1, 5.86657656e-09, -0.00308740465, 5.77628922e-09, -0.999995232)
            end
        end)
    end,
})


local Tab = Window:CreateTab("Vehicles", 6034754441) 

Tab:CreateButton({
    Name = "Goto Car",
    Callback = function()
        for i, car in pairs(vfolder:GetChildren()) do
            local OwnerOfTheVehicle = car:WaitForChild("Control_Values"):WaitForChild("Owner").Value
            local player = Players:WaitForChild(OwnerOfTheVehicle)
            if player == plr then
                repeat
                    task.wait()
                    humr.CFrame = car.WorldPivot
                until
                car:FindFirstChild("DriverSeat")
            end
        end
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Car Color",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.RainbowCar = Value
        while _G.RainbowCar do task.wait()
            for i, car in pairs(vfolder:GetChildren()) do
                local OwnerOfTheVehicle = car:WaitForChild("Control_Values"):WaitForChild("Owner").Value
                local player = Players:WaitForChild(OwnerOfTheVehicle)
                if car:FindFirstChild("Body") and player == plr then
                    local body = car:WaitForChild("Body")
                    for i, bodyPart in next, body:GetChildren() do
                        if bodyPart.Name == "COLOR" then
                            local hue = tick() % 5/5
                            local color = Color3.fromHSV(hue,1,1)
                            bodyPart.Color = color
                        end
                    end
                end
            end
        end
    end,
})

local ColorPicker = Tab:CreateColorPicker({
    Name = "Car Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        for i, car in pairs(vfolder:GetChildren()) do
            local OwnerOfTheVehicle = car:WaitForChild("Control_Values"):WaitForChild("Owner").Value
            local player = Players:WaitForChild(OwnerOfTheVehicle)
            if car:FindFirstChild("Body") and player == plr then
                local body = car:WaitForChild("Body")
                for i, bodyPart in next, body:GetChildren() do
                    if bodyPart.Name == "COLOR" then
                        bodyPart.Color = Value
                    end
                end
            end
        end
    end
})
