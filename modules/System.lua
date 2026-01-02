-- modules/System.lua
-- System datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetAddOnInfo     = C_AddOns.GetAddOnInfo
local GetNumAddOns     = C_AddOns.GetNumAddOns
local IsAddOnLoaded    = C_AddOns.IsAddOnLoaded
local IsShiftKeyDown   = IsShiftKeyDown
local ResetCPUUsage    = ResetCPUUsage

----------------------------------------------------
-- Misc Locals
----------------------------------------------------
local floor = math.floor
local format = string.format
local tinsert = table.insert
local tsort = table.sort
local wipe = table.wipe
local ipairs = ipairs
local pairs = pairs
local enteredFrame = false
local wait = 0

----------------------------------------------------
-- Status Colors
----------------------------------------------------
local statusColors = {
    '|cff0CD809', -- green
    '|cffE8DA0F', -- yellow
    '|cffFF9000', -- orange
    '|cffD80909', -- red
}

----------------------------------------------------
-- Format Memory
----------------------------------------------------
local function FormatMem(memory)
    if memory >= 1024 then
        return format("%.2f %s", memory / 1024, L["MB_SUFFIX"])
    else
        return format("%d %s", memory, L["KB_SUFFIX"])
    end
end

----------------------------------------------------
-- Status Color Picker
----------------------------------------------------
local function StatusColor(fps, ping)
    if fps then
        return statusColors[fps >= 30 and 1 or (fps >= 20 and 2) or (fps >= 10 and 3) or 4] .. fps .. "|r"
    else
        return statusColors[ping < 150 and 1 or (ping < 300 and 2) or (ping < 500 and 3) or 4] .. ping .. "|r"
    end
end

----------------------------------------------------
-- Tooltip Creation Function
----------------------------------------------------
function mod.OnEnter(self)
    local anchor = SDT:FindBestAnchorPoint(self)
    GameTooltip:SetOwner(self, anchor)
    GameTooltip:ClearLines()

    local fps = floor(GetFramerate())
    local _, _, homePing, worldPing = GetNetStats()

    GameTooltip:AddLine(L["SYSTEM"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["FPS:"], fps, .69, .31, .31, .84, .75, .65)
    GameTooltip:AddDoubleLine(L["Home Latency:"], homePing .. " ms", .69, .31, .31, .84, .75, .65)
    GameTooltip:AddDoubleLine(L["World Latency:"], worldPing .. " ms", .69, .31, .31, .84, .75, .65)

    -- Update memory & CPU usage
    UpdateAddOnMemoryUsage()
    local cpuProfiling = GetCVarBool("scriptProfile")
    if cpuProfiling then
        UpdateAddOnCPUUsage()
    end

    local totalMEM, totalCPU = 0, 0
    local infoDisplay = {}
    for i, data in ipairs(SDT.cache.addonList) do
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
            tinsert(infoDisplay, displayData)
        end
    end

    -- Sort by usage
    tsort(infoDisplay, function(a,b) return a.sort > b.sort end)

    -- Display addons
    GameTooltip:AddDoubleLine(L["Total Memory:"], FormatMem(totalMEM), .69, .31, .31, .84, .75, .65)
    GameTooltip:AddLine(" ")
    for _, data in ipairs(infoDisplay) do
        local memStr = FormatMem(data.mem or 0)
        if cpuProfiling then
            local cpuStr = data.cpu and format("%d ms", floor(data.cpu)) or "0 ms"
            GameTooltip:AddDoubleLine(data.title, memStr.." / "..cpuStr)
        else
            local red = totalMEM > 0 and data.mem / totalMEM or 0
		    local green = (1 - red) + .5
            GameTooltip:AddDoubleLine(data.title, memStr, 1, 1, 1, red or 1, green or 1, 0)
        end
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["(Shift Click) Collect Garbage"])
    GameTooltip:Show()
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

    ----------------------------------------------------
    -- Tooltip Handler
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        enteredFrame = true
        mod.OnEnter(self)
    end)
    slotFrame:SetScript("OnLeave", function()
        enteredFrame = false
        GameTooltip:Hide()
    end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" and IsShiftKeyDown() then
            collectgarbage("collect")
            ResetCPUUsage()
        end
    end)

    ----------------------------------------------------
    -- Update Logic
    ----------------------------------------------------
    local function UpdateText()
        local fps = floor(GetFramerate())
        local _, _, homePing, worldPing = GetNetStats()
        local latency = homePing
        local textString = SDT:ColorText(L["FPS"] .. ": ") .. StatusColor(fps) .. SDT:ColorText(" " .. L["MS"] .. ": ") .. StatusColor(nil, latency)
        text:SetText(textString)
    end

    f:SetScript("OnUpdate", function(self, elapsed)
        wait = wait + elapsed
        if wait < 1 then return end
        wait = 0

        UpdateText()

        if enteredFrame then
            mod.OnEnter(slotFrame)
        end
    end)

    UpdateText()
    f.Update = UpdateText

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if enteredFrame then mod.OnEnter(self) end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("MODIFIER_STATE_CHANGED")

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("System", mod)

return mod
