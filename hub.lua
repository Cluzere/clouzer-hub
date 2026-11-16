local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local coreGui = game:GetService("CoreGui")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- BUAT TOMBOL "CLZ" DI AWAL (AGAR AMAN & INDEPENDEN)
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
ToggleBtn.TextSize = 13
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

-- Fungsi pencari ScreenGui Fluent yang tahan banting
local function findFluentGui()
    local containers = {coreGui, playerGui}
    for _, container in ipairs(containers) do
        for _, gui in ipairs(container:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= ScreenGui then
                for _, desc in ipairs(gui:GetDescendants()) do
                    if desc:IsA("TextLabel") and desc.Text == "CLOUZER HUB" then
                        return gui
                    end
                end
            end
        end
    end
    return nil
end

local fluentGui = nil
task.spawn(function()
    while not fluentGui do
        task.wait(0.3)
        fluentGui = findFluentGui()
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

-- Fungsi Tombol Minimize / Restore (Dengan Fallback Darurat)
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    if not fluentGui then
        fluentGui = findFluentGui()
    end

    isOpen = not isOpen

    if isOpen then
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200) -- Hijau (Terbuka)
    else
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)  -- Merah (Minimize)
    end

    if fluentGui then
        fluentGui.Enabled = isOpen
    else
        -- Fallback pengaman mutlak: Sembunyikan semua ScreenGui asing selain tombol kita
        local containers = {coreGui, playerGui}
        for _, c in ipairs(containers) do
            for _, g in ipairs(c:GetChildren()) do
                if g:IsA("ScreenGui") and g ~= ScreenGui then
                    g.Enabled = isOpen
                end
            end
        end
    end
end)
