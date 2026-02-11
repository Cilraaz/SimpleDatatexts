-- modules/Hearthstone.lua
-- Hearthstone datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local random = math.random

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local C_ToyBox = C_ToyBox
local C_Item = C_Item
local GetItemInfo = C_Item.GetItemInfo
local GetItemInfoInstant = C_Item.GetItemInfoInstant
local PlayerHasToy = PlayerHasToy
local IsUsableItem = C_Item.IsUsableItem
local GetItemCooldown = C_Item.GetItemCooldown
local UseItemByName = UseItemByName
local InCombatLockdown = InCombatLockdown

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Hearthstone"

-- List of hearthstone item IDs (toys and items)
local HEARTHSTONES = {
    -- Basic Hearthstone (always available)
    { id = 6948, name = "Hearthstone", isToy = false },
    
    -- Toy Hearthstones
    { id = 54452, name = "Ethereal Portal", isToy = true },
    { id = 64488, name = "The Innkeeper's Daughter", isToy = true },
    { id = 93672, name = "Dark Portal", isToy = true },
    { id = 142542, name = "Tome of Town Portal", isToy = true },
    { id = 162973, name = "Greatfather Winter's Hearthstone", isToy = true },
    { id = 163045, name = "Headless Horseman's Hearthstone", isToy = true },
    { id = 165669, name = "Lunar Elder's Hearthstone", isToy = true },
    { id = 165670, name = "Peddlefeet's Lovely Hearthstone", isToy = true },
    { id = 165802, name = "Noble Gardener's Hearthstone", isToy = true },
    { id = 166746, name = "Fire Eater's Hearthstone", isToy = true },
    { id = 166747, name = "Brewfest Reveler's Hearthstone", isToy = true },
    { id = 168907, name = "Holographic Digitalization Hearthstone", isToy = true },
    { id = 172179, name = "Eternal Traveler's Hearthstone", isToy = true },
    { id = 180290, name = "Night Fae Hearthstone", isToy = true },
    { id = 182773, name = "Necrolord Hearthstone", isToy = true },
    { id = 183716, name = "Venthyr Sinstone", isToy = true },
    { id = 184353, name = "Kyrian Hearthstone", isToy = true },
    { id = 188952, name = "Dominated Hearthstone", isToy = true },
    { id = 190196, name = "Enlightened Hearthstone", isToy = true },
    { id = 190237, name = "Broker Translocation Matrix", isToy = true },
    { id = 193588, name = "Timewalker's Hearthstone", isToy = true },
    { id = 200630, name = "Ohn'ir Windsage's Hearthstone", isToy = true },
    { id = 206195, name = "Path of the Naaru", isToy = true },
    { id = 208704, name = "Deepdweller's Earthen Hearthstone", isToy = true },
    { id = 209035, name = "Hearthstone of the Flame", isToy = true },
    { id = 210455, name = "Draenic Hologem", isToy = true },
    { id = 212337, name = "Stone of the Hearth", isToy = true },
    { id = 228940, name = "Notorious Thread's Hearthstone", isToy = true },
    { id = 236687, name = "Explosive Hearthstone", isToy = true },
    { id = 245970, name = "P.O.S.T. Master's Express Hearthstone", isToy = true },
    { id = 246565, name = "Cosmic Hearthstone", isToy = true },
    { id = 250411, name = "Timerunner's Hearthstone", isToy = true },
    { id = 257736, name = "Lightcalled Hearthstone", isToy = true },
    { id = 265100, name = "Corewarden's Hearthstone", isToy = true },

    -- Other Items that can be used as Hearthstones
    { id = 28585, name = "Ruby Slippers", isToy = false },
    { id = 142298, name = "Astonishingly Scarlet Slippers", isToy = false },
}

-- Default settings
local defaultHearthstone = "random"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Helper Functions
----------------------------------------------------
local function GetAvailableHearthstones()
    local available = {}
    
    for _, hs in ipairs(HEARTHSTONES) do
        local hasItem = false
        
        if hs.isToy then
            hasItem = PlayerHasToy(hs.id)
        else
            -- Check if player has the item in inventory
            hasItem = C_Item.GetItemCount(hs.id) > 0
        end
        
        if hasItem then
            table.insert(available, hs)
        end
    end
    
    return available
end

local function GetHearthstoneIcon(hsID)
    if not hsID or hsID == "random" then
        -- We'll use the random hearthstone icon
        return
    end
    
    local _, _, _, _, icon = GetItemInfoInstant(hsID)
    return icon or 134414
end

local function GetSelectedHearthstone()
    local config = SDT.db.profile.moduleSettings[moduleName]
    if not config then return "random" end
    
    return config.selectedHearthstone or "random"
end

local function GetCooldownText(hsID)
    if hsID == "random" then
        -- Check cooldown of basic hearthstone
        hsID = 6948
    end
    
    local startTime, duration = GetItemCooldown(hsID)
    
    if duration and duration > 0 then
        local remaining = duration - (GetTime() - startTime)
        if remaining > 60 then
            return string.format("%.0fm", remaining / 60)
        else
            return string.format("%.0fs", remaining)
        end
    end
    
    return ""
end

----------------------------------------------------
-- Update Display
----------------------------------------------------
local function UpdateDisplay(slotFrame)
    local icon = slotFrame.icon
    local text = slotFrame.text
    local cooldownText = slotFrame.cooldownText
    
    if not icon or not text or not cooldownText then
        return -- Elements not created yet
    end
    
    local selectedHS = GetSelectedHearthstone()
    local hsID = selectedHS == "random" and "random" or tonumber(selectedHS)
    
    -- Update icon
    if hsID == "random" then
        icon:SetTexture("Interface\\AddOns\\SimpleDatatexts\\textures\\random_hearthstone")
    else
        icon:SetTexture(GetHearthstoneIcon(hsID))
    end
    
    -- Update cooldown text
    local cdText = GetCooldownText(hsID)
    if cdText ~= "" then
        cooldownText:SetText(SDT.FormatUtils:ColorModuleText(moduleName, cdText))
        cooldownText:Show()
        SDT.FontManager:ApplyModuleFont(moduleName, cooldownText)
    else
        cooldownText:Hide()
    end
    
    -- Hide the main text element since we're using icon display
    text:SetText("")
end

----------------------------------------------------
-- Tooltip Handler
----------------------------------------------------
local function ShowTooltip(slotFrame)
    local anchor = SDT.FormatUtils:FindBestAnchorPoint(slotFrame)
    GameTooltip:SetOwner(slotFrame, anchor)
    GameTooltip:ClearLines()
    
    if not SDT.db.profile.hideModuleTitle then
        SDT.FormatUtils:AddTooltipHeader(GameTooltip, 14, L["Hearthstone"])
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
    end
    
    local selectedHS = GetSelectedHearthstone()
    local hsID = selectedHS == "random" and "random" or tonumber(selectedHS)
    
    if hsID == "random" then
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, L["Selected:"], L["Random"], 1, 1, 1, 0.5, 1, 0.5)
    else
        local itemName = GetItemInfo(hsID)
        if itemName then
            SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, L["Selected:"], itemName, 1, 1, 1, 0.5, 1, 0.5)
        end
    end
    
    -- Show available hearthstones
    local available = GetAvailableHearthstones()
    if #available > 0 then
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, L["Available Hearthstones:"], nil, 0.69, 0.31, 0.31)
        
        for _, hs in ipairs(available) do
            local itemName = GetItemInfo(hs.id)
            if itemName then
                local _, _, _, _, icon = GetItemInfoInstant(hs.id)
                local iconStr = string.format("|T%s:14:14:0:0:64:64:4:60:4:60|t", icon or "")
                SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, iconStr .. " " .. itemName, nil, 1, 1, 1)
            end
        end
    end
    
    SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
    SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cffFFFFFF" .. L["Left Click: Use Hearthstone"] .. "|r")
    SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cffFFFFFF" .. L["Right Click: Select Hearthstone"] .. "|r")
    
    GameTooltip:Show()
end

----------------------------------------------------
-- Click Handler
----------------------------------------------------
local function UpdateSecureAttributes(slotFrame)
    if InCombatLockdown() then
        return
    end
    
    local secureButton = slotFrame.secureButton
    if not secureButton then
        return
    end
    
    -- Determine which hearthstone to use
    local selectedHS = GetSelectedHearthstone()
    local hsID = selectedHS == "random" and "random" or tonumber(selectedHS)
    
    -- If random, pick a random available hearthstone
    if hsID == "random" then
        local available = GetAvailableHearthstones()
        if #available > 0 then
            local chosen = available[random(1, #available)]
            hsID = chosen.id
        else
            hsID = 6948 -- Fall back to basic hearthstone
        end
    end
    
    -- Get item name and set secure attribute
    local itemName = GetItemInfo(hsID)
    if itemName then
        secureButton:SetAttribute("type", "item")
        secureButton:SetAttribute("item", itemName)
    else
        SDT:Print("Hearthstone: Could not get item name for ID", hsID)
    end
end

local function OnClick(slotFrame, button)
    if button == "RightButton" and not IsControlKeyDown() then
        -- Show menu to select hearthstone
        MenuUtil.CreateContextMenu(slotFrame, function(owner, root)
            -- Random option
            root:CreateRadio(L["Random"], function()
                return GetSelectedHearthstone() == "random"
            end, function()
                if not SDT.db.profile.moduleSettings[moduleName] then
                    SDT.db.profile.moduleSettings[moduleName] = {}
                end
                SDT.db.profile.moduleSettings[moduleName].selectedHearthstone = "random"
                UpdateDisplay(slotFrame)
                UpdateSecureAttributes(slotFrame)
            end)
            
            -- Separator
            root:CreateDivider()
            
            -- Available hearthstones
            local available = GetAvailableHearthstones()
            for _, hs in ipairs(available) do
                local itemName = GetItemInfo(hs.id)
                if itemName then
                    local hsIDStr = tostring(hs.id)
                    root:CreateRadio(itemName, function()
                        return GetSelectedHearthstone() == hsIDStr
                    end, function()
                        if not SDT.db.profile.moduleSettings[moduleName] then
                            SDT.db.profile.moduleSettings[moduleName] = {}
                        end
                        SDT.db.profile.moduleSettings[moduleName].selectedHearthstone = hsIDStr
                        UpdateDisplay(slotFrame)
                        UpdateSecureAttributes(slotFrame)
                    end)
                end
            end
        end)
    end
end

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    -- Create a secure action button FIRST as a direct child of slotFrame
    local secureButton = CreateFrame("Button", nil, slotFrame, "SecureActionButtonTemplate")
    secureButton:SetAllPoints(slotFrame)
    secureButton:EnableMouse(true)
    secureButton:RegisterForClicks("LeftButtonDown", "RightButtonUp")
    secureButton:SetAttribute("type", "item")
    secureButton:SetFrameLevel(100)  -- Very high to ensure it's on top
    slotFrame.secureButton = secureButton
    
    -- Now create our event frame
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)
    
    -- Create icon texture on slotFrame
    local icon = slotFrame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24)
    icon:SetPoint("CENTER", slotFrame, "CENTER")
    slotFrame.icon = icon
    
    -- Create text for display (hidden but kept for compatibility)
    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end
    
    -- Create cooldown text overlay
    local cooldownText = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cooldownText:SetPoint("BOTTOM", icon, "BOTTOM", 0, -2)
    cooldownText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    slotFrame.cooldownText = cooldownText
    
    ----------------------------------------------------
    -- Tooltip Handler - on secure button so it works
    ----------------------------------------------------
    secureButton:SetScript("OnEnter", function(self)
        ShowTooltip(slotFrame)
    end)
    
    secureButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    ----------------------------------------------------
    -- PreClick Handler - randomize hearthstone before click
    ----------------------------------------------------
    secureButton:SetScript("PreClick", function(self, button)
        if button == "LeftButton" and not InCombatLockdown() then
            UpdateSecureAttributes(slotFrame)
        end
    end)
    
    ----------------------------------------------------
    -- PostClick Handler - for right-click menu
    ----------------------------------------------------
    secureButton:SetScript("PostClick", function(self, button)
        if button == "RightButton" then
            if IsControlKeyDown() then
                -- Pass through to slotFrame for config menu
                local originalHandler = slotFrame:GetScript("OnMouseUp")
                if originalHandler then
                    originalHandler(slotFrame, button)
                end
            else
                -- Show hearthstone selection menu
                OnClick(slotFrame, button)
            end
        end
    end)
    
    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "BAG_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_COOLDOWN" then
            UpdateDisplay(slotFrame)
        elseif event == "TOYS_UPDATED" or event == "BAG_UPDATE" then
            UpdateDisplay(slotFrame)
            UpdateSecureAttributes(slotFrame)
        end
    end
    
    f.Update = function() 
        UpdateDisplay(slotFrame)
        UpdateSecureAttributes(slotFrame)
    end
    
    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("BAG_UPDATE_COOLDOWN")
    f:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    f:RegisterEvent("TOYS_UPDATED")
    f:RegisterEvent("BAG_UPDATE")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    
    ----------------------------------------------------
    -- Preserve original slotFrame handlers for Ctrl+Right
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:RegisterForClicks("AnyUp")
    
    -- Initial update
    UpdateDisplay(slotFrame)
    UpdateSecureAttributes(slotFrame)
    
    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod