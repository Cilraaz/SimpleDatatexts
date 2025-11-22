-- modules/AttackPower.lua
-- AttackPower datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local UnitAttackPower = UnitAttackPower
local UnitRangedAttackPower = UnitRangedAttackPower
local ComputePetBonus = ComputePetBonus

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local ATTACK_POWER                          = ATTACK_POWER
local ATTACK_POWER_MAGIC_NUMBER             = ATTACK_POWER_MAGIC_NUMBER
local MELEE_ATTACK_POWER                    = MELEE_ATTACK_POWER
local MELEE_ATTACK_POWER_TOOLTIP            = MELEE_ATTACK_POWER_TOOLTIP
local RANGED_ATTACK_POWER                   = RANGED_ATTACK_POWER
local RANGED_ATTACK_POWER_TOOLTIP           = RANGED_ATTACK_POWER_TOOLTIP
local STAT_CATEGORY_ENHANCEMENTS            = STAT_CATEGORY_ENHANCEMENTS
local PET_BONUS_TOOLTIP_SPELLDAMAGE         = PET_BONUS_TOOLTIP_SPELLDAMAGE
local PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER = PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER

----------------------------------------------------
-- File Locals
----------------------------------------------------
local isHunter = SDTC.playerClass == 'HUNTER'
local totalAP  = 0

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

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateAP()
        local base, posBuff, negBuff = (isHunter and UnitRangedAttackPower or UnitAttackPower)("player")
        totalAP = base + posBuff + negBuff
        local textString = ATTACK_POWER..": "..totalAP
        text:SetText(SDT:ColorText(textString))
    end
    f.Update = UpdateAP

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_AURA"
        or event == "UNIT_STATS"
        or event == "UNIT_ATTACK_POWER"
        or event == "UNIT_RANGED_ATTACK_POWER" then
            UpdateAP()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("UNIT_ATTACK_POWER")
    f:RegisterEvent("UNIT_RANGED_ATTACK_POWER")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        GameTooltip:AddDoubleLine(isHunter and RANGED_ATTACK_POWER or MELEE_ATTACK_POWER , totalAP, 1, 1, 1)

        local APBonus = format("%.2f", totalAP / ATTACK_POWER_MAGIC_NUMBER)
        GameTooltip:AddLine(format(isHunter and RANGED_ATTACK_POWER_TOOLTIP or MELEE_ATTACK_POWER_TOOLTIP, APBonus), nil, nil, nil, true)

	    if isHunter and ComputePetBonus then
		    local petAPBonus = ComputePetBonus('PET_BONUS_RAP_TO_AP', totalAP)
		    local petSpellDmgBonus = ComputePetBonus('PET_BONUS_RAP_TO_SPELLDMG', totalAP)

    		if petAPBonus > 0 then
	    		GameTooltip:AddLine(format(PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER, format("%.2f", petAPBonus)))
		    end

    		if petSpellDmgBonus > 0 then
	    		GameTooltip:AddLine(format(PET_BONUS_TOOLTIP_SPELLDAMAGE, format("%.2f", petSpellDmgBonus)))
		    end
	    end

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateAP()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Attack Power", mod)

return mod
