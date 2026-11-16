local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local coreGui = game:GetService("CoreGui")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- BUAT TOMBOL MELAYANG "CLZ" DI AWAL
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
ScreenGui.ResetOnSpawn = false

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

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

-- 1. Bikin Jendela Utama (Window)
local Window = Fluent:CreateWindow({
    Title = "CLOUZER HUB",
    SubTitle = "High-Energy Cyber Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
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
-- SISTEM TOGGLE MINIMIZE / RESTORE OTOMATIS
-- ==========================================
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen

    -- Ubah teks & warna indikator tombol secara instan
    if isOpen then
        ToggleBtn.Text = "CLZ"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200) -- Hijau (Terbuka)
    else
        ToggleBtn.Text = "SHOW"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)  -- Merah (Minimized)
    end

    -- Cari dan toggle ScreenGui milik Fluent secara otomatis
    local containers = {coreGui, playerGui}
    for _, container in ipairs(containers) do
        for _, gui in ipairs(container:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= ScreenGui then
                -- Cek apakah ScreenGui ini punya komponen Frame (ciri khas UI library)
                local hasFrame = false
                pcall(function()
                    for _, desc in ipairs(gui:GetDescendants()) do
                        if desc:IsA("Frame") then
                            hasFrame = true
                            break
                        end
                    end
                end)
                
                if hasFrame then
                    gui.Enabled = isOpen
                end
            end
        end
    end
end)
