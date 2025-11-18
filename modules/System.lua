-- modules/System.lua
-- System datatext adapted from ElvUI for Simple DataTexts (SDT)
local addonName, addon = ...
local SDTC = addon.cache
local mod = {}
-- WoW API locals
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetNumAddOns = C_AddOns.GetNumAddOns
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- Local helpers
local floor, format, wipe, ipairs, pairs = math.floor, string.format, wipe, ipairs, pairs

-- Color gradient for status
local statusColors = {
    '|cff0CD809', -- green
    '|cffE8DA0F', -- yellow
    '|cffFF9000', -- orange
    '|cffD80909', -- red
}

-- Format memory nicely
local function FormatMem(memory)
    if memory >= 1024 then
        return format("%.2f mb", memory / 1024)
    else
        return format("%d kb", memory)
    end
end

-- Determine color for FPS / latency
local function StatusColor(fps, ping)
    if fps then
        return statusColors[fps >= 30 and 1 or (fps >= 20 and 2) or (fps >= 10 and 3) or 4]
    else
        return statusColors[ping < 150 and 1 or (ping < 300 and 2) or (ping < 500 and 3) or 4]
    end
end

-- Local state for the module
local enteredFrame = false
local infoTable = {}

-- Create the module frame
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    -- text object
    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end

    -- mouseover state
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        enteredFrame = true
        mod.OnEnter(self)
    end)
    slotFrame:SetScript("OnLeave", function()
        enteredFrame = false
        GameTooltip:Hide()
    end)

    -- clicking: Shift = GC, Ctrl+Shift = toggle CPU profiling
    slotFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    slotFrame:SetScript("OnClick", function(self, button)
        mod.OnClick(button)
    end)

    -- update text every second
    local wait = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        wait = wait + elapsed
        if wait < 1 then return end
        wait = 0

        local fps = floor(GetFramerate())
        local _, _, homePing, worldPing = GetNetStats()
        local latency = homePing
        local c = addon:GetTagColor()
        text:SetFormattedText("|c%sFPS:|r %s%d|r |c%sMS:|r %s%d|r", c, StatusColor(fps), fps, c, StatusColor(nil, latency), latency)

        if enteredFrame then
            mod.OnEnter(self)
        end
    end)

    -- Update immediately upon creation
    local function UpdateText()
        local fps = floor(GetFramerate())
        local _, _, homePing, worldPing = GetNetStats()
        local latency = homePing
        text:SetFormattedText("FPS: %s%d|r MS: %s%d|r", StatusColor(fps), fps, StatusColor(nil, latency), latency)
    end
    UpdateText()
    f.Update = UpdateText

    -- Event handling: keep track of addons loaded
    local function OnEvent(self, event, ...)
        if event == "MODIFIER_STATE_CHANGED" then
            if enteredFrame then mod.OnEnter(self) end
        else
            local addOnCount = GetNumAddOns()
            if addOnCount ~= #infoTable then
                wipe(infoTable)
                local counter = 1
                for i = 1, addOnCount do
                    local name, title, _, loadable, reason = GetAddOnInfo(i)
                    if loadable or reason == "DEMAND_LOADED" then
                        infoTable[counter] = {name = name, title = title, index = i}
                        counter = counter + 1
                    end
                end
            end
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("MODIFIER_STATE_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")

    return f
end

-- Click behavior
function mod.OnClick(button)
    local shiftDown = IsShiftKeyDown()
    if shiftDown then
        collectgarbage("collect")
        ResetCPUUsage()
    end
end

-- Tooltip display
function mod.OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearLines()

    local fps = floor(GetFramerate())
    local _, _, homePing, worldPing = GetNetStats()

    GameTooltip:AddLine("SYSTEM")
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("FPS:", fps, .69, .31, .31, .84, .75, .65)
    GameTooltip:AddDoubleLine("Home Latency:", homePing.." ms", .69, .31, .31, .84, .75, .65)
    GameTooltip:AddDoubleLine("World Latency:", worldPing.." ms", .69, .31, .31, .84, .75, .65)

    -- Update memory & CPU usage
    UpdateAddOnMemoryUsage()
    local cpuProfiling = GetCVarBool("scriptProfile")
    if cpuProfiling then
        UpdateAddOnCPUUsage()
    end

    local totalMEM, totalCPU = 0, 0
    local infoDisplay = {}
    for i, data in ipairs(infoTable) do
        if IsAddOnLoaded(data.index) then
            local mem = GetAddOnMemoryUsage(data.index)
            totalMEM = totalMEM + mem
            local cpu = cpuProfiling and GetAddOnCPUUsage(data.index) or nil
            totalCPU = totalCPU + (cpu or 0)

            local displayData = {
                index = data.index,
                title = data.title,
                mem = mem,
                cpu = cpu,
                sort = cpuProfiling and (cpu or mem) or mem
            }
            table.insert(infoDisplay, displayData)
        end
    end

    -- Sort by usage
    table.sort(infoDisplay, function(a,b) return a.sort > b.sort end)

    -- Display addons
    GameTooltip:AddDoubleLine("Total Memory:", BreakUpLargeNumbers(totalMEM).." mb", .69, .31, .31, .84, .75, .65)
    GameTooltip:AddLine(" ")
    for _, data in ipairs(infoDisplay) do
        local memStr = FormatMem(data.mem or 0)
        if cpuProfiling then
            local cpuStr = data.cpu and format("%d ms", floor(data.cpu)) or "0 ms"
            GameTooltip:AddDoubleLine(data.title, memStr.." / "..cpuStr)
        else
            local red = data.mem / totalMEM
		    local green = (1 - red) + .5
            GameTooltip:AddDoubleLine(data.title, memStr, 1, 1, 1, red or 1, green or 1, 0)
        end
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("(Shift Click) Collect Garbage")
    GameTooltip:Show()
end

-- Register with SDT
addon:RegisterDataText("System", mod)

return mod
