-- modules/Block.lua
-- Block datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
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
local GetBlockChance = GetBlockChance
local GetShieldBlock = GetShieldBlock

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local CR_BLOCK = CR_BLOCK or 5
local CR_BLOCK_TOOLTIP = CR_BLOCK_TOOLTIP
local STAT_BLOCK = STAT_BLOCK

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Block"

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

    if not SDTC.stats.block then SDTC.stats.block = {} end
    local Stats = SDTC.stats.block
    local blockChance = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateBlock()
        blockChance = GetBlockChance()
        if not issecretvalue(blockChance) then
            Stats.blockChance = blockChance
            Stats.blockRating = GetCombatRating(CR_BLOCK)
            Stats.blockBonus = GetCombatRatingBonus(CR_BLOCK)
        end
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local hideDecimals = SDT:GetModuleSetting(moduleName, "hideDecimals", false)
        local textString = (showLabel and STAT_BLOCK..": " or "") .. SDT.FormatUtils:FormatPercent(Stats.blockChance, hideDecimals)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateBlock

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_STATS"
        or event == "PLAYER_EQUIPMENT_CHANGED"
        or event == "UNIT_AURA" then
            UpdateBlock()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_STATS")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("UNIT_AURA")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        local text = format('%s: |cffFFFFFF%.2f%%|r', STAT_BLOCK, Stats.blockChance)
        local tooltip = format(CR_BLOCK_TOOLTIP, Stats.blockChance)
        local bonus = format('%s: %s [+%.2f%%]', STAT_BLOCK, Stats.blockRating, Stats.blockBonus)

        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, text)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, tooltip, nil, nil, nil, nil, nil, nil, nil, true)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, bonus, nil, nil, nil, nil, nil, nil, nil, true)

        if InCombatLockdown() then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Note: Value can't be updated while in combat. Using cached values."], "", 1, 0, 0)
        end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateBlock()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod