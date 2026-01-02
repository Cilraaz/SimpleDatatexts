-- modules/Currency.lua
-- Backpack Currency datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L
local SDTC = SDT.cache

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
local BreakUpLargeNumbers = BreakUpLargeNumbers
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
-- Helpers
----------------------------------------------------
local function FormatMoney(copper, classColor)
    local g = BreakUpLargeNumbers(floor(copper / 10000))
    local s = floor((copper % 10000) / 100)
    local c = copper % 100

    if classColor then
        local goldPart   = SDT:ColorText(g) .. GOLD_ICON
        local silverPart = SDT:ColorText(s) .. SILVER_ICON
        local copperPart = SDT:ColorText(c) .. COPPER_ICON
        return goldPart .. " " .. silverPart .. " " .. copperPart
    else
        return format(
            "|cffffd700%s|r%s |cffc7c7c7%d|r%s |cffeda55f%d|r%s", g, GOLD_ICON, s, SILVER_ICON, c, COPPER_ICON
        )
    end
end

----------------------------------------------------
-- State
----------------------------------------------------
local goldText = "0"

----------------------------------------------------
-- Update logic
----------------------------------------------------
local function UpdateDisplay(self)
    local display = ""

    -- Backpack currencies (1–3 slots)
    for i = 1, 3 do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
        if info and info.quantity and info.iconFileID then
            local icon = format(ICON_FMT, info.iconFileID)
            display = display == ""
                and format("%s %s", icon, info.quantity)
                or format("%s %s %s", display, icon, info.quantity)
        end
    end

    -- Gold
    goldText = FormatMoney(GetMoney(), true)

    if display == "" then
        display = goldText -- fallback
    else
        display = display
    end

    if self.text then
        self.text:SetText(SDT:ColorText(display))
    end
end

----------------------------------------------------
-- Tooltip
----------------------------------------------------
local function ShowTooltip(self)
    local tooltip = GameTooltip
    local anchor = SDT:FindBestAnchorPoint(self)
    tooltip:SetOwner(self, anchor)
    tooltip:ClearLines()

    ------------------------------------------------
    -- HEADER: CURRENCIES
    ------------------------------------------------
    tooltip:AddLine(L["CURRENCIES"])
    tooltip:AddLine(" ")

    for i = 1, 3 do
        local info = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
        if info and info.quantity and info.iconFileID then
            tooltip:AddDoubleLine(
                format("%s %s", format(ICON_FMT, info.iconFileID), info.name or "?"),
                BreakUpLargeNumbers(info.quantity),
                1,1,1, 1,1,1
            )
        end
    end

    ------------------------------------------------
    -- HEADER: GOLD
    ------------------------------------------------
    tooltip:AddLine(" ")
    tooltip:AddLine(L["GOLD"])
    tooltip:AddDoubleLine(UnitName("player"), FormatMoney(GetMoney()), 1,1,1, 1,1,1)

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
    f:RegisterEvent("PLAYER_MONEY")
    f:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
    f:RegisterEvent("SEND_MAIL_COD_CHANGED")
    f:RegisterEvent("PLAYER_TRADE_MONEY")
    f:RegisterEvent("TRADE_MONEY_CHANGED")
    f:RegisterEvent("CHAT_MSG_CURRENCY")
    f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    f:RegisterEvent("PERKS_PROGRAM_CURRENCY_REFRESH")

    hooksecurefunc(C_CurrencyInfo, "SetCurrencyBackpack", function()
        UpdateDisplay(slotFrame)
    end)
    hooksecurefunc(C_CurrencyInfo, "SetCurrencyBackpackByID", function()
        UpdateDisplay(slotFrame)
    end)

    ------------------------------------------------
    -- Tooltip
    ------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", ShowTooltip)
    slotFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
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
SDT:RegisterDataText("Currency", mod)

return mod
