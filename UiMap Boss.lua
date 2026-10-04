---------------------------------------------------------
-- Smooth Hub : Boss Map - Auto Replay
-- ทำงานเฉพาะในแมพบอส (PlaceId 123949707464677)
---------------------------------------------------------
local BOSS_PLACE_ID = 123949707464677
local MAIN_PLACE_ID = 71793674075007 -- โลกปกติ (ไว้อ้างอิง)

if game.PlaceId ~= BOSS_PLACE_ID then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- กันรันซ้ำ: ลูปเก่าจะหยุดเองเมื่อมี token ใหม่
local token = {}
_G.SmoothHubReplayToken = token
local function Alive() return _G.SmoothHubReplayToken == token end

---------------------------------------------------------
-- กดปุ่มในเกมโดยตรง (ไม่พึ่งชื่อ Remote เพราะชื่อใน Network เปลี่ยนทุกครั้งที่เข้าเซิร์ฟ)
-- วิธี 1: เรียก Connection ของปุ่ม (getconnections / firesignal)
-- วิธี 2: คลิกเมาส์จำลองที่กลางปุ่ม (VirtualInputManager)
-- ครั้งที่ 1,3,5 ใช้วิธี 1 / ครั้งที่ 2,4 ใช้วิธี 2 (สลับกันเวลากดซ้ำ)
---------------------------------------------------------
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local function GetClickable(obj)
    local cur = obj
    while cur and cur ~= PlayerGui do
        if cur:IsA("GuiButton") then return cur end
        cur = cur.Parent
    end
    return obj
end

local function ClickBySignal(btn)
    if not btn:IsA("GuiButton") then return false end
    if getconnections then
        for _, sig in ipairs({ "MouseButton1Click", "Activated" }) do
            local ok, conns = pcall(getconnections, btn[sig])
            if ok and conns and #conns > 0 then
                for _, c in ipairs(conns) do
                    pcall(function() c:Fire() end)
                end
                return true
            end
        end
    end
    if firesignal then
        local ok = pcall(firesignal, btn.MouseButton1Click)
        pcall(firesignal, btn.Activated)
        return ok
    end
    return false
end

local function ClickByMouse(obj)
    local pos, size = obj.AbsolutePosition, obj.AbsoluteSize
    local gui = obj:FindFirstAncestorOfClass("ScreenGui")
    local insetY = (gui and gui.IgnoreGuiInset) and 0 or GuiService:GetGuiInset().Y
    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2 + insetY
    return (pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end))
end

local function ClickGui(textObj, attempt)
    local btn = GetClickable(textObj)
    if attempt % 2 == 1 and ClickBySignal(btn) then
        return true
    end
    return ClickByMouse(btn)
end

---------------------------------------------------------
-- ตั้งค่า + เซฟลงไฟล์ (เผื่อเกม Teleport แล้วตัวนับหาย)
---------------------------------------------------------
---------------------------------------------------------
-- 💾 ระบบจำการตั้งค่า (แยกตามไอดี)
-- เก็บไว้ที่ workspace/SmoothHub/<UserId>/<ชื่อไฟล์>.json
-- ไอดีหลักกับไอดีรองมี UserId คนละตัว = คนละโฟลเดอร์ = ไม่ปนกัน
-- ไอดีที่ไม่เคยเปิดสคริปต์มาก่อนจะเริ่มจากค่าเริ่มต้นเสมอ
---------------------------------------------------------
local SettingsStore = {}
do
    local HttpService = game:GetService("HttpService")
    local owner = game:GetService("Players").LocalPlayer
    local ROOT = "SmoothHub"
    local DIR = ROOT .. "/" .. tostring(owner.UserId)

    local canSave = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
    local canFolder = type(makefolder) == "function" and type(isfolder) == "function"
    local flushers = {}

    function SettingsStore.Path(fileName)
        if canFolder then
            return DIR .. "/" .. fileName .. ".json"
        end
        -- executor ที่ไม่มี makefolder: ใช้ไฟล์เดี่ยว ใส่ UserId ไว้ในชื่อไฟล์แทน
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

    -- ทำให้เป็นข้อมูลที่ JSON เก็บได้ (ตัด function / Instance ทิ้ง)
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

    -- อ่านไฟล์ของไอดีนี้ (ไม่มีไฟล์ / อ่านไม่ได้ = ตารางว่าง = ใช้ค่าเริ่มต้น)
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

    -- เอาค่าที่เซฟไว้ (saved) ใส่ลงตาราง target
    -- รับเฉพาะ key ที่มีอยู่ในค่าเริ่มต้น และชนิดข้อมูลต้องตรงกัน (กันไฟล์เก่า/ไฟล์เพี้ยนทำสคริปต์พัง)
    function SettingsStore.Restore(target, saved)
        if type(target) ~= "table" or type(saved) ~= "table" then return end
        for key, default in pairs(target) do
            local value = saved[key]
            if value ~= nil then
                if type(default) == "table" then
                    if type(value) == "table" then
                        if next(default) == nil then
                            -- ค่าเริ่มต้นเป็นตารางว่าง (เช่น รายการที่ติ๊กเลือก) ใช้ที่เซฟไว้ทั้งก้อน
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

    function SettingsStore.IndexOf(options, name, fallback)
        return table.find(options, name) or fallback or 1
    end

    -- ตาราง { ชื่อ = true } -> รายการ index ของตัวเลือกที่ติ๊กไว้ (ใช้กับ PopUpButton)
    function SettingsStore.IndexesFromMap(options, map)
        local out = {}
        if type(map) == "table" then
            for i, name in ipairs(options) do
                if map[name] then table.insert(out, i) end
            end
        end
        return out
    end

    -- กรองรายการ index ให้เหลือเฉพาะเลขที่ใช้ได้ (ไม่ซ้ำ และอยู่ในช่วง 1..max) โดยคงลำดับเดิม
    function SettingsStore.ValidIndexes(list, max)
        local out, seen = {}, {}
        if type(list) == "table" then
            for _, index in ipairs(list) do
                if type(index) == "number" and index >= 1 and index <= max and index % 1 == 0 and not seen[index] then
                    seen[index] = true
                    table.insert(out, index)
                end
            end
        end
        return out
    end

    -- เริ่มบันทึกอัตโนมัติ: ตรวจทุก interval วินาที ถ้าค่าเปลี่ยนจะเขียนลงไฟล์
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

    -- สั่งเซฟทันที (ไม่ต้องรอรอบถัดไป)
    function SettingsStore.Flush(fileName)
        local flush = flushers[fileName]
        if flush then pcall(flush) end
    end
end

-- โหลดค่าที่จำไว้ของไอดีนี้ (ไม่เคยเซฟ = ใช้ค่าเริ่มต้น)
local SavedData = SettingsStore.Load("BossMap")
local SavedUi = type(SavedData.UI) == "table" and SavedData.UI or {}

-- หลัง Replay ให้ระบบฟาร์มรอจนถึงเวลานี้ (รอบอสเกิดในโฟลเดอร์)
local FarmResumeAt = 0
local REPLAY_WAIT = 3 -- วินาที

local Config = {
    AutoReplay = false,
    Mode = "X Match",   -- "X Match" หรือ "Infinity"
    Target = 5,         -- 1 - 30 (ใช้เฉพาะโหมด X Match)
    RetryDelay = 1,     -- วินาที ก่อนกด Retry
    AutoStart = true,   -- กดปุ่ม Start สีเขียวให้อัตโนมัติ
    Count = 0,          -- จำนวนแมตช์ที่จบแล้ว
}

-- เรียกค่าที่จำไว้กลับมา แล้วตรวจให้ใช้ได้จริง
SettingsStore.Restore(Config, SavedData.Replay)
if Config.Mode ~= "X Match" and Config.Mode ~= "Infinity" then Config.Mode = "X Match" end
Config.Target = math.clamp(math.floor(tonumber(Config.Target) or 5), 1, 30)
Config.RetryDelay = math.clamp(tonumber(Config.RetryDelay) or 1, 0, 10)
-- ตัวนับแมตช์เรียกคืนเฉพาะกรณีเพิ่งเซฟไม่เกิน 3 นาที (ฟาร์มต่อเนื่องหลังวาร์ป) ไม่งั้นเริ่มนับใหม่
if os.time() - (tonumber(SavedData.SavedAt) or 0) >= 180 then
    Config.Count = 0
end
Config.Count = math.max(0, math.floor(tonumber(Config.Count) or 0))

-- สั่งเซฟทันที (นอกจากนี้ระบบจะเซฟอัตโนมัติทุกครั้งที่ค่าใดๆ เปลี่ยน)
local function SaveState()
    SettingsStore.Flush("BossMap")
end

---------------------------------------------------------
-- ตัวช่วยหาปุ่มบนหน้าจอ
---------------------------------------------------------
local function IsVisible(obj)
    local cur = obj
    while cur and cur ~= PlayerGui do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("ScreenGui") and not cur.Enabled then return false end
        cur = cur.Parent
    end
    return cur == PlayerGui
end

local function FindVisibleText(text)
    for _, d in ipairs(PlayerGui:GetDescendants()) do
        if (d:IsA("TextButton") or d:IsA("TextLabel")) then
            local t = d.Text:match("^%s*(.-)%s*$")
            if t == text and IsVisible(d) then
                return d
            end
        end
    end
    return nil
end

---------------------------------------------------------
-- UI (Cascade)
---------------------------------------------------------
local Cascade = loadstring(game:HttpGet("https://raw.githubusercontent.com/smoothhubv1-prog/Cascade-UI-Library/refs/heads/main/Ui.luau"))()

---------------------------------------------------------
-- 🎨 สีพื้นหลัง UI ที่เปลี่ยนตามสี Theme Color
-- แก้รหัสสี (hex) ตรงนี้ได้เลย
-- Background = พื้นหลังหน้าต่าง, View = การ์ดของแต่ละหมวด
-- Sidebar = แถบซ้าย, Titlebar = แถบบนสุด, Menu = เมนูดรอปดาวน์
---------------------------------------------------------
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

---------------------------------------------------------
-- 🌈 สีเพิ่มเติม (สร้างสีหลัก + สีพื้นหลังให้อัตโนมัติจากรหัสสีเดียว)
-- อยากเพิ่มสีใหม่ แค่เติมบรรทัด { "ชื่อสี", "#รหัสสี" } ในตารางนี้
---------------------------------------------------------
local ExtraAccents = {
    -- โทนมืด: ใส่สีพื้นหลังกำหนดเองเป็นช่องที่ 3
    { "Black", "#9A9AA0", { Background = "#000000", View = "#090909", Sidebar = "#050505", Titlebar = "#141414", Menu = "#101010" } },
    { "Midnight", "#4C6EF5", { Background = "#05080F", View = "#0A0F1A", Sidebar = "#070B14", Titlebar = "#131C30", Menu = "#0E1524" } },
    { "Sky",        "#64D2FF" },
    { "Cyan",       "#00C7E6" },
    { "Teal",       "#30B0C7" },
    { "Turquoise",  "#40E0D0" },
    { "Aqua",       "#00E5FF" },
    { "Mint",       "#63E6BE" },
    { "Emerald",    "#10B981" },
    { "Forest",     "#2E8B57" },
    { "Lime",       "#A3E635" },
    { "Neon Green", "#39FF14" },
    { "Olive",      "#8A9A2B" },
    { "Gold",       "#FFC83D" },
    { "Amber",      "#FFA726" },
    { "Sand",       "#D9B97A" },
    { "Sunset",     "#FF7A45" },
    { "Peach",      "#FF9E80" },
    { "Coral",      "#FF6F61" },
    { "Cherry",     "#E0245E" },
    { "Crimson",    "#DC143C" },
    { "Maroon",     "#A52A2A" },
    { "Rose",       "#FF5C8A" },
    { "Hot Pink",   "#FF2E93" },
    { "Magenta",    "#E040FB" },
    { "Violet",     "#8B5CF6" },
    { "Lavender",   "#B39DDB" },
    { "Indigo",     "#5E5CE6" },
    { "Ocean",      "#1E88E5" },
    { "Navy",       "#3A5BA0" },
    { "Slate",      "#7C8DA6" },
    { "Silver",     "#B0B7C3" },
    { "Brown",      "#A2845E" },
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

-- Dark แบบดั้งเดิมของ Cascade: สีปุ่มฟ้าเดิม + พื้นหลังเทาเข้มเดิม
-- ต้องใส่สีพื้นหลังเดิมทับให้ครบทุกช่อง เพราะ Cascade ไม่รีเซ็ตสีเก่าให้ตอนสลับสี
-- (ถ้าไม่ใส่ จะค้างโทนสีของสีก่อนหน้า)
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
    darkSet.Background = Color3.fromHex("#1C1C1E") -- พื้นหลังหน้าต่าง
    darkSet.View = Color3.fromHex("#1F1F21")       -- การ์ดของแต่ละหมวด
    darkSet.Sidebar = Color3.fromHex("#202023")    -- แถบซ้าย
    darkSet.Titlebar = Color3.fromHex("#363636")   -- แถบบนสุด
    darkSet.MenuButton = { MenuBackground = Color3.fromHex("#2C2C2E") }

    Cascade.Accents.Dark = {
        _id = "Dark",
        Dark = darkSet,
        Light = originalSet(),
    }
end

-- ลำดับสีในเมนู: สีเดิม 8 สี, Dark แบบดั้งเดิม แล้วตามด้วยสีเพิ่มเติม
local AccentOrder = { "Blue", "Purple", "Pink", "Red", "Orange", "Yellow", "Green", "Graphite", "Dark" }
for _, entry in ipairs(ExtraAccents) do
    pcall(MakeAccent, entry[1], entry[2], entry[3])
    if Cascade.Accents[entry[1]] then
        table.insert(AccentOrder, entry[1])
    end
end

local App = Cascade.New({
    Name = "Smooth Hub Replay",
    WindowPill = true,
    Theme = Cascade.Themes.Dark,
    -- สีเริ่มต้น = สีที่จำไว้ (ถ้าไม่เคยตั้ง ใช้ Dark)
    Accent = (table.find(AccentOrder, SavedUi.Theme) and Cascade.Accents[SavedUi.Theme]) or Cascade.Accents.Dark
})

local Window = App:Window({
    Title = "Smooth Hub",
    Subtitle = "Boss Map : Auto Replay",
    Resizable = true,
    Draggable = true,
    UIBlur = false
})

---------------------------------------------------------
-- หมวด Dashboard (อยู่บนสุด) + แท็บ Status : รวมสถานะทุกอย่างไว้หน้าเดียว
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

local Dash = {}  -- เก็บ Label ทั้งหมดของหน้า Status
local ON_TEXT, OFF_TEXT = "On\u{200B}", "Off\u{200B}" -- อักขระไร้เสียงกัน Roblox แปลเป็นไทย

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

    -- 🔁 Auto Replay
    local replayForm = StatusTab:PageSection({
        Title = "🔁 Auto Replay",
        Subtitle = "Replay settings and match progress."
    }):Form()
    AddStatusRow(replayForm, "RState", "Auto Replay", "Game Settings tab.", OFF_TEXT)
    AddStatusRow(replayForm, "RMode", "Mode", "X Match or Infinity.")
    AddStatusRow(replayForm, "RProgress", "Matches Done", "Finished matches in this series.")
    AddStatusRow(replayForm, "RStatus", "Replay Status", "What Auto Replay is doing right now.")
    AddStatusRow(replayForm, "RStart", "Auto Start", "Presses the green Start button.", OFF_TEXT)

    -- 🌾 Farming
    local farmForm = StatusTab:PageSection({
        Title = "🌾 Farming",
        Subtitle = "Boss farm and combat."
    }):Form()
    AddStatusRow(farmForm, "FState", "Auto Farm Boss", "Farming tab.", OFF_TEXT)
    AddStatusRow(farmForm, "FStatus", "Farm Status", "What the farm is doing right now.")
    AddStatusRow(farmForm, "FHp", "Boss HP", "Health of the current boss.")
    AddStatusRow(farmForm, "FPos", "Farm Position", "Above or below the boss.")
    AddStatusRow(farmForm, "FAttack", "Fast Attack", "Attacks sent so far.", OFF_TEXT)
    AddStatusRow(farmForm, "FEquip", "Auto Equip (E)", "Draws your weapon after you spawn.", OFF_TEXT)
    AddStatusRow(farmForm, "FNoClip", "No Clip", "Pass through walls while farming.", OFF_TEXT)
    AddStatusRow(farmForm, "FRgb", "RGB Outline", "Rainbow outline while farming.", OFF_TEXT)

    -- ⚡ Auto Skill
    local skillForm = StatusTab:PageSection({
        Title = "⚡ Auto Skill",
        Subtitle = "Skills that are switched on."
    }):Form()
    AddStatusRow(skillForm, "SState", "Auto Skill", "Auto Skill tab.", OFF_TEXT)
    AddStatusRow(skillForm, "SActive", "Active Skills", "Key and mode of each skill in use.", "None")

    -- 🛡️ Safety / Advanced
    local advForm = StatusTab:PageSection({
        Title = "🛡️ Advanced",
        Subtitle = "Protection and player tools."
    }):Form()
    AddStatusRow(advForm, "AAfk", "Anti-AFK", "Advanced tab.", OFF_TEXT)
    AddStatusRow(advForm, "ARejoin", "Auto Rejoin", "Advanced tab.", OFF_TEXT)
    AddStatusRow(advForm, "AAdmin", "Anti Admin", "Advanced tab.", OFF_TEXT)
    AddStatusRow(advForm, "AJump", "Infinite Jump", "Advanced tab.", OFF_TEXT)
    AddStatusRow(advForm, "AFps", "FPS Lock", "Advanced tab.", OFF_TEXT)

    -- 🖥️ Server
    local serverForm = StatusTab:PageSection({
        Title = "🖥️ Server",
        Subtitle = "Live information about the server you are in."
    }):Form()
    AddStatusRow(serverForm, "VMap", "Map", "Which map you are in.")
    AddStatusRow(serverForm, "VJob", "JobId", "First characters of the server id.")
    AddStatusRow(serverForm, "VPlayers", "Players", "Players in this server / max players.")
    AddStatusRow(serverForm, "VPing", "Ping", "Your connection delay to the server.")
    AddStatusRow(serverForm, "VFps", "FPS", "Frames per second on your screen.")
    AddStatusRow(serverForm, "VTime", "Session Time", "How long this script has been running.")
end

local Category = Cascade.Components.Section(Window, {
    Title = "Boss Map",
    Disclosure = false
})

local ReplayTab = Category:Tab({
    Title = "Game Settings",
    Icon = Cascade.Symbols["arrowTriangle2Circlepath"] or Cascade.Symbols["leafFill"]
})

-- ───────── หมวด 1 : Auto Replay ─────────
local ReplaySection = ReplayTab:PageSection({
    Title = "🎮 Game Settings",
    Subtitle = "Presses Retry for you when a match ends, so the game does not send you back to the lobby."
})
local Form = ReplaySection:Form()

local function Colorize(text, hex)
    return string.format('<font color="%s">%s</font>', hex, text)
end

local EnableRow = Form:Row()
EnableRow:Left():TitleStack({
    Title = "Auto Replay",
    Subtitle = "Press Retry automatically after each match."
})
local EnableToggle = EnableRow:Right():Toggle({
    Value = Config.AutoReplay,
    ValueChanged = function(self, value)
        if value and not Config.AutoReplay then
            Config.Count = 0 -- เริ่มนับใหม่ตอนเปิด
        end
        Config.AutoReplay = value and true or false
        SaveState()
    end
})

local modeOptions = { "X Match", "Infinity" }
local ModeRow = Form:Row()
ModeRow:Left():TitleStack({
    Title = "Mode",
    Subtitle = "X Match = stop after the number below.  Infinity = never stop."
})
ModeRow:Right():PullDownButton({
    Label = Config.Mode,
    Options = modeOptions,
    Value = (Config.Mode == "Infinity") and 2 or 1,
    ValueChanged = function(self, index)
        Config.Mode = modeOptions[index] or "X Match"
        self.Label = Config.Mode
        SaveState()
    end
})

local TargetRow = Form:Row()
TargetRow:Left():TitleStack({
    Title = "Matches",
    Subtitle = "How many matches to play (1 - 30). Only used in X Match mode."
})
TargetRow:Right():Stepper({
    Minimum = 1,
    Maximum = 30,
    Step = 1,
    Fielded = true,
    Value = Config.Target,
    ValueChanged = function(self, value)
        Config.Target = math.clamp(math.floor(tonumber(value) or 1), 1, 30)
        SaveState()
    end
})

-- ───────── หมวด 2 : Options ─────────
local OptionSection = ReplayTab:PageSection({
    Title = "⚙️ Options",
    Subtitle = "Timing and automatic buttons."
})
local OptionForm = OptionSection:Form()

local DelayRow = OptionForm:Row()
DelayRow:Left():TitleStack({
    Title = "Retry Delay",
    Subtitle = "Seconds to wait after the match ends before pressing Retry."
})
DelayRow:Right():Stepper({
    Minimum = 0,
    Maximum = 10,
    Step = 1,
    Fielded = true,
    Value = Config.RetryDelay,
    ValueChanged = function(self, value)
        Config.RetryDelay = math.clamp(tonumber(value) or 1, 0, 10)
        SaveState()
    end
})

local StartRow = OptionForm:Row()
StartRow:Left():TitleStack({
    Title = "Auto Start",
    Subtitle = "Press the green Start button when it appears."
})
StartRow:Right():Toggle({
    Value = Config.AutoStart,
    ValueChanged = function(self, value)
        Config.AutoStart = value and true or false
        SaveState()
    end
})

-- ───────── หมวด 3 : Status ─────────
local StatusSection = ReplayTab:PageSection({
    Title = "📊 Status",
    Subtitle = "Current progress of Auto Replay."
})
local StatusForm = StatusSection:Form()

local StatusRow = StatusForm:Row()
StatusRow:Left():Label({ Text = "Status" })
local StatusLabel = StatusRow:Right():Label({ Text = "Idle" })

local CountRow = StatusForm:Row()
CountRow:Left():Label({ Text = "Matches Done" })
local CountLabel = CountRow:Right():Label({ Text = "0" })

local ResetRow = StatusForm:Row()
ResetRow:Left():TitleStack({
    Title = "Reset Counter",
    Subtitle = "Set the finished-match counter back to 0."
})
local function ResetCounter()
    Config.Count = 0
    SaveState()
end
local ResetBtn
ResetBtn = ResetRow:Right():Button({
    Label = "Execute",
    Callback = ResetCounter
})


---------------------------------------------------------
-- ตัวช่วย: ผูกปุ่ม (กันกดซ้ำ 2 ครั้ง) + แต่งไอคอนดรอปดาวน์
---------------------------------------------------------
local function BindButton(btn, fn)
    local last = 0
    local function run()
        if os.clock() - last < 0.5 then return end
        last = os.clock()
        task.spawn(fn)
    end
    pcall(function()
        if btn.__instance then
            local obj = btn.__instance:FindFirstChildWhichIsA("TextButton", true) or btn.__instance
            obj.MouseButton1Click:Connect(run)
        end
    end)
    return run
end

local function StyleDropdown(btn)
    pcall(function()
        local indicator = btn.__instance:FindFirstChild("PullDownIndicator")
        local img = indicator and indicator:FindFirstChild("Indicators")
        if img then
            img.Image = "rbxassetid://115187614425058"
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Size = UDim2.fromOffset(18, 18)
            img.Position = UDim2.fromScale(0.5, 0.5)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end)
end

local function CopyText(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif syn and syn.write_clipboard then syn.write_clipboard(text)
        elseif Clipboard and Clipboard.set then Clipboard.set(text) end
    end)
end

---------------------------------------------------------
-- แท็บ Farming : ฟาร์มบอสในแมพบอส
---------------------------------------------------------
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local FarmConfig = {
    AutoFarm = false,
    Position = "Down",   -- "Upper" = บินอยู่เหนือบอส / "Down" = อยู่ใต้บอส
    FastAttack = true,
    AutoEquip = true,    -- กด E ชักอาวุธหลังเกิด (เหมือน Hub หลัก)
    RGBOutline = true,   -- กรอบ RGB รอบตัวละครตอนฟาร์ม
    NoClip = true,
}
SettingsStore.Restore(FarmConfig, SavedData.Farm)
if FarmConfig.Position ~= "Upper" then FarmConfig.Position = "Down" end

local FarmingTab = Category:Tab({
    Title = "Farming",
    Icon = Cascade.Symbols["leafFill"]
})

local function AddFarmToggle(form, title, subtitle, key)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    row:Right():Toggle({
        Value = FarmConfig[key],
        ValueChanged = function(self, value)
            FarmConfig[key] = value and true or false
        end
    })
end

-- ───────── หมวด 1 : Auto Farm ─────────
local FarmSection = FarmingTab:PageSection({
    Title = "🗡️ Auto Farm Boss",
    Subtitle = "Fly to the boss and stay next to it."
})
local FarmForm = FarmSection:Form()

AddFarmToggle(FarmForm, "Enable Farm", "Fly to the boss in this map and keep facing it.", "AutoFarm")

local PositionRow = FarmForm:Row()
PositionRow:Left():TitleStack({
    Title = "Farm Position",
    Subtitle = "Stay above or below the boss."
})
local positionOptions = { "Upper", "Down" }
local PositionBtn = PositionRow:Right():PullDownButton({
    Label = FarmConfig.Position,
    Options = positionOptions,
    Value = (FarmConfig.Position == "Upper") and 1 or 2,
    ValueChanged = function(self, index)
        FarmConfig.Position = positionOptions[index] or "Down"
        self.Label = FarmConfig.Position
    end
})
StyleDropdown(PositionBtn)

-- ───────── หมวด 2 : Combat ─────────
local CombatSection = FarmingTab:PageSection({
    Title = "⚔️ Combat",
    Subtitle = "Attacks and movement while farming."
})
local CombatForm = CombatSection:Form()

AddFarmToggle(CombatForm, "Fast Attack", "Attack automatically when the boss is within 35 studs.", "FastAttack")
AddFarmToggle(CombatForm, "Auto Equip (E)", "Press E a few times after you spawn to draw your weapon. Fast Attack needs it.", "AutoEquip")
AddFarmToggle(CombatForm, "No Clip", "Pass through walls and the boss while farming.", "NoClip")
AddFarmToggle(CombatForm, "RGB Outline", "Rainbow outline around your character while farming.", "RGBOutline")

-- ───────── หมวด 3 : Farm Status ─────────
local FarmStatusSection = FarmingTab:PageSection({
    Title = "📊 Farm Status",
    Subtitle = "What the farm is doing right now."
})
local FarmStatusForm = FarmStatusSection:Form()

local FarmTargetRow = FarmStatusForm:Row()
FarmTargetRow:Left():Label({ Text = "Status" })
local FarmTargetLabel = FarmTargetRow:Right():Label({ Text = "Idle" })

local FarmHpRow = FarmStatusForm:Row()
FarmHpRow:Left():Label({ Text = "Boss HP" })
local FarmHpLabel = FarmHpRow:Right():Label({ Text = "-" })

local FarmAttackRow = FarmStatusForm:Row()
FarmAttackRow:Left():TitleStack({
    Title = "Attacks Sent",
    Subtitle = "Stays at 0 if the boss is never in range."
})
local FarmAttackLabel = FarmAttackRow:Right():Label({ Text = "0" })

-- ───────── แท็บ Auto Skill ─────────
local SkillTab = Category:Tab({
    Title = "Auto Skill",
    Icon = Cascade.Symbols["boltFill"] or Cascade.Symbols["leafFill"]
})

local SKILL_ORDER = { "Z", "X", "C", "V" }
local SKILL_KEYCODES = { Z = Enum.KeyCode.Z, X = Enum.KeyCode.X, C = Enum.KeyCode.C, V = Enum.KeyCode.V }
local SkillConfig = {
    Master = false,
    Z = { Enabled = false, Mode = "Instant", Delay = 5 },
    X = { Enabled = false, Mode = "Instant", Delay = 5 },
    C = { Enabled = false, Mode = "Instant", Delay = 5 },
    V = { Enabled = false, Mode = "Instant", Delay = 5 },
}
SettingsStore.Restore(SkillConfig, SavedData.Skill)
for _, skillKey in ipairs(SKILL_ORDER) do
    local skillCfg = SkillConfig[skillKey]
    if skillCfg.Mode ~= "Hold" then skillCfg.Mode = "Instant" end
    skillCfg.Delay = math.clamp(tonumber(skillCfg.Delay) or 5, 1, 30)
end

local SkillMainSection = SkillTab:PageSection({
    Title = "⚡ Auto Skill",
    Subtitle = "Uses your skills automatically while the boss is nearby."
})
local SkillMainForm = SkillMainSection:Form()
local SkillMasterRow = SkillMainForm:Row()
SkillMasterRow:Left():TitleStack({
    Title = "Enable Auto Skill",
    Subtitle = "Master switch for the Z / X / C / V skills below."
})
SkillMasterRow:Right():Toggle({
    Value = SkillConfig.Master,
    ValueChanged = function(self, value) SkillConfig.Master = value and true or false end
})

local skillModeOptions = { "Instant", "Hold" }
for _, key in ipairs(SKILL_ORDER) do
    local cfg = SkillConfig[key]
    local section = SkillTab:PageSection({
        Title = "🔑 Skill " .. key,
        Subtitle = "Instant = tap the key again and again.  Hold = hold the key down."
    })
    local form = section:Form()

    local enableRow = form:Row()
    enableRow:Left():TitleStack({ Title = "Use Skill " .. key, Subtitle = "Press " .. key .. " automatically." })
    enableRow:Right():Toggle({
        Value = cfg.Enabled,
        ValueChanged = function(self, value) cfg.Enabled = value and true or false end
    })

    local modeRow = form:Row()
    modeRow:Left():TitleStack({ Title = "Mode", Subtitle = "Instant or Hold." })

    local delayRow = form:Row()
    delayRow:Left():TitleStack({
        Title = "Delay Skill",
        Subtitle = "Seconds to hold " .. key .. " down before releasing."
    })
    delayRow:Right():Stepper({
        Minimum = 1,
        Maximum = 30,
        Step = 1,
        Fielded = true,
        Value = cfg.Delay,
        ValueChanged = function(self, value)
            cfg.Delay = math.clamp(tonumber(value) or 5, 1, 30)
        end
    })
    pcall(function() delayRow.Visible = (cfg.Mode == "Hold") end) -- โชว์เฉพาะตอนเลือก Hold

    modeRow:Right():PullDownButton({
        Label = cfg.Mode,
        Options = skillModeOptions,
        Value = (cfg.Mode == "Hold") and 2 or 1,
        ValueChanged = function(self, index)
            cfg.Mode = skillModeOptions[index] or "Instant"
            self.Label = cfg.Mode
            pcall(function() delayRow.Visible = (cfg.Mode == "Hold") end)
        end
    })
end

-- ───────── ระบบหาบอส ─────────
-- เจอบอสจาก Workspace["AI/Player"].Boss ก่อน ถ้าไม่มีโฟลเดอร์นี้ในแมพบอส
-- จะสแกนหา Model ที่มี Humanoid (ไม่ใช่ผู้เล่น) แล้วเลือกตัวที่ MaxHealth สูงสุด
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
        return list -- มีโฟลเดอร์ Boss แล้วใช้เฉพาะในนั้น (ไม่ไปสแกนหา NPC อื่น)
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

local function PickBoss()
    local best, bestHp = nil, -1
    for _, m in ipairs(GetBossList()) do
        local hp = m:FindFirstChildOfClass("Humanoid").MaxHealth
        if hp > bestHp then best, bestHp = m, hp end
    end
    return best
end

local FarmTarget = nil
local AttacksSent = 0
local FarmDone = false        -- บอสตายแล้ว: หยุดบินจนกว่าจะเริ่มแมตช์ใหม่
local ResultScreenUp = false  -- หน้าจบแมตช์ (Retry) ขึ้นอยู่
local FLY_SPEED = 200
local ATTACK_RANGE = 35
-- คีย์ของ NormalAttack ในแมพบอส (จาก Remote Spy) / โลกปกติใช้ "\x13"
local ATTACK_KEY = "\x12"

local function GetMyRoot()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Health > 0 then return root, char end
    return nil
end

-- บินไปหาบอส
task.spawn(function()
    local lastPick = 0
    while Alive() do
        local dt = RunService.Heartbeat:Wait()
        if not FarmConfig.AutoFarm or os.clock() < FarmResumeAt then
            FarmTarget = nil
            FarmDone = false
            scanCache = {}
            continue
        end

        local root = GetMyRoot()
        if not root then
            FarmTarget = nil
            continue
        end

        -- หน้าจบแมตช์ขึ้นแล้ว: หยุดบินทันที
        if ResultScreenUp then
            FarmTarget = nil
            FarmDone = true
            continue
        end

        if FarmTarget then
            local th = FarmTarget:FindFirstChildOfClass("Humanoid")
            if not FarmTarget.Parent or not th or th.Health <= 0 then
                -- บอสตาย: หยุดนิ่งทันที ไม่ไปหาเป้าหมายอื่นนอกโฟลเดอร์ Boss
                FarmTarget = nil
                root.AssemblyLinearVelocity = Vector3.zero
                local nextBoss = PickBoss()
                if nextBoss then
                    FarmTarget = nextBoss
                else
                    FarmDone = true
                end
            end
        end
        if FarmDone then continue end
        if not FarmTarget and os.clock() - lastPick > 0.5 then
            lastPick = os.clock()
            FarmTarget = PickBoss()
        end

        local bossRoot = FarmTarget and FarmTarget:FindFirstChild("HumanoidRootPart")
        if bossRoot then
            local offsetY = (FarmConfig.Position == "Upper") and 6 or -6
            local goal = bossRoot.Position + Vector3.new(0, offsetY, 0)
            local diff = goal - root.Position
            local dist = diff.Magnitude
            root.AssemblyLinearVelocity = Vector3.zero
            if dist > 2 then
                local step = math.min(FLY_SPEED * dt, dist)
                root.CFrame = CFrame.new(root.Position + diff.Unit * step, bossRoot.Position)
            else
                root.CFrame = CFrame.new(goal, bossRoot.Position)
            end
        end
    end
end)

-- ตรวจหน้าจบแมตช์ (Retry) ทุก 0.5 วิ ตอนเปิดฟาร์มอยู่ / เริ่มแมตช์ใหม่แล้วรีเซ็ต FarmDone
task.spawn(function()
    while Alive() do
        task.wait(0.5)
        if FarmConfig.AutoFarm then
            local up = FindVisibleText("Retry") ~= nil
            if ResultScreenUp and not up then
                FarmDone = false -- หน้าจบหายไป = แมตช์ใหม่
            end
            ResultScreenUp = up
        else
            ResultScreenUp = false
            FarmDone = false
        end
    end
end)

-- No Clip ตอนฟาร์ม
task.spawn(function()
    while Alive() do
        RunService.Stepped:Wait()
        if FarmConfig.AutoFarm and FarmConfig.NoClip and FarmTarget then
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

-- มีบอสอยู่ในระยะโจมตีไหม
local function BossInRange(range)
    range = range or ATTACK_RANGE
    if os.clock() < FarmResumeAt then return false end
    local root = GetMyRoot()
    if not root then return false end
    for _, m in ipairs(GetBossList()) do
        local br = m:FindFirstChild("HumanoidRootPart")
        if br and (br.Position - root.Position).Magnitude <= range then
            return true
        end
    end
    return false
end

-- Fast Attack (ใช้ Remote เดียวกับ Hub หลัก: BridgeNet2.dataRemoteEvent)
task.spawn(function()
    local bridge = ReplicatedStorage:WaitForChild("BridgeNet2", 10)
    local attackEvent = bridge and bridge:WaitForChild("dataRemoteEvent", 10)
    while Alive() do
        task.wait(0.1)
        if attackEvent and FarmConfig.FastAttack and BossInRange() then
            local ok = pcall(function()
                attackEvent:FireServer({ { "NormalAttack", 1 }, ATTACK_KEY })
            end)
            if ok then AttacksSent += 1 end
        end
    end
end)

-- Auto Equip : กด E ชักอาวุธหลังเกิด (ทำเหมือน Hub หลัก: รอ 1 วิ แล้วกด 5 ครั้ง)
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
        if FarmConfig.AutoFarm and FarmConfig.AutoEquip and char and char ~= equippedFor and GetMyRoot() then
            equippedFor = char
            task.wait(1)
            for _ = 1, 5 do
                if not (Alive() and FarmConfig.AutoFarm and LocalPlayer.Character == char) then break end
                TapKey(Enum.KeyCode.E)
                task.wait(0.5)
            end
        end
    end
end)

-- Auto Skill Z X C V : Instant = แตะซ้ำ ๆ / Hold = กดค้างตามเวลา Delay Skill
local SKILL_RANGE = 80
local SkillState = {}
for _, key in ipairs(SKILL_ORDER) do
    SkillState[key] = { holding = false, untilT = 0, nextT = 0 }
end

local function SkillKey(key, down)
    pcall(function()
        VirtualInputManager:SendKeyEvent(down, SKILL_KEYCODES[key], false, game)
    end)
end

task.spawn(function()
    while Alive() do
        task.wait(0.05)
        local active = SkillConfig.Master and BossInRange(SKILL_RANGE)
        local now = os.clock()
        for _, key in ipairs(SKILL_ORDER) do
            local cfg, st = SkillConfig[key], SkillState[key]
            if active and cfg.Enabled then
                local isHold = (cfg.Mode == "Hold")
                if st.holding then
                    if now >= st.untilT then
                        SkillKey(key, false)
                        st.holding = false
                        st.nextT = now + (isHold and 0.2 or 0.25)
                    end
                elseif now >= st.nextT then
                    SkillKey(key, true)
                    st.holding = true
                    st.untilT = now + (isHold and cfg.Delay or 0.05)
                end
            elseif st.holding then
                SkillKey(key, false) -- ปล่อยปุ่มทันทีเมื่อปิด/บอสออกนอกระยะ
                st.holding = false
            end
        end
    end
    for _, key in ipairs(SKILL_ORDER) do
        if SkillState[key].holding then SkillKey(key, false) end
    end
end)

-- กรอบ RGB รอบตัวละครตอนฟาร์ม
task.spawn(function()
    local highlight = nil
    while Alive() do
        task.wait(0.05)
        local char = LocalPlayer.Character
        if FarmConfig.AutoFarm and FarmConfig.RGBOutline and char then
            if not highlight or highlight.Parent ~= char then
                if highlight then highlight:Destroy() end
                highlight = Instance.new("Highlight")
                highlight.Name = "SmoothHubRGBFarm"
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

-- อัปเดตสถานะ
task.spawn(function()
    while Alive() do
        task.wait(0.5)
        pcall(function()
            FarmAttackLabel.Text = tostring(AttacksSent)
            if not FarmConfig.AutoFarm then
                FarmTargetLabel.Text = "Idle"
                FarmHpLabel.Text = "-"
            elseif FarmTarget and FarmTarget.Parent then
                local th = FarmTarget:FindFirstChildOfClass("Humanoid")
                FarmTargetLabel.Text = "Farming: " .. FarmTarget.Name
                FarmHpLabel.Text = th and string.format("%d / %d", th.Health, th.MaxHealth) or "-"
            elseif FarmDone then
                FarmTargetLabel.Text = "Boss defeated - holding still"
                FarmHpLabel.Text = "0"
            else
                FarmTargetLabel.Text = "Waiting for boss..."
                FarmHpLabel.Text = "-"
            end
        end)
    end
end)

-- ในแมพบอสเข้าซ้ำ/ย้ายเซิร์ฟตรง ๆ ไม่ได้ (เป็นแมพเฉพาะ) เลยใช้โลกปกติเป็นปลายทาง
-- ถ้าอยากให้ใช้แมพปัจจุบัน เปลี่ยนเป็น game.PlaceId
local HOP_PLACE_ID = MAIN_PLACE_ID

local HubConfig = {
    InfiniteJump = false,
    AntiAFK = true,
    AutoRejoin = true,
    AntiAdmin = true,
    EnableFPSLock = false,
    FPSLimit = 144,
}
SettingsStore.Restore(HubConfig, SavedData.Hub)

local function HopServer()
    pcall(function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. HOP_PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100")
        local body = HttpService:JSONDecode(req)
        if body and body.data then
            for _, sv in ipairs(body.data) do
                if type(sv) == "table" and sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    table.insert(servers, sv.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(HOP_PLACE_ID, servers[math.random(1, #servers)], LocalPlayer)
        else
            TeleportService:Teleport(HOP_PLACE_ID, LocalPlayer)
        end
    end)
end

---------------------------------------------------------
-- หมวด Settings : Advanced / Server / Windows
---------------------------------------------------------
local SettingsCategory = Cascade.Components.Section(Window, {
    Title = "Settings\u{200B}", -- อักขระไร้เสียงต่อท้าย กัน Roblox แปลเป็น "การตั้งค่า"
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

local function AddToggle(form, title, subtitle, key, onChange)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    row:Right():Toggle({
        Value = HubConfig[key],
        ValueChanged = function(self, value)
            HubConfig[key] = value and true or false
            if onChange then onChange(value) end
        end
    })
end

AddToggle(AdvForm, "Infinite Jump", "Allow your character to jump infinitely in the air.", "InfiniteJump")
AddToggle(AdvForm, "Anti-AFK", "Prevent being kicked out of the game due to inactivity.", "AntiAFK")
AddToggle(AdvForm, "Auto Rejoin", "Automatically rejoin the game if disconnected or kicked.", "AutoRejoin")
AddToggle(AdvForm, "Anti Admin", "Automatically server hop if an admin joins the game.", "AntiAdmin")

local FpsSection = AdvancedTab:PageSection({
    Title = "🖥️ FPS",
    Subtitle = "Limit the frame rate of the game."
})
local FpsForm = FpsSection:Form()

AddToggle(FpsForm, "Enable FPS Lock", "Toggle frame rate limiting on or off.", "EnableFPSLock", function(value)
    if setfpscap then
        setfpscap(value and HubConfig.FPSLimit or 9999)
    end
end)

local FpsMenuRow = FpsForm:Row()
FpsMenuRow:Left():TitleStack({
    Title = "FPS Limit Preset",
    Subtitle = "Choose target frame rate limit."
})
local fpsOptions = { "15 FPS", "30 FPS", "60 FPS", "120 FPS", "144 FPS", "240 FPS", "500 FPS", "1000 FPS", "9999 (Unlimited)" }
local fpsValues = { 15, 30, 60, 120, 144, 240, 500, 1000, 9999 }
local fpsDefaultIndex = table.find(fpsValues, HubConfig.FPSLimit) or 5

local FpsBtn = FpsMenuRow:Right():PullDownButton({
    Label = fpsOptions[fpsDefaultIndex],
    Options = fpsOptions,
    Value = fpsDefaultIndex,
    ValueChanged = function(self, index)
        local target = fpsValues[index]
        HubConfig.FPSLimit = target
        self.Label = fpsOptions[index]
        if HubConfig.EnableFPSLock and setfpscap then
            setfpscap(target)
        end
    end
})
StyleDropdown(FpsBtn)

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

local function AddAction(form, title, subtitle, fn)
    local row = form:Row()
    row:Left():TitleStack({ Title = title, Subtitle = subtitle })
    local run
    local btn = row:Right():Button({
        Label = "Execute",
        Callback = function() if run then run() end end
    })
    run = BindButton(btn, fn)
end

AddAction(ServerActionForm, "Copy JobId", "Copy current JobId to clipboard for friends to join.", function()
    CopyText(tostring(game.JobId))
end)

AddAction(ServerActionForm, "Rejoin Server", "Go back to the main world (this map can't be rejoined directly).", function()
    pcall(function()
        if #Players:GetPlayers() <= 1 then
            LocalPlayer:Kick("\nRejoining...")
            task.wait()
        end
        TeleportService:Teleport(HOP_PLACE_ID, LocalPlayer)
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
local CurrentThemeName = table.find(AccentOrder, SavedUi.Theme) and SavedUi.Theme or DEFAULT_ACCENT
local CurrentAccentName = (SavedUi.Accent == FOLLOW_THEME or table.find(AccentOrder, SavedUi.Accent)) and SavedUi.Accent or FOLLOW_THEME
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

        for _, tab in ipairs({ StatusTab, ReplayTab, FarmingTab, SkillTab, AdvancedTab, ServerTab, SettingsTab }) do
            if tab.Selected then
                tab.Selected = false
                task.wait()
                tab.Selected = true
                break
            end
        end
    end)
end

local ThemeColorBtn = ColorRow:Right():PullDownButton({
    Label = CurrentThemeName,
    Options = colorOptions,
    Value = table.find(colorOptions, CurrentThemeName) or 1,
    ValueChanged = function(self, index)
        if colorOptions[index] and colorMaps[index] then
            CurrentThemeName = colorOptions[index]
            self.Label = colorOptions[index]
            ApplyAppearance()
        end
    end
})
StyleDropdown(ThemeColorBtn)

local AccentRow = ColorForm:Row()
AccentRow:Left():TitleStack({
    Title = "Accent Color",
    Subtitle = "Only changes icons, switches and buttons. The background stays the same."
})
local accentOptions = { FOLLOW_THEME }
for _, accentName in ipairs(AccentOrder) do
    table.insert(accentOptions, accentName)
end
local AccentColorBtn = AccentRow:Right():PullDownButton({
    Label = CurrentAccentName,
    Options = accentOptions,
    Value = table.find(accentOptions, CurrentAccentName) or 1,
    ValueChanged = function(self, index)
        if accentOptions[index] then
            CurrentAccentName = accentOptions[index]
            self.Label = accentOptions[index]
            ApplyAppearance()
        end
    end
})
StyleDropdown(AccentColorBtn)

-- ถ้าเคยตั้ง Accent Color ไว้ ให้ใช้ทันที (สี Theme ถูกใช้ตั้งแต่ตอนสร้างหน้าต่างแล้ว)
if CurrentAccentName ~= FOLLOW_THEME then
    ApplyAppearance()
end

local BlurSection = SettingsTab:PageSection({
    Title = "✨ Windows Effects",
    Subtitle = "Manage special visual styles for your script window."
})
local BlurForm = BlurSection:Form()

-- ใช้ค่า Blur / Shadow ที่จำไว้ (ต้องตั้งก่อนสร้างสวิตช์ เพราะสวิตช์อ่านค่าจาก Window)
if type(SavedUi.UIBlur) == "boolean" then Window.UIBlur = SavedUi.UIBlur end
if type(SavedUi.Dropshadow) == "boolean" then Window.Dropshadow = SavedUi.Dropshadow end

local BlurRow = BlurForm:Row()
BlurRow:Left():TitleStack({
    Title = "Blur Effect",
    Subtitle = "Enable frosted glass blur effect behind the window."
})
BlurRow:Right():Toggle({
    Value = Window.UIBlur,
    ValueChanged = function(self, value) Window.UIBlur = value end
})

local ShadowRow = BlurForm:Row()
ShadowRow:Left():TitleStack({
    Title = "Shadows Effect",
    Subtitle = "Enable smooth dropshadow around the script window."
})
ShadowRow:Right():Toggle({
    Value = Window.Dropshadow,
    ValueChanged = function(self, value) Window.Dropshadow = value end
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
    ValueChanged = function(self, newKey) currentKeybind = newKey end,
    BindPressed = function(self, key, inputComplete, gameProcessedEvent)
        if inputComplete and not gameProcessedEvent then
            Window.Minimized = not Window.Minimized
        end
    end
})

---------------------------------------------------------
-- 💾 เริ่มบันทึกอัตโนมัติ: ค่าเปลี่ยนเมื่อไหร่ จะเซฟลงไฟล์ของไอดีนี้เอง
---------------------------------------------------------
SettingsStore.StartAutoSave("BossMap", function()
    return {
        Replay = Config,
        Farm = FarmConfig,
        Skill = SkillConfig,
        Hub = HubConfig,
        UI = {
            Theme = CurrentThemeName,
            Accent = CurrentAccentName,
            UIBlur = Window.UIBlur,
            Dropshadow = Window.Dropshadow,
            Keybind = currentKeybind and currentKeybind.Name or "LeftAlt",
        },
    }
end)

---------------------------------------------------------
-- ระบบเบื้องหลังของหมวด Settings
---------------------------------------------------------
-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Alive() and HubConfig.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Alive() and HubConfig.AntiAFK then
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

-- Auto Rejoin (ตอนเด้งออก/โดนเตะ)
pcall(function()
    local errorPrompt = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui", true)
    if errorPrompt then
        errorPrompt.ChildAdded:Connect(function(child)
            if child.Name == "promptOverlay" then
                task.wait(1)
                if Alive() and HubConfig.AutoRejoin then
                    TeleportService:Teleport(HOP_PLACE_ID, LocalPlayer)
                end
            end
        end)
    end
end)

-- Anti Admin
local function CheckAdmin(player)
    if player == LocalPlayer or not HubConfig.AntiAdmin then return end
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
        if HubConfig.AntiAdmin then
            for _, player in ipairs(Players:GetPlayers()) do
                CheckAdmin(player)
            end
        end
    end
end)

-- FPS Lock (ย้ำค่าเรื่อย ๆ เผื่อเกมรีเซ็ต)
task.spawn(function()
    while Alive() do
        if HubConfig.EnableFPSLock and setfpscap then
            pcall(setfpscap, HubConfig.FPSLimit)
        end
        task.wait(1)
    end
end)

local function SetStatus(text, hex)
    pcall(function() StatusLabel.Text = hex and Colorize(text, hex) or text end)
end

local function Notify(title, subtitle)
    pcall(function()
        App:Notification({ Title = title, Subtitle = subtitle, Duration = 6 })
    end)
end

local function TurnOff()
    Config.AutoReplay = false
    pcall(function() EnableToggle.Value = false end)
    SaveState()
end

---------------------------------------------------------
-- ลูปหลัก: Auto Replay
---------------------------------------------------------
local State = "Waiting" -- Waiting | Retrying | Done
local retryAttempts = 0

task.spawn(function()
    local handled = false  -- หน้าจอ Retry ขึ้นอยู่และถูกจัดการแล้ว
    local lastFire = 0

    while Alive() do
        task.wait(0.5)
        if not Config.AutoReplay then
            handled = false
            State = "Waiting"
            retryAttempts = 0
            continue
        end

        local retryBtn = FindVisibleText("Retry")
        if not retryBtn then
            -- แมตช์ยังเล่นอยู่ (หรือกำลังโหลดแมตช์ใหม่)
            if handled and State == "Retrying" then
                FarmResumeAt = os.clock() + REPLAY_WAIT -- แมตช์ใหม่เริ่มแล้ว รอบอสเกิด
            end
            handled = false
            State = "Waiting"
            retryAttempts = 0
            continue
        end

        if not handled then
            -- แมตช์เพิ่งจบ: นับ 1 แมตช์
            handled = true
            Config.Count += 1
            SaveState()

            local more = (Config.Mode == "Infinity") or (Config.Count < Config.Target)
            if more then
                State = "Retrying"
                SetStatus("Match ended, retrying...", "#64C8FF")
                task.wait(Config.RetryDelay)
                if Alive() and Config.AutoReplay then
                    retryAttempts = 1
                    local btn = FindVisibleText("Retry")
                    if btn then ClickGui(btn, retryAttempts) end
                    lastFire = os.clock()
                    FarmResumeAt = os.clock() + REPLAY_WAIT
                end
            else
                State = "Done"
                SetStatus("Finished " .. Config.Count .. " matches", "#5CE16A")
                Notify("Auto Replay", "Finished " .. Config.Count .. " matches. Returning to lobby.")
                Config.Count = 0
                TurnOff()
            end
        elseif State == "Retrying" and os.clock() - lastFire > 4 then
            -- กด Retry แล้วแต่หน้าจอยังอยู่ ลองยิงซ้ำ (สูงสุด 5 ครั้ง)
            if retryAttempts < 6 then
                retryAttempts += 1
                ClickGui(retryBtn, retryAttempts)
                lastFire = os.clock()
            else
                SetStatus("Retry not responding", "#FFB432")
            end
        end
    end
end)

---------------------------------------------------------
-- ลูป Auto Start (ปุ่ม Start สีเขียว)
---------------------------------------------------------
task.spawn(function()
    local lastStart = 0
    local startAttempts = 0
    while Alive() do
        task.wait(0.5)
        if Config.AutoStart then
            local startBtn = FindVisibleText("Start")
            if startBtn then
                if os.clock() - lastStart > 4 and startAttempts < 6 then
                    startAttempts += 1
                    ClickGui(startBtn, startAttempts)
                    lastStart = os.clock()
                end
            else
                startAttempts = 0
            end
        end
    end
end)

---------------------------------------------------------
-- อัปเดตข้อความสถานะ
---------------------------------------------------------
task.spawn(function()
    while Alive() do
        task.wait(0.4)
        pcall(function()
            if Config.Mode == "Infinity" then
                CountLabel.Text = tostring(Config.Count) .. "  (Infinity)"
            else
                CountLabel.Text = Config.Count .. " / " .. Config.Target
            end

            if not Config.AutoReplay then
                if State ~= "Done" then SetStatus("Idle", "#96A5AA") end
            elseif State == "Waiting" then
                if Config.Mode == "Infinity" then
                    SetStatus("Infinity - Match " .. (Config.Count + 1), "#5CE16A")
                else
                    SetStatus("Match " .. math.min(Config.Count + 1, Config.Target) .. "/" .. Config.Target .. " in progress", "#5CE16A")
                end
            end
        end)
    end
end)

---------------------------------------------------------
-- อัปเดตหน้า Dashboard > Status (รวมสถานะทุกอย่าง)
---------------------------------------------------------
do
    local sessionStart = os.clock()

    local frames, fps, lastFpsTick = 0, 0, os.clock()
    local fpsConn
    fpsConn = RunService.RenderStepped:Connect(function()
        if not Alive() then fpsConn:Disconnect() return end
        frames += 1
        local now = os.clock()
        if now - lastFpsTick >= 1 then
            fps = math.floor(frames / (now - lastFpsTick) + 0.5)
            frames = 0
            lastFpsTick = now
        end
    end)

    local function FormatTime(seconds)
        seconds = math.floor(seconds)
        return string.format("%02d:%02d:%02d", seconds // 3600, (seconds % 3600) // 60, seconds % 60)
    end

    local function Set(key, text)
        local label = Dash[key]
        if label then label.Text = text end
    end

    task.spawn(function()
        while Alive() do
            task.wait(0.5)
            pcall(function()
                -- Auto Replay
                Set("RState", OnOff(Config.AutoReplay))
                Set("RMode", Config.Mode == "Infinity" and "Infinity" or ("X Match (" .. Config.Target .. ")"))
                Set("RProgress", Config.Mode == "Infinity" and (Config.Count .. "  (Infinity)") or (Config.Count .. " / " .. Config.Target))
                if not Config.AutoReplay then
                    Set("RStatus", Paint("Idle", "#96A5AA"))
                elseif State == "Retrying" then
                    Set("RStatus", Paint("Match ended, retrying...", "#64C8FF"))
                else
                    Set("RStatus", Paint("Match " .. (Config.Count + 1) .. " in progress", "#5CE16A"))
                end
                Set("RStart", OnOff(Config.AutoStart))

                -- Farming
                Set("FState", OnOff(FarmConfig.AutoFarm))
                local th = FarmTarget and FarmTarget.Parent and FarmTarget:FindFirstChildOfClass("Humanoid")
                if not FarmConfig.AutoFarm then
                    Set("FStatus", Paint("Idle", "#96A5AA"))
                    Set("FHp", "-")
                elseif os.clock() < FarmResumeAt then
                    Set("FStatus", Paint("Waiting for boss to spawn...", "#64C8FF"))
                    Set("FHp", "-")
                elseif FarmTarget and th then
                    Set("FStatus", Paint("Farming: " .. FarmTarget.Name, "#5CE16A"))
                    Set("FHp", string.format("%d / %d", th.Health, th.MaxHealth))
                elseif FarmDone then
                    Set("FStatus", Paint("Boss defeated", "#FFB432"))
                    Set("FHp", "0")
                else
                    Set("FStatus", Paint("Waiting for boss...", "#64C8FF"))
                    Set("FHp", "-")
                end
                Set("FPos", FarmConfig.Position)
                Set("FAttack", FarmConfig.FastAttack and Paint("On\u{200B} (" .. AttacksSent .. " sent)", "#5CE16A") or OnOff(false))
                Set("FEquip", OnOff(FarmConfig.AutoEquip))
                Set("FNoClip", OnOff(FarmConfig.NoClip))
                Set("FRgb", OnOff(FarmConfig.RGBOutline))

                -- Auto Skill
                Set("SState", OnOff(SkillConfig.Master))
                local active = {}
                for _, key in ipairs(SKILL_ORDER) do
                    local cfg = SkillConfig[key]
                    if cfg.Enabled then
                        table.insert(active, key .. " " .. (cfg.Mode == "Hold" and ("Hold " .. cfg.Delay .. "s") or "Instant"))
                    end
                end
                Set("SActive", #active > 0 and table.concat(active, "  |  ") or "None")

                -- Advanced
                Set("AAfk", OnOff(HubConfig.AntiAFK))
                Set("ARejoin", OnOff(HubConfig.AutoRejoin))
                Set("AAdmin", OnOff(HubConfig.AntiAdmin))
                Set("AJump", OnOff(HubConfig.InfiniteJump))
                Set("AFps", HubConfig.EnableFPSLock and Paint("On\u{200B} (" .. HubConfig.FPSLimit .. ")", "#5CE16A") or OnOff(false))

                -- Server
                Set("VMap", game.PlaceId == BOSS_PLACE_ID and "Boss Map" or tostring(game.PlaceId))
                Set("VJob", tostring(game.JobId):sub(1, 8))
                Set("VPlayers", string.format("%d / %d", #Players:GetPlayers(), Players.MaxPlayers))
                Set("VPing", string.format("%d ms", math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)))
                Set("VFps", tostring(fps))
                Set("VTime", FormatTime(os.clock() - sessionStart))
            end)
        end
    end)
end

print("SmoothHub Boss Replay loaded")
