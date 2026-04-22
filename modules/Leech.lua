-- modules/Leech.lua
-- Leech datatext adapted from ElvUI for Simple DataTexts (SDT)
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

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local CR_LIFESTEAL = CR_LIFESTEAL or 17
local CR_LIFESTEAL_TOOLTIP = CR_LIFESTEAL_TOOLTIP
local STAT_LIFESTEAL = STAT_LIFESTEAL

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Leech"

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

    if not SDTC.stats.leech then SDTC.stats.leech = {} end
    local Stats = SDTC.stats.leech
    local leechPercent, leechRating = 0, 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateLeech()
        leechRating = GetCombatRating(CR_LIFESTEAL)
        if not issecretvalue(leechRating) then
            Stats.leechPercent = GetCombatRatingBonus(CR_LIFESTEAL)
            Stats.leechRating = leechRating
        end
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and STAT_LIFESTEAL..": " or "") .. SDT.FormatUtils:FormatPercent(Stats.leechPercent, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateLeech

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "COMBAT_RATING_UPDATE"
        or event == "PLAYER_EQUIPMENT_CHANGED" then
            UpdateLeech()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("COMBAT_RATING_UPDATE")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        local text = format('%s: |cffFFFFFF%.2f%%|r', STAT_LIFESTEAL, Stats.leechPercent)
        local tooltip = format(CR_LIFESTEAL_TOOLTIP, Stats.leechRating, Stats.leechPercent)

        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, text)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, tooltip, nil, nil, nil, nil, nil, nil, nil, true)

        if InCombatLockdown() then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Note: Value can't be updated while in combat. Using cached values."], "", 1, 0, 0)
        end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateLeech()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod