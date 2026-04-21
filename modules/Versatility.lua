-- modules/Versatility.lua
-- Versatility datatext adapted from ElvUI for Simple DataTexts (SDT)
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

    local currentVers, versReduction = 0, 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateVersatility()
        currentVers = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
        if issecretvalue(currentVers) then return end
        versReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN)
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and L["Vers:"].." " or "") .. SDT.FormatUtils:FormatPercent(currentVers, hideDecimals)
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
        if InCombatLockdown() then return end
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
        local text = HIGHLIGHT_FONT_COLOR_CODE..format(VERSATILITY_TOOLTIP_FORMAT, '|cffFFD000'..STAT_VERSATILITY..'|r', currentVers, versReduction)..FONT_COLOR_CODE_CLOSE
        local tooltip = format(CR_VERSATILITY_TOOLTIP, currentVers, versReduction, SDT.FormatUtils:FormatLargeNumbers(versatility), currentVers, versReduction)
        
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, text)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, tooltip, nil, nil, nil, nil, nil, nil, nil, true)

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
