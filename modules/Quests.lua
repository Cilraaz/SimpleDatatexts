-- modules/Quests.lua
-- Quests datatext for Simple DataTexts (SDT)
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
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetMaxNumQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Quests"
local currentQuests = 0
local maxQuests = 0

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
    local function UpdateQuests()
        _, currentQuests = C_QuestLog_GetNumQuestLogEntries()
        maxQuests = C_QuestLog_GetMaxNumQuestsCanAccept()
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local textString = (showLabel and L["Quests"]..": " or "")..format("%d/%d", currentQuests, maxQuests)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateQuests

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "QUEST_LOG_UPDATE"
        or event == "QUEST_ACCEPTED"
        or event == "QUEST_REMOVED"
        or event == "QUEST_TURNED_IN" then
            UpdateQuests()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("QUEST_LOG_UPDATE")
    f:RegisterEvent("QUEST_ACCEPTED")
    f:RegisterEvent("QUEST_REMOVED")
    f:RegisterEvent("QUEST_TURNED_IN")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Quests"], format("%d/%d", currentQuests, maxQuests), 1, 0.82, 0, 1, 1, 1)
        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateQuests()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod