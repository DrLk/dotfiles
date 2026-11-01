-- Sourcing external config files

HOME = os.getenv("HOME") or ""

-- Default Configs
local configs = HOME .. "/.config/hypr/configs"

dofile(configs .. "/Settings.lua")
dofile(configs .. "/Keybinds.lua")

-- User Configs
local UserConfigs = HOME .. "/.config/hypr/UserConfigs"

dofile(UserConfigs .. "/Startup_Apps.lua")
dofile(UserConfigs .. "/ENVariables.lua")
dofile(UserConfigs .. "/Monitors.lua")
dofile(UserConfigs .. "/Laptops.lua")
dofile(UserConfigs .. "/LaptopDisplay.lua")
dofile(UserConfigs .. "/WindowRules.lua")
dofile(UserConfigs .. "/UserKeybinds.lua")
dofile(UserConfigs .. "/UserSettings.lua")
