-- modules/Currency.lua
-- Backpack Currency datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- lua locals
----------------------------------------------------
local floor  = math.floor
local format = string.format

----------------------------------------------------
-- WoW API locals
----------------------------------------------------
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo
local GetMoney            = GetMoney
local UnitName            = UnitName

----------------------------------------------------
-- Constants
----------------------------------------------------
local GOLD_ICON   = "|TInterface\\AddOns\\SimpleDatatexts\\textures\\Coins:10:10:0:0:64:32:22:42:1:20|t"
local SILVER_ICON = "|TInterface\\AddOns\\SimpleDatatexts\\textures\\Coins:10:10:0:0:64:32:43:64:1:20|t"
local COPPER_ICON = "|TInterface\\AddOns\\SimpleDatatexts\\textures\\Coins:10:10:0:0:64:32:0:21:1:20|t"
local ICON_FMT = '|T%s:16:16:0:0:64:64:4:60:4:60|t'

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Currency"

----------------------------------------------------
-- Helpers
----------------------------------------------------
local function FormatMoney(copper, classColor)
    local g = SDT.FormatUtils:FormatLargeNumbers(floor(copper / 10000))
    local s = floor((copper % 10000) / 100)
    local c = copper % 100

    if classColor then
        local goldPart   = SDT.FormatUtils:ColorText(g) .. GOLD_ICON
        local silverPart = SDT.FormatUtils:ColorText(s) .. SILVER_ICON
        local copperPart = SDT.FormatUtils:ColorText(c) .. COPPER_ICON
        return goldPart .. " " .. silverPart .. " " .. copperPart
    else
        return format(
            "|cffffd700%s|r%s |cffc7c7c7%d|r%s |cffeda55f%d|r%s", g, GOLD_ICON, s, SILVER_ICON, c, COPPER_ICON
        )
    end
end

-- Get number of currently tracked currencies
local function GetNumTrackedCurrencies()
    local count = 0
    for i = 1, 8 do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
        if info and info.name then
            count = count + 1
        else
            break
        end
    end
    return count
end

-- Get all currently tracked currencies with their info
local function GetTrackedCurrencies()
    local currencies = {}
    for i = 1, 8 do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
        if info and info.name then
            currencies[i] = {
                index = i,
                name = info.name,
                iconFileID = info.iconFileID,
                quantity = info.quantity
            }
        end
    end
    return currencies
end

-- Get a map of currencyTypesID to current backpack index
local function GetCurrencyTypeIDToIndex()
    local typeIDToIndex = {}
    for i = 1, 8 do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
        if info and info.name and info.currencyTypesID then
            typeIDToIndex[info.currencyTypesID] = i
        end
    end
    return typeIDToIndex
end

-- Compact the currency order settings to remove gaps
local function CompactCurrencyOrder()
    local orderedTypeIDs = {}
    local usedTypeIDs = {}
    
    -- Step 1: Read user's order by currencyTypesID
    for position = 1, 8 do
        local settingKey = "currencyTypeID" .. position
        local typeID = SDT:GetModuleSetting(moduleName, settingKey, nil)
        
        if typeID and not usedTypeIDs[typeID] then
            -- Check if this currency is still tracked
            local typeIDToIndex = GetCurrencyTypeIDToIndex()
            if typeIDToIndex[typeID] then
                orderedTypeIDs[#orderedTypeIDs + 1] = typeID
                usedTypeIDs[typeID] = true
            end
        end
    end
    
    -- Step 2: Find newly tracked currencies and append them
    local typeIDToIndex = GetCurrencyTypeIDToIndex()
    for typeID, _ in pairs(typeIDToIndex) do
        if not usedTypeIDs[typeID] then
            orderedTypeIDs[#orderedTypeIDs + 1] = typeID
            usedTypeIDs[typeID] = true
        end
    end
    
    -- Step 3: Write back the compacted order
    for position = 1, 8 do
        local settingKey = "currencyTypeID" .. position
        if orderedTypeIDs[position] then
            SDT:SetModuleSetting(moduleName, settingKey, orderedTypeIDs[position])
        else
            -- Clear this position
            SDT:SetModuleSetting(moduleName, settingKey, nil)
        end
    end
end

-- Get the ordered indices based on user settings
local function GetOrderedIndices()
    local orderedIndices = {}
    local trackedQty = SDT:GetModuleSetting(moduleName, "trackedQty", 3)
    local typeIDToIndex = GetCurrencyTypeIDToIndex()
    
    -- Go through each position and get the currency by typeID
    for i = 1, trackedQty do
        local settingKey = "currencyTypeID" .. i
        local typeID = SDT:GetModuleSetting(moduleName, settingKey, nil)
        
        if typeID then
            local backpackIndex = typeIDToIndex[typeID]
            if backpackIndex then
                orderedIndices[#orderedIndices + 1] = backpackIndex
            end
        end
    end
    
    return orderedIndices
end

-- Refresh config UI when currencies change
local function RefreshConfigUI()
    CompactCurrencyOrder()
    
    -- Notify AceConfig that the options table has changed
    local AceConfigRegistry = LibStub("AceConfigRegistry-3.0", true)
    if AceConfigRegistry then
        AceConfigRegistry:NotifyChange("SimpleDatatexts")
    end
end

----------------------------------------------------
-- State
----------------------------------------------------
local goldText = "0"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "range", L["Tracked Currency Qty"], "trackedQty", 3, 1, 8, 1)

    -- Add separator for ordering section
    SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, L["Currency Display Order"])
    
    -- Add 8 currency order dropdowns
    for i = 1, 8 do
        SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "currencyOrder", format(L["Position %d"], i), "currencyOrder" .. i, i)
    end

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Update logic
----------------------------------------------------
local function UpdateDisplay(self)
    local display = ""

    -- Get ordered currency indices
    local orderedIndices = GetOrderedIndices()

    -- Display the currencies
    for i = 1, #orderedIndices do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(orderedIndices[i])
        if info and info.quantity and info.iconFileID then
            local formattedQty = SDT.FormatUtils:FormatLargeNumbers(info.quantity)
            local icon = format(ICON_FMT, info.iconFileID)
            display = display == ""
                and format("%s %s", icon, formattedQty)
                or format("%s %s %s", display, icon, formattedQty)
        end
    end

    -- Gold
    goldText = FormatMoney(GetMoney(), true)

    if display == "" then display = goldText end -- fallback

    if self.text then
        self.text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, display))
        SDT.FontManager:ApplyModuleFont(moduleName, self.text)
    end
end

----------------------------------------------------
-- Tooltip
----------------------------------------------------
local function ShowTooltip(self)
    local tooltip = SDT.Tooltip
    local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
    tooltip:SetOwner(self, anchor)
    tooltip:ClearLines()

    ------------------------------------------------
    -- HEADER: CURRENCIES
    ------------------------------------------------
    if not SDT.db.profile.hideModuleTitle then
        SDT.FormatUtils:AddTooltipHeader(tooltip, nil, L["CURRENCIES"])
        SDT.FormatUtils:AddTooltipLine(tooltip, nil, " ")
    end

    -- Get ordered currency indices
    local orderedIndices = GetOrderedIndices()

    for i = 1, #orderedIndices do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(orderedIndices[i])
        if info and info.quantity and info.iconFileID then
            SDT.FormatUtils:AddTooltipLine(tooltip, nil, 
                format("%s %s", format(ICON_FMT, info.iconFileID), info.name or "?"),
                SDT.FormatUtils:FormatLargeNumbers(info.quantity),
                1,1,1, 1,1,1
            )
        end
    end

    ------------------------------------------------
    -- HEADER: GOLD
    ------------------------------------------------
    SDT.FormatUtils:AddTooltipLine(tooltip, nil, " ")
    if not SDT.db.profile.hideModuleTitle then
        SDT.FormatUtils:AddTooltipHeader(tooltip, nil, L["GOLD"])
    end
    SDT.FormatUtils:AddTooltipLine(tooltip, nil, UnitName("player"), FormatMoney(GetMoney()), 1,1,1, 1,1,1)

    tooltip:Show()
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

    ------------------------------------------------
    -- Events
    ------------------------------------------------
    local function OnEvent()
        UpdateDisplay(slotFrame)
    end
    f.Update = function() OnEvent(f) end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("CHAT_MSG_CURRENCY")
    f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

    hooksecurefunc(C_CurrencyInfo, "SetCurrencyBackpack", function()
        RefreshConfigUI()
        UpdateDisplay(slotFrame)
    end)
    hooksecurefunc(C_CurrencyInfo, "SetCurrencyBackpackByID", function()
        RefreshConfigUI()
        UpdateDisplay(slotFrame)
    end)

    ------------------------------------------------
    -- Tooltip
    ------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", ShowTooltip)
    slotFrame:SetScript("OnLeave", function() SDT.Tooltip:Hide() end)
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            _G.ToggleCharacter('TokenFrame')
        end
    end)

    ------------------------------------------------
    UpdateDisplay(slotFrame)
    return f
end

----------------------------------------------------
-- Register
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
