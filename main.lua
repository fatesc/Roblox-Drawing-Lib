local Drawing = {}
newcclosure = newcclosure or function(f)
    return f
end


local Workspace = game:GetService("Workspace");
local Camera = Workspace:FindFirstChild("Camera");
local CoreGui = game:GetService("CoreGui");

local WorldToScreen = Camera.WorldToScreenPoint

local BaseDrawingProperties = setmetatable({
    Visible = false,
    Color = Color3.new(),
    Transparency = 0,
    Remove = function()
    end
}, {
    __add = function(tbl1, tbl2)
        local new = {}
        for i, v in next, tbl1 do
            new[i] = v
        end
        for i, v in next, tbl2 do
            new[i] = v
        end
        return new
    end
})

Drawing.new = function(Type, UI)
    UI = UI and UI:IsA("ScreenGui") and UI or Instance.new("ScreenGui", CoreGui) or Instance.new("ScreenGui", CoreGui);

    if (Type == "Line") then
        local LineProperties = ({
            To = Vector2.new(),
            From = Vector2.new(),
            Thickness = 1,
        } + BaseDrawingProperties)

        local LineFrame = Instance.new("Frame");
        LineFrame.AnchorPoint = Vector2.new(0.5, 0.5);
        LineFrame.BorderSizePixel = 0

        LineFrame.BackgroundColor3 = LineProperties.Color
        LineFrame.Visible = LineProperties.Visible
        LineFrame.BackgroundTransparency = LineProperties.Transparency


        LineFrame.Parent = UI

        return setmetatable({}, {
            __newindex = newcclosure(function(Instance_, Property, Value)
                if (Property == "To") then
                    local To = Value
                    local Direction = (To - LineProperties.From);
                    local Center = (To + LineProperties.From) / 2
                    local Distance = Direction.Magnitude
                    local Theta = math.atan2(Direction.Y, Direction.X);

                    LineFrame.Position = UDim2.fromOffset(Center.X, Center.Y);
                    LineFrame.Rotation = math.deg(Theta);
                    LineFrame.Size = UDim2.fromOffset(Distance, LineProperties.Thickness);

                    LineProperties.To = To
                end
                if (Property == "From") then
                    local From = Value
                    local Direction = (LineProperties.To - From);
                    local Center = (LineProperties.To + From) / 2
                    local Distance = Direction.Magnitude
                    local Theta = math.atan2(Direction.Y, Direction.X);

                    LineFrame.Position = UDim2.fromOffset(Center.X, Center.Y);
                    LineFrame.Rotation = math.deg(Theta);
                    LineFrame.Size = UDim2.fromOffset(Distance, LineProperties.Thickness);


                    LineProperties.From = From
                end
                if (Property == "Visible") then
                    LineFrame.Visible = Value
                    LineProperties.Visible = Value
                end
                if (Property == "Thickness") then
                    Value = Value < 1 and 1 or Value

                    local Direction = (LineProperties.To - LineProperties.From);
                    local Distance = Direction.Magnitude

                    LineFrame.Size = UDim2.fromOffset(Distance, Value);

                    LineProperties.Thickness = Value
                end
                if (Property == "Transparency") then
                    LineFrame.BackgroundTransparency = 1 - Value
                    LineProperties.Transparency = Value
                end
                if (Property == "Color") then
                    LineFrame.BackgroundColor3 = Value
                    LineProperties.Color = Value 
                end
                if (Property == "Position") then
                    LineFrame.Position = Value
                end
            end),
            __index = newcclosure(function(Instance_, Property)
                if (Property == "Remove") then
                    return newcclosure(function()
                        LineFrame:Destroy();
                    end)
                end
                return LineProperties[Property]
            end)
        })
    end

    if (Type == "Circle") then
        local CircleProperties = ({
            Radius = 150,
            Filled = false,
            Position = Vector2.new()
        } + BaseDrawingProperties)

        local CircleFrame = Instance.new("Frame");

        CircleFrame.AnchorPoint = Vector2.new(0.5, 0.5);
        CircleFrame.BorderSizePixel = 0

        CircleFrame.BackgroundColor3 = CircleProperties.Color
        CircleFrame.Visible = CircleProperties.Visible
        CircleFrame.BackgroundTransparency = CircleProperties.Transparency

        local Corner = Instance.new("UICorner", CircleFrame);
        Corner.CornerRadius = UDim.new(1, 0);
        CircleFrame.Size = UDim2.new(0, CircleProperties.Radius, 0, CircleProperties.Radius);

        CircleFrame.Parent = UI

        return setmetatable({}, {
            __newindex = newcclosure(function(Instance_, Property, Value)
                if (Property == "Radius") then
                    CircleFrame.Size = UDim2.new(0, Value, 0, Value);
                    CircleProperties.Radius = Value
                end
                if (Property == "Position") then
                    CircleFrame.Position = UDim2.new(0, Value.X, 0, Value.Y);
                    CircleProperties.Position = Value
                end
                if (Property == "Filled") then
                    CircleFrame.BackgroundTransparency = Value == true and 0 or 0.8
                    CircleProperties.Filled = Value
                end
                if (Property == "Color") then
                    CircleFrame.BackgroundColor3 = Value
                    CircleProperties.Color = Value
                end
                if (Property == "Visible") then
                    CircleFrame.Visible = Value
                    CircleProperties.Visible = Value
                end
                if (Property == "Transparency") then

                end
            end),
            __index = newcclosure(function(Instance_, Property)
                if (Property == "Remove") then
                    return newcclosure(function()
                        CircleFrame:Destroy();
                    end)
                end

                return CircleProperties[Property]
            end)
        })
    end

    if (Type == "Text") then
        local TextProperties = ({
            Text = "",
            Size = 0,
            Center = false,
            Outline = false,
            OutlineColor = Color3.new(),
            Position = Vector2.new(),
        } + BaseDrawingProperties)

        local TextLabel = Instance.new("TextLabel");

        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.BorderSizePixel = 0
        TextLabel.Size = UDim2.new(0, 200, 0, 50);
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.TextSize = 14

        TextLabel.TextColor3 = TextProperties.Color
        TextLabel.Visible = TextProperties.Visible
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextTransparency = 1 - TextProperties.Transparency

        TextLabel.Parent = UI

        return setmetatable({}, {
            __newindex = newcclosure(function(Instance_, Property, Value)
                if (Property == "Text") then
                    TextLabel.Text = Value
                    TextProperties.Text = Value
                end
                if (Property == "Position") then
                    TextLabel.Position = UDim2.new(0, Value.X, 0, Value.Y);
                    TextProperties.Position = Value
                end
                if (Property == "Size") then
                    TextLabel.TextSize = Value
                    TextProperties.Size = Value
                end
                if (Property == "Color") then
                    TextLabel.TextColor3 = Value
                    TextProperties.Color = Value
                end
                if (Property == "Transparency") then
                    TextLabel.TextTransparency = 1 - Value
                    TextProperties.Transparency = Value
                end
                if (Property == "Visible") then
                    TextLabel.Visible = Value
                    TextProperties.Visible = Value
                end
                if (Property == "Center") then
                    TextLabel.Position = Value == true and UDim2.new(0, Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2, 0)
                    TextProperties.Center = Value
                end
            end),
            __index = newcclosure(function(Instance_, Property)
                if (Property == "Remove") then
                    return newcclosure(function()
                        TextLabel:Destroy();
                    end)
                end

                return TextProperties[Property]
            end)
        })
    end

    if (Type == "Square") then
        local SquareProperties = ({
            Size = 150,
            Filled = true,
            Position = Vector2.new()
        } + BaseDrawingProperties)

        local SquareFrame = Instance.new("Frame");

        SquareFrame.AnchorPoint = Vector2.new(0.5, 0.5);
        SquareFrame.BorderSizePixel = 0

        SquareFrame.BackgroundColor3 = SquareProperties.Color
        SquareFrame.Visible = SquareProperties.Visible
        SquareFrame.BackgroundTransparency = SquareProperties.Transparency

        SquareFrame.Parent = UI

        return setmetatable({}, {
            __newindex = newcclosure(function(Instance_, Property, Value)
            if (Property == "Size") then
                    SquareFrame.Size = UDim2.new(0, Value, 0, Value);
                    SquareProperties.Size = Value
                end
                if (Property == "Position") then
                    SquareFrame.Position = UDim2.new(0, Value.X, 0, Value.Y);
                    SquareProperties.Position = Value
                end
                if (Property == "Filled") then
                    SquareFrame.BackgroundTransparency = Value == true and 0 or 0.8
                    SquareProperties.Filled = Value
                end
                if (Property == "Color") then
                    SquareFrame.BackgroundColor3 = Value
                    SquareProperties.Color = Value
                end
                if (Property == "Visible") then
                    SquareFrame.Visible = Value
                    SquareProperties.Visible = Value
                end
                if (Property == "Transparency") then

                end
                if (Property == "Color") then
                    SquareFrame.BackgroundColor3 = Value
                    SquareProperties.Color = Value
                end
            end),
            __index = newcclosure(function(Instance_, Property)
                if (Property == "Remove") then
                    return newcclosure(function()
                        SquareFrame:Destroy();
                    end)
                end

                return SquareProperties[Property]
            end)
        })
    end

    if (Type == "Quad") then -- will add later
        return setmetatable({}, {

        });  
    end
end
