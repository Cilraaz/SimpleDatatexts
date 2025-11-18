-- modules/Versatility.lua
-- Versatility datatext adapted from ElvUI for Simple DataTexts (SDT)
local addonName, addon = ...
local SDTC = addon.cache

local mod = {}

----------------------------------------------------
-- Utility
----------------------------------------------------
local function FormatPercent(v)
    return string.format("%.2f%%", v)
end

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
        text:SetFormattedText("|c%sVers: %s|r", addon:GetTagColor(), FormatPercent(currentVers))
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
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
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
addon:RegisterDataText("Versatility", mod)

return mod
