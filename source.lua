-- QUANTUM UI LIBRARY - CORE MODULE
-- Developer: CostyTR

local QuantumLib = {}
QuantumLib.__index = QuantumLib

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Silemezler Koruması ve Ekran Kurulumu
local function Protect(gui)
    gui.Name = game:GetService("HttpService"):GenerateGUID(false)
    gui.Parent = CoreGui
    gui.AncestryChanged:Connect(function(_, p)
        if not p then gui.Parent = CoreGui end
    end)
end

function QuantumLib:CreateWindow(cfg)
    local self = setmetatable({}, QuantumLib)
    self.Title = cfg.Name or "Quantum"
    
    -- Ana Ekran
    self.ScreenGui = Instance.new("ScreenGui")
    Protect(self.ScreenGui)

    -- Intro Sistemi (Hızlı ve Havalı)
    task.spawn(function()
        local Intro = Instance.new("Frame", self.ScreenGui)
        Intro.Size = UDim2.new(1,0,1,0)
        Intro.BackgroundColor3 = Color3.fromRGB(10,10,15)
        Intro.ZIndex = 100
        
        local T = Instance.new("TextLabel", Intro)
        T.Size = UDim2.new(1,0,1,0)
        T.Text = "QUANTUM\nMade By CostyTR"
        T.TextColor3 = Color3.fromRGB(130,130,255)
        T.Font = Enum.Font.GothamBold
        T.TextSize = 50
        T.BackgroundTransparency = 1
        
        task.wait(2)
        TweenService:Create(Intro, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        TweenService:Create(T, TweenInfo.new(1), {TextTransparency = 1}):Play()
        task.wait(1)
        Intro:Destroy()
    end)

    -- Main Frame
    self.Main = Instance.new("Frame", self.ScreenGui)
    self.Main.Size = UDim2.new(0, 550, 0, 350)
    self.Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    self.Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 10)

    -- Tab Container (Sol Taraf)
    self.TabContainer = Instance.new("Frame", self.Main)
    self.TabContainer.Size = UDim2.new(0, 150, 1, -40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", self.TabContainer)
    Layout.Padding = UDim.new(0, 5)

    -- Page Container (Sağ Taraf)
    self.Pages = Instance.new("Frame", self.Main)
    self.Pages.Size = UDim2.new(1, -160, 1, -50)
    self.Pages.Position = UDim2.new(0, 155, 0, 45)
    self.Pages.BackgroundTransparency = 1

    return self
end

function QuantumLib:CreateTab(name)
    local Tab = {}
    
    -- Tab Butonu
    local TabBtn = Instance.new("TextButton", self.TabContainer)
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    -- Sayfa İçeriği
    local Page = Instance.new("ScrollingFrame", self.Pages)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.Pages:GetChildren()) do v.Visible = false end
        Page.Visible = true
    end)

    -- Tab İçine Buton Ekleme
    function Tab:CreateButton(txt, callback)
        local Btn = Instance.new("TextButton", Page)
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Btn.Text = txt
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        
        Btn.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    return Tab
end

return QuantumLib
