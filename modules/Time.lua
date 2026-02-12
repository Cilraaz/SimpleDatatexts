-- modules/Time.lua
-- Time & Lockout datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local date    = date
local format  = string.format
local next    = next
local tinsert = table.insert
local tsort   = table.sort
local unpack  = unpack
local wipe    = table.wipe

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local SecondsToTime = SecondsToTime
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local EJ_GetNumTiers, EJ_SelectTier, EJ_GetInstanceByIndex = EJ_GetNumTiers, EJ_SelectTier, EJ_GetInstanceByIndex
local C_DateAndTime_GetSecondsUntilDailyReset = C_DateAndTime.GetSecondsUntilDailyReset
local C_DateAndTime_GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local TimeManagerFrame = TimeManagerFrame
local GameTimeFrame = GameTimeFrame
local ToggleFrame = ToggleFrame

----------------------------------------------------
-- Constants
----------------------------------------------------
local TIMEMANAGER_TOOLTIP_LOCALTIME = TIMEMANAGER_TOOLTIP_LOCALTIME
local TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_REALMTIME
local DAILY_RESET = format('%s %s', DAILY, RESET)
local WEEKLY_RESET = format('%s %s', WEEKLY, RESET)
local AMPM = { TIMEMANAGER_PM, TIMEMANAGER_AM }

local lockoutColorExtended = { r = 0.3, g = 1, b = 0.3 }
local lockoutColorNormal = { r = 0.8, g = 0.8, b = 0.8 }

local ICON_EJ = ICON_EJ
local OVERRIDE_ICON = [[Interface\EncounterJournal\UI-EJ-Dungeonbutton-%s]]

----------------------------------------------------
-- Misc Locals
----------------------------------------------------
local enteredFrame = false
local lockedInstances = { raids = {}, dungeons = {} }
local collectedImages = false
local instanceIconByName = {}
local moduleName = "Time"
local difficultyTable = {
    [1] = "(N)",
    [2] = "(H)",
    [8] = "(M)",
    [14] = "(N)",
    [15] = "(H)",
    [16] = "(M)",
    [17] = "(LFR)",
    [23] = "(M)",
    [24] = "(TW)",
    [33] = "(TW)",
    [38] = "(N)",
    [39] = "(H)",
    [40] = "(M)",
    [147] = "(N)",
    [149] = "(H)",
    [150] = "(N)",
    [151] = "(LFR)",
    [230] = "(H)",
}

----------------------------------------------------
-- Module Config
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Display Realm Time"], "useRealmTime", false)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Time Helpers
----------------------------------------------------
local function ToTime(secs)
    return SecondsToTime(secs, true, nil, 3)
end

local function ConvertTime(h, m, s)
    local charKey = SDT:GetCharKey()
    if SDT.db.profile.use24HourClock then
        return h, m, s, -1
    elseif h >= 12 then
        if h > 12 then h = h - 12 end
        return h, m, s, 1
    else
        if h == 0 then h = 12 end
        return h, m, s, 2
    end
end

-- Get local time values
local function GetLocalTimeValues()
    local dateTable = date("*t")
    return ConvertTime(dateTable.hour, dateTable.min, dateTable.sec)
end

-- Get realm time values
local function GetRealmTimeValues()
    local realmTime = C_DateAndTime_GetCurrentCalendarTime()
    local dateTable = {
        hour = realmTime.hour,
        min = realmTime.minute,
        sec = realmTime.second or 0
    }
    return ConvertTime(dateTable.hour, dateTable.min, dateTable.sec)
end

-- Get the time values to display (based on setting)
local function GetDisplayTimeValues()
    local useRealmTime = SDT:GetModuleSetting(moduleName, "useRealmTime", false)
    
    if useRealmTime then
        return GetRealmTimeValues()
    else
        return GetLocalTimeValues()
    end
end

function SDT:GetTimeValues()
    return GetDisplayTimeValues()
end

----------------------------------------------------
-- Instance Data from EJ
----------------------------------------------------
local function GetInstanceImages(index, raid)
    local instanceID, name, _, _, buttonImage = EJ_GetInstanceByIndex(index, raid)
    while instanceID do
        local overrideName = name
        local overrideImage = ICON_EJ and ICON_EJ[buttonImage]
        instanceIconByName[overrideName] = overrideImage and format(OVERRIDE_ICON, overrideImage) or buttonImage

        index = index + 1
        instanceID, name, _, _, buttonImage = EJ_GetInstanceByIndex(index, raid)
    end
end

local function CollectImages()
    local numTiers = EJ_GetNumTiers() or 0
    if numTiers > 0 then
        for i = 1, numTiers do
            EJ_SelectTier(i)
            GetInstanceImages(1, false)
            GetInstanceImages(1, true)
        end
        collectedImages = true
    end
end

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    local text = slotFrame.text or slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    slotFrame.text = text

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateText()
        local Hr, Min, Sec, AmPm = GetDisplayTimeValues()
        local textString = format("%d:%02d %s", Hr, Min, AMPM[AmPm] or "")
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    -- Register with UpdateTicker for 5 second updates
    local updateKey = "Time_" .. (slotFrame:GetName() or tostring(slotFrame))
    SDT.UpdateTicker:Register(updateKey, UpdateText, 5)
    
    f.Update = UpdateText

    ----------------------------------------------------
    -- Cleanup on frame release
    ----------------------------------------------------
    f:SetScript("OnHide", function()
        -- Unregister from UpdateTicker when hidden
        SDT.UpdateTicker:Unregister(updateKey, 5)
    end)
    
    f:SetScript("OnShow", function()
        -- Re-register when shown
        SDT.UpdateTicker:Register(updateKey, UpdateText, 5)
        UpdateText()
    end)

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event)
        wipe(lockedInstances.raids)
        wipe(lockedInstances.dungeons)

        C_Timer.After(0.1, function()
            for i = 1, GetNumSavedInstances() do
                local info = { GetSavedInstanceInfo(i) }
                local name, _, _, difficulty, locked, extended, _, isRaid = unpack(info)
                local diffTag = difficultyTable[difficulty] or ""
                if name and (locked or extended) then
                    local buttonImg = instanceIconByName[name] and format('|T%s:16:16|t ', instanceIconByName[name]) or ''
                    tinsert(lockedInstances[isRaid and 'raids' or 'dungeons'], { name, diffTag, buttonImg, info })
                end
            end
        end)

        if not collectedImages then
            CollectImages()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("UPDATE_INSTANCE_INFO")
    f:RegisterEvent("BOSS_KILL")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()
        if not SDT.db.profile.hideModuleTitle then
            SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, L["TIME"])
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end
        enteredFrame = true

        -- Saved instances
        if next(lockedInstances.raids) then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Saved Raid(s)"])
            tsort(lockedInstances.raids, function(a,b) return a[1]<b[1] end)
            for _, info in next, lockedInstances.raids do
                local difficultyLetter, buttonImg = info[2], info[3]
                local name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(info[4])
                local lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
                if numEncounters and numEncounters > 0 and (encounterProgress and encounterProgress > 0) then
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format('%s%s %s |cffaaaaaa(%s, %s/%s)', buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
                else
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format('%s%s %s |cffaaaaaa(%s)', buttonImg, maxPlayers, difficultyLetter, name), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
                end
            end
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end

        -- Saved dungeons
        if next(lockedInstances.dungeons) then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Saved Dungeon(s)"])
            tsort(lockedInstances.dungeons, function(a,b) return a[1]<b[1] end)
            for _, info in next, lockedInstances.dungeons do
                local difficultyLetter, buttonImg = info[2], info[3]
                local name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(info[4])
                local lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
                if numEncounters and numEncounters > 0 and (encounterProgress and encounterProgress > 0) then
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format('%s%s %s |cffaaaaaa(%s, %s/%s)', buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
                else
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format('%s%s %s |cffaaaaaa(%s)', buttonImg, maxPlayers, difficultyLetter, name), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
                end
            end
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end

        -- Daily/weekly reset
        local dailyReset = C_DateAndTime_GetSecondsUntilDailyReset()
        local weeklyReset = C_DateAndTime_GetSecondsUntilWeeklyReset()
        if dailyReset then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, DAILY_RESET, ToTime(dailyReset), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
        end
        if weeklyReset then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, WEEKLY_RESET, ToTime(weeklyReset), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
        end
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")

        -- Local/realm time
        local localHr, localMin, localSec, localAmPm = GetLocalTimeValues()
        local realmHr, realmMin, realmSec, realmAmPm = GetRealmTimeValues()
        
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, TIMEMANAGER_TOOLTIP_LOCALTIME, format('%02d:%02d:%02d', localHr, localMin, localSec), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, TIMEMANAGER_TOOLTIP_REALMTIME, format('%02d:%02d:%02d', realmHr, realmMin, realmSec), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
        
        SDT.Tooltip:Show()
    end)
    
    slotFrame:SetScript("OnLeave", function() enteredFrame = false; SDT.Tooltip:Hide() end)

    ----------------------------------------------------
    -- Click to Open
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            GameTimeFrame:Click()
        end
    end)

    UpdateText()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
