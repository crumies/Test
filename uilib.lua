local library = {
    windowcount = 0;
}

local dragger = {};
local resizer = {};

do
    local mouse = game:GetService("Players").LocalPlayer:GetMouse();
    local inputService = game:GetService('UserInputService');
    local heartbeat = game:GetService("RunService").Heartbeat;
    
    function dragger.new(frame)
        local s, event = pcall(function()
            return frame.MouseEnter
        end)

        if s then
            frame.Active = true;

            event:connect(function()
                local input;
                input = frame.InputBegan:connect(function(key)
                    if key.UserInputType == Enum.UserInputType.MouseButton1 or key.UserInputType == Enum.UserInputType.Touch then
                        local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y);
                        while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X + (frame.Size.X.Offset * frame.AnchorPoint.X), 0, mouse.Y - objectPosition.Y + (frame.Size.Y.Offset * frame.AnchorPoint.Y)), 'Out', 'Quad', 0.1, true);
                        end
                    end
                end)

                local leave;
                leave = frame.MouseLeave:connect(function()
                    input:disconnect();
                    leave:disconnect();
                end)
            end)
        end
    end

    function resizer.new(p, s)
        p:GetPropertyChangedSignal('AbsoluteSize'):connect(function()
            s.Size = UDim2.new(s.Size.X.Scale, s.Size.X.Offset, s.Size.Y.Scale, p.AbsoluteSize.Y);
        end)
    end
end

local defaults = {
    txtcolor = Color3.fromRGB(255, 255, 255),
    underline = Color3.fromRGB(0, 255, 140),
    barcolor = Color3.fromRGB(40, 40, 40),
    bgcolor = Color3.fromRGB(30, 30, 30),
}

function library:Create(class, props)
    local object = Instance.new(class);

    for i, prop in next, props do
        if i ~= "Parent" then
            object[i] = prop;
        end
    end

    object.Parent = props.Parent;
    return object;
end

function library:CreateWindow(options)
    assert(options.text, "no name");
    local window = {
        count = 0;
        toggles = {},
        closed = false;
    }

    local options = options or {};
    setmetatable(options, {__index = defaults})

    self.windowcount = self.windowcount + 1;

    library.gui = library.gui or self:Create("ScreenGui", {Name = "UILibrary", Parent = game:GetService("CoreGui")})
    
    window.frame = self:Create("Frame", {
        Name = options.text;
        Parent = self.gui,
        Active = true,
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 190, 0, 30),
        Position = UDim2.new(0, (15 + ((200 * self.windowcount) - 200)), 0, 15),
        BackgroundColor3 = options.barcolor,
        BorderSizePixel = 0;
    })

    window.background = self:Create('Frame', {
        Name = 'Background';
        Parent = window.frame,
        BorderSizePixel = 0;
        BackgroundColor3 = options.bgcolor,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 25),
        ClipsDescendants = true;
    })

    window.container = self:Create('Frame', {
        Name = 'Container';
        Parent = window.frame,
        BorderSizePixel = 0;
        BackgroundColor3 = options.bgcolor,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 25),
        ClipsDescendants = true;
    })

    window.organizer = self:Create('UIListLayout', {
        Name = 'Sorter';
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = window.container;
    })

    window.padder = self:Create('UIPadding', {
        Name = 'Padding';
        PaddingLeft = UDim.new(0, 10);
        PaddingTop = UDim.new(0, 5);
        Parent = window.container;
    })
    self:Create("Frame", {
        Name = 'Underline';
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BorderSizePixel = 0;
        BackgroundColor3 = options.underline;
        Parent = window.frame
    })

    local togglebutton = self:Create("TextButton", {
        Name = 'Toggle';
        ZIndex = 2,
        BackgroundTransparency = 1;
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Text = "-",
        TextSize = 17,
        TextColor3 = options.txtcolor,
        Font = Enum.Font.FredokaOne;
        Parent = window.frame,
    })
    togglebutton.MouseButton1Click:connect(function()
        window.closed = not window.closed
        togglebutton.Text = (window.closed and "+" or "-")
        if window.closed then
            window:Resize(true, UDim2.new(1, 0, 0, 0))
        else
            window:Resize(true)
        end
    end)

    self:Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        TextColor3 = options.txtcolor,
        TextColor3 = (options.bartextcolor or Color3.fromRGB(255, 255, 255));
        TextSize = 17,
        Font = Enum.Font.FredokaOne;
        Text = options.text or "window",
        Name = "Window",
        Parent = window.frame,
    })

    -- Dragger and Resizer Setup
    dragger.new(window.frame)
    resizer.new(window.background, window.container);

    local function getSize()
        local ySize = 0;
        for i, object in next, window.container:GetChildren() do
            if (not object:IsA('UIListLayout')) and (not object:IsA('UIPadding')) then
                ySize = ySize + object.AbsoluteSize.Y
            end
        end
        return UDim2.new(1, 0, 0, ySize + 10)
    end

    function window:Resize(tween, change)
        local size = change or getSize()
        self.container.ClipsDescendants = true;

        if tween then
            self.background:TweenSize(size, "Out", "Sine", 0.5, true)
        else
            self.background.Size = size
        end
    end

    -- Add other functional methods like AddButton, AddLabel, etc.
   
    return window
end

return library
