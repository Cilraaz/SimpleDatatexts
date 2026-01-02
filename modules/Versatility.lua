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
local BreakUpLargeNumbers  = BreakUpLargeNumbers
local CreateFrame          = CreateFrame
local GameTooltip          = GameTooltip
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
        versReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN)
        local textString = L["Vers: "] .. SDT:FormatPercent(currentVers)
        text:SetText(SDT:ColorText(textString))
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
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()

        local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
        local text = HIGHLIGHT_FONT_COLOR_CODE..format(VERSATILITY_TOOLTIP_FORMAT, STAT_VERSATILITY, currentVers, versReduction)..FONT_COLOR_CODE_CLOSE
        local tooltip = format(CR_VERSATILITY_TOOLTIP, currentVers, versReduction, BreakUpLargeNumbers(versatility), currentVers, versReduction)
        
        GameTooltip:AddDoubleLine(text, nil, 1, 1, 1)
	    GameTooltip:AddLine(tooltip, nil, nil, nil, true)

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateVersatility()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Versatility", mod)

return mod
