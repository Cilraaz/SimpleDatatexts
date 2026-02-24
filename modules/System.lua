-- modules/System.lua
-- System datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
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
local moduleName = "System"

----------------------------------------------------
-- Cache Locals
----------------------------------------------------
local addonDataCache = nil
local lastCacheUpdate = 0
local CACHE_DURATION = 2 -- Cache data for 2 seconds

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
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "range", L["Top Addons in Tooltip"], "addonQty", 10, 1, 30, 1)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Format CPU
----------------------------------------------------
local function FormatCpu(time)
    if time >= 60000 then
        return format("%.2f %s", time / 60000, L["MIN_SUFFIX"])
    elseif time >= 1000 then
        return format("%.2f %s", time / 1000, L["SEC_SUFFIX"])
    else
        return format("%d %s", time, L["MS_SUFFIX"])
    end
end

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
-- Get Cached Addon Data
----------------------------------------------------
local function GetCachedAddonData()
    local now = GetTime()
    
    -- Return cached data if still fresh
    if addonDataCache and (now - lastCacheUpdate) < CACHE_DURATION then
        return addonDataCache
    end
    
    -- Update cache
    UpdateAddOnMemoryUsage()
    local cpuProfiling = GetCVarBool("scriptProfile")
    if cpuProfiling then
        UpdateAddOnCPUUsage()
    end
    
    local totalMEM, totalCPU = 0, 0
    local infoDisplay = {}
    
    for i, data in ipairs(SDT:GetAddonList()) do
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
    table.sort(infoDisplay, function(a, b) return a.sort > b.sort end)
    
    addonDataCache = {
        totalMEM = totalMEM,
        totalCPU = totalCPU,
        cpuProfiling = cpuProfiling,
        addons = infoDisplay,
        timestamp = now
    }
    
    lastCacheUpdate = now
    
    return addonDataCache
end

----------------------------------------------------
-- Tooltip Creation Function
----------------------------------------------------
function mod.OnEnter(self)
    local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
    SDT.Tooltip:SetOwner(self, anchor)
    SDT.Tooltip:ClearLines()

    if not SDT.db.profile.hideModuleTitle then
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, L["SYSTEM"])
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
    end

    local fps = floor(GetFramerate())
    local _, _, homePing, worldPing = GetNetStats()

    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["FPS:"], fps, .69, .31, .31, .84, .75, .65)
    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Home Latency:"], homePing .. " ms", .69, .31, .31, .84, .75, .65)
    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["World Latency:"], worldPing .. " ms", .69, .31, .31, .84, .75, .65)

    -- Use cached data if not stale
    local cachedData = GetCachedAddonData()

    -- Display addons
    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Total Memory:"], FormatMem(cachedData.totalMEM), .69, .31, .31, .84, .75, .65)
    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")

    if cachedData.cpuProfiling then
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Total CPU:"], FormatCpu(cachedData.totalCPU), .69, .31, .31, .84, .75, .65)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Top Addons by CPU:"])
    else
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Top Addons by Memory:"])
    end

    -- Display top addons from cached data
    local addonQty = SDT:GetModuleSetting(moduleName, "addonQty", 10)
    local addonFontSize = SDT.db.profile.tooltipLineFontSize - 1
    for i = 1, min(addonQty, #cachedData.addons) do
        local addon = cachedData.addons[i]
        if cachedData.cpuProfiling then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, addonFontSize, 
                addon.title, 
                FormatCpu(addon.cpu) .. " / " .. FormatMem(addon.mem), 
                .84, .75, .65, .84, .75, .65
            )
        else
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, addonFontSize, 
                addon.title, 
                FormatMem(addon.mem), 
                .84, .75, .65, .84, .75, .65
            )
        end
    end

    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["(Shift Click) Collect Garbage"])
    SDT.Tooltip:Show()
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
        SDT.Tooltip:Hide()
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
        local latency = worldPing
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local textString
        if showLabel then
            textString = SDT.FormatUtils:ColorModuleText(moduleName, L["FPS"] .. ": ") .. StatusColor(fps) .. SDT.FormatUtils:ColorModuleText(moduleName, " " .. L["MS"] .. ": ") .. StatusColor(nil, latency)
        else
            local separator = SDT.FormatUtils:ColorModuleText(moduleName, " | ")
            textString = StatusColor(fps) .. separator .. StatusColor(nil, latency)
        end
        text:SetText(textString)
        SDT.FontManager:ApplyModuleFont(moduleName, text)
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
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
