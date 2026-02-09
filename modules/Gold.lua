-- modules/Gold.lua
-- Gold & Currency datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- lua locals
----------------------------------------------------
local format  = string.format
local tinsert = table.insert
local sort    = table.sort

----------------------------------------------------
-- WoW API locals
----------------------------------------------------
local C_Bank_FetchDepositedMoney             = C_Bank and C_Bank.FetchDepositedMoney
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo and C_CurrencyInfo.GetBackpackCurrencyInfo
local C_Timer_NewTicker                      = C_Timer and C_Timer.NewTicker
local C_WowTokenPublic_GetCurrentMarketPrice = C_WowTokenPublic.GetCurrentMarketPrice
local C_WowTokenPublic_UpdateMarketPrice     = C_WowTokenPublic.UpdateMarketPrice
local GetBuildInfo                           = GetBuildInfo
local GetMoney                               = GetMoney
local GetRealmName                           = GetRealmName
local IsLoggedIn                             = IsLoggedIn
local IsShiftKeyDown                         = IsShiftKeyDown
local IsControlKeyDown                       = IsControlKeyDown
local UnitName                               = UnitName
local WARBANDBANK_TYPE                       = (Enum.BankType and Enum.BankType.Account) or 2

----------------------------------------------------
-- State
----------------------------------------------------
local Profit, Spent = 0, 0
local Ticker = nil
local myGold = {}
local totalGold, totalHorde, totalAlliance, warbandGold = 0, 0, 0, 0
local iconStringName = '|T%s:16:16:0:0:64:64:4:60:4:60|t %s'
local GOLD_ICON = "|TInterface\\AddOns\\SimpleDatatexts\\textures\\Coins:10:10:0:0:64:32:22:42:1:20|t"
local SILVER_ICON = "|TInterface\\AddOns\\SimpleDatatexts\\textures\\Coins:10:10:0:0:64:32:43:64:1:20|t"
local COPPER_ICON = "|TInterface\\AddOns\\SimpleDatatexts\\textures\\Coins:10:10:0:0:64:32:0:21:1:20|t"

----------------------------------------------------
-- File locals
----------------------------------------------------
local moduleName = "Gold"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Show Silver"], "showSilver", true)
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Show Copper"], "showCopper", true)
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Use Coin Icons"], "useCoinIcons", true)

    SDT:AddModuleConfigSeparator(moduleName, L["Display Quantities"])
    SDT:AddModuleConfigSetting(moduleName, "range", L["Characters to Show"], "characterQty", 20, 1, 100, 1)
    SDT:AddModuleConfigSetting(moduleName, "range", L["Servers to Show"], "serverQty", 20, 1, 100, 1)

    SDT:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Helpers
----------------------------------------------------
local function SortFunction(a,b) return (a.amount or 0) > (b.amount or 0) end

local function UpdateMarketPrice()
    return C_WowTokenPublic_UpdateMarketPrice()
end

local function InitTicker()
    if not Ticker then
        UpdateMarketPrice()
        Ticker = C_Timer_NewTicker(60, UpdateMarketPrice)
    end
end

local function UpdateTotal(faction, change)
    if faction == 'Alliance' then
        totalAlliance = totalAlliance + change
    elseif faction == 'Horde' then
        totalHorde = totalHorde + change
    end
    totalGold = totalGold + change
end

local function UpdateWarbandGold()
    warbandGold = C_Bank_FetchDepositedMoney and C_Bank_FetchDepositedMoney(WARBANDBANK_TYPE) or 0
end

local function DisplayCurrencyInfo(tooltip)
    local index = 1
    local info = C_CurrencyInfo_GetBackpackCurrencyInfo(index)
    local _, _, _, toc = GetBuildInfo()
    while info and info.name do
        if index == 1 then GameTooltip:AddLine(" ") end
        if (info.name ~= "Valorstones" or toc < 120001) and info.quantity then
            GameTooltip:AddDoubleLine(format(iconStringName, info.iconFileID, info.name), SDT:FormatLargeNumbers(info.quantity), 1,1,1, 1,1,1)
        end
        index = index + 1
        info, name = C_CurrencyInfo_GetBackpackCurrencyInfo(index)
    end
end

local function FormatMoney(copper, customColor)
    local showCopper = SDT:GetModuleSetting(moduleName, "showCopper", true)
    local showSilver = SDT:GetModuleSetting(moduleName, "showSilver", true)
    local useCoinIcons = SDT:GetModuleSetting(moduleName, "useCoinIcons", true)
    local g = SDT:FormatLargeNumbers(floor(copper / 10000))
    local s = floor((copper % 10000) / 100)
    local c = copper % 100
    if customColor then
        local goldPart = SDT:ColorModuleText(moduleName, g) .. (useCoinIcons and GOLD_ICON or SDT:ColorModuleText(moduleName, "g"))
        local silverPart = SDT:ColorModuleText(moduleName, s) .. (useCoinIcons and SILVER_ICON or SDT:ColorModuleText(moduleName, "s"))
        local copperPart = SDT:ColorModuleText(moduleName, c) .. (useCoinIcons and COPPER_ICON or SDT:ColorModuleText(moduleName, "c"))
        local retString = goldPart
        if showSilver then
            retString = retString .. " " .. silverPart
        end
        if showCopper then
            retString = retString .. " " .. copperPart
        end
        return retString
    else
        local retString = "|cffffd700" .. g .. "|r" .. (useCoinIcons and GOLD_ICON or "|cffffd700g|r")
        if showSilver then
            retString = retString .. " |cffc7c7c7" .. s .. "|r" .. (useCoinIcons and SILVER_ICON or "|cffc7c7c7s|r")
        end
        if showCopper then
            retString = retString .. " |cffeda55f" .. c .. "|r" .. (useCoinIcons and COPPER_ICON or "|cffeda55fc|r")
        end
        return retString
    end
end

local function RebuildGoldCache()
    wipe(myGold)
    totalGold, totalHorde, totalAlliance = 0, 0, 0
    for realm, chars in pairs(SDT.db.global.gold) do
        for name, charValues in pairs(chars) do
            tinsert(myGold, {
                name = name,
                realm = realm,
                amount = charValues.amount,
                amountText = FormatMoney(charValues.amount),
                faction = charValues.faction,
                r = 1, g = 1, b = 1,
            })
            UpdateTotal(charValues.faction, charValues.amount)
        end
    end
end

local function ShowGoldDeleteConfirmation(characterName, realmName)
    local dialog = StaticPopupDialogs["SDT_CONFIRM_GOLD_DELETE"]
    if not dialog then
        StaticPopupDialogs["SDT_CONFIRM_GOLD_DELETE"] = {
            text = "",
            button1 = L["Yes"],
            button2 = L["No"],
            OnAccept = function(self)
                local char = self.characterName
                local realm = self.realmName
                
                if char == "ALL" then
                    -- Clear all gold data
                    SDT.db.global.gold = {}
                    SDT:Print(L["Gold: All data reset!"])
                else
                    -- Clear specific character
                    if SDT.db.global.gold[realm] and SDT.db.global.gold[realm][char] then
                        SDT.db.global.gold[realm][char] = nil
                        
                        -- If realm is now empty, remove it too
                        local hasChars = false
                        for _ in pairs(SDT.db.global.gold[realm] or {}) do
                            hasChars = true
                            break
                        end
                        if not hasChars then
                            SDT.db.global.gold[realm] = nil
                        end
                        
                        SDT:Print(string.format(L["Gold: Data reset for %s!"], char))
                    end
                end
                
                -- Rebuild the gold cache so tooltip updates
                RebuildGoldCache()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
    end
    
    local displayName = characterName
    if characterName ~= "ALL" then
        displayName = characterName .. " - " .. realmName
    end
    
    StaticPopupDialogs["SDT_CONFIRM_GOLD_DELETE"].text = 
        string.format(L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"], displayName)
    
    local popup = StaticPopup_Show("SDT_CONFIRM_GOLD_DELETE")
    if popup then
        popup.characterName = characterName
        popup.realmName = realmName
    end
end

-- Create the character selection menu using custom scrollable dropdown
local function ShowGoldDeleteMenu(slotFrame)
    local maxVisibleItems = 20 -- Maximum items to show before scrolling
    
    -- Collect all characters from all realms
    local characters = {}
    for realmName, realmData in pairs(SDT.db.global.gold or {}) do
        for charName, charData in pairs(realmData) do
            tinsert(characters, {
                name = charName,
                realm = realmName,
                faction = charData.faction,
                amount = charData.amount or 0
            })
        end
    end
    
    -- Sort by realm then name
    sort(characters, function(a, b)
        if a.realm == b.realm then
            return a.name < b.name
        end
        return a.realm < b.realm
    end)
    
    -- Count total items (ALL button + divider + realm headers + characters + dividers between realms)
    local totalItems = 2 -- ALL button + divider
    if #characters > 0 then
        local realmCount = 0
        local lastRealm = nil
        for _, charInfo in ipairs(characters) do
            if charInfo.realm ~= lastRealm then
                realmCount = realmCount + 1
                lastRealm = charInfo.realm
                if realmCount > 1 then
                    totalItems = totalItems + 1 -- divider between realms
                end
                totalItems = totalItems + 1 -- realm header
            end
            totalItems = totalItems + 1 -- character button
        end
    else
        totalItems = totalItems + 1 -- "No character data" message
    end
    
    -- Close any existing custom dropdown
    if SDT.goldDeleteDropdown then
        SDT.goldDeleteDropdown:Hide()
        SDT.goldDeleteDropdown = nil
    end
    
    -- Create custom scrollable dropdown
    local dropdown = CreateFrame("Frame", "SDT_GoldDeleteDropdown", UIParent, "BackdropTemplate")
    SDT.goldDeleteDropdown = dropdown
    
    local itemHeight = 18
    local visibleHeight = math.min(totalItems, maxVisibleItems) * itemHeight
    local dropdownWidth = 200
    local backdropInsets = 4
    
    dropdown:SetSize(dropdownWidth, visibleHeight + backdropInsets)
    dropdown:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = false,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    dropdown:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
    dropdown:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    dropdown:SetFrameStrata("FULLSCREEN_DIALOG")
    dropdown:SetClampedToScreen(true)
    
    -- Position at cursor
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    dropdown:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale)
    
    -- Close on escape
    dropdown:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            self:Hide()
        end
    end)
    dropdown:SetPropagateKeyboardInput(false)
    
    -- Create scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", nil, dropdown)
    scrollFrame:SetPoint("TOPLEFT", 2, -2)
    scrollFrame:SetPoint("BOTTOMRIGHT", -20, 2)
    
    -- Create scroll child (content container)
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(dropdownWidth - 22, totalItems * itemHeight)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Create scrollbar (only visible if needed)
    local scrollbar = CreateFrame("Slider", nil, dropdown, "UIPanelScrollBarTemplate")
    scrollbar:SetPoint("TOPRIGHT", dropdown, "TOPRIGHT", -3, -18)
    scrollbar:SetPoint("BOTTOMRIGHT", dropdown, "BOTTOMRIGHT", -3, 18)
    scrollbar:SetMinMaxValues(0, math.max(0, (totalItems * itemHeight) - visibleHeight))
    scrollbar:SetValueStep(itemHeight)
    scrollbar:SetObeyStepOnDrag(true)
    scrollbar:SetWidth(18)
    
    if totalItems <= maxVisibleItems then
        scrollbar:Hide()
    end
    
    scrollbar:SetScript("OnValueChanged", function(self, value)
        scrollFrame:SetVerticalScroll(value)
    end)
    
    -- Mouse wheel scrolling
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local current = scrollbar:GetValue()
        local minVal, maxVal = scrollbar:GetMinMaxValues()
        local newValue = current - (delta * itemHeight * 3)
        newValue = math.max(minVal, math.min(maxVal, newValue))
        scrollbar:SetValue(newValue)
    end)
    
    -- Create buttons
    local itemIndex = 0
    
    local function CreateButton(charName, charFaction, goldAmount, onClick)
        local btn = CreateFrame("Button", nil, scrollChild)
        btn:SetSize(dropdownWidth - 22, itemHeight)
        btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(itemIndex * itemHeight))
        
        -- Character name (left-aligned)
        local factionColor = charFaction == "Alliance" and "|cFF0078FF" or "|cFFFF0000"
        local nameText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        nameText:SetPoint("LEFT", btn, "LEFT", 5, 0)
        nameText:SetText(string.format("%s%s|r", factionColor, charName))
        
        -- Gold amount (right-aligned)
        local gold = math.floor(goldAmount / 10000)
        local goldText = SDT:FormatLargeNumbers(gold)
        local goldDisplay = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        goldDisplay:SetPoint("RIGHT", btn, "RIGHT", -5, 0)
        goldDisplay:SetText(string.format("|cFFFFD700%sg|r", goldText))
        
        -- Highlight texture
        local highlight = btn:CreateTexture(nil, "BACKGROUND")
        highlight:SetAllPoints(btn)
        highlight:SetColorTexture(0.3, 0.3, 0.8, 0.5)
        btn:SetHighlightTexture(highlight)
        
        btn:SetScript("OnClick", function()
            onClick()
            dropdown:Hide()
        end)
        
        itemIndex = itemIndex + 1
        return btn
    end
    
    local function CreateSimpleButton(text, onClick)
        local btn = CreateFrame("Button", nil, scrollChild)
        btn:SetSize(dropdownWidth - 22, itemHeight)
        btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(itemIndex * itemHeight))
        
        btn:SetNormalFontObject("GameFontHighlightSmall")
        btn:SetHighlightFontObject("GameFontHighlightSmall")
        
        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        btnText:SetPoint("CENTER", btn, "CENTER", 0, 0)
        btnText:SetText(text)
        btn:SetFontString(btnText)
        
        -- Highlight texture
        local highlight = btn:CreateTexture(nil, "BACKGROUND")
        highlight:SetAllPoints(btn)
        highlight:SetColorTexture(0.3, 0.3, 0.8, 0.5)
        btn:SetHighlightTexture(highlight)
        
        btn:SetScript("OnClick", function()
            onClick()
            dropdown:Hide()
        end)
        
        itemIndex = itemIndex + 1
        return btn
    end
    
    local function CreateHeader(text)
        local header = CreateFrame("Frame", nil, scrollChild)
        header:SetSize(dropdownWidth - 22, itemHeight)
        header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(itemIndex * itemHeight))
        
        local headerText = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        headerText:SetPoint("CENTER", header, "CENTER", 0, 0)
        headerText:SetText(text)
        
        itemIndex = itemIndex + 1
        return header
    end
    
    local function CreateDivider()
        local divider = CreateFrame("Frame", nil, scrollChild)
        divider:SetSize(dropdownWidth - 22, itemHeight)
        divider:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(itemIndex * itemHeight))
        
        local line = divider:CreateTexture(nil, "BACKGROUND")
        line:SetHeight(1)
        line:SetPoint("LEFT", divider, "LEFT", 5, 0)
        line:SetPoint("RIGHT", divider, "RIGHT", -5, 0)
        line:SetColorTexture(0.4, 0.4, 0.4, 1)
        
        itemIndex = itemIndex + 1
        return divider
    end
    
    -- Add "ALL" option
    CreateSimpleButton(L["|cFFFF0000ALL CHARACTERS|r"], function()
        ShowGoldDeleteConfirmation("ALL", nil)
    end)
    
    -- Add divider
    CreateDivider()
    
    if #characters > 0 then
        local currentRealm = nil
        for _, charInfo in ipairs(characters) do
            -- Add realm header if this is a new realm
            if charInfo.realm ~= currentRealm then
                currentRealm = charInfo.realm
                if currentRealm ~= characters[1].realm then
                    CreateDivider()
                end
                CreateHeader("|cFF00CCFF" .. charInfo.realm .. "|r")
            end
            
            -- Add character button with name left-aligned and gold right-aligned
            CreateButton(
                charInfo.name,
                charInfo.faction,
                charInfo.amount,
                function()
                    ShowGoldDeleteConfirmation(charInfo.name, charInfo.realm)
                end
            )
        end
    else
        CreateHeader(L["|cFF808080No character data found|r"])
    end
    
    -- Close on click outside
    dropdown:SetScript("OnHide", function()
        SDT.goldDeleteDropdown = nil
    end)
    
    -- Close on right click anywhere
    dropdown:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            self:Hide()
        end
    end)
    
    -- Create invisible close button that covers entire screen
    local closeButton = CreateFrame("Button", nil, UIParent)
    closeButton:SetFrameStrata("FULLSCREEN")
    closeButton:SetAllPoints(UIParent)
    closeButton:SetScript("OnClick", function()
        dropdown:Hide()
        closeButton:Hide()
    end)
    closeButton:Show()
    
    dropdown:SetScript("OnHide", function()
        closeButton:Hide()
        SDT.goldDeleteDropdown = nil
    end)
    
    -- Show the dropdown after close button so it's on top
    closeButton:SetFrameLevel(dropdown:GetFrameLevel() - 1)
    dropdown:Show()
    
    -- Set initial scroll position
    scrollbar:SetValue(0)
end

----------------------------------------------------
-- Update logic
----------------------------------------------------
local function UpdateGold(self)
    if not IsLoggedIn() then return end

    local playerName = SDT.cache.playerName
    local realmName = SDT.cache.playerRealmProper
    local faction = SDT.cache.playerFaction
    SDT.db.global.gold[realmName] = SDT.db.global.gold[realmName] or {}
    SDT.db.global.gold[realmName][playerName] = SDT.db.global.gold[realmName][playerName] or {}
    SDT.db.global.gold[realmName][playerName].faction = faction

    local oldMoney = SDT.db.global.gold[realmName][playerName].amount
    local newMoney = GetMoney()
    SDT.db.global.gold[realmName][playerName].amount = newMoney

    local change = (oldMoney and (newMoney - oldMoney)) or 0
    if change ~= 0 then
        if change > 0 then
            Profit = Profit + change
        else
            Spent = Spent - change
        end

        -- Update faction and overall totals
        UpdateTotal(faction, change)

        -- Update cache with new gold amount
        for _, g in ipairs(myGold) do
            if g.name == playerName and g.realm == realmName then
                g.amount = newMoney
                g.amountText = FormatMoney(newMoney)
                break
            end
        end
    end

    -- Update displayed text
    if self.text then
        self.text:SetText(FormatMoney(newMoney, true))
        SDT:ApplyModuleFont(moduleName, self.text)
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
    if not SDT.db.profile.hideModuleTitle then
        SDT:AddTooltipHeader(tooltip, 14, L["GOLD"])
        SDT:AddTooltipLine(tooltip, 12, " ")
    end

    -- Session info
    SDT:AddTooltipLine(tooltip, 12, L["Session:"])
    SDT:AddTooltipLine(tooltip, 12, L["Earned:"], FormatMoney(Profit), 1,1,1,1,1,1)
    SDT:AddTooltipLine(tooltip, 12, L["Spent:"], FormatMoney(Spent), 1,1,1,1,1,1)
    if Spent ~= 0 then
        local gained = Profit > Spent
        SDT:AddTooltipLine(tooltip, 12, 
            gained and L["Profit:"] or L["Deficit:"],
            FormatMoney(Profit-Spent),
            gained and 0 or 1, gained and 1 or 0, 0, 1,1,1)
    end

    SDT:AddTooltipLine(tooltip, 12, " ")
    SDT:AddTooltipLine(tooltip, 12, L["Character:"])
    sort(myGold, SortFunction)
    local total = #myGold
    local maxChars = SDT:GetModuleSetting(moduleName, "characterQty", 20)
    for i = 1, math.min(maxChars, total) do
        local g = myGold[i]
        local toonName = g.name .. (g.realm and g.realm ~= _G.GetRealmName() and ' - '..g.realm or '')
        if g.faction and g.faction ~= 'Neutral' and g.faction ~= '' then
            toonName = format('|TInterface\\FriendsFrame\\PlusManz-%s:14|t ', g.faction) .. toonName
        end
        SDT:AddTooltipLine(tooltip, 12, (g.name == _G.UnitName("player") and toonName..' |TInterface\\COMMON\\Indicator-Green:14|t' or toonName),
            g.amountText, g.r, g.g, g.b, 1,1,1)
    end

    SDT:AddTooltipLine(tooltip, 12, " ")
    SDT:AddTooltipLine(tooltip, 12, L["Server:"])
    local serverGold = {}
    for _, charData in pairs(myGold) do
        if not serverGold[charData.realm] then
            serverGold[charData.realm] = charData.amount
        else
            serverGold[charData.realm] = serverGold[charData.realm] + charData.amount
        end
    end
    local sortedServerGold = {}
    for realm, amount in pairs(serverGold) do
        tinsert(sortedServerGold, {realm = realm, amount = amount})
    end
    sort(sortedServerGold, SortFunction)
    local maxServers = SDT:GetModuleSetting(moduleName, "serverQty", 20)
    for i = 1, math.min(maxServers, #sortedServerGold) do
        local data = sortedServerGold[i]
        SDT:AddTooltipLine(tooltip, 12, data.realm, FormatMoney(data.amount), 1,1,1,1,1,1)
    end

    SDT:AddTooltipLine(tooltip, 12, " ")
    SDT:AddTooltipLine(tooltip, 12, L["Faction:"])
    if totalAlliance > 0 then
        SDT:AddTooltipLine(tooltip, 12, L["Alliance:"], FormatMoney(totalAlliance), 0, .376,1,1,1,1)
    end
    if totalHorde > 0 then
        SDT:AddTooltipLine(tooltip, 12, L["Horde:"], FormatMoney(totalHorde), 1, .2, .2, 1,1,1)
    end
    SDT:AddTooltipLine(tooltip, 12, " ")
    SDT:AddTooltipLine(tooltip, 12, L["Total:"], FormatMoney(totalGold), 1,1,1,1,1,1)
    SDT:AddTooltipLine(tooltip, 12, L["Warband:"], FormatMoney(warbandGold), 1,1,1,1,1,1)
    if C_WowTokenPublic_GetCurrentMarketPrice then
        SDT:AddTooltipLine(tooltip, 12, " ")
        SDT:AddTooltipLine(tooltip, 12, L["WoW Token:"], FormatMoney(C_WowTokenPublic_GetCurrentMarketPrice() or 0), 0,.8,1,1,1,1)
    end
    DisplayCurrencyInfo()

    SDT:AddTooltipLine(tooltip, 12, " ")
    SDT:AddTooltipLine(tooltip, 12, "|cffaaaaaa" .. L["Reset Session Data:"], L["Hold Shift + Right Click"] .. "|r")
    SDT:AddTooltipLine(tooltip, 12, "|cffaaaaaa" .. L["Reset Character Gold Data:"], L["Hold Alt + Right Click"] .. "|r")
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

    -- Build myGold cache
    if not next(myGold) then
        RebuildGoldCache()
    end

    InitTicker()

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(_, event)
        UpdateWarbandGold()
        UpdateGold(slotFrame)
        if not SDT.db.global.gold[SDT.cache.playerRealmProper][SDT.cache.playerName] then
            RebuildGoldCache()
        end
    end
    f.Update = function() OnEvent(f) end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_MONEY")
    f:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
    f:RegisterEvent("SEND_MAIL_COD_CHANGED")
    f:RegisterEvent("PLAYER_TRADE_MONEY")
    f:RegisterEvent("TRADE_MONEY_CHANGED")
    f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

    ----------------------------------------------------
    -- Tooltip Handler
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", ShowTooltip)
    slotFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            if IsShiftKeyDown() then
                -- Reset session data
                Profit, Spent = 0,0
                SDT:Print(L["Gold: Session data reset!"])
            elseif IsAltKeyDown() then
                -- Show character selection menu for deletion
                ShowGoldDeleteMenu(self)
            end
        else
            _G.ToggleAllBags()
        end
    end)

    UpdateGold(slotFrame)

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText(moduleName, mod)

return mod
