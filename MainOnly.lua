---------------------------------------------------------
-- Smooth Hub : Main (Key System)
-- เช็กว่าอยู่แมพไหน > ขอคีย์ > เซิร์ฟเวอร์เช็กคีย์ > ส่งสคริปต์ของแมพนั้นมาให้
---------------------------------------------------------
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------
-- ⚙️ ตั้งค่าตรงนี้
---------------------------------------------------------
local CONFIG = {
    -- ลิงก์ Worker ของคุณ (ไม่ต้องมี / ท้ายลิงก์)
    ApiUrl = "https://smoothhub-key-server.xenonhub67.workers.dev",
    -- ลิงก์ซื้อคีย์พรีเมียม (เช่น Discord หรือหน้าร้าน)
    BuyUrl = "https://discord.gg/YOUR-INVITE",
    -- ลิงก์รับคีย์ฟรี (ผ่านโฆษณา) = ลิงก์ Worker + /free/start (ไม่ต้องแก้ ใช้ ApiUrl ด้านบน)
    FreeKeyPath = "/", -- หน้าแรกของ Worker (เลือกวิธีรับคีย์) Worker ปัจจุบันไม่มี /free/start
    -- ไฟล์ที่จำคีย์ไว้ (ไม่ต้องกรอกใหม่ทุกครั้ง)
    -- ใช้ชื่อเดียวกันในทุกสคริปต์ของ Smooth Hub: คีย์เดียวใช้ได้ทุกสคริปต์ กรอกครั้งเดียวทุกสคริปต์จะจำให้
    KeyFile = "SmoothHub_key.txt",
    -- แมพที่รองรับ (ต้องตรงกับ MAPS ใน Worker)
    Maps = {
        [71793674075007] = "Kanom Tokyo | โลกปกติ",
        [123949707464677] = "Kanom Tokyo | Boss Map",
        -- [PLACE_ID_แมพ_Raid] = "Kanom Tokyo | Raid",
    },
}

---------------------------------------------------------
-- 🚀 ส่วนทำงาน (ไม่ต้องแก้)
---------------------------------------------------------
local MapName = CONFIG.Maps[game.PlaceId]
if not MapName then
    LocalPlayer:Kick("สคริปต์นี้ใช้ได้เฉพาะ Map | Kanom Tokyo")
    return
end

-- ส่งคำขอไปเซิร์ฟเวอร์ คืน (statusCode, body)
local function Http(path, params)
    local parts = {}
    for k, v in pairs(params) do
        parts[#parts + 1] = k .. "=" .. HttpService:UrlEncode(tostring(v))
    end
    local url = CONFIG.ApiUrl .. path .. "?" .. table.concat(parts, "&")

    local requestFn = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
    if requestFn then
        local ok, res = pcall(requestFn, { Url = url, Method = "GET" })
        if ok and type(res) == "table" then return res.StatusCode, res.Body end
        return nil, tostring(res)
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok then return 200, body end
    return nil, tostring(body)
end

local function FormatTime(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    if seconds >= 86400 then
        return string.format("%dd %dh", seconds // 86400, (seconds % 86400) // 3600)
    end
    return string.format("%dh %02dm", seconds // 3600, (seconds % 3600) // 60)
end

-- รหัสอุปกรณ์ (ส่งไปให้เซิร์ฟเวอร์แฮชเก็บ ใช้ผูกคีย์กับเครื่อง)
local function GetHwid()
    local id
    pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end)
    if (not id or id == "") and type(gethwid) == "function" then
        pcall(function() id = gethwid() end)
    end
    return tostring(id or "")
end

local function CleanKey(text)
    local key = tostring(text or ""):gsub("%s+", "")
    return key:upper()
end

-- เช็กคีย์ คืน (true, ข้อมูล) หรือ (false, ข้อความผิดพลาด)
local function CheckKey(key)
    local status, body = Http("/verify", { key = key, uid = LocalPlayer.UserId, hwid = GetHwid() })
    if not status then return false, "Can't reach the key server" end
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(data) ~= "table" then return false, "Bad answer from the key server" end
    if data.ok then return true, data end
    local reasons = {
        invalid = "Invalid key",
        expired = "This key has expired",
        used_by_other = "This key is already locked to another device",
        too_many_accounts = "This key reached its account limit on this device",
        device_in_use = "This account or device already has another active key",
        no_hwid = "Your executor doesn't provide a device ID",
    }
    return false, reasons[data.reason] or "Key rejected"
end

-- ขอสคริปต์ของแมพนี้จากเซิร์ฟเวอร์ แล้วรัน
local function LoadMap(key)
    local status, body = Http("/script", { key = key, uid = LocalPlayer.UserId, hwid = GetHwid(), place = game.PlaceId })
    if status ~= 200 or type(body) ~= "string" or #body == 0 then
        if type(body) == "string" and body:find("no free version", 1, true) then
            return false, "No free version for this map yet. Get a Premium key."
        end
        return false, "Could not load the script (" .. tostring(status) .. ")"
    end
    local chunk, compileError = loadstring(body)
    if not chunk then return false, "Script error: " .. tostring(compileError) end
    local okRun, runError = pcall(chunk)
    if not okRun then return false, "Script failed: " .. tostring(runError) end
    return true
end

local function ReadSavedKey()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return nil end
    local ok, text = pcall(function()
        if isfile(CONFIG.KeyFile) then return readfile(CONFIG.KeyFile) end
    end)
    if ok and text and #text > 0 then return CleanKey(text) end
    return nil
end

local function SaveKey(key)
    if type(writefile) == "function" then pcall(writefile, CONFIG.KeyFile, key) end
end

print("[Smooth Hub] แมพ: " .. MapName)

-- 1) มีคีย์ที่จำไว้และยังใช้ได้ = เข้าเลย ไม่ต้องกรอก
local saved = ReadSavedKey()
if saved then
    local ok = CheckKey(saved)
    if ok then
        local loaded, err = LoadMap(saved)
        if loaded then return end
        warn("[Smooth Hub] " .. tostring(err))
    end
end

-- 2) ไม่มีคีย์ / หมดอายุ = ขึ้นหน้าต่างให้กรอก
local gui = Instance.new("ScreenGui")
gui.Name = "SmoothHubKey"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
local parentOk = pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not parentOk or not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local function Make(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end

local COLOR_BG = Color3.fromRGB(28, 28, 32)
local COLOR_FIELD = Color3.fromRGB(40, 40, 46)
local COLOR_ACCENT = Color3.fromRGB(235, 52, 90)
local COLOR_TEXT = Color3.fromRGB(235, 235, 240)
local COLOR_DIM = Color3.fromRGB(150, 150, 160)
local COLOR_OK = Color3.fromRGB(90, 200, 120)
local COLOR_BAD = Color3.fromRGB(240, 90, 90)

local Window = Make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(380, 300), BackgroundColor3 = COLOR_BG,
}, gui)
Make("UICorner", { CornerRadius = UDim.new(0, 12) }, Window)
Make("UIStroke", { Color = Color3.fromRGB(60, 60, 68), Thickness = 1 }, Window)

Make("TextLabel", {
    Text = "Smooth Hub", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = COLOR_TEXT,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 14), Size = UDim2.new(1, -40, 0, 26),
    TextXAlignment = Enum.TextXAlignment.Left,
}, Window)
Make("TextLabel", {
    Text = MapName, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = COLOR_DIM,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 40), Size = UDim2.new(1, -40, 0, 18),
    TextXAlignment = Enum.TextXAlignment.Left,
}, Window)

local KeyBox = Make("TextBox", {
    PlaceholderText = "Paste your key (SmoothHub-...)", Text = "", ClearTextOnFocus = false,
    Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = COLOR_TEXT, PlaceholderColor3 = COLOR_DIM,
    BackgroundColor3 = COLOR_FIELD, Position = UDim2.fromOffset(20, 76), Size = UDim2.new(1, -40, 0, 40),
}, Window)
Make("UICorner", { CornerRadius = UDim.new(0, 8) }, KeyBox)

local VerifyBtn = Make("TextButton", {
    Text = "Verify Key", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = COLOR_ACCENT, Position = UDim2.fromOffset(20, 128), Size = UDim2.new(1, -40, 0, 38),
    AutoButtonColor = true,
}, Window)
Make("UICorner", { CornerRadius = UDim.new(0, 8) }, VerifyBtn)

local FreeKeyBtn = Make("TextButton", {
    Text = "Get Free Key", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = COLOR_TEXT,
    BackgroundColor3 = COLOR_FIELD, Position = UDim2.fromOffset(20, 176), Size = UDim2.new(0.5, -26, 0, 38),
    AutoButtonColor = true,
}, Window)
Make("UICorner", { CornerRadius = UDim.new(0, 8) }, FreeKeyBtn)

local BuyBtn = Make("TextButton", {
    Text = "Buy Premium", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = COLOR_TEXT,
    BackgroundColor3 = COLOR_FIELD, Position = UDim2.new(0.5, 6, 0, 176), Size = UDim2.new(0.5, -26, 0, 38),
    AutoButtonColor = true,
}, Window)
Make("UICorner", { CornerRadius = UDim.new(0, 8) }, BuyBtn)

local Status = Make("TextLabel", {
    Text = "Paste your key and press Verify Key.", Font = Enum.Font.Gotham, TextSize = 13,
    TextColor3 = COLOR_DIM, BackgroundTransparency = 1, TextWrapped = true,
    Position = UDim2.fromOffset(20, 224), Size = UDim2.new(1, -40, 0, 36),
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
}, Window)
Make("TextLabel", {
    Text = "A key lasts 24 hours from redeem. One device, up to 3 accounts.", Font = Enum.Font.Gotham, TextSize = 11,
    TextColor3 = COLOR_DIM, BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 272), Size = UDim2.new(1, -40, 0, 16),
    TextXAlignment = Enum.TextXAlignment.Left,
}, Window)

local function SetStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color or COLOR_DIM
end

local busy = false
VerifyBtn.MouseButton1Click:Connect(function()
    if busy then return end
    local key = CleanKey(KeyBox.Text)
    if key == "" then
        SetStatus("Please enter a key first.", COLOR_BAD)
        return
    end
    busy = true
    SetStatus("Checking key...", COLOR_DIM)
    task.spawn(function()
        local ok, info = CheckKey(key)
        if not ok then
            SetStatus(info, COLOR_BAD)
            busy = false
            return
        end
        SaveKey(key)
        local tierName = info.tier == "free" and "Free" or "Premium"
        SetStatus(tierName .. " key OK - " .. FormatTime(info.secondsLeft) .. " left. Loading...", COLOR_OK)
        task.wait(0.4)
        local loaded, err = LoadMap(key)
        if loaded then
            gui:Destroy()
        else
            SetStatus(tostring(err), COLOR_BAD)
            busy = false
        end
    end)
end)

local function CopyLink(url, label)
    local copied = type(setclipboard) == "function" and pcall(setclipboard, url)
    SetStatus(copied and (label .. " link copied. Paste it in your browser:\n" .. url) or (label .. ": " .. url), COLOR_DIM)
end

FreeKeyBtn.MouseButton1Click:Connect(function()
    CopyLink(CONFIG.ApiUrl .. CONFIG.FreeKeyPath, "Free key")
end)

BuyBtn.MouseButton1Click:Connect(function()
    CopyLink(CONFIG.BuyUrl, "Premium")
end)    
