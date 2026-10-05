-- Smooth Hub : Dungeon Map
-- ทำงานเฉพาะในแมพ Dungeon (PlaceId 71793674075007)
-- เหมือน Boss Map แต่ไม่มี Auto Replay + มี Wave Control
---------------------------------------------------------
local DUNGEON_PLACE_ID = 12337212938933

if game.PlaceId ~= DUNGEON_PLACE_ID then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- กันรันซ้ำ
local token = {}
_G.SmoothHubDungeonToken = token
local function Alive() return _G.SmoothHubDungeonToken == token end

---------------------------------------------------------
-- 💾 ระบบจำการตั้งค่า
---------------------------------------------------------
local SettingsStore = {}
do
    local owner = LocalPlayer
    local ROOT = "SmoothHub"
    local DIR = ROOT .. "/" .. tostring(owner.UserId)

    local canSave = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
    local canFolder = type(makefolder) == "function" and type(isfolder) == "function"
    local flushers = {}

    function SettingsStore.Path(fileName)
        if canFolder then
            return DIR .. "/" .. fileName .. ".json"
        end
        return ROOT .. "_" .. tostring(owner.UserId) .. "_" .. fileName .. ".json"
    end

    local function ensureFolder()
        if not canFolder then return end
        pcall(function()
            if not isfolder(ROOT) then makefolder(ROOT) end
            if not isfolder(DIR) then makefolder(DIR) end
        end)
    end

    local function copy(value)
        if type(value) ~= "table" then return value end
        local out = {}
        for k, v in pairs(value) do
            out[k] = copy(v)
        end
        return out
    end

    local function clean(value, depth)
        depth = depth or 0
        local kind = type(value)
        if kind == "string" or kind == "boolean" then return value end
        if kind == "number" then
            if value ~= value or value == math.huge or value == -math.huge then return nil end
            return value
        end
        if kind ~= "table" or depth > 6 then return nil end

        local count, isArray = 0, true
        for k in pairs(value) do
            count = count + 1
            if type(k) ~= "number" then isArray = false end
        end
        if isArray then
            for i = 1, count do
                if value[i] == nil then
                    isArray = false
                    break
                end
            end
        end

        local out = {}
        if isArray then
            for i = 1, count do
                local c = clean(value[i], depth + 1)
                if c ~= nil then table.insert(out, c) end
            end
        else
            for k, v in pairs(value) do
                local c = clean(v, depth + 1)
                if c ~= nil then out[tostring(k)] = c end
            end
        end
        return out
    end

    function SettingsStore.Load(fileName)
        if not canSave then return {} end
        local ok, data = pcall(function()
            local path = SettingsStore.Path(fileName)
            if not isfile(path) then return nil end
            return HttpService:JSONDecode(readfile(path))
        end)
        if ok and type(data) == "table" then return data end
        return {}
    end

    function SettingsStore.Write(fileName, data)
        if not canSave then return false end
        ensureFolder()
        local ok = pcall(function()
            writefile(SettingsStore.Path(fileName), HttpService:JSONEncode(data))
        end)
        return ok
    end

    function SettingsStore.Restore(target, saved)
        if type(target) ~= "table" or type(saved) ~= "table" then return end
        for key, default in pairs(target) do
            local value = saved[key]
            if value ~= nil then
                if type(default) == "table" then
                    if type(value) == "table" then
                        if next(default) == nil then
                            target[key] = copy(value)
                        else
                            SettingsStore.Restore(default, value)
                        end
                    end
                elseif type(default) == type(value) then
                    target[key] = value
                end
            end
        end
    end

    function SettingsStore.StartAutoSave(fileName, getData, interval)
        if flushers[fileName] then return end
        local last = nil

        local function flush()
            local ok, snapshot = pcall(function()
                return clean(getData())
            end)
            if not ok or type(snapshot) ~= "table" then return end

            local okSig, signature = pcall(function()
                return HttpService:JSONEncode(snapshot)
            end)
            if not okSig or signature == last then return end

            snapshot.SavedAt = os.time()
            snapshot.Account = owner.Name
            if SettingsStore.Write(fileName, snapshot) then
                last = signature
            end
        end

        flushers[fileName] = flush
        task.spawn(function()
            while true do
                task.wait(interval or 1.5)
                flush()
            end
        end)
    end

    function SettingsStore.Flush(fileName)
        local flush = flushers[fileName]
        if flush then pcall(flush) end
    end
end

local SavedData = SettingsStore.Load("Dungeon")
local SavedUi = type(SavedData.UI) == "table" and SavedData.UI or {}

---------------------------------------------------------
-- ⚙️️ ตั้งค่าเริ่มต้น (เปิดใช้งานฟีเจอร์ Advanced ทั้งหมดเป็นค่าเริ่มต้น)
---------------------------------------------------------
local Config = {
    AutoFarm = false,
    Position = "Down",
    FastAttack = true,
    AutoEquip = true,
    RGBOutline = true,
    NoClip = true,
    StopAtWave = 10,
    CurrentWave = 0,
    WaveControlEnabled = true,
    -- Advanced Defaults (ตั้งเป็น true ทั้งหมดตามที่ขอครับ)
    InfiniteJump = true,
    AntiAFK = true,
    AutoRejoin = true,
    AntiAdmin = true,
    EnableFPSLock = true,
    FPSLimit = 60,
    -- ระบบบันทึกปุ่มที่กด
    KeyHistory = {},
    MaxKeyHistoryLength = 20,
}

SettingsStore.Restore(Config, SavedData.Config)
if Config.Position ~= "Upper" then Config.Position = "Down" end
Config.StopAtWave = math.clamp(math.floor(tonumber(Config.StopAtWave) or 10), 0, 999)

---------------------------------------------------------
-- ⌨️ ระบบบันทึกปุ่มที่กด (Input Logger)
---------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not Alive() then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        local timestamp = os.date("%H:%M:%S")
        
        table.insert(Config.KeyHistory, 1, {
            Key = keyName,
            Time = timestamp,
            GameProcessed = gameProcessed
        })
        
        if #Config.KeyHistory > Config.MaxKeyHistoryLength then
            table.remove(Config.KeyHistory)
        end
        
        SettingsStore.Flush("Dungeon")
    end
end)

---------------------------------------------------------
-- UI (Cascade)
---------------------------------------------------------
local Cascade = loadstring(game:HttpGet("https://raw.githubusercontent.com/smoothhubv1-prog/Cascade-UI-Library/refs/heads/main/Ui.luau"))()

local WindowTints = {
    Blue     = { Background = "#0F1722", View = "#121C2A", Sidebar = "#111B29", Titlebar = "#1D2D45", Menu = "#182436" },
    Purple   = { Background = "#1A1226", View = "#1F1630", Sidebar = "#1C1429", Titlebar = "#33214D", Menu = "#261A38" },
    Pink     = { Background = "#25121A", View = "#2C161F", Sidebar = "#281420", Titlebar = "#4A2133", Menu = "#361B28" },
    Red      = { Background = "#241211", View = "#2B1615", Sidebar = "#271413", Titlebar = "#4A2220", Menu = "#351B1A" },
    Orange   = { Background = "#241A0F", View = "#2B1F12", Sidebar = "#271C10", Titlebar = "#4A3317", Menu = "#35261A" },
    Yellow   = { Background = "#222010", View = "#292611", Sidebar = "#252210", Titlebar = "#453D16", Menu = "#322E18" },
    Green    = { Background = "#0F2016", View = "#12271A", Sidebar = "#112318", Titlebar = "#1D4029", Menu = "#1A3022" },
    Graphite = { Background = "#1C1C1E", View = "#1F1F21", Sidebar = "#202023", Titlebar = "#363636", Menu = "#2C2C2E" },
}

for accentName, tint in pairs(WindowTints) do
    pcall(function()
        local dark = Cascade.Accents[accentName].Dark
        dark.Background = Color3.fromHex(tint.Background)
        dark.View = Color3.fromHex(tint.View)
        dark.Sidebar = Color3.fromHex(tint.Sidebar)
        dark.Titlebar = Color3.fromHex(tint.Titlebar)
        dark.MenuButton = { MenuBackground = Color3.fromHex(tint.Menu) }
    end)
end

local ExtraAccents = {
    { "Black", "#9A9AA0", { Background = "#000000", View = "#090909", Sidebar = "#050505", Titlebar = "#141414", Menu = "#101010" } },
    { "Midnight", "#4C6EF5", { Background = "#05080F", View = "#0A0F1A", Sidebar = "#070B14", Titlebar = "#131C30", Menu = "#0E1524" } },
    { "Sky", "#64D2FF" }, { "Cyan", "#00C7E6" }, { "Teal", "#30B0C7" },
    { "Turquoise", "#40E0D0" }, { "Aqua", "#00E5FF" }, { "Mint", "#63E6BE" },
    { "Emerald", "#10B981" }, { "Forest", "#2E8B57" }, { "Lime", "#A3E635" },
    { "Neon Green", "#39FF14" }, { "Olive", "#8A9A2B" }, { "Gold", "#FFC83D" },
    { "Amber", "#FFA726" }, { "Sand", "#D9B97A" }, { "Sunset", "#FF7A45" },
    { "Peach", "#FF9E80" }, { "Coral", "#FF6F61" }, { "Cherry", "#E0245E" },
    { "Crimson", "#DC143C" }, { "Maroon", "#A52A2A" }, { "Rose", "#FF5C8A" },
    { "Hot Pink", "#FF2E93" }, { "Magenta", "#E040FB" }, { "Violet", "#8B5CF6" },
    { "Lavender", "#B39DDB" }, { "Indigo", "#5E5CE6" }, { "Ocean", "#1E88E5" },
    { "Navy", "#3A5BA0" }, { "Slate", "#7C8DA6" }, { "Silver", "#B0B7C3" },
    { "Brown", "#A2845E" },
}

local function MakeAccent(name, hex, customBg)
    local main = Color3.fromHex(hex)
    local h, s, val = main:ToHSV()
    local selection = Color3.fromHSV(h, math.min(s * 1.05, 1), math.min(val * 0.78, 0.72))
    local focused = Color3.fromHSV(h, s, math.min(val * 0.88, 0.80))
    local buttonBottom = Color3.fromHSV(h, math.min(s * 1.1, 1), math.min(val * 0.6, 0.55))
    local bgS = math.min(s * 0.6, 0.55)

    local function buildSet()
        return {
            SwitchAccent = main,
            Selection = selection,
            SelectionFocused = focused,
            Toggle = { SwitchOn = main },
            Button = { FillPrimary = ColorSequence.new(focused, buttonBottom) },
        }
    end

    local dark = buildSet()
    dark.Background = Color3.fromHSV(h, bgS, 0.13)
    dark.View = Color3.fromHSV(h, bgS, 0.16)
    dark.Sidebar = Color3.fromHSV(h, bgS * 0.95, 0.15)
    dark.Titlebar = Color3.fromHSV(h, bgS * 0.85, 0.28)
    dark.MenuButton = { MenuBackground = Color3.fromHSV(h, bgS * 0.8, 0.20) }

    if customBg then
        dark.Background = Color3.fromHex(customBg.Background)
        dark.View = Color3.fromHex(customBg.View)
        dark.Sidebar = Color3.fromHex(customBg.Sidebar)
        dark.Titlebar = Color3.fromHex(customBg.Titlebar)
        dark.MenuButton = { MenuBackground = Color3.fromHex(customBg.Menu) }
    end

    Cascade.Accents[name] = {
        _id = name,
        Dark = dark,
        Light = buildSet(),
    }
end

do
    local originalSet = function()
        return {
            SwitchAccent = Color3.fromHex("#0A84FF"),
            Selection = Color3.fromHex("#007AFF"),
            SelectionFocused = Color3.fromHex("#0A82FF"),
            Toggle = { SwitchOn = Color3.fromHex("#0A84FF") },
            Button = {
                FillPrimary = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 148, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 110, 255)),
                }),
            },
        }
    end
    local darkSet = originalSet()
    darkSet.Background = Color3.fromHex("#1C1C1E")
    darkSet.View = Color3.fromHex("#1F1F21")
    darkSet.Sidebar = Color3.fromHex("#202023")
    darkSet.Titlebar = Color3.fromHex("#363636")
    darkSet.MenuButton = { MenuBackground = Color3.fromHex("#2C2C2E") }

    Cascade.Accents.Dark = {
        _id = "Dark",
        Dark = darkSet,
        Light = originalSet(),
    }
end

local AccentOrder = { "Blue", "Purple", "Pink", "Red", "Orange", "Yellow", "Green", "Graphite", "Dark" }
for _, entry in ipairs(ExtraAccents) do
    pcall(MakeAccent, entry[1], entry[2], entry[3])
    if Cascade.Accents[entry[1]] then
        table.insert(AccentOrder, entry[1])
    end
end

local App = Cascade.New({
    Name = "Smooth Hub Dungeon",
    WindowPill = true,
    Theme = Cascade.Themes.Dark,
    Accent = (table.find(AccentOrder, SavedUi.Theme) and Cascade.Accents[SavedUi.Theme]) or Cascade.Accents.Dark
})

local Window = App:Window({
    Title = "Smooth Hub",
    Subtitle = "Dungeon : Auto Farm",
    Resizable = true,
    Draggable = true,
    UIBlur = false
})

---------------------------------------------------------
-- Dashboard
---------------------------------------------------------
local DashboardSection = Cascade.Components.Section(Window, {
    Title = "Dashboard",
    Disclosure = false
})

local StatusTab = DashboardSection:Tab({
    Title = "Status",
    Icon = Cascade.Symbols["chartBarFill"] or Cascade.Symbols["leafFill"],
    Selected = true
})

local Dash = {}
local ON_TEXT, OFF_TEXT = "On\u{200B}", "Off\u{200B}"

local function Paint(text, hex)
    return string.format('<font color="%s">%s</font>', hex, text)
end
local function OnOff(v)
    return v and Paint(ON_TEXT, "#5CE16A") or Paint(OFF_TEXT, "#96A5AA")
end

do
    local function AddStatusRow(form, key, title, subtitle, initialText)
        local row = form:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        Dash[key] = row:Right():Label({ Text = initialText or "-" })
    end

    local farmForm = StatusTab:PageSection({
        Title = "🌾 Auto Farm",
        Subtitle = "Dungeon farming status."
    }):Form()
    AddStatusRow(farmForm, "FState", "Auto Farm", "Main switch.", OFF_TEXT)
    AddStatusRow(farmForm, "FStatus", "Farm Status", "What the farm is doing now.")
    AddStatusRow(farmForm, "FWave", "Current Wave", "Wave number from the game.")
    AddStatusRow(farmForm, "FMob", "Mob Remaining", "Monsters left in this wave.")
    AddStatusRow(farmForm, "FTarget", "Target", "Current monster / boss being attacked.")
    AddStatusRow(farmForm, "FPos", "Farm Position", "Above or below the target.")
    AddStatusRow(farmForm, "FAttack", "Fast Attack", "Attacks sent so far.", OFF_TEXT)
    AddStatusRow(farmForm, "FEquip", "Auto Equip (E)", "Draws your weapon after you spawn.", OFF_TEXT)
    AddStatusRow(farmForm, "FNoClip", "No Clip", "Pass through walls while farming.", OFF_TEXT)
    AddStatusRow(farmForm, "FRgb", "RGB Outline", "Rainbow outline while farming.", OFF_TEXT)

    local waveForm = StatusTab:PageSection({
        Title = "🌊 Wave Control",
        Subtitle = "Stop farming at a specific wave."
    }):Form()
    AddStatusRow(waveForm, "WEnabled", "Wave Control", "Enable or disable wave stopping.", OFF_TEXT)
    AddStatusRow(waveForm, "WStopAt", "Stop At Wave", "The wave where the script stops and lets mobs kill you.")
    AddStatusRow(waveForm, "WCurrent", "Current Wave", "Live wave number.")

    local serverForm = StatusTab:PageSection({
        Title = "🖥️️ Server",
        Subtitle = "Live information about the server."
    }):Form()
    AddStatusRow(serverForm, "VMap", "Map", "Which map you are in.")
    AddStatusRow(serverForm, "VJob", "JobId", "First characters of the server id.")
    AddStatusRow(serverForm, "VPlayers", "Players", "Players in this server / max players.")
    AddStatusRow(serverForm, "VPing", "Ping", "Your connection delay to the server.")
    AddStatusRow(serverForm, "VFps", "FPS", "Frames per second on your screen.")
    AddStatusRow(serverForm, "VTime", "Session Time", "How long this script has been running.")
end

---------------------------------------------------------
-- หมวด Dungeon
---------------------------------------------------------
local Category = Cascade.Components.Section(Window, {
    Title = "Dungeon",
    Disclosure = false
})

local FarmTab = Category:Tab({
    Title = "Auto Farm",
    Icon = Cascade.Symbols["leafFill"]
})

local FarmSection = FarmTab:PageSection({
    Title = "🗡️ Auto Farm",
    Subtitle = "Fly to monsters and bosses, then attack."
})
local FarmForm = FarmSection:Form()

local EnableRow = FarmForm:Row()
EnableRow:Left():TitleStack({
    Title = "Enable Farm",
    Subtitle = "Fly to the nearest monster / boss and attack."
})
EnableRow:Right():Toggle({
    Value = Config.AutoFarm,
    ValueChanged = function(self, value)
        Config.AutoFarm = value and true or false
        SettingsStore.Flush("Dungeon")
    end
})

local PositionRow = FarmForm:Row()
PositionRow:Left():TitleStack({
    Title = "Farm Position",
    Subtitle = "Stay above or below the target."
})
local positionOptions = { "Upper", "Down" }
PositionRow:Right():PullDownButton({
    Label = Config.Position,
    Options = positionOptions,
    Value = (Config.Position == "Upper") and 1 or 2,
    ValueChanged = function(self, index)
        Config.Position = positionOptions[index] or "Down"
        self.Label = Config.Position
        SettingsStore.Flush("Dungeon")
    end
})

local CombatSection = FarmTab:PageSection({
    Title = "⚔️ Combat",
    Subtitle = "Attacks and movement while farming."
})
local CombatForm = CombatSection:Form()

local function AddFarmToggle(form, title, subtitle, key)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    row:Right():Toggle({
        Value = Config[key],
        ValueChanged = function(self, value)
            Config[key] = value and true or false
            SettingsStore.Flush("Dungeon")
        end
    })
end

AddFarmToggle(CombatForm, "Fast Attack", "Attack automatically when a target is within 35 studs.", "FastAttack")
AddFarmToggle(CombatForm, "Auto Equip (E)", "Press E a few times after you spawn to draw your weapon.", "AutoEquip")
AddFarmToggle(CombatForm, "No Clip", "Pass through walls and monsters while farming.", "NoClip")
AddFarmToggle(CombatForm, "RGB Outline", "Rainbow outline around your character while farming.", "RGBOutline")

local WaveSection = FarmTab:PageSection({
    Title = "🌊 Wave Control",
    Subtitle = "Choose the wave where the script stops fighting and lets mobs kill you."
})
local WaveForm = WaveSection:Form()

local WaveEnableRow = WaveForm:Row()
WaveEnableRow:Left():TitleStack({
    Title = "Enable Wave Control",
    Subtitle = "When the target wave is reached, stop fighting and let mobs kill you."
})
WaveEnableRow:Right():Toggle({
    Value = Config.WaveControlEnabled,
    ValueChanged = function(self, value)
        Config.WaveControlEnabled = value and true or false
        SettingsStore.Flush("Dungeon")
    end
})

local WaveStopRow = WaveForm:Row()
WaveStopRow:Left():TitleStack({
    Title = "Stop At Wave",
    Subtitle = "The script stops farming when this wave is reached. (0 = never stop)"
})
WaveStopRow:Right():Stepper({
    Minimum = 0,
    Maximum = 999,
    Step = 1,
    Fielded = true,
    Value = Config.StopAtWave,
    ValueChanged = function(self, value)
        Config.StopAtWave = math.clamp(math.floor(tonumber(value) or 0), 0, 999)
        SettingsStore.Flush("Dungeon")
    end
})

local WaveStatusRow = WaveForm:Row()
WaveStatusRow:Left():Label({ Text = "Current Wave" })
local WaveStatusLabel = WaveStatusRow:Right():Label({ Text = "0" })

local StatusSection = FarmTab:PageSection({
    Title = "📊 Status",
    Subtitle = "Current progress."
})
local StatusForm = StatusSection:Form()

local StatusRow = StatusForm:Row()
StatusRow:Left():Label({ Text = "Status" })
local StatusLabel = StatusRow:Right():Label({ Text = "Idle" })

local MobRow = StatusForm:Row()
MobRow:Left():Label({ Text = "Mob Remaining" })
local MobLabel = MobRow:Right():Label({ Text = "-" })

local TargetRow = StatusForm:Row()
TargetRow:Left():Label({ Text = "Target" })
local TargetLabel = TargetRow:Right():Label({ Text = "-" })

---------------------------------------------------------
-- ระบบหาบอส / มอน
---------------------------------------------------------
local function IsBossCandidate(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    return hum ~= nil and root ~= nil and hum.Health > 0
end

local scanCache, lastScan = {}, 0
local function GetBossList()
    local list = {}
    local ai = Workspace:FindFirstChild("AI/Player")
    local folder = ai and ai:FindFirstChild("Boss")
    if folder then
        for _, m in ipairs(folder:GetChildren()) do
            if IsBossCandidate(m) then table.insert(list, m) end
        end
        return list
    end
    if os.clock() - lastScan > 3 then
        lastScan = os.clock()
        scanCache = {}
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("Humanoid") and IsBossCandidate(d.Parent) then
                table.insert(scanCache, d.Parent)
            end
        end
    end
    for _, m in ipairs(scanCache) do
        if m.Parent and IsBossCandidate(m) then table.insert(list, m) end
    end
    return list
end

local function GetMonsterList()
    local list = {}
    local ai = Workspace:FindFirstChild("AI/Player")
    if not ai then return list end
    for _, m in ipairs(ai:GetChildren()) do
        if m:IsA("Model") and IsBossCandidate(m) then
            table.insert(list, m)
        end
    end
    return list
end

local function PickTarget()
    local bosses = GetBossList()
    if #bosses > 0 then
        local best, bestHp = nil, -1
        for _, m in ipairs(bosses) do
            local hp = m:FindFirstChildOfClass("Humanoid").MaxHealth
            if hp > bestHp then best, bestHp = m, hp end
        end
        return best
    end
    local monsters = GetMonsterList()
    if #monsters > 0 then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local best, bestDist = nil, math.huge
            for _, m in ipairs(monsters) do
                local mr = m:FindFirstChild("HumanoidRootPart")
                if mr then
                    local d = (mr.Position - root.Position).Magnitude
                    if d < bestDist then best, bestDist = m, d end
                end
            end
            return best
        end
    end
    return nil
end

---------------------------------------------------------
-- อ่าน Wave จาก UI ของเกม
---------------------------------------------------------
local function ReadWave()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil, nil end
    local wave, mob = nil, nil
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text ~= "" then
            local w = d.Text:match("Wave:%s*(%d+)")
            if w then wave = tonumber(w) end
            local m = d.Text:match("Mob Remaining:%s*(%d+)")
            if m then mob = tonumber(m) end
        end
    end
    return wave, mob
end

---------------------------------------------------------
-- ตัวช่วย
---------------------------------------------------------
local FarmTarget = nil
local AttacksSent = 0
local FLY_SPEED = 200
local ATTACK_RANGE = 35
local ATTACK_KEY = "\x12"
local StopFarming = false

local function GetMyRoot()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Health > 0 then return root, char end
    return nil
end

---------------------------------------------------------
-- บินไปหาบอส / มอน
---------------------------------------------------------
task.spawn(function()
    local lastPick = 0
    while Alive() do
        local dt = RunService.Heartbeat:Wait()
        if not Config.AutoFarm or StopFarming then
            FarmTarget = nil
            scanCache = {}
            continue
        end

        local root = GetMyRoot()
        if not root then
            FarmTarget = nil
            continue
        end

        if FarmTarget then
            local th = FarmTarget:FindFirstChildOfClass("Humanoid")
            if not FarmTarget.Parent or not th or th.Health <= 0 then
                FarmTarget = nil
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end

        if not FarmTarget and os.clock() - lastPick > 0.5 then
            lastPick = os.clock()
            FarmTarget = PickTarget()
        end

        local targetRoot = FarmTarget and FarmTarget:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local offsetY = (Config.Position == "Upper") and 6 or -6
            local goal = targetRoot.Position + Vector3.new(0, offsetY, 0)
            local diff = goal - root.Position
            local dist = diff.Magnitude
            root.AssemblyLinearVelocity = Vector3.zero
            if dist > 2 then
                local step = math.min(FLY_SPEED * dt, dist)
                root.CFrame = CFrame.new(root.Position + diff.Unit * step, targetRoot.Position)
            else
                root.CFrame = CFrame.new(goal, targetRoot.Position)
            end
        end
    end
end)

---------------------------------------------------------
-- No Clip
---------------------------------------------------------
task.spawn(function()
    while Alive() do
        RunService.Stepped:Wait()
        if Config.AutoFarm and Config.NoClip and not StopFarming then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- ตรวจสอบเป้าหมายในระยะโจมตี
---------------------------------------------------------
local function TargetInRange(range)
    range = range or ATTACK_RANGE
    if StopFarming then return false end
    local root = GetMyRoot()
    if not root then return false end
    for _, m in ipairs(GetBossList()) do
        local br = m:FindFirstChild("HumanoidRootPart")
        if br and (br.Position - root.Position).Magnitude <= range then
            return true
        end
    end
    for _, m in ipairs(GetMonsterList()) do
        local br = m:FindFirstChild("HumanoidRootPart")
        if br and (br.Position - root.Position).Magnitude <= range then
            return true
        end
    end
    return false
end

---------------------------------------------------------
-- Fast Attack
---------------------------------------------------------
task.spawn(function()
    local bridge = ReplicatedStorage:WaitForChild("BridgeNet2", 10)
    local attackEvent = bridge and bridge:WaitForChild("dataRemoteEvent", 10)
    while Alive() do
        task.wait(0.1)
        if attackEvent and Config.FastAttack and not StopFarming and TargetInRange() then
            local ok = pcall(function()
                attackEvent:FireServer({ { "NormalAttack", 1 }, ATTACK_KEY })
            end)
            if ok then AttacksSent += 1 end
        end
    end
end)

---------------------------------------------------------
-- Auto Equip (E)
---------------------------------------------------------
local function TapKey(code)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, code, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, code, false, game)
    end)
end

task.spawn(function()
    local equippedFor = nil
    while Alive() do
        task.wait(0.5)
        local char = LocalPlayer.Character
        if Config.AutoFarm and Config.AutoEquip and char and char ~= equippedFor and GetMyRoot() then
            equippedFor = char
            task.wait(1)
            for _ = 1, 5 do
                if not (Alive() and Config.AutoFarm and LocalPlayer.Character == char) then break end
                TapKey(Enum.KeyCode.E)
                task.wait(0.5)
            end
        end
    end
end)

---------------------------------------------------------
-- RGB Outline
---------------------------------------------------------
task.spawn(function()
    local highlight = nil
    while Alive() do
        task.wait(0.05)
        local char = LocalPlayer.Character
        if Config.AutoFarm and Config.RGBOutline and char and not StopFarming then
            if not highlight or highlight.Parent ~= char then
                if highlight then highlight:Destroy() end
                highlight = Instance.new("Highlight")
                highlight.Name = "SmoothHubRGBDungeon"
                highlight.Adornee = char
                highlight.FillTransparency = 1
                highlight.OutlineTransparency = 0
                highlight.Parent = char
            end
            highlight.OutlineColor = Color3.fromHSV((os.clock() % 5) / 5, 1, 1)
        elseif highlight then
            highlight:Destroy()
            highlight = nil
        end
    end
    if highlight then highlight:Destroy() end
end)

---------------------------------------------------------
-- Wave Control Loop
---------------------------------------------------------
task.spawn(function()
    while Alive() do
        task.wait(0.5)
        local wave, mob = ReadWave()
        if wave then
            Config.CurrentWave = wave
            WaveStatusLabel.Text = tostring(wave)
            MobLabel.Text = mob and tostring(mob) or "-"
        end

        if Config.AutoFarm and Config.WaveControlEnabled and Config.StopAtWave > 0 then
            if wave and wave >= Config.StopAtWave then
                if not StopFarming then
                    StopFarming = true
                    FarmTarget = nil
                    StatusLabel.Text = "Wave " .. wave .. " reached - stopping farm"
                end
            elseif wave and wave < Config.StopAtWave then
                if StopFarming then
                    StopFarming = false
                    StatusLabel.Text = "Farming again..."
                end
            end
        elseif not Config.WaveControlEnabled then
            if StopFarming then
                StopFarming = false
                StatusLabel.Text = "Wave Control disabled - farming again..."
            end
        end
    end
end)

---------------------------------------------------------
-- อัปเดตสถานะ UI
---------------------------------------------------------
task.spawn(function()
    local sessionStart = os.clock()
    local frames, fps, lastFpsTick = 0, 0, os.clock()

    RunService.RenderStepped:Connect(function()
        frames += 1
        local now = os.clock()
        if now - lastFpsTick >= 1 then
            fps = math.floor(frames / (now - lastFpsTick) + 0.5)
            frames = 0
            lastFpsTick = now
        end
    end)

    while Alive() do
        task.wait(0.5)
        pcall(function()
            -- Dashboard Farm
            Dash["FState"].Text = OnOff(Config.AutoFarm)
            Dash["FPos"].Text = Config.Position
            Dash["FAttack"].Text = Config.FastAttack and Paint("On\u{200B} (" .. AttacksSent .. " sent)", "#5CE16A") or OnOff(false)
            Dash["FEquip"].Text = OnOff(Config.AutoEquip)
            Dash["FNoClip"].Text = OnOff(Config.NoClip)
            Dash["FRgb"].Text = OnOff(Config.RGBOutline)

            -- Dashboard Wave
            Dash["WEnabled"].Text = OnOff(Config.WaveControlEnabled)
            Dash["WStopAt"].Text = tostring(Config.StopAtWave)
            Dash["WCurrent"].Text = tostring(Config.CurrentWave)

            -- Dashboard Server
            Dash["VMap"].Text = "Dungeon"
            Dash["VJob"].Text = tostring(game.JobId):sub(1, 8)
            Dash["VPlayers"].Text = string.format("%d / %d", #Players:GetPlayers(), Players.MaxPlayers)
            Dash["VPing"].Text = string.format("%d ms", math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5))
            Dash["VFps"].Text = tostring(fps)
            local elapsed = math.floor(os.clock() - sessionStart)
            Dash["VTime"].Text = string.format("%02d:%02d:%02d", 
                math.floor(elapsed / 3600), 
                math.floor((elapsed % 3600) / 60), 
                elapsed % 60)

            -- Farm Status
            if not Config.AutoFarm then
                Dash["FStatus"].Text = Paint("Idle", "#96A5AA")
                Dash["FTarget"].Text = "-"
                Dash["FWave"].Text = "-"
                Dash["FMob"].Text = "-"
            elseif StopFarming then
                Dash["FStatus"].Text = Paint("Waiting to die at Wave " .. Config.CurrentWave, "#FFB432")
                Dash["FTarget"].Text = "-"
                Dash["FWave"].Text = tostring(Config.CurrentWave)
                Dash["FMob"].Text = "-"
            else
                local targetName = FarmTarget and FarmTarget.Name or "Searching..."
                Dash["FStatus"].Text = Paint("Farming", "#5CE16A")
                Dash["FTarget"].Text = targetName
                Dash["FWave"].Text = tostring(Config.CurrentWave)
                Dash["FMob"].Text = "-"
            end

            -- Status Tab
            if Config.AutoFarm then
                if StopFarming then
                    StatusLabel.Text = "Stopped at Wave " .. Config.CurrentWave .. " - letting mobs kill you"
                else
                    StatusLabel.Text = "Farming..."
                end
            else
                StatusLabel.Text = "Idle"
            end

            TargetLabel.Text = FarmTarget and FarmTarget.Name or "-"
        end)
    end
end)

---------------------------------------------------------
-- หมวด Settings : Advanced / Server / Windows
---------------------------------------------------------
local SettingsCategory = Cascade.Components.Section(Window, {
    Title = "Settings\u{200B}",
    Disclosure = false
})

-- ═════════ Advanced ═════════
local AdvancedTab = SettingsCategory:Tab({
    Title = "Advanced",
    Icon = Cascade.Symbols["gearshapeFill"]
})

local AdvSection = AdvancedTab:PageSection({
    Title = "⚙️ Advanced Settings",
    Subtitle = "Configure advanced player modifications and tools.",
})
local AdvForm = AdvSection:Form()

local function AddAdvToggle(form, title, subtitle, key, onChange)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    row:Right():Toggle({
        Value = Config[key],
        ValueChanged = function(self, value)
            Config[key] = value and true or false
            if onChange then onChange(value) end
            SettingsStore.Flush("Dungeon")
        end
    })
end

AddAdvToggle(AdvForm, "Infinite Jump", "Allow your character to jump infinitely in the air.", "InfiniteJump")
AddAdvToggle(AdvForm, "Anti-AFK", "Prevent being kicked out of the game due to inactivity.", "AntiAFK")
AddAdvToggle(AdvForm, "Auto Rejoin", "Automatically rejoin the game if disconnected or kicked.", "AutoRejoin")
AddAdvToggle(AdvForm, "Anti Admin", "Automatically server hop if an admin joins the game.", "AntiAdmin")

local FpsSection = AdvancedTab:PageSection({
    Title = "🖥️ FPS",
    Subtitle = "Limit the frame rate of the game."
})
local FpsForm = FpsSection:Form()

AddAdvToggle(FpsForm, "Enable FPS Lock", "Toggle frame rate limiting on or off.", "EnableFPSLock", function(value)
    if setfpscap then
        setfpscap(value and Config.FPSLimit or 9999)
    end
end)

local FpsMenuRow = FpsForm:Row()
FpsMenuRow:Left():TitleStack({
    Title = "FPS Limit Preset",
    Subtitle = "Choose target frame rate limit."
})
local fpsOptions = { "15 FPS", "30 FPS", "60 FPS", "120 FPS", "144 FPS", "240 FPS", "500 FPS", "1000 FPS", "9999 (Unlimited)" }
local fpsValues = { 15, 30, 60, 120, 144, 240, 500, 1000, 9999 }
local fpsDefaultIndex = table.find(fpsValues, Config.FPSLimit) or 5

FpsMenuRow:Right():PullDownButton({
    Label = fpsOptions[fpsDefaultIndex],
    Options = fpsOptions,
    Value = fpsDefaultIndex,
    ValueChanged = function(self, index)
        local target = fpsValues[index]
        Config.FPSLimit = target
        self.Label = fpsOptions[index]
        if Config.EnableFPSLock and setfpscap then
            setfpscap(target)
        end
        SettingsStore.Flush("Dungeon")
    end
})

-- ═════════ Server ═════════
local ServerTab = SettingsCategory:Tab({
    Title = "Server",
    Icon = Cascade.Symbols["globe"]
})

local ServerInfoSection = ServerTab:PageSection({
    Title = "🌐 Server Information",
    Subtitle = "Display current server details and identifiers."
})
local ServerInfoForm = ServerInfoSection:Form()

local GameIdRow = ServerInfoForm:Row()
GameIdRow:Left():TitleStack({ Title = "GameId", Subtitle = "The unique ID of this game universe." })
GameIdRow:Right():Label({ Text = tostring(game.GameId) })

local PlaceIdRow = ServerInfoForm:Row()
PlaceIdRow:Left():TitleStack({ Title = "PlaceId", Subtitle = "The specific place ID of this server instance." })
PlaceIdRow:Right():Label({ Text = tostring(game.PlaceId) })

local ServerActionSection = ServerTab:PageSection({
    Title = "💾 Server Actions",
    Subtitle = "Quick tools to copy identifiers or switch servers."
})
local ServerActionForm = ServerActionSection:Form()

local function CopyText(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif syn and syn.write_clipboard then syn.write_clipboard(text)
        elseif Clipboard and Clipboard.set then Clipboard.set(text) end
    end)
end

local function HopServer()
    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local body = HttpService:JSONDecode(req)
        if body and body.data then
            for _, sv in ipairs(body.data) do
                if type(sv) == "table" and sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    table.insert(servers, sv.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end

local function AddAction(form, title, subtitle, fn)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    row:Right():Button({
        Label = "Execute",
        Callback = fn
    })
end

AddAction(ServerActionForm, "Copy JobId", "Copy current JobId to clipboard for friends to join.", function()
    CopyText(tostring(game.JobId))
end)

AddAction(ServerActionForm, "Rejoin Server", "Go back to the main world (this map can't be rejoined directly).", function()
    local TeleportService = game:GetService("TeleportService")
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            LocalPlayer:Kick("\nRejoining...")
            task.wait()
        end
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

AddAction(ServerActionForm, "Server Hop", "Teleport to a different server to find a new one.", HopServer)

-- ═════════ Windows ═════════
local SettingsTab = SettingsCategory:Tab({
    Title = "Windows",
    Icon = Cascade.Symbols["macwindow"] or Cascade.Symbols["sliderHorizontal3"]
})

local ColorSection = SettingsTab:PageSection({
    Title = "🎨 Customs Color",
    Subtitle = "Customize the appearance and visual style of the interface."
})
local ColorForm = ColorSection:Form()
local ColorRow = ColorForm:Row()
ColorRow:Left():TitleStack({
    Title = "Theme Color",
    Subtitle = "The whole palette, not just light or dark."
})

local colorOptions = AccentOrder
local colorMaps = {}
for index, accentName in ipairs(colorOptions) do
    colorMaps[index] = Cascade.Accents[accentName]
end

local DEFAULT_ACCENT = "Dark"
local FOLLOW_THEME = "Theme Default"
local CurrentThemeName = (SavedUi.Theme and table.find(AccentOrder, SavedUi.Theme)) and SavedUi.Theme or DEFAULT_ACCENT
local CurrentAccentName = (SavedUi.Accent == FOLLOW_THEME or (SavedUi.Accent and table.find(AccentOrder, SavedUi.Accent))) and SavedUi.Accent or FOLLOW_THEME
local ACCENT_ONLY_KEYS = { "SwitchAccent", "Selection", "SelectionFocused", "Toggle", "Button" }

local function BuildFinalAccent()
    local base = Cascade.Accents[CurrentThemeName]
    if not base then return nil end
    if CurrentAccentName == FOLLOW_THEME then return base end
    local pick = Cascade.Accents[CurrentAccentName]
    if not pick then return base end
    local combined = { _id = "SmoothHubCustom" }
    for _, mode in ipairs({ "Dark", "Light" }) do
        local set = {}
        for key, value in pairs(base[mode] or {}) do
            set[key] = value
        end
        for _, key in ipairs(ACCENT_ONLY_KEYS) do
            if pick[mode] and pick[mode][key] ~= nil then
                set[key] = pick[mode][key]
            end
        end
        combined[mode] = set
    end
    Cascade.Accents.SmoothHubCustom = combined
    return combined
end

local function ApplyAppearance()
    local finalAccent = BuildFinalAccent()
    if not finalAccent then return end
    App.Accent = finalAccent
    pcall(function()
        if App.SetTheme then
            App:SetTheme(finalAccent)
        elseif Window.RefreshTheme then
            Window:RefreshTheme()
        end
    end)
    task.spawn(function()
        Window.Maximized = not Window.Maximized
        task.wait()
        Window.Maximized = not Window.Maximized
        for _, tab in ipairs({ StatusTab, FarmTab, AdvancedTab, ServerTab, SettingsTab }) do
            if tab.Selected then
                tab.Selected = false
                task.wait()
                tab.Selected = true
                break
            end
        end
    end)
end

ColorRow:Right():PullDownButton({
    Label = CurrentThemeName,
    Options = colorOptions,
    Value = table.find(colorOptions, CurrentThemeName) or 1,
    ValueChanged = function(self, index)
        if colorOptions[index] and colorMaps[index] then
            CurrentThemeName = colorOptions[index]
            self.Label = colorOptions[index]
            ApplyAppearance()
            SettingsStore.Flush("Dungeon")
        end
    end
})

local AccentRow = ColorForm:Row()
AccentRow:Left():TitleStack({
    Title = "Accent Color",
    Subtitle = "Only changes icons, switches and buttons. The background stays the same."
})
local accentOptions = { FOLLOW_THEME }
for _, accentName in ipairs(AccentOrder) do
    table.insert(accentOptions, accentName)
end
AccentRow:Right():PullDownButton({
    Label = CurrentAccentName,
    Options = accentOptions,
    Value = table.find(accentOptions, CurrentAccentName) or 1,
    ValueChanged = function(self, index)
        if accentOptions[index] then
            CurrentAccentName = accentOptions[index]
            self.Label = accentOptions[index]
            ApplyAppearance()
            SettingsStore.Flush("Dungeon")
        end
    end
})

if CurrentAccentName ~= FOLLOW_THEME then
    ApplyAppearance()
end

local BlurSection = SettingsTab:PageSection({
    Title = "✨ Windows Effects",
    Subtitle = "Manage special visual styles for your script window."
})
local BlurForm = BlurSection:Form()

if type(SavedUi.UIBlur) == "boolean" then Window.UIBlur = SavedUi.UIBlur end
if type(SavedUi.Dropshadow) == "boolean" then Window.Dropshadow = SavedUi.Dropshadow end

local BlurRow = BlurForm:Row()
BlurRow:Left():TitleStack({
    Title = "Blur Effect",
    Subtitle = "Enable frosted glass blur effect behind the window."
})
BlurRow:Right():Toggle({
    Value = Window.UIBlur,
    ValueChanged = function(self, value)
        Window.UIBlur = value
        SettingsStore.Flush("Dungeon")
    end
})

local ShadowRow = BlurForm:Row()
ShadowRow:Left():TitleStack({
    Title = "Shadows Effect",
    Subtitle = "Enable smooth dropshadow around the script window."
})
ShadowRow:Right():Toggle({
    Value = Window.Dropshadow,
    ValueChanged = function(self, value)
        Window.Dropshadow = value
        SettingsStore.Flush("Dungeon")
    end
})

local InputSection = SettingsTab:PageSection({
    Title = "⌨️ Input",
    Subtitle = "The shortcut that hides and shows the window."
})
local InputForm = InputSection:Form()
local HotkeyRow = InputForm:Row()
HotkeyRow:Left():TitleStack({
    Title = "Minimize Hotkey",
    Subtitle = "Press to hide or show the window."
})

local currentKeybind = Enum.KeyCode.LeftAlt
if type(SavedUi.Keybind) == "string" then
    pcall(function()
        local savedKey = Enum.KeyCode[SavedUi.Keybind]
        if savedKey then currentKeybind = savedKey end
    end)
end

HotkeyRow:Right():KeybindField({
    Value = currentKeybind,
    ValueChanged = function(self, newKey)
        currentKeybind = newKey
        SettingsStore.Flush("Dungeon")
    end,
    BindPressed = function(self, key, inputComplete, gameProcessedEvent)
        if inputComplete and not gameProcessedEvent then
            Window.Minimized = not Window.Minimized
        end
    end
})

---------------------------------------------------------
-- ระบบเบื้องหลังของหมวด Settings
---------------------------------------------------------
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Alive() and Config.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Alive() and Config.AntiAFK then
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- Auto Rejoin
pcall(function()
    local errorPrompt = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui", true)
    if errorPrompt then
        errorPrompt.ChildAdded:Connect(function(child)
            if child.Name == "promptOverlay" then
                task.wait(1)
                if Alive() and Config.AutoRejoin then
                    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
                end
            end
        end)
    end
end)

-- Anti Admin
local function CheckAdmin(player)
    if player == LocalPlayer or not Config.AntiAdmin then return end
    pcall(function()
        if player:GetRankInGroup(game.CreatorId) >= 250 or player.UserId == game.CreatorId then
            HopServer()
        end
    end)
end
Players.PlayerAdded:Connect(function(player) if Alive() then CheckAdmin(player) end end)
task.spawn(function()
    while Alive() do
        task.wait(3)
        if Config.AntiAdmin then
            for _, player in ipairs(Players:GetPlayers()) do
                CheckAdmin(player)
            end
        end
    end
end)

-- FPS Lock
task.spawn(function()
    while Alive() do
        if Config.EnableFPSLock and setfpscap then
            pcall(setfpscap, Config.FPSLimit)
        end
        task.wait(1)
    end
end)

---------------------------------------------------------
-- ระบบบันทึกการตั้งค่า UI ทั้งหมด (Theme, Accent, Blur, Shadows, Keybind) อัตโนมัติ
---------------------------------------------------------
SettingsStore.StartAutoSave("Dungeon", function()
    return {
        Config = Config,
        UI = {
            Theme = CurrentThemeName,
            Accent = CurrentAccentName,
            UIBlur = Window.UIBlur,
            Dropshadow = Window.Dropshadow,
            Keybind = tostring(currentKeybind.Name),
        },
    }
end)
