-- modules/SpellPower.lua
-- Spell Power datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local GetSpellBonusDamage = GetSpellBonusDamage

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local ITEM_MOD_SPELL_POWER_SHORT = ITEM_MOD_SPELL_POWER_SHORT
local MAX_SPELL_SCHOOLS = MAX_SPELL_SCHOOLS
local STAT_SPELLPOWER_TOOLTIP = STAT_SPELLPOWER_TOOLTIP
local SPELL_SCHOOL_NAMES = {
    [1] = SPELL_SCHOOL1_CAP, -- Holy
    [2] = SPELL_SCHOOL2_CAP, -- Fire
    [3] = SPELL_SCHOOL3_CAP, -- Nature
    [4] = SPELL_SCHOOL4_CAP, -- Frost
    [5] = SPELL_SCHOOL5_CAP, -- Shadow
    [6] = SPELL_SCHOOL6_CAP, -- Arcane
}

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Spell Power"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)

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

    if not SDTC.stats.spellPower then SDTC.stats.spellPower = {} end
    local Stats = SDTC.stats.spellPower
    local spellPower = 0

    local spellPowerFunc = function() return GetSpellBonusDamage(2) end

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateSpellPower()
        -- Get the highest spell power across all schools
        local SPOk, spellPower = pcall(spellPowerFunc)
        if SPOk then Stats.spellPower = spellPower end

        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local textString = (showLabel and ITEM_MOD_SPELL_POWER_SHORT..": " or "") .. Stats.spellPower
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateSpellPower

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "PLAYER_EQUIPMENT_CHANGED"
        or event == "UNIT_SPELL_HASTE" then
            UpdateSpellPower()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("UNIT_SPELL_HASTE")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        local text = format('%s: |cffFFFFFF%d|r', ITEM_MOD_SPELL_POWER_SHORT, Stats.spellPower)
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, text)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, STAT_SPELLPOWER_TOOLTIP, nil, nil, nil, nil, nil, nil, nil, true)

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateSpellPower()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod