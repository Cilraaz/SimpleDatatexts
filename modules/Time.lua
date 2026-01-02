-- modules/Time.lua
-- Time & Lockout datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L
local SDTC = SDT.cache

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
local TimeManagerFrame = TimeManagerFrame
local GameTimeFrame = GameTimeFrame
local ToggleFrame = ToggleFrame
local GameTooltip = GameTooltip

----------------------------------------------------
-- Constants
----------------------------------------------------
local TIMEMANAGER_TOOLTIP_LOCALTIME = TIMEMANAGER_TOOLTIP_LOCALTIME
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
local updateTime = 5
local lockedInstances = { raids = {}, dungeons = {} }
local collectedImages = false
local instanceIconByName = {}

----------------------------------------------------
-- Time Helpers
----------------------------------------------------
local function ToTime(secs)
    return SecondsToTime(secs, true, nil, 3)
end

local function ConvertTime(h, m, s)
    local charKey = SDT:GetCharKey()
    if SDTDB[charKey].settings.use24HourClock then
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

function SDT:GetTimeValues()
    return GetTimeValues()
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
        local Hr, Min, Sec, AmPm = GetTimeValues()
        local textString = format("%d:%02d %s", Hr, Min, AMPM[AmPm] or "")
        text:SetText(SDT:ColorText(textString))
    end

    f:SetScript("OnUpdate", function(self, elapsed)
        self.timeElapsed = (self.timeElapsed or updateTime) - elapsed
        if self.timeElapsed > 0 then return end
        self.timeElapsed = updateTime

        UpdateText()
    end)
    
    f.Update = UpdateText

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
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

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UPDATE_INSTANCE_INFO")
    f:RegisterEvent("BOSS_KILL")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(L["TIME"])
        GameTooltip:AddLine(" ")
        enteredFrame = true

        -- Saved instances
        if next(lockedInstances.raids) then
            GameTooltip:AddLine(L["Saved Raid(s)"])
            tsort(lockedInstances.raids, function(a,b) return a[1]<b[1] end)
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
            GameTooltip:AddLine(L["Saved Dungeon(s)"])
            tsort(lockedInstances.dungeons, function(a,b) return a[1]<b[1] end)
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
    end)
    slotFrame:SetScript("OnLeave", function() enteredFrame = false; GameTooltip:Hide() end)

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
SDT:RegisterDataText("Time", mod)

return mod
