-- Custom UI Library Code (Enhanced Version)
local UI = {}
local activeWindow
local minimized = false

-- Utility to create instances
function UI:Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Window Setup (with Tabs, Close & Minimize Button, Console)
function UI:CreateWindow(title)
    -- Main ScreenGui window setup
    local window = self:Create("ScreenGui", {
        Name = title,
        DisplayOrder = 100,
        Enabled = true,
    })
    activeWindow = window
    
    -- Window frame
    local windowFrame = self:Create("Frame", {
        Parent = window,
        Position = UDim2.new(0.5, -150, 0.5, -200),
        Size = UDim2.new(0, 300, 0, 400),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Visible = not minimized
    })
    
    -- Title bar with Close and Minimize buttons
    local titleBar = self:Create("Frame", {
        Parent = windowFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    })
    
    local titleLabel = self:Create("TextLabel", {
        Parent = titleBar,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.8, 0, 1, 0),
        Text = title,
        TextSize = 24,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    -- Close button
    local closeButton = self:Create("TextButton", {
        Parent = titleBar,
        Position = UDim2.new(0.9, 0, 0, 0),
        Size = UDim2.new(0.1, 0, 1, 0),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 0, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        TextSize = 18,
    })
    
    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- Minimize button
    local minimizeButton = self:Create("TextButton", {
        Parent = titleBar,
        Position = UDim2.new(0.8, 0, 0, 0),
        Size = UDim2.new(0.1, 0, 1, 0),
        Text = "_",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        TextSize = 18,
    })
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = true
        windowFrame.Visible = false
        self:ShowOpenButton()  -- Show open button when minimized
    end)

    return window, windowFrame
end

-- Open Button (used after minimizing the window)
function UI:ShowOpenButton()
    local openButton = self:Create("TextButton", {
        Parent = activeWindow,
        Position = UDim2.new(0.5, -50, 0.2, 0),  -- Positioned in the center but a little up
        Size = UDim2.new(0, 100, 0, 40),
        Text = "Open UI",
        BackgroundColor3 = Color3.fromRGB(0, 255, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
    })
    
    openButton.MouseButton1Click:Connect(function()
        minimized = false
        activeWindow:ClearAllChildren()
        self:CreateWindow("Sample UI Window") -- reopen the main window UI with "Sample UI Window"
        openButton:Destroy()
    end)
end

-- Adding a Tab
function UI:AddTab(windowFrame, tabName)
    local tab = self:Create("Frame", {
        Parent = windowFrame,
        Size = UDim2.new(0, 300, 0, 50),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
    })
    
    local tabButton = self:Create("TextButton", {
        Parent = tab,
        Size = UDim2.new(1, 0, 1, 0),
        Text = tabName,
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(0, 255, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
    })
    
    return tab
end

-- Console
function UI:CreateConsole(windowFrame)
    local consoleFrame = self:Create("ScrollingFrame", {
        Parent = windowFrame,
        Position = UDim2.new(0, 0, 0.9, 0),
        Size = UDim2.new(1, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 1000),
        ScrollBarThickness = 8
    })
    
    local outputText = self:Create("TextLabel", {
        Parent = consoleFrame,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextWrapped = true,
    })

    function UI:AddToConsole(message)
        outputText.Text = outputText.Text .. message .. "\n"
    end

    return consoleFrame
end

return UI
