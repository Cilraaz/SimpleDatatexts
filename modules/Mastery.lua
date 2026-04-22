-- modules/Mastery.lua
-- Mastery datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Mastery"

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

    if not SDTC.stats.mastery then SDTC.stats.mastery = {} end
    local Stats = SDTC.stats.mastery
    local currentMastery, bonusCoeff = 0, 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateMastery()
        currentMastery, bonusCoeff = GetMasteryEffect()
        if not issecretvalue(currentMastery) then
            Stats.mastery = currentMastery
            Stats.masteryRating = GetCombatRating(CR_MASTERY)
	        Stats.masteryBonus = (GetCombatRatingBonus(CR_MASTERY) or 0) * (bonusCoeff or 0)
        end
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and L["Mastery:"].." " or "") .. SDT.FormatUtils:FormatPercent(Stats.mastery, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
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
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

	    local title = format('%s: |cffFFFFFF%.2f%%|r', STAT_MASTERY, Stats.masteryRating)
	    if Stats.masteryBonus > 0 then
		    title = format('%s |cffFFFFFF(%.2f%%|r |cff33ff33+%.2f%%|r|cffFFFFFF)|r', title, Stats.masteryRating - Stats.masteryBonus, Stats.masteryBonus)
	    end
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, title)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")

        local spec = GetSpecialization()
	    if spec then
		    local spells = { GetSpecializationMasterySpells(spec) }
		    local hasSpell = false
		    for _, spell in next, spells do
			    if hasSpell then
				    SDT.Tooltip:AddLine(" ")
			    else
				    hasSpell = true
			    end

                local spellObj = Spell:CreateFromSpellID(spell)
                local spellName = spellObj:GetSpellName()
                local spellDescription = spellObj:GetSpellDescription()
                if spellName then
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, spellName, nil, 1, 1, 1)
                    if spellDescription and spellDescription ~= "" then
                        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, spellDescription)
                    end
                end
		    end
	    end

        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format("%s: %s [+%.2f%%]", STAT_MASTERY, Stats.masteryRating, Stats.masteryBonus))

        if InCombatLockdown() then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Note: Value can't be updated while in combat. Using cached values."], "", 1, 0, 0)
        end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateMastery()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
