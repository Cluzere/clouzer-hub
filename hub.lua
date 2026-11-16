local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Catat daftar GUI yang ada SEBELUM window dibuat (buat nangkep GUI Fluent secara instan)
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")

local existingCore = {}
for _, v in ipairs(coreGui:GetChildren()) do existingCore[v] = true end
local existingPlayer = {}
for _, v in ipairs(playerGui:GetChildren()) do existingPlayer[v] = true end

-- 1. Bikin Jendela Utama (Window)
local Window = Fluent:CreateWindow({
    Title = "CLOUZER HUB",
    SubTitle = "High-Energy Cyber Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- Tangkap ScreenGui milik Fluent yang BARU MUNCUL secara mutlak!
local fluentGui = nil
task.spawn(function()
    task.wait(0.1) -- Jeda mikro supaya executor sempat me-render GUI
    for _, v in ipairs(coreGui:GetChildren()) do
        if not existingCore[v] and v:IsA("ScreenGui") then
            fluentGui = v
            break
        end
    end
    if not fluentGui then
        for _, v in ipairs(playerGui:GetChildren()) do
            if not existingPlayer[v] and v:IsA("ScreenGui") then
                fluentGui = v
                break
            end
        end
    end
end)

-- 2. Bikin Menu Tab
local Tabs = {
    Main = Window:AddTab({ Title = "Utama", Icon = "home" }),
    Features = Window:AddTab({ Title = "Fitur Game", Icon = "zap" }),
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

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

-- ==========================================
-- TOMBOL MELAYANG MINIMIZE/RESTORE (DIJAMIN WORK)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "ClouzerMobileToggle"
pcall(function()
    ScreenGui.Parent = coreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = playerGui
end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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
ToggleBtn.TextSize = 13
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

-- Fungsi Toggle pakai objek GUI yang udah pasti terekam
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    -- Backup kalau variabel telat ter-load
    if not fluentGui then
        for _, v in ipairs(coreGui:GetChildren()) do
            if not existingCore[v] and v:IsA("ScreenGui") and v ~= ScreenGui then
                fluentGui = v
                break
            end
        end
    end

    if fluentGui then
        isOpen = not isOpen
        fluentGui.Enabled = isOpen
        
        if isOpen then
            ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200) -- Hijau (Kebuka)
        else
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)  -- Merah (Minimize)
        end
    else
        print("ScreenGui Fluent gagal dideteksi di perangkat ini!")
    end
end)
