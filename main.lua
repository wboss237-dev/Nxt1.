--[[
    NXT | made by Waleed
    ESP, Speed, Noclip, Fly, Invisibility
]]

-- GUI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NXT | made by Waleed", "DarkTheme")

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Movement & Visuals")

-- ESP Toggle
local ESPEnabled = false
local ESPBoxes = {}

local function CreateESP(player)
    if player == game.Players.LocalPlayer then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = player.Character
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = player.Character
    
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "ESPName"
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
    nameTag.AlwaysOnTop = true
    nameTag.Parent = player.Character
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = nameTag
    
    ESPBoxes[player] = {box, nameTag}
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

MainSection:NewToggle("ESP Players", "Show player boxes", function(state)
    ESPEnabled = state
    if state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character then
                CreateESP(player)
            end
        end
    else
        for _, esp in pairs(ESPBoxes) do
            esp[1]:Destroy()
            esp[2]:Destroy()
        end
        ESPBoxes = {}
    end
end)

-- Speed Slider
local speedValue = 16
MainSection:NewSlider("Speed", "Walk speed", 16, 100, function(value)
    speedValue = value
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Noclip Toggle
local noclipEnabled = false
MainSection:NewToggle("Noclip", "Walk through walls", function(state)
    noclipEnabled = state
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if noclipEnabled then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Fly Toggle
local flyEnabled = false
local flySpeed = 50

MainSection:NewToggle("Fly", "Fly around", function(state)
    flyEnabled = state
    if state then
        local char = game.Players.LocalPlayer.Character
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.PlatformStand = true
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if flyEnabled then
                local camera = workspace.CurrentCamera
                local moveDirection = Vector3.new()
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                if moveDirection.Magnitude > 0 then
                    char:SetPrimaryPartCFrame(char.PrimaryPart.CFrame + moveDirection.Unit * flySpeed * 0.1)
                end
            else
                humanoid.PlatformStand = false
            end
        end)
    end
end)

-- Fly Speed Slider
MainSection:NewSlider("Fly Speed", "Fly movement speed", 10, 200, function(value)
    flySpeed = value
end)

-- Invisibility Toggle
local invisEnabled = false
MainSection:NewToggle("Invisibility", "Become invisible", function(state)
    invisEnabled = state
    local char = game.Players.LocalPlayer.Character
    
    if state then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1
            end
        end
        char.Humanoid:FindFirstChild("Health"):WaitForChild("BillboardGui").Enabled = false
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
            end
        end
        char.Humanoid:FindFirstChild("Health"):WaitForChild("BillboardGui").Enabled = true
    end
end)

-- Credits
local CreditTab = Window:NewTab("Credits")
local CreditSection = CreditTab:NewSection("NXT | made by Waleed")
CreditSection:NewLabel("Script by Waleed")
CreditSection:NewLabel("Enjoy!")
