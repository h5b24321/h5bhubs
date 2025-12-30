--[[
    QUANTUM LIB [ULTRA QUALITY EDITION]

    Feature: Fully Animated, Custom Keybind, Anti-Delete
--]]

local QuantumLib = {}
QuantumLib.__index = QuantumLib

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Tema Ayarları
local Theme = {
    Background = Color3.fromRGB(15, 15, 18),
    Sidebar = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(126, 124, 245), -- Görseldeki morumsu renk
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(160, 160, 160),
    SectionHeader = Color3.fromRGB(120, 120, 120)
}

-- Güvenlik Katmanı
local function Protect(gui)
    gui.Name = HttpService:GenerateGUID(false)
    gui.Parent = CoreGui
    gui.AncestryChanged:Connect(function(_, p)
        if not p then gui.Parent = CoreGui end
    end)
end

function QuantumLib:CreateWindow(cfg)
    local self = setmetatable({}, QuantumLib)
    self.Keybind = cfg.Keybind or Enum.KeyCode.RightShift
    self.Visible = true

    -- Ana Ekran
    self.ScreenGui = Instance.new("ScreenGui")
    Protect(self.ScreenGui)

    -- MANDATORY INTRO (QUANTUM LIB - CostyTR)
    task.spawn(function()
        local IntroFrame = Instance.new("Frame", self.ScreenGui)
        IntroFrame.Size = UDim2.new(1, 0, 1, 0)
        IntroFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
        IntroFrame.ZIndex = 1000

        local MainText = Instance.new("TextLabel", IntroFrame)
        MainText.Size = UDim2.new(1, 0, 1, 0)
        MainText.BackgroundTransparency = 1
        MainText.Text = "QUANTUM LIB"
        MainText.Font = Enum.Font.GothamBold
        MainText.TextSize = 70
        MainText.TextColor3 = Theme.Accent
        MainText.TextTransparency = 1

        local SubText = Instance.new("TextLabel", IntroFrame)
        SubText.Size = UDim2.new(1, 0, 0, 50)
        SubText.Position = UDim2.new(0, 0, 0.6, 0)
        SubText.BackgroundTransparency = 1
        SubText.Text = "Made By CostyTR"
        SubText.Font = Enum.Font.Code
        SubText.TextSize = 25
        SubText.TextColor3 = Theme.Text
        SubText.TextTransparency = 1

        -- Animasyon Başlat
        TweenService:Create(MainText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
        task.wait(0.5)
        TweenService:Create(SubText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
        task.wait(2.5)
        TweenService:Create(MainText, TweenInfo.new(1), {TextTransparency = 1}):Play()
        TweenService:Create(SubText, TweenInfo.new(1), {TextTransparency = 1}):Play()
        TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()
        task.wait(1.5)
        IntroFrame:Destroy()
    end)

    -- Ana Pencere
    self.Main = Instance.new("Frame", self.ScreenGui)
    self.Main.Size = UDim2.new(0, 580, 0, 380)
    self.Main.Position = UDim2.new(0.5, -290, 0.5, -190)
    self.Main.BackgroundColor3 = Theme.Background
    self.Main.BorderSizePixel = 0
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 12)

    -- Sürükleme Özelliği
    local dragging, dragInput, dragStart, startPos
    self.Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = self.Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Açma/Kapama Tuşu (Keybind)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.Keybind then
            self.Visible = not self.Visible
            self.Main.Visible = self.Visible
        end
    end)

    -- Sidebar (Yan Menü)
    self.Sidebar = Instance.new("Frame", self.Main)
    self.Sidebar.Size = UDim2.new(0, 160, 1, 0)
    self.Sidebar.BackgroundColor3 = Theme.Sidebar
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 12)

    local Logo = Instance.new("TextLabel", self.Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 60)
    Logo.Text = "QUANTUM"
    Logo.TextColor3 = Theme.Accent
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 22
    Logo.BackgroundTransparency = 1

    self.TabHolder = Instance.new("ScrollingFrame", self.Sidebar)
    self.TabHolder.Size = UDim2.new(1, -10, 1, -70); self.TabHolder.Position = UDim2.new(0, 5, 0, 60)
    self.TabHolder.BackgroundTransparency = 1; self.TabHolder.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout", self.TabHolder); TabLayout.Padding = UDim.new(0, 5)

    self.PageHolder = Instance.new("Frame", self.Main)
    self.PageHolder.Size = UDim2.new(1, -180, 1, -20); self.PageHolder.Position = UDim2.new(0, 170, 0, 10)
    self.PageHolder.BackgroundTransparency = 1

    return self
end

function QuantumLib:CreateTab(name)
    local Tab = {}
    local TabBtn = Instance.new("TextButton", self.TabHolder)
    TabBtn.Size = UDim2.new(1, 0, 0, 38); TabBtn.BackgroundColor3 = Theme.Sidebar; TabBtn.Text = name
    TabBtn.TextColor3 = Theme.SecondaryText; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn)

    local Page = Instance.new("ScrollingFrame", self.PageHolder)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2
    local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(self.PageHolder:GetChildren()) do v.Visible = false end
        for _, v in pairs(self.TabHolder:GetChildren()) do if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Theme.SecondaryText}):Play() end end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Theme.Accent}):Play()
    end)

    -- ELEMENTLER
    
    -- Bölüm Başlığı (Non-Interactable / Interactable gibi)
    function Tab:CreateSection(txt)
        local S = Instance.new("TextLabel", Page)
        S.Size = UDim2.new(1, 0, 0, 25); S.Text = txt; S.TextColor3 = Theme.SectionHeader
        S.Font = Enum.Font.GothamBold; S.TextSize = 13; S.TextXAlignment = Enum.TextXAlignment.Left; S.BackgroundTransparency = 1
    end

    -- Paragraph
    function Tab:CreateParagraph(title, desc)
        local P = Instance.new("Frame", Page)
        P.Size = UDim2.new(1, -10, 0, 60); P.BackgroundColor3 = Color3.fromRGB(22, 22, 26); Instance.new("UICorner", P)
        local T = Instance.new("TextLabel", P); T.Size = UDim2.new(1, -20, 0, 25); T.Position = UDim2.new(0, 10, 0, 5)
        T.Text = title; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamBold; T.TextSize = 14; T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
        local D = Instance.new("TextLabel", P); D.Size = UDim2.new(1, -20, 0, 25); D.Position = UDim2.new(0, 10, 0, 30)
        D.Text = desc; D.TextColor3 = Theme.SecondaryText; D.Font = Enum.Font.Gotham; D.TextSize = 12; D.BackgroundTransparency = 1; D.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- Button
    function Tab:CreateButton(txt, callback)
        local B = Instance.new("TextButton", Page)
        B.Size = UDim2.new(1, -10, 0, 40); B.BackgroundColor3 = Color3.fromRGB(28, 28, 35); B.Text = "   " .. txt
        B.TextColor3 = Theme.Text; B.Font = Enum.Font.GothamSemibold; B.TextSize = 14; B.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", B)
        B.MouseEnter:Connect(function() TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play() end)
        B.MouseLeave:Connect(function() TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}):Play() end)
        B.MouseButton1Click:Connect(callback)
    end

    -- Toggle
    function Tab:CreateToggle(txt, callback)
        local Toggled = false
        local B = Instance.new("TextButton", Page)
        B.Size = UDim2.new(1, -10, 0, 40); B.BackgroundColor3 = Color3.fromRGB(28, 28, 35); B.Text = "   " .. txt
        B.TextColor3 = Theme.Text; B.Font = Enum.Font.GothamSemibold; B.TextSize = 14; B.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", B)
        
        local Indicator = Instance.new("Frame", B)
        Indicator.Size = UDim2.new(0, 20, 0, 20); Indicator.Position = UDim2.new(1, -30, 0.5, -10); Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
        
        B.MouseButton1Click:Connect(function()
            Toggled = not Toggled
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(50, 50, 50)}):Play()
            callback(Toggled)
        end)
    end

    -- Slider
    function Tab:CreateSlider(txt, min, max, default, callback)
        local SFrame = Instance.new("Frame", Page)
        SFrame.Size = UDim2.new(1, -10, 0, 55); SFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35); Instance.new("UICorner", SFrame)
        local Label = Instance.new("TextLabel", SFrame); Label.Size = UDim2.new(1, -20, 0, 25); Label.Position = UDim2.new(0, 10, 0, 5)
        Label.Text = txt .. ": " .. default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local Bar = Instance.new("Frame", SFrame); Bar.Size = UDim2.new(1, -40, 0, 6); Bar.Position = UDim2.new(0, 20, 0, 40); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent
        
        -- Basit Slider Mantığı
        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    local mousePos = UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X
                    local percent = math.clamp(mousePos / Bar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    local value = math.floor(min + (max - min) * percent)
                    Label.Text = txt .. ": " .. value
                    callback(value)
                end)
                UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
                end)
            end
        end)
    end

    return Tab
end

return QuantumLib
