---------------------------------------------------------
-- Smooth Hub : Main
-- เช็กว่าอยู่ PlaceId ไหน แล้วโหลด UI ของแมพนั้น
---------------------------------------------------------
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LocalPlayer = game:GetService("Players").LocalPlayer

---------------------------------------------------------
-- ⚙️ ตั้งค่าตรงนี้
-- แต่ละแมพใส่ลิงก์ raw ของสคริปต์ใน Scripts
-- สคริปต์จะโหลดเรียงจากบนลงล่าง
---------------------------------------------------------
local Maps = {
    -- โลกปกติ
    [71793674075007] = {
        Name = "Kanom Tokyo",
        Scripts = {
            { Name = "Ui โลกปกติ", Url = "https://raw.githubusercontent.com/smoothhubv1-prog/KanomTokyoHACK/refs/heads/main/Ui.lua" },
        },
    },

    -- Boss Map
    [123949707464677] = {
        Name = "Kanom Tokyo",
        Scripts = {
            { Name = "Ui Boss Map", Url = "https://raw.githubusercontent.com/smoothhubv1-prog/KanomTokyoHACK/refs/heads/main/UiMap%20Boss.lua" },
        },
    },
	    -- Raid Map
    [12337212938933] = {
        Name = "Kanom Tokyo",
        Scripts = {   
            { Name = "Ui Raid Map", Url = "https://raw.githubusercontent.com/smoothhubv1-prog/KanomTokyoHACK/refs/heads/main/UiMapRaid.lua" },
        },
    },
}

---------------------------------------------------------
-- 🚀 ส่วนทำงาน (ไม่ต้องแก้)
---------------------------------------------------------
local Map = Maps[game.PlaceId]

if not Map then
    LocalPlayer:Kick("สคริปต์นี้ใช้ได้เฉพาะ Map | Kanom Tokyo")
    return
end

-- โหลดและรันสคริปต์ 1 ไฟล์ คืนค่า true ถ้าสำเร็จ
local function RunScript(info)
    local okGet, source = pcall(function()
        return game:HttpGet(info.Url)
    end)
    if not okGet then
        warn("[Smooth Hub] โหลดไม่สำเร็จ (" .. info.Name .. "): " .. tostring(source))
        return false
    end

    local chunk, compileError = loadstring(source)
    if not chunk then
        warn("[Smooth Hub] สคริปต์มี Error (" .. info.Name .. "): " .. tostring(compileError))
        return false
    end

    local okRun, runError = pcall(chunk)
    if not okRun then
        warn("[Smooth Hub] รันไม่สำเร็จ (" .. info.Name .. "): " .. tostring(runError))
        return false
    end

    return true
end

print("[Smooth Hub] แมพ: " .. Map.Name)

for _, info in ipairs(Map.Scripts) do
    if not RunScript(info) then
        -- หยุดทันทีถ้าสคริปต์ตัวไหนโหลดไม่สำเร็จ
        break
    end
end
