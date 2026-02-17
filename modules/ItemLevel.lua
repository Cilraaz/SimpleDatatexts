-- modules/ItemLevel.lua
-- ItemLevel datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetAverageItemLevel = GetAverageItemLevel

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Item Level"
local equippedIL = 0
local maxIL = 0

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Short Label"], "showShortLabel", false)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Max Item Level"], "showMaxItemLevel", true)

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
    local function UpdateItemLevel()
        equippedIL, maxIL = GetAverageItemLevel()
        
        -- Round to whole numbers
        equippedIL = format("%.0f", equippedIL)
        maxIL = format("%.0f", maxIL)
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local showShortLabel = SDT:GetModuleSetting(moduleName, "showShortLabel", false)
        local showMaxItemLevel = SDT:GetModuleSetting(moduleName, "showMaxItemLevel", true)
        
        local label = ""
        if showLabel then
            label = (showShortLabel and L["ilvl"]..": " or L["Item Level"]..": ")
        end
        
        local textString
        if showMaxItemLevel then
            textString = label..format("%s/%s", equippedIL, maxIL)
        else
            textString = label..equippedIL
        end
        
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateItemLevel

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "PLAYER_EQUIPMENT_CHANGED"
        or event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
            UpdateItemLevel()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Equipped Item Level"], equippedIL, 1, 0.82, 0, 1, 1, 1)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Maximum Item Level"], maxIL, 1, 0.82, 0, 1, 1, 1)
        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateItemLevel()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod