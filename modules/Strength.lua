-- modules/Strength.lua
-- Strength datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local UnitStat = UnitStat

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT
local LE_UNIT_STAT_STRENGTH = LE_UNIT_STAT_STRENGTH

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Strength"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Short Label"], "showShortLabel", false)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end

    if not SDTC.stats.strength then SDTC.stats.strength = {} end
    local Stats = SDTC.stats.strength
    local currentStr = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateStrength()
        currentStr = UnitStat("player", LE_UNIT_STAT_STRENGTH)
        if not issecretvalue(currentStr) then
            Stats.strength = currentStr
        end
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local showShortLabel = SDT:GetModuleSetting(moduleName, "showShortLabel", false)
        local textString = (showLabel and (showShortLabel and L["Str"] or ITEM_MOD_STRENGTH_SHORT)..": " or "") .. Stats.strength
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateStrength

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_AURA"
        or event == "UNIT_STATS" then
            UpdateStrength()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("UNIT_STATS")

    UpdateStrength()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
