local library = {}

-- Creating UI elements
local function CreateUI()
    -- Create main window container (make it smaller in height)
    local window = Instance.new("ScreenGui")
    window.Name = "UIWindow"
    window.Parent = game.CoreGui

    -- Main UI frame, adjusted height for smaller size
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 250)  -- Made it even smaller (300x250)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = window

    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Text = "_"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -35, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    minimizeButton.Parent = mainFrame

    -- Console tab
    local consoleTab = Instance.new("Frame")
    consoleTab.Size = UDim2.new(1, 0, 0.2, 0)  -- Reduced console area height
    consoleTab.Position = UDim2.new(0, 0, 0.8, 0)
    consoleTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    consoleTab.Visible = true
    consoleTab.Parent = mainFrame

    -- Console output textbox
    local consoleTextBox = Instance.new("TextBox")
    consoleTextBox.Size = UDim2.new(1, 0, 1, 0)
    consoleTextBox.BackgroundTransparency = 1
    consoleTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    consoleTextBox.TextSize = 14
    consoleTextBox.TextWrap = true
    consoleTextBox.Text = ""
    consoleTextBox.ClearTextOnFocus = false
    consoleTextBox.Parent = consoleTab

    -- Handle the minimize button functionality
    local uiVisible = true
    minimizeButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
    end)

    -- Store elements in the library
    library.mainFrame = mainFrame
    library.consoleTextBox = consoleTextBox

    -- Create a Toggle button
    function library:AddToggle(name, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)  -- Smaller toggle button
        toggleFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        toggleFrame.Parent = mainFrame

        local label = Instance.new("TextLabel")
        label.Text = name
        label.Size = UDim2.new(0, 100, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Parent = toggleFrame

        local toggleButton = Instance.new("TextButton")
        toggleButton.Text = "OFF"
        toggleButton.Size = UDim2.new(0, 50, 1, 0)
        toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        toggleButton.Parent = toggleFrame

        toggleButton.MouseButton1Click:Connect(function()
            local state = toggleButton.Text == "OFF"
            toggleButton.Text = state and "ON" or "OFF"
            callback(state)
        end)
    end

    -- Create a Dropdown menu for selection
    function library:AddDropdown(name, options, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 30)  -- Reduced height for dropdown
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        dropdownFrame.Parent = mainFrame

        local label = Instance.new("TextLabel")
        label.Text = name
        label.Size = UDim2.new(0, 100, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Parent = dropdownFrame

        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Text = "Select"
        dropdownButton.Size = UDim2.new(0, 80, 1, 0)
        dropdownButton.Position = UDim2.new(0.7, 0, 0, 0)
        dropdownButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        dropdownButton.Parent = dropdownFrame

        local optionList = Instance.new("ScrollingFrame")
        optionList.Size = UDim2.new(1, 0, 0, 0)
        optionList.Position = UDim2.new(0, 0, 1, 0)
        optionList.BackgroundTransparency = 1
        optionList.ScrollBarThickness = 4
        optionList.Visible = false
        optionList.Parent = dropdownFrame

        for _, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Text = option
            optionButton.TextSize = 14
            optionButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            optionButton.Parent = optionList

            optionButton.MouseButton1Click:Connect(function()
                dropdownButton.Text = option
                optionList.Visible = false
                callback(option)
            end)
        end

        dropdownButton.MouseButton1Click:Connect(function()
            optionList.Visible = not optionList.Visible
        end)
    end

    -- Console log output method
    function library:Log(message)
        consoleTextBox.Text = consoleTextBox.Text .. "\n" .. message
        consoleTextBox.Text = consoleTextBox.Text:sub(1, 2000) -- Keep within a character limit
    end

    return window
end

library.CreateWindow = CreateUI
return library
