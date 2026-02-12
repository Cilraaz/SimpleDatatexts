-- modules/CombatTime.lua
-- Combat time tracker datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format = string.format
local floor = math.floor

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Combat Timer"
local combatStartTime = nil
local lastCombatDuration = nil
local combatEndTime = nil

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "range", L["Display Duration"], "displayDuration", 10, 0, 60, 1)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Helper Functions
----------------------------------------------------
local function FormatTime(seconds)
    local hours = floor(seconds / 3600)
    local minutes = floor((seconds % 3600) / 60)
    local secs = floor(seconds % 60)
    
    if hours > 0 then
        return format("%d:%02d:%02d", hours, minutes, secs)
    elseif minutes > 0 then
        return format("%d:%02d", minutes, secs)
    else
        return format("0:%02d", secs)
    end
end

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    local f = CreateFrame("Frame")
    local text = slotFrame.text

    ----------------------------------------------------
    -- Update Display
    ----------------------------------------------------
    local function UpdateDisplay()
        local textString
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel")
        
        if InCombatLockdown() and combatStartTime then
            -- Currently in combat - show elapsed time
            local elapsed = GetTime() - combatStartTime
            local timeStr = FormatTime(elapsed)
            if showLabel then
                textString = format("%s: %s", L["Combat"], timeStr)
            else
                textString = timeStr
            end
        elseif lastCombatDuration and combatEndTime and (GetTime() - combatEndTime) < SDT:GetModuleSetting(moduleName, "displayDuration") then
            -- Out of combat - show last combat duration for displayDuration seconds
            local timeStr = FormatTime(lastCombatDuration)
            if showLabel then
                textString = format("%s: %s", L["Last"], timeStr)
            else
                textString = timeStr
            end
        else
            -- Out of combat - either no previous combat or displayDuration seconds have passed
            textString = L["Out of Combat"]
        end
        
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateDisplay

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_REGEN_DISABLED" then
            -- Entering combat
            combatStartTime = GetTime()
            combatEndTime = nil
        elseif event == "PLAYER_REGEN_ENABLED" then
            -- Leaving combat
            if combatStartTime then
                lastCombatDuration = GetTime() - combatStartTime
                combatEndTime = GetTime()
                combatStartTime = nil
            end
            local displayDuration = SDT:GetModuleSetting(moduleName, "displayDuration")
            C_Timer.After(displayDuration, UpdateDisplay)
        elseif event == "PLAYER_ENTERING_WORLD" then
            -- Reset on zone change/reload
            combatStartTime = nil
        end
        
        UpdateDisplay()
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("PLAYER_REGEN_ENABLED")

    ----------------------------------------------------
    -- Update Timer (for live combat time updates and post-combat display)
    ----------------------------------------------------
    local updateThrottle = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        updateThrottle = updateThrottle + elapsed
        if updateThrottle > 0.1 then -- Update 10 times per second
            if InCombatLockdown() and combatStartTime then
                -- Update during combat
                UpdateDisplay()
            elseif combatEndTime and (GetTime() - combatEndTime) < SDT:GetModuleSetting(moduleName, "displayDuration") then
                -- Update after combat
                UpdateDisplay()
            end
            updateThrottle = 0
        end
    end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" and not InCombatLockdown() then
            -- Reset to "Out of Combat" when clicked while out of combat
            lastCombatDuration = nil
            combatStartTime = nil
            combatEndTime = nil
            UpdateDisplay()
        end
    end)

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()
        if not SDT.db.profile.hideModuleTitle then
            SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, L["Combat Timer"])
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end

        if InCombatLockdown() and combatStartTime then
            local elapsed = GetTime() - combatStartTime
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format("%s %s: %s", L["Current"], L["combat duration"], FormatTime(elapsed)))
        elseif lastCombatDuration then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format("%s %s: %s", L["Last"], L["combat duration"], FormatTime(lastCombatDuration)))
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format("|cff00FF00%s|r %s", L["Left-click"], L["to reset"]))
        else
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Currently out of combat"])
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Enter combat to start tracking"])
        end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateDisplay()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod