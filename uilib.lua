local library = {}

local function CreateUI()
    -- Create the main window container
    local window = Instance.new("ScreenGui")
    window.Name = "UIWindow"
    window.Parent = game.CoreGui

    -- Main UI frame, adjusting height to make it smaller
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)  -- Made it smaller
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
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

    -- Console tab for messages
    local consoleTab = Instance.new("Frame")
    consoleTab.Size = UDim2.new(1, 0, 0.25, 0)  -- Made the console smaller
    consoleTab.Position = UDim2.new(0, 0, 0.75, 0)
    consoleTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    consoleTab.Visible = true
    consoleTab.Parent = mainFrame

    -- Text box for console output
    local consoleTextBox = Instance.new("TextBox")
    consoleTextBox.Size = UDim2.new(1, 0, 1, 0)
    consoleTextBox.BackgroundTransparency = 1
    consoleTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    consoleTextBox.TextSize = 14
    consoleTextBox.TextWrap = true
    consoleTextBox.Text = ""
    consoleTextBox.ClearTextOnFocus = false
    consoleTextBox.Parent = consoleTab

    -- Hide and Show the UI on minimize button click
    local uiVisible = true
    minimizeButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
    end)

    -- Store the UI elements in the library for later access
    library.mainFrame = mainFrame
    library.consoleTextBox = consoleTextBox

    -- Create a toggle function
    function library:AddToggle(name, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)  -- Adjusted the size to be more compact
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
        toggleButton.Size = UDim2.new(0, 80, 1, 0)
        toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        toggleButton.Parent = toggleFrame

        toggleButton.MouseButton1Click:Connect(function()
            local state = toggleButton.Text == "OFF"
            toggleButton.Text = state and "ON" or "OFF"
            callback(state)
        end)
    end

    -- Create a dropdown function for selections
    function library:AddDropdown(name, options, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 40)  -- Made it more compact
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
        dropdownButton.Position = UDim2.new(0.8, 0, 0, 0)
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
            optionButton.Size = UDim2.new(1, 0, 0, 30)  -- Adjusted height of options
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

    -- Function to add the console log output
    function library:Log(message)
        consoleTextBox.Text = consoleTextBox.Text .. "\n" .. message
        consoleTextBox.Text = consoleTextBox.Text:sub(1, 2000) -- Limit to last 2000 characters to avoid overflow
    end

    return window
end

library.CreateWindow = CreateUI
return library
