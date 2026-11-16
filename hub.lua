local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

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
-- TOMBOL RESTORE / MINIMIZE KHUSUS MOBILE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local RestoreBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "ClouzerRestoreGui"
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false -- Mulanya disembunyiin karena window pas awal ke-buka lagi aktif

RestoreBtn.Name = "RestoreButton"
RestoreBtn.Parent = ScreenGui
RestoreBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RestoreBtn.BorderColor3 = Color3.fromRGB(0, 255, 200)
RestoreBtn.BorderSizePixel = 2
RestoreBtn.Position = UDim2.new(0, 20, 0.4, 0)
RestoreBtn.Size = UDim2.new(0, 45, 0, 45)
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.Text = "CLZ"
RestoreBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
RestoreBtn.TextSize = 13
RestoreBtn.Active = true
RestoreBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = RestoreBtn

-- Cari frame utama Fluent buat di-minimize/restore bersih
local mainFrame = nil
task.spawn(function()
    while not mainFrame do
        task.wait(0.2)
        local containers = {game:GetService("CoreGui"), game.Players.LocalPlayer:WaitForChild("PlayerGui")}
        for _, container in ipairs(containers) do
            for _, gui in ipairs(container:GetChildren()) do
                if gui:IsA("ScreenGui") and gui ~= ScreenGui then
                    for _, desc in ipairs(gui:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.Text == "CLOUZER HUB" then
                            local p = desc.Parent
                            while p and p ~= gui do
                                if p:IsA("Frame") and p.Size.X.Offset >= 500 then
                                    mainFrame = p
                                    break
                                end
                                p = p.Parent
                            end
                            break
                        end
                    end
                end
                if mainFrame then break end
            end
            if mainFrame then break end
        end
    end
end)

-- Tombol buat buka lagi (Restore) pas di-minimize
RestoreBtn.MouseButton1Click:Connect(function()
    if mainFrame then
        mainFrame.Visible = true
        ScreenGui.Enabled = false -- Sembunyikan tombol "CLZ" pas hub ke-buka
    end
end)

-- Tambahin tombol minimize kecil di dalam jendela Fluent secara otomatis kalau ketemu
task.spawn(function()
    while true do
        task.wait(1)
        if mainFrame then
            -- Cari apakah ada tombol close/minimize bawaan, kalau mau gampang kita sediakan trigger minimize via notif atau kita pantau visibilitas frame
            if not mainFrame.Visible and not ScreenGui.Enabled then
                ScreenGui.Enabled = true
            end
        end
    end
end)
