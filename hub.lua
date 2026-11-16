-- Hapus tombol "CLZ" lama kalau ada (Biar gak double pas execute ulang)
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("ClouzerMobileToggle") then
        game:GetService("CoreGui").ClouzerMobileToggle:Destroy()
    end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("ClouzerMobileToggle") then
        game.Players.LocalPlayer.PlayerGui.ClouzerMobileToggle:Destroy()
    end
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local coreGui = game:GetService("CoreGui")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- BUAT TOMBOL MELAYANG "CLZ" (ANTI-DOUBLE)
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

-- Cari Frame utama Fluent secara presisi
local mainFrame = nil
task.spawn(function()
    while not mainFrame do
        task.wait(0.2)
        local containers = {coreGui, playerGui}
        for _, container in ipairs(containers) do
            for _, gui in ipairs(container:GetChildren()) do
                if gui:IsA("ScreenGui") and gui ~= ScreenGui then
                    for _, desc in ipairs(gui:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.Text == "CLOUZER HUB" then
                            local p = desc.Parent
                            while p and p ~= gui do
                                if p:IsA("Frame") and p.Size.X.Offset >= 400 then
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
-- SISTEM MINIMIZE / RESTORE (FRAME TOGGLE)
-- ==========================================
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    if mainFrame then
        isOpen = not isOpen
        mainFrame.Visible = isOpen
        
        if isOpen then
            ToggleBtn.Text = "CLZ"
            ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200) -- Hijau (Terbuka)
        else
            ToggleBtn.Text = "SHOW"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)  -- Merah (Minimize)
        end
    else
        print("MainFrame Fluent belum tertangkap!")
    end
end)
