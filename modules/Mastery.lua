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
    if not Stats.spells then Stats.spells = {} end
    local currentMastery, bonusCoeff = 0, 0

    local masteryFunc = function() return GetMasteryEffect() end
    local ratingFunc = function() return GetCombatRating(CR_MASTERY) end
    local bonusFunc = function() return GetCombatRatingBonus(CR_MASTERY) end

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateMastery()
        local masteryOk, currentMastery = pcall(masteryFunc)
        local ratingOk, masteryRating = pcall(ratingFunc)
        local bonusOk, masteryBonus = pcall(bonusFunc)
        if masteryOk then Stats.mastery = currentMastery end
        if ratingOk then Stats.masteryRating = masteryRating end
        if bonusOk then Stats.masteryBonus = masteryBonus end

        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and L["Mastery:"].." " or "") .. SDT.FormatUtils:FormatPercent(Stats.mastery, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateMastery

    ----------------------------------------------------
    -- Spec MAstery Spell Helper
    ----------------------------------------------------
    local function GetSpecMasterySpells()
        local spec = GetSpecialization()
	    if spec then
		    local spells = { GetSpecializationMasterySpells(spec) }
		    local hasSpell = false
            local i = 1
            local spellCache = Stats.spells
		    for _, spell in next, spells do
                local spellObj = Spell:CreateFromSpellID(spell)
                if not spellCache[i] then spellCache[i] = {} end
                spellCache[i].spellName = spellObj:GetSpellName()
                spellCache[i].spellDescription = spellObj:GetSpellDescription()
		    end
	    end
    end
    GetSpecMasterySpells()

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            UpdateMastery()
            GetSpecMasterySpells()
        elseif event == "UNIT_STATS"
        or event == "COMBAT_RATING_UPDATE"
        or event == "PLAYER_EQUIPMENT_CHANGED" then
            UpdateMastery()
        elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
            GetSpecMasterySpells()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("COMBAT_RATING_UPDATE")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

	    local title = format('%s: |cffFFFFFF%.2f%%|r', STAT_MASTERY, Stats.mastery)
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, title)

        for _, spell in next, Stats.spells do
            SDT.Tooltip:AddLine(" ")
            if spell.spellName then
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, spell.spellName, nil, 1, 1, 1)
                if spell.spellDescription and spell.spellDescription ~= "" then
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, spell.spellDescription)
                end
            end
        end

        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format("%s: %s [+%.2f%%]", STAT_MASTERY, Stats.masteryRating, Stats.masteryBonus))

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
