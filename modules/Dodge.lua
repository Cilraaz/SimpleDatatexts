-- modules/Dodge.lua
-- Dodge datatext adapted from ElvUI for Simple DataTexts (SDT)
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
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetDodgeChance = GetDodgeChance

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local CR_DODGE = CR_DODGE or 3
local CR_DODGE_TOOLTIP = CR_DODGE_TOOLTIP
local STAT_DODGE = STAT_DODGE

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Dodge"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Hide Decimals"], "hideDecimals", false)

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

    if not SDTC.stats.dodge then SDTC.stats.dodge = {} end
    local Stats = SDTC.stats.dodge
    local dodgeChance = 0

    local dodgeFunc = function() return GetDodgeChance() end
    local ratingFunc = function() return GetCombatRating(CR_DODGE) end
    local bonusFunc = function() return GetCombatRatingBonus(CR_DODGE) end

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateDodge()
        local dodgeOk, dodgeChance = pcall(dodgeFunc)
        local ratingOk, dodgeRating = pcall(ratingFunc)
        local bonusOk, dodgeBonus = pcall(bonusFunc)
        if dodgeOk then Stats.dodgeChance = dodgeChance end
        if ratingOk then Stats.dodgeRating = dodgeRating end
        if bonusOk then Stats.dodgeBonus = dodgeBonus end
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and STAT_DODGE..": " or "") .. SDT.FormatUtils:FormatPercent(Stats.dodgeChance, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateDodge

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "PLAYER_EQUIPMENT_CHANGED"
        or event == "UNIT_AURA" then
            UpdateDodge()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("UNIT_AURA")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        local text = format('%s: |cffFFFFFF%.2f%%|r', STAT_DODGE, Stats.dodgeChance)
        local tooltip = format(CR_DODGE_TOOLTIP, Stats.dodgeRating, Stats.dodgeBonus)

        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, text)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, tooltip, nil, nil, nil, nil, nil, nil, nil, true)
        
        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateDodge()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod