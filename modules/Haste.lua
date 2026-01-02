-- modules/Haste.lua
-- Haste datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetCombatRating      = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetHaste             = GetHaste
local UnitAttackSpeed      = UnitAttackSpeed

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local STAT_HASTE = STAT_HASTE
local CR_HASTE_MELEE = CR_HASTE_MELEE
local CR_HASTE_RANGED = CR_HASTE_RANGED
local STAT_HASTE_BASE_TOOLTIP = STAT_HASTE_BASE_TOOLTIP
local STAT_HASTE_TOOLTIP = STAT_HASTE_TOOLTIP
local ATTACK_SPEED = ATTACK_SPEED

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
        local textString = L["Haste: "] .. SDT:FormatPercent(currentHaste)
        text:SetText(SDT:ColorText(textString))
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
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()

        -- Haste
        local haste = GetHaste()
        GameTooltip:AddLine(format('%s: %s%.2f%%|r', STAT_HASTE, '|cffFFFFFF', haste), 1, 1, 1)
        local hasteStat = SDTC.playerClass == "HUNTER" and CR_HASTE_RANGED or CR_HASTE_MELEE
        GameTooltip:AddLine(format('%s'..STAT_HASTE_BASE_TOOLTIP, _G['STAT_HASTE_'..SDTC.playerClass..'_TOOLTIP'] or STAT_HASTE_TOOLTIP, GetCombatRating(hasteStat), GetCombatRatingBonus(hasteStat)), nil, nil, nil, true)

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

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateHaste()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Haste", mod)

return mod
