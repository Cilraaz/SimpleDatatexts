-- modules/Armor.lua
-- Armor datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
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
local UnitArmor                   = UnitArmor
local UnitLevel                   = UnitLevel
local C_PDI_GetArmorEffectiveness = C_PaperDollInfo.GetArmorEffectiveness

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local ARMOR                    = ARMOR
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Armor"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)

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

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateArmor()
        local _, currentArmor = UnitArmor("player")
        if issecretvalue(currentArmor) then return end
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local textString = (showLabel and ARMOR..": " or "")..currentArmor
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateArmor

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_AURA"
        or event == "UNIT_STATS"
        or event == "UNIT_RESISTANCES" then
            UpdateArmor()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("UNIT_RESISTANCES")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        if InCombatLockdown() then return end
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, L["Mitigation By Level:"])
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")

        -- Armor
        local _, currentArmor = UnitArmor("player")
        local upperLevel = UnitLevel("player") + 3
        for _ = 1, 4 do
            local armorReduction = C_PDI_GetArmorEffectiveness(currentArmor, upperLevel) * 100
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format(L["Level %d"], upperLevel), format("%.2f%%", armorReduction), 1, 1, 1, 0.1, 1, 0.1)
            upperLevel = upperLevel - 1
        end
        
        local targetLevel = UnitLevel("target")
	    if targetLevel and targetLevel > 0 and (targetLevel > upperLevel + 3 or targetLevel < upperLevel) then
		    local armorReduction = C_PDI_GetArmorEffectiveness(currentArmor, targetLevel) * 100
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
		    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Target Mitigation"], format("%.2f%%", armorReduction), 1, 1, 1)
	    end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateArmor()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
