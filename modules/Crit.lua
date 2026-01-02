-- modules/Crit.lua
-- Crit datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = string.format
local min    = math.min

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GameTooltip          = GameTooltip
local GetCombatRating      = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetCritChance        = GetCritChance
local GetRangedCritChance  = GetRangedCritChance
local GetSpellCritChance   = GetSpellCritChance

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local CR_CRIT_MELEE        = CR_CRIT_MELEE
local CR_CRIT_RANGED       = CR_CRIT_RANGED
local CR_CRIT_SPELL        = CR_CRIT_SPELL
local CR_CRIT_TOOLTIP      = CR_CRIT_TOOLTIP
local MAX_SPELL_SCHOOLS    = MAX_SPELL_SCHOOLS
local MELEE_CRIT_CHANCE    = MELEE_CRIT_CHANCE

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

    local critChance, ratingIndex = 0, 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateCrit()
        local spellCrit, rangedCrit, meleeCrit

	    local holySchool = 2 -- start at 2 to skip physical damage
	    local minCrit = GetSpellCritChance(holySchool)
	    for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
		    spellCrit = GetSpellCritChance(i)
		    minCrit = min(minCrit, spellCrit)
	    end

    	spellCrit = minCrit
	    rangedCrit = GetRangedCritChance()
	    meleeCrit = GetCritChance()

	    if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
		    critChance = spellCrit
		    ratingIndex = CR_CRIT_SPELL
	    elseif (rangedCrit >= meleeCrit) then
    		critChance = rangedCrit
	    	ratingIndex = CR_CRIT_RANGED
	    else
		    critChance = meleeCrit
		    ratingIndex = CR_CRIT_MELEE
	    end

        local textString = L["Crit: "] .. SDT:FormatPercent(critChance)
        text:SetText(SDT:ColorText(textString))
    end
    f.Update = UpdateCrit

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "COMBAT_RATING_UPDATE"
        or event == "PLAYER_EQUIPMENT_CHANGED" then
            UpdateCrit()
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

        local critical = GetCombatRating(ratingIndex)
        GameTooltip:AddLine(format('|cffFFFFFF%s:|r |cffFFFFFF%.2f%%|r', MELEE_CRIT_CHANCE, critChance))
		GameTooltip:AddDoubleLine(format(CR_CRIT_TOOLTIP, critical , GetCombatRatingBonus(ratingIndex)))

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateCrit()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Crit", mod)

return mod
