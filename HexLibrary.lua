--[[
    Hex Scripts UI Library
    Author: IssacPrada (Issac Mckenney)
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

local function PlaySound(id, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = 0.4
    sound.PlaybackSpeed = pitch or 1
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

function HexLib:KeySystem(validKeys, onSuccess)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "HexKeySystem"
    KeyGui.Parent = CoreGui
    
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 24
    Blur.Parent = Lighting

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 380, 0, 230)
    Frame.Position = UDim2.new(0.5, -190, 0.5, -115)
    Frame.BackgroundColor3 = HexLib.CurrentTheme.Container
    Frame.BorderSizePixel = 0
    Frame.Parent = KeyGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Text = "Hex Scripts - Key Verification"
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.TextColor3 = HexLib.CurrentTheme.TextPrimary
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local TextBox = Instance.new("TextBox")
    TextBox.PlaceholderText = "Enter Access Key..."
    TextBox.Size = UDim2.new(0.85, 0, 0, 42)
    TextBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    TextBox.BackgroundColor3 = HexLib.CurrentTheme.Card
    TextBox.TextColor3 = HexLib.CurrentTheme.TextPrimary
    TextBox.PlaceholderColor3 = HexLib.CurrentTheme.TextSecondary
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 16
    TextBox.Parent = Frame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Text = "Verify Key"
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 42)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.62, 0)
    SubmitBtn.BackgroundColor3 = HexLib.CurrentTheme.Accent
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.SourceSansBold
    SubmitBtn.TextSize = 16
    SubmitBtn.Parent = Frame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

    SubmitBtn.MouseButton1Click:Connect(function()
        PlaySound(6895079853, 1.1)
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

function HexLib:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "Hex Scripts"
    local SubTitleText = config.SubTitle or "v1.0.0"

    -- Screen Blur & Intro Sequence
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = Lighting
    TweenService:Create(Blur, TweenInfo.new(0.8), {Size = 22}):Play()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "HexWindowGui"
    Gui.Parent = CoreGui

    local IntroFrame = Instance.new("Frame")
    IntroFrame.Size = UDim2.new(0, 220, 0, 220)
    IntroFrame.Position = UDim2.new(0.5, -110, 0.5, -110)
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

    PlaySound(9114223179, 1.0)
    TweenService:Create(Logo, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {ImageTransparency = 0}):Play()
    task.wait(0.6)
    
    TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -45)}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()
    task.wait(1.4)

    TweenService:Create(Logo, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
    task.wait(0.5)
    IntroFrame:Destroy()
    Blur:Destroy()

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 700, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -220)
    MainFrame.BackgroundColor3 = HexLib.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Gui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- Ambient Gradient Turning Red
    local AmbientGradient = Instance.new("UIGradient")
    AmbientGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, HexLib.CurrentTheme.GradientStart),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 20, 35)),
        ColorSequenceKeypoint.new(1, HexLib.CurrentTheme.Background)
    })
    AmbientGradient.Rotation = 45
    AmbientGradient.Parent = MainFrame

    task.spawn(function()
        local rot = 45
        while MainFrame.Parent do
            rot = (rot + 1) % 360
            AmbientGradient.Rotation = rot
            task.wait(0.04)
        end
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 190, 1, 0)
    Sidebar.BackgroundColor3 = HexLib.CurrentTheme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local BrandLogo = Instance.new("ImageLabel")
    BrandLogo.Image = HexLib.LogoId
    BrandLogo.Size = UDim2.new(0, 32, 0, 32)
    BrandLogo.Position = UDim2.new(0, 15, 0, 16)
    BrandLogo.BackgroundTransparency = 1
    BrandLogo.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = TitleText
    TitleLabel.Size = UDim2.new(0, 120, 0, 20)
    TitleLabel.Position = UDim2.new(0, 56, 0, 14)
    TitleLabel.TextColor3 = HexLib.CurrentTheme.TextPrimary
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Sidebar

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Text = SubTitleText
    SubTitleLabel.Size = UDim2.new(0, 120, 0, 15)
    SubTitleLabel.Position = UDim2.new(0, 56, 0, 32)
    SubTitleLabel.TextColor3 = HexLib.CurrentTheme.TextSecondary
    SubTitleLabel.Font = Enum.Font.SourceSans
    SubTitleLabel.TextSize = 12
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Parent = Sidebar

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, -20, 1, -75)
    TabHolder.Position = UDim2.new(0, 10, 0, 65)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 2
    TabHolder.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabHolder

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -205, 1, -20)
    ContentHolder.Position = UDim2.new(0, 200, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    local WindowObj = { Tabs = {} }

    function WindowObj:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = "   " .. tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
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

            function SectionObj:CreateSlider(sliderText, min, max, default, callback)
                local val = default or min
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 52)
                Frame.BackgroundColor3 = HexLib.CurrentTheme.Card
                Frame.Parent = TabPage
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                local Label = Instance.new("TextLabel")
                Label.Text = "   " .. sliderText .. " [" .. tostring(val) .. "]"
                Label.Size = UDim2.new(1, 0, 0, 26)
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

            function SectionObj:CreateTextbox(textboxText, placeholder, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 48)
                Frame.BackgroundColor3 = HexLib.CurrentTheme.Card
                Frame.Parent = TabPage
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                local Label = Instance.new("TextLabel")
                Label.Text = "   " .. textboxText
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.TextColor3 = HexLib.CurrentTheme.TextPrimary
                Label.Font = Enum.Font.SourceSans
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame

                local Box = Instance.new("TextBox")
                Box.PlaceholderText = placeholder or "Type here..."
                Box.Size = UDim2.new(0.55, 0, 0, 32)
                Box.Position = UDim2.new(0.42, 0, 0.5, -16)
                Box.BackgroundColor3 = HexLib.CurrentTheme.Container
                Box.TextColor3 = HexLib.CurrentTheme.TextPrimary
                Box.PlaceholderColor3 = HexLib.CurrentTheme.TextSecondary
                Box.Font = Enum.Font.SourceSans
                Box.TextSize = 13
                Box.Parent = Frame
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

                Box.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then callback(Box.Text) end
                end)
            end

            function SectionObj:CreateKeybind(keybindText, defaultKey, callback)
                local selectedKey = defaultKey or Enum.KeyCode.F
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 40)
                Frame.BackgroundColor3 = HexLib.CurrentTheme.Card
                Frame.Parent = TabPage
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                local Label = Instance.new("TextLabel")
                Label.Text = "   " .. keybindText
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.TextColor3 = HexLib.CurrentTheme.TextPrimary
                Label.Font = Enum.Font.SourceSans
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Text = selectedKey.Name
                KeyBtn.Size = UDim2.new(0, 90, 0, 26)
                KeyBtn.Position = UDim2.new(1, -100, 0.5, -13)
                KeyBtn.BackgroundColor3 = HexLib.CurrentTheme.Container
                KeyBtn.TextColor3 = HexLib.CurrentTheme.Accent
                KeyBtn.Font = Enum.Font.SourceSansBold
                KeyBtn.TextSize = 13
                KeyBtn.Parent = Frame
                Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)

                local binding = false
                KeyBtn.MouseButton1Click:Connect(function()
                    PlaySound(6895079853, 1.0)
                    binding = true
                    KeyBtn.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input, gp)
                    if binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            selectedKey = input.KeyCode
                            KeyBtn.Text = selectedKey.Name
                            binding = false
                        end
                    elseif not gp and input.KeyCode == selectedKey then
                        if callback then callback(selectedKey) end
                    end
                end)
            end

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
