-- ==========================================
-- CLOUZER HUB (versi perbaikan)
--
-- Yang diperbaiki:
--  1. SetLibrary() dipanggil dulu sebelum BuildInterfaceSection / BuildConfigSection.
--     (Sebelumnya script berhenti di situ, jadi tombol CLZ gak pernah dikasih fungsi klik.)
--  2. Tombol CLZ sekarang manggil Window:Minimize(), fungsi yang sama
--     dengan tombol "-" bawaan Fluent. Cuma ada SATU saklar, jadi selalu sinkron.
-- ==========================================

-- Bersihin sisa script lama biar gak dobel pas execute ulang
local env = (getgenv and getgenv()) or _G
if env.ClouzerFluent then
    pcall(function() env.ClouzerFluent:Destroy() end)
    env.ClouzerFluent = nil
end

local coreGui = game:GetService("CoreGui")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    local old = coreGui:FindFirstChild("ClouzerMobileToggle")
    if old then old:Destroy() end
end)
pcall(function()
    local old = playerGui:FindFirstChild("ClouzerMobileToggle")
    if old then old:Destroy() end
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
env.ClouzerFluent = Fluent

-- ==========================================
-- JENDELA UTAMA
-- ==========================================
local Window = Fluent:CreateWindow({
    Title = "CLOUZER HUB",
    SubTitle = "High-Energy Cyber Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- biar aman, sama kayak contoh resmi Fluent
})

-- ==========================================
-- TOMBOL MELAYANG "CLZ"
-- Dipasang di awal (tepat setelah jendela dibuat) supaya tetap
-- berfungsi walaupun ada bagian di bawah yang error.
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClouzerMobileToggle"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100 -- selalu di atas jendela Fluent
pcall(function()
    ScreenGui.Parent = coreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = playerGui
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleButton"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 200)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "CLZ"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
ToggleBtn.TextSize = 12
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

-- Klik CLZ = minimize / restore lewat fungsi bawaan Fluent
ToggleBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
    if Window.Minimized then
        ToggleBtn.Text = "SHOW"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80) -- merah = disembunyiin
    else
        ToggleBtn.Text = "CLZ"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200) -- hijau = terbuka
    end
end)

-- Kalau UI di-unload (tombol X di jendela Fluent), tombol CLZ ikut hilang
pcall(function()
    Fluent.GUI.Destroying:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- ==========================================
-- MENU TAB
-- ==========================================
local Tabs = {
    Main = Window:AddTab({ Title = "Utama", Icon = "home" }),
    Features = Window:AddTab({ Title = "Fitur Game", Icon = "gamepad-2" }),
    Settings = Window:AddTab({ Title = "Pengaturan", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "CLOUZER HUB Loaded!",
        Content = "Sistem berhasil diaktifkan. Enjoy, bro!",
        Duration = 5
    })

    Tabs.Main:AddParagraph({
        Title = "Selamat Datang di CLOUZER HUB",
        Content = "Gunakan script ini dengan bijak.\nStatus: Connected & Secure."
    })

    Tabs.Main:AddButton({
        Title = "Contoh Tombol",
        Description = "Klik untuk menjalankan fungsi tertentu",
        Callback = function()
            Fluent:Notify({
                Title = "Berhasil!",
                Content = "Tombol diklik, bro!",
                Duration = 3
            })
        end
    })

    Tabs.Features:AddToggle("AutoFarmToggle", {
        Title = "Auto Farm / Fitur Utama",
        Default = false
    })

    Options.AutoFarmToggle:OnChanged(function()
        if Options.AutoFarmToggle.Value then
            print("Fitur diaktifkan!")
        else
            print("Fitur dimatikan!")
        end
    end)
end

-- ==========================================
-- TAB PENGATURAN
-- SetLibrary WAJIB dipanggil dulu. Dibungkus pcall supaya kalau gagal
-- (misal executor gak support file system), bagian lain tetap jalan.
-- ==========================================
local ok, err = pcall(function()
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    InterfaceManager:SetFolder("ClouzerHub")
    SaveManager:SetFolder("ClouzerHub/configs")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end)
if not ok then
    warn("[CLZ] Tab Pengaturan gagal dibuat: " .. tostring(err))
end

Window:SelectTab(1)

pcall(function()
    SaveManager:LoadAutoloadConfig()
end)
