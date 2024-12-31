local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait 

local Rizuki = library:CreateWindow({
Name = "Rizuki",
Themeable = {
Info = "Dahood lock script."
}
})

local GeneralTab = Rizuki:CreateTab({
Name = "General"
})
local Camlock = GeneralTab:CreateSection({
Name = "Camlock"
})
Camlock:AddToggle({
Name = "Enabled",
Flag = "uwu_camlocktoggle",
Keybind = 1,
Callback = print
})
Camlock:AddSlider({
Name = "PredictionX",
Flag = "uwu_predictionX",
Value = 0.15,
Precise = 2,
Min = 0,
Max = 1
})
Camlock:AddSlider({
Name = "PredictionY",
Flag = "uwu_predictionY",
Value = 0.15,
Precise = 2,
Min = 0,
Max = 1
})

local FovSection = GeneralTab:CreateSection({
Name = "FOV",
Side = "Right"
})
FovSection:AddToggle({
Name = "Enabled",
Flag = "uwu_fovtoggle",
Callback = print
})
FovSection:AddColorpicker({
Name = "Fov Color"
Value = "255, 0, 0"
Flag = "uwu_fovcolorpicker"
})
Camlock:AddSlider({
Name = "FOV Size",
Flag = "uwu_fovsizeslider",
Value = 0.15,
Precise = 2,
Min = 0,
Max = 1
})

local VisualTab = Rizuki:CreateTab({
Name = "Visual"
})

local EspSection = VisualTab:CreateSection({
Name = "ESP"
})
EspSection:AddToggle({
Name = "Enabled",
Flag = "uwu_esptoggle"
})
EspSection:AddToggle({
Name = "Box ESP",
Flag = "uwu_boxesptoggle"
})
