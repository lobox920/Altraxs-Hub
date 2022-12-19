task.spawn(function()
    local gamemt = getrawmetatable(game)
    setreadonly(gamemt, false)
    local nc = gamemt.__namecall
    
    gamemt.__namecall = newcclosure(function(...)
     if (getnamecallmethod() == 'GetTotalMemoryUsageMb') then
       return math.random(395, 405)
     end
     return nc(...)
    end)
   local BlockedRemotes = { 
       "ResyncCharacter",
       "Handcuffs",
       "CarLeave",
       "GetCurrency", 
       "PurchaseShopItem",
       "ToolPickUp",
       "CarModify",
       "CheckWalkSpeed",
       "GameAnalyticsError",
   }
   local Events = {
       Fire = true, 
       Invoke = true, 
       FireServer = true, 
       InvokeServer = true,
   }
   
   local gameMeta = getrawmetatable(game)
   local psuedoEnv = {
       ["__index"] = gameMeta.__index,
       ["__namecall"] = gameMeta.__namecall;
   }
   setreadonly(gameMeta, false)
   gameMeta.__index, gameMeta.__namecall = newcclosure(function(self, index, ...)
       local scripts = getcallingscript()
       if Events[index] then
           for i,v in pairs(BlockedRemotes) do
               if v == self.Name and not checkcaller() then
                   return workspace:WaitForChild("Altrax Hub") 
               end
           end
       end
       return psuedoEnv.__index(self, index, ...)
   end)
   setreadonly(gameMeta, true)
   hookfunction(game.Stats.GetTotalMemoryUsageMb, function() return math.random(395, 405) end)
end)
--if getgenv().HaveLoadedAltraxsHub == true then game:GetService("Players").LocalPlayer:Kick("Script can only be executed once!") return end
getgenv().HaveLoadedAltraxsHub = true
task.wait(0.8)
---------------------------------------------------Functions---------------------------------------------------
_G.AutoRobATM = false
_G.AutoLockpick = false
_G.AutoSafe = false
_G.CarEspColor = Color3.fromRGB(0,0,255)
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
local humr = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local Main = plr.PlayerGui:WaitForChild("GameMenus")
local ATM = Main:WaitForChild("ATM"):WaitForChild("Hacking")
local ClientObjects = workspace:WaitForChild("ClientObjects")
local mychar = game.Players.LocalPlayer.Character

local vfolder = workspace.Vehicles
local HouseRobbery = workspace:WaitForChild("HouseRobbery")
local EnterableBuildings = workspace:WaitForChild("EnterableBuildings")

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local TeamsF = game:GetService("Teams")
local CivilianTeam = TeamsF:WaitForChild("Civilian")
local PoliceTeam = TeamsF:WaitForChild("Police")
local SheriffTeam = TeamsF:WaitForChild("Sheriff")

local devconsole = CoreGui:FindFirstChild("DevConsoleMaster")
--if devconsole then devconsole:Destroy() end -- DevConsoleMas

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    humr = newChar:WaitForChild("HumanoidRootPart")
    hum = newChar:WaitForChild("Humanoid")
    for i,v in pairs(getconnections(hum:GetPropertyChangedSignal "WalkSpeed")) do
        v:Disable()
    end
    for i,v in pairs(getconnections(hum:GetPropertyChangedSignal "JumpPower")) do
        v:Disable()
    end
end)
for i,v in pairs(getconnections(hum:GetPropertyChangedSignal "WalkSpeed")) do
    v:Disable()
end
for i,v in pairs(getconnections(hum:GetPropertyChangedSignal "JumpPower")) do
    v:Disable()
end
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
SafePart.Parent = workspace.CurrentCamera
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
                    local ContentProvider = game:GetService("ContentProvider")
                    hookfunction(ContentProvider.PreloadAsync or ContentProvider.PreloadAsync(), function(...) 
                        return workspace:WaitForChild(game:GetService("Players").LocalPlayer.Name) -- Some dex or stuff getting detected by this
                    end)
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
Lockpick.Changed:Connect(function()
    local Pick = Lockpick:FindFirstChild("Pick")
    if Lockpick.Position.Y.Scale ~= 0.5 then
        if Pick then
            for i,v in pairs(Lockpick.Pick:GetChildren()) do
                if tonumber(v.Name) then
                    v.Visible = false
                end
            end
        end
    else
        if Pick then
            for i,v in pairs(Lockpick.Pick:GetChildren()) do
                if tonumber(v.Name) then
                    v.Visible = true
                end
            end
        end
    end
end)

Lockpick.DescendantAdded:Connect(function(child)
    if child:IsA("Frame") then
        if tonumber(child.Name) then
            repeat task.wait() until Lockpick:FindFirstChild("Pick")
            task.wait(0.5)
            local Pick = Lockpick:WaitForChild("Pick")
            local TargetLock = child
    
            local RedLine = Pick:WaitForChild("RedLine")

            child.Changed:Connect(function()
                local ChildName = tonumber(child.Name)
                local ChildPos = child.Position.Y.Scale
                local RedLinePos = RedLine.Position.Y.Scale
                local MaxTilt = 0.04
                if ChildName == 1 then -- Max use
                    MaxTilt = 0.17
                elseif ChildName == 2 then
                    MaxTilt = 0.13
                elseif ChildName == 3 then
                    MaxTilt = 0.1
                elseif ChildName == 4 then
                    MaxTilt = 0.07
                elseif ChildName == 5 then
                    MaxTilt = 0.05
                elseif ChildName == 6 then
                    MaxTilt = 0.04
                else
                    MaxTilt = 0.04
                end
                -- Better Method as each frame have a special Tilt
                if ChildPos <= RedLinePos and ChildPos >= RedLinePos - MaxTilt or ChildPos >= RedLinePos and ChildPos <= RedLinePos + MaxTilt then
                    if _G.AutoLockpick and not InCd then
                        Click()
                        task.wait(0.5)
                        InCd = false
                    end
                end
                -- Old method
                --[[
                if ChildPos <= RedLinePos and ChildPos >= RedLinePos - 0.04 or ChildPos >= RedLinePos and ChildPos <= RedLinePos + 0.04 then
                    if _G.AutoLockpick and not InCd then
                        Click()
                        task.wait(0.5)
                        InCd = false
                    end
                end
                ]]
                -- Work fine as long as the anticheat is bypassed
                --[[
                child.Size = UDim2.new(0.1, 0, 10, 0) 
                if _G.AutoLockpick and not InCd then
                    Click()
                    task.wait(0.5)
                    InCd = false
                end
                ]]
            end)
        end
    end
end)


Main.Safe.ChildAdded:Connect(function(child)
    if child:IsA("Frame") and child.Name == "Safe" then
        local SafeUI = Main.Safe
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
    LoadingTitle = "Pro Script",
    LoadingSubtitle = "by lobox920#9889 and Awaken#6969",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, 
       FileName = "Altraxs Hub"
    },
    Discord = {
       Enabled = true,
       Invite = "https://discord.gg/3dPPvsVAy4", 
       RememberJoins = true,
    },
    KeySystem = false, 
    KeySettings = {
       Title = "Altraxs Hub",
       Subtitle = "HomieSexuals",
       Note = "Join the discord https://discord.gg/3dPPvsVAy4",
       FileName = "YourSonWatchesGayShit",
       SaveKey = false,
       GrabKeyFromSite = false, 
       Key = "ILIKEMANS"
    }
})
Rayfield:Notify({
    Title = "Informations",
    Content = "WE ARE NOT RESPONSIBLE IF YOUR ACCOUNT GOT BANNED BY AN ADMINISTATOR AS YOU USED A CHEAT!",
    Duration = 20,
    Image = 4483362458,
    Actions = { -- Notification Buttons
 },
})
 local Tab = Window:CreateTab("Credits", 7072706216)

Tab:CreateParagraph({Title = "Please Read", Content = "If you are getting ban please report it in dm or in my discord server!"})


local Button = Tab:CreateButton({
   Name = "Copy discord link",
   Callback = function()
    setclipboard("https://discord.gg/3dPPvsVAy4")
   end,
})

Tab:CreateParagraph({Title = "lobox920#9889", Content = "Main Script Developper"})
Tab:CreateParagraph({Title = "Awaken#6969", Content = "Script Developper"})


local Tab = Window:CreateTab("Player", 7072724538)


local Slider = Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 1000},
    Increment = 10,
    Suffix = "WalkSpeed",
    CurrentValue = 10,
    Flag = "Slider1",
    Callback = function(Value)
        _G.WalkSpeed = Value
    end,
})
game:GetService"RunService".RenderStepped:Connect(function()
    if _G.WalkSpeedChange then
        hum.WalkSpeed = _G.WalkSpeed
    end
    if _G.JumpPowerChange then
        hum.UseJumpPower = false
        hum.JumpHeight = Value
    end
end)


local Slider = Tab:CreateSlider({
    Name = "JumpPower",
    Range = {7.5, 500},
    Increment = 1,
    Suffix = "JumpPower",
    CurrentValue = 10,
    Flag = "Slider1",
    Callback = function(Value)
        _G.JumpPower = Value
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Inf Stamina",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.InfStamina = Value
        while _G.InfStamina do task.wait()
            firesignal(ReplicatedStorage.FE.FillStamina.OnClientEvent)
        end
    end,
})

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
local Tab = Window:CreateTab("Combat", 7072715317)

Tab:CreateParagraph({Title = "Gun Mods", Content = "Make you able to customise your gun as your wish"})

local GunSettingsF = game:GetService("ReplicatedStorage").Guns.GunSettings

local function ChangeGunStat(property, Value)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        if GunSettingsF:FindFirstChild(tool.Name) then
            require(tool:WaitForChild("GunSettings"))[property] = Value
        end
    end
end
local function RemoveGunStat(property)
    for i,v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") and GunSettingsF:FindFirstChild(v.Name) and v:FindFirstChild("GunSettings") then
            require(v:WaitForChild("GunSettings"))[property] = require(GunSettingsF:WaitForChild(v.Name))[property]
        end
    end
    for i,v in pairs(char:GetChildren()) do
        if v:IsA("Tool") and GunSettingsF:FindFirstChild(v.Name) and v:FindFirstChild("GunSettings") then
            require(v:WaitForChild("GunSettings"))[property] = require(GunSettingsF:WaitForChild(v.Name))[property]
        end
    end
end
local Toggle = Tab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.NoRecoil = Value
        while _G.NoRecoil do task.wait()
            ChangeGunStat("Stability", 0)
        end
        RemoveGunStat("Stability")
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Instant Reload",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.InstantReload = Value
        while _G.InstantReload do task.wait()
            ChangeGunStat("ReloadTime", -1)
        end
        RemoveGunStat("ReloadTime")
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Inf Range",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.InfAmmo = Value
        while _G.InfAmmo do task.wait()
            ChangeGunStat("Range", 10000)
        end
        RemoveGunStat("Range")
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Inf FireRate",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.ToggleFireRate = Value
        while _G.ToggleFireRate do task.wait()
            ChangeGunStat("Firerate", 0.01)
        end
        RemoveGunStat("Firerate")
    end,
})
local Toggle = Tab:CreateToggle({
    Name = "Accuracy Changer",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.AccuracyChanger = Value
        while _G.AccuracyChanger do task.wait()
            ChangeGunStat("Accuracy", _G.Accuracy)
        end
        RemoveGunStat("Accuracy")
    end,
})
local Slider = Tab:CreateSlider({
    Name = "Accuracy",
    Range = {0, 20},
    Increment = 0.01,
    Suffix = "Gun/Bullet Accuracy",
    CurrentValue = 10,
    Flag = "Slider1",
    Callback = function(Value)
        _G.Accuracy = Value
    end,
})

local Tab = Window:CreateTab("ESP", 7072716095)

Tab:CreateParagraph({Title = "ESP", Content = "Make you able to see threw anything stuffs"})

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
local Tab = Window:CreateTab("Teleports", 7072718631) 

Tab:CreateParagraph({Title = "Teleports", Content = "Use invisible for more safe teleport"})

Tab:CreateButton({
    Name = "Safe Zone",
    Callback = function()
        if char then
            if char:FindFirstChild("HumanoidRootPart") then
                char:WaitForChild("HumanoidRootPart").CFrame = SafePart.CFrame*CFrame.new(0,5,0)
            end
        end
    end,
})

Tab:CreateButton({
    Name = "Goto Waypoint",
    Callback = function()
        local Waypoint = ClientObjects:FindFirstChild("OverheadCustomWaypointMarker")
        if Waypoint then
            if char:FindFirstChild("HumanoidRootPart") then
                char:WaitForChild("HumanoidRootPart").CFrame = Waypoint.CFrame * CFrame.new(0,5,0)
            end
        elseif not ClientObjects:FindFirstChild("OverheadCustomWaypointMarker") then
            Rayfield:Notify({
                Title = "Altrix Hub :",
                Content = "No Waypoint Found",
                Duration = 6.5,
                Image = 8982365769,
                Actions = { 
                    Ignore = {
                       Name = "Yes Master",
                       Callback = function()
                    end
                },
            },
            })
        end
    end,
})

local atmlist = {}
for i,v in pairs(workspace.ATMs:GetChildren()) do
    table.insert(atmlist, tostring(i))
end
Tab:CreateDropdown({
    Name = "Atms",
    Options = atmlist,
    CurrentOption = "Option 1",
    Flag = "Dropdown1",
    Callback = function(Option)
        local Atm = workspace.ATMs:GetChildren()[tonumber(Option)]
        repeat
            task.wait()
            humr.CFrame = Atm.WorldPivot
        until
        Atm:FindFirstChild("ClickPart")
        task.wait(0.2)
        humr.CFrame = Atm.WorldPivot*CFrame.new(0,5,0)
    end,
})
local HousesList = {}
for i,v in pairs(workspace.Houses:GetChildren()) do
    table.insert(HousesList, tostring(i))
end
Tab:CreateDropdown({
    Name = "Houses",
    Options = HousesList,
    CurrentOption = "Option 1",
    Flag = "Dropdown1",
    Callback = function(Option)
        local Atm = workspace.Houses:GetChildren()[tonumber(Option)]
        repeat
            task.wait()
            humr.CFrame = Atm.WorldPivot
        until
        Atm:FindFirstChild("Base")
        task.wait(0.2)
        humr.CFrame = Atm.Base.CFrame*CFrame.new(0,5,0)
    end,
})

Tab:CreateDropdown({
    Name = "Common Places",
    Options = {"None","Spawn","Bank","Fire Station"},
    CurrentOption = "None",
    Flag = "Dropdown1",
    Callback = function(Option)
        if char and humr ~= nil then
            if Option == "Spawn" then
                humr.CFrame = CFrame.new(-678.247803, 24.0880184, 669.413757, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            elseif Option == "Bank" then
                humr.CFrame = CFrame.new(-1028, 28, 412, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            elseif Option == "Fire Station" then
                humr.CFrame = CFrame.new(-1128, 23, 206, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            elseif Option == "Hospital" then
                local Hospital = game:GetService("Workspace").EnterableBuildings.Hospital
                repeat
                    task.wait()
                    humr.CFrame = Hospital.WorldPivot
                until
                Hospital:FindFirstChildOfClass("Part")
                task.wait(0.2)
                humr.CFrame = CFrame.new(-141.680466, 23.4109287, -434.881165, 0.999952912, -3.71007296e-08, 0.00970219169, 3.81539564e-08, 1, -1.0837033e-07, -0.00970219169, 1.08735406e-07, 0.999952912)
            end
        end
    end,
 })
Tab:CreateDropdown({
    Name = "Goto Stores/Enterable Buildings",
    Options = {"None","Tool Store","Gun Store","Jewelry Store"},
    CurrentOption = "None",
    Flag = "Dropdown1",
    Callback = function(Option)
        spawn(function()
            pcall(function()
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
                        task.wait(0.2)
                        TweenService:Create(humr, Tweeninfo, {CFrame = GunStore["GunSore_Interior"].WorldPivot}):Play()
                    until
                    GunStore:FindFirstChild("CenterOfInterior")
                    task.wait(0.2)
                    humr.CFrame = CFrame.new(-1222.29126, 23.239994, -193.104797, 0.00848470908, -9.77858772e-09, -0.999963999, 4.9501776e-09, 1, -9.73693748e-09, 0.999963999, -4.86738427e-09, 0.00848470908)
                elseif Option == "Jewelry Store" then
                    repeat
                        task.wait(0.2)
                        TweenService:Create(humr, Tweeninfo, {CFrame = JewelryStore["JewelryInterior"].WorldPivot}):Play()
                    until
                    JewelryInterior:FindFirstChild("CenterOfInterior")
                    task.wait(0.2)
                    humr.CFrame = CFrame.new(-460.767151, 23.9868279, -444.967896, -0.999995232, -2.92526217e-08, 0.00308740465, -2.92346485e-08, 1, 5.86657656e-09, -0.00308740465, 5.77628922e-09, -0.999995232)
                end
            end)
        end)
    end,
})
local Dropdown = Tab:CreateDropdown({
    Name = "Gas Stations",
    Options = {"City Gas Station","County Gas Station", "Town Gas Station"},
    CurrentOption = "Option 1",
    Flag = "Dropdown1",
    Callback = function(Option)
        if char and humr ~= nil then
            if Option == "City Gas Station" then
                humr.CFrame = CFrame.new(-869.368896484375, 23.344104766845703, 484.44085693359375)
                wait(1)
                humr.CFrame = CFrame.new(-869.368896484375, 23.344104766845703, 484.44085693359375)
                task.wait(0.7)
                humr.CFrame = CFrame.new(-869.368896484375, 23.344104766845703, 484.44085693359375)
                wait(0.8)
                humr.CFrame = CFrame.new(-1006.4979248046875, 38.968605041503906, 833.8005981445312)
            elseif Option == "County Gas Station" then
                humr.CFrame = CFrame.new(263.0196533203125, 3.2969253063201904, -689.057373046875)
                wait(1)
                humr.CFrame = CFrame.new(738.2784423828125, 3.771601676940918, -1524.680419921875)
                task.wait(0.8)
                humr.CFrame = CFrame.new(738.2784423828125, 3.771601676940918, -1524.680419921875)
                task.wait(0.8)
                humr.CFrame = CFrame.new(738.2784423828125, 3.771601676940918, -1524.680419921875)
            elseif Option == "Town Gas Station" then
                humr.CFrame = CFrame.new(1542.789794921875, 3.2959001064300537, -781.2706909179688)
                wait(1)
                humr.CFrame = CFrame.new(1890.2059326171875, 3.1904311180114746, -1361.2642822265625)
                wait(1)
                humr.CFrame = CFrame.new(2524.75073, -2.09069061, -1776.50439, 0, 0, -1, 0, 1, 0, 1, 0, 0)

            end
        end
    end,
 })

local Tab = Window:CreateTab("Farming", 7072707588) 

Tab:CreateParagraph({Title = "Please Read", Content = "Move gui to right/left side bottom/top so it wont bug you while auto farm."})

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
    Name = "Rainbow Car",
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
    Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you"re using configuration saving to ensure no overlaps
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
local Button = Tab:CreateButton({
    Name = "Remove Traffic Detections",
    Callback = function()
        local TrafficDetections = workspace:FindFirstChild("TrafficDetections")
        if TrafficDetections then TrafficDetections:Destroy() end
    end,
})
local Shop = Window:CreateTab("Shop", 2161586955) 

local names = {
    "None",
    "Beretta M9",
    "M14",
    "Colt M1911",
    "AK47",
    "Remington 870",
    "Skorpion",
    "Desert Eagle",
    "LMT L129A1",

    -- Gamepass Guns
    "Remington MSR",
    "PPSH 41",
    "Colt Python",
    "M249",
}
local GamePassGuns = {
    "Remington MSR",
    "PPSH 41",
    "Colt Python",
    "M249",
}
Shop:CreateDropdown({
    Name = "Buy Guns",
    Options = names,
    CurrentOption = "None",
    Flag = "Dropdown1",
    Callback = function(Option)
        if Option ~= "None" then
            local function BuyGuns()
                local OldCF = humr.CFrame
                repeat
                    task.wait(0.2)
                    humr.CFrame = GunStore["GunSore_Interior"].WorldPivot
                    ReplicatedStorage.FE.BuyGun:InvokeServer(Option)
                    ReplicatedStorage.FE.EquipGun:InvokeServer(Option, true)
                until GunStore:FindFirstChild("CenterOfInterior") and plr.Backpack:FindFirstChild(Option)
                task.wait()
                humr.CFrame = OldCF
            end

            if table.find(GamePassGuns, Option) then
                if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(plr.UserId, 5743922) then
                    BuyGuns()
                else
                    Rayfield:Notify({
                        Title = "Altrix Hub :",
                        Content = "No gamePass Found",
                        Duration = 6.5,
                        Image = 8982365769,
                        Actions = { 
                            Ignore = {
                               Name = "Yes Master",
                               Callback = function()
                               print("He doing it")
                            end
                        },
                    },
                    })
                end
            else
                BuyGuns()
            end
        end
    end,
})

Shop:CreateDropdown({
    Name = "BuyAmmo",
    Options = names,
    CurrentOption = "None",
    Flag = "Dropdown1",
    Callback = function(Option)
        humr.CFrame = CFrame.new(-1221.8466796875, 21.739999771118164, -181.59596252441406)
        wait(0.5)
        humr.CFrame = CFrame.new(-1221.8466796875, 21.739999771118164, -181.59596252441406)
        wait(0.5)
        humr.CFrame = CFrame.new(-1221.8466796875, 21.739999771118164, -181.59596252441406)
        wait(0.5)
        humr.CFrame = CFrame.new(-1221.8466796875, 21.739999771118164, -181.59596252441406)
        game:GetService("ReplicatedStorage").FE.BuyAmmo:InvokeServer(Option)
        game:GetService("ReplicatedStorage").FE.BuyAmmo:InvokeServer(Option)
        humr.CFrame = CFrame.new(-1203.9273681640625, 23.333995819091797, -21.247079849243164)
    end,
})

local Misc = Window:CreateTab("Misc", 7059346373)

local function webhook(WebHook, player)
    if _G.Webhook ~= nil then
        local url = WebHook
        local data = {
           ["content"] = "@here",
           ["embeds"] = {
               {
                   ["title"] = "Test Webhook Altrax Mod Detection System",
                   ["type"] = "rich",
                   ["color"] = tonumber(0x7269da),
               }
           }
        }
        local newdata = game:GetService("HttpService"):JSONEncode(data)
    
        local headers = {
           ["content-type"] = "application/json"
        }
        request = http_request or request or HttpPost or syn.request
        request({Url = url, Body = newdata, Method = "POST", Headers = headers})
    else
        Rayfield:Notify({
            Title = "Altrax Hub",
            Content = "You must use a valid Webhook!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                   Name = "Yes Master",
                   Callback = function()
                end
            },
        },
        })
    end
end
_G.ModDetection = false
Players.PlayerAdded:Connect(function(player)
    if player:GetRoleInGroup(4328109) == "Moderator" or player:GetRoleInGroup(4328109) == "Developer" or player:GetRoleInGroup(4328109) == "Senior Developer" or player:GetRoleInGroup(4328109) == "Community Manager"  or player:GetRoleInGroup(4328109) == "Owner" then
        if _G.ModDetection then
            webhook("")
        end
    end
end)   

local Button = Misc:CreateButton({
    Name = "Test Webhook",
    Callback = function()
        webhook(_G.Webhook)
    end,
})


local Input = Misc:CreateInput({
    Name = "Webhook",
    PlaceholderText = "https://discord.com/api/webhooks/ ...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.Webhook = Text
    end,
})

local Toggle = Misc:CreateToggle({
    Name = "Mod Detection",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.ModDetection = Value
        if _G.ModDetection ~= true then
            Rayfield:Notify({
                Title = "Altrax Hub :",
                Content = "ModDetection is turned Off",
                Duration = 6.5,
                Image = 4483362458,
                Actions = { 
                    Ignore = {
                       Name = "Yes Master",
                       Callback = function()
                    end
                },
            },
            })
        end
        if _G.ModDetection == true then 
            Rayfield:Notify({
                Title = "Altrax Hub :",
                Content = "ModDetection is On",
                Duration = 6.5,
                Image = 4483362458,
                Actions = { 
                    Ignore = {
                       Name = "Yes Master",
                       Callback = function()
                    end
                },
            },
            })
        end
    end,
})
