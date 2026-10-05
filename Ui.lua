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
    ConflictGuard = true, -- เปิดหลายฟังก์ชันพร้อมกันได้ ระบบจะสลับคิวให้ไม่แย่งตัวละครกัน
    FarmPriorityFirst = true, -- เลเวลต่ำกว่า 200: ไปฟาร์ม Chest Mimic ก่อน (รับของให้เสร็จ) แล้วค่อยกลับมาฟาร์มเควสปกติ
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
    WorldBossJoinDelay = 10,  -- วินาที
    -- Auto Skill tab (Z / X / C / V)
    Skill = {
        Master = false,
        RequireEnemy = true,
        Z = { Enabled = false, Mode = "Instant", Delay = 5 },
        X = { Enabled = false, Mode = "Instant", Delay = 5 },
        C = { Enabled = false, Mode = "Instant", Delay = 5 },
        V = { Enabled = false, Mode = "Instant", Delay = 5 },
    },
    -- Item tab
    Item = { Chest = false, Flower = false, Quest = { Enabled = false, Pick = "Auto", Picks = {}, Position = "Upper" } },
    -- Shop tab (Auto Buy Mask) : Masks = ชื่อหน้ากากตามลำดับที่ติ๊ก, Delay = วินาทีระหว่างการซื้อแต่ละชิ้น
    Shop = { AutoBuy = false, Masks = {}, Delay = 1 },
    -- Crafting tab : ซื้ออาวุธ Ghoul/CCG + Auto Craft (Items = ชื่อตามลำดับที่ติ๊ก)
    Crafting = {
        GhoulWeapons = { AutoBuy = false, Items = {}, Delay = 1, Retry = true, RetryDelay = 30, Bought = {} },
        CCGWeapons   = { AutoBuy = false, Items = {}, Delay = 1, Retry = true, RetryDelay = 30, Bought = {} },
        Craft        = { AutoCraft = false, Items = {}, Delay = 5 },
    },
    -- Black Market tab : Delay = วินาทีก่อนกลับไปคุยซ้ำ, PauseFarms = พักฟาร์มมอน/บอสชั่วคราวตอนบินไปคุย
    BlackMarket = {
        Enabled = false, Delay = 30, PauseFarms = true,
        AutoBuy = false,              -- เปิดร้านแล้วซื้อของที่ความหายากตรงกับที่ติ๊กไว้
        Rarities = {},                -- { Legendary = true, Mythical = true, ... }
        BuyMethod = "Click Button",   -- "Click Button" = กดปุ่ม BUY / "Remote" = ส่งคำสั่งซื้อตรง
    },
    -- Dungeon tab : Dungeon / Mode / Access = ตัวเลือกในหน้าต่าง Create Gate ของ NPC Gate Keeper
    Dungeon = {
        AutoCreate = false,   -- สร้างเกตซ้ำอัตโนมัติ
        Dungeon = "Raid",     -- ตอนนี้ปลดล็อกแค่ Raid
        Mode = "Normal",      -- "Normal" / "Infinite"
        Access = "Public",    -- "Public" / "Solo" / "Allies"
        Delay = 60,           -- วินาทีก่อนสร้างซ้ำ (10 - 900)
        PauseFarms = true,    -- พักฟาร์มมอน/บอสชั่วคราวตอนบินไปคุย
    },
    -- PVP tab
    PVP = {
        Aimbot = {
            Enabled = false,
            Mode = "Hold Right Click",   -- "Hold Right Click" / "Always On"
            Part = "Head",               -- "Head" / "HumanoidRootPart" / "Closest Part"
            FOV = 150,
            ShowFOV = true,
            Smooth = 30,                 -- 1 - 100
            MaxDist = 500,
            TeamCheck = true,
            WallCheck = true,
        },
        Bounty = {
            Enabled = false,
            MinBounty = 0,
            Position = "Behind",         -- "Behind" / "Above" / "Below"
            Distance = 4,
            FlySpeed = 250,
            SkipSafeZone = true,
            SkipAura = true,
            LevelFilter = true,
            LevelRange = 10,
            MoveMode = "Teleport",       -- "Teleport" (ล็อกตำแหน่งแบบเดิม) / "Fly"
            NoDamageTime = 5,            -- ตีเท่านี้วิแล้วเลือดไม่ลด = คิดว่าปิด PVP
            PvpOffTime = 120,            -- ข้ามคนที่ปิด PVP กี่วินาที
            OnlySelected = false,        -- true = ล่าเฉพาะคนที่ติ๊กเลือก
            OnlyPlayers = {},            -- ชื่อผู้เล่นที่ติ๊กไว้
            TeamCheck = true,
        },
        ESP = {
            Enabled = false,
            Chams = true, Name = true, Distance = true, Health = true,
            Level = true, Bounty = true, Aura = true, Tracers = false,
            TeamCheck = true,
            MaxDist = 2000,
        },
    },
    -- Auto Equip Best tab : Focus = สายที่เน้น, Types = ประเภทของที่ให้สวม, Enabled = โหมดเช็กอัตโนมัติ
    Equip = {
        Enabled = false, Interval = 30, ReEquipOnRespawn = false,
        Focus = "Damage",   -- "Damage" / "Defense (Durability)" / "Speed" / "Stamina" / "Balanced (All)"
        Types = { Hat = true, Face = true, Aura = true, Accessory = true, Cape = true },
        AutoTypes = true,    -- สวมประเภทอื่นที่รู้ว่าเป็นของสวมใส่ให้ด้วย
        TryUnknown = false,  -- ลองกดประเภทที่ไม่รู้จัก (เสี่ยง)
    },
}
_G.SmoothHubStatus = {
    FarmStatusLabel = nil,
    StatsStatusLabel = nil,
    StatsStatusLabelDashboard = nil,
    MonsterStatusLabel = nil,
    BossStatusLabel = nil
}
-- สถานะสดของแต่ละแท็บ (ใช้แสดงรวมในหน้า Status)
-- SmoothHubLive[key] = ข้อความสถานะล่าสุด / SmoothHubLiveKeys[label] = key ของ label นั้น
_G.SmoothHubLive = {}
_G.SmoothHubLiveKeys = setmetatable({}, { __mode = "k" })

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

---------------------------------------------------------
-- 🛡️ Conflict Guard : เปิดหลายฟังก์ชันพร้อมกันได้ ไม่แย่งตัวละครกัน
-- ลำดับความสำคัญ (บนสุดทำก่อน):
--   1) Dungeon / Black Market (ไปคุย NPC)  2) Item (Chest / Flower / Quest Board)
--   3) Boss Farm (ตอนมีบอสให้ตี)           4) Monster Farm
--   5) Auto Farm Level                     6) Auto Farm RC (PVP ค่าหัว)
-- ฟังก์ชันที่ไม่ขยับตัวละคร (Auto Skill / Fast Attack / ซื้อของ / คราฟ / ESP ฯลฯ) ทำงานคู่กันได้ตลอด
-- ตัวที่ถูกพักจะ "ไม่ถูกปิดสวิตช์" แค่รอคิว แล้วกลับมาทำเองเมื่อตัวที่สำคัญกว่าทำเสร็จ
---------------------------------------------------------
_G.SmoothHubArb = {}
do
    local Arb = _G.SmoothHubArb

    local function Has(t)
        return type(t) == "table" and next(t) ~= nil
    end

    local function ItemsBusy()
        return _G.SmoothHubItemWorking == true or os.clock() < (_G.SmoothHubItemBusyUntil or 0)
    end

    -- ฟาร์มตัวไหนที่ผู้ใช้เปิดไว้และตั้งค่าพร้อมทำงาน (ใช้ค่าจริงในสวิตช์)
    local function Claims()
        local cfg = _G.SmoothHubConfig
        return {
            Boss = cfg.EnableFarmBoss and Has(cfg.BossSelection) and true or false,
            Monster = cfg.EnableFarmMonster and Has(cfg.MonsterSelection) and true or false,
            Level = cfg.AutoFarmLevel and true or false,
        }
    end

    -- key = "EnableFarmBoss" / "EnableFarmMonster" / "AutoFarmLevel"
    -- คืน true เมื่อสวิตช์เปิดอยู่ "และ" ตอนนี้ถึงคิวของฟังก์ชันนี้
    function Arb.FarmOn(key)
        local cfg = _G.SmoothHubConfig
        if not cfg[key] then return false end
        if not cfg.ConflictGuard then return true end

        -- Item (Chest / Flower / Quest) กำลังทำงาน: ฟาร์มทุกตัวรอก่อน
        if ItemsBusy() then return false end

        if key == "AutoFarmLevel" then
            -- Monster Farm ที่ตั้งค่าไว้แล้ว และบอสที่กำลังตี มาก่อน Auto Farm Level
            if _G.SmoothHubBossActive then return false end
            if cfg.EnableFarmMonster and Has(cfg.MonsterSelection) then return false end
        end
        return true
    end

    -- Auto Farm RC (PVP): ทำเมื่อไม่มีฟาร์ม PVE ตัวไหนเปิดอยู่เท่านั้น
    function Arb.BountyOn()
        local cfg = _G.SmoothHubConfig
        if not cfg.ConflictGuard then return true end
        if ItemsBusy() or _G.SmoothHubBossActive then return false end
        local c = Claims()
        if c.Boss or c.Monster or c.Level then return false end
        return true
    end

    -- ข้อความบอกว่าตอนนี้ใครคุมตัวละคร (ไว้โชว์ใน Dashboard)
    function Arb.Owner()
        local cfg = _G.SmoothHubConfig
        if _G.SmoothHubYieldToItems and not ItemsBusy() then
            local ok, yielding = pcall(_G.SmoothHubYieldToItems)
            if ok and yielding then return "NPC visit (Dungeon / Black Market)" end
        end
        if ItemsBusy() then return "Item (Chest / Flower / Quest)" end
        if _G.SmoothHubBossActive then return "Boss Farm" end
        local c = Claims()
        if c.Monster then return "Monster Farm" end
        if c.Level then return "Auto Farm Level" end
        if c.Boss then return "Boss Farm (waiting for a boss)" end
        local pvp = cfg.PVP and cfg.PVP.Bounty
        if pvp and pvp.Enabled then return "Auto Farm RC" end
        return "-"
    end

    -- รายชื่อฟาร์มที่เปิดอยู่แต่กำลังรอคิว
    function Arb.Waiting()
        local cfg = _G.SmoothHubConfig
        local list = {}
        if not cfg.ConflictGuard then return list end
        local c = Claims()
        if c.Level and not Arb.FarmOn("AutoFarmLevel") then table.insert(list, "Auto Farm Level") end
        local pvp = cfg.PVP and cfg.PVP.Bounty
        if pvp and pvp.Enabled and not Arb.BountyOn() then table.insert(list, "Auto Farm RC") end
        return list
    end
end

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
    Subtitle = "Game : Kanom Tokyo | Version 0.5",
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
        Subtitle = "Live info about this server.",
    })
    local ServerForm = StatusServerSection:Form()

    local PlayersLabel = AddStatusRow(ServerForm, "Players", "In this server / max.", "-")
    local PingLabel = AddStatusRow(ServerForm, "Ping", "Your delay to the server.", "-")
    local FpsLabel = AddStatusRow(ServerForm, "FPS", "Frames per second.", "-")
    local TimeLabel = AddStatusRow(ServerForm, "Session Time", "Time since the script started.", "-")

    -- 📊 Character Stats (ตัวเดียวกับ Stats Status ในแท็บ Main Farm)
    local StatusStatsSection = StatusTab:PageSection({
        Title = "📊 Character Stats",
        Subtitle = "Your level and stat points.",
    })
    local StatusStatsForm = StatusStatsSection:Form()
    _G.SmoothHubStatus.StatsStatusLabelDashboard = AddStatusRow(
        StatusStatsForm,
        "Stats Status",
        "Level, Damage, Durability, Stamina, Speed.",
        "Lvl: 0 | Dmg: 0 | Dur: 0 | Sta: 0 | Spd: 0"
    )

    -- ⚙ Features : รวมสถานะของทุกฟังก์ชันไว้ที่นี่ (Off / Running / ข้อความสถานะสดจากแต่ละแท็บ)
    local GREY = "#96A5AA"

    local function StripRich(s)
        s = string.gsub(tostring(s or ""), "<[^>]+>", "")
        s = string.gsub(s, "\u{200B}", "")
        return s
    end
    local function Short(s, maxChars)
        s = StripRich(s)
        local len = utf8.len(s)
        if len and len > maxChars then
            s = string.sub(s, 1, utf8.offset(s, maxChars) - 1) .. "…"
        end
        return s
    end

    local featureGroups = {}
    local function AddFeatureSection(title, subtitle, defs, summary)
        local section = StatusTab:PageSection({ Title = title, Subtitle = subtitle })
        local form = section:Form()
        local summaryLabel
        if summary then
            summaryLabel = AddStatusRow(form, "Active Features", "How many features are turned on.", "0")
        end
        local rows = {}
        for _, d in ipairs(defs) do
            rows[#rows + 1] = {
                Label = AddStatusRow(form, d[1], d[2], Colorize(OFF_TEXT, GREY)),
                On = d[3],
                Live = d[4],
                Last = nil,
            }
        end
        table.insert(featureGroups, rows)
        return summaryLabel
    end

    local ActiveCountLabel = AddFeatureSection("🌾 Farming", "Everything that farms for you.", {
        { "Auto Farm Level", "Main Farm tab", function(c) return c.AutoFarmLevel end },
        { "Fast Attack", "Main Farm tab", function(c) return c.FastAttack end },
        { "Auto Upgrade Stats", "Main Farm tab", function(c) return c.AutoUpgradeStats end },
        { "Monster Farm", "Monster tab", function(c) return c.EnableFarmMonster end },
        { "Boss Farm", "Boss tab", function(c) return c.EnableFarmBoss end },
        { "World Boss", "Boss World tab", function(c) return c.AutoStartWorldBoss end },
        { "Auto Skill", "Auto Skill tab", function(c) return c.Skill.Master end, "Skill" },
        { "Auto Chest", "Item tab", function(c) return c.Item.Chest end, "Chest" },
        { "Auto Flower", "Item tab", function(c) return c.Item.Flower end, "Flower" },
        { "Auto Quest", "Quest Board tab", function(c) return c.Item.Quest.Enabled end, "Quest" },
    }, true)

    AddFeatureSection("🤖 Automation", "Buying, crafting and other helpers.", {
        { "Auto Buy Mask", "Shop tab", function(c) return c.Shop.AutoBuy end, "Shop" },
        { "Auto Buy Kagune", "Crafting tab", function(c) return c.Crafting.GhoulWeapons.AutoBuy end, "KaguneBuy" },
        { "Auto Buy Quinque", "Crafting tab", function(c) return c.Crafting.CCGWeapons.AutoBuy end, "QuinqueBuy" },
        { "Auto Craft", "Crafting tab", function(c) return c.Crafting.Craft.AutoCraft end, "Craft" },
        { "Black Market", "Black Market tab", function(c) return c.BlackMarket.Enabled end, "BlackMarket" },
        { "Auto Create Gate", "Dungeon tab", function(c) return c.Dungeon.AutoCreate end, "Dungeon" },
        { "Auto Equip Best", "Auto Equip Best tab", function(c) return c.Equip.Enabled end, "Equip" },
    })

    AddFeatureSection("⚔️ PVP", "Player-versus-player tools.", {
        { "Aimbot", "PVP tab", function(c) return c.PVP.Aimbot.Enabled end, "Aimbot" },
        { "Auto Farm RC", "PVP tab", function(c) return c.PVP.Bounty.Enabled end, "Bounty" },
        { "ESP", "PVP tab", function(c) return c.PVP.ESP.Enabled end },
    })

    -- 📋 Boss Status
    AddBossStatusSection(StatusTab)

    -- 🛡️ Conflict Guard : เปิดหลายฟังก์ชันพร้อมกันได้ ระบบสลับคิวให้ ไม่แย่งตัวละครกัน
    do
        local GuardSection = StatusTab:PageSection({
            Title = "🛡️ Conflict Guard",
            Subtitle = "Turn on as many functions as you like. Only one controls your character at a time.",
        })
        local GuardForm = GuardSection:Form()

        local GuardRow = GuardForm:Row()
        GuardRow:Left():TitleStack({
            Title = "Conflict Guard",
            Subtitle = "Queue movement functions by priority instead of letting them fight."
        })
        GuardRow:Right():Toggle({
            Value = _G.SmoothHubConfig.ConflictGuard,
            ValueChanged = function(self, value)
                _G.SmoothHubConfig.ConflictGuard = value and true or false
            end
        })

        AddStatusRow(GuardForm, "Priority",
            "Top goes first. Waiting ones resume by themselves.",
            "NPC visit > Item > Boss > Monster > Level > RC")
        local OwnerLabel = AddStatusRow(GuardForm, "Controlling now", "Who is moving your character.", "-")
        local WaitLabel = AddStatusRow(GuardForm, "Waiting", "Turned on, waiting for its turn.", "-")
        AddStatusRow(GuardForm, "Always together", "Never move your character, so no queue.",
            "Auto Skill, Fast Attack, Buy, Craft, ESP, Stats")

        task.spawn(function()
            local lastOwner, lastWait
            while true do
                task.wait(0.5)
                pcall(function()
                    local cfg = _G.SmoothHubConfig
                    local ownerText, waitText
                    if not cfg.ConflictGuard then
                        ownerText = Colorize("Guard off", GREY)
                        waitText = "-"
                    else
                        local owner = _G.SmoothHubArb.Owner()
                        ownerText = owner == "-" and Colorize("Nobody (idle)", GREY) or Colorize(owner, BOSS_GREEN)
                        local waiting = _G.SmoothHubArb.Waiting()
                        waitText = #waiting > 0 and table.concat(waiting, ", ") or "-"
                    end
                    if ownerText ~= lastOwner then lastOwner = ownerText; OwnerLabel.Text = ownerText end
                    if waitText ~= lastWait then lastWait = waitText; WaitLabel.Text = waitText end
                end)
            end
        end)
    end

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

                local activeCount = 0
                for _, group in ipairs(featureGroups) do
                    for _, f in ipairs(group) do
                        local okOn, on = pcall(f.On, _G.SmoothHubConfig)
                        local text
                        if okOn and on then
                            activeCount += 1
                            local live = f.Live and _G.SmoothHubLive[f.Live]
                            live = live and Short(live, 34) or ""
                            text = Colorize(live ~= "" and live or "Running", BOSS_GREEN)
                        else
                            text = Colorize(OFF_TEXT, GREY)
                        end
                        if f.Last ~= text then
                            f.Last = text
                            f.Label.Text = text
                        end
                    end
                end
                ActiveCountLabel.Text = tostring(activeCount)
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

local PriorityRow = FarmForm:Row()
PriorityRow:Left():TitleStack({
    Title = "Mimic Chest First",
    Subtitle = "Below Lv.200: farms Mimic chests first (kills the Slimes and claims the reward), then goes back to normal quests."
})
PriorityRow:Right():Toggle({
    Value = _G.SmoothHubConfig.FarmPriorityFirst,
    ValueChanged = function(self, value)
        _G.SmoothHubConfig.FarmPriorityFirst = value and true or false
    end
})

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

---------------------------------------------------------
-- แท็บ Auto Skill (กด Z X C V อัตโนมัติ เมื่อมีศัตรูอยู่ใกล้)
-- Instant = กดรัวๆ / Hold = กดค้างตามเวลา Delay Skill
-- ใช้ do ... end ครอบ เพื่อไม่ให้ตัวแปร local เกินลิมิต 200 ตัวของ Lua
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LocalPlayer = Players.LocalPlayer

    -- token กันลูปซ้อนเมื่อรันสคริปต์ซ้ำ
    local token = {}
    _G.SmoothHubSkillToken = token
    local function Alive() return _G.SmoothHubSkillToken == token end

    local SkillTab = CategorySection:Tab({
        Title = "Auto Skill",
        Icon = Cascade.Symbols["boltFill"] or Cascade.Symbols["leafFill"]
    })

    local SKILL_ORDER = { "Z", "X", "C", "V" }
    local SKILL_KEYCODES = { Z = Enum.KeyCode.Z, X = Enum.KeyCode.X, C = Enum.KeyCode.C, V = Enum.KeyCode.V }
    local SkillConfig = _G.SmoothHubConfig.Skill -- ถูกโหลดค่าที่เซฟไว้ให้แล้วจาก SettingsStore.Restore
    for _, skillKey in ipairs(SKILL_ORDER) do
        local skillCfg = SkillConfig[skillKey]
        if skillCfg.Mode ~= "Hold" then skillCfg.Mode = "Instant" end
        skillCfg.Delay = math.clamp(tonumber(skillCfg.Delay) or 5, 1, 30)
    end

    local SkillMainSection = SkillTab:PageSection({
        Title = "⚡ Auto Skill",
        Subtitle = "Presses Z / X / C / V for you."
    })
    local SkillMainForm = SkillMainSection:Form()
    local SkillMasterRow = SkillMainForm:Row()
    SkillMasterRow:Left():TitleStack({
        Title = "Enable Auto Skill",
        Subtitle = "Master switch for all skills below."
    })
    SkillMasterRow:Right():Toggle({
        Value = SkillConfig.Master,
        ValueChanged = function(self, value) SkillConfig.Master = value and true or false end
    })

    local SkillEnemyRow = SkillMainForm:Row()
    SkillEnemyRow:Left():TitleStack({
        Title = "Only Near Enemies",
        Subtitle = "Off = press skills all the time."
    })
    SkillEnemyRow:Right():Toggle({
        Value = SkillConfig.RequireEnemy,
        ValueChanged = function(self, value) SkillConfig.RequireEnemy = value and true or false end
    })

    local SkillStatusRow = SkillMainForm:Row()
    SkillStatusRow:Left():TitleStack({ Title = "Status", Subtitle = "Why skills are or aren't firing." })
    local SkillStatusLabel = SkillStatusRow:Right():Label({ Text = "Off" })

    local skillModeOptions = { "Instant", "Hold" }
    for _, key in ipairs(SKILL_ORDER) do
        local cfg = SkillConfig[key]
        local section = SkillTab:PageSection({
            Title = "🔹 Skill " .. key,
            Subtitle = "Instant = tap repeatedly. Hold = hold the key."
        })
        local form = section:Form()

        local enableRow = form:Row()
        enableRow:Left():TitleStack({ Title = "Use Skill " .. key, Subtitle = "Presses the key automatically." })
        enableRow:Right():Toggle({
            Value = cfg.Enabled,
            ValueChanged = function(self, value) cfg.Enabled = value and true or false end
        })

        local modeRow = form:Row()
        modeRow:Left():TitleStack({ Title = "Mode", Subtitle = "Instant or Hold." })

        local delayRow = form:Row()
        delayRow:Left():TitleStack({
            Title = "Hold Time",
            Subtitle = "Seconds to hold the key (Hold mode only)."
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
        pcall(function() delayRow.Visible = (cfg.Mode == "Hold") end) -- แสดงเฉพาะโหมด Hold

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

    -- เช็คว่ามีศัตรู (มอนสเตอร์ / บอส) อยู่ใกล้หรือไม่
    -- ศัตรูอยู่ใน Workspace["AI/Player"] (บอสอาจอยู่ในโฟลเดอร์ย่อย เช่น Boss) จึงไล่ลงไป 1 ชั้น
    local SKILL_RANGE = 80
    local function IsEnemyModel(model)
        if not model or not model:IsA("Model") then return false end
        if Players:GetPlayerFromCharacter(model) then return false end
        local hum = model:FindFirstChildOfClass("Humanoid")
        local root = model:FindFirstChild("HumanoidRootPart")
        return hum ~= nil and root ~= nil and hum.Health > 0
    end

    local function EnemyInRange(range)
        local char = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not hum or hum.Health <= 0 then return false end
        local folder = Workspace:FindFirstChild("AI/Player")
        if not folder then return false end
        local myPos = myRoot.Position
        for _, obj in ipairs(folder:GetChildren()) do
            if IsEnemyModel(obj) then
                if (obj.HumanoidRootPart.Position - myPos).Magnitude <= range then return true end
            elseif obj:IsA("Folder") then
                for _, sub in ipairs(obj:GetChildren()) do
                    if IsEnemyModel(sub) and (sub.HumanoidRootPart.Position - myPos).Magnitude <= range then
                        return true
                    end
                end
            end
        end
        return false
    end

    -- ลูป Auto Skill Z X C V : Instant = กดรัวๆ / Hold = กดค้างตาม Delay Skill
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
        local enemyNear, lastCheck, lastStatus = false, 0, nil
        while Alive() do
            task.wait(0.05)
            local now = os.clock()
            if SkillConfig.Master and now - lastCheck >= 0.2 then
                lastCheck = now
                enemyNear = EnemyInRange(SKILL_RANGE)
            elseif not SkillConfig.Master then
                enemyNear = false
            end

            local active = SkillConfig.Master and (enemyNear or not SkillConfig.RequireEnemy)

            local statusText
            if not SkillConfig.Master then statusText = "Off (Enable Auto Skill is off)"
            elseif active then statusText = "Active - pressing skills"
            else statusText = "Waiting - no enemy within " .. SKILL_RANGE end
            if statusText ~= lastStatus then
                lastStatus = statusText
                _G.SmoothHubLive.Skill = statusText
                pcall(function() SkillStatusLabel.Text = statusText end)
            end
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
                    SkillKey(key, false) -- ปล่อยปุ่มทันทีเมื่อปิดสวิตช์ / ศัตรูหาย
                    st.holding = false
                end
            end
        end
        for _, key in ipairs(SKILL_ORDER) do
            if SkillState[key].holding then SkillKey(key, false) end
        end
    end)
end

---------------------------------------------------------
-- แท็บ Item : Auto Chest Mimic + Auto Flower
-- Chest  = บิน -> กดเปิดกล่อง -> ฆ่า Slime ในมินิเกม (Workspace["AI/Player"]) -> กดรับของ
-- Flower = บิน -> กดเก็บดอกไม้
-- หมายเหตุ: Remote Spy ไม่เห็นอะไร = เกมน่าจะใช้ ProximityPrompt (กด E) เหมือนคุยเควสต์
--           จึงใช้ fireproximityprompt (ถ้า executor มี) หรือกดค้างปุ่มของ Prompt แทน
-- ใช้ do ... end ครอบ เพื่อไม่ให้ตัวแปร local เกินลิมิต 200 ตัวของ Lua
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local LocalPlayer = Players.LocalPlayer

    local token = {}
    _G.SmoothHubItemToken = token
    local function Alive() return _G.SmoothHubItemToken == token end

    local ItemConfig = _G.SmoothHubConfig.Item -- ถูกโหลดค่าที่เซฟไว้ให้แล้วจาก SettingsStore.Restore

    ---------------------------------------------------------
    -- 🎯 โหมด "ฟาร์มกล่องมิมิกก่อน" ของ Auto Farm Level
    -- เลเวลต่ำกว่า PRIORITY_LEVEL และเปิด Auto Farm Level อยู่ ->
    --   ไปฟาร์ม Chest Mimic ก่อน: เปิดกล่อง -> ฆ่า Slime -> "รับของรางวัลให้เสร็จ" -> กล่องถัดไป
    --   ถ้าไม่มีกล่องให้เปิดแล้ว (ครบ) -> ปล่อยให้ Auto Farm Level ฟาร์มเควสปกติ (ถ้ามีกล่องเกิดใหม่ค่อยกลับไปเปิด)
    -- เลเวลถึง PRIORITY_LEVEL (200) แล้ว -> ฟาร์มเควสปกติอย่างเดียว
    --   (ถ้าเลเวลถึง 200 ตอนกำลังฆ่า Slime / รอรับของอยู่ จะรับของให้เสร็จก่อนแล้วค่อยกลับไปฟาร์มปกติ)
    -- Quest Board ไม่เกี่ยวกับโหมดนี้แล้ว (ใช้ได้เมื่อเปิดสวิตช์ในแท็บ Item เองเท่านั้น)
    ---------------------------------------------------------
    local PRIORITY_LEVEL = 200
    local QUEST_RECHECK_SEC = 600 -- เควสบอร์ดหมดแล้ว: รอเลเวลเปลี่ยน หรือครบเวลานี้ก่อนค่อยกลับไปเช็กใหม่

    local levelCache, levelCacheAt = nil, 0
    local function CurrentLevel()
        if os.clock() - levelCacheAt > 1 then
            levelCacheAt = os.clock()
            local ok, level = pcall(function()
                local data = LocalPlayer:FindFirstChild("Data")
                local stat = data and (data:FindFirstChild("Level") or data:FindFirstChild("Lv"))
                return stat and stat.Value
            end)
            levelCache = ok and tonumber(level) or nil
        end
        return levelCache
    end

    local function PriorityMode()
        local cfg = _G.SmoothHubConfig
        if not (cfg.AutoFarmLevel and cfg.FarmPriorityFirst) then return false end
        local level = CurrentLevel()
        return level ~= nil and level < PRIORITY_LEVEL
    end

    local QuestExhaustedAt, QuestExhaustedLevel = nil, nil -- เควสบอร์ดไม่มีอะไรให้ทำแล้ว (Completed หมด / เลเวลไม่ถึง / รับไม่ได้)
    local QuestPausedUntil = 0 -- รอมอนเควสเกิดนานเกิน: พักเควสบอร์ดชั่วคราว ให้ฟาร์มเควสปกติไปก่อน

    local function QuestExhausted()
        if not QuestExhaustedAt then return false end
        if CurrentLevel() ~= QuestExhaustedLevel or os.clock() - QuestExhaustedAt > QUEST_RECHECK_SEC then
            QuestExhaustedAt = nil
            return false
        end
        return true
    end

    -- true ระหว่างที่กล่องอยู่ในมินิเกม/กำลังรอรับของ -> ห้ามทิ้งกลางทาง ต้องรับของให้เสร็จก่อน
    local ClaimPending = false

    local function ChestEnabled()
        if ItemConfig.Chest or PriorityMode() then return true end
        -- เลเวลถึง 200 ระหว่างฆ่า Slime / รับของ: ทำต่อจนรับของเสร็จ (ตราบใดที่ยังเปิด Auto Farm Level อยู่)
        return ClaimPending and _G.SmoothHubConfig.AutoFarmLevel and true or false
    end

    -- Quest Board ทำงานเมื่อผู้ใช้เปิดสวิตช์เองเท่านั้น (ไม่ผูกกับโหมดฟาร์มกล่องก่อนแล้ว)
    local function QuestEnabled()
        return ItemConfig.Quest.Enabled and true or false
    end

    -- ให้ Auto Farm Level เช็กว่าตอนนี้ต้องหยุดรอระบบ Chest / Quest Board ไหม (ไม่แย่งตัวละครกัน)
    _G.SmoothHubItemWorking = false
    _G.SmoothHubItemBusyUntil = 0
    _G.SmoothHubYieldToItems = function()
        return _G.SmoothHubConfig.AutoFarmLevel
            and (_G.SmoothHubItemWorking or os.clock() < (_G.SmoothHubItemBusyUntil or 0))
    end

    local ItemTab = CategorySection:Tab({
        Title = "Item",
        Icon = Cascade.Symbols["shippingboxFill"] or Cascade.Symbols["leafFill"]
    })

    ---------------------------------------------------------
    -- UI
    ---------------------------------------------------------
    local ChestSection = ItemTab:PageSection({
        Title = "📦 Chest Mimic",
        Subtitle = "Opens chests, kills the 3 Slimes, claims the reward. Turn off other farms."
    })
    local ChestForm = ChestSection:Form()

    local ChestRow = ChestForm:Row()
    ChestRow:Left():TitleStack({
        Title = "Enable Auto Chest",
        Subtitle = "Flies to the nearest chest and opens it."
    })
    ChestRow:Right():Toggle({
        Value = ItemConfig.Chest,
        ValueChanged = function(self, value) ItemConfig.Chest = value and true or false end
    })

    local ChestStatusRow = ChestForm:Row()
    ChestStatusRow:Left():Label({ Text = "Status" })
    local ChestStatusLabel = ChestStatusRow:Right():Label({ Text = "Idle" })

    local ChestCountRow = ChestForm:Row()
    ChestCountRow:Left():Label({ Text = "Chests Done" })
    local ChestCountLabel = ChestCountRow:Right():Label({ Text = "0" })

    local FlowerSection = ItemTab:PageSection({
        Title = "🌸 Flowers",
        Subtitle = "Picks up flowers automatically."
    })
    local FlowerForm = FlowerSection:Form()

    local FlowerRow = FlowerForm:Row()
    FlowerRow:Left():TitleStack({
        Title = "Enable Auto Flower",
        Subtitle = "Flies to the nearest flower."
    })
    FlowerRow:Right():Toggle({
        Value = ItemConfig.Flower,
        ValueChanged = function(self, value) ItemConfig.Flower = value and true or false end
    })

    local FlowerStatusRow = FlowerForm:Row()
    FlowerStatusRow:Left():Label({ Text = "Status" })
    local FlowerStatusLabel = FlowerStatusRow:Right():Label({ Text = "Idle" })

    local FlowerCountRow = FlowerForm:Row()
    FlowerCountRow:Left():Label({ Text = "Flowers Collected" })
    local FlowerCountLabel = FlowerCountRow:Right():Label({ Text = "0" })

    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        pcall(function() label.Text = text end)
    end
    _G.SmoothHubLiveKeys[ChestStatusLabel] = "Chest"
    _G.SmoothHubLiveKeys[FlowerStatusLabel] = "Flower"

    ---------------------------------------------------------
    -- ฟังก์ชันช่วย
    ---------------------------------------------------------
    local FLY_SPEED = 250

    local function GetMyRoot()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and hum and hum.Health > 0 then return root end
        return nil
    end

    local function PosOf(obj)
        if obj:IsA("Model") then return obj:GetPivot().Position end
        if obj:IsA("BasePart") then return obj.Position end
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end

    local function GetPrompt(obj) return obj:FindFirstChildWhichIsA("ProximityPrompt", true) end
    local function GetClick(obj) return obj:FindFirstChildWhichIsA("ClickDetector", true) end

    -- กด Prompt / ClickDetector ของวัตถุ
    local function Interact(obj, useKey)
        local prompt = GetPrompt(obj)
        if prompt then
            if not prompt.Enabled then return false end
            if fireproximityprompt and not useKey then
                local oldHold = prompt.HoldDuration
                pcall(function() prompt.HoldDuration = 0 end)
                local ok = pcall(fireproximityprompt, prompt)
                pcall(function() prompt.HoldDuration = oldHold end)
                if ok then return true end
            end
            -- ทางสำรอง: กดค้างปุ่มของ Prompt (ปกติคือ E) ตามเวลา HoldDuration
            local key = prompt.KeyboardKeyCode
            if key == Enum.KeyCode.Unknown then key = Enum.KeyCode.E end
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                task.wait(math.max(prompt.HoldDuration, 0) + 0.15)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
            end)
            return true
        end
        local cd = GetClick(obj)
        if cd and fireclickdetector then
            return (pcall(fireclickdetector, cd))
        end
        return false
    end

    local function Interactable(obj)
        local prompt = GetPrompt(obj)
        if prompt then return prompt.Enabled end
        return GetClick(obj) ~= nil
    end

    -- บินไปยังตำแหน่ง (ขยับ CFrame ทีละก้าว เหมือนระบบฟาร์มอื่น)
    local function FlyTo(pos, stillOk, timeout)
        local t0 = os.clock()
        while Alive() and stillOk() and os.clock() - t0 < (timeout or 15) do
            local dt = RunService.Heartbeat:Wait()
            local root = GetMyRoot()
            if not root then return false end
            local diff = pos - root.Position
            local dist = diff.Magnitude
            root.AssemblyLinearVelocity = Vector3.zero
            if dist <= 2 then
                root.CFrame = CFrame.new(pos)
                return true
            end
            root.CFrame = CFrame.new(root.Position + diff.Unit * math.min(FLY_SPEED * dt, dist))
        end
        return false
    end

    -- ยืนนิ่งอยู่ที่ตำแหน่ง (กันตก) ตามเวลาที่กำหนด
    local function HoldFor(sec, pos, stillOk)
        local t0 = os.clock()
        while Alive() and stillOk() and os.clock() - t0 < sec do
            RunService.Heartbeat:Wait()
            local root = GetMyRoot()
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                if pos then root.CFrame = CFrame.new(pos) end
            end
        end
    end

    -- ตีศัตรู (Remote เดียวกับ Fast Attack)
    local AttackEvent = nil
    task.spawn(function()
        local bridge = ReplicatedStorage:WaitForChild("BridgeNet2", 10)
        AttackEvent = bridge and bridge:WaitForChild("dataRemoteEvent", 10)
    end)
    local function Attack()
        if AttackEvent then
            pcall(function() AttackEvent:FireServer({ { "NormalAttack", 1 }, "\x13" }) end)
        end
    end

    ---------------------------------------------------------
    -- ปุ่มรับของ (ทางสำรอง ถ้าเกมใช้ปุ่ม GUI แทน Prompt)
    ---------------------------------------------------------
    local CLAIM_WORDS = { "claim", "collect", "receive", "take", "รับ", "เก็บ" }

    local function IsShown(obj)
        local cur = obj
        while cur do
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            if cur:IsA("ScreenGui") and not cur.Enabled then return false end
            cur = cur.Parent
        end
        return true
    end

    local function FindClaimButton()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return nil end
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("TextButton") or d:IsA("TextLabel") then
                local text = string.lower(d.Text or "")
                -- ข้ามข้อความที่เป็นตัวนับของ UI เราเอง (เช่น "Flowers Collected") และ UI ของ Prompt ที่ Roblox วาดให้
                if text ~= "" and #text <= 30 and not string.find(text, "collected", 1, true)
                    and d:FindFirstAncestorWhichIsA("ScreenGui") and not d:FindFirstAncestor("ProximityPrompts") then
                    for _, word in ipairs(CLAIM_WORDS) do
                        if string.find(text, word, 1, true) and IsShown(d) then return d end
                    end
                end
            end
        end
        return nil
    end

    local function ClickGui(obj)
        local btn = obj
        while btn and not btn:IsA("GuiButton") do btn = btn.Parent end
        btn = btn or obj
        if btn:IsA("GuiButton") and getconnections then
            for _, sig in ipairs({ "MouseButton1Click", "Activated" }) do
                local ok, conns = pcall(getconnections, btn[sig])
                if ok and conns and #conns > 0 then
                    for _, c in ipairs(conns) do pcall(function() c:Fire() end) end
                    return true
                end
            end
        end
        local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
        local gui = btn:FindFirstAncestorOfClass("ScreenGui")
        local insetY = (gui and gui.IgnoreGuiInset) and 0 or GuiService:GetGuiInset().Y
        local x, y = pos.X + size.X / 2, pos.Y + size.Y / 2 + insetY
        return (pcall(function()
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end))
    end

    ---------------------------------------------------------
    -- Auto Chest Mimic
    ---------------------------------------------------------
    local ChestDone = setmetatable({}, { __mode = "k" })
    local ChestsOpened = 0

    local function FindNearest(name, doneTable, cooldown)
        local root = GetMyRoot()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == name then
                local doneAt = doneTable[obj]
                if not (doneAt and os.clock() - doneAt < cooldown) and Interactable(obj) then
                    local pos = PosOf(obj)
                    if pos then
                        local d = (pos - root.Position).Magnitude
                        if d < bestDist then best, bestDist = obj, d end
                    end
                end
            end
        end
        return best
    end

    -- Slime ของมินิเกม อยู่ใน Workspace["AI/Player"]
    local function AliveSlimes()
        local list = {}
        local folder = Workspace:FindFirstChild("AI/Player")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do
                if m:IsA("Model") and string.find(string.lower(m.Name), "slime", 1, true) then
                    local hum = m:FindFirstChildOfClass("Humanoid")
                    local root = m:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then table.insert(list, m) end
                end
            end
        end
        return list
    end

    local function RunChest(chest)
        local function enabled() return ChestEnabled() end
        local pos = PosOf(chest) + Vector3.new(0, 3, 0)

        SetText(ChestStatusLabel, "Flying to chest...")
        if not FlyTo(pos, enabled, 20) then
            ChestDone[chest] = os.clock()
            return
        end

        -- ลองเปิดสูงสุด 3 ครั้ง: ครั้งที่ 2 ใช้กดปุ่มจริง (F) แทน fireproximityprompt
        -- แล้วรอให้ Slime ของมินิเกมเกิด
        local started = false
        for attempt = 1, 3 do
            if not (Alive() and enabled()) then break end
            SetText(ChestStatusLabel, "Opening chest (try " .. attempt .. ")...")
            Interact(chest, attempt == 2)
            local w0 = os.clock()
            while Alive() and enabled() and os.clock() - w0 < 2.5 do
                HoldFor(0.2, pos, enabled)
                if #AliveSlimes() > 0 then started = true break end
            end
            if started or not chest.Parent then break end
        end
        if not started then
            SetText(ChestStatusLabel, "No minigame started")
            ChestDone[chest] = os.clock()
            return
        end

        -- มินิเกมเริ่มแล้ว: ล็อกไว้ว่า "ต้องรับของให้เสร็จ" ต่อให้เลเวลข้าม 200 ระหว่างฆ่า Slime ก็ไม่ทิ้งกลางทาง
        ClaimPending = true

        -- ฆ่า Slime จนหมด
        local k0, lastSeen, lastAtk = os.clock(), os.clock(), 0
        local slimesCleared = false
        while Alive() and enabled() and os.clock() - k0 < 60 do
            local dt = RunService.Heartbeat:Wait()
            local slimes = AliveSlimes()
            if #slimes == 0 then
                if os.clock() - lastSeen > 1.5 then slimesCleared = true break end
            else
                lastSeen = os.clock()
                local root = GetMyRoot()
                if root then
                    local target, td = nil, math.huge
                    for _, s in ipairs(slimes) do
                        local d = (s.HumanoidRootPart.Position - root.Position).Magnitude
                        if d < td then target, td = s, d end
                    end
                    local tr = target.HumanoidRootPart
                    local goal = tr.Position + Vector3.new(0, 6, 0)
                    local diff = goal - root.Position
                    local dist = diff.Magnitude
                    root.AssemblyLinearVelocity = Vector3.zero
                    if dist > 2 then
                        root.CFrame = CFrame.new(root.Position + diff.Unit * math.min(FLY_SPEED * dt, dist), tr.Position)
                    else
                        root.CFrame = CFrame.new(goal, tr.Position)
                    end
                    if os.clock() - lastAtk > 0.1 and dist <= 35 then
                        lastAtk = os.clock()
                        Attack()
                    end
                    SetText(ChestStatusLabel, "Killing slimes (" .. #slimes .. " left)")
                end
            end
        end

        if not slimesCleared then
            -- ฆ่าไม่หมด (หมดเวลา / ผู้ใช้ปิดฟาร์ม / ตาย) -> ยังรับของไม่ได้ ไม่นับว่าเปิดสำเร็จ
            ClaimPending = false
            ChestDone[chest] = os.clock()
            SetText(ChestStatusLabel, "Slimes not cleared - reward not claimed")
            return
        end

        -- รับของรางวัล: ต้องรับให้เสร็จก่อนค่อยไปทำอย่างอื่น
        -- 1) บินกลับมาที่กล่อง (ตอนฆ่า Slime อาจอยู่ไกล)
        -- 2) กด Prompt ของกล่อง หรือปุ่ม Claim/Collect ใน GUI
        -- 3) นับว่า "รับแล้ว" เมื่อกดไปแล้ว และไม่เหลืออะไรให้กดอีก (ปุ่มหาย / กล่องหาย / Prompt ปิด)
        if chest.Parent then
            SetText(ChestStatusLabel, "Returning to chest to claim...")
            FlyTo(pos, enabled, 15)
        end

        SetText(ChestStatusLabel, "Claiming reward...")
        local acted, idle, claimed, auto = 0, 0, false, false
        local c0 = os.clock()
        while Alive() and enabled() and os.clock() - c0 < 25 do
            HoldFor(0.5, chest.Parent and pos or nil, enabled)

            if chest.Parent and Interactable(chest) then
                idle = 0
                acted += 1
                SetText(ChestStatusLabel, "Claiming reward (try " .. acted .. ")...")
                Interact(chest, acted % 2 == 0) -- ครั้งที่เลขคู่ใช้กดปุ่มจริง (F) แทน fireproximityprompt
                HoldFor(0.6, pos, enabled)
            else
                local btn = FindClaimButton()
                if btn then
                    idle = 0
                    acted += 1
                    SetText(ChestStatusLabel, "Claiming reward (click " .. acted .. ")...")
                    ClickGui(btn)
                    HoldFor(0.6, chest.Parent and pos or nil, enabled)
                else
                    idle += 1
                    if acted > 0 and idle >= 2 then claimed = true break end   -- กดแล้ว และไม่เหลืออะไรให้กดอีก = รับแล้ว
                    if acted == 0 and idle >= 8 then auto = true break end      -- ไม่เจอขั้นตอนรับของเลย (เกมอาจให้ของอัตโนมัติ)
                end
            end

            if acted >= 4 then claimed = true break end -- กดหลายครั้งแล้ว กันวนกดซ้ำไม่จบ
        end

        ClaimPending = false

        if not (claimed or auto) then
            -- หมดเวลา/ถูกปิดกลางทาง: ยังยืนยันไม่ได้ว่ารับของแล้ว ให้ลองกล่องนี้ใหม่เร็วกว่าปกติ
            ChestDone[chest] = os.clock() - 40
            SetText(ChestStatusLabel, "Reward claim not confirmed")
            return
        end

        ChestsOpened += 1
        ChestDone[chest] = os.clock()
        SetText(ChestCountLabel, tostring(ChestsOpened))
        SetText(ChestStatusLabel, claimed and "Done - reward claimed" or "Done (no claim step found)")
    end

    ---------------------------------------------------------
    -- Auto Flower
    ---------------------------------------------------------
    local FlowerDone = setmetatable({}, { __mode = "k" })
    local FlowersCollected = 0

    local function RunFlower(flower)
        local function enabled() return ItemConfig.Flower end
        local pos = PosOf(flower) + Vector3.new(0, 2, 0)

        SetText(FlowerStatusLabel, "Flying to flower...")
        if not FlyTo(pos, enabled, 20) then
            FlowerDone[flower] = os.clock()
            return
        end

        SetText(FlowerStatusLabel, "Collecting...")
        Interact(flower)
        HoldFor(0.5, pos, enabled)
        if flower.Parent and Interactable(flower) then
            Interact(flower, true) -- ยังเก็บไม่ติด: ลองกดปุ่มจริง (F)
            HoldFor(0.5, pos, enabled)
        end

        FlowersCollected += 1
        FlowerDone[flower] = os.clock()
        SetText(FlowerCountLabel, tostring(FlowersCollected))
        SetText(FlowerStatusLabel, "Done")
    end

    ---------------------------------------------------------
    -- Auto Quest Board (แท็บ Quest Board)
    -- 1) บินไปหา Workspace.TalkNpc["Quest board"] แล้วกดปุ่ม Collect (F) เพื่อคุย
    -- 2) รับเควส: ลองส่ง Remote "RequestQuest" ก่อน ถ้าเกมไม่รับ จะกดปุ่ม Accept บนหน้าจอแทน
    -- 3) อ่านเควสจาก HUD.Quest (รูปแบบ "Kill N <ชื่อมอน>") แล้วบินไปฆ่ามอนใน Workspace["AI/Player"]
    -- 4) เควสครบ -> กลับไปคุยกับบอร์ดอีกครั้ง (ส่งเควส / รับเควสถัดไป) วนไปเรื่อยๆ
    ---------------------------------------------------------
    local HttpService = game:GetService("HttpService")
    local QuestCfg = ItemConfig.Quest

    -- Remote ที่ดักได้จาก Remote Spy: ReplicatedStorage.Network["{...}"]:FireServer("RequestQuest", <ModuleScript เควส>, <GUID>)
    local QUEST_REMOTE = "{28E5E5B9-E5C9-4F23-911D-72E9DF276DCC}"
    local RARITY_ORDER = { "Legendary", "Rare", "Common" } -- โหมด Auto ลองจากหายากสุดก่อน

    local function QuestBoardFolder()
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        local db = modules and modules:FindFirstChild("DataBase")
        return db and db:FindFirstChild("QuestBoard")
    end

    -- รายชื่อเควสทั้งหมดจากโฟลเดอร์ QuestBoard (Legendary -> Rare -> Common)
    local function AllQuestModules()
        local list = {}
        local qb = QuestBoardFolder()
        if qb then
            for _, rarity in ipairs(RARITY_ORDER) do
                local folder = qb:FindFirstChild(rarity)
                if folder then
                    for _, m in ipairs(folder:GetChildren()) do
                        if m:IsA("ModuleScript") then table.insert(list, m) end
                    end
                end
            end
        end
        return list
    end

    -- Smart = เลือกเควสที่ดีที่สุดให้เอง / Auto = หายากสุดก่อน (เหมือนเดิม) / ที่เหลือ = เลือกเควสเฉพาะ (ติ๊กได้หลายอัน)
    local questOptions = { "Smart", "Auto" }
    for _, m in ipairs(AllQuestModules()) do table.insert(questOptions, m.Name) end
    if #questOptions == 1 then
        for _, n in ipairs({ "End of Jason", "Hidden Remains", "One-Eyed Requiem", "Shadows of Rin",
            "Venom in the Shadows", "Athlete Hunt", "Body Retrieval", "Bulk Cleanup" }) do
            table.insert(questOptions, n)
        end
    end
    -- ย้ายค่าเก่า (Pick เดี่ยว) -> Picks (หลายอัน) และถ้ายังไม่เคยเลือกอะไรเลย ให้เริ่มที่ Smart
    if type(QuestCfg.Picks) ~= "table" then QuestCfg.Picks = {} end
    if next(QuestCfg.Picks) == nil then
        if QuestCfg.Pick and QuestCfg.Pick ~= "Auto" and table.find(questOptions, QuestCfg.Pick) then
            QuestCfg.Picks[QuestCfg.Pick] = true
        else
            QuestCfg.Picks.Smart = true
        end
    end

    local QuestTab = CategorySection:Tab({
        Title = "Quest Board",
        Icon = Cascade.Symbols["scrollFill"] or Cascade.Symbols["leafFill"]
    })
    local QuestSection = QuestTab:PageSection({
        Title = "📜 Auto Quest",
        Subtitle = "Takes quests from the board and kills the targets. Kill quests only."
    })
    local QuestForm = QuestSection:Form()

    local QuestEnableRow = QuestForm:Row()
    QuestEnableRow:Left():TitleStack({
        Title = "Enable Auto Quest",
        Subtitle = "Flies to the board, accepts and completes quests."
    })
    QuestEnableRow:Right():Toggle({
        Value = QuestCfg.Enabled,
        ValueChanged = function(self, value) QuestCfg.Enabled = value and true or false end
    })

    local QuestPickRow = QuestForm:Row()
    QuestPickRow:Left():TitleStack({
        Title = "Quest Selection",
        Subtitle = "Tick one or more. Smart = best available. Auto = rarest first."
    })
    QuestPickRow:Right():PopUpButton({
        Options = questOptions,
        Maximum = #questOptions, -- ติ๊กได้หลายอัน
        Value = SettingsStore.IndexesFromMap(questOptions, QuestCfg.Picks),
        ValueChanged = function(self, value)
            local picked = {}
            for _, index in ipairs(value or {}) do
                if questOptions[index] then picked[questOptions[index]] = true end
            end
            if next(picked) == nil then picked.Smart = true end -- ไม่ติ๊กอะไรเลย = Smart
            QuestCfg.Picks = picked
        end
    })

    -- Position: ลอยอยู่เหนือ (Upper) หรือใต้ (Down) มอนที่กำลังฆ่าตอนทำเควส
    local QuestPosRow = QuestForm:Row()
    QuestPosRow:Left():TitleStack({
        Title = "Farm Position",
        Subtitle = "Stay above or below the monster."
    })
    local questPosOptions = { "Upper", "Down" }
    if not table.find(questPosOptions, QuestCfg.Position) then QuestCfg.Position = "Upper" end
    local QuestPosBtn = QuestPosRow:Right():PullDownButton({
        Label = QuestCfg.Position,
        Options = questPosOptions,
        Value = table.find(questPosOptions, QuestCfg.Position) or 1,
        ValueChanged = function(self, index)
            QuestCfg.Position = questPosOptions[index] or "Upper"
            self.Label = QuestCfg.Position
        end
    })
    pcall(function()
        local indicator = QuestPosBtn.__instance:FindFirstChild("PullDownIndicator")
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

    local QuestStatusRow = QuestForm:Row()
    QuestStatusRow:Left():Label({ Text = "Status" })
    local QuestStatusLabel = QuestStatusRow:Right():Label({ Text = "Idle" })
    _G.SmoothHubLiveKeys[QuestStatusLabel] = "Quest"

    local QuestCountRow = QuestForm:Row()
    QuestCountRow:Left():Label({ Text = "Quests Done" })
    local QuestCountLabel = QuestCountRow:Right():Label({ Text = "0" })

    local function StripTags(s) return (string.gsub(s or "", "<[^>]+>", "")) end

    local function NormName(s)
        local n = string.lower(StripTags(s))
        n = string.gsub(n, "[^%w]", "")
        if #n > 3 and string.sub(n, -1) == "s" then n = string.sub(n, 1, -2) end
        return n
    end

    -- อ่านเควสปัจจุบันจาก HUD.Quest  ("Kill 6 Serpent ghouls." + "2/6")
    local function ReadQuest()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local hud = pg and pg:FindFirstChild("HUD")
        local ui = hud and hud:FindFirstChild("Quest")
        if not ui then return nil end
        local name, need, have
        local sawCounter = false
        for _, d in ipairs(ui:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text ~= "" and IsShown(d) then
                local text = StripTags(d.Text)
                local n, nm = string.match(text, "^%s*[Kk]ill%s+(%d+)%s+(.-)%s*%.?%s*$")
                if n then
                    need, name = tonumber(n), nm
                else
                    local h, nd = string.match(text, "^%s*(%d+)%s*/%s*(%d+)%s*$")
                    if h then
                        have, need = tonumber(h), tonumber(nd)
                        sawCounter = true
                    end
                end
            end
        end
        if not name and not sawCounter then return nil end
        return { name = name, have = have or 0, need = need or 0 }
    end

    -- มอนที่ตรงกับชื่อในเควส (เทียบแบบไม่สนตัวพิมพ์/เว้นวรรค/ตัว s ท้ายคำ) ไม่รวมตัวละครผู้เล่น
    local function QuestTargets(questName)
        local want = NormName(questName)
        local list = {}
        local folder = Workspace:FindFirstChild("AI/Player")
        if not folder then return list end
        for _, m in ipairs(folder:GetChildren()) do
            if m:IsA("Model") and not Players:GetPlayerFromCharacter(m) then
                local hum = m:FindFirstChildOfClass("Humanoid")
                local root = m:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local have = NormName(m.Name)
                    if have == want or (#want >= 6 and #have >= 6
                        and (string.find(have, want, 1, true) or string.find(want, have, 1, true))) then
                        table.insert(list, m)
                    end
                end
            end
        end
        return list
    end

    ---------------------------------------------------------
    -- 🧠 Smart: จัดอันดับเควสที่ "ดีที่สุด" ให้ผู้เล่นตอนนี้
    -- คะแนน = ความหายาก (Legendary > Rare > Common)
    --       + รางวัลในข้อมูลเควส (ถ้ามีช่อง exp/reward/yen/money ฯลฯ)
    --       + มอนเป้าหมายของเควสเกิดอยู่ในแมพตอนนี้ (ทำได้ทันที)
    --       - เควสที่ต้องใช้เลเวลสูงกว่าเรา (ถ้าข้อมูลเควสบอกเลเวลไว้) จะถูกดันไปท้ายสุด
    ---------------------------------------------------------
    local RARITY_SCORE = { Legendary = 3000, Rare = 2000, Common = 1000 }

    local function MyLevel()
        local ok, level = pcall(function()
            local data = LocalPlayer:FindFirstChild("Data")
            local stat = data and (data:FindFirstChild("Level") or data:FindFirstChild("Lv"))
            return stat and stat.Value
        end)
        return ok and tonumber(level) or nil
    end

    local function QuestScore(mod)
        local score = RARITY_SCORE[mod.Parent and mod.Parent.Name or ""] or 0
        local ok, data = pcall(require, mod)
        if not (ok and type(data) == "table") then return score end

        local myLevel = MyLevel()
        local strings = {}
        local function scan(tbl, depth)
            if depth > 2 then return end
            for key, value in pairs(tbl) do
                local k = string.lower(tostring(key))
                if type(value) == "number" then
                    if string.find(k, "level", 1, true) or string.find(k, "lv", 1, true) then
                        if myLevel and value > myLevel then score -= 100000 end
                    elseif string.find(k, "exp", 1, true) or string.find(k, "xp", 1, true)
                        or string.find(k, "reward", 1, true) or string.find(k, "yen", 1, true)
                        or string.find(k, "money", 1, true) or string.find(k, "cash", 1, true) then
                        score += math.min(value, 999999) / 1000
                    end
                elseif type(value) == "string" then
                    strings[#strings + 1] = value
                elseif type(value) == "table" then
                    scan(value, depth + 1)
                end
            end
        end
        pcall(scan, data, 0)

        -- มอนเป้าหมายเกิดอยู่ไหม: ชื่อมอนในแมพไปโผล่อยู่ในข้อความของเควส
        local folder = Workspace:FindFirstChild("AI/Player")
        if folder then
            local seen = {}
            for _, m in ipairs(folder:GetChildren()) do
                if m:IsA("Model") and not seen[m.Name] and not Players:GetPlayerFromCharacter(m) then
                    seen[m.Name] = true
                    local mn = NormName(m.Name)
                    if #mn >= 5 then
                        for _, s in ipairs(strings) do
                            if string.find(NormName(s), mn, 1, true) then score += 500 break end
                        end
                    end
                end
            end
        end
        return score
    end

    -- รายชื่อเควสที่จะลองรับ เรียงตามลำดับความสำคัญ + ชื่อเควสที่ต้องการ (ใช้กับปุ่ม Accept บนจอ)
    local function BuildQuestCandidates()
        local all = AllQuestModules()
        local picks = QuestCfg.Picks or {}
        local named, used = {}, {}
        for _, m in ipairs(all) do
            if picks[m.Name] then
                table.insert(named, m)
                used[m] = true
            end
        end

        local rest = {}
        if picks.Smart then
            local scored = {}
            for i, m in ipairs(all) do
                if not used[m] then table.insert(scored, { mod = m, score = QuestScore(m), idx = i }) end
            end
            table.sort(scored, function(a, b)
                if a.score ~= b.score then return a.score > b.score end
                return a.idx < b.idx
            end)
            for _, s in ipairs(scored) do table.insert(rest, s.mod) end
        elseif picks.Auto or #named == 0 then
            for _, m in ipairs(all) do
                if not used[m] then table.insert(rest, m) end
            end
        end

        local candidates = {}
        for _, m in ipairs(named) do table.insert(candidates, m) end
        for _, m in ipairs(rest) do table.insert(candidates, m) end

        -- ปุ่ม Accept บนจอเลือกเควสให้ไม่ได้ จึงเจาะจงชื่อเฉพาะตอนที่ผู้เล่นเลือกเควสเอง (ไม่ได้ติ๊ก Smart/Auto)
        local wanted = nil
        if #named > 0 and not picks.Smart and not picks.Auto then
            wanted = {}
            for _, m in ipairs(named) do table.insert(wanted, m.Name) end
        end
        return candidates, wanted
    end

    -- กด E 5 ครั้ง (เหมือนฟังก์ชันฟาร์มอื่น) ใช้ตอนคุยกับบอร์ดเควส
    local function PressE5(enabled)
        for i = 1, 5 do
            if not (Alive() and enabled()) then return end
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
            if i < 5 then task.wait(0.5) end
        end
    end

    local function HuntOne(target, enabled)
        local t0, lastAtk = os.clock(), 0
        while Alive() and enabled() and os.clock() - t0 < 12 do
            local dt = RunService.Heartbeat:Wait()
            local hum = target:FindFirstChildOfClass("Humanoid")
            local tr = target:FindFirstChild("HumanoidRootPart")
            local root = GetMyRoot()
            if not (target.Parent and hum and hum.Health > 0 and tr and root) then return end
            local yOffset = (QuestCfg.Position == "Down") and -6 or 6
            local goal = tr.Position + Vector3.new(0, yOffset, 0)
            local diff = goal - root.Position
            local dist = diff.Magnitude
            root.AssemblyLinearVelocity = Vector3.zero
            if dist > 2 then
                root.CFrame = CFrame.new(root.Position + diff.Unit * math.min(FLY_SPEED * dt, dist), tr.Position)
            else
                root.CFrame = CFrame.new(goal, tr.Position)
            end
            if os.clock() - lastAtk > 0.1 and dist <= 35 then
                lastAtk = os.clock()
                Attack()
            end
        end
    end

    local function FindBoard()
        local talk = Workspace:FindFirstChild("TalkNpc")
        if not talk then return nil end
        local board = talk:FindFirstChild("Quest board")
        if board then return board end
        for _, c in ipairs(talk:GetChildren()) do
            if string.lower(c.Name) == "quest board" then return c end
        end
        return nil
    end

    -- หาปุ่ม/ข้อความบนจอ ที่ข้อความตรงกับ text ทั้งคำ (เช่น "accept", ">")
    local function FindGuiText(text)
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return nil end
        for _, d in ipairs(pg:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel")) and d.Text ~= "" and IsShown(d) then
                local s = string.lower(string.match(StripTags(d.Text), "^%s*(.-)%s*$"))
                if s == text then return d end
            end
        end
        return nil
    end

    -- ปิดหน้าบอร์ดเควสที่ค้างอยู่หลังรับเควสแล้ว: หาปุ่มปิด (X / Close) ที่อยู่ใกล้ปุ่ม Accept ที่สุด
    local lastBoardAnchor = nil -- ปุ่ม Accept ล่าสุดที่เจอ (ใช้เดินขึ้นไปหาปุ่มปิดในหน้าต่างเดียวกัน)
    local CLOSE_NAMES = { close = true, closebutton = true, closebtn = true, exit = true, x = true, xbutton = true, xbtn = true }
    local CLOSE_TEXTS = { x = true, close = true, exit = true, ["✕"] = true, ["×"] = true, ["✖"] = true }

    local function FindCloseButton(root)
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("GuiButton") and IsShown(d) then
                local text = d:IsA("TextButton") and string.lower(StripTags(d.Text)) or ""
                text = string.match(text, "^%s*(.-)%s*$") or text
                if CLOSE_NAMES[string.lower(d.Name)] or CLOSE_TEXTS[text] then return d end
            end
        end
        return nil
    end

    local function CloseQuestGui(pos, enabled)
        -- หน้าบอร์ดมีปุ่ม "Exit" สีแดงมุมขวาบน: กดปุ่มนี้ก่อนเลย
        local exitBtn = FindGuiText("exit")
        if exitBtn then
            ClickGui(exitBtn)
            HoldFor(0.4, pos, enabled)
            lastBoardAnchor = nil
            return true
        end

        local anchor = lastBoardAnchor
        if not (anchor and anchor.Parent) then anchor = FindGuiText("accept") end
        if not anchor then lastBoardAnchor = nil return false end

        local cur = anchor.Parent
        while cur do
            local btn = FindCloseButton(cur)
            if btn then
                ClickGui(btn)
                HoldFor(0.4, pos, enabled)
                lastBoardAnchor = nil
                return true
            end
            if cur:IsA("ScreenGui") then break end
            cur = cur.Parent
        end
        lastBoardAnchor = nil
        return false
    end

    -- ทางสำรอง: กด Accept บนหน้าบอร์ด (ถ้าเลือกเควสเฉพาะ จะกดลูกศร ">" ไปหาเควสนั้นก่อน)
    local function AcceptViaGui(wanted, pos, enabled)
        for _ = 1, 10 do
            if not (Alive() and enabled()) then return false end
            local accept = FindGuiText("accept")
            if not accept then return false end
            lastBoardAnchor = accept
            local matches = not wanted -- wanted = nil: รับเควสที่แสดงอยู่เลย
            if wanted then
                for _, name in ipairs(wanted) do
                    if FindGuiText(string.lower(name)) then matches = true break end
                end
            end
            if matches then
                ClickGui(accept)
                HoldFor(1.2, pos, enabled)
                return ReadQuest() ~= nil
            end
            local nextBtn = FindGuiText(">")
            if not nextBtn then return false end
            ClickGui(nextBtn)
            HoldFor(0.4, pos, enabled)
        end
        return false
    end

    ---------------------------------------------------------
    -- 🔀 เปลี่ยนเควสอัตโนมัติด้วยลูกศร < >
    -- อ่านการ์ดเควสที่แสดงบนหน้าบอร์ด (ชื่อ / ความหายาก / Exp / เลเวลที่ต้องใช้ / ทำเสร็จแล้วหรือยัง)
    -- กดลูกศรไล่ดูทุกเควส แล้วเลือกอันที่ดีที่สุดตามโหมดที่ติ๊กไว้ จากนั้นกดลูกศรไปหาและกด Accept
    ---------------------------------------------------------
    local function KnownQuestNames()
        local map = {}
        for _, name in ipairs(questOptions) do
            if name ~= "Smart" and name ~= "Auto" then map[string.lower(name)] = name end
        end
        return map
    end

    local function ReadBoardCard()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return nil end
        local names = KnownQuestNames()
        local card = { exp = 0, level = 0, completed = false, canAccept = false }

        for _, d in ipairs(pg:GetDescendants()) do
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text ~= "" and IsShown(d) then
                local text = string.match(StripTags(d.Text), "^%s*(.-)%s*$") or ""
                local low = string.lower(text)

                if names[low] and not card.name then card.name = names[low] end
                if low == "legendary" or low == "rare" or low == "common" then card.rarity = low end
                if low == "completed" then card.completed = true end
                if low == "accept" then card.canAccept = true end

                local exp = string.match(text, "^([%d,]+)%s+[Ee]xp$") -- "1,000 Exp" (ไม่ตรงกับป้าย "X2Exp : 1d" ด้านบน)
                if exp then card.exp = tonumber((string.gsub(exp, ",", ""))) or 0 end

                local lv = string.match(text, "[Ll]evel required:%s*(%d+)")
                if lv then card.level = tonumber(lv) or 0 end

                local clean = string.gsub(text, "^[^%w]+", "") -- ตัดขีด "- " หน้าข้อความออก
                local n, target = string.match(clean, "^[Kk]ill%s+(%d+)%s+(.-)%s*%.?%s*$")
                if n then card.need, card.target = tonumber(n), target end
            end
        end

        if not card.name then return nil end
        if not card.rarity then
            for _, m in ipairs(AllQuestModules()) do
                if m.Name == card.name and m.Parent then card.rarity = string.lower(m.Parent.Name) break end
            end
        end
        return card
    end

    -- หาปุ่มลูกศร: ข้อความ ">" / "<" ก่อน ถ้าไม่เจอลองหาจากชื่อปุ่ม (next/right, prev/left)
    local function FindArrow(dir)
        local btn = FindGuiText(dir)
        if btn then return btn end
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return nil end
        local words = (dir == ">") and { "next", "right", "forward" } or { "prev", "previous", "left", "back" }
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("GuiButton") and IsShown(d) then
                local n = string.lower(d.Name)
                for _, w in ipairs(words) do
                    if string.find(n, w, 1, true) then return d end
                end
            end
        end
        return nil
    end

    local function ClickArrow(dir)
        local btn = FindArrow(dir)
        if not btn then return false end
        return ClickGui(btn) and true or false
    end

    local function Sweep(dir, list, seen, pos, enabled)
        for _ = 1, 14 do
            if not (Alive() and enabled()) then return nil end
            local card = ReadBoardCard()
            if not card then return nil end
            if seen[card.name] then return card end -- เจออันเดิม = วนครบรอบ (หรือลูกศรไม่ขยับแล้ว)
            seen[card.name] = true
            list[#list + 1] = card
            if not ClickArrow(dir) then return card end
            HoldFor(0.35, pos, enabled)
        end
        return nil
    end

    -- กดลูกศรไล่ดูทุกเควสบนบอร์ด ได้รายการการ์ดทั้งหมด
    local function BrowseBoard(pos, enabled)
        local list, seen = {}, {}
        local stop = Sweep(">", list, seen, pos, enabled)
        -- ถ้าลูกศรไม่วนรอบ (ไปติดที่อันสุดท้าย) ให้ย้อนกลับด้วย "<" เก็บอันที่เหลือ
        if stop and #list > 1 and stop.name ~= list[1].name then
            if ClickArrow("<") then
                HoldFor(0.35, pos, enabled)
                Sweep("<", list, seen, pos, enabled)
            end
        end
        return list
    end

    -- กดลูกศรไปหาเควสที่ต้องการ
    local function GoToQuest(name, pos, enabled)
        for _, dir in ipairs({ ">", "<" }) do
            local lastName = nil
            for _ = 1, 14 do
                if not (Alive() and enabled()) then return false end
                local card = ReadBoardCard()
                if card and card.name == name then return true end
                if card and card.name == lastName then break end -- ลูกศรไม่ขยับ: ลองอีกทิศ
                lastName = card and card.name
                if not ClickArrow(dir) then break end
                HoldFor(0.35, pos, enabled)
            end
        end
        local card = ReadBoardCard()
        return card ~= nil and card.name == name
    end

    -- เรียงเควสที่ "รับได้" (ยังไม่ Completed และเลเวลถึง) ตามโหมดที่ติ๊กไว้
    local function RankBoardCards(cards)
        local picks = QuestCfg.Picks or {}
        local myLevel = MyLevel()
        -- รองรับเฉพาะเควสฆ่ามอน ("Kill N <ชื่อมอน>") เควสแบบอื่นถือว่าไม่รองรับ -> ไม่เลือก
        -- (กันพลาด: ถ้าไม่มีการ์ดไหนอ่านเจอว่าเป็นเควสฆ่ามอนเลย แปลว่าอ่านข้อความไม่ได้ ให้ถือว่ารองรับทั้งหมด)
        local anySupported = false
        for _, c in ipairs(cards) do
            if c.target then anySupported = true break end
        end

        local usable = {}
        for _, c in ipairs(cards) do
            local supported = (not anySupported) or c.target ~= nil
            if supported and not c.completed and (not myLevel or c.level <= myLevel) then
                table.insert(usable, c)
            end
        end

        local order, used = {}, {}
        for _, c in ipairs(usable) do -- เควสที่ติ๊กเลือกเอง มาก่อน
            if picks[c.name] then table.insert(order, c) used[c] = true end
        end

        local rest = {}
        for _, c in ipairs(usable) do
            if not used[c] then table.insert(rest, c) end
        end

        local function rarityScore(c) return RARITY_SCORE[c.rarity and (string.upper(string.sub(c.rarity, 1, 1)) .. string.sub(c.rarity, 2)) or ""] or 0 end

        if picks.Smart then
            local function score(c)
                local s = rarityScore(c) + math.min(c.exp or 0, 999999) / 100
                if c.target and #QuestTargets(c.target) > 0 then s += 500 end -- มอนเป้าหมายเกิดอยู่ตอนนี้ ทำได้ทันที
                return s
            end
            local scored = {}
            for i, c in ipairs(rest) do scored[i] = { card = c, score = score(c), idx = i } end
            table.sort(scored, function(a, b)
                if a.score ~= b.score then return a.score > b.score end
                return a.idx < b.idx
            end)
            for _, s in ipairs(scored) do table.insert(order, s.card) end
        elseif picks.Auto or #order == 0 then
            local indexed = {}
            for i, c in ipairs(rest) do indexed[i] = { card = c, idx = i } end
            table.sort(indexed, function(a, b)
                local ra, rb = rarityScore(a.card), rarityScore(b.card)
                if ra ~= rb then return ra > rb end
                return a.idx < b.idx
            end)
            for _, s in ipairs(indexed) do table.insert(order, s.card) end
        end
        return order
    end

    -- กดลูกศรไปหาเควสตามลำดับ แล้วกด Accept
    local function AcceptOrdered(order, pos, enabled)
        for _, card in ipairs(order) do
            if not (Alive() and enabled()) then return false end
            SetText(QuestStatusLabel, "Switching quest: " .. card.name)
            if GoToQuest(card.name, pos, enabled) then
                local accept = FindGuiText("accept")
                if accept then
                    lastBoardAnchor = accept
                    ClickGui(accept)
                    HoldFor(1.2, pos, enabled)
                    if ReadQuest() then return true end
                end
            end
        end
        return false
    end

    local QuestRemoteUseless = false -- true = Remote ถูกปฏิเสธ แต่ปุ่ม Accept ใช้ได้ -> ข้าม Remote
    local function StartQuest()
        local function enabled() return QuestEnabled() end
        local board = FindBoard()
        if not board then
            SetText(QuestStatusLabel, "Quest board not found")
            QuestExhaustedAt, QuestExhaustedLevel = os.clock(), CurrentLevel()
            HoldFor(3, nil, enabled)
            return
        end

        SetText(QuestStatusLabel, "Flying to Quest board...")
        local pos = PosOf(board) + Vector3.new(0, 3, 0)
        if not FlyTo(pos, enabled, 25) then return end

        SetText(QuestStatusLabel, "Talking to board (E x5)...")
        PressE5(enabled)
        HoldFor(1.0, pos, enabled)
        if not (ReadQuest() or FindGuiText("accept") or FindGuiText("completed")) then
            Interact(board) -- กด E แล้วหน้าบอร์ดไม่เปิด: ลองกด Prompt ตรงๆ อีกที
            HoldFor(1.2, pos, enabled)
        end
        if ReadQuest() then
            CloseQuestGui(pos, enabled) -- กดคุยแล้วได้เควส/รับรางวัลแล้ว
            return
        end

        -- กดลูกศร < > ไล่ดูทุกเควสบนบอร์ด แล้วจัดอันดับ (ข้ามเควสที่ Completed แล้ว / เลเวลไม่ถึง)
        SetText(QuestStatusLabel, "Checking quests (< > arrows)...")
        local cards = BrowseBoard(pos, enabled)
        local order = RankBoardCards(cards)
        if #cards > 0 and #order == 0 then
            SetText(QuestStatusLabel, "No quest available (completed / level too low)")
            CloseQuestGui(pos, enabled)
            QuestExhaustedAt, QuestExhaustedLevel = os.clock(), CurrentLevel()
            HoldFor(1, nil, enabled)
            return
        end

        local candidates, wantedNames
        if #order > 0 then
            candidates = {}
            local modByName = {}
            for _, m in ipairs(AllQuestModules()) do modByName[m.Name] = m end
            for _, c in ipairs(order) do
                if modByName[c.name] then table.insert(candidates, modByName[c.name]) end
            end
        else
            candidates, wantedNames = BuildQuestCandidates() -- อ่านหน้าบอร์ดไม่ได้: ใช้วิธีเดิมจากข้อมูลเควส
        end

        -- วิธีที่ 1: Remote RequestQuest
        local network = ReplicatedStorage:FindFirstChild("Network")
        local remote = network and network:FindFirstChild(QUEST_REMOTE)
        if remote and not QuestRemoteUseless then
            for _, mod in ipairs(candidates) do
                if not (Alive() and enabled()) then return end
                SetText(QuestStatusLabel, "Requesting: " .. mod.Name)
                local guid = string.lower(HttpService:GenerateGUID(false))
                pcall(function() remote:FireServer("RequestQuest", mod, guid) end)
                HoldFor(1.2, pos, enabled)
                if ReadQuest() then
                    SetText(QuestStatusLabel, "Accepted: " .. mod.Name)
                    SetText(QuestStatusLabel, "Closing quest window...")
                    CloseQuestGui(pos, enabled)
                    SetText(QuestStatusLabel, "Accepted: " .. mod.Name)
                    return
                end
            end
        end

        -- วิธีที่ 2: กดปุ่ม Accept บนหน้าบอร์ด
        SetText(QuestStatusLabel, "Accepting via board UI...")
        local accepted
        if #order > 0 then
            accepted = AcceptOrdered(order, pos, enabled)
        else
            accepted = AcceptViaGui(wantedNames, pos, enabled)
        end
        if accepted then
            if remote and not QuestRemoteUseless then QuestRemoteUseless = true end
            SetText(QuestStatusLabel, "Closing quest window...")
            CloseQuestGui(pos, enabled)
            SetText(QuestStatusLabel, "Accepted via board UI")
        else
            SetText(QuestStatusLabel, "Could not accept a quest")
            QuestExhaustedAt, QuestExhaustedLevel = os.clock(), CurrentLevel()
        end
    end

    local QuestsDone, lastQuest, lastStartAt = 0, nil, 0
    local QuestWaitSince = nil
    local function TryStartQuest()
        local function enabled() return QuestEnabled() end
        if os.clock() - lastStartAt < 6 then
            HoldFor(0.5, nil, enabled)
            return
        end
        lastStartAt = os.clock()
        StartQuest()
    end

    local function QuestStep()
        local function enabled() return QuestEnabled() end
        local q = ReadQuest()
        if q then
            lastQuest = q
            if not q.name then
                SetText(QuestStatusLabel, "Unsupported quest (kill quests only)")
                if not QuestCfg.Enabled then
                    QuestPausedUntil = os.clock() + 120 -- โหมดฟาร์มก่อน: เควสนี้ทำไม่ได้ ข้ามไปฟาร์มเควสปกติ
                end
                HoldFor(1, nil, enabled)
                return
            end
            if q.need > 0 and q.have >= q.need then
                SetText(QuestStatusLabel, "Quest complete - back to board")
                TryStartQuest()
                return
            end
            local root = GetMyRoot()
            local target, td = nil, math.huge
            if root then
                for _, m in ipairs(QuestTargets(q.name)) do
                    local d = (m.HumanoidRootPart.Position - root.Position).Magnitude
                    if d < td then target, td = m, d end
                end
            end
            if target then
                QuestWaitSince = nil
                SetText(QuestStatusLabel, string.format("Killing %s (%d/%d)", q.name, q.have, q.need))
                HuntOne(target, enabled)
            else
                SetText(QuestStatusLabel, "Waiting for " .. q.name .. " to spawn...")
                QuestWaitSince = QuestWaitSince or os.clock()
                if not QuestCfg.Enabled and os.clock() - QuestWaitSince > 45 then
                    QuestPausedUntil = os.clock() + 120 -- โหมดฟาร์มก่อน: รอนานเกินไป พักเควสบอร์ด ให้ฟาร์มเควสปกติไปก่อน
                    QuestWaitSince = nil
                end
                HoldFor(0.5, nil, enabled)
            end
            return
        end

        if lastQuest then
            QuestsDone += 1
            lastQuest = nil
            SetText(QuestCountLabel, tostring(QuestsDone))
        end
        TryStartQuest()
    end

    ---------------------------------------------------------
    -- 🧱 No Clip ตอนฟาร์ม: ทุกฟังก์ชันฟาร์ม (เวล / มอน / บอส / World Boss / กล่อง / ดอกไม้ / Quest Board)
    ---------------------------------------------------------
    task.spawn(function()
        while Alive() do
            local cfg = _G.SmoothHubConfig
            if ChestEnabled() or ItemConfig.Flower or QuestEnabled()
                or cfg.AutoFarmLevel or cfg.EnableFarmMonster or cfg.EnableFarmBoss or cfg.AutoStartWorldBoss then
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

    ---------------------------------------------------------
    -- 🌈 RGB รอบตัวละครตอนฟาร์ม: Chest / Flower / Quest Board / World Boss
    -- (ฟาร์มเวล ฟาร์มมอน ฟาร์มบอส มีกรอบ RGB ของตัวเองอยู่แล้ว ถ้าตัวใดตัวหนึ่งเปิดอยู่ จะไม่สร้างซ้ำ)
    ---------------------------------------------------------
    task.spawn(function()
        local highlight = nil
        while Alive() do
            task.wait(0.1)
            local cfg = _G.SmoothHubConfig
            local hasOwnRGB = cfg.AutoFarmLevel or cfg.EnableFarmMonster or cfg.EnableFarmBoss
            local farming = ChestEnabled() or ItemConfig.Flower or QuestEnabled() or cfg.AutoStartWorldBoss
            local character = LocalPlayer.Character

            if farming and not hasOwnRGB and character then
                if not highlight or highlight.Parent ~= character then
                    if highlight then highlight:Destroy() end
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SmoothHubRGBFarm"
                    highlight.Adornee = character
                    highlight.FillTransparency = 1
                    highlight.OutlineTransparency = 0
                    highlight.Parent = character
                end
                highlight.OutlineColor = Color3.fromHSV((tick() % 5) / 5, 1, 1)
            elseif highlight then
                highlight:Destroy()
                highlight = nil
            end
        end
        if highlight then highlight:Destroy() end
    end)

    ---------------------------------------------------------
    -- ลูปหลัก (ทำทีละอย่าง กันแย่งตัวละคร) ลำดับ: Chest > Flower > Quest
    ---------------------------------------------------------
    task.spawn(function()
        while Alive() do
            task.wait((QuestEnabled() or ChestEnabled()) and 0.1 or 0.3)
            local didSomething = false

            if ChestEnabled() then
                local chest = FindNearest("Chest", ChestDone, 60)
                if chest then
                    didSomething = true
                    _G.SmoothHubItemWorking = true
                    local ok, err = pcall(RunChest, chest)
                    ClaimPending = false
                    _G.SmoothHubItemWorking = false
                    _G.SmoothHubItemBusyUntil = os.clock() + 1.5
                    if not ok then
                        ChestDone[chest] = os.clock()
                        SetText(ChestStatusLabel, "Error: " .. tostring(err))
                    end
                else
                    SetText(ChestStatusLabel, "Waiting for chest...")
                end
            else
                SetText(ChestStatusLabel, "Idle")
            end

            if not didSomething then
                if ItemConfig.Flower then
                    local flower = FindNearest("Flower", FlowerDone, 20)
                    if flower then
                        didSomething = true
                        _G.SmoothHubItemWorking = true
                        local ok, err = pcall(RunFlower, flower)
                        _G.SmoothHubItemWorking = false
                        _G.SmoothHubItemBusyUntil = os.clock() + 1.5
                        if not ok then
                            FlowerDone[flower] = os.clock()
                            SetText(FlowerStatusLabel, "Error: " .. tostring(err))
                        end
                    else
                        SetText(FlowerStatusLabel, "Waiting for flower...")
                    end
                else
                    SetText(FlowerStatusLabel, "Idle")
                end
            end

            if not didSomething then
                if QuestEnabled() then
                    _G.SmoothHubItemWorking = true
                    local ok, err = pcall(QuestStep)
                    _G.SmoothHubItemWorking = false
                    _G.SmoothHubItemBusyUntil = os.clock() + 1.5
                    if not ok then
                        SetText(QuestStatusLabel, "Error: " .. tostring(err))
                        task.wait(2)
                    end
                else
                    SetText(QuestStatusLabel, "Idle")
                end
            end
        end
    end)
end

---------------------------------------------------------
-- แท็บ Shop (แท็บใหม่)
-- อยากเพิ่มฟีเจอร์ในแท็บนี้ ให้ต่อจาก ShopForm ได้เลย (เพิ่ม Row / Toggle / PullDownButton ฯลฯ)
---------------------------------------------------------
local ShopTab = CategorySection:Tab({
    Title = "Shop",
    Icon = Cascade.Symbols["cartFill"] or Cascade.Symbols["bagFill"] or Cascade.Symbols["leafFill"]
})

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ShopCfg = _G.SmoothHubConfig.Shop -- ถูกโหลดค่าที่เซฟไว้ให้แล้วจาก SettingsStore.Restore

    -- รายชื่อหน้ากาก (ชื่อตรงกับที่ Remote Spy จับได้ตอนกดซื้อ)
    local MASKS = {
        "Blackdog", "Devil Ape", "Gourmet", "Null Mask", "Mockery", "Red Iris",
        "Toxic Vanguard", "Nishiki", "Ayato", "Hinami", "Tatara's Mask",
    }

    -- ชื่อ Remote ที่จับได้ (RemoteFunction ใน ReplicatedStorage.Network) ใช้เป็นตัวเลือกแรกเท่านั้น
    -- ชื่อใน Network เปลี่ยนตามเซิร์ฟเวอร์ได้ จึงมีระบบหา Remote เองจากโฟลเดอร์ Network ด้วย (ดู ResolveBuyRemote)
    local KNOWN_BUY_REMOTE = "{CB9E5C07-3661-4EAC-B76D-553560668412}"

    -- ตรวจค่าที่โหลดมา: เหลือเฉพาะชื่อที่มีจริง ไม่ซ้ำ เรียงตามลำดับเดิม
    do
        local clean, seen = {}, {}
        if type(ShopCfg.Masks) == "table" then
            for _, name in ipairs(ShopCfg.Masks) do
                if table.find(MASKS, name) and not seen[name] then
                    seen[name] = true
                    table.insert(clean, name)
                end
            end
        end
        ShopCfg.Masks = clean
        ShopCfg.Delay = math.clamp(tonumber(ShopCfg.Delay) or 1, 1, 60)
        ShopCfg.AutoBuy = ShopCfg.AutoBuy == true
    end

    ---------------------------------------------------------
    -- UI : Auto Buy Mask
    ---------------------------------------------------------
    local BuySection = ShopTab:PageSection({
        Title = "🛒 Auto Buy Mask",
        Subtitle = "Buys the ticked masks one by one, in the order ticked.",
    })
    local BuyForm = BuySection:Form()

    local BuyToggleRow = BuyForm:Row()
    BuyToggleRow:Left():TitleStack({
        Title = "Auto Buy",
        Subtitle = "Buys each ticked mask once, then stops."
    })
    BuyToggleRow:Right():Toggle({
        Value = ShopCfg.AutoBuy,
        ValueChanged = function(self, value)
            ShopCfg.AutoBuy = value and true or false
        end
    })

    local MaskSelectRow = BuyForm:Row()
    MaskSelectRow:Left():TitleStack({
        Title = "Masks",
        Subtitle = "Tick one or more. First ticked = bought first."
    })
    local initialIndexes = {}
    for _, name in ipairs(ShopCfg.Masks) do
        table.insert(initialIndexes, table.find(MASKS, name))
    end

    local RefreshShop -- ประกาศไว้ก่อน (กำหนดค่าด้านล่าง)
    MaskSelectRow:Right():PopUpButton({
        Options = MASKS,
        Maximum = #MASKS,
        Value = initialIndexes,
        ValueChanged = function(self, value)
            -- value เรียงตามลำดับที่ติ๊ก (ติ๊กก่อนอยู่หน้า)
            local names = {}
            for _, index in ipairs(value or {}) do
                if MASKS[index] then table.insert(names, MASKS[index]) end
            end
            ShopCfg.Masks = names
            if RefreshShop then RefreshShop() end
        end
    })

    local BuyDelayRow = BuyForm:Row()
    BuyDelayRow:Left():TitleStack({
        Title = "Buy Delay",
        Subtitle = "Seconds between purchases."
    })
    BuyDelayRow:Right():Stepper({
        Minimum = 1,
        Maximum = 60,
        Step = 1,
        Fielded = true,
        Value = ShopCfg.Delay,
        ValueChanged = function(self, value)
            ShopCfg.Delay = math.clamp(tonumber(value) or 1, 1, 60)
        end
    })

    local DebugRow = BuyForm:Row()
    DebugRow:Left():TitleStack({
        Title = "Debug: Print Remotes",
        Subtitle = "Prints shop remotes to the console (F9). For bug reports."
    })
    DebugRow:Right():Button({
        Label = "Print",
        Callback = function()
            local network = ReplicatedStorage:FindFirstChild("Network")
            if not network then
                print("[Smooth Hub] ReplicatedStorage.Network not found")
                return
            end
            for _, child in ipairs(network:GetChildren()) do
                print(string.format("[Smooth Hub] %s : %s", child.ClassName, child.Name))
            end
        end
    })

    ---------------------------------------------------------
    -- UI : Status
    ---------------------------------------------------------
    local StatusSection = ShopTab:PageSection({
        Title = "📊 Status",
        Subtitle = "What Auto Buy is doing now.",
    })
    local StatusForm = StatusSection:Form()

    local function AddInfoRow(title, text)
        local row = StatusForm:Row()
        row:Left():Label({ Text = title })
        return row:Right():Label({ Text = text })
    end
    local StatusLabel   = AddInfoRow("Status", OFF_TEXT)
    local NowLabel      = AddInfoRow("Now", "-")
    local NextLabel     = AddInfoRow("Next", "-")
    local ProgressLabel = AddInfoRow("Progress", "Bought 0 | Failed 0 | Left 0")

    -- รายการทั้งหมดตามลำดับที่ติ๊ก (แสดงเฉพาะหน้ากากที่ติ๊กไว้)
    local OrderSection = ShopTab:PageSection({
        Title = "🧾 Buy Order",
        Subtitle = "Ticked masks, in buying order.",
    })
    local OrderForm = OrderSection:Form()
    local MaskRows = {}
    for _, name in ipairs(MASKS) do
        local row = OrderForm:Row()
        row:Left():Label({ Text = name })
        MaskRows[name] = { Row = row, Label = row:Right():Label({ Text = "-" }) }
    end

    ---------------------------------------------------------
    -- ระบบซื้อ
    ---------------------------------------------------------
    local results = {}     -- results[ชื่อ] = { kind = "bought" | "sent" | "failed", text = "..." }
    local current = nil    -- หน้ากากที่กำลังซื้ออยู่ตอนนี้
    local lastResult = nil -- ผลล่าสุด { name, kind, text }
    local lastError = nil  -- ปัญหาที่ทำให้ซื้อไม่ได้ (เช่น หา Remote ไม่เจอ)
    local waitUntil = 0
    local wasOn = false
    local cachedRemote = nil
    local shown = setmetatable({}, { __mode = "k" }) -- กันตั้งข้อความซ้ำถ้าไม่เปลี่ยน

    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        if shown[label] == text then return end
        shown[label] = text
        pcall(function() label.Text = text end)
    end
    _G.SmoothHubLiveKeys[StatusLabel] = "Shop"

    local function Pending()
        local list = {}
        for _, name in ipairs(ShopCfg.Masks) do
            if not results[name] then table.insert(list, name) end
        end
        return list
    end


    -- หา Remote ซื้อของ Shop: ใช้เฉพาะ GUID ที่รู้จักแน่นอนเท่านั้น (ไม่เดา ไม่ยิงทุก Remote)
    local function ResolveBuyRemote()
        if cachedRemote and cachedRemote.Parent then return cachedRemote end
        cachedRemote = nil
        local network = ReplicatedStorage:FindFirstChild("Network")
        if not network then return nil, {}, "Network folder not found" end
        local known = network:FindFirstChild(KNOWN_BUY_REMOTE)
        if known and known:IsA("RemoteFunction") then
            cachedRemote = known
            return known
        end
        return nil, {}, "Shop remote not found (the game may have changed it) - nothing was sent"
    end

    -- เรียก InvokeServer พร้อมเวลารอสูงสุด (กันค้างถ้าเซิร์ฟเวอร์ไม่ตอบ)
    local function InvokeOne(remote, name, timeout)
        local replied, ok, reply = false, false, nil
        task.spawn(function()
            ok, reply = pcall(function() return remote:InvokeServer(name) end)
            replied = true
        end)
        local t0 = os.clock()
        while not replied and os.clock() - t0 < timeout do task.wait(0.05) end
        if not replied then return false, "no reply (timeout)" end
        return ok, reply
    end


    local function Classify(ok, reply)
        if not ok then return "failed", tostring(reply) end
        if reply == false then return "failed", "server replied false" end
        if reply == true then return "bought", "reply: true" end
        if reply == nil then return "sent", "no reply value" end
        if type(reply) == "string" or type(reply) == "number" then
            return "sent", "reply: " .. tostring(reply)
        end
        return "sent", "reply: " .. typeof(reply)
    end

    ---------------------------------------------------------
    -- อัปเดต Status ทั้งหมด (ตั้งข้อความเฉพาะที่เปลี่ยน)
    ---------------------------------------------------------
    RefreshShop = function()
        local on = ShopCfg.AutoBuy
        local pending = Pending()
        local bought, failed = 0, 0
        for _, name in ipairs(ShopCfg.Masks) do
            local r = results[name]
            if r then
                if r.kind == "failed" then failed += 1 else bought += 1 end
            end
        end

        -- ตัวถัดไป = ตัวถัดจากที่กำลังซื้ออยู่ (ถ้าไม่ได้ซื้ออยู่ = ตัวแรกที่ยังไม่ซื้อ)
        local nextName
        if current then
            for _, name in ipairs(pending) do
                if name ~= current then nextName = name break end
            end
        else
            nextName = pending[1]
        end

        -- Status หลัก
        local statusText
        if not on then
            statusText = Colorize(OFF_TEXT, "#96A5AA")
        elseif #ShopCfg.Masks == 0 then
            statusText = Colorize("No mask selected", "#FFB432")
        elseif lastError and not current then
            statusText = Colorize(lastError, BOSS_RED)
        elseif current then
            statusText = Colorize(string.format("Buying %s (%d/%d)", current, bought + failed + 1, #ShopCfg.Masks), "#64C8FF")
        elseif #pending == 0 then
            statusText = failed > 0
                and Colorize(string.format("Finished - %d bought, %d failed", bought, failed), "#FFB432")
                or Colorize(string.format("Finished - %d bought", bought), BOSS_GREEN)
        else
            local remain = math.max(0, math.ceil(waitUntil - os.clock()))
            statusText = Colorize(string.format("Next purchase in %ds", remain), "#64C8FF")
        end
        SetText(StatusLabel, statusText)

        -- Now: กำลังทำอะไรอยู่ / ผลล่าสุด
        local nowText = "-"
        if current then
            nowText = Colorize("🛒 Buying " .. current .. "...", "#64C8FF")
        elseif lastResult then
            local good = lastResult.kind ~= "failed"
            nowText = Colorize(
                string.format("%s %s - %s", good and "✅" or "❌", lastResult.name, lastResult.text),
                good and BOSS_GREEN or BOSS_RED
            )
        end
        SetText(NowLabel, nowText)

        SetText(NextLabel, nextName and Colorize("⏭ " .. nextName, "#FFB432") or "-")
        SetText(ProgressLabel, string.format("Bought %d | Failed %d | Left %d", bought, failed, #pending))

        -- รายการทั้งหมดตามลำดับที่ติ๊ก
        for _, name in ipairs(MASKS) do
            local entry = MaskRows[name]
            local order = table.find(ShopCfg.Masks, name)
            pcall(function() entry.Row.Visible = order ~= nil end)
            if order then
                local r = results[name]
                local text
                if r then
                    if r.kind == "failed" then
                        text = Colorize("❌ Failed - " .. r.text, BOSS_RED)
                    else
                        text = Colorize("✅ " .. (r.kind == "bought" and "Bought" or "Sent") .. " (" .. r.text .. ")", BOSS_GREEN)
                    end
                elseif current == name then
                    text = Colorize("🛒 Buying...", "#64C8FF")
                elseif nextName == name then
                    text = Colorize("⏭ Next", "#FFB432")
                else
                    text = "⏳ Queued"
                end
                SetText(entry.Label, string.format("#%d  %s", order, text))
            end
        end
    end

    ---------------------------------------------------------
    -- ลูปหลัก: ซื้อทีละชิ้นตามลำดับที่ติ๊ก
    ---------------------------------------------------------
    task.spawn(function()
        while true do
            task.wait(0.2)

            if not ShopCfg.AutoBuy then
                if wasOn then
                    -- ปิดสวิตช์: ล้างผล เปิดใหม่รอบหน้าจะเริ่มซื้อใหม่ทั้งหมด
                    results, current, lastResult, lastError = {}, nil, nil, nil
                end
                wasOn = false
                RefreshShop()
                continue
            end
            wasOn = true

            if #ShopCfg.Masks == 0 or os.clock() < waitUntil then
                RefreshShop()
                continue
            end

            local pending = Pending()
            if #pending == 0 then
                RefreshShop()
                continue
            end

            local name = pending[1]
            local remote, candidates, why = ResolveBuyRemote()
            if not remote and (why or #candidates == 0) then
                lastError = why or "Shop remote not found"
                waitUntil = os.clock() + 3
                RefreshShop()
                continue
            end
            lastError = nil

            current = name
            RefreshShop()

            local kind, text
            local ok, reply = InvokeOne(remote, name, 6)
            kind, text = Classify(ok, reply)

            -- ผู้ใช้ปิดสวิตช์ / เอาติ๊กออกระหว่างรอ: ไม่บันทึกผล
            if ShopCfg.AutoBuy and table.find(ShopCfg.Masks, name) then
                results[name] = { kind = kind, text = text }
                lastResult = { name = name, kind = kind, text = text }
            end
            current = nil
            waitUntil = os.clock() + (ShopCfg.Delay or 1)
            RefreshShop()
        end
    end)

    RefreshShop()
end

---------------------------------------------------------
-- แท็บ Black Market
-- 1) NPC อยู่ที่ Workspace.TalkNpc.BlackMarket (เกิดเป็นช่วง ๆ) ถ้าเกิดแล้ว -> บินไปหา -> กด Talk (F)
-- 2) กดตัวเลือก "..." ในกล่องคุย เพื่อเปิดหน้าร้าน BLACK MARKET
-- 3) Auto Buy : คลิกเลือกของทีละชิ้น -> อ่านความหายาก (Secret / Mythical / Legendary ...) จากแผงรายละเอียด
--    -> ถ้าตรงกับที่ติ๊กไว้ กดปุ่ม BUY (หรือส่ง Remote) -> ครบแล้วปิดร้าน กด Bye แล้วกลับไปฟาร์มต่อ
-- ใช้ do ... end ครอบ เพื่อไม่ให้ตัวแปร local เกินลิมิต 200 ตัวของ Lua
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local token = {}
    _G.SmoothHubBlackMarketToken = token
    local function Alive() return _G.SmoothHubBlackMarketToken == token end

    local BM = _G.SmoothHubConfig.BlackMarket -- ถูกโหลดค่าที่เซฟไว้ให้แล้วจาก SettingsStore.Restore
    BM.Delay = math.clamp(tonumber(BM.Delay) or 30, 5, 300)
    if type(BM.Rarities) ~= "table" then BM.Rarities = {} end
    if BM.BuyMethod ~= "Click Button" and BM.BuyMethod ~= "Remote" then BM.BuyMethod = "Click Button" end

    local RARITY_OPTIONS = { "Secret", "Mythical", "Legendary", "Epic", "Rare", "Uncommon", "Common" }
    -- ข้อความความหายากที่อ่านจากแผงรายละเอียด -> ชื่อตัวเลือก ("Race" ใส่เผื่อไว้ให้นับเป็น Rare)
    local RARITY_MAP = {
        secret = "Secret", mythical = "Mythical", legendary = "Legendary", epic = "Epic",
        rare = "Rare", race = "Rare", uncommon = "Uncommon", common = "Common",
    }

    local BlackMarketTab = CategorySection:Tab({
        Title = "Black Market",
        Icon = Cascade.Symbols["bagFill"] or Cascade.Symbols["cartFill"] or Cascade.Symbols["leafFill"]
    })
    _G.SmoothHubBlackMarketTab = BlackMarketTab -- ให้ระบบรีเฟรชธีมเห็นแท็บนี้

    ---------------------------------------------------------
    -- UI
    ---------------------------------------------------------
    local MainSection = BlackMarketTab:PageSection({
        Title = "🕶️ Black Market",
        Subtitle = "Visits the Black Market NPC when it spawns."
    })
    local MainForm = MainSection:Form()

    local EnableRow = MainForm:Row()
    EnableRow:Left():TitleStack({
        Title = "Auto Visit NPC",
        Subtitle = "Flies to the NPC, talks and opens the shop."
    })
    EnableRow:Right():Toggle({
        Value = BM.Enabled,
        ValueChanged = function(self, value) BM.Enabled = value and true or false end
    })

    local PauseRow = MainForm:Row()
    PauseRow:Left():TitleStack({
        Title = "Pause Monster / Boss Farm",
        Subtitle = "Pauses them during the visit, then resumes."
    })
    PauseRow:Right():Toggle({
        Value = BM.PauseFarms,
        ValueChanged = function(self, value) BM.PauseFarms = value and true or false end
    })

    local DelayRow = MainForm:Row()
    DelayRow:Left():TitleStack({
        Title = "Revisit Delay",
        Subtitle = "Seconds before visiting again (5 - 300)."
    })
    DelayRow:Right():Stepper({
        Minimum = 5,
        Maximum = 300,
        Step = 5,
        Fielded = true,
        Value = BM.Delay,
        ValueChanged = function(self, value)
            BM.Delay = math.clamp(tonumber(value) or 30, 5, 300)
        end
    })

    local BuySection = BlackMarketTab:PageSection({
        Title = "🛒 Auto Buy",
        Subtitle = "Buys only the rarities you tick."
    })
    local BuyForm = BuySection:Form()

    local BuyRow = BuyForm:Row()
    BuyRow:Left():TitleStack({
        Title = "Enable Auto Buy",
        Subtitle = "Needs Auto Visit NPC. Closes the shop when done."
    })
    BuyRow:Right():Toggle({
        Value = BM.AutoBuy,
        ValueChanged = function(self, value) BM.AutoBuy = value and true or false end
    })

    local RarityRow = BuyForm:Row()
    RarityRow:Left():TitleStack({
        Title = "Rarities",
        Subtitle = "Tick one or more. Others are skipped."
    })
    RarityRow:Right():PopUpButton({
        Options = RARITY_OPTIONS,
        Maximum = #RARITY_OPTIONS,
        Value = SettingsStore.IndexesFromMap(RARITY_OPTIONS, BM.Rarities),
        ValueChanged = function(self, value)
            local picked = {}
            for _, index in ipairs(value or {}) do
                picked[RARITY_OPTIONS[index]] = true
            end
            BM.Rarities = picked
        end
    })

    local methodOptions = { "Click Button", "Remote" }
    local MethodRow = BuyForm:Row()
    MethodRow:Left():TitleStack({
        Title = "Buy Method",
        Subtitle = "Click Button is safer. Remote sends the request directly."
    })
    MethodRow:Right():PullDownButton({
        Label = BM.BuyMethod,
        Options = methodOptions,
        Value = SettingsStore.IndexOf(methodOptions, BM.BuyMethod, 1),
        ValueChanged = function(self, index)
            BM.BuyMethod = methodOptions[index] or "Click Button"
            self.Label = BM.BuyMethod
        end
    })

    local StatusSection = BlackMarketTab:PageSection({
        Title = "📊 Status",
        Subtitle = "What it is doing now."
    })
    local StatusForm = StatusSection:Form()

    local StatusRow = StatusForm:Row()
    StatusRow:Left():Label({ Text = "Status" })
    local StatusLabel = StatusRow:Right():Label({ Text = "Idle" })

    local NpcRow = StatusForm:Row()
    NpcRow:Left():Label({ Text = "Black Market NPC" })
    local NpcLabel = NpcRow:Right():Label({ Text = "Not spawned" })

    local CountRow = StatusForm:Row()
    CountRow:Left():Label({ Text = "Times Talked" })
    local CountLabel = CountRow:Right():Label({ Text = "0" })

    local BoughtRow = StatusForm:Row()
    BoughtRow:Left():Label({ Text = "Items Bought" })
    local BoughtLabel = BoughtRow:Right():Label({ Text = "0" })

    local LastRow = StatusForm:Row()
    LastRow:Left():Label({ Text = "Last Item" })
    local LastLabel = LastRow:Right():Label({ Text = "-" })

    local DebugRow = StatusForm:Row()
    DebugRow:Left():TitleStack({
        Title = "Debug: Copy GUI Info",
        Subtitle = "Open the shop first. Copies screen info for bug reports."
    })

    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        pcall(function() label.Text = text end)
    end
    _G.SmoothHubLiveKeys[StatusLabel] = "BlackMarket"

    ---------------------------------------------------------
    -- ฟังก์ชันช่วย
    ---------------------------------------------------------
    local FLY_SPEED = 250

    local function GetMyRoot()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and hum and hum.Health > 0 then return root end
        return nil
    end

    local function PosOf(obj)
        if obj:IsA("Model") then return obj:GetPivot().Position end
        if obj:IsA("BasePart") then return obj.Position end
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end

    local function GetPrompt(obj) return obj:FindFirstChildWhichIsA("ProximityPrompt", true) end

    -- ตัดแท็ก RichText + ช่องว่างหัวท้าย
    local function Clean(s)
        s = string.gsub(tostring(s or ""), "<[^>]+>", "")
        return (string.match(s, "^%s*(.-)%s*$"))
    end

    local function IsShown(obj)
        local cur = obj
        while cur do
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            if cur:IsA("ScreenGui") and not cur.Enabled then return false end
            cur = cur.Parent
        end
        return true
    end

    local function WaitFor(check, timeout)
        local t0 = os.clock()
        while Alive() and os.clock() - t0 < timeout do
            if check() then return true end
            task.wait(0.15)
        end
        return check() and true or false
    end

    -- หา Label/ปุ่มที่ข้อความ (หลังตัดแท็ก) ผ่านเงื่อนไข pred และมองเห็นอยู่
    local function FindText(pred, scope)
        for _, d in ipairs((scope or PlayerGui):GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel")) and IsShown(d) then
                local t = Clean(d.Text)
                if t ~= "" and pred(t) then return d end
            end
        end
        return nil
    end

    ---------------------------------------------------------
    -- กดปุ่มบนหน้าจอ : 1) เรียก connection ของปุ่ม  2) คลิกเมาส์จำลองที่กลางปุ่ม
    ---------------------------------------------------------
    local function GetClickable(obj)
        local cur = obj
        while cur and cur ~= PlayerGui do
            if cur:IsA("GuiButton") then return cur end
            cur = cur.Parent
        end
        return obj
    end

    local function ClickSignal(btn)
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

    local function ClickMouse(obj)
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

    -- กด 1 ครั้งด้วยวิธีแรก แล้วรอเช็กผล ถ้าไม่สำเร็จค่อยลองอีกวิธี (กันกดซ้ำโดยไม่จำเป็น)
    local function ClickUntil(obj, check, wait)
        check = check or function() return true end
        wait = wait or 1
        local btn = GetClickable(obj)
        if ClickSignal(btn) and WaitFor(check, wait) then return true end
        if not btn.Parent then return check() end
        ClickMouse(btn)
        return WaitFor(check, wait)
    end

    ---------------------------------------------------------
    -- กล่องคุย : ตัวเลือก "..." และ "Bye..."
    ---------------------------------------------------------
    local function IsDots(t)
        if #t > 12 then return false end
        local r = string.gsub(t, "%.", "")
        r = string.gsub(r, "…", "")
        r = string.gsub(r, "·", "")
        r = string.gsub(r, "•", "")
        r = string.gsub(r, "%s", "")
        return r == ""
    end

    local function FindBye()
        return FindText(function(t) return string.lower(t):find("^bye") ~= nil end)
    end

    local function FindDialogOption()
        local dots = FindText(IsDots)
        if dots then return dots end
        -- ทางสำรอง: ปุ่มพี่น้องของ Bye... ที่ไม่ใช่ Bye (ตัวบนสุด)
        local bye = FindBye()
        if bye then
            local byeBtn = GetClickable(bye)
            local parent = byeBtn.Parent
            local best
            if parent then
                for _, sib in ipairs(parent:GetChildren()) do
                    if sib ~= byeBtn and sib:IsA("GuiButton") and IsShown(sib) then
                        if not best or sib.AbsolutePosition.Y < best.AbsolutePosition.Y then best = sib end
                    end
                end
            end
            return best
        end
        return nil
    end

    ---------------------------------------------------------
    -- หน้าร้าน BLACK MARKET
    ---------------------------------------------------------
    local function FindShopScope()
        local title = FindText(function(t) return string.lower(t) == "black market" end)
        if title then
            return title:FindFirstAncestorWhichIsA("ScreenGui") or PlayerGui, title
        end
        return nil
    end

    local function LabelOfButton(btn)
        if btn:IsA("TextButton") then return Clean(btn.Text) end
        local lbl = btn:FindFirstChildWhichIsA("TextLabel", true)
        return lbl and Clean(lbl.Text) or ""
    end

    -- ช่องของในร้าน = ปุ่มสี่เหลี่ยมขนาดใกล้กันที่อยู่กลุ่มเดียวกันมากที่สุด (ไม่นับปุ่ม X / BUY)
    local function GetSlots(scope)
        local groups = {}
        local function add(key, btn)
            if key then
                groups[key] = groups[key] or {}
                table.insert(groups[key], btn)
            end
        end
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("GuiButton") and IsShown(d) then
                local sz = d.AbsoluteSize
                local label = string.lower(LabelOfButton(d))
                if sz.X >= 40 and sz.X <= 220 and sz.Y >= 40 and sz.Y <= 220 and label ~= "x" and label ~= "buy" then
                    add(d.Parent, d)
                    if d.Parent then add(d.Parent.Parent, d) end
                end
            end
        end
        local best
        for _, list in pairs(groups) do
            if not best or #list > #best then best = list end
        end
        if not best or #best < 2 then return {} end
        table.sort(best, function(a, b)
            local ay, by = math.floor(a.AbsolutePosition.Y / 20), math.floor(b.AbsolutePosition.Y / 20)
            if ay ~= by then return ay < by end
            return a.AbsolutePosition.X < b.AbsolutePosition.X
        end)
        return best
    end

    local function InsideSlot(obj, slotSet)
        local cur = obj
        while cur do
            if slotSet[cur] then return true end
            cur = cur.Parent
        end
        return false
    end

    -- อ่านแผงรายละเอียดของของที่เลือกอยู่ : คืน (ความหายาก, ชื่อของ)
    local IGNORE_NAMES = { description = true, requirements = true, ["black market"] = true, buy = true, x = true }
    local function ReadPanel(scope, slotSet)
        local rarityLabel, rarity
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("TextLabel") and IsShown(d) and not InsideSlot(d, slotSet) then
                local r = RARITY_MAP[string.lower(Clean(d.Text))]
                if r then rarityLabel, rarity = d, r break end
            end
        end
        if not rarityLabel then return nil, nil end

        local nameLabel
        local rp = rarityLabel.AbsolutePosition
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("TextLabel") and d ~= rarityLabel and IsShown(d) and not InsideSlot(d, slotSet) then
                local t = Clean(d.Text)
                local dp = d.AbsolutePosition
                if t ~= "" and not IGNORE_NAMES[string.lower(t)] and not RARITY_MAP[string.lower(t)]
                    and dp.Y > rp.Y + 2 and math.abs(dp.X - rp.X) < 300 then
                    if not nameLabel or dp.Y < nameLabel.AbsolutePosition.Y then nameLabel = d end
                end
            end
        end
        return rarity, nameLabel and Clean(nameLabel.Text) or nil
    end

    local function SlotName(slot)
        local best
        for _, d in ipairs(slot:GetDescendants()) do
            if d:IsA("TextLabel") then
                local t = Clean(d.Text)
                if t ~= "" and not string.match(t, "^[xX]%w*$") and (not best or #t > #best) then best = t end
            end
        end
        return best
    end

    -- ซื้อ : วิธีที่ 1 กดปุ่ม BUY
    local function BuyByClick(scope)
        local buy = FindText(function(t) return string.lower(t) == "buy" end, scope)
        if not buy then return false end
        local btn = GetClickable(buy)
        if not ClickSignal(btn) then ClickMouse(btn) end
        return true
    end

    -- ซื้อ : วิธีที่ 2 ส่งคำสั่งซื้อตรง (ByteNetQuery : แพ็กเก็ต 3 + ความยาวชื่อ 2 ไบต์ + ชื่อของ ตามที่ Remote Spy จับได้)
    local function BuyByRemote(name)
        local sent = false
        task.spawn(function()
            pcall(function()
                local query = ReplicatedStorage.Modules.Network.ByteNetMax.system.ByteNetQuery
                local buf = buffer.create(3 + #name)
                buffer.writeu8(buf, 0, 3)
                buffer.writeu16(buf, 1, #name)
                buffer.writestring(buf, 3, name)
                sent = true
                query:InvokeServer(buf, nil, 3)
            end)
        end)
        task.wait(0.4)
        return sent
    end

    local function CloseShop(scope)
        local x = FindText(function(t) return string.lower(t) == "x" end, scope)
        if x then
            ClickUntil(x, function() return FindShopScope() == nil end, 0.8)
        end
    end

    local function CloseDialog()
        local bye = FindBye()
        if bye then
            ClickUntil(bye, function() return FindBye() == nil end, 0.8)
        end
    end

    ---------------------------------------------------------
    -- Copy GUI Info (ไว้ส่งให้ผมแก้สคริปต์ให้ตรงกับ GUI จริง)
    ---------------------------------------------------------
    local function DumpGui()
        local lines = {}
        local scope = FindShopScope()
        local root = scope or PlayerGui
        table.insert(lines, "== Scope: " .. root:GetFullName() .. (scope and " (shop open)" or " (shop NOT open - whole PlayerGui)"))
        local count = 0
        for _, d in ipairs(root:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel") or d:IsA("ImageButton")) and IsShown(d) then
                local text = d:IsA("ImageButton") and "" or Clean(d.Text)
                if text ~= "" or d:IsA("ImageButton") then
                    count += 1
                    if count > 600 then break end
                    table.insert(lines, string.format("%s | %s | text=%q | size=%dx%d | pos=%d,%d",
                        d.ClassName, d:GetFullName(), text,
                        d.AbsoluteSize.X, d.AbsoluteSize.Y, d.AbsolutePosition.X, d.AbsolutePosition.Y))
                end
            end
        end
        local out = table.concat(lines, "\n")
        pcall(function()
            if setclipboard then setclipboard(out)
            elseif toclipboard then toclipboard(out) end
        end)
        print(out)
        SetText(StatusLabel, "GUI info copied (" .. count .. " items)")
    end

    local DumpBtn
    DumpBtn = DebugRow:Right():Button({
        Label = "Execute",
        Callback = function() task.spawn(DumpGui) end
    })

    -- ทะลุของระหว่างบินไปหา NPC
    local Visiting = false
    task.spawn(function()
        while Alive() do
            RunService.Stepped:Wait()
            if Visiting then
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

    -- ให้ Auto Farm Level หยุดรอตอนกำลังไปคุย (ต่อจากเงื่อนไขเดิมของระบบ Item)
    local prevYield = _G.SmoothHubYieldToItems
    _G.SmoothHubYieldToItems = function()
        if Visiting then return true end
        return prevYield and prevYield() or false
    end

    -- หา NPC (ชื่อ BlackMarket / Black Market) ใน Workspace.TalkNpc
    local function Norm(s) return string.lower((string.gsub(s, "[%s_%-]", ""))) end
    local function FindNpc()
        local talk = Workspace:FindFirstChild("TalkNpc")
        if not talk then return nil end
        local direct = talk:FindFirstChild("BlackMarket") or talk:FindFirstChild("Black Market")
        if direct then return direct end
        for _, c in ipairs(talk:GetChildren()) do
            if Norm(c.Name) == "blackmarket" then return c end
        end
        return nil
    end

    -- บินเข้าใกล้ NPC (ขยับ CFrame ทีละก้าว เหมือนระบบฟาร์มอื่น ไม่วาร์ปทีเดียว)
    local function FlyNear(npc, radius, timeout)
        local t0 = os.clock()
        while Alive() and BM.Enabled and npc.Parent and os.clock() - t0 < timeout do
            local dt = RunService.Heartbeat:Wait()
            local root = GetMyRoot()
            if not root then return false end
            local target = PosOf(npc)
            if not target then return false end
            local diff = target - root.Position
            local dist = diff.Magnitude
            root.AssemblyLinearVelocity = Vector3.zero
            if dist <= radius then return true end
            root.CFrame = CFrame.new(root.Position + diff.Unit * math.min(FLY_SPEED * dt, dist - radius + 0.5))
        end
        return false
    end

    -- กดปุ่ม Talk (ProximityPrompt) : fireproximityprompt ก่อน ถ้าไม่ได้ค่อยกดค้างปุ่มจริง
    local function PressTalk(npc, useKey)
        local prompt = GetPrompt(npc)
        if not prompt or not prompt.Enabled then return false end
        if fireproximityprompt and not useKey then
            local oldHold = prompt.HoldDuration
            pcall(function() prompt.HoldDuration = 0 end)
            local ok = pcall(fireproximityprompt, prompt)
            pcall(function() prompt.HoldDuration = oldHold end)
            if ok then return true end
        end
        local key = prompt.KeyboardKeyCode
        if key == Enum.KeyCode.Unknown then key = Enum.KeyCode.F end
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(math.max(prompt.HoldDuration, 0) + 0.15)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
        end)
        return true
    end

    ---------------------------------------------------------
    -- ซื้อของในร้าน
    ---------------------------------------------------------
    local talked, totalBought = 0, 0
    local Bought = {}   -- ชื่อของที่ซื้อ/ลองซื้อไปแล้วในรอบที่ NPC เกิดนี้
    local Seen = {}     -- ชื่อของที่ตรวจแล้ว

    local function WantedAny()
        for _, picked in pairs(BM.Rarities) do
            if picked then return true end
        end
        return false
    end

    local function RunShop(npc)
        local scope = FindShopScope()
        if not scope then return false end

        local tried, selections = {}, 0
        for pass = 1, 6 do
            local slots = GetSlots(scope)
            if #slots == 0 then
                SetText(StatusLabel, "Shop items not found (use Copy GUI Info)")
                return false
            end
            local slotSet = {}
            for _, b in ipairs(slots) do slotSet[b] = true end

            local relaid = false
            local fresh = false
            for i, slot in ipairs(slots) do
                if not (Alive() and BM.Enabled and BM.AutoBuy and npc.Parent and FindShopScope()) then return false end
                if not tried[slot] and slot.Parent then
                    fresh = true
                    tried[slot] = true
                    selections += 1
                    if selections > 60 then return true end

                    local _, prevName = ReadPanel(scope, slotSet)
                    SetText(StatusLabel, string.format("Checking item %d/%d...", i, #slots))
                    ClickUntil(slot, function()
                        local _, n = ReadPanel(scope, slotSet)
                        return n ~= nil and n ~= prevName
                    end, 0.7)
                    task.wait(0.15)

                    local rarity, name = ReadPanel(scope, slotSet)
                    name = name or SlotName(slot)
                    if name and name ~= prevName or (i == 1 and name) then
                        if not Seen[name] then
                            Seen[name] = true
                            if rarity and BM.Rarities[rarity] and not Bought[name] then
                                Bought[name] = true
                                SetText(StatusLabel, "Buying " .. name .. " (" .. rarity .. ")")
                                local ok
                                if BM.BuyMethod == "Remote" then
                                    ok = BuyByRemote(name)
                                else
                                    ok = BuyByClick(scope)
                                end
                                if ok then
                                    totalBought += 1
                                    SetText(BoughtLabel, tostring(totalBought))
                                    SetText(LastLabel, name .. " (" .. rarity .. ")")
                                end
                                task.wait(1)
                                if not slot.Parent then relaid = true end -- ร้านจัดเรียงของใหม่หลังซื้อ
                            end
                        end
                    end
                    if relaid then break end
                end
            end
            if not fresh then break end
        end
        return true
    end

    ---------------------------------------------------------
    -- ไปหา NPC -> คุย -> เปิดร้าน -> (ซื้อ) -> ปิดร้าน
    ---------------------------------------------------------
    local function Visit(npc)
        local prompt = GetPrompt(npc)
        local radius = 5
        if prompt then
            radius = math.clamp((prompt.MaxActivationDistance or 10) * 0.5, 3, 8)
        end

        SetText(StatusLabel, "Flying to Black Market...")
        if not FlyNear(npc, radius, 25) then
            SetText(StatusLabel, "Could not reach the NPC")
            return false
        end

        -- 1) กด Talk รอให้กล่องคุยขึ้น (ลองสูงสุด 3 ครั้ง ครั้งที่ 3 ใช้กดปุ่มจริง)
        SetText(StatusLabel, "Talking...")
        local opened = false
        for attempt = 1, 3 do
            if not (Alive() and BM.Enabled and npc.Parent) then return false end
            local root = GetMyRoot()
            if root then root.AssemblyLinearVelocity = Vector3.zero end
            PressTalk(npc, attempt == 3)
            if WaitFor(function() return FindDialogOption() ~= nil or FindShopScope() ~= nil end, 2.5) then
                opened = true
                break
            end
        end
        if not opened then
            SetText(StatusLabel, "Talk box did not open")
            return false
        end
        talked += 1
        SetText(CountLabel, tostring(talked))

        -- 2) กดตัวเลือก "..." เพื่อเปิดหน้าร้าน
        if not FindShopScope() then
            SetText(StatusLabel, "Opening shop...")
            local option = FindDialogOption()
            if option then
                ClickUntil(option, function() return FindShopScope() ~= nil end, 1.2)
            end
            WaitFor(function() return FindShopScope() ~= nil end, 3)
        end

        local scope = FindShopScope()
        if not scope then
            SetText(StatusLabel, "Shop did not open (use Copy GUI Info)")
            CloseDialog()
            return false
        end

        -- 3) ไม่เปิด Auto Buy : เปิดร้านทิ้งไว้ให้ซื้อเอง
        if not BM.AutoBuy then
            SetText(StatusLabel, "Shop opened")
            return true
        end
        if not WantedAny() then
            SetText(StatusLabel, "Auto Buy: tick at least one rarity")
            return true
        end

        -- 4) Auto Buy แล้วปิดร้าน + กด Bye
        local ok = RunShop(npc)
        CloseShop(scope)
        task.wait(0.3)
        CloseDialog()
        SetText(StatusLabel, ok and "Shopping finished" or "Shopping stopped")
        return ok
    end

    ---------------------------------------------------------
    -- ลูปหลัก
    ---------------------------------------------------------
    local lastVisit = -1e9
    local spawnNpc, shopDone = nil, false

    task.spawn(function()
        while Alive() do
            task.wait(1)
            local npc = FindNpc()
            SetText(NpcLabel, npc and "Spawned" or "Not spawned")

            -- NPC หายไป/เกิดใหม่ = เริ่มรอบใหม่ (ลืมของที่ซื้อไปแล้ว)
            if npc ~= spawnNpc then
                spawnNpc = npc
                shopDone = false
                Bought, Seen = {}, {}
                lastVisit = -1e9
            end

            if not BM.Enabled then
                SetText(StatusLabel, "Idle")
            elseif not npc then
                SetText(StatusLabel, "Waiting for Black Market to spawn...")
            elseif BM.AutoBuy and shopDone then
                SetText(StatusLabel, "Done for this Black Market - back to farming")
            elseif os.clock() - lastVisit < BM.Delay then
                SetText(StatusLabel, string.format("Next visit in %ds", math.ceil(BM.Delay - (os.clock() - lastVisit))))
            elseif _G.SmoothHubItemWorking then
                SetText(StatusLabel, "Waiting for Item farm to finish...")
            elseif GetMyRoot() then
                local cfg = _G.SmoothHubConfig
                local prevMonster, prevBoss = cfg.EnableFarmMonster, cfg.EnableFarmBoss
                if BM.PauseFarms then
                    cfg.EnableFarmMonster = false
                    cfg.EnableFarmBoss = false
                end
                Visiting = true

                local ok, result = pcall(Visit, npc)

                Visiting = false
                if BM.PauseFarms then
                    -- คืนค่าเดิม (ถ้าระหว่างนั้นผู้ใช้ไม่ได้ปิดเองไปแล้ว)
                    if prevMonster and cfg.EnableFarmMonster == false then cfg.EnableFarmMonster = true end
                    if prevBoss and cfg.EnableFarmBoss == false then cfg.EnableFarmBoss = true end
                end

                if not ok then
                    SetText(StatusLabel, "Error: " .. tostring(result))
                    lastVisit = os.clock() - BM.Delay + 10 -- ลองใหม่อีก 10 วินาที
                elseif result then
                    lastVisit = os.clock()
                    if BM.AutoBuy and WantedAny() then shopDone = true end
                else
                    lastVisit = os.clock() - BM.Delay + 10
                end
            end
        end
    end)
end

---------------------------------------------------------
-- แท็บ Dungeon
-- 1) NPC "Gate Keeper" อยู่ที่ Workspace.TalkNpc["Gate Keeper"] -> บินไปหา -> กด Talk (F)
-- 2) หน้าต่าง Create Gate ขึ้น (Select Dungeon / Gate Preview / Leaderboard)
-- 3) เลือก Dungeon / Mode (Normal, Infinite) / Access (Public, Solo, Allies)
--    แล้วเช็กผลจากช่อง Gate Preview ว่าตรงกับที่เลือกไหม -> กดปุ่ม Create Gate
-- ใช้ do ... end ครอบ เพื่อไม่ให้ตัวแปร local เกินลิมิต 200 ตัวของ Lua
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local token = {}
    _G.SmoothHubDungeonToken = token
    local function Alive() return _G.SmoothHubDungeonToken == token end

    local DG = _G.SmoothHubConfig.Dungeon -- ถูกโหลดค่าที่เซฟไว้ให้แล้วจาก SettingsStore.Restore

    local DUNGEON_OPTIONS = { "Raid" } -- ตอนนี้ในเกมปลดล็อกแค่ Raid (ตัวอื่นขึ้น Locked) เพิ่มชื่อได้ทีหลัง
    local MODE_OPTIONS = { "Normal", "Infinite" }
    local ACCESS_OPTIONS = { "Public", "Solo", "Allies" }

    -- กันค่าเพี้ยนจากไฟล์เซฟเก่า
    if not table.find(DUNGEON_OPTIONS, DG.Dungeon) then DG.Dungeon = DUNGEON_OPTIONS[1] end
    if not table.find(MODE_OPTIONS, DG.Mode) then DG.Mode = MODE_OPTIONS[1] end
    if not table.find(ACCESS_OPTIONS, DG.Access) then DG.Access = ACCESS_OPTIONS[1] end
    DG.Delay = math.clamp(tonumber(DG.Delay) or 60, 10, 900)

    -- ประกาศไว้ก่อน เพราะปุ่มใน UI เรียกฟังก์ชันที่เขียนไว้ด้านล่าง
    local RunManual, DumpGui

    local DungeonTab = CategorySection:Tab({
        Title = "Dungeon",
        Icon = Cascade.Symbols["doorLeftHandClosed"] or Cascade.Symbols["flameFill"] or Cascade.Symbols["leafFill"]
    })
    _G.SmoothHubDungeonTab = DungeonTab -- ให้ระบบรีเฟรชธีมเห็นแท็บนี้

    ---------------------------------------------------------
    -- UI
    ---------------------------------------------------------
    local PickSection = DungeonTab:PageSection({
        Title = "🏰 Gate Options",
        Subtitle = "The script picks these in the Create Gate window."
    })
    local PickForm = PickSection:Form()

    local function AddPicker(title, subtitle, options, key)
        local row = PickForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        row:Right():PullDownButton({
            Label = DG[key],
            Options = options,
            Value = SettingsStore.IndexOf(options, DG[key], 1),
            ValueChanged = function(self, index)
                DG[key] = options[index] or options[1]
                self.Label = DG[key]
            end
        })
    end

    AddPicker("Dungeon", "Only Raid is unlocked in the game right now.", DUNGEON_OPTIONS, "Dungeon")
    AddPicker("Mode", "Normal or Infinite.", MODE_OPTIONS, "Mode")
    AddPicker("Access", "Public = anyone can join, Solo = only you, Allies = allies only.", ACCESS_OPTIONS, "Access")

    local ActionSection = DungeonTab:PageSection({
        Title = "⚡ Auto Create Gate",
        Subtitle = "Flies to the Gate Keeper and creates a gate."
    })
    local ActionForm = ActionSection:Form()

    local AutoRow = ActionForm:Row()
    AutoRow:Left():TitleStack({
        Title = "Auto Create",
        Subtitle = "Repeats the whole process automatically."
    })
    AutoRow:Right():Toggle({
        Value = DG.AutoCreate,
        ValueChanged = function(self, value) DG.AutoCreate = value and true or false end
    })

    local DelayRow = ActionForm:Row()
    DelayRow:Left():TitleStack({
        Title = "Repeat Delay",
        Subtitle = "Seconds between runs (10 - 900)."
    })
    DelayRow:Right():Stepper({
        Minimum = 10,
        Maximum = 900,
        Step = 10,
        Fielded = true,
        Value = DG.Delay,
        ValueChanged = function(self, value)
            DG.Delay = math.clamp(tonumber(value) or 60, 10, 900)
        end
    })

    local PauseRow = ActionForm:Row()
    PauseRow:Left():TitleStack({
        Title = "Pause Monster / Boss Farm",
        Subtitle = "Pauses them during the visit, then resumes."
    })
    PauseRow:Right():Toggle({
        Value = DG.PauseFarms,
        ValueChanged = function(self, value) DG.PauseFarms = value and true or false end
    })

    local NowRow = ActionForm:Row()
    NowRow:Left():TitleStack({
        Title = "Create Gate Now",
        Subtitle = "Runs the whole process once, now."
    })
    NowRow:Right():Button({
        Label = "Execute",
        Callback = function() if RunManual then RunManual(true) end end
    })

    local OpenRow = ActionForm:Row()
    OpenRow:Left():TitleStack({
        Title = "Open Dungeon Window",
        Subtitle = "Flies to the NPC and opens the window. You choose."
    })
    OpenRow:Right():Button({
        Label = "Execute",
        Callback = function() if RunManual then RunManual(false) end end
    })

    local StatusSection = DungeonTab:PageSection({
        Title = "📊 Status",
        Subtitle = "What it is doing now."
    })
    local StatusForm = StatusSection:Form()

    local StatusRow = StatusForm:Row()
    StatusRow:Left():Label({ Text = "Status" })
    local StatusLabel = StatusRow:Right():Label({ Text = "Idle" })

    local NpcRow = StatusForm:Row()
    NpcRow:Left():Label({ Text = "Gate Keeper NPC" })
    local NpcLabel = NpcRow:Right():Label({ Text = "Not found" })

    local CountRow = StatusForm:Row()
    CountRow:Left():Label({ Text = "Gates Created" })
    local CountLabel = CountRow:Right():Label({ Text = "0" })

    local LastRow = StatusForm:Row()
    LastRow:Left():Label({ Text = "Last Created" })
    local LastLabel = LastRow:Right():Label({ Text = "-" })

    local DebugRow = StatusForm:Row()
    DebugRow:Left():TitleStack({
        Title = "Debug: Copy GUI Info",
        Subtitle = "Open the Create Gate window first. For bug reports."
    })
    DebugRow:Right():Button({
        Label = "Execute",
        Callback = function() if DumpGui then task.spawn(DumpGui) end end
    })

    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        pcall(function() label.Text = text end)
    end
    _G.SmoothHubLiveKeys[StatusLabel] = "Dungeon"

    ---------------------------------------------------------
    -- ฟังก์ชันช่วย
    ---------------------------------------------------------
    local FLY_SPEED = 250

    local function GetMyRoot()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and hum and hum.Health > 0 then return root end
        return nil
    end

    local function PosOf(obj)
        if obj:IsA("Model") then return obj:GetPivot().Position end
        if obj:IsA("BasePart") then return obj.Position end
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end

    local function GetPrompt(obj) return obj:FindFirstChildWhichIsA("ProximityPrompt", true) end

    -- ตัดแท็ก RichText + ช่องว่างหัวท้าย
    local function Clean(s)
        s = string.gsub(tostring(s or ""), "<[^>]+>", "")
        return (string.match(s, "^%s*(.-)%s*$"))
    end

    local function IsShown(obj)
        local cur = obj
        while cur do
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            if cur:IsA("ScreenGui") and not cur.Enabled then return false end
            cur = cur.Parent
        end
        return true
    end

    local Busy, manualRun, Visiting = false, false, false

    -- ทำงานต่อได้ไหม: ระบบยังอยู่ และ (กดปุ่มเอง หรือเปิด Auto Create ไว้)
    local function ShouldRun()
        return Alive() and (manualRun or DG.AutoCreate)
    end

    local function WaitFor(check, timeout)
        local t0 = os.clock()
        while Alive() and os.clock() - t0 < timeout do
            if check() then return true end
            task.wait(0.15)
        end
        return check() and true or false
    end

    -- หา Label/ปุ่มที่ข้อความ (หลังตัดแท็ก) ผ่านเงื่อนไข pred และมองเห็นอยู่
    local function FindText(pred, scope)
        for _, d in ipairs((scope or PlayerGui):GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel")) and IsShown(d) then
                local t = Clean(d.Text)
                if t ~= "" and pred(t) then return d end
            end
        end
        return nil
    end

    ---------------------------------------------------------
    -- กดปุ่มบนหน้าจอ : 1) เรียก connection ของปุ่ม  2) คลิกเมาส์จำลองที่กลางปุ่ม
    ---------------------------------------------------------
    local function GetClickable(obj)
        local cur = obj
        while cur and cur ~= PlayerGui do
            if cur:IsA("GuiButton") then return cur end
            cur = cur.Parent
        end
        return obj
    end

    local function ClickSignal(btn)
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

    local function ClickMouse(obj)
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

    -- กด 1 ครั้งด้วยวิธีแรก แล้วรอเช็กผล ถ้าไม่สำเร็จค่อยลองอีกวิธี (กันกดซ้ำโดยไม่จำเป็น)
    local function ClickUntil(obj, check, wait)
        check = check or function() return true end
        wait = wait or 1
        local btn = GetClickable(obj)
        if ClickSignal(btn) and WaitFor(check, wait) then return true end
        if not btn.Parent then return check() end
        ClickMouse(btn)
        return WaitFor(check, wait)
    end

    ---------------------------------------------------------
    -- กล่องคุย : ตัวเลือก "..." และ "Bye..."
    ---------------------------------------------------------
    local function IsDots(t)
        if #t > 12 then return false end
        local r = string.gsub(t, "%.", "")
        r = string.gsub(r, "…", "")
        r = string.gsub(r, "·", "")
        r = string.gsub(r, "•", "")
        r = string.gsub(r, "%s", "")
        return r == ""
    end

    local function FindBye()
        return FindText(function(t) return string.lower(t):find("^bye") ~= nil end)
    end

    local function FindDialogOption()
        local dots = FindText(IsDots)
        if dots then return dots end
        -- ข้อความที่เกี่ยวกับดันเจี้ยน/เกต
        local named = FindText(function(t)
            local l = string.lower(t)
            return l:find("dungeon") ~= nil or l:find("gate") ~= nil
        end)
        if named and GetClickable(named):IsA("GuiButton") then return named end
        -- ทางสำรอง: ปุ่มพี่น้องของ Bye... ที่ไม่ใช่ Bye (ตัวบนสุด)
        local bye = FindBye()
        if bye then
            local byeBtn = GetClickable(bye)
            local parent = byeBtn.Parent
            local best
            if parent then
                for _, sib in ipairs(parent:GetChildren()) do
                    if sib ~= byeBtn and sib:IsA("GuiButton") and IsShown(sib) then
                        if not best or sib.AbsolutePosition.Y < best.AbsolutePosition.Y then best = sib end
                    end
                end
            end
            return best
        end
        return nil
    end

    local function CloseDialog()
        local bye = FindBye()
        if bye then
            ClickUntil(bye, function() return FindBye() == nil end, 0.8)
        end
    end

    ---------------------------------------------------------
    -- หน้าต่าง Create Gate (Select Dungeon / Gate Preview / Leaderboard)
    ---------------------------------------------------------
    -- คืน ScreenGui ที่เป็นหน้าต่างนี้ (nil = หน้าต่างยังไม่เปิด)
    local function WindowScope()
        local title = FindText(function(t)
            local l = string.lower(t)
            return l == "select dungeon" or l == "gate preview"
        end)
        if title then
            return title:FindFirstAncestorWhichIsA("ScreenGui") or PlayerGui
        end
        return nil
    end

    -- หาปุ่มตัวเลือกจากข้อความ (ไม่สนตัวพิมพ์เล็กใหญ่)
    -- ข้อความเดียวกันอาจโผล่ซ้ำในช่อง Gate Preview ที่ไม่ใช่ปุ่ม จึงเลือกอันที่เป็นปุ่มก่อน
    local function FindOption(scope, wanted)
        local want = string.lower(wanted)
        local fallback
        for _, d in ipairs(scope:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel")) and IsShown(d) and string.lower(Clean(d.Text)) == want then
                if GetClickable(d):IsA("GuiButton") then return d end
                fallback = fallback or d
            end
        end
        return fallback
    end

    -- อ่านค่าในช่อง Gate Preview เช่น  Dungeon | Raid  /  Mode | Normal  /  Access | Public
    -- key = ข้อความฝั่งซ้าย  คืนค่าข้อความฝั่งขวาของแถวเดียวกัน (อ่านไม่ได้ = nil)
    local function ReadPreview(scope, key)
        local want = string.lower(key)
        local keyLabel
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("TextLabel") and IsShown(d) and string.lower(Clean(d.Text)) == want
                and not GetClickable(d):IsA("GuiButton") then
                keyLabel = d
                break
            end
        end
        if not keyLabel then return nil end

        local kp, ks = keyLabel.AbsolutePosition, keyLabel.AbsoluteSize
        local centerY = kp.Y + ks.Y / 2
        local best, bestDx
        for _, d in ipairs(scope:GetDescendants()) do
            if d ~= keyLabel and d:IsA("TextLabel") and IsShown(d) then
                local t = Clean(d.Text)
                if t ~= "" and t ~= "|" then
                    local p, s = d.AbsolutePosition, d.AbsoluteSize
                    local dx = p.X - (kp.X + ks.X)
                    if math.abs(p.Y + s.Y / 2 - centerY) <= 12 and dx > -4 then
                        if not bestDx or dx < bestDx then
                            best, bestDx = t, dx
                        end
                    end
                end
            end
        end
        return best
    end

    -- เลือกตัวเลือก 1 อย่าง แล้วเช็กผลจาก Gate Preview (อ่านพรีวิวไม่ได้ = กด 1 ครั้งแล้วถือว่าผ่าน)
    local function ChooseOption(scope, previewKey, wanted)
        local want = string.lower(wanted)

        local function isSet()
            local v = ReadPreview(scope, previewKey)
            if v == nil then return true end
            return string.lower(v) == want
        end

        local now = ReadPreview(scope, previewKey)
        if now and string.lower(now) == want then return true end -- เลือกอยู่แล้ว

        local btn = FindOption(scope, wanted)
        if not btn then return false end

        ClickUntil(btn, isSet, 0.8)
        task.wait(0.2)

        local after = ReadPreview(scope, previewKey)
        return after == nil or string.lower(after) == want
    end

    local function WindowClosed() return WindowScope() == nil end

    local function CloseWindow(scope)
        local cancel = FindOption(scope, "Cancel")
        if cancel then
            ClickUntil(cancel, WindowClosed, 1)
        end
    end

    -- กดปุ่ม Create Gate (คืน true ถ้าหน้าต่างปิดลง = สร้างสำเร็จ)
    local function PressCreate(scope)
        local btn = FindOption(scope, "Create Gate")
        if not btn then return false end
        ClickUntil(btn, WindowClosed, 1.5)
        return WaitFor(WindowClosed, 1.5)
    end

    ---------------------------------------------------------
    -- Copy GUI Info (ไว้ส่งให้ผมแก้สคริปต์ให้ตรงกับ GUI จริง)
    ---------------------------------------------------------
    DumpGui = function()
        local scope = WindowScope()
        local root = scope or PlayerGui
        local lines = {
            "== Scope: " .. root:GetFullName() .. (scope and " (Create Gate window open)" or " (window NOT open - whole PlayerGui)")
        }
        if scope then
            for _, key in ipairs({ "Dungeon", "Mode", "Access" }) do
                table.insert(lines, "== Preview " .. key .. " = " .. tostring(ReadPreview(scope, key)))
            end
        end
        local count = 0
        for _, d in ipairs(root:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel") or d:IsA("ImageButton")) and IsShown(d) then
                local text = d:IsA("ImageButton") and "" or Clean(d.Text)
                if text ~= "" or d:IsA("ImageButton") then
                    count += 1
                    if count > 600 then break end
                    table.insert(lines, string.format("%s | %s | text=%q | size=%dx%d | pos=%d,%d",
                        d.ClassName, d:GetFullName(), text,
                        d.AbsoluteSize.X, d.AbsoluteSize.Y, d.AbsolutePosition.X, d.AbsolutePosition.Y))
                end
            end
        end
        local out = table.concat(lines, "\n")
        pcall(function()
            if setclipboard then setclipboard(out)
            elseif toclipboard then toclipboard(out) end
        end)
        print(out)
        SetText(StatusLabel, "GUI info copied (" .. count .. " items)")
    end

    ---------------------------------------------------------
    -- บินไปหา NPC / คุย
    ---------------------------------------------------------
    -- ทะลุของระหว่างบินไปหา NPC
    task.spawn(function()
        while Alive() do
            RunService.Stepped:Wait()
            if Visiting then
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

    -- ให้ Auto Farm Level หยุดรอตอนกำลังไปคุย (ต่อจากเงื่อนไขเดิมของระบบอื่น)
    local prevYield = _G.SmoothHubYieldToItems
    _G.SmoothHubYieldToItems = function()
        if Visiting then return true end
        return prevYield and prevYield() or false
    end

    -- หา NPC Gate Keeper ใน Workspace.TalkNpc
    local function Norm(s) return string.lower((string.gsub(s, "[%s_%-]", ""))) end
    local function FindNpc()
        local talk = Workspace:FindFirstChild("TalkNpc")
        if not talk then return nil end
        local direct = talk:FindFirstChild("Gate Keeper") or talk:FindFirstChild("GateKeeper")
        if direct then return direct end
        for _, c in ipairs(talk:GetChildren()) do
            if Norm(c.Name) == "gatekeeper" then return c end
        end
        return nil
    end

    -- บินเข้าใกล้ NPC (ขยับ CFrame ทีละก้าว เหมือนระบบฟาร์มอื่น ไม่วาร์ปทีเดียว)
    local function FlyNear(npc, radius, timeout)
        local t0 = os.clock()
        while ShouldRun() and npc.Parent and os.clock() - t0 < timeout do
            local dt = RunService.Heartbeat:Wait()
            local root = GetMyRoot()
            if not root then return false end
            local target = PosOf(npc)
            if not target then return false end
            local diff = target - root.Position
            local dist = diff.Magnitude
            root.AssemblyLinearVelocity = Vector3.zero
            if dist <= radius then return true end
            root.CFrame = CFrame.new(root.Position + diff.Unit * math.min(FLY_SPEED * dt, dist - radius + 0.5))
        end
        return false
    end

    -- กดปุ่ม Talk (ProximityPrompt) : fireproximityprompt ก่อน ถ้าไม่ได้ค่อยกดค้างปุ่มจริง
    local function PressTalk(npc, useKey)
        local prompt = GetPrompt(npc)
        if not prompt or not prompt.Enabled then return false end
        if fireproximityprompt and not useKey then
            local oldHold = prompt.HoldDuration
            pcall(function() prompt.HoldDuration = 0 end)
            local ok = pcall(fireproximityprompt, prompt)
            pcall(function() prompt.HoldDuration = oldHold end)
            if ok then return true end
        end
        local key = prompt.KeyboardKeyCode
        if key == Enum.KeyCode.Unknown then key = Enum.KeyCode.F end
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(math.max(prompt.HoldDuration, 0) + 0.15)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
        end)
        return true
    end

    ---------------------------------------------------------
    -- ไปหา NPC -> คุย -> เปิดหน้าต่าง -> (เลือกตัวเลือก -> Create Gate)
    -- create = false : เปิดหน้าต่างทิ้งไว้เฉยๆ ให้ผู้เล่นเลือกเอง
    ---------------------------------------------------------
    local created = 0

    local function Visit(npc, create)
        local prompt = GetPrompt(npc)
        local radius = 5
        if prompt then
            radius = math.clamp((prompt.MaxActivationDistance or 10) * 0.5, 3, 8)
        end

        local scope = WindowScope() -- ถ้าหน้าต่างเปิดอยู่แล้ว ข้ามขั้นบิน/คุย

        if not scope then
            SetText(StatusLabel, "Flying to Gate Keeper...")
            if not FlyNear(npc, radius, 30) then
                SetText(StatusLabel, "Could not reach the Gate Keeper")
                return false
            end

            -- 1) กด Talk รอให้หน้าต่าง/กล่องคุยขึ้น (ลองสูงสุด 3 ครั้ง ครั้งที่ 3 ใช้กดปุ่มจริง)
            SetText(StatusLabel, "Talking...")
            for attempt = 1, 3 do
                if not (ShouldRun() and npc.Parent) then return false end
                local root = GetMyRoot()
                if root then root.AssemblyLinearVelocity = Vector3.zero end
                PressTalk(npc, attempt == 3)
                if WaitFor(function() return WindowScope() ~= nil or FindDialogOption() ~= nil end, 2.5) then
                    break
                end
            end

            -- 2) ถ้าขึ้นเป็นกล่องคุย ให้กดตัวเลือกเพื่อเปิดหน้าต่าง
            if not WindowScope() then
                local option = FindDialogOption()
                if option then
                    SetText(StatusLabel, "Opening Create Gate window...")
                    ClickUntil(option, function() return WindowScope() ~= nil end, 1.2)
                end
                WaitFor(function() return WindowScope() ~= nil end, 3)
            end
            scope = WindowScope()
        end

        if not scope then
            SetText(StatusLabel, "Dungeon window did not open (use Copy GUI Info)")
            return false
        end

        if not create then
            SetText(StatusLabel, "Dungeon window opened")
            return true
        end

        -- 3) เลือก Dungeon / Mode / Access (เช็กผลจาก Gate Preview ทุกขั้น)
        local steps = {
            { "Dungeon", DG.Dungeon },
            { "Mode", DG.Mode },
            { "Access", DG.Access },
        }
        for _, step in ipairs(steps) do
            if not ShouldRun() then return false end
            scope = WindowScope()
            if not scope then
                SetText(StatusLabel, "The window closed unexpectedly")
                return false
            end
            SetText(StatusLabel, "Choosing " .. step[1] .. ": " .. step[2])
            if not ChooseOption(scope, step[1], step[2]) then
                SetText(StatusLabel, "Could not select " .. step[1] .. " = " .. step[2] .. " (use Copy GUI Info)")
                return false
            end
        end

        -- 4) กด Create Gate
        scope = WindowScope()
        if not scope then return false end
        SetText(StatusLabel, "Pressing Create Gate...")
        if not PressCreate(scope) then
            SetText(StatusLabel, "Create Gate pressed but the window stayed open")
            local still = WindowScope()
            if still then CloseWindow(still) end
            return false
        end

        created += 1
        SetText(CountLabel, tostring(created))
        SetText(LastLabel, string.format("%s | %s | %s", DG.Dungeon, DG.Mode, DG.Access))
        SetText(StatusLabel, "Gate created")
        task.wait(0.4)
        CloseDialog()
        return true
    end

    -- ครอบการทำงาน: พักฟาร์มระหว่างไปคุย แล้วคืนค่าเดิม
    local function Run(npc, create, isManual)
        Busy = true
        manualRun = isManual and true or false

        local cfg = _G.SmoothHubConfig
        local prevMonster, prevBoss = cfg.EnableFarmMonster, cfg.EnableFarmBoss
        if DG.PauseFarms then
            cfg.EnableFarmMonster = false
            cfg.EnableFarmBoss = false
        end
        Visiting = true

        local ok, result = pcall(Visit, npc, create)

        Visiting = false
        if DG.PauseFarms then
            -- คืนค่าเดิม (ถ้าระหว่างนั้นผู้ใช้ไม่ได้ปิดเองไปแล้ว)
            if prevMonster and cfg.EnableFarmMonster == false then cfg.EnableFarmMonster = true end
            if prevBoss and cfg.EnableFarmBoss == false then cfg.EnableFarmBoss = true end
        end
        manualRun = false
        Busy = false

        if not ok then
            SetText(StatusLabel, "Error: " .. tostring(result))
            return false
        end
        return result and true or false
    end

    -- ปุ่มกดเอง (create = true: ทำครบจนกด Create Gate / false: เปิดหน้าต่างเฉยๆ)
    RunManual = function(create)
        if Busy then
            SetText(StatusLabel, "Busy - wait for the current run to finish")
            return
        end
        task.spawn(function()
            local npc = FindNpc()
            if not npc then
                SetText(StatusLabel, "Gate Keeper NPC not found (go to the lobby)")
                return
            end
            if not GetMyRoot() then
                SetText(StatusLabel, "Your character is not ready")
                return
            end
            Run(npc, create, true)
        end)
    end

    ---------------------------------------------------------
    -- ลูปหลัก (Auto Create)
    ---------------------------------------------------------
    local lastRun = -1e9
    local wasAuto = false

    task.spawn(function()
        while Alive() do
            task.wait(1)
            local npc = FindNpc()
            SetText(NpcLabel, npc and "Found" or "Not found")

            if Busy then
                -- กำลังทำงานอยู่ (ข้อความสถานะอัพเดตโดยขั้นตอนต่างๆ)
            elseif not DG.AutoCreate then
                if wasAuto then SetText(StatusLabel, "Idle") end
            elseif not npc then
                SetText(StatusLabel, "Waiting for the Gate Keeper NPC...")
            elseif os.clock() - lastRun < DG.Delay then
                SetText(StatusLabel, string.format("Next create in %ds", math.ceil(DG.Delay - (os.clock() - lastRun))))
            elseif _G.SmoothHubItemWorking then
                SetText(StatusLabel, "Waiting for Item farm to finish...")
            elseif GetMyRoot() then
                local ok = Run(npc, true, false)
                -- สำเร็จ = รอครบ Delay ก่อนทำใหม่ / ไม่สำเร็จ = ลองใหม่อีก 10 วินาที
                lastRun = ok and os.clock() or (os.clock() - DG.Delay + 10)
            end
            wasAuto = DG.AutoCreate
        end
    end)
end

---------------------------------------------------------
-- แท็บ PVP  (Aimbot + Auto Farm RC / ค่าหัว)
-- วางบล็อกนี้ในไฟล์ "Ui โลกปกติ" ต่อจากแท็บ Black Market
-- (ก่อนบรรทัด  local InformationSection = ...)
-- ใช้ do ... end ครอบ เพื่อไม่ให้ local เกินลิมิต 200 ตัว
--
-- ต้องเพิ่ม Default ใน _G.SmoothHubConfig ด้วย (ดูไฟล์ PVP_Config_Snippet.lua)
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    local token = {}
    _G.SmoothHubPvpToken = token
    local function Alive() return _G.SmoothHubPvpToken == token end

    local PVP = _G.SmoothHubConfig.PVP
    local AIM, BNT = PVP.Aimbot, PVP.Bounty

    -- กันค่าเพี้ยนจากไฟล์เซฟเก่า
    AIM.FOV = math.clamp(tonumber(AIM.FOV) or 150, 20, 800)
    AIM.Smooth = math.clamp(tonumber(AIM.Smooth) or 30, 1, 100)
    AIM.MaxDist = math.clamp(tonumber(AIM.MaxDist) or 500, 50, 3000)
    BNT.MinBounty = math.max(tonumber(BNT.MinBounty) or 0, 0)
    BNT.Distance = math.clamp(tonumber(BNT.Distance) or 4, 2, 15)
    BNT.FlySpeed = math.clamp(tonumber(BNT.FlySpeed) or 250, 50, 600)
    if BNT.SkipSafeZone == nil then BNT.SkipSafeZone = true end
    if BNT.SkipAura == nil then BNT.SkipAura = true end
    if BNT.LevelFilter == nil then BNT.LevelFilter = true end
    if BNT.MoveMode ~= "Fly" then BNT.MoveMode = "Teleport" end
    BNT.NoDamageTime = math.clamp(tonumber(BNT.NoDamageTime) or 5, 2, 30)
    BNT.PvpOffTime = math.clamp(tonumber(BNT.PvpOffTime) or 120, 10, 3600)
    if BNT.OnlySelected == nil then BNT.OnlySelected = false end
    if type(BNT.OnlyPlayers) ~= "table" then BNT.OnlyPlayers = {} end
    BNT.LevelRange = math.clamp(tonumber(BNT.LevelRange) or 10, 0, 1000)
    local ESP = PVP.ESP
    if ESP.Level == nil then ESP.Level = true end
    ESP.MaxDist = math.clamp(tonumber(ESP.MaxDist) or 2000, 100, 10000)

    local PvpTab = CategorySection:Tab({
        Title = "PVP",
        Icon = Cascade.Symbols["scope"] or Cascade.Symbols["bagFill"] or Cascade.Symbols["leafFill"]
    })
    _G.SmoothHubPvpTab = PvpTab

    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        pcall(function() label.Text = text end)
    end

    ---------------------------------------------------------
    -- ตัวช่วยทั่วไป
    ---------------------------------------------------------
    local function GetMyRoot()
        local c = LocalPlayer.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local function IsAlive(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
    end

    local function SameTeam(plr)
        return LocalPlayer.Team ~= nil and plr.Team == LocalPlayer.Team
    end

    ---------------------------------------------------------
    -- UI : Aimbot
    ---------------------------------------------------------
    local AimSection = PvpTab:PageSection({
        Title = "🎯 Aimbot",
        Subtitle = "Aims at the player closest to your crosshair."
    })
    local AimForm = AimSection:Form()

    local AimEnableRow = AimForm:Row()
    AimEnableRow:Left():TitleStack({ Title = "Enable Aimbot", Subtitle = "Turns the aim assist on." })
    AimEnableRow:Right():Toggle({
        Value = AIM.Enabled,
        ValueChanged = function(self, v) AIM.Enabled = v and true or false end
    })

    local modeOptions = { "Hold Right Click", "Always On" }
    local AimModeRow = AimForm:Row()
    AimModeRow:Left():TitleStack({ Title = "Aim Mode", Subtitle = "Hold Right Click = aim only while held." })
    AimModeRow:Right():PullDownButton({
        Label = AIM.Mode,
        Options = modeOptions,
        Value = SettingsStore.IndexOf(modeOptions, AIM.Mode, 1),
        ValueChanged = function(self, index)
            AIM.Mode = modeOptions[index] or "Hold Right Click"
            self.Label = AIM.Mode
        end
    })

    local partOptions = { "Head", "HumanoidRootPart", "Closest Part" }
    local AimPartRow = AimForm:Row()
    AimPartRow:Left():TitleStack({ Title = "Target Part", Subtitle = "Which body part to aim at." })
    AimPartRow:Right():PullDownButton({
        Label = AIM.Part,
        Options = partOptions,
        Value = SettingsStore.IndexOf(partOptions, AIM.Part, 1),
        ValueChanged = function(self, index)
            AIM.Part = partOptions[index] or "Head"
            self.Label = AIM.Part
        end
    })

    local AimFovRow = AimForm:Row()
    AimFovRow:Left():TitleStack({ Title = "FOV Radius", Subtitle = "Only players inside this circle (px)." })
    AimFovRow:Right():Stepper({
        Minimum = 20, Maximum = 800, Step = 10, Fielded = true,
        Value = AIM.FOV,
        ValueChanged = function(self, v) AIM.FOV = math.clamp(tonumber(v) or 150, 20, 800) end
    })

    local AimShowRow = AimForm:Row()
    AimShowRow:Left():TitleStack({ Title = "Show FOV Circle", Subtitle = "Draws the circle on screen." })
    AimShowRow:Right():Toggle({
        Value = AIM.ShowFOV,
        ValueChanged = function(self, v) AIM.ShowFOV = v and true or false end
    })

    local AimSmoothRow = AimForm:Row()
    AimSmoothRow:Left():TitleStack({ Title = "Smoothness", Subtitle = "1 = slow and smooth, 100 = instant." })
    AimSmoothRow:Right():Stepper({
        Minimum = 1, Maximum = 100, Step = 5, Fielded = true,
        Value = AIM.Smooth,
        ValueChanged = function(self, v) AIM.Smooth = math.clamp(tonumber(v) or 30, 1, 100) end
    })

    local AimDistRow = AimForm:Row()
    AimDistRow:Left():TitleStack({ Title = "Max Distance", Subtitle = "Ignore players farther than this (studs)." })
    AimDistRow:Right():Stepper({
        Minimum = 50, Maximum = 3000, Step = 50, Fielded = true,
        Value = AIM.MaxDist,
        ValueChanged = function(self, v) AIM.MaxDist = math.clamp(tonumber(v) or 500, 50, 3000) end
    })

    local AimTeamRow = AimForm:Row()
    AimTeamRow:Left():TitleStack({ Title = "Team Check", Subtitle = "Skip players on your team." })
    AimTeamRow:Right():Toggle({
        Value = AIM.TeamCheck,
        ValueChanged = function(self, v) AIM.TeamCheck = v and true or false end
    })

    local AimWallRow = AimForm:Row()
    AimWallRow:Left():TitleStack({ Title = "Wall Check", Subtitle = "Skip players hidden behind walls." })
    AimWallRow:Right():Toggle({
        Value = AIM.WallCheck,
        ValueChanged = function(self, v) AIM.WallCheck = v and true or false end
    })

    ---------------------------------------------------------
    -- UI : Auto Farm RC (ค่าหัว)
    ---------------------------------------------------------
    local BntSection = PvpTab:PageSection({
        Title = "💰 Auto Farm RC (Bounty)",
        Subtitle = "Hunts the highest-bounty players. Turn off other farms."
    })
    local BntForm = BntSection:Form()

    local BntEnableRow = BntForm:Row()
    BntEnableRow:Left():TitleStack({
        Title = "Enable Auto Farm RC",
        Subtitle = "Goes to the target and attacks."
    })
    BntEnableRow:Right():Toggle({
        Value = BNT.Enabled,
        ValueChanged = function(self, v) BNT.Enabled = v and true or false end
    })

    local BntMinRow = BntForm:Row()
    BntMinRow:Left():TitleStack({ Title = "Minimum Bounty", Subtitle = "Skip players below this bounty. 0 = anyone." })
    BntMinRow:Right():Stepper({
        Minimum = 0, Maximum = 100000000, Step = 1000, Fielded = true,
        Value = BNT.MinBounty,
        ValueChanged = function(self, v) BNT.MinBounty = math.max(tonumber(v) or 0, 0) end
    })

    local posOptions = { "Behind", "Above", "Below" }
    local BntPosRow = BntForm:Row()
    BntPosRow:Left():TitleStack({ Title = "Position", Subtitle = "Where to stand relative to the target." })
    BntPosRow:Right():PullDownButton({
        Label = BNT.Position,
        Options = posOptions,
        Value = SettingsStore.IndexOf(posOptions, BNT.Position, 1),
        ValueChanged = function(self, index)
            BNT.Position = posOptions[index] or "Behind"
            self.Label = BNT.Position
        end
    })

    local BntDistRow = BntForm:Row()
    BntDistRow:Left():TitleStack({ Title = "Distance", Subtitle = "Studs between you and the target (2 - 15)." })
    BntDistRow:Right():Stepper({
        Minimum = 2, Maximum = 15, Step = 1, Fielded = true,
        Value = BNT.Distance,
        ValueChanged = function(self, v) BNT.Distance = math.clamp(tonumber(v) or 4, 2, 15) end
    })

    local moveOptions = { "Teleport", "Fly" }
    local BntMoveRow = BntForm:Row()
    BntMoveRow:Left():TitleStack({ Title = "Movement", Subtitle = "Fly = glide at Fly Speed. Teleport = instant (may get you kicked)." })
    BntMoveRow:Right():PullDownButton({
        Label = BNT.MoveMode,
        Options = moveOptions,
        Value = SettingsStore.IndexOf(moveOptions, BNT.MoveMode, 1),
        ValueChanged = function(self, index)
            BNT.MoveMode = moveOptions[index] or "Teleport"
            self.Label = BNT.MoveMode
        end
    })

    local BntNoDmgRow = BntForm:Row()
    BntNoDmgRow:Left():TitleStack({ Title = "No-Damage Timeout (sec)", Subtitle = "Move on if the target takes no damage for this long." })
    BntNoDmgRow:Right():Stepper({
        Minimum = 2, Maximum = 30, Step = 1, Fielded = true,
        Value = BNT.NoDamageTime,
        ValueChanged = function(self, v) BNT.NoDamageTime = math.clamp(tonumber(v) or 5, 2, 30) end
    })

    local BntPvpOffRow = BntForm:Row()
    BntPvpOffRow:Left():TitleStack({ Title = "Skip PVP-off Players (sec)", Subtitle = "How long to ignore them." })
    BntPvpOffRow:Right():Stepper({
        Minimum = 10, Maximum = 3600, Step = 10, Fielded = true,
        Value = BNT.PvpOffTime,
        ValueChanged = function(self, v) BNT.PvpOffTime = math.clamp(tonumber(v) or 120, 10, 3600) end
    })

    local BntSelRow = BntForm:Row()
    BntSelRow:Left():TitleStack({ Title = "Selected Players Only", Subtitle = "Hunt only the players ticked below." })
    BntSelRow:Right():Toggle({
        Value = BNT.OnlySelected,
        ValueChanged = function(self, v) BNT.OnlySelected = v and true or false end
    })

    local playerList = {}
    local pickerRefreshing = false
    local PlayerPicker
    local function BuildPlayerList()
        local names, seen = {}, {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then names[#names + 1] = plr.Name seen[plr.Name] = true end
        end
        table.sort(names)
        for _, n in ipairs(BNT.OnlyPlayers) do -- คนที่ติ๊กไว้แต่ออกเกมไปแล้ว ยังโชว์ให้เห็น
            if not seen[n] then names[#names + 1] = n seen[n] = true end
        end
        return names
    end
    local function RefreshPicker()
        if not PlayerPicker then return end
        playerList = BuildPlayerList()
        local idx = {}
        for i, n in ipairs(playerList) do
            if table.find(BNT.OnlyPlayers, n) then idx[#idx + 1] = i end
        end
        pickerRefreshing = true
        pcall(function() PlayerPicker.Options = playerList end)
        pcall(function() PlayerPicker.Value = idx end)
        pickerRefreshing = false
    end

    playerList = BuildPlayerList()
    local pickerIdx = {}
    for i, n in ipairs(playerList) do
        if table.find(BNT.OnlyPlayers, n) then pickerIdx[#pickerIdx + 1] = i end
    end
    local BntPickRow = BntForm:Row()
    BntPickRow:Left():TitleStack({ Title = "Target Players", Subtitle = "Tick players to hunt. Refresh after someone joins." })
    PlayerPicker = BntPickRow:Right():PopUpButton({
        Options = playerList,
        Maximum = 100,
        Value = pickerIdx,
        ValueChanged = function(self, value)
            if pickerRefreshing then return end
            local names = {}
            for _, index in ipairs(value or {}) do
                if playerList[index] then names[#names + 1] = playerList[index] end
            end
            BNT.OnlyPlayers = names
        end
    })

    local BntRefreshRow = BntForm:Row()
    BntRefreshRow:Left():TitleStack({ Title = "Refresh List", Subtitle = "Reloads the player names." })
    BntRefreshRow:Right():Button({ Label = "Refresh", Callback = RefreshPicker })

    local refreshQueued = false
    local function QueueRefresh()
        if refreshQueued then return end
        refreshQueued = true
        task.delay(1, function() refreshQueued = false RefreshPicker() end)
    end
    Players.PlayerAdded:Connect(QueueRefresh)
    Players.PlayerRemoving:Connect(QueueRefresh)

    local BntSpeedRow = BntForm:Row()
    BntSpeedRow:Left():TitleStack({ Title = "Fly Speed", Subtitle = "Only used in Fly mode." })
    BntSpeedRow:Right():Stepper({
        Minimum = 50, Maximum = 600, Step = 10, Fielded = true,
        Value = BNT.FlySpeed,
        ValueChanged = function(self, v) BNT.FlySpeed = math.clamp(tonumber(v) or 250, 50, 600) end
    })

    local BntSafeRow = BntForm:Row()
    BntSafeRow:Left():TitleStack({ Title = "Skip Safe Zone Players", Subtitle = "Ignore players standing in a Safe Zone." })
    BntSafeRow:Right():Toggle({
        Value = BNT.SkipSafeZone,
        ValueChanged = function(self, v) BNT.SkipSafeZone = v and true or false end
    })

    local BntLevelRow = BntForm:Row()
    BntLevelRow:Left():TitleStack({ Title = "Only Similar Level", Subtitle = "Hunt only players near your level." })
    BntLevelRow:Right():Toggle({
        Value = BNT.LevelFilter,
        ValueChanged = function(self, v) BNT.LevelFilter = v and true or false end
    })

    local BntLevelRangeRow = BntForm:Row()
    BntLevelRangeRow:Left():TitleStack({ Title = "Level Range (+/-)", Subtitle = "Max level difference (+/-)." })
    BntLevelRangeRow:Right():Stepper({
        Minimum = 0, Maximum = 1000, Step = 5, Fielded = true,
        Value = BNT.LevelRange,
        ValueChanged = function(self, v) BNT.LevelRange = math.clamp(tonumber(v) or 10, 0, 1000) end
    })

    local BntAuraRow = BntForm:Row()
    BntAuraRow:Left():TitleStack({ Title = "Skip Aura Players", Subtitle = "Ignore players with Aura on." })
    BntAuraRow:Right():Toggle({
        Value = BNT.SkipAura,
        ValueChanged = function(self, v) BNT.SkipAura = v and true or false end
    })

    local BntTeamRow = BntForm:Row()
    BntTeamRow:Left():TitleStack({ Title = "Skip Teammates", Subtitle = "Never hunt teammates." })
    BntTeamRow:Right():Toggle({
        Value = BNT.TeamCheck,
        ValueChanged = function(self, v) BNT.TeamCheck = v and true or false end
    })

    local EspSection = PvpTab:PageSection({
        Title = "👁 ESP",
        Subtitle = "See players through walls, with their info."
    })
    local EspForm = EspSection:Form()
    local function EspToggle(key, title, subtitle)
        local row = EspForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        row:Right():Toggle({
            Value = ESP[key],
            ValueChanged = function(self, v) ESP[key] = v and true or false end
        })
    end
    EspToggle("Enabled", "Enable ESP", "Master switch for everything below.")
    EspToggle("Chams", "Chams (Highlight)", "Colored outline + fill on players, visible through walls.")
    EspToggle("Name", "Name", "Show the player's name.")
    EspToggle("Distance", "Distance", "Show distance in studs.")
    EspToggle("Health", "Health", "Show current / max health.")
    EspToggle("Level", "Level", "Show the player's level.")
    EspToggle("Bounty", "Bounty", "Show the player's bounty (uses the same reader as Auto Farm RC).")
    EspToggle("Aura", "Aura Tag", "Show [AURA] on players who have their Aura on.")
    EspToggle("Tracers", "Tracers", "Line from the bottom of the screen to each player (needs Drawing support).")
    EspToggle("TeamCheck", "Hide Teammates", "Don't draw players on your team.")

    local EspDistRow = EspForm:Row()
    EspDistRow:Left():TitleStack({ Title = "ESP Max Distance", Subtitle = "Hide players farther than this (studs)." })
    EspDistRow:Right():Stepper({
        Minimum = 100, Maximum = 10000, Step = 100, Fielded = true,
        Value = ESP.MaxDist,
        ValueChanged = function(self, v) ESP.MaxDist = math.clamp(tonumber(v) or 2000, 100, 10000) end
    })

    local StatusSection = PvpTab:PageSection({
        Title = "📊 Status",
        Subtitle = "What PVP features are doing now."
    })
    local StatusForm = StatusSection:Form()

    local AimStatusRow = StatusForm:Row()
    AimStatusRow:Left():Label({ Text = "Aimbot" })
    local AimStatusLabel = AimStatusRow:Right():Label({ Text = "Off" })

    local BntStatusRow = StatusForm:Row()
    BntStatusRow:Left():Label({ Text = "Auto Farm RC" })
    local BntStatusLabel = BntStatusRow:Right():Label({ Text = "Off" })
    _G.SmoothHubLiveKeys[AimStatusLabel] = "Aimbot"
    _G.SmoothHubLiveKeys[BntStatusLabel] = "Bounty"

    local TargetRow = StatusForm:Row()
    TargetRow:Left():Label({ Text = "Current Target" })
    local TargetLabel = TargetRow:Right():Label({ Text = "-" })

    local PvpOffRow = StatusForm:Row()
    PvpOffRow:Left():Label({ Text = "PVP-off Skipped" })
    local PvpOffLabel = PvpOffRow:Right():Label({ Text = "0" })

    local KillRow = StatusForm:Row()
    KillRow:Left():Label({ Text = "Kills This Session" })
    local KillLabel = KillRow:Right():Label({ Text = "0" })

    ---------------------------------------------------------
    -- หาค่าหัวของผู้เล่น (เกมไม่ได้เปิดเผยตำแหน่งแน่นอน เลยไล่หาหลายที่)
    -- 1) leaderstats / ค่าใน Player  2) Attribute ของ Player/Character
    -- 3) ข้อความเหนือหัว (BillboardGui)
    ---------------------------------------------------------
    local BOUNTY_WORDS = { "bounty", "wanted", "ค่าหัว", "reward", "rc" }

    local function NameLooksLikeBounty(name)
        name = string.lower(tostring(name))
        for _, w in ipairs(BOUNTY_WORDS) do
            if w == "rc" then
                if name == "rc" then return true end
            elseif string.find(name, w, 1, true) then
                return true
            end
        end
        return false
    end

    local function ParseNumber(text)
        text = tostring(text):gsub(",", ""):gsub("%s", "")
        local num, suffix = string.match(text, "([%d%.]+)([KkMmBb]?)")
        num = tonumber(num)
        if not num then return nil end
        suffix = string.lower(suffix or "")
        if suffix == "k" then num = num * 1e3
        elseif suffix == "m" then num = num * 1e6
        elseif suffix == "b" then num = num * 1e9 end
        return num
    end

    -- ค่าหัว = leaderstats.RC  /  เลเวล = Data.Level  (ดูจาก Explorer ของเกม)
    local function GetLevel(plr)
        local data = plr:FindFirstChild("Data")
        local lv = data and data:FindFirstChild("Level")
        if lv and lv:IsA("ValueBase") then return tonumber(lv.Value) end
        return nil
    end

    local function GetBounty(plr)
        local ls = plr:FindFirstChild("leaderstats")
        local rc = ls and ls:FindFirstChild("RC")
        if rc and rc:IsA("ValueBase") then
            local n = tonumber(rc.Value) or ParseNumber(rc.Value)
            if n then return n end
        end
        -- 1) ค่าใน Player (leaderstats ฯลฯ)
        for _, d in ipairs(plr:GetDescendants()) do
            if NameLooksLikeBounty(d.Name) then
                if d:IsA("ValueBase") then
                    local n = tonumber(d.Value) or ParseNumber(d.Value)
                    if n then return n end
                end
            end
        end
        -- 2) Attribute
        for _, holder in ipairs({ plr, plr.Character }) do
            if holder then
                for k, v in pairs(holder:GetAttributes()) do
                    if NameLooksLikeBounty(k) then
                        local n = tonumber(v) or ParseNumber(v)
                        if n then return n end
                    end
                end
            end
        end
        -- 3) ข้อความเหนือหัวตัวละคร
        local char = plr.Character
        if char then
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("TextLabel") and (NameLooksLikeBounty(d.Name)
                    or string.find(string.lower(d.Text), "bounty", 1, true)) then
                    local n = ParseNumber(d.Text)
                    if n then return n end
                end
            end
        end
        return 0
    end

    ---------------------------------------------------------
    -- เช็กว่าผู้เล่นเปิด Aura อยู่ไหม (เดาจากชื่อ: aura / ออร่า / haki / buso)
    -- ดูทั้ง Attribute, ค่า Bool และเอฟเฟกต์ (Particle/Beam/Trail ฯลฯ) ที่ชื่อมีคำเหล่านี้
    ---------------------------------------------------------
    local AURA_WORDS = { "aura", "ออร่า", "haki", "ฮาคิ", "buso" }
    local function NameLooksLikeAura(name)
        name = string.lower(tostring(name))
        for _, w in ipairs(AURA_WORDS) do
            if string.find(name, w, 1, true) then return true end
        end
        return false
    end

    local function Truthy(v)
        local ty = type(v)
        if ty == "boolean" then return v end
        if ty == "number" then return v ~= 0 end
        if ty == "string" then
            local s = string.lower(v)
            return s ~= "" and s ~= "false" and s ~= "0" and s ~= "off" and s ~= "none"
        end
        return v ~= nil
    end

    local function InstanceAuraOn(d)
        if d:IsA("ValueBase") then return Truthy(d.Value) end
        if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail")
            or d:IsA("Light") or d:IsA("Highlight") then
            return d.Enabled
        end
        if d:IsA("BasePart") then return d.Transparency < 1 end
        if d:IsA("Attachment") then
            local any = false
            for _, c in ipairs(d:GetChildren()) do
                if (c:IsA("ParticleEmitter") or c:IsA("Beam") or c:IsA("Trail")) then
                    any = true
                    if c.Enabled then return true end
                end
            end
            return not any
        end
        return true -- Folder / Model / อื่นๆ ที่ชื่อ Aura = ถือว่ากำลังเปิด
    end

    local auraCache = {}
    local function HasAura(plr)
        local c = auraCache[plr]
        if c and os.clock() - c.t < 0.4 then return c.v end
        local found = false
        local char = plr.Character
        for _, holder in ipairs({ plr, char or plr }) do
            if not found then
                for k, v in pairs(holder:GetAttributes()) do
                    if NameLooksLikeAura(k) and Truthy(v) then found = true break end
                end
            end
        end
        if not found then
            for _, d in ipairs(plr:GetDescendants()) do
                if d:IsA("ValueBase") and NameLooksLikeAura(d.Name) and Truthy(d.Value) then
                    found = true break
                end
            end
        end
        if not found and char then
            for _, d in ipairs(char:GetDescendants()) do
                if NameLooksLikeAura(d.Name) and InstanceAuraOn(d) then
                    found = true break
                end
            end
        end
        auraCache[plr] = { t = os.clock(), v = found }
        return found
    end

    local huntTarget = nil -- เป้าหมายที่ Auto Farm RC กำลังล่า (ให้ ESP ใช้ไฮไลต์)

    -- ปุ่มดีบัก: ปริ้นว่าอ่านค่าหัวของแต่ละคนได้เท่าไหร่ (กด F9 ดู)
    local DebugRow = BntForm:Row()
    DebugRow:Left():TitleStack({
        Title = "Debug: Print Bounties",
        Subtitle = "Prints detected bounties to the console (F9)."
    })
    DebugRow:Right():Button({
        Label = "Print",
        Callback = function()
            for _, plr in ipairs(Players:GetPlayers()) do
                print(string.format("[Smooth Hub] %s : bounty=%s", plr.Name, tostring(GetBounty(plr))))
                for _, d in ipairs(plr:GetDescendants()) do
                    if d:IsA("ValueBase") then
                        print("    ", d:GetFullName(), "=", tostring(d.Value))
                    end
                end
                for k, v in pairs(plr:GetAttributes()) do
                    print("     attr", k, "=", tostring(v))
                end
            end
        end
    })

    local AuraDebugRow = BntForm:Row()
    AuraDebugRow:Left():TitleStack({
        Title = "Debug: Print Aura Info",
        Subtitle = "Prints Aura detection info to the console (F9)."
    })
    AuraDebugRow:Right():Button({
        Label = "Print",
        Callback = function()
            for _, plr in ipairs(Players:GetPlayers()) do
                print(string.format("[Smooth Hub] %s : aura=%s", plr.Name, tostring(HasAura(plr))))
                for k, v in pairs(plr:GetAttributes()) do print("     plr attr", k, "=", tostring(v)) end
                local char = plr.Character
                if char then
                    for k, v in pairs(char:GetAttributes()) do print("     char attr", k, "=", tostring(v)) end
                    local names = {}
                    for _, c in ipairs(char:GetChildren()) do names[#names + 1] = c.Name .. "(" .. c.ClassName .. ")" end
                    print("     char children:", table.concat(names, ", "))
                end
            end
        end
    })

    local Camera = Workspace.CurrentCamera
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        Camera = Workspace.CurrentCamera
    end)

    ---------------------------------------------------------
    -- ESP : ทำงาน
    ---------------------------------------------------------
    local espFolder = Instance.new("Folder")
    espFolder.Name = "SH_ESP"
    pcall(function() espFolder.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not espFolder.Parent then espFolder.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local espObjs = {}

    local function DestroyESP(plr)
        local o = espObjs[plr]
        if not o then return end
        espObjs[plr] = nil
        pcall(function() o.hl:Destroy() end)
        pcall(function() o.bb:Destroy() end)
        pcall(function() if o.line then o.line:Remove() end end)
    end

    local function CreateESP(plr)
        local o = { nextData = 0, text = "" }
        o.hl = Instance.new("Highlight")
        o.hl.FillTransparency = 0.65
        o.hl.OutlineTransparency = 0
        o.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        o.hl.Parent = espFolder

        o.bb = Instance.new("BillboardGui")
        o.bb.Size = UDim2.new(0, 220, 0, 60)
        o.bb.StudsOffset = Vector3.new(0, 3.2, 0)
        o.bb.AlwaysOnTop = true
        o.bb.Parent = espFolder

        o.label = Instance.new("TextLabel")
        o.label.Size = UDim2.new(1, 0, 1, 0)
        o.label.BackgroundTransparency = 1
        o.label.Font = Enum.Font.GothamBold
        o.label.TextSize = 13
        o.label.TextColor3 = Color3.new(1, 1, 1)
        o.label.TextStrokeTransparency = 0.3
        o.label.RichText = true
        o.label.Parent = o.bb

        pcall(function()
            o.line = Drawing.new("Line")
            o.line.Thickness = 1.2
            o.line.Visible = false
        end)
        espObjs[plr] = o
        return o
    end

    Players.PlayerRemoving:Connect(DestroyESP)

    local espConn
    espConn = RunService.RenderStepped:Connect(function()
        if not Alive() then
            espConn:Disconnect()
            for plr in pairs(espObjs) do DestroyESP(plr) end
            pcall(function() espFolder:Destroy() end)
            return
        end

        local myRoot = GetMyRoot()
        local viewport = Camera.ViewportSize

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local show = ESP.Enabled and root and hum and hum.Health > 0
                    and not (ESP.TeamCheck and SameTeam(plr))
                local dist = 0
                if show and myRoot then
                    dist = (root.Position - myRoot.Position).Magnitude
                    if dist > ESP.MaxDist then show = false end
                end

                if not show then
                    local o = espObjs[plr]
                    if o then
                        o.hl.Enabled = false
                        o.bb.Enabled = false
                        if o.line then o.line.Visible = false end
                    end
                else
                    local o = espObjs[plr] or CreateESP(plr)
                    local isTarget = (huntTarget == plr)
                    local aura = ESP.Aura and HasAura(plr)

                    local color = Color3.fromRGB(255, 255, 255)
                    if isTarget then color = Color3.fromRGB(255, 60, 60)
                    elseif aura then color = Color3.fromRGB(255, 170, 40) end

                    o.hl.Enabled = ESP.Chams
                    o.hl.Adornee = char
                    o.hl.FillColor = color
                    o.hl.OutlineColor = color

                    o.bb.Enabled = true
                    o.bb.Adornee = char:FindFirstChild("Head") or root
                    o.label.TextColor3 = color

                    if os.clock() >= o.nextData then
                        o.nextData = os.clock() + 0.4
                        local lines = {}
                        if ESP.Name then lines[#lines + 1] = plr.DisplayName end
                        if ESP.Level then
                            local lv = GetLevel(plr)
                            if lv then lines[#lines + 1] = "Lv. " .. tostring(math.floor(lv)) end
                        end
                        if ESP.Bounty then
                            local b = GetBounty(plr)
                            if b > 0 then lines[#lines + 1] = "💰 " .. tostring(math.floor(b)) end
                        end
                        if aura then lines[#lines + 1] = "[AURA]" end
                        o.text = table.concat(lines, "\n")
                    end
                    local extra = {}
                    if ESP.Health then extra[#extra + 1] = string.format("HP %d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth)) end
                    if ESP.Distance then extra[#extra + 1] = string.format("%d studs", math.floor(dist)) end
                    local full = o.text
                    if #extra > 0 then full = full .. (full ~= "" and "\n" or "") .. table.concat(extra, "  ") end
                    o.label.Text = full

                    if o.line then
                        local v, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if ESP.Tracers and onScreen then
                            o.line.From = Vector2.new(viewport.X / 2, viewport.Y)
                            o.line.To = Vector2.new(v.X, v.Y)
                            o.line.Color = color
                            o.line.Visible = true
                        else
                            o.line.Visible = false
                        end
                    end
                end
            end
        end
    end)

    ---------------------------------------------------------
    -- Aimbot : ทำงาน
    ---------------------------------------------------------
    local circle = nil
    pcall(function()
        circle = Drawing.new("Circle")
        circle.Thickness = 1.5
        circle.NumSides = 64
        circle.Filled = false
        circle.Color = Color3.fromRGB(255, 255, 255)
        circle.Visible = false
    end)

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local function PickPart(char, mousePos)
        if AIM.Part == "Head" then
            return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        elseif AIM.Part == "HumanoidRootPart" then
            return char:FindFirstChild("HumanoidRootPart")
        end
        -- Closest Part : ชิ้นส่วนที่อยู่ใกล้เคอร์เซอร์ที่สุด
        local best, bestDist = nil, math.huge
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                local v, onScreen = Camera:WorldToViewportPoint(p.Position)
                if onScreen then
                    local d = (Vector2.new(v.X, v.Y) - mousePos).Magnitude
                    if d < bestDist then best, bestDist = p, d end
                end
            end
        end
        return best
    end

    local function Visible(part, char)
        if not AIM.WallCheck then return true end
        rayParams.FilterDescendantsInstances = { LocalPlayer.Character, char }
        local origin = Camera.CFrame.Position
        local hit = Workspace:Raycast(origin, part.Position - origin, rayParams)
        return hit == nil
    end

    local function GetAimTarget()
        local myRoot = GetMyRoot()
        local mousePos = UserInputService:GetMouseLocation()
        local bestPart, bestDist = nil, AIM.FOV
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and not (AIM.TeamCheck and SameTeam(plr)) then
                local char = plr.Character
                if IsAlive(char) then
                    local part = PickPart(char, mousePos)
                    if part then
                        local inRange = not myRoot or (part.Position - myRoot.Position).Magnitude <= AIM.MaxDist
                        local v, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if inRange and onScreen then
                            local d = (Vector2.new(v.X, v.Y) - mousePos).Magnitude
                            if d < bestDist and Visible(part, char) then
                                bestPart, bestDist = part, d
                            end
                        end
                    end
                end
            end
        end
        return bestPart
    end

    local lastAimText = ""
    RunService.RenderStepped:Connect(function()
        if not Alive() then return end

        local mousePos = UserInputService:GetMouseLocation()
        if circle then
            circle.Visible = AIM.Enabled and AIM.ShowFOV
            circle.Position = mousePos
            circle.Radius = AIM.FOV
        end

        local text = "Off"
        if AIM.Enabled then
            local holding = AIM.Mode == "Always On"
                or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            if holding then
                local part = GetAimTarget()
                if part then
                    local goal = CFrame.lookAt(Camera.CFrame.Position, part.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(goal, math.clamp(AIM.Smooth / 100, 0.01, 1))
                    text = "Locked : " .. (part.Parent and part.Parent.Name or "?")
                else
                    text = "No target"
                end
            else
                text = "Ready (hold right click)"
            end
        end
        if text ~= lastAimText then
            lastAimText = text
            SetText(AimStatusLabel, text)
        end
    end)

    ---------------------------------------------------------
    -- Auto Farm RC : ทำงาน
    ---------------------------------------------------------
    local AttackEvent = nil
    task.spawn(function()
        local bridge = ReplicatedStorage:WaitForChild("BridgeNet2", 10)
        AttackEvent = bridge and bridge:WaitForChild("dataRemoteEvent", 10)
    end)
    local function Attack()
        if AttackEvent then
            pcall(function() AttackEvent:FireServer({ { "NormalAttack", 1 }, "\x13" }) end)
        end
    end

    -- เช็ก Safe Zone (โครงสร้างเดียวกับฟาร์มมอน: Workspace.IncludeToGame.Zones > SafeZone)
    local function GetZonesFolder()
        local inc = Workspace:FindFirstChild("IncludeToGame")
        return inc and inc:FindFirstChild("Zones")
    end

    local function InSafeZone(char)
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local zones = GetZonesFolder()
        if not root or not zones then return false end
        local pos = root.Position
        for _, zone in ipairs(zones:GetChildren()) do
            if zone.Name == "SafeZone" and zone:IsA("BasePart") then
                local zp, zs = zone.Position, zone.Size
                if math.abs(pos.X - zp.X) <= zs.X / 2 and math.abs(pos.Z - zp.Z) <= zs.Z / 2 then
                    return true
                end
            end
        end
        return false
    end

    local function LevelOk(plr)
        if not BNT.LevelFilter then return true end
        local mine, theirs = GetLevel(LocalPlayer), GetLevel(plr)
        if not mine or not theirs then return true end -- อ่านเลเวลไม่ได้ = ไม่กรอง
        return math.abs(mine - theirs) <= BNT.LevelRange
    end

    local function PickBountyTarget(skip)
        local best, bestBounty = nil, -1
        local why = { safe = 0, level = 0, aura = 0, skipped = 0, team = 0, online = 0 }
        local selected = nil
        if BNT.OnlySelected then
            selected = {}
            for _, n in ipairs(BNT.OnlyPlayers) do selected[n] = true end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not selected or selected[plr.Name])
                and IsAlive(plr.Character) and plr.Character:FindFirstChild("HumanoidRootPart") then
                why.online += 1
                if skip and skip[plr] then
                    why.skipped += 1
                elseif BNT.TeamCheck and SameTeam(plr) then
                    why.team += 1
                elseif BNT.SkipSafeZone and InSafeZone(plr.Character) then
                    why.safe += 1
                elseif BNT.SkipAura and HasAura(plr) then
                    why.aura += 1
                elseif not selected and not LevelOk(plr) then
                    why.level += 1
                else
                    local b = GetBounty(plr)
                    if (selected or b >= BNT.MinBounty) and b > bestBounty then
                        best, bestBounty = plr, b
                    end
                end
            end
        end
        return best, bestBounty, why
    end

    local function FormatNum(n)
        local s = tostring(math.floor(n))
        local formatted = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
        return (formatted:gsub("^,", ""))
    end

    local kills, pvpOffCount = 0, 0
    task.spawn(function()
        local skipUntil = {}   -- ผู้เล่นที่ข้ามชั่วคราว (ติดไม่ลง / ตีไม่เข้า / ตีไม่ตาย)
        while Alive() do
            task.wait(0.1)
            if not (BNT.Enabled and _G.SmoothHubArb.BountyOn()) then
                huntTarget = nil
                -- เปิดสวิตช์ไว้แต่ถูกพัก = รอคิว (ไม่ใช่ปิด)
                SetText(BntStatusLabel, BNT.Enabled and "Waiting (another farm has priority)" or "Off")
                SetText(TargetLabel, "-")
            else
                local skip = {}
                for plr, untilT in pairs(skipUntil) do
                    if os.clock() < untilT and plr.Parent == Players then skip[plr] = true else skipUntil[plr] = nil end
                end

                local target, bounty, why = PickBountyTarget(skip)
                if not target then
                    local parts = {}
                    if BNT.OnlySelected and why.online == 0 then parts[#parts + 1] = "selected players not found / dead" end
                    if why.safe > 0 then parts[#parts + 1] = "safe zone " .. why.safe end
                    if why.level > 0 then parts[#parts + 1] = "level " .. why.level end
                    if why.aura > 0 then parts[#parts + 1] = "aura " .. why.aura end
                    if why.skipped > 0 then parts[#parts + 1] = "skipped " .. why.skipped end
                    if why.team > 0 then parts[#parts + 1] = "team " .. why.team end
                    local txt = "Waiting for a target"
                    if #parts > 0 then txt = txt .. " (" .. table.concat(parts, ", ") .. ")" end
                    SetText(BntStatusLabel, txt)
                    SetText(TargetLabel, "-")
                else
                    SetText(BntStatusLabel, "Hunting")
                    SetText(TargetLabel, target.Name .. " (" .. FormatNum(bounty) .. ")")
                    huntTarget = target
                    local startedAt = os.clock()
                    local died = false
                    local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
                    local lastHp = hum and hum.Health or 0
                    local noDmgSince = nil

                    while Alive() and BNT.Enabled and _G.SmoothHubArb.BountyOn() and target.Parent == Players
                        and IsAlive(target.Character) and IsAlive(LocalPlayer.Character) do
                        local dt = RunService.Heartbeat:Wait()
                        local myRoot = GetMyRoot()
                        local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                        if not (myRoot and tRoot) then break end

                        -- เป้าหมายเดินเข้า Safe Zone กลางทาง = เลิกตามคนนี้ ไปหาคนอื่นก่อน
                        if BNT.SkipSafeZone and InSafeZone(target.Character) then
                            skipUntil[target] = os.clock() + 10
                            break
                        end

                        -- เป้าหมายเปิด Aura กลางคัน = เลิกตาม
                        if BNT.SkipAura and HasAura(target) then
                            skipUntil[target] = os.clock() + 10
                            break
                        end

                        local d = BNT.Distance
                        local offset
                        if BNT.Position == "Above" then
                            offset = CFrame.new(0, d, 0) * CFrame.Angles(-math.pi / 2, 0, 0)
                        elseif BNT.Position == "Below" then
                            offset = CFrame.new(0, -d, 0) * CFrame.Angles(math.pi / 2, 0, 0)
                        else
                            offset = CFrame.new(0, 0, d)
                        end
                        local goal = tRoot.CFrame * offset
                        local dist = (goal.Position - myRoot.Position).Magnitude
                        myRoot.AssemblyLinearVelocity = Vector3.zero

                        local inRange = true
                        if BNT.MoveMode == "Fly" and dist > 2 then
                            -- บินเข้าหาทีละก้าว
                            local step = math.min(BNT.FlySpeed * dt, dist)
                            myRoot.CFrame = CFrame.lookAt(myRoot.Position + (goal.Position - myRoot.Position).Unit * step, tRoot.Position)
                            SetText(BntStatusLabel, "Flying to target")
                            inRange = dist <= 15
                        else
                            -- แบบเดิม : ล็อกตำแหน่งข้างเป้าหมายทุกเฟรม
                            myRoot.CFrame = goal
                            SetText(BntStatusLabel, "Attacking")
                        end

                        if inRange then
                            Attack()
                            -- ตีไม่เข้า : เลือดไม่ลดเลยตลอดช่วงที่ตั้งไว้ = ถือว่าคนนี้ปิด PVP อยู่
                            if not hum or hum.Parent ~= target.Character then
                                hum = target.Character:FindFirstChildOfClass("Humanoid")
                                lastHp = hum and hum.Health or 0
                            end
                            local hp = hum and hum.Health or 0
                            if hp < lastHp - 0.01 or not noDmgSince then
                                noDmgSince = os.clock()
                            elseif os.clock() - noDmgSince > BNT.NoDamageTime then
                                skipUntil[target] = os.clock() + BNT.PvpOffTime
                                pvpOffCount += 1
                                SetText(PvpOffLabel, tostring(pvpOffCount))
                                SetText(TargetLabel, target.Name .. " - can't damage (PVP off?), next target")
                                break
                            end
                            lastHp = hp
                        end

                        -- ตีนานเกิน 40 วิยังไม่ตาย = ข้ามไปก่อน (อาจมีโล่/ติดบั๊ก)
                        if os.clock() - startedAt > 40 then
                            skipUntil[target] = os.clock() + 30
                            break
                        end
                    end

                    huntTarget = nil
                    if target.Parent == Players and target.Character and not IsAlive(target.Character)
                        and IsAlive(LocalPlayer.Character) then
                        died = true
                    end
                    if died then
                        kills += 1
                        SetText(KillLabel, tostring(kills))
                        skipUntil[target] = os.clock() + 5 -- ให้รีสปอนก่อนค่อยล่าอีก
                    end
                end
            end
        end
    end)
end

---------------------------------------------------------
-- แท็บ Crafting (Ghoul + CCG)
-- 1) Weapon Shop Timer : อ่านเวลานับถอยหลังของร้านอาวุธ (Kagune = Ghoul / Quinque = CCG)
--    จากหน้าร้านที่เปิดอยู่ แล้วนับถอยหลังต่อเองแม้ปิดร้านไปแล้ว
-- 2) Auto Buy Weapon : ซื้ออาวุธของร้าน Kagune (Ghoul) และ Quinque (CCG) ได้หลายอันตามลำดับที่ติ๊ก
--      InvokeServer("Buy", "<ชื่ออาวุธ>") ไปที่ RemoteFunction ในโฟลเดอร์ ReplicatedStorage.Network
-- 3) Auto Craft : คราฟต์ไอเทมของ Ghoul (BridgeNet2.dataRemoteEvent) วนซ้ำตามลำดับที่ติ๊ก
-- 4) NPC Check : เช็กว่า NPC Crafting / Workshop / Weapon อยู่ใน Workspace.TalkNpc ไหม
-- ใช้ do ... end ครอบไว้ เพื่อไม่ให้ตัวแปร local ชนลิมิต 200 ตัวของ Lua
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local token = {}
    _G.SmoothHubCraftingToken = token
    local function Alive() return _G.SmoothHubCraftingToken == token end

    local CraftingCfg = _G.SmoothHubConfig.Crafting -- ถูกโหลดค่าที่เซฟไว้ให้แล้วจาก SettingsStore.Restore

    local CraftingTab = CategorySection:Tab({
        Title = "Crafting",
        Icon = Cascade.Symbols["hammerFill"] or Cascade.Symbols["wrenchAndScrewdriverFill"] or Cascade.Symbols["leafFill"]
    })
    _G.SmoothHubCraftingTab = CraftingTab -- ให้ปุ่มเปลี่ยนสีธีมรีเฟรชแท็บนี้ด้วย

    ---------------------------------------------------------
    -- ข้อมูล
    ---------------------------------------------------------
    -- ชื่ออาวุธ (ชื่อที่ส่งใน Remote ตรงกับชื่อในร้าน) ที่ Remote Spy จับได้แล้ว:
    --   Ghoul: Sumiharu, Shuu, Kaneki, Touka    CCG: Douhi, Fueguchi, Nagomi, Kajiri
    -- ที่เหลือใช้ชื่อตามหน้าร้าน (Jason of 13 ของ CCG ขึ้น "Not sale" เลยไม่ใส่)
    local GHOUL_WEAPONS = {
        "Nishiki", "Sumiharu", "Shuu", "Jason", "Kaneki", "Hinami",
        "Noro", "Eto", "Touka", "Tatara", "Takizawa",
    }
    local CCG_WEAPONS = {
        "Katana", "Douhi", "Doujima", "Fueguchi", "Scorpion", "Yamada", "Nagomi",
        "Yukimura", "Kajiri", "Bokusatsu", "Kuroiwa Special", "Kura", "Ginkui",
    }

    -- ชื่อ Remote ที่จับได้ (ใช้เป็นตัวเลือกแรก ชื่อใน Network เปลี่ยนตามเซิร์ฟเวอร์ได้ จึงมีระบบหาเองด้วย)
    local KNOWN_GHOUL_SHOP = "{C338142B-ECCA-4F59-9FC6-981C6143CDA2}"
    local KNOWN_CCG_SHOP = "{71D6624F-D93C-4388-99C1-062C617883DB}"
    local KNOWN_MASK_SHOP = "{CB9E5C07-3661-4EAC-B76D-553560668412}" -- ของแท็บ Shop (ไม่ลองซ้ำตอนหา Remote)

    -- Auto Craft (Ghoul): BridgeNet2.dataRemoteEvent:FireServer({ { "\x01", <รหัส 16 ไบต์ของไอเทม>, "<ชื่อ>" }, "\x17" })
    local CRAFT_ITEMS = { "Centipede", "Crimson Watchflower", "One-Eyed Core", "Inferno Core", "Seal of Shackles" }
    local CRAFT_KEYS = {
        ["Centipede"]           = "\xA3J\x84?\f\fK#\xA0\xEF\xEE\xAA\xD9\xEF\xDA\x93",
        ["Crimson Watchflower"] = ")\x18\xEF\xB5\xD9`HZ\x80\xF3\xDA]\x1Dg\x15a",
        ["One-Eyed Core"]       = "\xC9\xE5\xF3/\x8E\xD2J\xA9\x8E~\xCE\x1F\xF5\x89\x13\x82",
        ["Inferno Core"]        = "\x98\xAFl\xDF\xEDOM \xA8Dk>w\x88\xF5B",
        ["Seal of Shackles"]    = "\xFCB_\xA1\xFF\x83D%\xB1@f`f6\xA3:",
    }

    ---------------------------------------------------------
    -- ตัวช่วยทั่วไป
    ---------------------------------------------------------
    local function Clean(text)
        text = string.gsub(tostring(text or ""), "<[^>]+>", "")
        return (string.match(text, "^%s*(.-)%s*$"))
    end

    local function IsShown(obj)
        local cur = obj
        while cur do
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            if cur:IsA("ScreenGui") and not cur.Enabled then return false end
            cur = cur.Parent
        end
        return true
    end

    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        pcall(function() label.Text = text end)
    end

    local function Paint(text, hex)
        return string.format('<font color="%s">%s</font>', hex, text)
    end

    local function FormatTime(seconds)
        seconds = math.max(0, math.floor(seconds))
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        if h > 0 then return string.format("%dh %02dm %02ds", h, m, s) end
        return string.format("%dm %02ds", m, s)
    end

    ---------------------------------------------------------
    -- ตัวช่วยเรื่อง Remote ใน ReplicatedStorage.Network
    ---------------------------------------------------------

    -- เรียก InvokeServer พร้อมเวลารอสูงสุด (กันค้างถ้าเซิร์ฟเวอร์ไม่ตอบ)
    local function InvokeOne(remote, timeout, ...)
        local args = table.pack(...)
        local replied, ok, reply = false, false, nil
        task.spawn(function()
            ok, reply = pcall(function() return remote:InvokeServer(table.unpack(args, 1, args.n)) end)
            replied = true
        end)
        local t0 = os.clock()
        while not replied and os.clock() - t0 < timeout do task.wait(0.05) end
        if not replied then return false, "no reply (timeout)" end
        return ok, reply
    end


    -- แปลผลที่เซิร์ฟเวอร์ตอบ -> kind: "done" | "sent" | "failed"
    local function Classify(ok, reply)
        if not ok then return "failed", tostring(reply) end
        if reply == false then return "failed", "server replied false" end
        if reply == true then return "done", "reply: true" end
        if reply == nil then return "sent", "no reply value" end
        if type(reply) == "string" or type(reply) == "number" then
            return "sent", "reply: " .. tostring(reply)
        end
        return "sent", "reply: " .. typeof(reply)
    end

    -- Auto Buy: ส่งเฉพาะไปที่ Remote ที่รู้จักแน่นอน (GUID ที่ดักจาก Remote Spy) เท่านั้น
    -- ถ้าไม่เจอ Remote นั้น (เกมอาจเปลี่ยนชื่อ) จะไม่ส่งอะไรเลย แล้วแจ้งในสถานะ
    -- (เวอร์ชันเก่าจะยิง "Buy" ไปทุก Remote ใน Network เพื่อเดา ซึ่งเกมตรวจจับได้และเตะ)
    local function MakeBuyAction(knownGuid, excludeGuids)
        return function(name)
            local network = ReplicatedStorage:FindFirstChild("Network")
            if not network then return nil, "Network folder not found" end
            local remote = network:FindFirstChild(knownGuid)
            if not (remote and remote:IsA("RemoteFunction")) then
                return nil, "Shop remote not found (the game may have changed it) - nothing was sent"
            end
            local ok, reply = InvokeOne(remote, 6, "Buy", name)
            return Classify(ok, reply)
        end
    end

    ---------------------------------------------------------
    -- ตัวสร้างหน้า "Auto ..." (ใช้ร่วมกันทั้งซื้ออาวุธ Ghoul / CCG และ Auto Craft)
    -- o.Items   = รายชื่อทั้งหมดให้ติ๊ก      o.Cfg = ตารางค่าที่เซฟ (OnKey / Items / Delay / Retry / RetryDelay)
    -- o.Act(name) -> kind, text  (kind = "done" | "sent" | "failed")  หรือ nil, ข้อความปัญหา (เช่นหา Remote ไม่เจอ)
    -- o.Repeat = true : ทำครบทุกชิ้นแล้ววนรอบใหม่ไปเรื่อย ๆ (Auto Craft) / false : ทำแต่ละชิ้นรอบเดียว (ซื้อของ)
    ---------------------------------------------------------
    local function BuildQueue(o)
        local cfg = o.Cfg

        -- ตรวจค่าที่โหลดมา: เหลือเฉพาะชื่อที่มีจริง ไม่ซ้ำ เรียงตามลำดับเดิม
        do
            local clean, seen = {}, {}
            if type(cfg.Items) == "table" then
                for _, name in ipairs(cfg.Items) do
                    if table.find(o.Items, name) and not seen[name] then
                        seen[name] = true
                        table.insert(clean, name)
                    end
                end
            end
            cfg.Items = clean
            cfg.Delay = math.clamp(tonumber(cfg.Delay) or o.DelayDefault, o.DelayMin, o.DelayMax)
            cfg[o.OnKey] = cfg[o.OnKey] == true
            if o.AllowRetry then
                cfg.Retry = cfg.Retry == true
                cfg.RetryDelay = math.clamp(tonumber(cfg.RetryDelay) or 30, 5, 600)
            end
        end

        -- ความจำของที่ซื้อแล้ว (เซฟลงไฟล์ ปิด/เปิดสคริปต์ใหม่ก็ยังจำได้ = ไม่ซื้อซ้ำ)
        if o.Persist then
            local clean, seen = {}, {}
            if type(cfg.Bought) == "table" then
                for _, name in ipairs(cfg.Bought) do
                    if table.find(o.Items, name) and not seen[name] then
                        seen[name] = true
                        table.insert(clean, name)
                    end
                end
            end
            cfg.Bought = clean
        end
        local function IsBought(name)
            return o.Persist and cfg.Bought and table.find(cfg.Bought, name) ~= nil or false
        end

        local Refresh -- กำหนดค่าด้านล่าง

        ---------------------------------------------------------
        -- UI : ตั้งค่า
        ---------------------------------------------------------
        local SetSection = CraftingTab:PageSection({ Title = o.Title, Subtitle = o.Subtitle })
        local SetForm = SetSection:Form()

        local ToggleRow = SetForm:Row()
        ToggleRow:Left():TitleStack({ Title = o.ToggleTitle, Subtitle = o.ToggleSubtitle })
        ToggleRow:Right():Toggle({
            Value = cfg[o.OnKey],
            ValueChanged = function(self, value) cfg[o.OnKey] = value and true or false end
        })

        local PickRow = SetForm:Row()
        PickRow:Left():TitleStack({ Title = o.PickTitle, Subtitle = "Tick one or more. First ticked = first." })
        local initialIndexes = {}
        for _, name in ipairs(cfg.Items) do
            table.insert(initialIndexes, table.find(o.Items, name))
        end
        local results = {} -- results[ชื่อ] = { kind, text, at }
        local function SeedBought()
            if not o.Persist then return end
            for _, name in ipairs(cfg.Bought) do
                results[name] = { kind = "done", text = "saved from before", at = os.clock() }
            end
        end
        SeedBought()
        PickRow:Right():PopUpButton({
            Options = o.Items,
            Maximum = #o.Items,
            Value = initialIndexes,
            ValueChanged = function(self, value)
                -- value เรียงตามลำดับที่ติ๊ก (ติ๊กก่อนอยู่หน้า)
                local names = {}
                for _, index in ipairs(value or {}) do
                    if o.Items[index] then table.insert(names, o.Items[index]) end
                end
                cfg.Items = names
                for name in pairs(results) do
                    -- เอาติ๊กออก = ล้างผล ติ๊กใหม่จะทำอีกรอบ (ยกเว้นของที่ซื้อแล้ว ยังจำไว้ ไม่ซื้อซ้ำ)
                    if not table.find(names, name) and not IsBought(name) then results[name] = nil end
                end
                if Refresh then Refresh() end
            end
        })

        local DelayRow = SetForm:Row()
        DelayRow:Left():TitleStack({
            Title = o.DelayTitle,
            Subtitle = string.format("Seconds to wait between each one (%d - %d, default %d).", o.DelayMin, o.DelayMax, o.DelayDefault)
        })
        DelayRow:Right():Stepper({
            Minimum = o.DelayMin,
            Maximum = o.DelayMax,
            Step = 1,
            Fielded = true,
            Value = cfg.Delay,
            ValueChanged = function(self, value)
                cfg.Delay = math.clamp(tonumber(value) or o.DelayDefault, o.DelayMin, o.DelayMax)
            end
        })

        if o.AllowRetry then
            local RetryRow = SetForm:Row()
            RetryRow:Left():TitleStack({
                Title = "Keep Trying",
                Subtitle = "Waits for items that are out of stock / not affordable yet, and retries them."
            })
            RetryRow:Right():Toggle({
                Value = cfg.Retry,
                ValueChanged = function(self, value) cfg.Retry = value and true or false end
            })

            local RetryDelayRow = SetForm:Row()
            RetryDelayRow:Left():TitleStack({
                Title = "Retry Every",
                Subtitle = "Seconds before retrying (5 - 600)."
            })
            RetryDelayRow:Right():Stepper({
                Minimum = 5,
                Maximum = 600,
                Step = 5,
                Fielded = true,
                Value = cfg.RetryDelay,
                ValueChanged = function(self, value)
                    cfg.RetryDelay = math.clamp(tonumber(value) or 30, 5, 600)
                end
            })
        end

        if o.Persist then
            local ForgetRow = SetForm:Row()
            ForgetRow:Left():TitleStack({
                Title = "Forget Bought",
                Subtitle = "Clears the saved list. Ticked weapons can then be bought again."
            })
            ForgetRow:Right():Button({
                Label = "Reset",
                Callback = function()
                    for i = #cfg.Bought, 1, -1 do table.remove(cfg.Bought, i) end
                    for name in pairs(results) do results[name] = nil end
                    if Refresh then Refresh() end
                end
            })
        end

        ---------------------------------------------------------
        -- UI : Status
        ---------------------------------------------------------
        local StatusSection = CraftingTab:PageSection({
            Title = o.StatusTitle,
            Subtitle = "What it is doing now."
        })
        local StatusForm = StatusSection:Form()
        local function AddInfoRow(title, text)
            local row = StatusForm:Row()
            row:Left():Label({ Text = title })
            return row:Right():Label({ Text = text })
        end
        local StatusLabel   = AddInfoRow("Status", OFF_TEXT)
        local NowLabel      = AddInfoRow("Now", "-")
        local NextLabel     = AddInfoRow("Next", "-")
        local ProgressLabel = AddInfoRow("Progress", "-")
        if o.LiveKey then _G.SmoothHubLiveKeys[StatusLabel] = o.LiveKey end

        local OrderSection = CraftingTab:PageSection({
            Title = o.OrderTitle,
            Subtitle = "Ticked items, in order."
        })
        local OrderForm = OrderSection:Form()
        local ItemRows = {}
        for _, name in ipairs(o.Items) do
            local row = OrderForm:Row()
            row:Left():Label({ Text = name })
            ItemRows[name] = { Row = row, Label = row:Right():Label({ Text = "-" }) }
        end

        ---------------------------------------------------------
        -- สถานะ
        ---------------------------------------------------------
        local current, lastResult, lastError = nil, nil, nil
        local waitUntil, wasOn, cycle = 0, false, 1
        local shown = setmetatable({}, { __mode = "k" }) -- กันตั้งข้อความซ้ำถ้าไม่เปลี่ยน

        local function Set(label, text)
            if shown[label] == text then return end
            shown[label] = text
            SetText(label, text)
        end

        -- ชิ้นที่ "ยังไม่จบ": ยังไม่มีผล หรือ ล้มเหลวแต่เปิด Keep Trying ไว้
        local function Waiting(name)
            local r = results[name]
            if not r then return true end
            return r.kind == "failed" and o.AllowRetry and cfg.Retry == true
        end

        -- ชิ้นที่ถึงเวลาทำได้เลย
        local function Eligible(name)
            local r = results[name]
            if not r then return true end
            return r.kind == "failed" and o.AllowRetry and cfg.Retry == true and os.clock() - r.at >= cfg.RetryDelay
        end

        local function RetryLeft(name)
            local r = results[name]
            if not r then return 0 end
            return math.max(0, math.ceil(cfg.RetryDelay - (os.clock() - r.at)))
        end

        Refresh = function()
            local on = cfg[o.OnKey]
            local waiting, done, failed = {}, 0, 0
            for _, name in ipairs(cfg.Items) do
                local r = results[name]
                if r then
                    if r.kind == "failed" then failed += 1 else done += 1 end
                end
                if Waiting(name) then table.insert(waiting, name) end
            end

            -- ตัวถัดไป
            local nextName
            for _, name in ipairs(waiting) do
                if name ~= current and Eligible(name) then nextName = name break end
            end
            if not nextName then
                for _, name in ipairs(waiting) do
                    if name ~= current then nextName = name break end
                end
            end

            -- Status หลัก
            local text
            if not on then
                text = Paint(OFF_TEXT, "#96A5AA")
            elseif #cfg.Items == 0 then
                text = Paint("Nothing selected", "#FFB432")
            elseif lastError and not current then
                text = Paint(lastError, "#EB4646")
            elseif current then
                text = Paint(string.format("%s %s (%d/%d)", o.Verb, current, done + failed + 1, #cfg.Items), "#64C8FF")
            elseif #waiting == 0 then
                text = failed > 0
                    and Paint(string.format("Finished - %d done, %d failed", done, failed), "#FFB432")
                    or Paint(string.format("Finished - %d done", done), "#28DC64")
            elseif os.clock() < waitUntil then
                text = Paint(string.format("Next in %ds", math.ceil(waitUntil - os.clock())), "#64C8FF")
            elseif nextName and not Eligible(nextName) then
                text = Paint(string.format("Retry %s in %ds", nextName, RetryLeft(nextName)), "#64C8FF")
            else
                text = Paint("Ready", "#64C8FF")
            end
            Set(StatusLabel, text)

            -- Now
            local nowText = "-"
            if current then
                nowText = Paint(string.format("🔧 %s %s...", o.Verb, current), "#64C8FF")
            elseif lastResult then
                local good = lastResult.kind ~= "failed"
                nowText = Paint(
                    string.format("%s %s - %s", good and "✅" or "❌", lastResult.name, lastResult.text),
                    good and "#28DC64" or "#EB4646"
                )
            end
            Set(NowLabel, nowText)

            Set(NextLabel, nextName and Paint("⏭ " .. nextName, "#FFB432") or "-")
            if o.Repeat then
                Set(ProgressLabel, string.format("Cycle %d | Done %d | Failed %d | Left %d", cycle, done, failed, #waiting))
            else
                Set(ProgressLabel, string.format("Done %d | Failed %d | Left %d", done, failed, #waiting))
            end

            -- รายการทั้งหมดตามลำดับที่ติ๊ก
            for _, name in ipairs(o.Items) do
                local entry = ItemRows[name]
                local order = table.find(cfg.Items, name)
                pcall(function() entry.Row.Visible = order ~= nil end)
                if order then
                    local r = results[name]
                    local line
                    if r then
                        if r.kind == "failed" then
                            line = Paint("❌ Failed - " .. r.text, "#EB4646")
                            if o.AllowRetry and cfg.Retry then
                                line = line .. Paint(string.format("  (retry in %ds)", RetryLeft(name)), "#FFB432")
                            end
                        else
                            line = Paint(string.format("✅ %s (%s)", r.kind == "done" and o.DoneWord or "Sent", r.text), "#28DC64")
                        end
                    elseif current == name then
                        line = Paint("🔧 " .. o.Verb .. "...", "#64C8FF")
                    elseif nextName == name then
                        line = Paint("⏭ Next", "#FFB432")
                    else
                        line = "⏳ Queued"
                    end
                    Set(entry.Label, string.format("#%d  %s", order, line))
                end
            end
        end

        ---------------------------------------------------------
        -- ลูปหลัก
        ---------------------------------------------------------
        task.spawn(function()
            while Alive() do
                task.wait(0.2)

                if not cfg[o.OnKey] then
                    if wasOn then
                        -- ปิดสวิตช์: ล้างผล เปิดใหม่รอบหน้าจะเริ่มใหม่ทั้งหมด
                        for name in pairs(results) do results[name] = nil end
                        SeedBought() -- ของที่ซื้อแล้วยังจำไว้
                        current, lastResult, lastError, cycle = nil, nil, nil, 1
                    end
                    wasOn = false
                    Refresh()
                    continue
                end
                wasOn = true

                if #cfg.Items == 0 or os.clock() < waitUntil then
                    Refresh()
                    continue
                end

                -- โหมดวนซ้ำ: ทำครบทุกชิ้นแล้ว เริ่มรอบใหม่
                if o.Repeat then
                    local all = true
                    for _, name in ipairs(cfg.Items) do
                        if not results[name] then all = false break end
                    end
                    if all then
                        for name in pairs(results) do results[name] = nil end
                        cycle += 1
                    end
                end

                local name
                for _, n in ipairs(cfg.Items) do
                    if Eligible(n) then name = n break end
                end
                if not name then
                    Refresh()
                    continue
                end

                results[name] = nil -- (กรณีลองใหม่) ล้างผลล้มเหลวเก่า
                current = name
                Refresh()

                local kind, text = o.Act(name)

                if kind == nil then
                    -- ทำไม่ได้เพราะปัญหาของระบบ (เช่น หา Remote ไม่เจอ) ไม่นับเป็นผลของชิ้นนี้
                    lastError = text
                    current = nil
                    waitUntil = os.clock() + 3
                    Refresh()
                    continue
                end

                -- ซื้อสำเร็จ (หรือส่งคำสั่งไปแล้ว) = จำไว้ถาวร จะไม่ซื้อซ้ำ แม้ผู้ใช้ปิดสวิตช์ระหว่างรอก็ตาม
                if o.Persist and (kind == "done" or kind == "sent") and not IsBought(name) then
                    table.insert(cfg.Bought, name)
                end

                -- ผู้ใช้ปิดสวิตช์ / เอาติ๊กออกระหว่างรอ: ไม่บันทึกผล
                if cfg[o.OnKey] and table.find(cfg.Items, name) then
                    results[name] = { kind = kind, text = text, at = os.clock() }
                    lastResult = { name = name, kind = kind, text = text }
                    lastError = nil
                end
                current = nil
                waitUntil = os.clock() + (cfg.Delay or o.DelayDefault)
                Refresh()
            end
        end)

        Refresh()
    end

    ---------------------------------------------------------
    -- 1) Weapon Shop Timer
    ---------------------------------------------------------
    local TimerSection = CraftingTab:PageSection({
        Title = "⏱ Weapon Shop Timer",
        Subtitle = "Time until the weapon shop restocks. Open the shop once to read it."
    })
    local TimerForm = TimerSection:Form()

    local function AddTimerRow(title, subtitle)
        local row = TimerForm:Row()
        row:Left():TitleStack({ Title = title, Subtitle = subtitle })
        return row, row:Right():Label({ Text = "-" })
    end

    local _, KaguneLabel = AddTimerRow("Kagune Shop (Ghoul)", "Weapon NPC in Workspace > TalkNpc > GHOUL")
    local _, QuinqueLabel = AddTimerRow("Quinque Shop (CCG)", "Weapon NPC in Workspace > TalkNpc > CCG")
    local GenericRow, GenericLabel = AddTimerRow("Weapon Shop (unlabeled)", "A timer was found but its Kagune / Quinque title was not")
    pcall(function() GenericRow.Visible = false end)

    local DebugRow = TimerForm:Row()
    DebugRow:Left():TitleStack({
        Title = "Debug: Copy Timer Info",
        Subtitle = "Open the shop first. For bug reports."
    })

    ---------------------------------------------------------
    -- 2) Auto Buy Weapon : Ghoul (Kagune) และ CCG (Quinque)
    ---------------------------------------------------------
    BuildQueue({
        Title = "🛒 Auto Buy Kagune",
        Subtitle = "Tick what you want. Each one is bought once when the shop has it and you can afford it - then remembered.",
        ToggleTitle = "Enable Auto Buy",
        ToggleSubtitle = "Never buys the same weapon twice. Not in stock / not enough materials or money = waits and retries.",
        PickTitle = "Kagune",
        DelayTitle = "Buy Delay",
        StatusTitle = "📊 Kagune Status",
        OrderTitle = "🧾 Kagune Buy Order",
        Verb = "Buying", DoneWord = "Bought",
        Items = GHOUL_WEAPONS, Cfg = CraftingCfg.GhoulWeapons, OnKey = "AutoBuy", LiveKey = "KaguneBuy",
        DelayMin = 1, DelayMax = 60, DelayDefault = 1,
        AllowRetry = true, Repeat = false, Persist = true,
        Act = MakeBuyAction(KNOWN_GHOUL_SHOP, { [KNOWN_CCG_SHOP] = true, [KNOWN_MASK_SHOP] = true }),
    })

    BuildQueue({
        Title = "🛒 Auto Buy Quinque",
        Subtitle = "Tick what you want. Each one is bought once when the shop has it and you can afford it - then remembered.",
        ToggleTitle = "Enable Auto Buy",
        ToggleSubtitle = "Never buys the same weapon twice. Not in stock / not enough materials or money = waits and retries.",
        PickTitle = "Quinque",
        DelayTitle = "Buy Delay",
        StatusTitle = "📊 Quinque Status",
        OrderTitle = "🧾 Quinque Buy Order",
        Verb = "Buying", DoneWord = "Bought",
        Items = CCG_WEAPONS, Cfg = CraftingCfg.CCGWeapons, OnKey = "AutoBuy", LiveKey = "QuinqueBuy",
        DelayMin = 1, DelayMax = 60, DelayDefault = 1,
        AllowRetry = true, Repeat = false, Persist = true,
        Act = MakeBuyAction(KNOWN_CCG_SHOP, { [KNOWN_GHOUL_SHOP] = true, [KNOWN_MASK_SHOP] = true }),
    })

    ---------------------------------------------------------
    -- 3) Auto Craft (Ghoul)
    ---------------------------------------------------------
    BuildQueue({
        Title = "🔨 Auto Craft (Ghoul)",
        Subtitle = "Crafts the ticked items in a loop. Needs materials. CCG not supported yet.",
        ToggleTitle = "Enable Auto Craft",
        ToggleSubtitle = "Loops until you turn it off.",
        PickTitle = "Craft Items",
        DelayTitle = "Craft Delay",
        StatusTitle = "📊 Craft Status",
        OrderTitle = "🧾 Craft Order",
        Verb = "Crafting", DoneWord = "Crafted",
        Items = CRAFT_ITEMS, Cfg = CraftingCfg.Craft, OnKey = "AutoCraft", LiveKey = "Craft",
        DelayMin = 1, DelayMax = 300, DelayDefault = 5,
        AllowRetry = false, Repeat = true,
        Act = function(name)
            local bridge = ReplicatedStorage:FindFirstChild("BridgeNet2")
            local remote = bridge and bridge:FindFirstChild("dataRemoteEvent")
            if not remote then return nil, "BridgeNet2.dataRemoteEvent not found" end
            local key = CRAFT_KEYS[name]
            if not key then return nil, "No craft key for " .. tostring(name) end
            local ok, err = pcall(function()
                remote:FireServer({ { "\x01", key, name }, "\x17" })
            end)
            if not ok then return "failed", tostring(err) end
            return "sent", "request sent"
        end,
    })

    ---------------------------------------------------------
    -- 4) NPC Check
    ---------------------------------------------------------
    local NpcSection = CraftingTab:PageSection({
        Title = "🧭 NPC Check",
        Subtitle = "Distance to the crafting and weapon NPCs."
    })
    local NpcForm = NpcSection:Form()

    local NPCS = {
        { Title = "Ghoul - Crafting", Folder = "GHOUL", Name = "Crafting" },
        { Title = "Ghoul - Weapon (Kagune)", Folder = "GHOUL", Name = "Weapon" },
        { Title = "CCG - Workshop", Folder = "CCG", Name = "Workshop" },
        { Title = "CCG - Weapon (Quinque)", Folder = "CCG", Name = "Weapon" },
    }
    for _, npc in ipairs(NPCS) do
        local row = NpcForm:Row()
        row:Left():Label({ Text = npc.Title })
        npc.Label = row:Right():Label({ Text = "-" })
    end

    ---------------------------------------------------------
    -- ลูปอ่านเวลา Weapon Shop + นับถอยหลัง
    ---------------------------------------------------------
    -- "00h:39m:25s" -> วินาที
    local function ParseTimer(text)
        local h, m, s = string.match(Clean(text), "^(%d+)%s*h%s*:%s*(%d+)%s*m%s*:%s*(%d+)%s*s$")
        if not h then return nil end
        return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
    end

    local TITLES = { kagune = "Kagune", quinque = "Quinque" }

    -- หาชื่อร้าน (Kagune / Quinque) ที่อยู่ใกล้ ๆ ป้ายเวลา โดยไล่ขึ้นไปหา Frame แม่ทีละชั้น
    local function FindTitleFor(timerLabel)
        local node = timerLabel.Parent
        for _ = 1, 6 do
            if not node or node == PlayerGui then break end
            for _, d in ipairs(node:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    local key = TITLES[string.lower(Clean(d.Text))]
                    if key and IsShown(d) then return key end
                end
            end
            node = node.Parent
        end
        return nil
    end

    -- สแกนหาป้ายเวลาที่กำลังแสดงอยู่ { Kagune = วินาที, Quinque = วินาที, Weapon = วินาที(ไม่รู้ชื่อร้าน) }
    local function ScanTimers()
        local found = {}
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            if d:IsA("TextLabel") and #d.Text <= 40 then
                local secs = ParseTimer(d.Text)
                if secs and IsShown(d) then
                    found[FindTitleFor(d) or "Weapon"] = secs
                end
            end
        end
        return found
    end

    local expiry = {}   -- expiry[ร้าน] = เวลา (os.clock) ที่ร้านจะรีเฟรช
    local lastLive = {} -- ครั้งล่าสุดที่เห็นป้ายเวลาในหน้าจอจริง

    local function Describe(key)
        local at = expiry[key]
        if not at then
            return Paint("Open the shop once to read it", "#96A5AA")
        end
        local left = at - os.clock()
        if left <= 0 then
            return Paint("Refreshed - open the shop to update", "#FFB432")
        end
        local live = lastLive[key] and os.clock() - lastLive[key] < 4
        local hex = left <= 60 and "#EB4646" or (left <= 300 and "#FFB432" or "#28DC64")
        return Paint(FormatTime(left), hex) .. (live and "  (live)" or "  (estimated)")
    end

    task.spawn(function()
        local lastScan = 0
        while Alive() do
            task.wait(0.5)

            if os.clock() - lastScan >= 1.5 then
                lastScan = os.clock()
                local ok, found = pcall(ScanTimers)
                if ok then
                    for key, secs in pairs(found) do
                        expiry[key] = os.clock() + secs
                        lastLive[key] = os.clock()
                    end
                end
            end

            SetText(KaguneLabel, Describe("Kagune"))
            SetText(QuinqueLabel, Describe("Quinque"))
            if expiry.Weapon then
                pcall(function() GenericRow.Visible = true end)
                SetText(GenericLabel, Describe("Weapon"))
            end
        end
    end)

    ---------------------------------------------------------
    -- ลูปเช็ก NPC
    ---------------------------------------------------------
    local function PosOf(obj)
        if obj:IsA("Model") then return obj:GetPivot().Position end
        if obj:IsA("BasePart") then return obj.Position end
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end

    task.spawn(function()
        while Alive() do
            local talk = Workspace:FindFirstChild("TalkNpc")
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            for _, npc in ipairs(NPCS) do
                local folder = talk and talk:FindFirstChild(npc.Folder)
                local obj = folder and folder:FindFirstChild(npc.Name)
                local text
                if not obj then
                    text = Paint("Not found", "#EB4646")
                else
                    local pos = PosOf(obj)
                    if pos and root then
                        text = Paint(string.format("Found - %d studs away", math.floor((pos - root.Position).Magnitude)), "#28DC64")
                    else
                        text = Paint("Found", "#28DC64")
                    end
                end
                SetText(npc.Label, text)
            end
            task.wait(2)
        end
    end)

    ---------------------------------------------------------
    -- ปุ่ม Copy Timer Info (ไว้ส่งให้ผมแก้สคริปต์ถ้าอ่านเวลาไม่ได้)
    ---------------------------------------------------------
    DebugRow:Right():Button({
        Label = "Copy",
        Callback = function()
            local lines = {}
            for _, d in ipairs(PlayerGui:GetDescendants()) do
                if d:IsA("TextLabel") and #d.Text <= 40 then
                    local secs = ParseTimer(d.Text)
                    if secs then
                        table.insert(lines, string.format(
                            "%s | text=%q | shown=%s | title=%s",
                            d:GetFullName(), d.Text, tostring(IsShown(d)), tostring(FindTitleFor(d))
                        ))
                    end
                end
            end
            local text = #lines > 0 and table.concat(lines, "\n") or "No timer label like 00h:00m:00s found in PlayerGui"
            print("[Smooth Hub] Timer info:\n" .. text)
            pcall(function() if setclipboard then setclipboard(text) end end)
        end
    })
end

---------------------------------------------------------
-- หมวดหมู่ Equipment > แท็บ Auto Equip Best
-- สวมของที่ดีที่สุดในกระเป๋า (Hat / Face / Aura / Accessory) ตามสายที่เลือก
-- (Damage / Defense / Speed / Stamina / Balanced)
--
-- วางต่อจากแท็บ PVP ก่อนบรรทัด  -- หมวดหมู่ Information
-- ต้องเพิ่ม Default ใน _G.SmoothHubConfig ด้วย (ดูไฟล์ Equip_Config_Snippet.lua)
--
-- วิธีวัดว่าชิ้นไหนดีที่สุด :
--   ช่องของในกระเป๋าไม่ได้โชว์ค่าสเตตัสของแต่ละชิ้น แต่แผง Equipment ด้านขวาโชว์ "ค่ารวม"
--   (Damage / Durability / Stamina / Speed) ของที่สวมอยู่ เลยลองสวมทีละชิ้นในประเภทเดียวกัน
--   อ่านค่ารวมที่เปลี่ยนไป แล้วเลือกชิ้นที่ได้ค่าสายที่เลือกสูงสุด
--   (ทำครั้งเดียวต่อชุดของในกระเป๋า ถ้าของไม่เปลี่ยนจะไม่วัดซ้ำ)
---------------------------------------------------------
do
    local Players = game:GetService("Players")
    local GuiService = game:GetService("GuiService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local token = {}
    _G.SmoothHubEquipToken = token
    local function Alive() return _G.SmoothHubEquipToken == token end

    local EQ = _G.SmoothHubConfig.Equip
    EQ.Interval = math.clamp(tonumber(EQ.Interval) or 30, 10, 600)
    if type(EQ.Types) ~= "table" then EQ.Types = {} end
    for _, ty in ipairs({ "Hat", "Face", "Aura", "Accessory", "Cape" }) do
        if EQ.Types[ty] == nil then EQ.Types[ty] = true end
    end
    if EQ.AutoTypes == nil then EQ.AutoTypes = true end
    if EQ.TryUnknown == nil then EQ.TryUnknown = false end
    if EQ.ReEquipOnRespawn == nil then EQ.ReEquipOnRespawn = false end

    local TYPE_ORDER = { "Hat", "Face", "Aura", "Accessory", "Cape" } -- ประเภทหลักที่มีสวิตช์ให้เปิดปิด

    -- ประเภทอื่นที่สคริปต์รู้ว่า "สวมได้" (ตรวจเจอในกระเป๋าแล้วจะสวมให้เองถ้าเปิด Auto-detect)
    local KNOWN_GEAR = {}
    for _, n in ipairs({ "hat", "face", "aura", "accessory", "cape", "cloak", "back", "wings", "wing", "mask",
        "glove", "gloves", "shoes", "boots", "armor", "body", "shirt", "pants", "head", "neck", "necklace",
        "ring", "belt", "scarf", "tail", "ears", "eyes", "mouth" }) do KNOWN_GEAR[n] = true end

    -- ประเภทที่ห้ามแตะเด็ดขาด (กดแล้วอาจใช้/ทิ้งของ)
    local NEVER_TOUCH = {}
    for _, n in ipairs({ "material", "consumable", "potion", "food", "item", "key", "chest", "box", "crate",
        "currency", "quest", "fragment", "ticket", "scroll", "gem", "drop", "misc" }) do NEVER_TOUCH[n] = true end
    local STATS = { "Damage", "Durability", "Stamina", "Speed" }

    local FOCUS_OPTIONS = { "Damage", "Defense (Durability)", "Speed", "Stamina", "Balanced (All)" }
    local FOCUS_KEY = {
        ["Damage"] = "Damage",
        ["Defense (Durability)"] = "Durability",
        ["Speed"] = "Speed",
        ["Stamina"] = "Stamina",
    }
    if not table.find(FOCUS_OPTIONS, EQ.Focus) then EQ.Focus = "Damage" end

    ---------------------------------------------------------
    -- หมวดหมู่ใหม่ : Equipment
    ---------------------------------------------------------
    local EquipSection = Cascade.Components.Section(Window, {
        Title = "Equipment",
        Disclosure = false
    })
    local EquipTab = EquipSection:Tab({
        Title = "Auto Equip Best",
        Icon = Cascade.Symbols["starFill"] or Cascade.Symbols["bagFill"] or Cascade.Symbols["leafFill"]
    })

    local forceRun = false

    ---------------------------------------------------------
    -- UI
    ---------------------------------------------------------
    local MainSection = EquipTab:PageSection({
        Title = "🎒 Auto Equip Best",
        Subtitle = "Equips the best gear for your build."
    })
    local Form = MainSection:Form()

    local FocusRow = Form:Row()
    FocusRow:Left():TitleStack({
        Title = "Build Focus",
        Subtitle = "Best gear for that stat. Balanced = best overall."
    })
    FocusRow:Right():PullDownButton({
        Label = EQ.Focus,
        Options = FOCUS_OPTIONS,
        Value = SettingsStore.IndexOf(FOCUS_OPTIONS, EQ.Focus, 1),
        ValueChanged = function(self, index)
            EQ.Focus = FOCUS_OPTIONS[index] or "Damage"
            self.Label = EQ.Focus
        end
    })

    local RunRow = Form:Row()
    RunRow:Left():TitleStack({
        Title = "Equip Now",
        Subtitle = "Opens your inventory and equips the best gear."
    })
    RunRow:Right():Button({
        Label = "Equip",
        Callback = function() forceRun = true end
    })

    local AutoRow = Form:Row()
    AutoRow:Left():TitleStack({
        Title = "Keep Checking",
        Subtitle = "Re-equips when you get new gear."
    })
    AutoRow:Right():Toggle({
        Value = EQ.Enabled,
        ValueChanged = function(self, v)
            EQ.Enabled = v and true or false
            if EQ.Enabled then forceRun = true end
        end
    })

    local IntervalRow = Form:Row()
    IntervalRow:Left():TitleStack({ Title = "Check Every (sec)", Subtitle = "How often to check your inventory." })
    IntervalRow:Right():Stepper({
        Minimum = 10, Maximum = 600, Step = 10, Fielded = true,
        Value = EQ.Interval,
        ValueChanged = function(self, v) EQ.Interval = math.clamp(tonumber(v) or 30, 10, 600) end
    })

    local RespawnRow = Form:Row()
    RespawnRow:Left():TitleStack({ Title = "Run After Respawn", Subtitle = "Runs again when you respawn." })
    RespawnRow:Right():Toggle({
        Value = EQ.ReEquipOnRespawn,
        ValueChanged = function(self, v) EQ.ReEquipOnRespawn = v and true or false end
    })

    local TypeSection = EquipTab:PageSection({
        Title = "🧩 What To Equip",
        Subtitle = "Gear types the script may change."
    })
    local TypeForm = TypeSection:Form()
    for _, ty in ipairs(TYPE_ORDER) do
        local row = TypeForm:Row()
        row:Left():TitleStack({ Title = ty, Subtitle = "Equip the best " .. ty .. " item." })
        row:Right():Toggle({
            Value = EQ.Types[ty],
            ValueChanged = function(self, v) EQ.Types[ty] = v and true or false end
        })
    end

    local AutoTypeRow = TypeForm:Row()
    AutoTypeRow:Left():TitleStack({
        Title = "Auto-detect Other Gear",
        Subtitle = "Also equips other wearables (Wings, Gloves, Armor...)."
    })
    AutoTypeRow:Right():Toggle({
        Value = EQ.AutoTypes,
        ValueChanged = function(self, v) EQ.AutoTypes = v and true or false end
    })

    local TryUnknownRow = TypeForm:Row()
    TryUnknownRow:Left():TitleStack({
        Title = "Try Unknown Types (risky)",
        Subtitle = "Clicks unknown item types. May use up items - leave off."
    })
    TryUnknownRow:Right():Toggle({
        Value = EQ.TryUnknown,
        ValueChanged = function(self, v) EQ.TryUnknown = v and true or false end
    })

    local StatusSection = EquipTab:PageSection({
        Title = "📊 Status",
        Subtitle = "What it is doing now."
    })
    local StatusForm = StatusSection:Form()
    local function AddInfoRow(title, text)
        local row = StatusForm:Row()
        row:Left():Label({ Text = title })
        return row:Right():Label({ Text = text })
    end
    local StatusLabel = AddInfoRow("Status", "Idle")
    local ItemsLabel = AddInfoRow("Gear Found", "-")
    local StatsLabel = AddInfoRow("Total Stats", "-")
    local ResultLabel = AddInfoRow("Last Result", "-")

    local shown = setmetatable({}, { __mode = "k" })
    local function SetText(label, text)
        local liveKey = _G.SmoothHubLiveKeys[label]
        if liveKey then _G.SmoothHubLive[liveKey] = text end
        if shown[label] == text then return end
        shown[label] = text
        pcall(function() label.Text = text end)
    end
    _G.SmoothHubLiveKeys[StatusLabel] = "Equip"

    ---------------------------------------------------------
    -- ตัวช่วยกด / อ่านหน้าจอ
    ---------------------------------------------------------
    local function Clean(s)
        s = string.gsub(tostring(s or ""), "<[^>]+>", "")
        return (string.match(s, "^%s*(.-)%s*$"))
    end

    local function IsShown(obj)
        local cur = obj
        while cur do
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            if cur:IsA("ScreenGui") and not cur.Enabled then return false end
            cur = cur.Parent
        end
        return true
    end

    local function WaitFor(check, timeout)
        local t0 = os.clock()
        while Alive() and os.clock() - t0 < timeout do
            if check() then return true end
            task.wait(0.1)
        end
        return check() and true or false
    end

    local function GetClickable(obj)
        local cur = obj
        while cur and cur ~= PlayerGui do
            if cur:IsA("GuiButton") then return cur end
            cur = cur.Parent
        end
        return obj
    end

    local function ClickSignal(btn)
        if not btn:IsA("GuiButton") then return false end
        if getconnections then
            for _, sig in ipairs({ "MouseButton1Click", "Activated" }) do
                local ok, conns = pcall(getconnections, btn[sig])
                if ok and conns and #conns > 0 then
                    for _, c in ipairs(conns) do pcall(function() c:Fire() end) end
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

    local function ClickMouse(obj)
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

    -- กด 1 ครั้งด้วยวิธีแรก รอเช็กผล ถ้าไม่สำเร็จค่อยคลิกเมาส์ (กันกดซ้ำจนสลับสวม/ถอด)
    local function ClickUntil(obj, check, wait)
        check = check or function() return true end
        wait = wait or 1
        local btn = GetClickable(obj)
        if ClickSignal(btn) and WaitFor(check, wait) then return true end
        if not btn.Parent then return check() end
        if check() then return true end
        ClickMouse(btn)
        return WaitFor(check, wait)
    end

    ---------------------------------------------------------
    -- หน้า Inventory  (PlayerGui.Menu.MenuFrames.Inventory  /  ปุ่มเปิด = Menu.Container.Inventory)
    ---------------------------------------------------------
    local function GetMenuGui() return PlayerGui:FindFirstChild("Menu") end

    local function FindInventoryScope()
        local menu = GetMenuGui()
        if not menu then return nil end
        local frames = menu:FindFirstChild("MenuFrames")
        local inv = frames and frames:FindFirstChild("Inventory")
        if inv then return inv end
        for _, d in ipairs(menu:GetDescendants()) do
            if d.Name == "Inventory" and not d:IsA("GuiButton") and d:IsA("GuiObject") then
                return d
            end
        end
        return nil
    end

    local function FindInventoryButton()
        local menu = GetMenuGui()
        local container = menu and menu:FindFirstChild("Container")
        local b = container and container:FindFirstChild("Inventory")
        if b and b:IsA("GuiButton") then return b end
        if menu then
            for _, d in ipairs(menu:GetDescendants()) do
                if d.Name == "Inventory" and d:IsA("GuiButton") then return d end
            end
        end
        return nil
    end

    local openedByUs = false
    local function OpenInventory()
        local scope = FindInventoryScope()
        if scope and IsShown(scope) then return true end
        local btn = FindInventoryButton()
        if not btn then return false end
        openedByUs = true
        ClickUntil(btn, function()
            local s = FindInventoryScope()
            return s ~= nil and IsShown(s)
        end, 1.5)
        local s = FindInventoryScope()
        return s ~= nil and IsShown(s)
    end

    local function CloseInventory()
        if not openedByUs then return end
        openedByUs = false
        local scope = FindInventoryScope()
        if not scope or not IsShown(scope) then return end
        -- ปุ่ม X มุมขวาบนของหน้าต่าง Inventory
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("GuiButton") and IsShown(d) then
                local isClose = string.lower(d.Name) == "close"
                if not isClose then
                    local t = string.lower(Clean(d:IsA("TextButton") and d.Text or ""))
                    if t == "" then
                        for _, c in ipairs(d:GetChildren()) do
                            if c:IsA("TextLabel") then t = string.lower(Clean(c.Text)) end
                        end
                    end
                    isClose = (t == "x" or t == "close")
                end
                if isClose then
                    ClickUntil(d, function() return not IsShown(scope) end, 1)
                    if not IsShown(scope) then return end
                end
            end
        end
        local btn = FindInventoryButton()
        if btn then ClickUntil(btn, function() return not IsShown(scope) end, 1) end
    end

    ---------------------------------------------------------
    -- อ่านช่องของ : ประเภทดูจากข้อความ "(Face)" "(Hat)" ฯลฯ ในช่อง
    -- ตัวเอ "E" สีเขียวมุมซ้ายบน = กำลังสวมอยู่
    ---------------------------------------------------------
    local function SlotRootOf(label, scope)
        local cur = label.Parent
        local best = nil
        while cur and cur ~= scope do
            if cur:IsA("GuiButton") then return cur end
            best = best or cur
            cur = cur.Parent
        end
        return best or label.Parent
    end

    local function IconImageOf(slot)
        local bestArea, bestImg = -1, ""
        for _, d in ipairs(slot:GetDescendants()) do
            if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and d.Image ~= "" then
                local a = d.AbsoluteSize.X * d.AbsoluteSize.Y
                if a > bestArea then bestArea, bestImg = a, d.Image end
            end
        end
        return bestImg
    end

    local function IsEquipped(slot)
        for _, d in ipairs(slot:GetDescendants()) do
            if d:IsA("TextLabel") and IsShown(d) and Clean(d.Text) == "E" then return true end
        end
        return false
    end

    local function ScanSlots()
        local scope = FindInventoryScope()
        local list = {}
        if not scope then return list, scope end
        local seen = {}
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("TextLabel") then
                local ty = string.match(Clean(d.Text), "^%((%a+)%)$")
                if ty then
                    local slot = SlotRootOf(d, scope)
                    if slot and not seen[slot] then
                        seen[slot] = true
                        list[#list + 1] = {
                            slot = slot,
                            type = ty,
                            key = slot.Name .. "|" .. IconImageOf(slot),
                        }
                    end
                end
            end
        end
        return list, scope
    end

    -- อ่านค่ารวมจากแผง Equipment ("Damage +18" ฯลฯ)
    local function ReadTotals()
        local scope = FindInventoryScope()
        if not scope then return nil end
        local totals, count = {}, 0
        for _, d in ipairs(scope:GetDescendants()) do
            if d:IsA("TextLabel") and IsShown(d) then
                local name, num = string.match(Clean(d.Text), "^(%a+)%s*([%+%-]?%d+%.?%d*)%%?$")
                if name and num then
                    for _, s in ipairs(STATS) do
                        if string.lower(s) == string.lower(name) and totals[s] == nil then
                            totals[s] = tonumber(num) or 0
                            count += 1
                        end
                    end
                end
            end
        end
        if count == 0 then return nil end
        for _, s in ipairs(STATS) do totals[s] = totals[s] or 0 end
        return totals
    end

    local function StatsText(t)
        if not t then return "-" end
        return string.format("DMG %s | DEF %s | STA %s | SPD %s",
            tostring(t.Damage), tostring(t.Durability), tostring(t.Stamina), tostring(t.Speed))
    end

    local function SameTotals(a, b)
        if not a or not b then return false end
        for _, s in ipairs(STATS) do if a[s] ~= b[s] then return false end end
        return true
    end

    local function Score(t)
        if not t then return -math.huge end
        local key = FOCUS_KEY[EQ.Focus]
        local sum = 0
        for _, s in ipairs(STATS) do sum += t[s] end
        if not key then return sum end            -- Balanced
        return t[key] * 1000 + sum * 0.001        -- สายที่เลือกมาก่อน ค่ารวมเป็นตัวตัดสินเสมอ
    end

    local function FindEquipButton()
        local scope = FindInventoryScope()
        if not scope then return nil end
        for _, d in ipairs(scope:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("TextLabel")) and IsShown(d) then
                local t = string.lower(Clean(d.Text))
                if t == "equip" then return d end
            end
        end
        return nil
    end

    -- สวมชิ้นนี้ (ถ้าสวมอยู่แล้วไม่กดซ้ำ เพราะกดซ้ำอาจเป็นการถอด)
    local function EquipSlot(entry)
        if not entry.slot.Parent then return false end
        if IsEquipped(entry.slot) then return true end
        ClickUntil(entry.slot, function() return IsEquipped(entry.slot) end, 1.2)
        if IsEquipped(entry.slot) then return true end
        local btn = FindEquipButton()
        if btn then
            ClickUntil(btn, function() return IsEquipped(entry.slot) end, 1.2)
        end
        return IsEquipped(entry.slot)
    end

    -- รอให้ค่ารวมเปลี่ยนจาก prev (สูงสุด 1.2 วิ) แล้วคืนค่ารวมล่าสุด
    local function ReadTotalsSettled(prev)
        local t0 = os.clock()
        local cur = ReadTotals()
        while Alive() and os.clock() - t0 < 1.2 and SameTotals(cur, prev) do
            task.wait(0.15)
            cur = ReadTotals()
        end
        return cur
    end

    ---------------------------------------------------------
    -- Dump
    ---------------------------------------------------------
    local DumpRow = Form:Row()
    DumpRow:Left():TitleStack({
        Title = "Debug: Dump Inventory",
        Subtitle = "Open your inventory first. Prints to the console (F9) for bug reports."
    })
    DumpRow:Right():Button({
        Label = "Dump",
        Callback = function()
            local slots, scope = ScanSlots()
            print("[Smooth Hub] Inventory scope:", scope and scope:GetFullName() or "nil",
                "shown =", scope and tostring(IsShown(scope)) or "-")
            for _, e in ipairs(slots) do
                print(string.format("   slot: type=%s equipped=%s class=%s key=%s",
                    e.type, tostring(IsEquipped(e.slot)), e.slot.ClassName, e.key))
            end
            print("   totals:", StatsText(ReadTotals()))
            if scope then
                for _, d in ipairs(scope:GetDescendants()) do
                    if d:IsA("TextButton") or d:IsA("TextLabel") then
                        local t = Clean(d.Text)
                        if t ~= "" and IsShown(d) then
                            print("   text:", t, "|", d.ClassName, "|", d:GetFullName())
                        end
                    end
                end
            end
        end
    })

    ---------------------------------------------------------
    -- ทำงานหลัก
    ---------------------------------------------------------
    local busy = false
    local lastSignature = nil -- ลายเซ็นตอนรันล่าสุด (ไม่เปลี่ยน = ไม่ต้องรันซ้ำในโหมดอัตโนมัติ)

    -- ประเภททั้งหมดที่เจอในกระเป๋า (เรียงเป็นลำดับ: ประเภทหลักก่อน แล้วตามด้วยประเภทอื่นตามตัวอักษร)
    local function DiscoveredTypes(slots)
        local seen, others = {}, {}
        for _, e in ipairs(slots) do
            if not seen[e.type] then
                seen[e.type] = true
                if not table.find(TYPE_ORDER, e.type) then others[#others + 1] = e.type end
            end
        end
        table.sort(others)
        local list = {}
        for _, ty in ipairs(TYPE_ORDER) do if seen[ty] then list[#list + 1] = ty end end
        for _, ty in ipairs(others) do list[#list + 1] = ty end
        return list
    end

    local function TypeHasEquipped(slots, ty)
        for _, e in ipairs(slots) do
            if e.type == ty and IsEquipped(e.slot) then return true end
        end
        return false
    end

    -- ตัดสินว่าประเภทไหน "ควรสวม" : คืน (รายการที่จะทำ, รายการที่ข้าม)
    local function TypesToProcess(slots)
        local todo, skipped = {}, {}
        for _, ty in ipairs(DiscoveredTypes(slots)) do
            local low = string.lower(ty)
            if NEVER_TOUCH[low] then
                -- ไม่แตะ ไม่ต้องรายงาน
            elseif table.find(TYPE_ORDER, ty) then
                if EQ.Types[ty] then todo[#todo + 1] = ty end
            elseif EQ.AutoTypes and (KNOWN_GEAR[low] or TypeHasEquipped(slots, ty)) then
                todo[#todo + 1] = ty
            elseif EQ.AutoTypes and EQ.TryUnknown then
                todo[#todo + 1] = ty
            else
                skipped[#skipped + 1] = ty
            end
        end
        return todo, skipped
    end

    -- ลายเซ็นแบบเบา : สายที่เลือก + จำนวนของแต่ละประเภทที่สวมได้ (อ่านได้แม้เมนูปิดอยู่)
    local function Signature(slots)
        local counts = {}
        for _, e in ipairs(slots) do counts[e.type] = (counts[e.type] or 0) + 1 end
        local parts = { EQ.Focus, tostring(EQ.AutoTypes), tostring(EQ.TryUnknown) }
        for _, ty in ipairs(DiscoveredTypes(slots)) do
            if not NEVER_TOUCH[string.lower(ty)] then
                parts[#parts + 1] = ty .. "=" .. (counts[ty] or 0) .. (EQ.Types[ty] == false and "-" or "+")
            end
        end
        return table.concat(parts, "|")
    end

    local function CountText(slots)
        local counts = {}
        for _, e in ipairs(slots) do counts[e.type] = (counts[e.type] or 0) + 1 end
        local parts = {}
        for _, ty in ipairs(DiscoveredTypes(slots)) do
            parts[#parts + 1] = ty .. " " .. (counts[ty] or 0)
        end
        return table.concat(parts, " | ")
    end

    local function RunBest()
        busy = true
        SetText(StatusLabel, "Opening Inventory...")
        if not OpenInventory() then
            SetText(StatusLabel, "Can't open Inventory (Menu > Container > Inventory not found)")
            busy = false
            return
        end
        task.wait(0.5)

        local slots = ScanSlots()
        SetText(ItemsLabel, CountText(slots))
        if #slots == 0 then
            SetText(StatusLabel, "No items found in Inventory (press Dump and send me the output)")
            CloseInventory()
            busy = false
            return
        end

        local changed, report = 0, {}
        local todo, skipped = TypesToProcess(slots)
        for _, ty in ipairs(todo) do
            do
                local cands = {}
                for _, e in ipairs(slots) do
                    if e.type == ty then cands[#cands + 1] = e end
                end

                if #cands == 0 then
                    -- ไม่มีของประเภทนี้
                elseif #cands == 1 then
                    SetText(StatusLabel, "Equipping " .. ty .. "...")
                    local wasOn = IsEquipped(cands[1].slot)
                    if EquipSlot(cands[1]) and not wasOn then changed += 1 end
                else
                    -- ลองสวมทีละชิ้น อ่านค่ารวม แล้วเลือกชิ้นที่คะแนนสายที่เลือกสูงสุด
                    local best, bestScore, prev = nil, -math.huge, ReadTotals()
                    for i, e in ipairs(cands) do
                        SetText(StatusLabel, string.format("Testing %s %d/%d...", ty, i, #cands))
                        if EquipSlot(e) then
                            local t = ReadTotalsSettled(prev)
                            prev = t
                            SetText(StatsLabel, StatsText(t))
                            local sc = Score(t)
                            if sc > bestScore then best, bestScore = e, sc end
                        end
                        task.wait(0.15)
                    end
                    if best then
                        SetText(StatusLabel, "Equipping best " .. ty .. "...")
                        local ok = EquipSlot(best)
                        task.wait(0.3)
                        if ok then
                            changed += 1
                            report[#report + 1] = ty
                        end
                    end
                end
            end
        end

        SetText(StatsLabel, StatsText(ReadTotals()))
        lastSignature = Signature(slots)
        SetText(StatusLabel, "Done")
        local resultText = string.format("%s | focus: %s | types: %s", os.date("%H:%M:%S"), EQ.Focus,
            #todo > 0 and table.concat(todo, ", ") or "none")
        if #skipped > 0 then
            resultText = resultText .. " | skipped (unknown): " .. table.concat(skipped, ", ")
        end
        SetText(ResultLabel, resultText)
        task.wait(0.3)
        CloseInventory()
        busy = false
    end

    LocalPlayer.CharacterAdded:Connect(function()
        if EQ.ReEquipOnRespawn then forceRun = true end
    end)

    local lastCheck = 0
    task.spawn(function()
        while Alive() do
            task.wait(0.5)
            if not busy then
                if forceRun then
                    forceRun = false
                    lastCheck = os.clock()
                    local ok, err = pcall(RunBest)
                    if not ok then
                        busy = false
                        SetText(StatusLabel, "Error: " .. tostring(err))
                    end
                elseif EQ.Enabled and os.clock() - lastCheck >= EQ.Interval then
                    lastCheck = os.clock()
                    -- โหมดอัตโนมัติ : แอบดูโดยไม่เปิดเมนู ถ้าของเปลี่ยนค่อยรันจริง
                    local slots = ScanSlots()
                    if #slots > 0 then
                        SetText(ItemsLabel, CountText(slots))
                        if Signature(slots) ~= lastSignature then forceRun = true end
                    elseif lastSignature == nil then
                        forceRun = true -- ยังไม่เคยรันเลย
                    end
                end
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

        local tabs = {StatusTab, MainFarmTab, MonsterTab, BossTab, BossWorldTab, ShopTab, DropTab, AdvancedTab, ServerTab, SettingsTab}
        if _G.SmoothHubBlackMarketTab then table.insert(tabs, _G.SmoothHubBlackMarketTab) end
        if _G.SmoothHubDungeonTab then table.insert(tabs, _G.SmoothHubDungeonTab) end
        if _G.SmoothHubCraftingTab then table.insert(tabs, _G.SmoothHubCraftingTab) end
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
    Subtitle = "Press to hide or show the window (default: B)."
})

local currentKeybind = Enum.KeyCode.B -- ค่าเริ่มต้น = ปุ่ม B
-- ถ้าไฟล์เซฟเป็นค่าเริ่มต้นเก่า (LeftAlt) ให้เปลี่ยนเป็น B ให้เลย / ถ้าผู้ใช้ตั้งปุ่มอื่นเองไว้ จะคงปุ่มนั้น
if type(SavedUi.Keybind) == "string" and SavedUi.Keybind ~= "LeftAlt" then
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
            Keybind = currentKeybind and currentKeybind.Name or "B",
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
            if _G.SmoothHubArb.FarmOn("EnableFarmMonster") then
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
            if _G.SmoothHubArb.FarmOn("EnableFarmMonster") then
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
            if _G.SmoothHubArb.FarmOn("EnableFarmMonster") and character then
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
            if not _G.SmoothHubArb.FarmOn("EnableFarmMonster") then continue end
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
            
                while (not HasActiveQuest() or not IsActiveQuestCorrect()) and isPlayerReadyToFarm and _G.SmoothHubArb.FarmOn("EnableFarmMonster") and not _G.SmoothHubBossActive do
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
            if not _G.SmoothHubArb.FarmOn("EnableFarmMonster") then continue end
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
            if not _G.SmoothHubArb.FarmOn("EnableFarmMonster") then break end
            pressE()
            if i < 5 then
                task.wait(0.5)
            end
        end
    end

    task.spawn(function()
        while true do
            if not _G.SmoothHubArb.FarmOn("EnableFarmMonster") then
                task.wait(0.5)
                continue
            end

            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
        
            task.wait(1)
            if _G.SmoothHubArb.FarmOn("EnableFarmMonster") then
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
        
            while isAlive and character.Parent and _G.SmoothHubArb.FarmOn("EnableFarmMonster") do
                task.wait(1)
            end
        end
    end)

    -- ระบบอัปเดต Status บน UI
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                if not _G.SmoothHubArb.FarmOn("EnableFarmMonster") then
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
            if _G.SmoothHubArb.FarmOn("EnableFarmBoss") then
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

            if not _G.SmoothHubArb.FarmOn("EnableFarmBoss") or not isPlayerReadyToFarm then
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
            if _G.SmoothHubArb.FarmOn("EnableFarmBoss") and character then
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
            if not _G.SmoothHubArb.FarmOn("EnableFarmBoss") then
                task.wait(0.5)
                continue
            end

            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")

            task.wait(1)
            for i = 1, 5 do
                if not _G.SmoothHubArb.FarmOn("EnableFarmBoss") then break end
                pressE()
                task.wait(0.5)
            end

            local isAlive = true
            local diedConnection
            diedConnection = humanoid.Died:Connect(function()
                isAlive = false
                if diedConnection then diedConnection:Disconnect() end
            end)

            while isAlive and character.Parent and _G.SmoothHubArb.FarmOn("EnableFarmBoss") do
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

                if not _G.SmoothHubArb.FarmOn("EnableFarmBoss") then
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
            if not _G.SmoothHubArb.FarmOn("AutoFarmLevel") then
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
            if _G.SmoothHubArb.FarmOn("AutoFarmLevel") then
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
            if _G.SmoothHubArb.FarmOn("AutoFarmLevel") then
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
            if not _G.SmoothHubArb.FarmOn("AutoFarmLevel") then continue end
            if not isPlayerReadyToFarm then continue end
            if _G.SmoothHubYieldToItems and _G.SmoothHubYieldToItems() then continue end -- รอ Chest / Quest Board ทำงานก่อน

            if HasActiveQuest() and not IsActiveQuestCorrect() then
                AbandonCurrentQuest()
                currentTarget = nil
                task.wait(0.8)
            end

            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if rootPart and (not HasActiveQuest() or not IsActiveQuestCorrect()) and not isDoingQuest then
                isDoingQuest = true

                while (not HasActiveQuest() or not IsActiveQuestCorrect()) and isPlayerReadyToFarm and _G.SmoothHubArb.FarmOn("AutoFarmLevel") do
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
            if not _G.SmoothHubArb.FarmOn("AutoFarmLevel") then continue end

            if not isPlayerReadyToFarm then
                continue
            end
            if _G.SmoothHubYieldToItems and _G.SmoothHubYieldToItems() then continue end -- รอ Chest / Quest Board ทำงานก่อน

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
            if not _G.SmoothHubArb.FarmOn("AutoFarmLevel") then break end
            pressE()
            if i < 5 then
                task.wait(0.5)
            end
        end
    end

    task.spawn(function()
        while true do
            if not _G.SmoothHubArb.FarmOn("AutoFarmLevel") then
                task.wait(0.5)
                continue
            end

            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")

            task.wait(1)
            if _G.SmoothHubArb.FarmOn("AutoFarmLevel") then
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

            while isAlive and character.Parent and _G.SmoothHubArb.FarmOn("AutoFarmLevel") do
                task.wait(1)
            end
        end
    end)

    -- ระบบอัปเดต Status ส่งตรงไปที่หน้าจอ UI (_G.SmoothHubStatus.FarmStatusLabel)
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                if not _G.SmoothHubArb.FarmOn("AutoFarmLevel") then
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
                    if _G.SmoothHubYieldToItems and _G.SmoothHubYieldToItems() then
                        _G.SmoothHubStatus.FarmStatusLabel.Text = "Mimic chest first..."
                    elseif not HasActiveQuest() or not IsActiveQuestCorrect() then
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
