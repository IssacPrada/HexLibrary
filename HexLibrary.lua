--[[
    Hex Scripts UI Library
    Inspired by Fluent / Kavo UI design with modern dark layout and smooth animations.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local HexLib = {
    Themes = {
        DarkRed = {
            Background = Color3.fromRGB(15, 15, 20),
            Sidebar = Color3.fromRGB(22, 22, 28),
            Container = Color3.fromRGB(28, 28, 36),
            Card = Color3.fromRGB(35, 35, 45),
            Accent = Color3.fromRGB(220, 50, 70),
            GradientStart = Color3.fromRGB(220, 50, 70),
            GradientEnd = Color3.fromRGB(120, 20, 40),
            TextPrimary = Color3.fromRGB(240, 240, 245),
            TextSecondary = Color3.fromRGB(150, 150, 165)
        },
        OceanBlue = {
            Background = Color3.fromRGB(15, 18, 25),
            Sidebar = Color3.fromRGB(20, 25, 35),
            Container = Color3.fromRGB(25, 32, 45),
            Card = Color3.fromRGB(32, 40, 58),
            Accent = Color3.fromRGB(0, 150, 255),
            GradientStart = Color3.fromRGB(0, 150, 255),
            GradientEnd = Color3.fromRGB(0, 70, 160),
            TextPrimary = Color3.fromRGB(240, 245, 255),
            TextSecondary = Color3.fromRGB(140, 160, 185)
        }
    },
    CurrentTheme = nil,
    LogoId = "rbxassetid://130021749368779"
}

HexLib.CurrentTheme = HexLib.Themes.DarkRed

-- Sound Helper Function
local function PlaySound(id, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = 0.4
    sound.PlaybackSpeed = pitch or 1
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

-- Key System Window
function HexLib:KeySystem(validKeys, onSuccess)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "HexKeySystem"
    KeyGui.Parent = CoreGui
    
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 24
    Blur.Parent = Lighting

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 360, 0, 220)
    Frame.Position = UDim2.new(0.5, -180, 0.5, -110)
    Frame.BackgroundColor3 = HexLib.CurrentTheme.Container
    Frame.BorderSizePixel = 0
    Frame.Parent = KeyGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Text = "Hex Scripts - Key Verification"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.TextColor3 = HexLib.CurrentTheme.TextPrimary
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local TextBox = Instance.new("TextBox")
    TextBox.PlaceholderText = "Enter Access Key..."
    TextBox.Size = UDim2.new(0.85, 0, 0, 40)
    TextBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    TextBox.BackgroundColor3 = HexLib.CurrentTheme.Card
    TextBox.TextColor3 = HexLib.CurrentTheme.TextPrimary
    TextBox.PlaceholderColor3 = HexLib.CurrentTheme.TextSecondary
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 16
    TextBox.Parent = Frame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 40)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
    SubmitBtn.BackgroundColor3 = HexLib.CurrentTheme.Accent
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.SourceSansBold
    SubmitBtn.TextSize = 16
    SubmitBtn.Parent = Frame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

    SubmitBtn.MouseButton1Click:Connect(function()
        PlaySound(6895079853, 1.1) -- Click SFX
        local input = TextBox.Text
        local valid = false
        for _, k in ipairs(validKeys) do
            if input == k then valid = true break end
        end
        if valid then
            Blur:Destroy()
            KeyGui:Destroy()
            onSuccess()
        else
            TextBox.Text = ""
            TextBox.PlaceholderText = "Invalid Key! Try Again..."
        end
    end)
end

-- Main Window Creator
function HexLib:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "Hex Scripts"
    local SubTitleText = config.SubTitle or "v1.0.0"

    -- Screen Blur Setup
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = Lighting
    TweenService:Create(Blur, TweenInfo.new(0.8), {Size = 20}):Play()

    -- ScreenGui Setup
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "HexWindowGui"
    Gui.Parent = CoreGui

    -- Intro Sequence Container
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Size = UDim2.new(0, 200, 0, 200)
    IntroFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
    IntroFrame.BackgroundTransparency = 1
    IntroFrame.Parent = Gui

    local Logo = Instance.new("ImageLabel")
    Logo.Image = HexLib.LogoId
    Logo.Size = UDim2.new(0, 90, 0, 90)
    Logo.Position = UDim2.new(0.5, -45, 0.5, -45)
    Logo.BackgroundTransparency = 1
    Logo.ImageTransparency = 1
    Logo.Parent = IntroFrame

    local IntroText = Instance.new("TextLabel")
    IntroText.Text = "Hex Scripts"
    IntroText.Size = UDim2.new(0, 200, 0, 40)
    IntroText.Position = UDim2.new(0.5, 10, 0.5, -20)
    IntroText.TextColor3 = HexLib.CurrentTheme.TextPrimary
    IntroText.Font = Enum.Font.SourceSansBold
    IntroText.TextSize = 26
    IntroText.TextTransparency = 1
    IntroText.BackgroundTransparency = 1
    IntroText.TextXAlignment = Enum.TextXAlignment.Left
    IntroText.Parent = IntroFrame

    -- Intro Animation Sequence
    PlaySound(9114223179, 1.0) -- Intro Swish SFX
    TweenService:Create(Logo, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {ImageTransparency = 0}):Play()
    task.wait(0.6)
    
    -- Logo Swish to Left & Reveal Text
    TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 0.5, -45)}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()
    task.wait(1.2)

    -- Fade Out Intro & Cleanup Blur
    TweenService:Create(Logo, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
    task.wait(0.5)
    IntroFrame:Destroy()
    Blur:Destroy()

    -- Main UI Frame Setup
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 680, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -210)
    MainFrame.BackgroundColor3 = HexLib.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Gui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- Multi-Color Gradient Ambient Background
    local AmbientGradient = Instance.new("UIGradient")
    AmbientGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, HexLib.CurrentTheme.GradientStart),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 35)),
        ColorSequenceKeypoint.new(1, HexLib.CurrentTheme.Background)
    })
    AmbientGradient.Rotation = 45
    AmbientGradient.Parent = MainFrame

    -- Slow Animated Red/Theme Gradient Transition
    task.spawn(function()
        local rot = 45
        while MainFrame.Parent do
            rot = (rot + 1) % 360
            AmbientGradient.Rotation = rot
            task.wait(0.05)
        end
    end)

    -- Sidebar Layout
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = HexLib.CurrentTheme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local BrandLogo = Instance.new("ImageLabel")
    BrandLogo.Image = HexLib.LogoId
    BrandLogo.Size = UDim2.new(0, 30, 0, 30)
    BrandLogo.Position = UDim2.new(0, 15, 0, 15)
    BrandLogo.BackgroundTransparency = 1
    BrandLogo.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = TitleText
    TitleLabel.Size = UDim2.new(0, 115, 0, 20)
    TitleLabel.Position = UDim2.new(0, 52, 0, 13)
    TitleLabel.TextColor3 = HexLib.CurrentTheme.TextPrimary
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Sidebar

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Text = SubTitleText
    SubTitleLabel.Size = UDim2.new(0, 115, 0, 15)
    SubTitleLabel.Position = UDim2.new(0, 52, 0, 31)
    SubTitleLabel.TextColor3 = HexLib.CurrentTheme.TextSecondary
    SubTitleLabel.Font = Enum.Font.SourceSans
    SubTitleLabel.TextSize = 12
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Parent = Sidebar

    -- Container for Tabs
    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, -20, 1, -70)
    TabHolder.Position = UDim2.new(0, 10, 0, 60)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 2
    TabHolder.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabHolder

    -- Content Area
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -195, 1, -20)
    ContentHolder.Position = UDim2.new(0, 190, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    local WindowObj = {
        Tabs = {},
        ActiveTab = nil
    }

    -- Create Tab Method
    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = "   " .. tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = HexLib.CurrentTheme.Card
        TabBtn.BackgroundTransparency = 0.8
        TabBtn.TextColor3 = HexLib.CurrentTheme.TextSecondary
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabHolder
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 3
        TabPage.Parent = ContentHolder

        local PageList = Instance.new("UIListLayout")
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 10)
        PageList.Parent = TabPage

        TabBtn.MouseButton1Click:Connect(function()
            PlaySound(6895079853, 1.2)
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = HexLib.CurrentTheme.TextSecondary}):Play()
            end
            TabPage.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = HexLib.CurrentTheme.TextPrimary}):Play()
        end)

        if #WindowObj.Tabs == 0 then
            TabPage.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = HexLib.CurrentTheme.TextPrimary
        end

        local TabElements = {}
        table.insert(WindowObj.Tabs, {Btn = TabBtn, Page = TabPage})

        -- Section Creator
        function TabElements:CreateSection(sectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Text = sectionName
            SectionLabel.Size = UDim2.new(1, 0, 0, 24)
            SectionLabel.TextColor3 = HexLib.CurrentTheme.Accent
            SectionLabel.Font = Enum.Font.SourceSansBold
            SectionLabel.TextSize = 14
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Parent = TabPage

            local SectionObj = {}

            -- Button Component
            function SectionObj:CreateButton(btnText, callback)
                local Btn = Instance.new("TextButton")
                Btn.Text = btnText
                Btn.Size = UDim2.new(1, -10, 0, 38)
                Btn.BackgroundColor3 = HexLib.CurrentTheme.Card
                Btn.TextColor3 = HexLib.CurrentTheme.TextPrimary
                Btn.Font = Enum.Font.SourceSans
                Btn.TextSize = 14
                Btn.Parent = TabPage
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

                Btn.MouseButton1Click:Connect(function()
                    PlaySound(6895079853, 1.0)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -14, 0, 36)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 38)}):Play()
                    if callback then callback() end
                end)
            end

            -- Toggle Component
            function SectionObj:CreateToggle(toggleText, default, callback)
                local toggled = default or false
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 40)
                Frame.BackgroundColor3 = HexLib.CurrentTheme.Card
                Frame.Parent = TabPage
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                local Label = Instance.new("TextLabel")
                Label.Text = "   " .. toggleText
                Label.Size = UDim2.new(0.7, 0, 1, 0)
                Label.TextColor3 = HexLib.CurrentTheme.TextPrimary
                Label.Font = Enum.Font.SourceSans
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame

                local Switch = Instance.new("TextButton")
                Switch.Text = ""
                Switch.Size = UDim2.new(0, 44, 0, 22)
                Switch.Position = UDim2.new(1, -54, 0.5, -11)
                Switch.BackgroundColor3 = toggled and HexLib.CurrentTheme.Accent or Color3.fromRGB(50, 50, 60)
                Switch.Parent = Frame
                Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 18, 0, 18)
                Indicator.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Indicator.Parent = Switch
                Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

                Switch.MouseButton1Click:Connect(function()
                    PlaySound(6895079853, 1.1)
                    toggled = not toggled
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and HexLib.CurrentTheme.Accent or Color3.fromRGB(50, 50, 60)}):Play()
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                    if callback then callback(toggled) end
                end)
            end

            -- Slider Component
            function SectionObj:CreateSlider(sliderText, min, max, default, callback)
                local val = default or min
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 50)
                Frame.BackgroundColor3 = HexLib.CurrentTheme.Card
                Frame.Parent = TabPage
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                local Label = Instance.new("TextLabel")
                Label.Text = "   " .. sliderText .. " [" .. tostring(val) .. "]"
                Label.Size = UDim2.new(1, 0, 0, 25)
                Label.TextColor3 = HexLib.CurrentTheme.TextPrimary
                Label.Font = Enum.Font.SourceSans
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame

                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(0.9, 0, 0, 6)
                Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
                Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                Bar.Parent = Frame
                Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = HexLib.CurrentTheme.Accent
                Fill.Parent = Bar
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local dragging = false
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * percent)
                        Label.Text = "   " .. sliderText .. " [" .. tostring(val) .. "]"
                        Fill.Size = UDim2.new(percent, 0, 1, 0)
                        if callback then callback(val) end
                    end
                end)
            end

            -- Dropdown Component with Refresh Option
            function SectionObj:CreateDropdown(dropdownText, options, callback)
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -10, 0, 40)
                DropFrame.BackgroundColor3 = HexLib.CurrentTheme.Card
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = TabPage
                Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)

                local DropBtn = Instance.new("TextButton")
                DropBtn.Text = "   " .. dropdownText
                DropBtn.Size = UDim2.new(1, 0, 0, 40)
                DropBtn.BackgroundColor3 = HexLib.CurrentTheme.Card
                DropBtn.TextColor3 = HexLib.CurrentTheme.TextPrimary
                DropBtn.Font = Enum.Font.SourceSans
                DropBtn.TextSize = 14
                DropBtn.TextXAlignment = Enum.TextXAlignment.Left
                DropBtn.Parent = DropFrame

                local open = false
                DropBtn.MouseButton1Click:Connect(function()
                    PlaySound(6895079853, 1.0)
                    open = not open
                    local targetSize = open and UDim2.new(1, -10, 0, 40 + (#options * 30)) or UDim2.new(1, -10, 0, 40)
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                end)

                for i, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Text = opt
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.Position = UDim2.new(0, 0, 0, 40 + ((i - 1) * 30))
                    OptBtn.BackgroundColor3 = HexLib.CurrentTheme.Container
                    OptBtn.TextColor3 = HexLib.CurrentTheme.TextSecondary
                    OptBtn.Font = Enum.Font.SourceSans
                    OptBtn.TextSize = 13
                    OptBtn.Parent = DropFrame

                    OptBtn.MouseButton1Click:Connect(function()
                        PlaySound(6895079853, 1.2)
                        DropBtn.Text = "   " .. dropdownText .. " (" .. opt .. ")"
                        open = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                        if callback then callback(opt) end
                    end)
                end
            end

            return SectionObj
        end

        return TabElements
    end

    return WindowObj
end

return HexLib
