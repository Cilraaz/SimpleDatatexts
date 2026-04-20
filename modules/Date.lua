-- modules/Date.lua
-- Date datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local date        = date
local format      = string.format

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Date"

-- Lookup table for full weekday and month names (WoW globals)
local WEEKDAY_NAMES = {
    SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY
}
local MONTH_NAMES = {
    JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE,
    JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER
}

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "select", L["Date Format"], "dateFormat", 1, {
        [1] = L["MM/DD/YYYY"],
        [2] = L["DD/MM/YYYY"],
        [3] = L["YYYY-MM-DD"],
        [4] = L["Month DD, YYYY"],
        [5] = L["DD Month YYYY"],
        [6] = L["Weekday, Month DD"],
        [7] = L["Abbrev. (Mon, Jan 1)"],
    })

    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Day of Week on Tooltip"], "showWeekday", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Day of Year on Tooltip"], "showDayOfYear", true)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Helpers
----------------------------------------------------

-- Returns individual date components from the local clock
local function GetDateComponents()
    local d = {}
    d.year    = tonumber(date("%Y"))
    d.month   = tonumber(date("%m"))
    d.day     = tonumber(date("%d"))
    d.wday    = tonumber(date("%w")) + 1  -- 1 = Sunday ... 7 = Saturday
    d.yday    = tonumber(date("%j"))
    d.weekday = WEEKDAY_NAMES[d.wday] or date("%A")
    d.monthName = MONTH_NAMES[d.month] or date("%B")
    d.monthAbbrev = d.monthName and d.monthName:sub(1, 3) or date("%b")
    return d
end

local function BuildDateString(d, fmt)
    if fmt == 1 then
        -- MM/DD/YYYY
        return format("%02d/%02d/%04d", d.month, d.day, d.year)
    elseif fmt == 2 then
        -- DD/MM/YYYY
        return format("%02d/%02d/%04d", d.day, d.month, d.year)
    elseif fmt == 3 then
        -- YYYY-MM-DD
        return format("%04d-%02d-%02d", d.year, d.month, d.day)
    elseif fmt == 4 then
        -- Month DD, YYYY  (e.g. "April 20, 2026")
        return format("%s %d, %04d", d.monthName, d.day, d.year)
    elseif fmt == 5 then
        -- DD Month YYYY  (e.g. "20 April 2026")
        return format("%d %s %04d", d.day, d.monthName, d.year)
    elseif fmt == 6 then
        -- Weekday, Month DD  (e.g. "Monday, April 20")
        return format("%s, %s %d", d.weekday, d.monthName, d.day)
    elseif fmt == 7 then
        -- Abbreviated  (e.g. "Mon, Apr 20")
        local dayAbbrev = d.weekday and d.weekday:sub(1, 3) or date("%a")
        return format("%s, %s %d", dayAbbrev, d.monthAbbrev, d.day)
    end
    return format("%02d/%02d/%04d", d.month, d.day, d.year)
end

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

    -- Cache the last-displayed date components so the tooltip stays current
    local cachedDate = {}

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateText()
        local d = GetDateComponents()
        cachedDate = d

        local fmt = SDT:GetModuleSetting(moduleName, "dateFormat", 1)
        local textString = BuildDateString(d, fmt)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    -- Register with UpdateTicker — refresh every 60 s (date only changes once a day,
    -- but a short interval ensures the display is correct after midnight)
    local updateKey = "Date_" .. (slotFrame:GetName() or tostring(slotFrame))
    SDT.UpdateTicker:Register(updateKey, UpdateText, 60)

    f.Update = UpdateText

    ----------------------------------------------------
    -- Cleanup on frame release
    ----------------------------------------------------
    f:SetScript("OnHide", function()
        SDT.UpdateTicker:Unregister(updateKey, 60)
    end)

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local d = cachedDate
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        -- Header: full date in the longest format
        local header = format("%s, %s %d, %04d", d.weekday or "", d.monthName or "", d.day or 0, d.year or 0)
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, header)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")

        -- Weekday line
        if SDT:GetModuleSetting(moduleName, "showWeekday", true) then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Day of Week:"], d.weekday or "", 1, 1, 1, 1, 1, 1)
        end

        -- Day-of-year line
        if SDT:GetModuleSetting(moduleName, "showDayOfYear", true) then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Day of Year:"], tostring(d.yday or 0), 1, 1, 1, 1, 1, 1)
        end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    UpdateText()
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod