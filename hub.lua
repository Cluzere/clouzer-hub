local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 1. Bikin Jendela Utama (Window)
local Window = Fluent:CreateWindow({
    Title = "CLOUZER HUB",
    SubTitle = "High-Energy Cyber Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Efek blur kaca transparan
    Theme = "Dark"
})

-- 2. Bikin Menu Tab
local Tabs = {
    Main = Window:AddTab({ Title = "Utama", Icon = "home" }),
    Features = Window:AddTab({ Title = "Fitur Game", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Pengaturan", Icon = "settings" })
}

local Options = Fluent.Options

do
    -- Notifikasi awal pas script sukses di-load
    Fluent:Notify({
        Title = "CLOUZER HUB Loaded!",
        Content = "Sistem berhasil diaktifkan. Enjoy, bro!",
        Duration = 5
    })

    -- Info / Paragraph di Tab Utama
    Tabs.Main:AddParagraph({
        Title = "Selamat Datang di CLOUZER HUB",
        Content = "Gunakan script ini dengan bijak.\nStatus: Connected & Secure."
    })

    -- Contoh Tombol Aksi
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

    -- Contoh Toggle (On/Off) di Tab Fitur
    Tabs.Features:AddToggle("AutoFarmToggle", {
        Title = "Auto Farm / Fitur Utama",
        Default = false
    })

    Options.AutoFarmToggle:OnChanged(function()
        if Options.AutoFarmToggle.Value then
            print("Fitur diaktifkan!")
            -- Masukin kode script cheat/fitur lu di sini
        else
            print("Fitur dimatikan!")
        end
    end)
end

-- 3. Manager buat Setting & Config
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

-- Load config otomatis kalau ada
SaveManager:LoadAutoloadConfig()

-- ==========================================
-- TOMBOL MELAYANG MINIMIZE/RESTORE MOBILE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "ClouzerMobileToggle"
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
ToggleBtn.Draggable = true -- Bisa digeser-geser di layar HP

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

-- Fungsi toggle minimize/restore jendela utama
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    -- Ubah warna teks tombol sebagai indikator (Hijau = Buka, Merah = Tutup)
    if isOpen then
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
    else
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    end

    -- Cari dan sembunyikan/tampilkan jendela utama CLOUZER HUB secara otomatis
    local containers = {game:GetService("CoreGui"), game.Players.LocalPlayer:WaitForChild("PlayerGui")}
    for _, parentContainer in ipairs(containers) do
        for _, obj in ipairs(parentContainer:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Text == "CLOUZER HUB" then
                local parent = obj.Parent
                while parent and parent ~= parentContainer do
                    if parent:IsA("Frame") and parent.Size.X.Offset > 400 then
                        parent.Visible = isOpen
                        break
                    end
                    parent = parent.Parent
                end
            end
        end
    end
end)
