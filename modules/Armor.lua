-- modules/Armor.lua
-- Armor datatext adapted from ElvUI for Simple DataTexts (SDT)
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
local UnitArmor                   = UnitArmor
local UnitLevel                   = UnitLevel
local C_PDI_GetArmorEffectiveness = C_PaperDollInfo.GetArmorEffectiveness

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local ARMOR                    = ARMOR
local STAT_CATEGORY_ATTRIBUTES = STAT_CATEGORY_ATTRIBUTES

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
        local textString = ARMOR..": "..currentArmor
        text:SetText(SDT:ColorText(textString))
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
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(L["Mitigation By Level:"])
        GameTooltip:AddLine(' ')

        -- Armor
        local _, currentArmor = UnitArmor("player")
        local upperLevel = UnitLevel("player") + 3
        for _ = 1, 4 do
            local armorReduction = C_PDI_GetArmorEffectiveness(currentArmor, upperLevel) * 100
            GameTooltip:AddDoubleLine(format(L["Level %d"], upperLevel), format("%.2f%%", armorReduction), 1, 1, 1)
            upperLevel = upperLevel - 1
        end
        
        local targetLevel = UnitLevel("target")
	    if targetLevel and targetLevel > 0 and (targetLevel > upperLevel + 3 or targetLevel < upperLevel) then
		    local armorReduction = C_PDI_GetArmorEffectiveness(currentArmor, targetLevel) * 100
		    GameTooltip:AddLine(' ')
		    GameTooltip:AddDoubleLine(L["Target Mitigation"], format("%.2f%%", armorReduction), 1, 1, 1)
	    end

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateArmor()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Armor", mod)

return mod
