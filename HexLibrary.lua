--[[
    Hex Scripts UI Library
    Author: IssacPrada (Issac Mckenney)
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local HexLib = {
    Themes = {
        BlackRed = {
            Background = Color3.fromRGB(12, 12, 16),
            Sidebar = Color3.fromRGB(18, 18, 24),
            Container = Color3.fromRGB(24, 24, 32),
            Card = Color3.fromRGB(30, 30, 40),
            Accent = Color3.fromRGB(225, 45, 65),
            GradientStart = Color3.fromRGB(225, 45, 65),
            GradientEnd = Color3.fromRGB(20, 20, 26),
            TextPrimary = Color3.fromRGB(245, 245, 250),
            TextSecondary = Color3.fromRGB(140, 140, 155)
        }
    },
    CurrentTheme = nil,
    LogoId = "rbxthumb://type=Asset&id=86138979087018&w=420&h=420"
}

HexLib.CurrentTheme = HexLib.Themes.BlackRed

local function PlaySound(id, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = 0.4
    sound.PlaybackSpeed = pitch or 1
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

-- Smooth Dragging System Utility
local function MakeDraggable(gui, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or gui

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(gui, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- Notification Toast Function
function HexLib:Notify(title, description, duration)
    local NotifyGui = CoreGui:FindFirstChild("HexNotifications")
    if not NotifyGui then
        NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Name = "HexNotifications"
        NotifyGui.Parent = CoreGui
    end

    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(0, 280, 0, 70)
    Toast.Position = UDim2.new(1, 10, 1, -90)
    Toast.BackgroundColor3 = HexLib.CurrentTheme.Container
    Toast.BorderSizePixel = 0
    Toast.Parent = NotifyGui
    Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 10)

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = HexLib.CurrentTheme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Toast
    Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 4)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title or "Notification"
    TitleLabel.Size = UDim2.new(1, -20, 0, 24)
    TitleLabel.Position = UDim2.new(0, 14, 0, 8)
    TitleLabel.TextColor3 = HexLib.CurrentTheme.TextPrimary
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Toast

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = description or ""
    DescLabel.Size = UDim2.new(1, -20, 0, 30)
    DescLabel.Position = UDim2.new(0, 14, 0, 30)
    DescLabel.TextColor3 = HexLib.CurrentTheme.TextSecondary
    DescLabel.Font = Enum.Font.SourceSans
    DescLabel.TextSize = 12
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.BackgroundTransparency = 1
    DescLabel.Parent = Toast

    PlaySound(6895079853, 1.2)
    TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -295, 1, -90)}):Play()

    task.delay(duration or 4, function()
        if Toast.Parent then
            TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 10, 1, -90)}):Play()
            task.wait(0.3)
            Toast:Destroy()
        end
    end)
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

    MakeDraggable(Frame)

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
    IntroFrame.Size = UDim2.new(0, 240, 0, 240)
    IntroFrame.Position = UDim2.new(0.5, -120, 0.5, -120)
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

    HexLib:Notify("Loaded " .. TitleText, "Welcome back, " .. LocalPlayer.Name .. "!", 5)

    -- Main Frame Setup
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 720, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
    MainFrame.BackgroundColor3 = HexLib.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Gui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- Ambient Black/Red Gradient
    local AmbientGradient = Instance.new("UIGradient")
    AmbientGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, HexLib.CurrentTheme.GradientStart),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 12, 16)),
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

    -- Floating Toggle Button
    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Name = "HexToggleBtn"
    OpenBtn.Image = HexLib.LogoId
    OpenBtn.Size = UDim2.new(0, 48, 0, 48)
    OpenBtn.Position = UDim2.new(0, 20, 1, 100)
    OpenBtn.BackgroundColor3 = HexLib.CurrentTheme.Container
    OpenBtn.Parent = Gui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    MakeDraggable(OpenBtn)
    
    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = HexLib.CurrentTheme.Accent
    OpenStroke.Thickness = 2
    OpenStroke.Parent = OpenBtn

    local savedPos = MainFrame.Position
    local isOpen = true

    local function ToggleWindow(state)
        isOpen = (state ~= nil) and state or not isOpen
        if isOpen then
            PlaySound(6895079853, 1.1)
            TweenService:Create(OpenBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 1, 100)}):Play()
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = savedPos}):Play()
        else
            savedPos = MainFrame.Position
            PlaySound(6895079853, 0.9)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset, 1.2, 0)}):Play()
            TweenService:Create(OpenBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 1, -68)}):Play()
        end
    end

    OpenBtn.MouseButton1Click:Connect(function()
        ToggleWindow(true)
    end)

    -- Top Drag Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    MakeDraggable(MainFrame, TopBar)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "×"
    CloseBtn.Size = UDim2.new(0, 32, 0, 24)
    CloseBtn.Position = UDim2.new(1, -38, 0, 6)
    CloseBtn.BackgroundColor3 = HexLib.CurrentTheme.Card
    CloseBtn.TextColor3 = HexLib.CurrentTheme.TextPrimary
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        ToggleWindow(false)
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = HexLib.CurrentTheme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
    MakeDraggable(MainFrame, Sidebar)

    local SidebarLogo = Instance.new("ImageLabel")
    SidebarLogo.Image = HexLib.LogoId
    SidebarLogo.Size = UDim2.new(0, 28, 0, 28)
    SidebarLogo.Position = UDim2.new(0, 14, 0, 14)
    SidebarLogo.BackgroundTransparency = 1
    SidebarLogo.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = TitleText
    TitleLabel.Size = UDim2.new(0, 130, 0, 18)
    TitleLabel.Position = UDim2.new(0, 50, 0, 12)
    TitleLabel.TextColor3 = HexLib.CurrentTheme.TextPrimary
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Sidebar

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Text = SubTitleText
    SubTitleLabel.Size = UDim2.new(0, 130, 0, 14)
    SubTitleLabel.Position = UDim2.new(0, 50, 0, 30)
    SubTitleLabel.TextColor3 = HexLib.CurrentTheme.TextSecondary
    SubTitleLabel.Font = Enum.Font.SourceSans
    SubTitleLabel.TextSize = 12
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Parent = Sidebar

    -- User Profile Card (Matches Image 1 layout)
    local UserCard = Instance.new("Frame")
    UserCard.Size = UDim2.new(1, -20, 0, 54)
    UserCard.Position = UDim2.new(0, 10, 1, -64)
    UserCard.BackgroundColor3 = HexLib.CurrentTheme.Container
    UserCard.Parent = Sidebar
    Instance.new("UICorner", UserCard).CornerRadius = UDim.new(0, 8)

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
    AvatarImg.Size = UDim2.new(0, 36, 0, 36)
    AvatarImg.Position = UDim2.new(0, 9, 0.5, -18)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Parent = UserCard
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

    local DisplayNameLabel = Instance.new("TextLabel")
    DisplayNameLabel.Text = LocalPlayer.DisplayName
    DisplayNameLabel.Size = UDim2.new(1, -54, 0, 18)
    DisplayNameLabel.Position = UDim2.new(0, 52, 0, 10)
    DisplayNameLabel.TextColor3 = HexLib.CurrentTheme.TextPrimary
    DisplayNameLabel.Font = Enum.Font.SourceSansBold
    DisplayNameLabel.TextSize = 13
    DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayNameLabel.BackgroundTransparency = 1
    DisplayNameLabel.Parent = UserCard

    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Text = "@" .. LocalPlayer.Name
    UsernameLabel.Size = UDim2.new(1, -54, 0, 14)
    UsernameLabel.Position = UDim2.new(0, 52, 0, 28)
    UsernameLabel.TextColor3 = HexLib.CurrentTheme.TextSecondary
    UsernameLabel.Font = Enum.Font.SourceSans
    UsernameLabel.TextSize = 11
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Parent = UserCard

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, -20, 1, -135)
    TabHolder.Position = UDim2.new(0, 10, 0, 58)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 2
    TabHolder.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabHolder

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -215, 1, -50)
    ContentHolder.Position = UDim2.new(0, 210, 0, 40)
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
