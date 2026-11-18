
--==================================================
-- CLOUZER HUB
-- 100 DAYS AT SEA
-- DARK RED EDITION
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Env = (getgenv and getgenv()) or _G

-- CLEANUP OLD UI
pcall(function()
    if Env.ClouzerFluent then
        Env.ClouzerFluent:Destroy()
        Env.ClouzerFluent = nil
    end
end)

pcall(function()
    CoreGui:FindFirstChild("ClouzerMobileToggle"):Destroy()
end)

-- LOAD FLUENT
local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()

Env.ClouzerFluent = Fluent

-- WINDOW
local Window = Fluent:CreateWindow({
    Title = "CLOUZER HUB",
    SubTitle = "100 DAYS AT SEA | DARK RED",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- TABS
local Tabs = {
    Home = Window:AddTab({Title = "Home", Icon = "home"}),
    Fishing = Window:AddTab({Title = "Fishing", Icon = "anchor"}),
    Farm = Window:AddTab({Title = "Farming", Icon = "fish"}),
    Combat = Window:AddTab({Title = "Combat", Icon = "swords"}),
    Teleport = Window:AddTab({Title = "Teleport", Icon = "map"}),
    Player = Window:AddTab({Title = "Player", Icon = "user"}),
    Visual = Window:AddTab({Title = "Visual", Icon = "eye"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

-- NOTIFICATION
local function Notify(title, content)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = 4
    })
end

-- PLACEHOLDER FEATURE
local function NotConnected(name)
    Notify("CLOUZER HUB", name .. " belum terhubung ke mekanisme game.")
end

--==================================================
-- HOME
--==================================================

Tabs.Home:AddParagraph({
    Title = "CLOUZER HUB",
    Content = "Welcome to CLOUZER HUB - Dark Red Edition."
})

Tabs.Home:AddParagraph({
    Title = "Game",
    Content = "100 Days at Sea"
})

Tabs.Home:AddParagraph({
    Title = "Build",
    Content = "Development Build | UI Loaded"
})

Tabs.Home:AddParagraph({
    Title = "Information",
    Content = "Pilih fitur dari menu di sebelah kiri."
})

--==================================================
-- FISHING
--==================================================

Tabs.Fishing:AddSection("AUTO FISHING")

Tabs.Fishing:AddToggle("AutoFishing", {
    Title = "Auto Fishing",
    Description = "Automatic fishing",
    Default = false,
    Callback = function(Value)
        if Value then
            NotConnected("Auto Fishing")
        else
            Notify("CLOUZER HUB", "Auto Fishing OFF")
        end
    end
})

Tabs.Fishing:AddSlider("FishingDelay", {
    Title = "Fishing Delay",
    Description = "Delay pengaturan",
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Env.ClouzerFishingDelay = Value
    end
})

Tabs.Fishing:AddParagraph({
    Title = "Status",
    Content = "Menunggu integrasi mekanisme memancing."
})

--==================================================
-- FARMING
--==================================================

Tabs.Farm:AddSection("AUTO FARM")

local FarmList = {
    "Auto Collect",
    "Auto Sell",
    "Auto Craft",
    "Auto Chest"
}

for _, Name in ipairs(FarmList) do
    Tabs.Farm:AddToggle(Name, {
        Title = Name,
        Default = false,
        Callback = function(Value)
            if Value then
                NotConnected(Name)
            end
        end
    })
end

--==================================================
-- COMBAT
--==================================================

Tabs.Combat:AddSection("COMBAT SYSTEM")

Tabs.Combat:AddToggle("AutoCombat", {
    Title = "Auto Combat",
    Default = false,
    Callback = function(Value)
        if Value then
            NotConnected("Auto Combat")
        end
    end
})

Tabs.Combat:AddToggle("AutoBoss", {
    Title = "Auto Boss",
    Default = false,
    Callback = function(Value)
        if Value then
            NotConnected("Auto Boss")
        end
    end
})

--==================================================
-- TELEPORT
--==================================================

Tabs.Teleport:AddSection("TELEPORT")

Tabs.Teleport:AddParagraph({
    Title = "Destinations",
    Content = "Lokasi teleport belum dipetakan."
})

--==================================================
-- PLAYER
--==================================================

Tabs.Player:AddSection("PLAYER SETTINGS")

Tabs.Player:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Player:AddSlider("JumpPower", {
    Title = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 150,
    Rounding = 0,
    Callback = function(Value)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Value
        end
    end
})

local InfiniteJump = false

Tabs.Player:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        InfiniteJump = Value
    end
})

UserInputService.JumpRequest:Connect(function()
    if not InfiniteJump then return end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--==================================================
-- VISUAL / PLAYER ESP
--==================================================

Tabs.Visual:AddSection("PLAYER ESP")

local ESPEnabled = false
local ESPObjects = {}

local function RemoveESP(Player)
    if ESPObjects[Player] then
        ESPObjects[Player]:Destroy()
        ESPObjects[Player] = nil
    end
end

local function AddESP(Player)
    if not ESPEnabled then return end
    if Player == LocalPlayer then return end
    if not Player.Character then return end

    RemoveESP(Player)

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "ClouzerPlayerESP"
    Highlight.Adornee = Player.Character
    Highlight.FillColor = Color3.fromRGB(180, 20, 35)
    Highlight.OutlineColor = Color3.fromRGB(255, 70, 70)
    Highlight.FillTransparency = 0.65
    Highlight.OutlineTransparency = 0
    Highlight.Parent = CoreGui

    ESPObjects[Player] = Highlight
end

Tabs.Visual:AddToggle("PlayerESP", {
    Title = "Player ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value

        if Value then
            for _, Player in ipairs(Players:GetPlayers()) do
                AddESP(Player)
            end
        else
            for Player in pairs(ESPObjects) do
                RemoveESP(Player)
            end
        end
    end
})

local function TrackPlayer(Player)
    if Player == LocalPlayer then return end

    Player.CharacterAdded:Connect(function()
        task.wait(1)
        AddESP(Player)
    end)

    if Player.Character then
        AddESP(Player)
    end
end

Players.PlayerAdded:Connect(TrackPlayer)
Players.PlayerRemoving:Connect(RemoveESP)

for _, Player in ipairs(Players:GetPlayers()) do
    TrackPlayer(Player)
end

--==================================================
-- SETTINGS
--==================================================

Tabs.Settings:AddSection("CONFIGURATION")

local SaveManager
local InterfaceManager

pcall(function()
    SaveManager = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
    ))()

    InterfaceManager = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
    ))()

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()
    InterfaceManager:SetFolder("ClouzerHub")
    SaveManager:SetFolder("ClouzerHub/configs")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    SaveManager:LoadAutoloadConfig()
end)

--==================================================
-- FLOATING CLZ BUTTON
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClouzerMobileToggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100

local ParentSuccess = pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not ParentSuccess or not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Button = Instance.new("TextButton")
Button.Name = "CLZ"
Button.Size = UDim2.fromOffset(50, 50)
Button.Position = UDim2.new(0, 20, 0.45, 0)
Button.BackgroundColor3 = Color3.fromRGB(35, 8, 12)
Button.Text = "CLZ"
Button.TextColor3 = Color3.fromRGB(255, 65, 75)
Button.TextSize = 16
Button.Font = Enum.Font.GothamBold
Button.BorderSizePixel = 0
Button.Active = true
Button.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Button

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(190, 25, 45)
Stroke.Thickness = 2
Stroke.Parent = Button

-- DRAG
local Dragging = false
local DragStart
local StartPosition

Button.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Button.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then
        local Delta = Input.Position - DragStart

        Button.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

Button.Activated:Connect(function()
    Window:Minimize()
end)

--==================================================
-- FINISH
--==================================================

Window:SelectTab(1)

Notify(
    "CLOUZER HUB",
    "Dark Red Edition berhasil dimuat."
)
