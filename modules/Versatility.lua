-- modules/Versatility.lua
-- Versatility datatext adapted from ElvUI for Simple DataTexts (SDT)
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
local CreateFrame          = CreateFrame
local GetCombatRating      = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local CR_VERSATILITY_DAMAGE_DONE  = CR_VERSATILITY_DAMAGE_DONE
local CR_VERSATILITY_DAMAGE_TAKEN = CR_VERSATILITY_DAMAGE_TAKEN
local CR_VERSATILITY_TOOLTIP      = CR_VERSATILITY_TOOLTIP
local FONT_COLOR_CODE_CLOSE       = FONT_COLOR_CODE_CLOSE
local HIGHLIGHT_FONT_COLOR_CODE   = HIGHLIGHT_FONT_COLOR_CODE
local STAT_VERSATILITY            = STAT_VERSATILITY
local VERSATILITY_TOOLTIP_FORMAT  = VERSATILITY_TOOLTIP_FORMAT

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Versatility"

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

    if not SDTC.stats.versatility then SDTC.stats.versatility = {} end
    local Stats = SDTC.stats.versatility
    local currentVers = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateVersatility()
        currentVers = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
        if not issecretvalue(currentVers) then
            Stats.versDmg = currentVers
            Stats.versReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN)
            Stats.versRating = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
        end
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and L["Vers:"].." " or "") .. SDT.FormatUtils:FormatPercent(Stats.versDmg, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateVersatility

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "COMBAT_RATING_UPDATE"
        or event == "PLAYER_EQUIPMENT_CHANGED" then
            UpdateVersatility()
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

        local text = HIGHLIGHT_FONT_COLOR_CODE..format(VERSATILITY_TOOLTIP_FORMAT, '|cffFFD000'..STAT_VERSATILITY..'|r', Stats.versDmg, Stats.versReduction)..FONT_COLOR_CODE_CLOSE
        local tooltip = format(CR_VERSATILITY_TOOLTIP, Stats.versDmg, Stats.versReduction, SDT.FormatUtils:FormatLargeNumbers(Stats.versRating), Stats.versDmg, Stats.versReduction)
        
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

    UpdateVersatility()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
