-- modules/Stagger.lua
-- Stagger datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local UnitStagger = UnitStagger
local UnitHealthMax = UnitHealthMax

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local STAT_STAGGER = STAT_STAGGER
local STAT_STAGGER_TARGET_TOOLTIP = STAT_STAGGER_TARGET_TOOLTIP
local STAT_STAGGER_TOOLTIP = STAT_STAGGER_TOOLTIP

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Stagger"

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

    local staggerPercent, staggerAmount = 0, 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateStagger()
        staggerAmount = UnitStagger("player") or 0
        local maxHealth = UnitHealthMax("player")
        
        if maxHealth and maxHealth > 0 then
            staggerPercent = (staggerAmount / maxHealth) * 100
        else
            staggerPercent = 0
        end
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and STAT_STAGGER..": " or "") .. SDT.FormatUtils:FormatPercent(staggerPercent, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateStagger

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_MAXHEALTH"
        or event == "UNIT_AURA" then
            UpdateStagger()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_MAXHEALTH")
    f:RegisterEvent("UNIT_AURA")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        local text = format('%s: |cffFFFFFF%.2f%%|r', STAT_STAGGER, staggerPercent)
        local tooltip = format(STAT_STAGGER_TOOLTIP, staggerPercent)
        local amount = format(L["Stagger Amount:"].." %d (%.2f%%)", staggerAmount, staggerPercent)

        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, text)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, tooltip, nil, nil, nil, nil, nil, nil, nil, true)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, amount, nil, nil, nil, nil, nil, nil, nil, true)

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateStagger()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod