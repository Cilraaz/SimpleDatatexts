-- modules/AttackPower.lua
-- AttackPower datatext adapted from ElvUI for Simple DataTexts (SDT)
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
local moduleName = "Attack Power"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Short Label"], "showShortLabel", false)

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

    if not SDTC.stats.attackPower then SDTC.stats.attackPower = {} end
    local Stats = SDTC.stats.attackPower

    local APFunc = function() return (isHunter and UnitRangedAttackPower or UnitAttackPower)("player") end

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateAP()
        local APOk, base, posBuff, negBuff = pcall(APFunc)
        if APOk then
            if not issecretvalue(base) then
                Stats.totalAP = base + posBuff + negBuff
            else
                Stats.totalAP = base
            end
        end
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local showShortLabel = SDT:GetModuleSetting(moduleName, "showShortLabel", false)
        local textString = (showLabel and (showShortLabel and L["AP"] or ATTACK_POWER)..": " or "") .. Stats.totalAP
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
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
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, isHunter and RANGED_ATTACK_POWER or MELEE_ATTACK_POWER, Stats.totalAP, 1, 0.82, 0, 1, 1, 1)

        local APBonus = not issecretvalue(Stats.totalAP) and format("%.2f", Stats.totalAP / ATTACK_POWER_MAGIC_NUMBER) or "0"
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format(isHunter and RANGED_ATTACK_POWER_TOOLTIP or MELEE_ATTACK_POWER_TOOLTIP, APBonus), nil, nil, nil, nil, nil, nil, true)

	    if isHunter and ComputePetBonus then
		    local petAPBonus = ComputePetBonus('PET_BONUS_RAP_TO_AP', Stats.totalAP)
		    local petSpellDmgBonus = ComputePetBonus('PET_BONUS_RAP_TO_SPELLDMG', Stats.totalAP)

    		if petAPBonus > 0 then
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format(PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER, format("%.2f", petAPBonus)))
		    end

    		if petSpellDmgBonus > 0 then
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format(PET_BONUS_TOOLTIP_SPELLDAMAGE, format("%.2f", petSpellDmgBonus)))
		    end
	    end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateAP()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
