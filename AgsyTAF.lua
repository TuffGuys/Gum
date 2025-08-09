-- // AUTH START \\


-- // AUTH END \\


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local success, result = pcall(function()
    if game.CreatorType == Enum.CreatorType.Group then
        local groupInfo = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId)
        return groupInfo.Name == "Aerial Interactive"
    elseif game.CreatorType == Enum.CreatorType.User then
        return false
    end
    return false
end)

if not success or not result then
    game:GetService("Players").LocalPlayer:Kick("Wrong game. Must be Track& Field Infinite")
end

local Window = Rayfield:CreateWindow({
    Name = "Track & Field Infinite Agsy",
    LoadingTitle = "Track & Field Infinite",
    LoadingSubtitle = "Last Update : 8/5/25",
    Theme = "Light",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "TrackFieldConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

Rayfield:Notify({
    Title = "Update!",
    Content = "Shotput feature now free",
    Duration = 6.5,
    Image = "bell"
})

local MainTab = Window:CreateTab("Main", "home")
local InfoTab = Window:CreateTab("Information", "info")

MainTab:CreateSection("Miscellaneous")

MainTab:CreateButton({
    Name = "Disable Hurdle Collision",
    Callback = function()
        local c = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local h = c:WaitForChild("HumanoidRootPart")
        local b = h:FindFirstChild("HurdleHitbox")
        if b then
            b.CanTouch = false
            b.CanCollide = false
            b.CanQuery = false
        end
    end
})

MainTab:CreateToggle({
    Name = "Quick Acceleration",
    CurrentValue = false,
    Flag = "QuickAccel",
    Callback = function(Value)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "maxStamina") then
                if not isreadonly(v) then
                    v.quickAcceleration = Value
                else
                    setreadonly(v, false)
                    v.quickAcceleration = Value
                    setreadonly(v, true)
                end
            end
        end
    end
})

MainTab:CreateSlider({
    Name = "Max Speed",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 75,
    Flag = "MaxSpeed",
    Callback = function(Value)
        _G.maxSpeedValue = Value
    end
})

MainTab:CreateToggle({
    Name = "Toggle Max Speed",
    CurrentValue = false,
    Flag = "MaxSpeedToggle",
    Callback = function(Value)
        if Value then
            _G.maxSpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "table" and rawget(v, "maxStamina") then
                        if not isreadonly(v) then
                            v.maxSpeed = _G.maxSpeedValue or 38
                        else
                            setreadonly(v, false)
                            v.maxSpeed = _G.maxSpeedValue or 38
                            setreadonly(v, true)
                        end
                    end
                end
            end)
        else
            if _G.maxSpeedConnection then
                _G.maxSpeedConnection:Disconnect()
                _G.maxSpeedConnection = nil
            end
        end
    end
})

local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("RemoteEvents"):WaitForChild("Party"):WaitForChild("SendPartyInvite")
local thread = nil

MainTab:CreateToggle({
    Name = "Mass Party Invitation Spam",
    CurrentValue = false,
    Flag = "PartySpam",
    Callback = function(on)
        if on then
            thread = task.spawn(function()
                while true do
                    for _, p in players:GetPlayers() do
                        if p ~= players.LocalPlayer then
                            remote:FireServer(p.UserId)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            if thread then
                task.cancel(thread)
                thread = nil
            end
        end
    end
})

MainTab:CreateSection("Finish Line Extender")

local outlineColor = MainTab:CreateColorPicker({
    Name = "Outline Color",
    Color = Color3.fromRGB(0, 0, 255),
    Flag = "OutlineColor",
    Callback = function(v) _G.outlineColor = v end
})

local meter300 = MainTab:CreateSlider({
    Name = "300 Meter Dash Target",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 270,
    Flag = "Target300",
    Callback = function(v) _G.target300 = v end
})

local meter60 = MainTab:CreateSlider({
    Name = "60 Meter Dash Target",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 60,
    Flag = "Target60",
    Callback = function(v) _G.target60 = v end
})

local meter100 = MainTab:CreateSlider({
    Name = "100 Meter Dash Target",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 70,
    Flag = "Target100",
    Callback = function(v) _G.target100 = v end
})

local meter110 = MainTab:CreateSlider({
    Name = "110 Meter Hurdles Target",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 95,
    Flag = "Target110",
    Callback = function(v) _G.target110 = v end
})

local meter200 = MainTab:CreateSlider({
    Name = "200 Meter Dash Target",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 95,
    Flag = "Target200",
    Callback = function(v) _G.target200 = v end
})

local relay = MainTab:CreateSlider({
    Name = "Relay Target",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 70,
    Flag = "TargetRelay",
    Callback = function(v) _G.targetRelay = v end
})

local other = MainTab:CreateSlider({
    Name = "Other Race Target",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 390,
    Flag = "TargetOther",
    Callback = function(v) _G.targetOther = v end
})

MainTab:CreateButton({
    Name = "Apply Track Config",
    Callback = function()
        local p = game:GetService("Players")
        local w = game:GetService("Workspace")
        local d = false
        
        local t = {
            ["300 METER DASH"] = _G.target300 or 270,
            ["60 METER DASH"] = _G.target60 or 60,
            ["100 METER DASH"] = _G.target100 or 70,
            ["110 METER HURDLES"] = _G.target110 or 95,
            ["200 METER DASH"] = _G.target200 or 95
        }
        
        local function l(part)
            local b = Instance.new("SelectionBox")
            b.Parent = part
            b.Adornee = part
            b.LineThickness = 0.1
            b.Color3 = _G.outlineColor or Color3.new(0,0,1)
        end
        
        local function a()
            if d then return end
            d = true
            
            local title = w.Map.Timers.Timer.Title.SurfaceGui.TitleText.Text
            local size = t[title] or (title:find("RELAY") and (_G.targetRelay or 70)) or (_G.targetOther or 390)
            
            for _,v in pairs(w:GetDescendants()) do
                if v:IsA("Part") then
                    if v.Name == "EndPoint" or v.Name:match("^Checkpoint%d+$") then
                        if v.Name == "EndPoint" then
                            v.Transparency = 0.9
                            l(v)
                        end
                        v.Size = Vector3.new(v.Size.X, v.Size.Y, size)
                        v.CanCollide = false
                    elseif v.Name == "LandingPad" then
                        v.Size = Vector3.new(v.Size.X, 400, v.Size.Z)
                        v.CanCollide = false
                    end
                end
            end
            
            wait(0.1)
            d = false
        end
        
        w.DescendantAdded:Connect(function() 
            if not d then spawn(a) end
        end)
        
        a()
    end
})

MainTab:CreateSection("Device Spoofing")

local function spoofDevice(deviceType)
    local rs = game:GetService("ReplicatedStorage")
    local remote = rs:WaitForChild("RemoteEvents"):WaitForChild("GameLoop"):WaitForChild("SetRuntimeData")
    local year = os.date("%y")
    local verification = tonumber(year) * tonumber(year)
    remote:FireServer({["deviceType"] = deviceType}, verification)
end

MainTab:CreateButton({
    Name = "Controller on Xbox",
    Callback = function() spoofDevice("Controller on Xbox") end
})

MainTab:CreateButton({
    Name = "PC",
    Callback = function() spoofDevice("PC") end
})

MainTab:CreateButton({
    Name = "Mobile",
    Callback = function() spoofDevice("Mobile") end
})

MainTab:CreateButton({
    Name = "Controller on PC",
    Callback = function() spoofDevice("Controller on PC") end
})

MainTab:CreateButton({
    Name = "Controller on Mobile",
    Callback = function() spoofDevice("Controller on Mobile") end
})

MainTab:CreateButton({
    Name = "Controller on Playstation",
    Callback = function() spoofDevice("Controller on Playstation") end
})

InfoTab:CreateSection("Links")

InfoTab:CreateButton({
    Name = "Discord Server",
    Callback = function()
        setclipboard("discord.gg/fmPASmTA")
    end
})

InfoTab:CreateButton({
    Name = "Last updated : 8/5/25",
    Callback = function()
    end
})

Rayfield:LoadConfiguration()

