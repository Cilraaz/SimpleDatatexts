-- modules/SpellPower.lua
-- Spell Power datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
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
local GameTooltip = GameTooltip
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

    local spellPower = 0
    local maxSpellPower = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateSpellPower()
        -- Get the highest spell power across all schools
        maxSpellPower = 0
        for i = 2, MAX_SPELL_SCHOOLS do
            local power = GetSpellBonusDamage(i)
            if power > maxSpellPower then
                maxSpellPower = power
            end
        end
        
        spellPower = maxSpellPower
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local textString = (showLabel and ITEM_MOD_SPELL_POWER_SHORT..": " or "") .. spellPower
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
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()

        local text = format('%s: |cffFFFFFF%d|r', ITEM_MOD_SPELL_POWER_SHORT, maxSpellPower)
        SDT.FormatUtils:AddTooltipHeader(GameTooltip, 14, text)
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, STAT_SPELLPOWER_TOOLTIP, nil, nil, nil, nil, nil, nil, nil, true)
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
        
        -- Show spell power for each school
        for i = 2, MAX_SPELL_SCHOOLS do
            local power = GetSpellBonusDamage(i)
            local schoolName = SPELL_SCHOOL_NAMES[i-1] or "Unknown"
            SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, schoolName, power, 1, 1, 1)
        end

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateSpellPower()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod