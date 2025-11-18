-- modules/Haste.lua
-- Haste datatext adapted from ElvUI for Simple DataTexts (SDT)
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

    local currentHaste = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateHaste()
        currentHaste = GetHaste() or 0
        text:SetFormattedText("|c%sHaste: %s|r", addon:GetTagColor(), FormatPercent(currentHaste))
    end
    f.Update = UpdateHaste

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_AURA"
        or event == "UNIT_STATS"
        or event == "UNIT_SPELL_HASTE" then
            UpdateHaste()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("UNIT_SPELL_HASTE")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:ClearLines()

        -- Haste
        local haste = GetHaste()
        GameTooltip:AddLine(format('%s: %s%.2f%%|r', STAT_HASTE, '|cffFFFFFF', haste), 1, 1, 1)
        local playerClass = select(2, UnitClass("player"))
        local hasteStat = playerClass == "HUNTER" and CR_HASTE_RANGED or CR_HASTE_MELEE
        GameTooltip:AddLine(format('%s'..STAT_HASTE_BASE_TOOLTIP, _G['STAT_HASTE_'..playerClass..'_TOOLTIP'] or STAT_HASTE_TOOLTIP, GetCombatRating(hasteStat), GetCombatRatingBonus(hasteStat)), nil, nil, nil, true)

        -- Attack speed
        local mh, oh = UnitAttackSpeed("player")
        GameTooltip:AddLine(" ")
        if oh then
            GameTooltip:AddDoubleLine(
                ATTACK_SPEED,
                string.format("%.2f / %.2f", mh, oh),
                1, 0.82, 0, 1, 0.82, 0
            )
        else
            GameTooltip:AddDoubleLine(
                ATTACK_SPEED,
                string.format("%.2f", mh),
                1, 0.82, 0, 1, 0.82, 0
            )
        end

        -- Rating
        local rating = CR_HASTE_MELEE
        local ratingAmount = GetCombatRating(rating)
        local ratingBonus = GetCombatRatingBonus(rating)

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Initialize immediately
    UpdateHaste()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
addon:RegisterDataText("Haste", mod)

return mod
