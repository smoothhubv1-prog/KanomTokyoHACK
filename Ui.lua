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

local _G = _G or {}
_G.SmoothHubConfig = {
    AutoFarmLevel = false,
    FastAttack = true,
    -- Auto Upgrade Stats
    StatSelection = {
        Damage = false,
        Durability = false,
        Stamina = false,
        Speed = false
    },
    StatAmount = 1,
    AutoUpgradeStats = false,
    StatLimits = {
        Damage = 0,
        Durability = 0,
        Stamina = 0,
        Speed = 0
    },
    -- ที่เหลือเหมือนเดิม
    FarmingDirection = "Upper",
    InfiniteJump = false,
    AntiAFK = true,
    AutoRejoin = true,
    AntiAdmin = true,
    EnableFPSLock = false,
    FPSLimit = 144,
    -- Monster tab
    EnableFarmMonster = false,
    MonsterSelection = {},
    MonsterFarmPosition = "Down",
    -- Boss tab
    EnableFarmBoss = false,
    BossSelection = {},
    BossFarmPosition = "Down",
    -- World Boss tab
    AutoStartWorldBoss = false,
    WorldBossQueue = {},     -- ลำดับ index ของบอสตามที่ติ๊กก่อน-หลัง
    WorldBossJoinDelay = 10  -- วินาที
}
_G.SmoothHubStatus = {
    FarmStatusLabel = nil,
    StatsStatusLabel = nil,
    StatsStatusLabelDashboard = nil,
    MonsterStatusLabel = nil,
    BossStatusLabel = nil
}

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
local SavedData = SettingsStore.Load("World")
local SavedUi = type(SavedData.UI) == "table" and SavedData.UI or {}
SettingsStore.Restore(_G.SmoothHubConfig, SavedData.Config)

-- ข้อความ "Off" ที่ Roblox จะไม่แปลเป็นไทย (มีอักขระไร้เสียง/มองไม่เห็นต่อท้าย)
-- เพราะ Roblox แปลข้อความ UI ที่ตรงกับคำในตารางแปลของมันเป๊ะ ๆ เช่น "Off" -> "ปิด"
local OFF_TEXT = "Off\u{200B}"

local App = Cascade.New({
    Name = "Smooth Hub",
    WindowPill = true,
    Theme = Cascade.Themes.Dark,
    -- สีเริ่มต้น = สีที่จำไว้ (ถ้าไม่เคยตั้ง ใช้ Dark)
    Accent = (table.find(AccentOrder, SavedUi.Theme) and Cascade.Accents[SavedUi.Theme]) or Cascade.Accents.Dark
})

local Window = App:Window({
    Title = "Smooth Hub",
    Subtitle = "Game : Kanom Tokyo",
    Resizable = true,
    Draggable = true,
    UIBlur = false
})

---------------------------------------------------------
-- 🌐 บังคับให้ UI เป็นภาษาอังกฤษทั้งหมด
-- Roblox แปลข้อความ UI อัตโนมัติตามภาษาของเครื่อง (เช่น Settings -> การตั้งค่า,
-- Off -> ปิด, Search -> ค้นหา) แก้โดยปิด AutoLocalize ของทุกองค์ประกอบใน UI
---------------------------------------------------------
do
    local function FindCascadeGui()
        local roots = {}
        pcall(function() if gethui then table.insert(roots, gethui()) end end)
        pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
        pcall(function() table.insert(roots, game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")) end)

        for _, root in ipairs(roots) do
            for _, gui in ipairs(root:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    local ok, found = pcall(function()
                        for _, d in ipairs(gui:GetDescendants()) do
                            if d:IsA("TextLabel") and d.Text == "Smooth Hub" then
                                return true
                            end
                        end
                        return false
                    end)
                    if ok and found then return gui end
                end
            end
        end
    end

    -- ปิด AutoLocalize แล้วเซ็ตข้อความซ้ำ 1 ครั้ง เพื่อให้ Roblox คืนข้อความต้นฉบับ (ภาษาอังกฤษ)
    -- (ไม่แตะ Text ของช่องกรอก เพื่อไม่ให้ไปกระตุ้น ValueChanged)
    -- คำที่ Roblox มีในตารางแปลของมัน (ตรงเป๊ะ ๆ ถึงจะโดนแปล) -> ต่อท้ายด้วยอักขระไร้เสียง
    local TRANSLATABLE = {
        ["settings"] = true, ["search"] = true, ["off"] = true, ["on"] = true,
        ["close"] = true, ["cancel"] = true, ["reset"] = true, ["back"] = true, ["done"] = true,
    }
    local function Mask(obj, prop)
        local value = obj[prop]
        if type(value) == "string" and TRANSLATABLE[value:lower()] then
            obj[prop] = value .. "\u{200B}"
            return true
        end
        return false
    end

    local function Delocalize(obj)
        pcall(function()
            if not obj:IsA("GuiBase2d") then return end
            obj.AutoLocalize = false

            if obj:IsA("TextBox") then
                if Mask(obj, "PlaceholderText") then return end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if Mask(obj, "Text") then return end
            end

            if obj:IsA("TextBox") then
                local placeholder = obj.PlaceholderText
                if placeholder ~= "" then
                    obj.PlaceholderText = placeholder .. "\u{200B}"
                    obj.PlaceholderText = placeholder
                end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local text = obj.Text
                if text ~= "" then
                    obj.Text = text .. "\u{200B}"
                    obj.Text = text
                end
            end
        end)
    end

    task.spawn(function()
        local gui
        for _ = 1, 20 do
            gui = FindCascadeGui()
            if gui then break end
            task.wait(0.25)
        end
        if not gui then return end

        Delocalize(gui)
        for _, d in ipairs(gui:GetDescendants()) do
            Delocalize(d)
        end
        gui.DescendantAdded:Connect(function(d)
            task.defer(Delocalize, d)
        end)

        -- สแกนซ้ำอีกรอบหลัง UI สร้างเสร็จ (กันหลุด)
        task.delay(2, function()
            for _, d in ipairs(gui:GetDescendants()) do
                Delocalize(d)
            end
        end)
    end)
end

-- 📋 Boss Status: เช็กบอสทั้งหมดในเกมว่าตอนนี้เกิดอยู่ไหม (บอสทุกตัวอยู่ใน Workspace["AI/Player"].Boss)
-- ใช้ร่วมกันทั้งแท็บ Boss และแท็บ Status (เรียก AddBossStatusSection(แท็บ) เพื่อสร้างตารางนี้ในแท็บนั้น)

-- Type = "Timed"  -> เกิดเองตามเวลา
-- Type = "Summon" -> ต้องเอาของไปเสกถึงจะเกิด
local BossList = {
    { Name = "Kaneki",     Type = "Timed" },
    { Name = "Jason",      Type = "Timed" },
    { Name = "Ihei Hairu", Type = "Timed" },
    { Name = "Noro",       Type = "Summon" },
}

-- หาโมเดลบอสในโฟลเดอร์ Boss (ชื่อตรงกัน หรือมีชื่อบอสอยู่ในชื่อโมเดล)
local function FindBossModel(bossName)
    local aiFolder = workspace:FindFirstChild("AI/Player")
    local bossFolder = aiFolder and aiFolder:FindFirstChild("Boss")
    if not bossFolder then return nil end

    local exact = bossFolder:FindFirstChild(bossName)
    if exact then return exact end

    local lowerName = bossName:lower()
    for _, child in ipairs(bossFolder:GetChildren()) do
        if child.Name:lower():find(lowerName, 1, true) then
            return child
        end
    end
    return nil
end

-- 🟢🔴 สีสถานะบอส (เขียว = เกิดแล้ว, แดง = ยังไม่เกิด)
local BOSS_GREEN = "#28DC64"
local BOSS_RED = "#EB4646"

-- Label ของ Cascade ผูกสีตัวอักษรกับ Theme (เปลี่ยนธีมแล้วสีจะถูกทับ)
-- เลยใช้ RichText ใส่สีในตัวข้อความแทน สีจึงไม่หายตอนเปลี่ยนธีม
local function Colorize(text, hex)
    return string.format('<font color="%s">%s</font>', hex, text)
end

local function AddBossStatusSection(tab)
    local BossStatusSection = tab:PageSection({
        Title = "📋 Boss Status",
        Subtitle = "Shows which bosses are currently alive in this server.",
    })
    local BossStatusForm = BossStatusSection:Form()

    local BossRows = {}
    for _, boss in ipairs(BossList) do
        local row = BossStatusForm:Row()
        row:Left():TitleStack({
            Title = boss.Name,
            Subtitle = boss.Type == "Summon"
                and "Summon boss - spawns only when you use an item to summon it."
                or "Spawns on its own timer."
        })
        BossRows[#BossRows + 1] = {
            Boss = boss,
            Label = row:Right():Label({
                Text = Colorize(boss.Type == "Summon" and "🔴 Not summoned" or "🔴 Not spawned", BOSS_RED)
            })
        }
    end

    local BossAliveRow = BossStatusForm:Row()
    BossAliveRow:Left():TitleStack({
        Title = "Bosses Alive",
        Subtitle = "How many of the " .. #BossList .. " bosses are alive right now."
    })
    local BossAliveLabel = BossAliveRow:Right():Label({
        Text = Colorize("0 / " .. #BossList, BOSS_RED)
    })

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local aliveCount = 0

                for _, entry in ipairs(BossRows) do
                    local model = FindBossModel(entry.Boss.Name)
                    local humanoid = model and model:FindFirstChildOfClass("Humanoid")

                    if model and humanoid and humanoid.Health > 0 then
                        aliveCount += 1
                        local percent = humanoid.MaxHealth > 0
                            and math.floor(humanoid.Health / humanoid.MaxHealth * 100 + 0.5)
                            or 100
                        entry.Label.Text = Colorize("🟢 Alive - HP " .. percent .. "%", BOSS_GREEN)
                    else
                        entry.Label.Text = Colorize(entry.Boss.Type == "Summon" and "🔴 Not summoned" or "🔴 Not spawned", BOSS_RED)
                    end
                end

                BossAliveLabel.Text = Colorize(aliveCount .. " / " .. #BossList, aliveCount > 0 and BOSS_GREEN or BOSS_RED)
            end)
        end
    end)
end

---------------------------------------------------------
-- หมวด Dashboard (อยู่บนสุด) + แท็บ Status
-- ดูสถานะเซิร์ฟเวอร์และสถานะฟีเจอร์ทั้งหมดได้ในหน้าเดียว
---------------------------------------------------------
local DashboardSection = Cascade.Components.Section(Window, {
    Title = "Dashboard",
    Disclosure = false
})

local StatusTab = DashboardSection:Tab({
    Title = "Status",
    Icon = Cascade.Symbols["chartBarFill"] or Cascade.Symbols["leafFill"]
})

do
    local PlayersService = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local startTime = os.clock()

    local function AddStatusRow(form, title, subtitle, initialText)
        local row = form:Row()
        row:Left():TitleStack({
            Title = title,
            Subtitle = subtitle
        })
        return row:Right():Label({
            Text = initialText
        })
    end

    -- 🖥️ Server
    local StatusServerSection = StatusTab:PageSection({
        Title = "🖥️ Server",
        Subtitle = "Live information about the server you are in.",
    })
    local ServerForm = StatusServerSection:Form()

    local PlayersLabel = AddStatusRow(ServerForm, "Players", "Players in this server / max players.", "-")
    local PingLabel = AddStatusRow(ServerForm, "Ping", "Your connection delay to the server.", "-")
    local FpsLabel = AddStatusRow(ServerForm, "FPS", "Frames per second on your screen.", "-")
    local TimeLabel = AddStatusRow(ServerForm, "Session Time", "How long this script has been running.", "-")

    -- 📊 Character Stats (ตัวเดียวกับ Stats Status ในแท็บ Main Farm)
    local StatusStatsSection = StatusTab:PageSection({
        Title = "📊 Character Stats",
        Subtitle = "Real-time character stats & level tracking.",
    })
    local StatusStatsForm = StatusStatsSection:Form()
    _G.SmoothHubStatus.StatsStatusLabelDashboard = AddStatusRow(
        StatusStatsForm,
        "Stats Status",
        "Level and stat points of your character.",
        "Lvl: 0 | Dmg: 0 | Dur: 0 | Sta: 0 | Spd: 0"
    )

    -- ⚙️ Features
    local StatusFeatureSection = StatusTab:PageSection({
        Title = "⚙️ Features",
        Subtitle = "Which features are running right now.",
    })
    local FeatureForm = StatusFeatureSection:Form()

    local featureRows = {
        { Label = AddStatusRow(FeatureForm, "Auto Farm Level", "Main Farm tab.", OFF_TEXT), Key = "AutoFarmLevel" },
        { Label = AddStatusRow(FeatureForm, "Fast Attack", "Main Farm tab.", OFF_TEXT), Key = "FastAttack" },
        { Label = AddStatusRow(FeatureForm, "Auto Upgrade Stats", "Main Farm tab.", OFF_TEXT), Key = "AutoUpgradeStats" },
        { Label = AddStatusRow(FeatureForm, "Monster Farm", "Monster tab.", OFF_TEXT), Key = "EnableFarmMonster" },
        { Label = AddStatusRow(FeatureForm, "Boss", "Boss tab.", OFF_TEXT), Key = "EnableFarmBoss" },
    }

    -- 📋 Boss Status
    AddBossStatusSection(StatusTab)

    -- นับ FPS
    local frames = 0
    local fps = 0
    local lastFpsTick = os.clock()
    RunService.RenderStepped:Connect(function()
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

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                PlayersLabel.Text = string.format("%d / %d", #PlayersService:GetPlayers(), PlayersService.MaxPlayers)
                PingLabel.Text = string.format("%d ms", math.floor(PlayersService.LocalPlayer:GetNetworkPing() * 1000 + 0.5))
                FpsLabel.Text = tostring(fps)
                TimeLabel.Text = FormatTime(os.clock() - startTime)

                for _, feature in ipairs(featureRows) do
                    feature.Label.Text = _G.SmoothHubConfig[feature.Key] and "Running" or OFF_TEXT
                end
            end)
        end
    end)
end

---------------------------------------------------------
-- แท็บ In-Game (เมนูฟาร์มหลัก)
---------------------------------------------------------
local CategorySection = Cascade.Components.Section(Window, {
    Title = "In-Game",
    Disclosure = false
})

local MainFarmTab = CategorySection:Tab({
    Title = "Main Farm",
    Icon = Cascade.Symbols["leafFill"], 
    Selected = true
})

local FarmSection = MainFarmTab:PageSection({
    Title = "📈 Auto Farm Level",
    Subtitle = "Manage your automatic farming settings here",
})

local FarmForm = FarmSection:Form()

local FarmRow = FarmForm:Row()
FarmRow:Left():TitleStack({
    Title = "Enable Farm",
    Subtitle = "Automatically takes quests, teleports, and attacks monsters for you."
})
FarmRow:Right():Toggle({
    Value = _G.SmoothHubConfig.AutoFarmLevel,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.AutoFarmLevel = value
        
        if value then
            if _G.SmoothHubStatus.FarmStatusLabel then
                _G.SmoothHubStatus.FarmStatusLabel.Text = "Running"
            end
        else
            if _G.SmoothHubStatus.FarmStatusLabel then
               _G.SmoothHubStatus.FarmStatusLabel.Text = "off"
            end
        end
    end
})

local StatusRow = FarmForm:Row()
StatusRow:Left():Label({
    Text = "Status"
})
_G.SmoothHubStatus.FarmStatusLabel = StatusRow:Right():Label({
    Text = "off"
})

local PositionRow = FarmForm:Row()
PositionRow:Left():TitleStack({
    Title = "Position",
    Subtitle = "Choose farming direction"
})

local directionOptions = {"Upper", "Down"}

local PositionBtn = PositionRow:Right():PullDownButton({
    Label = directionOptions[SettingsStore.IndexOf(directionOptions, _G.SmoothHubConfig.FarmingDirection, 1)],
    Options = directionOptions,
    Value = SettingsStore.IndexOf(directionOptions, _G.SmoothHubConfig.FarmingDirection, 1),
    ValueChanged = function(self, index)
        local selectedDirection = directionOptions[index]
        _G.SmoothHubConfig.FarmingDirection = selectedDirection
        self.Label = selectedDirection
    end
})

pcall(function()
    local indicator = PositionBtn.__instance:FindFirstChild("PullDownIndicator")
    if indicator then
        local img = indicator:FindFirstChild("Indicators")
        if img then
            img.Image = "rbxassetid://115187614425058"
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Size = UDim2.fromOffset(18, 18)
            img.Position = UDim2.fromScale(0.5, 0.5)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end
end)

-- ส่วนของ Fast Attack
local FastAttackSection = MainFarmTab:PageSection({
    Title = "⚡ Fast Attack",
    Subtitle = "Speed up your attack speed and combat performance.",
})

local FastAttackForm = FastAttackSection:Form()

local FastAttackRow = FastAttackForm:Row()
FastAttackRow:Left():TitleStack({
    Title = "Enable",
    Subtitle = "Use Fast Attack. 0.01/s"
})
FastAttackRow:Right():Toggle({
    Value = _G.SmoothHubConfig.FastAttack,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.FastAttack = value
    end
})

-- ส่วนของ Auto Upgrade Stats
local StatsSection = MainFarmTab:PageSection({
    Title = "💪 Auto Upgrade Stats",
    Subtitle = "Automatically invests your available stat points into your chosen category.",
})

local StatsForm = StatsSection:Form()

-- Stat Selection
local StatSelectRow = StatsForm:Row()
StatSelectRow:Left():TitleStack({
    Title = "Stat Selection",
    Subtitle = "Choose which stats to upgrade automatically"
})

local statOptions = {"Damage", "Durability", "Stamina", "Speed"}

StatSelectRow:Right():PopUpButton({
    Options = statOptions,
    Maximum = #statOptions, -- เลือกได้สูงสุดเท่าจำนวนตัวเลือก (ติ๊กได้หลายอัน)
    Value = SettingsStore.IndexesFromMap(statOptions, _G.SmoothHubConfig.StatSelection),
    ValueChanged = function(self, value)
        local picked = {}
        for _, index in ipairs(value or {}) do
            picked[statOptions[index]] = true
        end
        for _, name in ipairs(statOptions) do
            _G.SmoothHubConfig.StatSelection[name] = picked[name] == true
        end
    end
})

-- แต่งช่องกรอกให้เหมือนในรูป (ตัวเลขอยู่กลาง พื้นเข้ม ไม่มีเส้นขอบ)
local function StyleStatField(field)
    pcall(function()
        local s = field.Structures
        s.Body.Size = UDim2.fromOffset(150, 32)
        s.Body.BackgroundTransparency = 0
        s.Body.BackgroundColor3 = Color3.fromRGB(33, 37, 43) -- สีสำรอง
        s.Stroke.Enabled = false
        s.Field.TextXAlignment = Enum.TextXAlignment.Center

        -- สีช่องตามธีม: เอาสีการ์ด (View) มาทำให้สว่างขึ้นนิดหน่อย
        local viewColor = field.Theme.Controls.View[1]
        local function paint(c)
            s.Body.BackgroundColor3 = c:Lerp(Color3.new(1, 1, 1), 0.05)
        end
        paint(viewColor.Value)
        viewColor:Connect(paint)
    end)

    -- ให้พิมพ์ได้เฉพาะตัวเลข 0-9 (ตัวอักษรหรือสัญลักษณ์จะถูกลบทิ้งทันที)
    pcall(function()
        local box = field.Structures.Field
        box:GetPropertyChangedSignal("Text"):Connect(function()
            local cleaned = (box.Text:gsub("%D", ""))
            if cleaned ~= box.Text then
                box.Text = cleaned
            end
        end)
    end)
end

-- Customs Amount
local StatAmountRow = StatsForm:Row()
StatAmountRow:Left():TitleStack({
    Title = "Customs Amount",
    Subtitle = "Set points amount per loop"
})
local StatAmountField = StatAmountRow:Right():TextField({
    Value = tostring(_G.SmoothHubConfig.StatAmount),
    ValueChanged = function(self, value)
        local digits = (tostring(value):gsub("%D", ""))
        local num = math.clamp(tonumber(digits) or 1, 1, 1000000)
        _G.SmoothHubConfig.StatAmount = num
        if self.Value ~= tostring(num) then
            self.Value = tostring(num)
        end
    end
})
StyleStatField(StatAmountField)

-- Auto Upgrade
local AutoUpgradeRow = StatsForm:Row()
AutoUpgradeRow:Left():TitleStack({
    Title = "Auto Upgrade",
    Subtitle = "Automatically invests your stat points securely based on your selection and limits"
})
AutoUpgradeRow:Right():Toggle({
    Value = _G.SmoothHubConfig.AutoUpgradeStats,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.AutoUpgradeStats = value
    end
})

-- ช่องกรอก Max Limit ของแต่ละสเตตัส
local function AddStatLimitRow(statName, maxValue)
    local row = StatsForm:Row()
    row:Left():TitleStack({
        Title = statName,
        Subtitle = "Set max limit level for " .. statName .. " (Max: " .. maxValue .. ")"
    })
    local field = row:Right():TextField({
        Value = tostring(_G.SmoothHubConfig.StatLimits[statName]),
        ValueChanged = function(self, value)
            local digits = (tostring(value):gsub("%D", ""))
            local num = tonumber(digits) or 0
            if not _G.SmoothHubConfig.StatSelection[statName] then
                num = 0 -- ยังไม่ได้ติ๊กสเตตัสนี้ใน Stat Selection = ใส่เลขอะไรก็เป็น 0
            end
            num = math.clamp(num, 0, maxValue)
            _G.SmoothHubConfig.StatLimits[statName] = num
            if self.Value ~= tostring(num) then
                self.Value = tostring(num)
            end
        end
    })
    StyleStatField(field)
end

AddStatLimitRow("Damage", 5000)
AddStatLimitRow("Durability", 5000)
AddStatLimitRow("Stamina", 150)
AddStatLimitRow("Speed", 150)

-- Stats Status
local StatsStatusRow = StatsForm:Row()
StatsStatusRow:Left():TitleStack({
    Title = "Stats Status",
    Subtitle = "Real-time character stats & level tracking."
})
_G.SmoothHubStatus.StatsStatusLabel = StatsStatusRow:Right():Label({
    Text = "Lvl: 0 | Dmg: 0 | Dur: 0 | Sta: 0 | Spd: 0"
})

---------------------------------------------------------
-- แท็บ Monster (แท็บใหม่) - Monster Farm
---------------------------------------------------------
-- ข้อมูลมอนสเตอร์ + เควส (ใช้ร่วมกับระบบฟาร์มด้านท้ายไฟล์)
local MonsterQuestConfig = {
    { Names = {"Human", "Athlete"}, CFrame = CFrame.new(84.4766235, 4.73149872, -26.2268448), QuestPathName = "QuestGiver (Lv.1-Lv.50)" },
    { Names = {"Rank 2 Investigator"}, CFrame = CFrame.new(422.288239, 4.73097706, -362.139801), QuestPathName = "QuestGiver (Lv.50-Lv.150)" },
    { Names = {"Bulk Ghoul"}, CFrame = CFrame.new(404.266632, 4.7305007, 564.892761), QuestPathName = "QuestGiver (Lv.150-Lv.250)" },
    { Names = {"Rank 1 Investigator"}, CFrame = CFrame.new(-210.106567, 4.73097706, -375.544891), QuestPathName = "QuestGiver (Lv.250-Lv.350)" },
    { Names = {"Serpent Ghoul"}, CFrame = CFrame.new(-80.2059937, 4.72720528, 624.273926), QuestPathName = "QuestGiver (Lv.350-Lv.400)" },
    { Names = {"Rin Ghoul"}, CFrame = CFrame.new(503.120239, 4.72720814, 1168.27417), QuestPathName = "QuestGiver (Lv.400-Lv.450)" },
    { Names = {"First class Investigator"}, CFrame = CFrame.new(29.4314117, 4.7277298, 1001.64832), QuestPathName = "QuestGiver (Lv.450-Lv.500)" },
    { Names = {"Aogiri"}, CFrame = CFrame.new(5.03494263, 4.72723007, 1281.78027), QuestPathName = "QuestGiver (Lv.500-Lv.550)" },
    { Names = {"Akira"}, CFrame = CFrame.new(-289.776611, 4.72723007, 1107.37622), QuestPathName = "QuestGiver (Lv.550-Lv.600)" },
    { Names = {"Enforcer"}, CFrame = CFrame.new(917.967651, 4.7309761, 439.671967), QuestPathName = "QuestGiver (Lv.600-Lv.700)" },
    { Names = {"Phantom"}, CFrame = CFrame.new(834.595703, 4.73150063, -409.343506), QuestPathName = "QuestGiver (Lv.700-Lv.800)" },
    { Names = {"Fighter Ghoul"}, CFrame = CFrame.new(524.200989, 4.44271612, -292.036652), QuestPathName = "QuestGiver (Lv.800-Lv.900)" },
    { Names = {"Sparkling Wing Ghoul"}, CFrame = CFrame.new(684.235596, 4.42999983, 690.85791), QuestPathName = "QuestGiver (Lv.900-Lv.1000)" },
    { Names = {"Factor"}, CFrame = CFrame.new(1034.88269, 4.83298349, 651.943848), QuestPathName = "QuestGiver (Lv.1000-Lv.1100)" },
    { Names = {"Faulty Tatara Ghoul"}, CFrame = CFrame.new(708.203613, 4.73383665, 1255.29858), QuestPathName = "QuestGiver (Lv.1100-Lv.1200)" }
}

-- สร้างรายชื่อใน Dropdown จากข้อมูลเควส เช่น "Human [Lv.1-50]"
local monsterOptions = {}
for _, quest in ipairs(MonsterQuestConfig) do
    local lo, hi = quest.QuestPathName:match("Lv%.(%d+)%-Lv%.(%d+)")
    for _, mName in ipairs(quest.Names) do
        table.insert(monsterOptions, lo and (mName .. " [Lv." .. lo .. "-" .. hi .. "]") or mName)
    end
end

local MonsterTab = CategorySection:Tab({
    Title = "Monster",
    Icon = Cascade.Symbols["pawprintFill"] or Cascade.Symbols["leafFill"]
})

local MonsterSection = MonsterTab:PageSection({
    Title = "👹 Monster Farm",
    Subtitle = "Auto quest, fly to and attack the monsters you select.",
})

local MonsterForm = MonsterSection:Form()

-- Enable
local MonsterEnableRow = MonsterForm:Row()
MonsterEnableRow:Left():TitleStack({
    Title = "Enable Farm",
    Subtitle = "Automatically takes the right quest, flies to the selected monsters and attacks."
})
MonsterEnableRow:Right():Toggle({
    Value = _G.SmoothHubConfig.EnableFarmMonster,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.EnableFarmMonster = value
    end
})

-- Monster Selection (เลือกได้หลายตัว)
local MonsterSelectRow = MonsterForm:Row()
MonsterSelectRow:Left():TitleStack({
    Title = "Monster Selection",
    Subtitle = "Choose which monsters to farm"
})
MonsterSelectRow:Right():PopUpButton({
    Options = monsterOptions,
    Maximum = #monsterOptions,
    Value = SettingsStore.IndexesFromMap(monsterOptions, _G.SmoothHubConfig.MonsterSelection),
    ValueChanged = function(self, value)
        local picked = {}
        for _, index in ipairs(value or {}) do
            picked[monsterOptions[index]] = true
        end
        _G.SmoothHubConfig.MonsterSelection = picked
    end
})

-- Position
local MonsterPositionRow = MonsterForm:Row()
MonsterPositionRow:Left():TitleStack({
    Title = "Position",
    Subtitle = "Choose farming direction"
})

local monsterDirectionOptions = {"Upper", "Down"}
MonsterPositionRow:Right():PullDownButton({
    Label = monsterDirectionOptions[SettingsStore.IndexOf(monsterDirectionOptions, _G.SmoothHubConfig.MonsterFarmPosition, 2)],
    Options = monsterDirectionOptions,
    Value = SettingsStore.IndexOf(monsterDirectionOptions, _G.SmoothHubConfig.MonsterFarmPosition, 2),
    ValueChanged = function(self, index)
        local selectedDirection = monsterDirectionOptions[index]
        _G.SmoothHubConfig.MonsterFarmPosition = selectedDirection
        self.Label = selectedDirection
    end
})

-- Status
local MonsterStatusRow = MonsterForm:Row()
MonsterStatusRow:Left():Label({
    Text = "Status"
})
local MonsterStatusLabel = MonsterStatusRow:Right():Label({
    Text = OFF_TEXT
})
_G.SmoothHubStatus.MonsterStatusLabel = MonsterStatusLabel

-- ตัวช่วยอัปเดต Status (ระบบฟาร์มด้านท้ายไฟล์เรียกใช้ SetText)
_G.MonsterStatusObj = {
    SetText = function(text, color)
        MonsterStatusLabel.Text = text
        if color then
            pcall(function()
                MonsterStatusLabel.TextColor3 = color
            end)
        end
    end
}

---------------------------------------------------------
-- แท็บ Drops (Monster Drop Information)
-- แสดงรายชื่อมอนสเตอร์ทั้งหมดพร้อมไอเทมที่ดรอป เลื่อนดูได้
---------------------------------------------------------
-- 🖼️ ไอคอนของไอเทม: ใส่เป็น "rbxassetid://ตัวเลข" (ใช้ร่วมกันทุกมอนสเตอร์ที่ดรอปไอเทมนั้น)
-- ถ้าเว้นว่างไว้ ("") จะแสดงเป็นกากบาทแดง
local DropIcons = {
    CyanCrystal  = "", -- คริสตัลสีฟ้า (พื้นม่วง)
    TealCore     = "", -- ก้อนสีเขียวเข้ม/ฟ้าอมเขียว (พื้นทอง)
    RedCrystal   = "", -- คริสตัลสีแดง (พื้นเทา)
    GreenShard   = "", -- เศษคริสตัลสีเขียว (พื้นน้ำเงิน)
    YellowShard  = "", -- เศษคริสตัลสีเหลืองเขียว (พื้นม่วง)
    RedOrb       = "", -- ลูกแก้วสีแดง (พื้นทอง)
    PurpleShard  = "", -- เศษสีแดง (พื้นม่วง)
    DarkRedShard = "", -- เศษสีแดงเข้ม (พื้นดำ)
}

-- ชื่อไอเทมที่ไม่มีใน DropIcons (เช่น "Unknown") จะแสดงเป็นกากบาทแดง
local DropData = {
    { Title = "Human [Lv.1-50]", Desc = "Starter monsters suited for levels 1-50 players.",
      Drops = { "Unknown", "Unknown", "Unknown" } },
    { Title = "Athlete [Lv.1-50]", Desc = "Frenzied Athlete [Lv.1-50]",
      Drops = { "Unknown", "Unknown", "Unknown" } },
    { Title = "Rank 2 Investigator [Lv.50-Lv.150]", Desc = "Rank 2 Investigator [Lv.X] – Moderate defense and health.",
      Drops = { "CyanCrystal" } },
    { Title = "Bulk Ghoul [Lv.150-250]", Desc = "Giant Ghoul – High damage output, ideal for mid-game leveling.",
      Drops = { "RedCrystal", "GreenShard" } },
    { Title = "Rank 1 Investigator [Lv.250-350]", Desc = "Rank 1 Investigator – Enhanced combat capabilities.",
      Drops = { "CyanCrystal", "TealCore" } },
    { Title = "Serpent Ghoul [Lv.350-400]", Desc = "Serpent Ghoul – Features unique item drop rates.",
      Drops = { "RedCrystal", "YellowShard", "RedOrb" } },
    { Title = "Rin Ghoul [Lv.400-450]", Desc = "Rinkaku Ghoul – High agility and continuous attacks.",
      Drops = { "RedCrystal", "PurpleShard", "RedOrb" } },
    { Title = "First class Investigator [Lv.450-500]", Desc = "First-Class Investigator – Highly skilled and extremely dangerous.",
      Drops = { "CyanCrystal", "TealCore" } },
    { Title = "Aogiri [Lv.500-550]", Desc = "Aogiri Tree Member – Elite Ghoul Soldier.",
      Drops = { "RedCrystal", "DarkRedShard" } },
    { Title = "Akira [Lv.550-600]", Desc = "Special Monster: Akira – Strikes with rapid and swift movements.",
      Drops = { "DarkRedShard" } },
    { Title = "Enforcer [Lv.600-Lv.700]", Desc = "High-Level Area Enforcer",
      Drops = { "CyanCrystal", "TealCore" } },
    { Title = "Phantom [Lv.700-Lv.800]", Desc = "Phantom: A mysterious entity featuring high-speed strikes.",
      Drops = { "CyanCrystal", "TealCore" } },
    { Title = "Fighter Ghoul [Lv.800-900]", Desc = "Brawler Ghoul – Melee combatant with heavy damage.",
      Drops = { "RedCrystal", "DarkRedShard" } },
    { Title = "Sparkling Wing Ghoul [Lv.900-1000]", Desc = "Shining Wing Ghoul – High-level near max cap, unleashes wide-area light bursts.",
      Drops = { "RedCrystal", "DarkRedShard" } },
    { Title = "Factor [Lv.1000-1100]", Desc = "Factor – High-level endgame monster.",
      Drops = { "Unknown", "Unknown", "Unknown" } },
    { Title = "Faulty Tatara Ghoul [Lv.1100-1200]", Desc = "Flawed Tatara: The most formidable max-tier monster currently.",
      Drops = { "RedCrystal" } },
}

---------------------------------------------------------
-- แท็บ Boss (แท็บใหม่)
---------------------------------------------------------
local BossTab = CategorySection:Tab({
    Title = "Boss",
    Icon = Cascade.Symbols["crownFill"] or Cascade.Symbols["leafFill"]
})

local BossSection = BossTab:PageSection({
    Title = "👑 Boss",
    Subtitle = "Manage boss related settings here.",
})

local BossForm = BossSection:Form()

local BossEnableRow = BossForm:Row()
BossEnableRow:Left():TitleStack({
    Title = "Enable",
    Subtitle = "Turn the Boss feature on or off."
})
BossEnableRow:Right():Toggle({
    Value = _G.SmoothHubConfig.EnableFarmBoss,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.EnableFarmBoss = value
        if _G.SmoothHubStatus.BossStatusLabel then
            _G.SmoothHubStatus.BossStatusLabel.Text = value and "Running" or OFF_TEXT
        end
    end
})

local BossStatusRow = BossForm:Row()
BossStatusRow:Left():Label({
    Text = "Status"
})
_G.SmoothHubStatus.BossStatusLabel = BossStatusRow:Right():Label({
    Text = OFF_TEXT
})

-- Boss Selection (เลือกได้หลายตัว) - Noro เป็นบอสเสก ถ้าเลือกไว้ จะถูกให้ความสำคัญก่อนบอสอื่น
local bossOptions = { "Kaneki", "Jason", "Ihei Hairu", "Noro [Summon]" }

local BossSelectRow = BossForm:Row()
BossSelectRow:Left():TitleStack({
    Title = "Boss Selection",
    Subtitle = "Choose which bosses to farm. Noro (summon) is attacked first as soon as it appears."
})
BossSelectRow:Right():PopUpButton({
    Options = bossOptions,
    Maximum = #bossOptions,
    Value = SettingsStore.IndexesFromMap(bossOptions, _G.SmoothHubConfig.BossSelection),
    ValueChanged = function(self, value)
        local picked = {}
        for _, index in ipairs(value or {}) do
            picked[bossOptions[index]] = true
        end
        _G.SmoothHubConfig.BossSelection = picked
    end
})

-- Position
local BossPositionRow = BossForm:Row()
BossPositionRow:Left():TitleStack({
    Title = "Position",
    Subtitle = "Choose farming direction"
})
local bossDirectionOptions = {"Upper", "Down"}
BossPositionRow:Right():PullDownButton({
    Label = bossDirectionOptions[SettingsStore.IndexOf(bossDirectionOptions, _G.SmoothHubConfig.BossFarmPosition, 2)],
    Options = bossDirectionOptions,
    Value = SettingsStore.IndexOf(bossDirectionOptions, _G.SmoothHubConfig.BossFarmPosition, 2),
    ValueChanged = function(self, index)
        local selectedDirection = bossDirectionOptions[index]
        _G.SmoothHubConfig.BossFarmPosition = selectedDirection
        self.Label = selectedDirection
    end
})

-- ตัวช่วยอัปเดต Status ของแท็บ Boss (ใส่สีด้วย RichText เพราะสี Label ผูกกับ Theme)
_G.BossStatusObj = {
    SetText = function(text, color)
        local label = _G.SmoothHubStatus.BossStatusLabel
        if not label then return end
        if color then
            label.Text = string.format(
                '<font color="#%02X%02X%02X">%s</font>',
                math.floor(color.R * 255 + 0.5),
                math.floor(color.G * 255 + 0.5),
                math.floor(color.B * 255 + 0.5),
                text
            )
        else
            label.Text = text
        end
    end
}

-- 📋 Boss Status (ฟังก์ชันสร้างอยู่ก่อนหมวด Dashboard เพราะใช้ร่วมกับแท็บ Status)
AddBossStatusSection(BossTab)

---------------------------------------------------------
-- แท็บ Boss World (แท็บใหม่)
-- อยากเพิ่มฟีเจอร์ในแท็บนี้ ให้ต่อจาก BossWorldForm ได้เลย (เพิ่ม Row / Toggle / PullDownButton ฯลฯ)
---------------------------------------------------------
local BossWorldTab = CategorySection:Tab({
    Title = "Boss World",
    Icon = Cascade.Symbols["globeAmericasFill"] or Cascade.Symbols["crownFill"] or Cascade.Symbols["leafFill"]
})

local BossWorldSection = BossWorldTab:PageSection({
    Title = "🌍 Boss World",
    Subtitle = "Manage Boss World related settings here.",
})

local BossWorldForm = BossWorldSection:Form()

-- ใช้ do ... end ครอบไว้ เพื่อไม่ให้ตัวแปร local เพิ่มจนชนลิมิต 200 ตัวของสคริปต์หลัก
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")

    -- ข้อมูล World Boss (โลกปกติ): Key คือรหัสที่จับได้จาก Remote Spy ของปุ่ม Start ของบอสแต่ละตัว
    local WorldBossData = {
        { Name = "Shachi",          Level = 150, BossArg = "Shachi",
          Key = "n\xC3\x87IDsKt\x89\xE0\xACY\xC8\xCB\xDB\x1C" },
        { Name = "Eto Yoshimura",   Level = 250, BossArg = "Eto Yoshimura",
          Key = "\x15\xFE\x03\xF3\xA3dCu\xB8\x1E\xB2\x1F\xA9V\xE8\xF0" },
        { Name = "Arata Kirishima", Level = 150, BossArg = "Arata kirishima",
          Key = "\xCC\xC2\x0EsL\xB1D\xE8\xA3f,\x95\xF7\xB9\xB9\xFC" },
    }

    local worldBossOptions = {}
    for _, boss in ipairs(WorldBossData) do
        table.insert(worldBossOptions, string.format("%s [Lv.%d]", boss.Name, boss.Level))
    end

    -- ค่าเริ่มต้น/ค่าที่จำไว้อยู่ใน Config หลักด้านบนแล้ว (AutoStartWorldBoss, WorldBossQueue, WorldBossJoinDelay)
    -- ที่นี่แค่ตรวจให้ค่าใช้ได้จริง เผื่อไฟล์ที่จำไว้เพี้ยน
    _G.SmoothHubConfig.WorldBossQueue = SettingsStore.ValidIndexes(_G.SmoothHubConfig.WorldBossQueue, #worldBossOptions)
    _G.SmoothHubConfig.WorldBossJoinDelay = math.clamp(tonumber(_G.SmoothHubConfig.WorldBossJoinDelay) or 10, 1, 600)

    -- Auto Start
    local WorldBossEnableRow = BossWorldForm:Row()
    WorldBossEnableRow:Left():TitleStack({
        Title = "Auto Start",
        Subtitle = "Waits for the Join Delay, then starts the selected World Bosses one by one in the order you ticked them."
    })
    WorldBossEnableRow:Right():Toggle({
        Value = _G.SmoothHubConfig.AutoStartWorldBoss,
        ValueChanged = function(self, value)
            _G.SmoothHubConfig.AutoStartWorldBoss = value
        end
    })

    -- เลือกบอส (ติ๊กได้หลายตัว ลำดับที่ติ๊กคือลำดับที่จะ Start)
    local WorldBossSelectRow = BossWorldForm:Row()
    WorldBossSelectRow:Left():TitleStack({
        Title = "World Boss",
        Subtitle = "Tick one or more bosses. The first one you tick is started first."
    })

    -- แถวแสดงลำดับ Start จริง (เมนูด้านบนแสดงชื่อเรียงตามรายการ ไม่ใช่ตามลำดับที่ติ๊ก)
    local WorldBossOrderRow = BossWorldForm:Row()
    WorldBossOrderRow:Left():TitleStack({
        Title = "Start Order",
        Subtitle = "The order Auto Start will follow."
    })
    local WorldBossOrderLabel = WorldBossOrderRow:Right():Label({
        Text = "-"
    })

    local function UpdateWorldBossOrderLabel()
        local queue = _G.SmoothHubConfig.WorldBossQueue
        local parts = {}
        for i, index in ipairs(queue) do
            local boss = WorldBossData[index]
            if boss then
                table.insert(parts, string.format("%d. %s", i, boss.Name))
            end
        end
        pcall(function()
            WorldBossOrderLabel.Text = #parts > 0 and table.concat(parts, "  >  ") or "-"
        end)
    end

    WorldBossSelectRow:Right():PopUpButton({
        Options = worldBossOptions,
        Maximum = #worldBossOptions,
        Value = _G.SmoothHubConfig.WorldBossQueue, -- ลำดับที่ติ๊กไว้ (คงลำดับเดิม)
        ValueChanged = function(self, value)
            -- value เรียงตามลำดับที่ติ๊ก (ติ๊กก่อนอยู่หน้า / เอาติ๊กออกแล้วลำดับที่เหลือคงเดิม)
            _G.SmoothHubConfig.WorldBossQueue = table.clone(value or {})
            UpdateWorldBossOrderLabel()
        end
    })
    UpdateWorldBossOrderLabel() -- แสดงลำดับที่จำไว้ตั้งแต่เปิดสคริปต์

    -- Join Delay (วินาที) ค่าเริ่มต้น 10
    local WorldBossDelayRow = BossWorldForm:Row()
    WorldBossDelayRow:Left():TitleStack({
        Title = "Join Delay",
        Subtitle = "Seconds to wait before each Start (default 10s)."
    })
    WorldBossDelayRow:Right():Stepper({
        Minimum = 1,
        Maximum = 600,
        Step = 1,
        Fielded = true,
        Value = _G.SmoothHubConfig.WorldBossJoinDelay,
        ValueChanged = function(self, value)
            _G.SmoothHubConfig.WorldBossJoinDelay = math.clamp(tonumber(value) or 10, 1, 600)
        end
    })

    -- Status
    local WorldBossStatusRow = BossWorldForm:Row()
    WorldBossStatusRow:Left():Label({
        Text = "Status"
    })
    local WorldBossStatusLabel = WorldBossStatusRow:Right():Label({
        Text = OFF_TEXT
    })

    local function SetWorldBossStatus(text, hex)
        pcall(function()
            WorldBossStatusLabel.Text = hex and Colorize(text, hex) or text
        end)
    end

    -- อ่านเลเวลผู้เล่น (อ่านไม่ได้ = nil แล้วจะไม่ข้ามบอสตัวไหน)
    local function GetPlayerLevel()
        local ok, level = pcall(function()
            local data = Players.LocalPlayer:FindFirstChild("Data")
            local stat = data and (data:FindFirstChild("Level") or data:FindFirstChild("Lv"))
            return stat and stat.Value
        end)
        return ok and tonumber(level) or nil
    end

    -- กดปุ่ม Start ของบอสด้วยการยิง Remote ตามที่จับได้
    local function StartWorldBoss(boss)
        local bridge = ReplicatedStorage:FindFirstChild("BridgeNet2")
        local remote = bridge and bridge:FindFirstChild("dataRemoteEvent")
        if not remote then
            return false, "Remote not found"
        end

        local ok, err = pcall(function()
            remote:FireServer({
                { "\x01", boss.Key, { boss.BossArg } },
                "\x18"
            })
        end)
        return ok, err
    end

    -- ลูปหลัก: นับ Join Delay ให้ครบก่อน แล้วค่อย Start บอสตัวถัดไปในคิว (วนซ้ำตามลำดับที่ติ๊ก)
    task.spawn(function()
        local countdownStart = nil -- เวลาที่เริ่มนับ Join Delay ของรอบนี้
        local nextPos = 1          -- ตำแหน่งในคิวที่จะ Start ต่อไป
        local lastStarted = nil

        while true do
            task.wait(0.25)
            local cfg = _G.SmoothHubConfig

            if not cfg.AutoStartWorldBoss then
                countdownStart = nil
                nextPos = 1
                lastStarted = nil
                SetWorldBossStatus(OFF_TEXT, "#96A5AA")
                continue
            end

            local queue = cfg.WorldBossQueue or {}
            if #queue == 0 then
                countdownStart = nil
                nextPos = 1
                SetWorldBossStatus("No World Boss selected", "#FFB432")
                continue
            end

            -- เปิดสวิตช์ครั้งแรก = เริ่มนับ Join Delay ใหม่จาก 0 (ยังไม่ Start ทันที)
            if not countdownStart then
                countdownStart = os.clock()
            end
            if nextPos > #queue then
                nextPos = 1
            end

            -- เลือกบอสตัวถัดไปในคิว โดยข้ามตัวที่เลเวลเราไม่ถึง (ถ้าอ่านเลเวลได้)
            local level = GetPlayerLevel()
            local pickedPos, picked
            for i = 0, #queue - 1 do
                local pos = ((nextPos - 1 + i) % #queue) + 1
                local boss = WorldBossData[queue[pos]]
                if boss and (not level or level >= boss.Level) then
                    pickedPos, picked = pos, boss
                    break
                end
            end

            if not picked then
                countdownStart = os.clock()
                SetWorldBossStatus("No eligible boss (level too low)", BOSS_RED)
                continue
            end

            local delay = cfg.WorldBossJoinDelay or 10
            local elapsed = os.clock() - countdownStart

            if elapsed < delay then
                local remain = math.ceil(delay - elapsed)
                if lastStarted then
                    SetWorldBossStatus(
                        string.format("Next: %s in %ds  (last: %s)", picked.Name, remain, lastStarted),
                        "#64C8FF"
                    )
                else
                    SetWorldBossStatus(string.format("Starting %s in %ds", picked.Name, remain), "#64C8FF")
                end
            else
                local ok, err = StartWorldBoss(picked)
                if ok then
                    lastStarted = picked.Name
                    nextPos = (pickedPos % #queue) + 1
                else
                    SetWorldBossStatus("Error: " .. tostring(err), BOSS_RED)
                end
                countdownStart = os.clock() -- เริ่มนับ Join Delay รอบใหม่
            end
        end
    end)
end

-- หมวดหมู่ Information (ไกด์สำหรับคนที่ยังไม่รู้ข้อมูลเกม) - อยากเพิ่มแท็บไกด์อื่นก็ใช้ InformationSection:Tab({...})
local InformationSection = Cascade.Components.Section(Window, {
    Title = "Information",
    Disclosure = false
})

local DropTab = InformationSection:Tab({
    Title = "Drops",
    Icon = Cascade.Symbols["archiveboxFill"] or Cascade.Symbols["leafFill"]
})

local DropSection = DropTab:PageSection({
    Title = "🗡️ Monster Drop Information",
    Subtitle = "List of all monsters and their dropped items.",
})

do
    local container = DropSection.__container

    local function MakeIconTile(parent, itemKey, order)
        local tile = Instance.new("Frame")
        tile.Name = "DropItem"
        tile.Size = UDim2.fromOffset(46, 46)
        tile.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
        tile.BorderSizePixel = 0
        tile.LayoutOrder = order
        tile.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 7)
        corner.Parent = tile

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(58, 58, 64)
        stroke.Thickness = 1
        stroke.Parent = tile

        local icon = DropIcons[itemKey]
        if icon and icon ~= "" then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.fromScale(1, 1)
            img.BackgroundTransparency = 1
            img.BorderSizePixel = 0
            img.Image = icon
            img.ScaleType = Enum.ScaleType.Fit
            img.Parent = tile

            local imgCorner = Instance.new("UICorner")
            imgCorner.CornerRadius = UDim.new(0, 7)
            imgCorner.Parent = img
        else
            local x = Instance.new("TextLabel")
            x.Size = UDim2.fromScale(1, 1)
            x.BackgroundTransparency = 1
            x.Text = "✕"
            x.Font = Enum.Font.GothamBold
            x.TextSize = 30
            x.TextColor3 = Color3.fromRGB(200, 20, 20)
            x.AutoLocalize = false
            x.Parent = tile
        end
    end

    for i, info in ipairs(DropData) do
        local card = Instance.new("Frame")
        card.Name = "DropCard"
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = Color3.fromRGB(33, 33, 36)
        card.BorderSizePixel = 0
        card.LayoutOrder = i
        card.Parent = container

        -- สีการ์ดตามธีม: เอาสีการ์ด (View) มาทำให้สว่างขึ้นนิดหน่อย
        pcall(function()
            local viewColor = DropSection.Theme.Controls.View[1]
            local function paint(c)
                card.BackgroundColor3 = c:Lerp(Color3.new(1, 1, 1), 0.05)
            end
            paint(viewColor.Value)
            viewColor:Connect(paint)
        end)

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 8)
        cardCorner.Parent = card

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 12)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 14)
        pad.PaddingRight = UDim.new(0, 14)
        pad.Parent = card

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 6)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 0)
        title.AutomaticSize = Enum.AutomaticSize.Y
        title.BackgroundTransparency = 1
        title.Text = "👹 " .. info.Title
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextColor3 = Color3.fromRGB(255, 170, 45)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextWrapped = true
        title.AutoLocalize = false
        title.LayoutOrder = 1
        title.Parent = card

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, 0, 0, 0)
        desc.AutomaticSize = Enum.AutomaticSize.Y
        desc.BackgroundTransparency = 1
        desc.Text = info.Desc
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextColor3 = Color3.fromRGB(175, 175, 182)
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.AutoLocalize = false
        desc.LayoutOrder = 2
        desc.Parent = card

        if #info.Drops > 0 then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 46)
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.LayoutOrder = 3
            row.Parent = card

            local rowList = Instance.new("UIListLayout")
            rowList.FillDirection = Enum.FillDirection.Horizontal
            rowList.Padding = UDim.new(0, 6)
            rowList.SortOrder = Enum.SortOrder.LayoutOrder
            rowList.Parent = row

            for slot, itemKey in ipairs(info.Drops) do
                MakeIconTile(row, itemKey, slot)
            end
        end
    end
end

---------------------------------------------------------
-- แท็บ Advanced (รวม Anti Admin แล้ว)
---------------------------------------------------------
local AdvancedTab = Window:Tab({
    Title = "Advanced",
    Icon = Cascade.Symbols["gearshapeFill"]
})

local AdvSection = AdvancedTab:PageSection({
    Title = "⚙️ Advanced Settings",
    Subtitle = "Configure advanced player modifications and tools.",
})

local AdvForm = AdvSection:Form()

-- ปุ่ม Infinite Jump
local InfJumpRow = AdvForm:Row()
InfJumpRow:Left():TitleStack({
    Title = "Infinite Jump",
    Subtitle = "Allow your character to jump infinitely in the air."
})
InfJumpRow:Right():Toggle({
    Value = _G.SmoothHubConfig.InfiniteJump,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.InfiniteJump = value
    end
})

-- ปุ่ม Anti-AFK
local AntiAfkRow = AdvForm:Row()
AntiAfkRow:Left():TitleStack({
    Title = "Anti-AFK",
    Subtitle = "Prevent being kicked out of the game due to inactivity."
})
AntiAfkRow:Right():Toggle({
    Value = _G.SmoothHubConfig.AntiAFK,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.AntiAFK = value
    end
})

-- ปุ่ม Auto Rejoin
local AutoRejoinRow = AdvForm:Row()
AutoRejoinRow:Left():TitleStack({
    Title = "Auto Rejoin",
    Subtitle = "Automatically rejoin the game if disconnected or kicked."
})
AutoRejoinRow:Right():Toggle({
    Value = _G.SmoothHubConfig.AutoRejoin,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.AutoRejoin = value
    end
})

-- ปุ่ม Anti Admin (ใหม่)
local AntiAdminRow = AdvForm:Row()
AntiAdminRow:Left():TitleStack({
    Title = "Anti Admin",
    Subtitle = "Automatically server hop if an admin joins the game."
})
AntiAdminRow:Right():Toggle({
    Value = _G.SmoothHubConfig.AntiAdmin,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.AntiAdmin = value
    end
})

-- ปุ่ม Enable FPS Lock
local FpsLockToggleRow = AdvForm:Row()
FpsLockToggleRow:Left():TitleStack({
    Title = "Enable FPS Lock",
    Subtitle = "Toggle frame rate limiting on or off."
})
FpsLockToggleRow:Right():Toggle({
    Value = _G.SmoothHubConfig.EnableFPSLock,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.EnableFPSLock = value
        if not value and setfpscap then
            setfpscap(9999)
        elseif value and setfpscap then
            setfpscap(_G.SmoothHubConfig.FPSLimit)
        end
    end
})

-- เมนูดรอปดาวน์เลือกค่า FPS
local FpsMenuRow = AdvForm:Row()
FpsMenuRow:Left():TitleStack({
    Title = "FPS Limit Preset",
    Subtitle = "Choose target frame rate limit."
})

local fpsOptions = {"15 FPS","30 FPS","60 FPS", "120 FPS", "144 FPS", "240 FPS","500 FPS","1000 FPS", "9999 (Unlimited)"}
local fpsValues = {15,30,60, 120, 144, 240,500,1000, 9999}

local FpsBtn = FpsMenuRow:Right():PullDownButton({
    Label = fpsOptions[table.find(fpsValues, _G.SmoothHubConfig.FPSLimit) or 5],
    Options = fpsOptions,
    Value = table.find(fpsValues, _G.SmoothHubConfig.FPSLimit) or 5,
    ValueChanged = function(self, index)
        local targetFps = fpsValues[index]
        _G.SmoothHubConfig.FPSLimit = targetFps
        self.Label = fpsOptions[index]
        if _G.SmoothHubConfig.EnableFPSLock and setfpscap then
            setfpscap(targetFps)
        end
    end
})

pcall(function()
    local indicator = FpsBtn.__instance:FindFirstChild("PullDownIndicator")
    if indicator then
        local img = indicator:FindFirstChild("Indicators")
        if img then
            img.Image = "rbxassetid://115187614425058"
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Size = UDim2.fromOffset(18, 18)
            img.Position = UDim2.fromScale(0.5, 0.5)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end
end)


---------------------------------------------------------
-- แท็บ Server
---------------------------------------------------------
local ServerTab = Window:Tab({
    Title = "Server",
    Icon = Cascade.Symbols["globe"]
})

local ServerInfoSection = ServerTab:PageSection({
    Title = "🌐 Server Information",
    Subtitle = "Display current server details and identifiers."
})
local ServerInfoForm = ServerInfoSection:Form()

local GameIdRow = ServerInfoForm:Row()
GameIdRow:Left():TitleStack({
    Title = "GameId",
    Subtitle = "The unique ID of this game universe."
})
GameIdRow:Right():Label({
    Text = tostring(game.GameId)
})

local PlaceIdRow = ServerInfoForm:Row()
PlaceIdRow:Left():TitleStack({
    Title = "PlaceId",
    Subtitle = "The specific place ID of this server instance."
})
PlaceIdRow:Right():Label({
    Text = tostring(game.PlaceId)
})

local ServerActionSection = ServerTab:PageSection({
    Title = "💾 Server Actions",
    Subtitle = "Quick tools to copy identifiers or switch servers."
})
local ServerActionForm = ServerActionSection:Form()

local CopyJobRow = ServerActionForm:Row()
CopyJobRow:Left():TitleStack({
    Title = "Copy JobId",
    Subtitle = "Copy current JobId to clipboard for friends to join."
})
local CopyJobBtn = CopyJobRow:Right():Button({
    Label = "Execute",
    Callback = function()
        local jobId = tostring(game.JobId)
        pcall(function()
            if setclipboard then setclipboard(jobId)
            elseif toclipboard then toclipboard(jobId)
            elseif syn and syn.write_clipboard then syn.write_clipboard(jobId)
            elseif Clipboard and Clipboard.set then Clipboard.set(jobId) end
        end)
    end
})

pcall(function()
    if CopyJobBtn.__instance then
        local btnObj = CopyJobBtn.__instance:FindFirstChildWhichIsA("TextButton", true) or CopyJobBtn.__instance
        btnObj.MouseButton1Click:Connect(function()
            local jobId = tostring(game.JobId)
            pcall(function()
                if setclipboard then setclipboard(jobId)
                elseif toclipboard then toclipboard(jobId)
                elseif syn and syn.write_clipboard then syn.write_clipboard(jobId)
                elseif Clipboard and Clipboard.set then Clipboard.set(jobId) end
            end)
        end)
    end
end)

local RejoinRow = ServerActionForm:Row()
RejoinRow:Left():TitleStack({
    Title = "Rejoin Server",
    Subtitle = "Reconnect to the same server instance."
})
local RejoinBtn = RejoinRow:Right():Button({
    Label = "Execute",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local LocalPlayer = game:GetService("Players").LocalPlayer
        pcall(function()
            if #game:GetService("Players"):GetPlayers() <= 1 then
                LocalPlayer:Kick("\nRejoining...")
                task.wait()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            else
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end)
    end
})

pcall(function()
    if RejoinBtn.__instance then
        local btnObj = RejoinBtn.__instance:FindFirstChildWhichIsA("TextButton", true) or RejoinBtn.__instance
        btnObj.MouseButton1Click:Connect(function()
            local TeleportService = game:GetService("TeleportService")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            pcall(function()
                if #game:GetService("Players"):GetPlayers() <= 1 then
                    LocalPlayer:Kick("\nRejoining...")
                    task.wait()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                else
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end
            end)
        end)
    end
end)

local ServerHopRow = ServerActionForm:Row()
ServerHopRow:Left():TitleStack({
    Title = "Server Hop",
    Subtitle = "Teleport to a different server to find a new one."
})
local ServerHopBtn = ServerHopRow:Right():Button({
    Label = "Execute",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local LocalPlayer = game:GetService("Players").LocalPlayer
        
        pcall(function()
            local servers = {}
            local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local body = HttpService:JSONDecode(req)
            if body and body.data then
                for _, s in ipairs(body.data) do
                    if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                        table.insert(servers, s.id)
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
})

pcall(function()
    if ServerHopBtn.__instance then
        local btnObj = ServerHopBtn.__instance:FindFirstChildWhichIsA("TextButton", true) or ServerHopBtn.__instance
        btnObj.MouseButton1Click:Connect(function()
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            
            pcall(function()
                local servers = {}
                local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                local body = HttpService:JSONDecode(req)
                if body and body.data then
                    for _, s in ipairs(body.data) do
                        if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                            table.insert(servers, s.id)
                        end
                    end
                end
                if #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
                else
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)
        end)
    end
end)


---------------------------------------------------------
-- แท็บ Settings (Windows)
---------------------------------------------------------
local AppearanceSection = Cascade.Components.Section(Window, {
    Title = "Settings\u{200B}", -- มีอักขระไร้เสียงต่อท้าย กัน Roblox แปลเป็น "การตั้งค่า"
    Disclosure = false
})

local SettingsTab = Window:Tab({
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

local DEFAULT_ACCENT = "Dark" -- ต้องตรงกับสีเริ่มต้นที่ใส่ใน Cascade.New ด้านบน
local FOLLOW_THEME = "Theme Default" -- ตัวเลือกของ Accent Color = ใช้สีของ Theme Color ตามเดิม

-- สถานะปัจจุบัน: Theme Color (พื้นหลัง+โทนสี) และ Accent Color (ไอคอน/สวิตช์/ปุ่ม)
local CurrentThemeName = table.find(AccentOrder, SavedUi.Theme) and SavedUi.Theme or DEFAULT_ACCENT
local CurrentAccentName = (SavedUi.Accent == FOLLOW_THEME or table.find(AccentOrder, SavedUi.Accent)) and SavedUi.Accent or FOLLOW_THEME

-- ประกอบสีสุดท้าย: เอาสีพื้นหลังจาก Theme Color + สีไอคอน/สวิตช์/ปุ่มจาก Accent Color
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

        local tabs = {StatusTab, MainFarmTab, MonsterTab, BossTab, BossWorldTab, DropTab, AdvancedTab, ServerTab, SettingsTab}
        for _, tab in ipairs(tabs) do
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

pcall(function()
    local indicator = ThemeColorBtn.__instance:FindFirstChild("PullDownIndicator")
    if indicator then
        local img = indicator:FindFirstChild("Indicators")
        if img then
            img.Image = "rbxassetid://115187614425058"
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Size = UDim2.fromOffset(18, 18)
            img.Position = UDim2.fromScale(0.5, 0.5)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end
end)

-- 🎯 Accent Color: เปลี่ยนเฉพาะสีไอคอน สวิตช์ ปุ่ม และแถบที่เลือก (ไม่เปลี่ยนสีพื้นหลัง)
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

pcall(function()
    local indicator = AccentColorBtn.__instance:FindFirstChild("PullDownIndicator")
    if indicator then
        local img = indicator:FindFirstChild("Indicators")
        if img then
            img.Image = "rbxassetid://115187614425058"
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Size = UDim2.fromOffset(18, 18)
            img.Position = UDim2.fromScale(0.5, 0.5)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    end
end)

-- ถ้าเคยตั้ง Accent Color ไว้ ให้ใช้ทันที
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
    ValueChanged = function(self, newKey)
        currentKeybind = newKey
    end,
    BindPressed = function(self, key, inputComplete, gameProcessedEvent)
        if inputComplete and not gameProcessedEvent then
            Window.Minimized = not Window.Minimized
        end
    end
})

---------------------------------------------------------
-- 💾 เริ่มบันทึกอัตโนมัติ: ค่าเปลี่ยนเมื่อไหร่ จะเซฟลงไฟล์ของไอดีนี้เอง
---------------------------------------------------------
SettingsStore.StartAutoSave("World", function()
    return {
        Config = _G.SmoothHubConfig,
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
-- 🕹️ ระบบประมวลผลเบื้องหลัง (Anti Admin, Auto Rejoin, Anti-AFK, Fast Attack)
---------------------------------------------------------
task.spawn(function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local CoreGui = game:GetService("CoreGui")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer

    local AttackEvent = ReplicatedStorage:WaitForChild("BridgeNet2", 10):WaitForChild("dataRemoteEvent", 10)
    local PlayerFolder = Workspace:WaitForChild("AI/Player", 10)

    -- ฟังก์ชันสำหรับ Server Hop (ใช้ร่วมกับ Anti Admin)
    local function HopServer()
        pcall(function()
            local servers = {}
            local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local body = HttpService:JSONDecode(req)
            if body and body.data then
                for _, s in ipairs(body.data) do
                    if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                        table.insert(servers, s.id)
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

    -- ระบบ Anti Admin (ตรวจสอบผู้เล่นที่เข้ามาใหม่หรือมีอยู่แล้ว)
    local function CheckAdmin(player)
        if player == LocalPlayer then return end
        pcall(function()
            -- เช็กสิทธิ์แอดมินเบื้องต้น (เช่น ยศในกลุ่ม, บัญชีผู้ดูแล หรือเงื่อนไขพิเศษ)
            if player:GetRankInGroup(game.CreatorId) >= 250 or player.UserId == game.CreatorId then
                if _G.SmoothHubConfig.AntiAdmin then
                    HopServer()
                end
            end
        end)
    end

    Players.PlayerAdded:Connect(function(player)
        CheckAdmin(player)
    end)

    task.spawn(function()
        while task.wait(3) do
            if _G.SmoothHubConfig.AntiAdmin then
                for _, player in ipairs(Players:GetPlayers()) do
                    CheckAdmin(player)
                end
            end
        end
    end)

    -- ระบบ Auto Rejoin
    pcall(function()
        local errorPrompt = CoreGui:FindFirstChild("RobloxPromptGui", true)
        if errorPrompt then
            errorPrompt.ChildAdded:Connect(function(child)
                if child.Name == "promptOverlay" then
                    task.wait(1)
                    if _G.SmoothHubConfig.AutoRejoin then
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end
                end
            end)
        end
    end)

    local function HasValidEnemyNearby()
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not PlayerFolder then 
            return false 
        end
        
        local myPos = character.HumanoidRootPart.Position
        for _, obj in ipairs(PlayerFolder:GetChildren()) do
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local rootPart = obj:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart and humanoid.Health > 0 then
                if (rootPart.Position - myPos).Magnitude <= 35 then
                    return true
                end
            end
        end
        return false
    end

    UserInputService.JumpRequest:Connect(function()
        if _G.SmoothHubConfig.InfiniteJump then
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    LocalPlayer.Idled:Connect(function()
        if _G.SmoothHubConfig.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end
    end)
    ---------------------------------------------------------
    -- 📊 Auto Upgrade Stats
    ---------------------------------------------------------
    -- Remote ตัวเดียวกับ Fast Attack (BridgeNet2.dataRemoteEvent)
    local StatEvent = AttackEvent

    local STAT_ORDER = {"Damage", "Durability", "Stamina", "Speed"}

    -- ชื่อ Value ใน Players.<ชื่อเรา>.Stat (สเตตัส Speed ในเกมใช้ชื่อภาษาไทย)
    local STAT_VALUE_NAMES = {
        Damage = "Damage",
        Durability = "Durability",
        Stamina = "Stamina",
        Speed = "ความเร็ว"
    }

    local function GetStatValue(statName)
        local folder = LocalPlayer:FindFirstChild("Stat")
        local obj = folder and folder:FindFirstChild(STAT_VALUE_NAMES[statName])
        return obj and obj.Value or nil
    end

    local function GetLevel()
        local data = LocalPlayer:FindFirstChild("Data")
        local obj = data and data:FindFirstChild("Level")
        return obj and obj.Value or nil
    end

    -- อ่านแต้มคงเหลือจากข้อความ "Remaining Point(s): 302" บนหน้าต่าง Stats ของเกม
    -- คืนค่า nil ถ้าหาไม่เจอ (ถือว่าไม่ทราบ)
    local pointsLabel = nil
    local lastPointsSearch = 0

    local function GetRemainingPoints()
        if (not pointsLabel or not pointsLabel.Parent) and os.clock() - lastPointsSearch > 5 then
            lastPointsSearch = os.clock()
            pointsLabel = nil
            local gui = LocalPlayer:FindFirstChild("PlayerGui")
            if gui then
                for _, d in ipairs(gui:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text:find("Remaining Point") then
                        pointsLabel = d
                        break
                    end
                end
            end
        end

        if pointsLabel and pointsLabel.Parent then
            local txt = pointsLabel.Text:gsub(",", "")
            return tonumber(txt:match(":%s*(%d+)"))
        end
        return nil
    end

    -- อัพสเตตัส 1 ตัว คืนค่าจำนวนแต้มที่ใช้ไป (หรือ 0 ถ้าไม่ได้อัพ)
    -- points = แต้มคงเหลือ (nil = ไม่ทราบ)
    local function UpgradeStat(statName, amount, points)
        local limit = _G.SmoothHubConfig.StatLimits[statName] or 0
        local current = GetStatValue(statName)
        if not current then return 0 end

        local toSpend = math.min(amount, limit - current)
        if points then
            toSpend = math.min(toSpend, points)
        end
        if toSpend <= 0 then return 0 end -- ถึงเพดานแล้ว หรือแต้มหมด

        StatEvent:FireServer({
            {
                statName,
                toSpend
            },
            "\v"
        })
        return toSpend
    end

    local function UpdateStatsStatus()
        local label = _G.SmoothHubStatus.StatsStatusLabel
        local dashLabel = _G.SmoothHubStatus.StatsStatusLabelDashboard
        if not label and not dashLabel then return end

        local text = string.format(
            "Lvl: %s | Dmg: %s | Dur: %s | Sta: %s | Spd: %s",
            tostring(GetLevel() or 0),
            tostring(GetStatValue("Damage") or 0),
            tostring(GetStatValue("Durability") or 0),
            tostring(GetStatValue("Stamina") or 0),
            tostring(GetStatValue("Speed") or 0)
        )

        -- อัปเดตทั้งในแท็บ Main Farm และแท็บ Status
        if label then label.Text = text end
        if dashLabel then dashLabel.Text = text end
    end

    task.spawn(function()
        while task.wait(0.5) do
            pcall(UpdateStatsStatus)

            if _G.SmoothHubConfig.AutoUpgradeStats and StatEvent then
                local okPoints, points = pcall(GetRemainingPoints)
                if not okPoints then points = nil end

                for _, statName in ipairs(STAT_ORDER) do
                    if _G.SmoothHubConfig.StatSelection[statName] then
                        local ok, spent = pcall(UpgradeStat, statName, _G.SmoothHubConfig.StatAmount, points)
                        if ok and points and spent then
                            points = points - spent
                        end
                    end
                end
            end
        end
    end)

    while true do
        if _G.SmoothHubConfig.EnableFPSLock and setfpscap then
            pcall(function()
                setfpscap(_G.SmoothHubConfig.FPSLimit)
            end)
        end

        if _G.SmoothHubConfig.FastAttack and AttackEvent then
            pcall(function()
                if HasValidEnemyNearby() then
                    AttackEvent:FireServer({
                        {
                            "NormalAttack",
                            1
                        },
                        "\x13"
                    })
                end
            end)
        end
        task.wait(0.1)
    end
end)

---------------------------------------------------------
-- ระบบ Monster Farm (Auto Quest + Fly + Attack)
-- อ่านค่าจากแท็บ Monster: EnableFarmMonster / MonsterSelection / MonsterFarmPosition
---------------------------------------------------------
task.spawn(function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local player = Players.LocalPlayer
    local LocalPlayer = Players.LocalPlayer

    local PlayerFolder = Workspace:WaitForChild("AI/Player", 5)
    local IncludeToGame = Workspace:WaitForChild("IncludeToGame", 5)
    local ZonesFolder = IncludeToGame and IncludeToGame:WaitForChild("Zones", 5)

    -- ข้อมูลเควส/มอนสเตอร์ใช้ตารางเดียวกับที่สร้างไว้ในแท็บ Monster
    local QuestConfig = MonsterQuestConfig

    local FLY_SPEED = 250
    local currentTarget = nil 
    local isDoingQuest = false
    local isPlayerReadyToFarm = false

    local function GetPlayerLevel()
        local success, level = pcall(function()
            local dataFolder = LocalPlayer:FindFirstChild("Data")
            if dataFolder then
                local levelStat = dataFolder:FindFirstChild("Level") or dataFolder:FindFirstChild("Lv")
                if levelStat then return levelStat.Value end
            end
        end)
        return success and level or 1
    end

    -- ดึงรายชื่อมอนสเตอร์ทั้งหมดที่ผู้เล่นติ๊กเลือกไว้ใน UI
    local function GetSelectedMonsterNames()
        local selectedList = {}
        if _G.SmoothHubConfig.MonsterSelection and type(_G.SmoothHubConfig.MonsterSelection) == "table" then
            for monsterFullName, isSelected in pairs(_G.SmoothHubConfig.MonsterSelection) do
                if isSelected then
                    local cleanName = monsterFullName:match("^(.-)%s*%[") or monsterFullName
                    cleanName = cleanName:match("^%s*(.-)%s*$")
                    table.insert(selectedList, cleanName)
                end
            end
        end
        return selectedList
    end

    -- ฟังก์ชันค้นหาเควสที่ตรงกับมอนสเตอร์เป้าหมาย (เรียงจากลำดับขั้นเควสที่สูงกว่า หรือเช็กจากตัวที่กำลังเจอจริง)
    local function GetCurrentQuestInfo()
        local selectedMonsters = GetSelectedMonsterNames()
    
        -- ถ้าระบบกำลังเล็งมอนสเตอร์ตัวไหนอยู่ ให้พยายามดึงเควสของมอนสเตอร์ตัวนั้นเป็นหลักทันที
        if currentTarget and currentTarget.Name then
            for _, quest in ipairs(QuestConfig) do
                for _, mName in ipairs(quest.Names) do
                    if currentTarget.Name:lower() == mName:lower() or currentTarget.Name:lower():find(mName:lower()) then
                        return quest
                    end
                end
            end
        end

        -- ถ้ายังไม่มีเป้าหมาย ให้เช็กจากรายชื่อที่เลือกไว้ (เลือกตัวที่อยู่ในลำดับเควสสูงที่สุดที่คุณติ๊กไว้)
        if #selectedMonsters > 0 then
            for i = #QuestConfig, 1, -1 do
                local quest = QuestConfig[i]
                for _, qName in ipairs(quest.Names) do
                    for _, sName in ipairs(selectedMonsters) do
                        if sName:lower() == qName:lower() or sName:lower():find(qName:lower()) then
                            return quest
                        end
                    end
                end
            end
        end
    
        -- กรณีสำรอง อิงตามเลเวลผู้เล่น
        local level = GetPlayerLevel()
        for i = #QuestConfig, 1, -1 do
            if level >= (i - 1) * 100 then
                return QuestConfig[i]
            end
        end
        return QuestConfig[1]
    end

    -- ฟังก์ชันเช็กว่าปัจจุบันมีเควสแสดงอยู่บนหน้าจอ UI หรือไม่
    local function HasActiveQuest()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local hud = playerGui:FindFirstChild("HUD")
            local questUi = hud and hud:FindFirstChild("Quest")
            if questUi then
                if questUi.Visible or #questUi:GetChildren() > 0 then
                    local hasText = false
                    for _, desc in ipairs(questUi:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.Text ~= "" and not desc.Text:lower():find("quest") then
                            hasText = true
                            break
                        end
                    end
                    return hasText
                end
            end
        end
        return false
    end

    -- ฟังก์ชันตรวจสอบว่าเควสปัจจุบันบนหน้าจอตรงกับเป้าหมายหรือไม่
    local function IsActiveQuestCorrect()
        local targetQuestInfo = GetCurrentQuestInfo()
        if not targetQuestInfo then return true end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local hud = playerGui:FindFirstChild("HUD")
            local questUi = hud and hud:FindFirstChild("Quest")
            if questUi and questUi.Visible then
                for _, desc in ipairs(questUi:GetDescendants()) do
                    if desc:IsA("TextLabel") and desc.Text ~= "" then
                        local textLower = desc.Text:lower()
                        for _, mName in ipairs(targetQuestInfo.Names) do
                            if textLower:find(mName:lower()) then
                                return true -- เควสตรงกันแล้ว
                            end
                        end
                    end
                end
            end
        end
        return false -- เควสไม่ตรง (เช่น ถือเควส 400 แต่จะไปตีมอน 450)
    end

    -- ฟังก์ชันยกเลิก/ลบเควสเก่าทิ้งผ่าน RemoteEvent
    local function AbandonCurrentQuest()
        pcall(function()
            local networkFolder = ReplicatedStorage:FindFirstChild("Network")
            if networkFolder then
                for _, remote in ipairs(networkFolder:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("AbandonQuest")
                        remote:FireServer("RemoveQuest")
                        remote:FireServer("CancelQuest")
                    end
                end
            end
        end)
    end

    local function SetupDeathHandler(character)
        isPlayerReadyToFarm = false
        currentTarget = nil
        isDoingQuest = false
    
        task.delay(2.8, function()
            if LocalPlayer.Character == character then
                isPlayerReadyToFarm = true
            end
        end)
    
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                isPlayerReadyToFarm = false
                currentTarget = nil
                isDoingQuest = false
            end)
        end
    end

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        SetupDeathHandler(newChar)
    end)

    if LocalPlayer.Character then
        SetupDeathHandler(LocalPlayer.Character)
    end

    -- เช็ก SafeZone ของมอนสเตอร์
    local function IsMonsterInsideSafeZoneFolder(monsterObj)
        local enemyRoot = monsterObj:FindFirstChild("HumanoidRootPart")
        if not enemyRoot or not ZonesFolder then return false end
    
        local monsterPos = enemyRoot.Position
        for _, zone in ipairs(ZonesFolder:GetChildren()) do
            if zone.Name == "SafeZone" and zone:IsA("BasePart") then
                local zonePos = zone.Position
                local zoneSize = zone.Size
                local minX, maxX = zonePos.X - (zoneSize.X / 2), zonePos.X + (zoneSize.X / 2)
                local minZ, maxZ = zonePos.Z - (zoneSize.Z / 2), zonePos.Z + (zoneSize.Z / 2)
            
                if (monsterPos.X >= minX and monsterPos.X <= maxX) and (monsterPos.Z >= minZ and monsterPos.Z <= maxZ) then
                    return true 
                end
            end
        end
        return false
    end

    -- ค้นหามอนสเตอร์เป้าหมายที่ผู้เล่นเลือกฟาร์ม (อิงตามชื่อที่เลือกใน Dropdown)
    local function GetTargetMonster()
        local closestMonster = nil
        local shortestDistance = math.huge
        local character = LocalPlayer.Character
        local selectedMonsters = GetSelectedMonsterNames()
    
        if #selectedMonsters == 0 then return nil end
    
        if character and character:FindFirstChild("HumanoidRootPart") and PlayerFolder then
            local myPos = character.HumanoidRootPart.Position
        
            for _, obj in ipairs(PlayerFolder:GetChildren()) do
                local isMatch = false
                for _, name in ipairs(selectedMonsters) do
                    if obj.Name == name or obj.Name:find(name) then
                        isMatch = true
                        break
                    end
                end
            
                if isMatch and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
                    local humanoid = obj:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 and not IsMonsterInsideSafeZoneFolder(obj) then
                        local distance = (obj.HumanoidRootPart.Position - myPos).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestMonster = obj
                        end
                    end
                end
            end
        end
        return closestMonster
    end

    -- ระบบ No Clip
    task.spawn(function()
        while true do
            if _G.SmoothHubConfig.EnableFarmMonster then
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
            RunService.Stepped:Wait()
        end
    end)

    -- ระบบปิดหน้าต่าง Daily Rewards อัตโนมัติ
    task.spawn(function()
        while true do
            task.wait(1)
            if _G.SmoothHubConfig.EnableFarmMonster then
                pcall(function()
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in ipairs(playerGui:GetDescendants()) do
                            if gui:IsA("TextLabel") and (gui.Text == "Daily Rewards" or gui.Text:find("Daily Reward")) then
                                local rewardFrame = gui:FindFirstAncestorWhichIsA("Frame") or gui:FindFirstAncestorWhichIsA("ImageLabel")
                                if rewardFrame then
                                    rewardFrame.Visible = false
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- ระบบสร้างกรอบ RGB ให้ตัวละคร
    local rgbHighlight = nil
    task.spawn(function()
        while true do
            task.wait(0.1)
            local character = LocalPlayer.Character
            if _G.SmoothHubConfig.EnableFarmMonster and character then
                if not rgbHighlight or rgbHighlight.Parent ~= character then
                    if rgbHighlight then rgbHighlight:Destroy() end
                    rgbHighlight = Instance.new("Highlight")
                    rgbHighlight.Name = "SmoothHubRGB"
                    rgbHighlight.Adornee = character
                    rgbHighlight.FillTransparency = 1
                    rgbHighlight.OutlineTransparency = 0
                    rgbHighlight.Parent = character
                end
            
                local hue = (tick() % 5) / 5
                rgbHighlight.OutlineColor = Color3.fromHSV(hue, 1, 1)
            else
                if rgbHighlight then
                    rgbHighlight:Destroy()
                    rgbHighlight = nil
                end
            end
        end
    end)

    -- ระบบบินไปรับเควสอัตโนมัติ (ตรวจสอบความถูกต้องของเควส ถือผิดอันจะทำการสละเควสแล้วไปรับใหม่)
    task.spawn(function()
        while true do
            task.wait(0.8)
            if not _G.SmoothHubConfig.EnableFarmMonster then continue end
            if not isPlayerReadyToFarm then continue end
            if _G.SmoothHubBossActive then continue end -- กำลังไปตีบอส พักฟาร์มมอนไว้ก่อน
        
            -- ถ้ามีเควสอยู่แล้วแต่ตรวจพบว่าไม่ตรงกับเป้าหมาย ให้ยกเลิกทิ้งทันที
            if HasActiveQuest() and not IsActiveQuestCorrect() then
                AbandonCurrentQuest()
                currentTarget = nil
                task.wait(0.8)
            end
        
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
            if rootPart and (not HasActiveQuest() or not IsActiveQuestCorrect()) and not isDoingQuest then
                isDoingQuest = true
            
                while (not HasActiveQuest() or not IsActiveQuestCorrect()) and isPlayerReadyToFarm and _G.SmoothHubConfig.EnableFarmMonster and not _G.SmoothHubBossActive do
                    local char = LocalPlayer.Character
                    local rp = char and char:FindFirstChild("HumanoidRootPart")
                    local questInfo = GetCurrentQuestInfo()
                
                    if not rp or not questInfo then break end
                
                    local targetCFrame = questInfo.CFrame - Vector3.new(0, 7, 0)
                    local distance = (targetCFrame.Position - rp.Position).Magnitude
                
                    if distance > 3 then
                        local direction = (targetCFrame.Position - rp.Position).Unit
                        local moveStep = math.min(FLY_SPEED * 0.016, distance)
                        rp.Velocity = direction * FLY_SPEED
                        rp.CFrame = rp.CFrame + (direction * moveStep)
                    else
                        rp.Velocity = Vector3.new(0, 0, 0)
                        rp.CFrame = targetCFrame
                    
                        pcall(function()
                            local networkFolder = ReplicatedStorage:FindFirstChild("Network")
                            local questTarget = ReplicatedStorage:FindFirstChild("Modules") 
                                and ReplicatedStorage.Modules:FindFirstChild("Client") 
                                and ReplicatedStorage.Modules.Client:FindFirstChild("TalkNpc") 
                                and ReplicatedStorage.Modules.Client.TalkNpc:FindFirstChild("Quests") 
                                and ReplicatedStorage.Modules.Client.TalkNpc.Quests[questInfo.QuestPathName] 
                                and ReplicatedStorage.Modules.Client.TalkNpc.Quests[questInfo.QuestPathName]:FindFirstChild("Quest")

                            if networkFolder and questTarget then
                                for _, remote in ipairs(networkFolder:GetChildren()) do
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer("RequestQuest", questTarget)
                                    end
                                end
                            end
                        end)
                    end
                
                    task.wait(0.02)
                end
            
                task.wait(0.01)
                isDoingQuest = false
            end
        end
    end)

    -- ลูปการบินไปฟาร์มมอนสเตอร์ หรือบินขึ้นไปลอยตัวหลบบนฟ้าตอนรอมอนเกิด
    task.spawn(function()
        while true do
            task.wait()
            if not _G.SmoothHubConfig.EnableFarmMonster then continue end
            if not isPlayerReadyToFarm then continue end
            if _G.SmoothHubBossActive then continue end -- กำลังไปตีบอส พักฟาร์มมอนไว้ก่อน
        
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
            -- ต้องมีเควสและเควสต้องถูกต้องตรงกันเท่านั้น ถึงจะเริ่มบินไปตีมอน
            if rootPart and HasActiveQuest() and IsActiveQuestCorrect() and not isDoingQuest then
                if currentTarget then
                    local currentHumanoid = currentTarget:FindFirstChildOfClass("Humanoid")
                    if not currentHumanoid or currentHumanoid.Health <= 0 or IsMonsterInsideSafeZoneFolder(currentTarget) then
                        currentTarget = nil 
                    end
                end
            
                if not currentTarget then
                    currentTarget = GetTargetMonster()
                end
            
                if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                    local enemyRoot = currentTarget.HumanoidRootPart
                
                    local posMode = _G.SmoothHubConfig.MonsterFarmPosition or "Down"
                    local offsetVector = Vector3.new(0, -6, 0)
                
                    if posMode == "Upper" then
                        offsetVector = Vector3.new(0, 6, 0)
                    end
                
                    local targetPosition = enemyRoot.Position + offsetVector
                
                    local distance = (targetPosition - rootPart.Position).Magnitude
                    if distance > 2 then
                        local direction = (targetPosition - rootPart.Position).Unit
                        local moveStep = math.min(FLY_SPEED * 0.016, distance)
                        rootPart.Velocity = direction * FLY_SPEED
                        rootPart.CFrame = CFrame.new(rootPart.CFrame.Position + (direction * moveStep), enemyRoot.Position)
                    else
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                        rootPart.CFrame = CFrame.new(targetPosition, enemyRoot.Position)
                    end
                else
                    local currentPos = rootPart.Position
                    local skyPosition = Vector3.new(currentPos.X, 400, currentPos.Z)
                
                    local skyDistance = (skyPosition - rootPart.Position).Magnitude
                    if skyDistance > 5 then
                        local direction = (skyPosition - rootPart.Position).Unit
                        local moveStep = math.min(FLY_SPEED * 0.016, skyDistance)
                        rootPart.Velocity = direction * FLY_SPEED
                        rootPart.CFrame = CFrame.new(rootPart.CFrame.Position + (direction * moveStep))
                    else
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                        rootPart.CFrame = CFrame.new(skyPosition)
                    end
                end
            end
        end
    end)

    -- ====================================
    -- ระบบกด E (สำหรับโจมตีอัตโนมัติ)
    -- ====================================
    local function pressE()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end

    local function performThreePresses()
        for i = 1, 5 do
            if not _G.SmoothHubConfig.EnableFarmMonster then break end
            pressE()
            if i < 5 then
                task.wait(0.5)
            end
        end
    end

    task.spawn(function()
        while true do
            if not _G.SmoothHubConfig.EnableFarmMonster then
                task.wait(0.5)
                continue
            end

            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
        
            task.wait(1)
            if _G.SmoothHubConfig.EnableFarmMonster then
                performThreePresses()
            end
        
            local isAlive = true
            local diedConnection
            diedConnection = humanoid.Died:Connect(function()
                isAlive = false
                if diedConnection then
                    diedConnection:Disconnect()
                end
            end)
        
            while isAlive and character.Parent and _G.SmoothHubConfig.EnableFarmMonster do
                task.wait(1)
            end
        end
    end)

    -- ระบบอัปเดต Status บน UI
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                if not _G.SmoothHubConfig.EnableFarmMonster then
                    if _G.MonsterStatusObj then
                        _G.MonsterStatusObj.SetText(OFF_TEXT, Color3.fromRGB(150, 165, 170))
                    end
                    return
                end

                local selectedNames = GetSelectedMonsterNames()
                if #selectedNames == 0 then
                    if _G.MonsterStatusObj then
                        _G.MonsterStatusObj.SetText("No Monster Selected", Color3.fromRGB(255, 180, 50))
                    end
                    return
                end

                if _G.MonsterStatusObj then
                    if not HasActiveQuest() or not IsActiveQuestCorrect() then
                        _G.MonsterStatusObj.SetText("Syncing Right Quest...", Color3.fromRGB(255, 180, 50))
                    elseif currentTarget and currentTarget.Name then
                        _G.MonsterStatusObj.SetText("Farming: " .. currentTarget.Name, Color3.fromRGB(40, 220, 100))
                    else
                        _G.MonsterStatusObj.SetText("Waiting/Hidden in Sky...", Color3.fromRGB(100, 200, 255))
                    end
                end
            end)
        end
    end)

    print("SmoothHub Monster Farm loaded")
end)


---------------------------------------------------------
-- ระบบ Boss Farm (รวมจากไฟล์ Farm Boss + รองรับ Noro)
-- อ่านค่าจากแท็บ Boss: EnableFarmBoss / BossSelection / BossFarmPosition
-- Noro (บอสเสก) มีความสำคัญสูงสุด: พอมีคนเสกขึ้นมา จะบินไปตีทันที แม้กำลังตีบอสตัวอื่นหรือฟาร์มมอนอยู่
---------------------------------------------------------
task.spawn(function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local LocalPlayer = Players.LocalPlayer

    local IncludeToGame = Workspace:WaitForChild("IncludeToGame", 5)
    local ZonesFolder = IncludeToGame and IncludeToGame:WaitForChild("Zones", 5)

    local FLY_SPEED = 200
    local currentBossTarget = nil
    local isPlayerReadyToFarm = false

    -- บอสเสก: ถ้าเลือกไว้และเกิดขึ้น จะถูกเลือกก่อนบอสอื่นเสมอ
    local SummonBosses = { ["noro"] = true }

    local function IsSummonBoss(name)
        local lower = name:lower()
        for summonName in pairs(SummonBosses) do
            if lower:find(summonName, 1, true) then
                return true
            end
        end
        return false
    end

    local function SetupDeathHandler(character)
        isPlayerReadyToFarm = false
        currentBossTarget = nil

        task.delay(2.8, function()
            if LocalPlayer.Character == character then
                isPlayerReadyToFarm = true
            end
        end)

        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                isPlayerReadyToFarm = false
                currentBossTarget = nil
            end)
        end
    end

    LocalPlayer.CharacterAdded:Connect(SetupDeathHandler)
    if LocalPlayer.Character then
        SetupDeathHandler(LocalPlayer.Character)
    end

    local function IsBossInsideSafeZone(bossObj)
        local enemyRoot = bossObj:FindFirstChild("HumanoidRootPart")
        if not enemyRoot or not ZonesFolder then return false end

        local bossPos = enemyRoot.Position
        for _, zone in ipairs(ZonesFolder:GetChildren()) do
            if zone.Name == "SafeZone" and zone:IsA("BasePart") then
                local zonePos = zone.Position
                local zoneSize = zone.Size
                local minX, maxX = zonePos.X - (zoneSize.X / 2), zonePos.X + (zoneSize.X / 2)
                local minZ, maxZ = zonePos.Z - (zoneSize.Z / 2), zonePos.Z + (zoneSize.Z / 2)

                if (bossPos.X >= minX and bossPos.X <= maxX) and (bossPos.Z >= minZ and bossPos.Z <= maxZ) then
                    return true
                end
            end
        end
        return false
    end

    -- ดึงรายชื่อบอสที่เลือกไว้ (ตัดส่วน [Summon] ออก)
    local function GetSelectedBossNames()
        local selectedList = {}
        local selection = _G.SmoothHubConfig.BossSelection
        if selection and type(selection) == "table" then
            for bossFullName, isSelected in pairs(selection) do
                if isSelected then
                    local cleanName = bossFullName:match("^(.-)%s*%[") or bossFullName
                    cleanName = cleanName:match("^%s*(.-)%s*$")
                    table.insert(selectedList, cleanName)
                end
            end
        end
        return selectedList
    end

    -- หาบอสที่ต้องตี: บอสเสก (Noro) มาก่อน ถ้าไม่มีค่อยเลือกตัวที่ใกล้ที่สุดจากบอสอื่น
    local function GetTargetBoss(onlySummon)
        local selectedBosses = GetSelectedBossNames()
        if #selectedBosses == 0 then return nil end

        local aiFolder = Workspace:FindFirstChild("AI/Player")
        local bossFolder = aiFolder and aiFolder:FindFirstChild("Boss")
        if not bossFolder then return nil end

        local character = LocalPlayer.Character
        local myRoot = character and character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end

        local closestSummon, summonDist = nil, math.huge
        local closestNormal, normalDist = nil, math.huge

        for _, obj in ipairs(bossFolder:GetChildren()) do
            local isMatch = false
            for _, name in ipairs(selectedBosses) do
                if obj.Name:lower():find(name:lower(), 1, true) then
                    isMatch = true
                    break
                end
            end

            local root = obj:FindFirstChild("HumanoidRootPart")
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if isMatch and root and humanoid and humanoid.Health > 0 and not IsBossInsideSafeZone(obj) then
                local distance = (root.Position - myRoot.Position).Magnitude
                if IsSummonBoss(obj.Name) then
                    if distance < summonDist then
                        summonDist = distance
                        closestSummon = obj
                    end
                elseif distance < normalDist then
                    normalDist = distance
                    closestNormal = obj
                end
            end
        end

        if onlySummon then return closestSummon end
        return closestSummon or closestNormal
    end

    -- No Clip ตอนฟาร์มบอส
    task.spawn(function()
        while true do
            if _G.SmoothHubConfig.EnableFarmBoss then
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
            RunService.Stepped:Wait()
        end
    end)

    -- ลูปบินไปหาบอส (ยังไม่มีบอส = ไม่ทำอะไร ปล่อยให้ฟาร์มมอนทำงานต่อได้)
    task.spawn(function()
        local lastSummonCheck = 0
        while true do
            task.wait()

            if not _G.SmoothHubConfig.EnableFarmBoss or not isPlayerReadyToFarm then
                _G.SmoothHubBossActive = false
                continue
            end

            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not rootPart then
                _G.SmoothHubBossActive = false
                continue
            end

            -- ล้างเป้าหมายที่ตายแล้ว / เข้าเซฟโซน
            if currentBossTarget then
                local hum = currentBossTarget:FindFirstChildOfClass("Humanoid")
                if not currentBossTarget.Parent or not hum or hum.Health <= 0 or IsBossInsideSafeZone(currentBossTarget) then
                    currentBossTarget = nil
                end
            end

            if not currentBossTarget then
                currentBossTarget = GetTargetBoss(false)
            elseif not IsSummonBoss(currentBossTarget.Name) and os.clock() - lastSummonCheck > 0.25 then
                -- กำลังตีบอสปกติอยู่ แต่ถ้ามี Noro โผล่ ให้สลับไปตีทันที
                lastSummonCheck = os.clock()
                local summonTarget = GetTargetBoss(true)
                if summonTarget then
                    currentBossTarget = summonTarget
                end
            end

            local bossRoot = currentBossTarget and currentBossTarget:FindFirstChild("HumanoidRootPart")
            if bossRoot then
                _G.SmoothHubBossActive = true

                local offsetVector = Vector3.new(0, -6, 0) -- Down
                if (_G.SmoothHubConfig.BossFarmPosition or "Down") == "Upper" then
                    offsetVector = Vector3.new(0, 6, 0)
                end

                local targetPosition = bossRoot.Position + offsetVector
                local distance = (targetPosition - rootPart.Position).Magnitude

                if distance > 2 then
                    local direction = (targetPosition - rootPart.Position).Unit
                    local moveStep = math.min(FLY_SPEED * 0.016, distance)
                    rootPart.Velocity = direction * FLY_SPEED
                    rootPart.CFrame = CFrame.new(rootPart.CFrame.Position + (direction * moveStep), bossRoot.Position)
                else
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                    rootPart.CFrame = CFrame.new(targetPosition, bossRoot.Position)
                end
            else
                _G.SmoothHubBossActive = false
            end
        end
    end)

    -- กรอบ RGB รอบตัวละครตอนฟาร์มบอส (แยกชื่อกับของฟาร์มมอน จะได้ไม่ชนกัน)
    local bossHighlight = nil
    task.spawn(function()
        while true do
            task.wait(0.1)
            local character = LocalPlayer.Character
            if _G.SmoothHubConfig.EnableFarmBoss and character then
                if not bossHighlight or bossHighlight.Parent ~= character then
                    if bossHighlight then bossHighlight:Destroy() end
                    bossHighlight = Instance.new("Highlight")
                    bossHighlight.Name = "SmoothHubRGBBoss"
                    bossHighlight.Adornee = character
                    bossHighlight.FillTransparency = 1
                    bossHighlight.OutlineTransparency = 0
                    bossHighlight.Parent = character
                end

                local hue = (tick() % 5) / 5
                bossHighlight.OutlineColor = Color3.fromHSV(hue, 1, 1)
            else
                if bossHighlight then
                    bossHighlight:Destroy()
                    bossHighlight = nil
                end
            end
        end
    end)

    -- กดปุ่ม E ซ้ำเพื่อโจมตี
    local function pressE()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end

    task.spawn(function()
        while true do
            if not _G.SmoothHubConfig.EnableFarmBoss then
                task.wait(0.5)
                continue
            end

            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")

            task.wait(1)
            for i = 1, 5 do
                if not _G.SmoothHubConfig.EnableFarmBoss then break end
                pressE()
                task.wait(0.5)
            end

            local isAlive = true
            local diedConnection
            diedConnection = humanoid.Died:Connect(function()
                isAlive = false
                if diedConnection then diedConnection:Disconnect() end
            end)

            while isAlive and character.Parent and _G.SmoothHubConfig.EnableFarmBoss do
                task.wait(1)
            end
        end
    end)

    -- อัปเดตสถานะบนแท็บ Boss
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                local status = _G.BossStatusObj
                if not status then return end

                if not _G.SmoothHubConfig.EnableFarmBoss then
                    status.SetText(OFF_TEXT, Color3.fromRGB(150, 165, 170))
                elseif #GetSelectedBossNames() == 0 then
                    status.SetText("No Boss Selected", Color3.fromRGB(255, 180, 50))
                elseif currentBossTarget and currentBossTarget.Name then
                    status.SetText("Farming Boss: " .. currentBossTarget.Name, Color3.fromRGB(255, 65, 88))
                else
                    status.SetText("Waiting for Boss Spawn...", Color3.fromRGB(100, 200, 255))
                end
            end)
        end
    end)

    print("SmoothHub Boss Farm loaded")
end)

---------------------------------------------------------
-- 🌾 Auto Farm Level (รวมมาจากไฟล์ Auto Farm Level เดิม)
-- อยู่ท้ายไฟล์เพื่อให้ใช้ _G.SmoothHubConfig / _G.SmoothHubStatus ที่ UI สร้างไว้ข้างบน
-- ห่อด้วย task.spawn เพื่อให้ตัวแปรแยกเป็นของตัวเอง ไม่ชนกับส่วนอื่น
-- และไม่ทำให้ UI ต้องรอ WaitForChild ของ Auto Farm
---------------------------------------------------------
task.spawn(function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local player = Players.LocalPlayer
    local LocalPlayer = Players.LocalPlayer

    local PlayerFolder = Workspace:WaitForChild("AI/Player", 5)
    local IncludeToGame = Workspace:WaitForChild("IncludeToGame", 5)
    local ZonesFolder = IncludeToGame and IncludeToGame:WaitForChild("Zones", 5)

    -- กำหนดค่าพิกัด เควส และรายชื่อมอนสเตอร์เป้าหมายตามช่วงเลเวล
    local QuestConfig = {
        new1 = {
            CFrame = CFrame.new(84.4766235, 4.73149872, -26.2268448, -0.991879344, 0, 0.127182722, 0, 1, 0, -0.127182722, 0, -0.991879344),
            QuestPathName = "QuestGiver (Lv.1-Lv.50)",
            TargetMonsterNames = {"Human", "Athlete"}
        },
        Lv50 = {
            CFrame = CFrame.new(422.288239, 4.73097706, -362.139801, 0, 0, 1, 0, 1, -0, -1, 0, 0),
            QuestPathName = "QuestGiver (Lv.50-Lv.150)",
            TargetMonsterNames = {"Rank 2 Investigator"}
        },
        Lv150 = { 
            CFrame = CFrame.new(404.266632, 4.7305007, 564.892761, 0, 0, 1, 0, 1, -0, -1, 0, 0),
            QuestPathName = "QuestGiver (Lv.150-Lv.250)",
            TargetMonsterNames = {"Bulk Ghoul"}
        },
        Lv250 = { 
            CFrame = CFrame.new(-210.106567, 4.73097706, -375.544891, 0.149021685, -0, -0.988834023, 0, 1, -0, 0.988834023, 0, 0.149021685),
            QuestPathName = "QuestGiver (Lv.250-Lv.350)",
            TargetMonsterNames = {"Rank 1 Investigator"}
        },
        Lv350 = { 
            CFrame = CFrame.new(-80.2059937, 4.72720528, 624.273926, 0, 0, -1, 0, 1, 0, 1, 0, 0),
            QuestPathName = "QuestGiver (Lv.350-Lv.400)",
            TargetMonsterNames = {"Serpent Ghoul"}
        },
        Lv400 = { 
            CFrame = CFrame.new(503.120239, 4.72720814, 1168.27417, -1, 0, 0, 0, 1, 0, 0, 0, -1),
            QuestPathName = "QuestGiver (Lv.400-Lv.450)",
            TargetMonsterNames = {"Rin Ghoul"}
        },
        Lv450 = { 
            CFrame = CFrame.new(29.4314117, 4.7277298, 1001.64832, 0, 0, -1, 0, 1, 0, 1, 0, 0),
            QuestPathName = "QuestGiver (Lv.450-Lv.500)",
            TargetMonsterNames = {"First class Investigator"}
        },
        Lv500 = { 
            CFrame = CFrame.new(5.03494263, 4.72723007, 1281.78027, 0, 0, -1, 0, 1, 0, 1, 0, 0),
            QuestPathName = "QuestGiver (Lv.500-Lv.550)",
            TargetMonsterNames = {"Aogiri"}
        },
        Lv550 = { 
            CFrame = CFrame.new(-289.776611, 4.72723007, 1107.37622, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            QuestPathName = "QuestGiver (Lv.550-Lv.600)",
            TargetMonsterNames = {"Akira"}
        },
        Lv600 = { 
            CFrame = CFrame.new(917.967651, 4.7309761, 439.671967, 0, 0, 1, 0, 1, -0, -1, 0, 0),
            QuestPathName = "QuestGiver (Lv.600-Lv.700)",
            TargetMonsterNames = {"Enforcer"}
        },
        Lv700 = { 
            CFrame = CFrame.new(834.595703, 4.73150063, -409.343506, 0, 0, 1, 0, 1, -0, -1, 0, 0),
            QuestPathName = "QuestGiver (Lv.700-Lv.800)",
            TargetMonsterNames = {"Phantom"}
        },
        Lv800 = { 
            CFrame = CFrame.new(524.200989, 4.44271612, -292.036652, -1, 0, 0, 0, 1, 0, 0, 0, -1),
            QuestPathName = "QuestGiver (Lv.800-Lv.900)",
            TargetMonsterNames = {"Fighter Ghoul"}
        },
        Lv900 = { 
            CFrame = CFrame.new(684.235596, 4.42999983, 690.85791, 0, 0, -1, 0, 1, 0, 1, 0, 0),
            QuestPathName = "QuestGiver (Lv.900-Lv.1000)",
            TargetMonsterNames = {"Sparkling Wing Ghoul"}
        },
        Lv1000 = { 
            CFrame = CFrame.new(1034.88269, 4.83298349, 651.943848, -1, 0, 0, 0, 1, 0, 0, 0, -1),
            QuestPathName = "QuestGiver (Lv.1000-Lv.1100)",
            TargetMonsterNames = {"Factor"}
        },
        Lv1100 = { 
            CFrame = CFrame.new(708.203613, 4.73383665, 1255.29858, 1, 0, 0, 0, 1, 0, 0, 0, 1),
            QuestPathName = "QuestGiver (Lv.1100-Lv.1200)",
            TargetMonsterNames = {"Faulty Tatara Ghoul"}
        }
    }

    local FLY_SPEED = 250
    local currentTarget = nil 
    local isDoingQuest = false
    local isPlayerReadyToFarm = false

    -- ฟังก์ชันเช็กเลเวลผู้เล่นจากโฟลเดอร์ Data โดยตรง
    local function GetPlayerLevel()
        local success, level = pcall(function()
            local dataFolder = LocalPlayer:FindFirstChild("Data")
            if dataFolder then
                local levelStat = dataFolder:FindFirstChild("Level") or dataFolder:FindFirstChild("Lv")
                if levelStat and (levelStat:IsA("IntValue") or levelStat:IsA("NumberValue")) then
                    return levelStat.Value
                end
            end

            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in ipairs(leaderstats:GetChildren()) do
                    if stat.Name:lower():find("level") or stat.Name:lower():find("lv") then
                        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                            return stat.Value
                        end
                    end
                end
            end

            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in ipairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextLabel") and gui.Text:lower():find("level") then
                        local num = tonumber(gui.Text:match("%d+"))
                        if num then return num end
                    end
                end
            end
        end)

        if success and level then
            return level
        end
        return 1
    end

    -- ฟังก์ชันเช็กว่ามีเควสอยู่หรือไม่
    local function HasActiveQuest()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local hud = playerGui:FindFirstChild("HUD")
            local questUi = hud and hud:FindFirstChild("Quest")
            if questUi then
                if questUi.Visible or #questUi:GetChildren() > 0 then
                    local hasText = false
                    for _, desc in ipairs(questUi:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.Text ~= "" and not desc.Text:lower():find("quest") then
                            hasText = true
                            break
                        end
                    end
                    return hasText
                end
            end
        end
        return false
    end

    -- ฟังก์ชันเลือกข้อมูลเควสตามเลเวลปัจจุบัน
    local function GetCurrentQuestInfo()
        if currentTarget and currentTarget.Name then
            for _, qData in pairs(QuestConfig) do
                for _, mName in ipairs(qData.TargetMonsterNames) do
                    if currentTarget.Name:lower() == mName:lower() or currentTarget.Name:lower():find(mName:lower()) then
                        return qData
                    end
                end
            end
        end

        local level = GetPlayerLevel()

        if level >= 1100 then return QuestConfig.Lv1100
        elseif level >= 1000 then return QuestConfig.Lv1000
        elseif level >= 900 then return QuestConfig.Lv900
        elseif level >= 800 then return QuestConfig.Lv800
        elseif level >= 700 then return QuestConfig.Lv700
        elseif level >= 600 then return QuestConfig.Lv600
        elseif level >= 550 then return QuestConfig.Lv550
        elseif level >= 500 then return QuestConfig.Lv500
        elseif level >= 450 then return QuestConfig.Lv450
        elseif level >= 400 then return QuestConfig.Lv400
        elseif level >= 350 then return QuestConfig.Lv350
        elseif level >= 250 then return QuestConfig.Lv250
        elseif level >= 150 then return QuestConfig.Lv150
        elseif level >= 50 then return QuestConfig.Lv50
        else return QuestConfig.new1
        end
    end

    -- ฟังก์ชันตรวจสอบว่าเควสปัจจุบันบนหน้าจอตรงกับเป้าหมายหรือไม่
    local function IsActiveQuestCorrect()
        local targetQuestInfo = GetCurrentQuestInfo()
        if not targetQuestInfo then return true end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local hud = playerGui:FindFirstChild("HUD")
            local questUi = hud and hud:FindFirstChild("Quest")
            if questUi and questUi.Visible then
                for _, desc in ipairs(questUi:GetDescendants()) do
                    if desc:IsA("TextLabel") and desc.Text ~= "" then
                        local textLower = desc.Text:lower()
                        for _, mName in ipairs(targetQuestInfo.TargetMonsterNames) do
                            if textLower:find(mName:lower()) then
                                return true 
                            end
                        end
                    end
                end
            end
        end
        return false 
    end

    -- ฟังก์ชันยกเลิก/ลบเควสเก่าทิ้งผ่าน RemoteEvent
    local function AbandonCurrentQuest()
        pcall(function()
            local networkFolder = ReplicatedStorage:FindFirstChild("Network")
            if networkFolder then
                for _, remote in ipairs(networkFolder:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("AbandonQuest")
                        remote:FireServer("RemoveQuest")
                        remote:FireServer("CancelQuest")
                    end
                end
            end
        end)
    end

    -- จัดการการตายและจับเวลาเกิดใหม่
    local function SetupDeathHandler(character)
        isPlayerReadyToFarm = false
        currentTarget = nil
        isDoingQuest = false

        task.delay(2.8, function()
            if LocalPlayer.Character == character then
                isPlayerReadyToFarm = true
            end
        end)

        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                isPlayerReadyToFarm = false
                currentTarget = nil
                isDoingQuest = false
            end)
        end
    end

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        SetupDeathHandler(newChar)
    end)

    if LocalPlayer.Character then
        SetupDeathHandler(LocalPlayer.Character)
    end

    -- ระบบกรอบเรืองแสงเฉพาะเส้นขอบ (RGB Outline)
    task.spawn(function()
        local success, parentFolder = pcall(function()
            return CoreGui
        end)
        if not success or not parentFolder then
            parentFolder = LocalPlayer:WaitForChild("PlayerGui")
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "SmoothHubRGBOutline"
        highlight.FillTransparency = 1 
        highlight.OutlineTransparency = 0 
        highlight.Adornee = nil
        highlight.Parent = parentFolder

        LocalPlayer.CharacterAdded:Connect(function(newCharacter)
            highlight.Adornee = newCharacter
        end)

        if LocalPlayer.Character then
            highlight.Adornee = LocalPlayer.Character
        end

        RunService.RenderStepped:Connect(function()
            if not _G.SmoothHubConfig.AutoFarmLevel then
                highlight.Adornee = nil
                return
            end

            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                if highlight.Adornee ~= character then
                    highlight.Adornee = character
                end
                local hue = tick() % 5 / 5
                local rgbColor = Color3.fromHSV(hue, 1, 1)
                highlight.OutlineColor = rgbColor
            else
                highlight.Adornee = nil
            end
        end)
    end)

    -- ปิดเฉพาะหน้าต่าง Daily Rewards
    task.spawn(function()
        while true do
            task.wait(1)
            if _G.SmoothHubConfig.AutoFarmLevel then
                pcall(function()
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in ipairs(playerGui:GetDescendants()) do
                            if gui:IsA("TextLabel") and (gui.Text == "Daily Rewards" or gui.Text:find("Daily Reward")) then
                                local rewardFrame = gui:FindFirstAncestorWhichIsA("Frame") or gui:FindFirstAncestorWhichIsA("ImageLabel")
                                if rewardFrame then
                                    rewardFrame.Visible = false
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- เช็ก SafeZone
    local function IsMonsterInsideSafeZoneFolder(monsterObj)
        local enemyRoot = monsterObj:FindFirstChild("HumanoidRootPart")
        if not enemyRoot or not ZonesFolder then return false end

        local monsterPos = enemyRoot.Position
    	for _, zone in ipairs(ZonesFolder:GetChildren()) do
    		if zone.Name == "SafeZone" and zone:IsA("BasePart") then
    			local zonePos = zone.Position
    			local zoneSize = zone.Size
    			local minX, maxX = zonePos.X - (zoneSize.X / 2), zonePos.X + (zoneSize.X / 2)
    			local minZ, maxZ = zonePos.Z - (zoneSize.Z / 2), zonePos.Z + (zoneSize.Z / 2)

    			if (monsterPos.X >= minX and monsterPos.X <= maxX) and (monsterPos.Z >= minZ and monsterPos.Z <= maxZ) then
    				return true 
    			end
    		end
    	end
        return false
    end

    -- ค้นหามอนสเตอร์ตามเป้าหมายปัจจุบัน
    local function GetTargetMonster()
        local closestMonster = nil
        local shortestDistance = math.huge
        local character = LocalPlayer.Character
        local questInfo = GetCurrentQuestInfo()
        local targetNames = questInfo.TargetMonsterNames

        if character and character:FindFirstChild("HumanoidRootPart") and PlayerFolder then
            local myPos = character.HumanoidRootPart.Position

            for _, obj in ipairs(PlayerFolder:GetChildren()) do
                local isMatch = false
                for _, name in ipairs(targetNames) do
                    if obj.Name == name or obj.Name:find(name) then
                        isMatch = true
                        break
                    end
                end

                if isMatch and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
                    local humanoid = obj:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 and not IsMonsterInsideSafeZoneFolder(obj) then
                        local distance = (obj.HumanoidRootPart.Position - myPos).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestMonster = obj
                        end
                    end
                end
            end
        end
        return closestMonster
    end

    -- No Clip
    task.spawn(function()
        while true do
            if _G.SmoothHubConfig.AutoFarmLevel then
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
            RunService.Stepped:Wait()
        end
    end)

    -- ลูปจัดการเควส
    task.spawn(function()
        while true do
            task.wait(0.8)
            if not _G.SmoothHubConfig.AutoFarmLevel then continue end
            if not isPlayerReadyToFarm then continue end

            if HasActiveQuest() and not IsActiveQuestCorrect() then
                AbandonCurrentQuest()
                currentTarget = nil
                task.wait(0.8)
            end

            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if rootPart and (not HasActiveQuest() or not IsActiveQuestCorrect()) and not isDoingQuest then
                isDoingQuest = true

                while (not HasActiveQuest() or not IsActiveQuestCorrect()) and isPlayerReadyToFarm and _G.SmoothHubConfig.AutoFarmLevel do
                    local char = LocalPlayer.Character
                    local rp = char and char:FindFirstChild("HumanoidRootPart")
                    local questInfo = GetCurrentQuestInfo()

                    if not rp or not questInfo then break end

                    local targetCFrame = questInfo.CFrame - Vector3.new(0, 7, 0)
                    local distance = (targetCFrame.Position - rp.Position).Magnitude

                    if distance > 3 then
                        local direction = (targetCFrame.Position - rp.Position).Unit
                        local moveStep = math.min(FLY_SPEED * 0.016, distance)
                        rp.Velocity = direction * FLY_SPEED
                        rp.CFrame = rp.CFrame + (direction * moveStep)
                    else
                        rp.Velocity = Vector3.new(0, 0, 0)
                        rp.CFrame = targetCFrame

                        pcall(function()
                            local networkFolder = ReplicatedStorage:FindFirstChild("Network")
                            local questTarget = ReplicatedStorage:FindFirstChild("Modules") 
                                and ReplicatedStorage.Modules:FindFirstChild("Client") 
                                and ReplicatedStorage.Modules.Client:FindFirstChild("TalkNpc") 
                                and ReplicatedStorage.Modules.Client.TalkNpc:FindFirstChild("Quests") 
                                and ReplicatedStorage.Modules.Client.TalkNpc.Quests[questInfo.QuestPathName] 
                                and ReplicatedStorage.Modules.Client.TalkNpc.Quests[questInfo.QuestPathName]:FindFirstChild("Quest")

                            if networkFolder and questTarget then
                                for _, remote in ipairs(networkFolder:GetChildren()) do
                                    if remote:IsA("RemoteEvent") then
                                        remote:FireServer("RequestQuest", questTarget)
                                    end
                                end
                            end
                        end)
                    end

                    task.wait(0.02)
                end

                task.wait(0.01)
                isDoingQuest = false
            end
        end
    end)

    -- ลูปฟาร์มมอนสเตอร์ + รองรับ FarmingDirection (Upper / Down)
    task.spawn(function()
        while true do
            task.wait()
            if not _G.SmoothHubConfig.AutoFarmLevel then continue end

            if not isPlayerReadyToFarm then
                continue
            end

            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if rootPart and HasActiveQuest() and IsActiveQuestCorrect() and not isDoingQuest then
                if currentTarget then
                    local currentHumanoid = currentTarget:FindFirstChildOfClass("Humanoid")
                    if not currentHumanoid or currentHumanoid.Health <= 0 or IsMonsterInsideSafeZoneFolder(currentTarget) then
                        currentTarget = nil 
                    end
                end

                if not currentTarget then
                    currentTarget = GetTargetMonster()
                end

                if currentTarget and currentTarget:FindFirstChild("HumanoidRootPart") then
                    local enemyRoot = currentTarget.HumanoidRootPart

                    -- ดึงค่าทิศทางที่เลือกจาก UI ผ่านตัวแปร FarmingDirection
                    local farmPosType = _G.SmoothHubConfig.FarmingDirection or "Upper"
                    local offsetHeight = 6

                    local targetPosition
                    if farmPosType == "Upper" then
                        targetPosition = enemyRoot.Position + Vector3.new(0, offsetHeight, 0)
                    else
                        targetPosition = enemyRoot.Position - Vector3.new(0, offsetHeight, 0)
                    end

                    local distance = (targetPosition - rootPart.Position).Magnitude
                    if distance > 2 then
                        local direction = (targetPosition - rootPart.Position).Unit
                        local moveStep = math.min(FLY_SPEED * 0.016, distance)
                        rootPart.Velocity = direction * FLY_SPEED
                        rootPart.CFrame = CFrame.new(rootPart.CFrame.Position + (direction * moveStep), enemyRoot.Position)
                    else
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                        rootPart.CFrame = CFrame.new(targetPosition, enemyRoot.Position)
                    end
                else
                    local currentPos = rootPart.Position
                    local skyPosition = Vector3.new(currentPos.X, 400, currentPos.Z)

                    local skyDistance = (skyPosition - rootPart.Position).Magnitude
                    if skyDistance > 5 then
                        local direction = (skyPosition - rootPart.Position).Unit
                        local moveStep = math.min(FLY_SPEED * 0.016, skyDistance)
                        rootPart.Velocity = direction * FLY_SPEED
                        rootPart.CFrame = CFrame.new(rootPart.CFrame.Position + (direction * moveStep))
                    else
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                        rootPart.CFrame = CFrame.new(skyPosition)
                    end
                end
            else
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)

    -- ระบบกด E
    local function pressE()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end

    local function performThreePresses()
        for i = 1, 5 do
            if not _G.SmoothHubConfig.AutoFarmLevel then break end
            pressE()
            if i < 5 then
                task.wait(0.5)
            end
        end
    end

    task.spawn(function()
        while true do
            if not _G.SmoothHubConfig.AutoFarmLevel then
                task.wait(0.5)
                continue
            end

            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")

            task.wait(1)
            if _G.SmoothHubConfig.AutoFarmLevel then
                performThreePresses()
            end

            local isAlive = true
            local diedConnection
            diedConnection = humanoid.Died:Connect(function()
                isAlive = false
                if diedConnection then
                    diedConnection:Disconnect()
                end
            end)

            while isAlive and character.Parent and _G.SmoothHubConfig.AutoFarmLevel do
                task.wait(1)
            end
        end
    end)

    -- ระบบอัปเดต Status ส่งตรงไปที่หน้าจอ UI (_G.SmoothHubStatus.FarmStatusLabel)
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                if not _G.SmoothHubConfig.AutoFarmLevel then
                    if _G.SmoothHubStatus and _G.SmoothHubStatus.FarmStatusLabel then
                        _G.SmoothHubStatus.FarmStatusLabel.Text = "off"
                    end
                    return
                end

                local questInfo = GetCurrentQuestInfo()
                local spotRange = "Unknown"

                if questInfo == QuestConfig.new1 then spotRange = "lvl 1-50"
                elseif questInfo == QuestConfig.Lv50 then spotRange = "lvl 50-150"
                elseif questInfo == QuestConfig.Lv150 then spotRange = "lvl 150-250"
                elseif questInfo == QuestConfig.Lv250 then spotRange = "lvl 250-350"
                elseif questInfo == QuestConfig.Lv350 then spotRange = "lvl 350-400"
                elseif questInfo == QuestConfig.Lv400 then spotRange = "lvl 400-450"
                elseif questInfo == QuestConfig.Lv450 then spotRange = "lvl 450-500"
                elseif questInfo == QuestConfig.Lv500 then spotRange = "lvl 500-550"
                elseif questInfo == QuestConfig.Lv550 then spotRange = "lvl 550-600"
                elseif questInfo == QuestConfig.Lv600 then spotRange = "lvl 600-700"
                elseif questInfo == QuestConfig.Lv700 then spotRange = "lvl 700-800"
                elseif questInfo == QuestConfig.Lv800 then spotRange = "lvl 800-900"
                elseif questInfo == QuestConfig.Lv900 then spotRange = "lvl 900-1000"
                elseif questInfo == QuestConfig.Lv1000 then spotRange = "lvl 1000-1100"
                elseif questInfo == QuestConfig.Lv1100 then spotRange = "lvl 1100-1200"
                end

                local targetName = "Unknown"
                if currentTarget and currentTarget.Name then
                    targetName = currentTarget.Name
                else
                    if questInfo and questInfo.TargetMonsterNames and #questInfo.TargetMonsterNames > 0 then
                        targetName = questInfo.TargetMonsterNames[1]
                    end
                end

                local countText = "0/6"
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local hud = playerGui:FindFirstChild("HUD")
                    local questUi = hud and hud:FindFirstChild("Quest")
                    if questUi and questUi.Visible then
                        for _, desc in ipairs(questUi:GetDescendants()) do
                            if desc:IsA("TextLabel") and desc.Text ~= "" then
                                local txt = desc.Text
                                if txt:match("%d+/%d+") then
                                    countText = txt:match("%d+/%d+")
                                    break
                                end
                            end
                        end
                    end
                end

                if _G.SmoothHubStatus and _G.SmoothHubStatus.FarmStatusLabel then
                    if not HasActiveQuest() or not IsActiveQuestCorrect() then
                        _G.SmoothHubStatus.FarmStatusLabel.Text = "Syncing Quest..."
                    elseif not currentTarget then
                        _G.SmoothHubStatus.FarmStatusLabel.Text = "Waiting in Sky..."
                    else
                        _G.SmoothHubStatus.FarmStatusLabel.Text = "[" .. targetName .. "] " .. countText
                    end
                end
            end)
        end
    end)

    print("SmoothHub Auto Farm Level Integrated Successfully!")
end)
