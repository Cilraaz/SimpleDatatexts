-- modules/Mastery.lua
-- Mastery datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

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

    local currentMastery = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateMastery()
        currentMastery = GetMasteryEffect() or 0
        local textString = L["Mastery: "] .. SDT:FormatPercent(currentMastery)
        text:SetText(SDT:ColorText(textString))
    end
    f.Update = UpdateMastery

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "COMBAT_RATING_UPDATE"
        or event == "PLAYER_EQUIPMENT_CHANGED" then
            UpdateMastery()
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

        local masteryRating, bonusCoeff = GetMasteryEffect()
	    local masteryBonus = (GetCombatRatingBonus(CR_MASTERY) or 0) * (bonusCoeff or 0)

	    local title = format('|cffFFFFFF%s: %.2f%%|r', STAT_MASTERY, masteryRating)
	    if masteryBonus > 0 then
		    title = format('%s |cffFFFFFF(%.2f%%|r |cff33ff33+%.2f%%|r|cffFFFFFF)|r', title, masteryRating - masteryBonus, masteryBonus)
	    end
        GameTooltip:AddLine(title)
        GameTooltip:AddLine(" ")

        local spec = GetSpecialization()
	    if spec then
		    local spells = { GetSpecializationMasterySpells(spec) }
		    local hasSpell = false
		    for _, spell in next, spells do
			    if hasSpell then
				    GameTooltip:AddLine(" ")
			    else
				    hasSpell = true
			    end

                local spellObj = Spell:CreateFromSpellID(spell)
                local spellName = spellObj:GetSpellName()
                local spellDescription = spellObj:GetSpellDescription()
                if spellName then
                    GameTooltip:AddLine(spellName, 1, 1, 1)
                    if spellDescription and spellDescription ~= "" then
                        GameTooltip:AddLine(spellDescription)
                    end
                end
		    end
	    end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(format("%s: %s [+%.2f%%]", STAT_MASTERY, GetCombatRating(CR_MASTERY), masteryBonus), 1, 0.82, 0)
        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateMastery()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Mastery", mod)

return mod
