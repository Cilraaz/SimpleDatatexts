-- modules/Time.lua
-- Time & Lockout datatext adapted from ElvUI for Simple DataTexts (SDT)
local addonName, addon = ...
local SDTC = addon.cache

local mod = {}

-- WoW API locals
local _G = _G
local format, unpack, wipe, tinsert, sort = string.format, unpack, table.wipe, table.insert, table.sort
local SecondsToTime = SecondsToTime
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local EJ_GetNumTiers, EJ_SelectTier, EJ_GetInstanceByIndex = EJ_GetNumTiers, EJ_SelectTier, EJ_GetInstanceByIndex
local C_DateAndTime_GetSecondsUntilDailyReset = C_DateAndTime.GetSecondsUntilDailyReset
local C_DateAndTime_GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset

-- Constants
local TIMEMANAGER_TOOLTIP_LOCALTIME = _G.TIMEMANAGER_TOOLTIP_LOCALTIME
local DAILY_RESET = format('%s %s', _G.DAILY, _G.RESET)
local WEEKLY_RESET = format('%s %s', _G.WEEKLY, _G.RESET)
local AMPM = { _G.TIMEMANAGER_PM, _G.TIMEMANAGER_AM }

local lockoutColorExtended = { r = 0.3, g = 1, b = 0.3 }
local lockoutColorNormal = { r = 0.8, g = 0.8, b = 0.8 }

local OVERRIDE_ICON = [[Interface\EncounterJournal\UI-EJ-Dungeonbutton-%s]]

-- Internal state
local enteredFrame = false
local updateTime = 5
local lockedInstances = { raids = {}, dungeons = {} }
local collectedImages = false
local instanceIconByName = {}

-- Time helpers
local function ToTime(secs)
    return SecondsToTime(secs, true, nil, 3)
end

local function ConvertTime(h, m, s)
    if SDTDB.time24 then
        return h, m, s, -1
    elseif h >= 12 then
        if h > 12 then h = h - 12 end
        return h, m, s, 1
    else
        if h == 0 then h = 12 end
        return h, m, s, 2
    end
end

local function GetTimeValues()
    local dateTable = date("*t") -- simplified: can adjust for localTime/db.localTime
    return ConvertTime(dateTable.hour, dateTable.min, dateTable.sec)
end

-- Collect instance textures from EJ
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

-- Tooltip population
local function OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("TIME")
    GameTooltip:AddLine(" ")
    enteredFrame = true

    -- Saved instances
    if next(lockedInstances.raids) then
        GameTooltip:AddLine("Saved Raid(s)")
        sort(lockedInstances.raids, function(a,b) return a[1]<b[1] end)
        for _, info in next, lockedInstances.raids do
            local difficultyLetter, buttonImg = info[2], info[3]
            local name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(info[4])
            local lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
            if numEncounters and numEncounters > 0 and (encounterProgress and encounterProgress > 0) then
                GameTooltip:AddDoubleLine(format('%s%s %s |cffaaaaaa(%s, %s/%s)', buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
            else
                GameTooltip:AddDoubleLine(format('%s%s %s |cffaaaaaa(%s)', buttonImg, maxPlayers, difficultyLetter, name), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
            end
        end
        GameTooltip:AddLine(" ")
    end

    -- Saved dungeons
    if next(lockedInstances.dungeons) then
        GameTooltip:AddLine("Saved Dungeon(s)")
        sort(lockedInstances.dungeons, function(a,b) return a[1]<b[1] end)
        for _, info in next, lockedInstances.dungeons do
            local difficultyLetter, buttonImg = info[2], info[3]
            local name, _, reset, _, _, extended, _, _, maxPlayers, _, numEncounters, encounterProgress = unpack(info[4])
            local lockoutColor = extended and lockoutColorExtended or lockoutColorNormal
            if numEncounters and numEncounters > 0 and (encounterProgress and encounterProgress > 0) then
                GameTooltip:AddDoubleLine(format('%s%s %s |cffaaaaaa(%s, %s/%s)', buttonImg, maxPlayers, difficultyLetter, name, encounterProgress, numEncounters), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
            else
                GameTooltip:AddDoubleLine(format('%s%s %s |cffaaaaaa(%s)', buttonImg, maxPlayers, difficultyLetter, name), ToTime(reset), 1,1,1, lockoutColor.r, lockoutColor.g, lockoutColor.b)
            end
        end
        GameTooltip:AddLine(" ")
    end

    -- Daily/weekly reset
    local dailyReset = C_DateAndTime_GetSecondsUntilDailyReset()
    local weeklyReset = C_DateAndTime_GetSecondsUntilWeeklyReset()
    if dailyReset then
        GameTooltip:AddDoubleLine(DAILY_RESET, ToTime(dailyReset), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
    end
    if weeklyReset then
        GameTooltip:AddDoubleLine(WEEKLY_RESET, ToTime(weeklyReset), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
    end
    GameTooltip:AddLine(" ")

    -- Local/realm time
    local Hr, Min, Sec, AmPm = GetTimeValues()
    GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, format('%02d:%02d:%02d', Hr, Min, Sec), 1,1,1, lockoutColorNormal.r, lockoutColorNormal.g, lockoutColorNormal.b)
    GameTooltip:Show()
end

-- Frame creation
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    local text = slotFrame.text or slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER")
    slotFrame.text = text

    -- Events
    local function OnEvent(self, event)
        wipe(lockedInstances.raids)
        wipe(lockedInstances.dungeons)

        for i = 1, GetNumSavedInstances() do
            local info = { GetSavedInstanceInfo(i) }
            local name, _, _, difficulty, locked, extended, _, isRaid = unpack(info)
            if name and (locked or extended) then
                local buttonImg = instanceIconByName[name] and format('|T%s:16:16|t ', instanceIconByName[name]) or ''
                tinsert(lockedInstances[isRaid and 'raids' or 'dungeons'], { name, "", buttonImg, info })
            end
        end

        if not collectedImages then
            CollectImages()
        end
    end

    f.Update = function() OnEvent(f) end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UPDATE_INSTANCE_INFO")
    f:RegisterEvent("BOSS_KILL")

    -- Tooltip
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self) OnEnter(self) end)
    slotFrame:SetScript("OnLeave", function() enteredFrame = false; GameTooltip:Hide() end)

    -- Click opens calendar (simplified)
    slotFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    slotFrame:SetScript("OnClick", function(_, btn)
        if btn == "RightButton" then
            ToggleFrame(_G.TimeManagerFrame)
        else
            _G.GameTimeFrame:Click()
        end
    end)

    -- Text updater
    f:SetScript("OnUpdate", function(self, elapsed)
        self.timeElapsed = (self.timeElapsed or updateTime) - elapsed
        if self.timeElapsed > 0 then return end
        self.timeElapsed = updateTime

        local Hr, Min, Sec, AmPm = GetTimeValues()
        text:SetFormattedText('|c%s%02d:%02d %s|r', addon:GetTagColor(), Hr, Min, AMPM[AmPm])
    end)

    -- Update immediately upon creation
    do
        local Hr, Min, Sec, AmPm = GetTimeValues()
        text:SetFormattedText('|c%s%02d:%02d %s|r', addon:GetTagColor(), Hr, Min, AMPM[AmPm])
    end

    return f
end

addon:RegisterDataText("Time", mod)

return mod
