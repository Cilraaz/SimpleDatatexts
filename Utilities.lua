-- Utilities.lua - Helper functions and utilities for SimpleDatatexts
local addonName, SDT = ...
local L = SDT.L

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = string.format
local ipairs = ipairs
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local wipe = table.wipe

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetCVar = GetCVar
local SetCVar = SetCVar
local UIParent = UIParent

----------------------------------------------------
-- Module Settings Exclusions
----------------------------------------------------
-- Modules that have no settings panels
SDT.excludedModules = {
    ["HidingBar1"] = true,
}

SDT.allowedLDBModules = {
    ["LDB: BugSack"] = true,
    ["LDB: WIM"] = true,
}

function SDT:ExcludedModule(moduleName)
    if self.excludedModules[moduleName] then return true end
    if moduleName:match("^LDB:") and not self.allowedLDBModules[moduleName] then return true end
    return false
end

----------------------------------------------------
-- CVar Management
----------------------------------------------------
function SDT:SetCVar(cvar, value)
    local valStr = ((type(value) == "boolean") and (value and '1' or '0')) or tostring(value)
    if GetCVar(cvar) ~= valStr then
        SetCVar(cvar, valStr)
    end
end

----------------------------------------------------
-- Color Management
----------------------------------------------------
function SDT:GetTagColor()
    if self.db.profile.useCustomColor then
        local color = self.db.profile.customColorHex:gsub("#", "")
        return "ff"..color
    elseif self.db.profile.useClassColor then
        return self.cache.colorHex
    end
    return "ffffffff"
end

function SDT:ColorText(text)
    local color = self:GetTagColor()
    return "|c"..color..text.."|r"
end

function SDT:ColorModuleText(moduleName, text)
    local overrideColor = SDT:GetModuleSetting(moduleName, "overrideTextColor", false)
    if overrideColor then
        local colorSetting = SDT:GetModuleSetting(moduleName, "customTextColor", "#FFFFFF")
        return format("|cff%s%s|r", colorSetting:gsub("#", ""), text)
    else
        return SDT:ColorText(text)
    end
end

----------------------------------------------------
-- Tooltip Helpers
----------------------------------------------------
function SDT:AddTooltipHeader(tooltip, fontSize, text, r, g, b, wrap)
    tooltip = tooltip or GameTooltip
    r = r or 1
    g = g or 0.82
    b = b or 0
    
    tooltip:AddLine(text, r, g, b, wrap or false)
    
    -- Force the header to use a specific font size
    local textLeft = _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()]
    if textLeft then
        local font, _, flags = textLeft:GetFont()
        textLeft:SetFont(font, fontSize or 14, flags)
    end
end

function SDT:AddTooltipLine(tooltip, fontSize, textLeft, textRight, r1, g1, b1, r2, g2, b2, wrap)
    tooltip = tooltip or GameTooltip

    -- Handle single or double lines
    if textRight then
        r1 = r1 or 1
        g1 = g1 or 1
        b1 = b1 or 1
        r2 = r2 or 0.5
        g2 = g2 or 0.5
        b2 = b2 or 0.5
        tooltip:AddDoubleLine(textLeft, textRight, r1, g1, b1, r2, g2, b2, wrap or false)
    else
        r1 = r1 or 1
        g1 = g1 or 1
        b1 = b1 or 1
        tooltip:AddLine(textLeft, r1, g1, b1, wrap or false)
    end

    -- Apply font size to the line
    local lineNum = tooltip:NumLines()
    local textLeftObj = _G[tooltip:GetName() .. "TextLeft" .. lineNum]
    local textRightObj = _G[tooltip:GetName() .. "TextRight" .. lineNum]
    
    if textLeftObj then
        local font, _, flags = textLeftObj:GetFont()
        textLeftObj:SetFont(font, fontSize or 12, flags)
    end
    if textRightObj then
        local font, _, flags = textRightObj:GetFont()
        textRightObj:SetFont(font, fontSize or 12, flags)
    end
end

----------------------------------------------------
-- Font Application
----------------------------------------------------
function SDT:ApplyFont()
    local fontPath = self.LSM:Fetch("font", self.db.profile.font) or STANDARD_TEXT_FONT
    local fontSize = self.db.profile.fontSize or 12
    local fontOutline = self.db.profile.fontOutline or "NONE"

    -- Convert "NONE" to empty string for SetFont
    local outline = (fontOutline == "NONE") and "" or fontOutline

    for _, bar in pairs(self.bars) do
        for _, slot in ipairs(bar.slots) do
            if slot.text then
                slot.text:SetFont(fontPath, fontSize, outline)
            end
            if slot.moduleFrame and slot.moduleFrame.text and slot.moduleFrame.text.SetFont then
                slot.moduleFrame.text:SetFont(fontPath, fontSize, outline)
            end
        end
    end
end

function SDT:ApplyModuleFont(moduleName, textObject)
    if not moduleName or not textObject then return end
    
    local overrideFont = self:GetModuleSetting(moduleName, "overrideFont", false)
    if overrideFont then
        -- Apply module font when override is enabled
        local fontName = self:GetModuleSetting(moduleName, "font", "Friz Quadrata TT")
        local fontSize = self:GetModuleSetting(moduleName, "fontSize", 12)
        local fontOutline = self:GetModuleSetting(moduleName, "fontOutline", "NONE")
        
        local fontPath = self.LSM:Fetch("font", fontName) or STANDARD_TEXT_FONT
        local outline = (fontOutline == "NONE") and "" or fontOutline
        
        textObject:SetFont(fontPath, fontSize, outline)
        return true
    else
        -- Apply global font when override is disabled
        local fontPath = self.LSM:Fetch("font", self.db.profile.font) or STANDARD_TEXT_FONT
        local fontSize = self.db.profile.fontSize or 12
        local fontOutline = self.db.profile.fontOutline or "NONE"
        local outline = (fontOutline == "NONE") and "" or fontOutline
        
        textObject:SetFont(fontPath, fontSize, outline)
        return false
    end
    
    return false
end

----------------------------------------------------
-- Anchor Point Helper
----------------------------------------------------
function SDT:FindBestAnchorPoint(frame)
    local x, y = frame:GetCenter()
    local screenWidth = UIParent:GetRight()
    local screenHeight = UIParent:GetTop()

    if not x or not y then
        return "ANCHOR_BOTTOM"
    else
        if y < screenHeight / 2 then
            return "ANCHOR_TOP"
        else
            return "ANCHOR_BOTTOM"
        end
    end
end

----------------------------------------------------
-- Format Helpers
----------------------------------------------------
function SDT:FormatLargeNumbers(n)
    local locale = self.cache.locale
    local sep

    if locale == "frFR" then
        sep = " "
    elseif locale == "deDE" then
        sep = "."
    elseif locale == "enUS" or locale == "enGB" then
        sep = ","
    else
        return BreakUpLargeNumbers(n)
    end

    local s = tostring(math.floor(n))
    while true do
        local k
        s, k = s:gsub("^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
        if k == 0 then break end
    end
    return s
end

function SDT:FormatPercent(v, hideDecimals, roundDown)
    if hideDecimals then
        if roundDown then
            return format("%d%%", v)
        else
            -- Round to nearest integer using standard rounding (>= 0.5 rounds up)
            return format("%d%%", v + 0.5)
        end
    else
        return format("%.2f%%", v)
    end
end

----------------------------------------------------
-- Generate Addon List
----------------------------------------------------
function SDT:GetAddonList()
    if not self.cache.addonList or #self.cache.addonList == 0 then
        self:CreateAddonList()
    end
    return self.cache.addonList
end

----------------------------------------------------
-- Global Module Settings
----------------------------------------------------
function SDT:GlobalModuleSettings(moduleName)
    -- Text Settings
    SDT:AddModuleConfigSeparator(moduleName, L["Text Color"])
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Override Text Color"], "overrideTextColor", false)
    SDT:AddModuleConfigSetting(moduleName, "color", L["Text Custom Color"], "customTextColor", "#FFFFFF")

	-- Font Settings
    SDT:AddModuleConfigSeparator(moduleName, L["Font Settings"])
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Override Global Font"], "overrideFont", false)
    SDT:AddModuleConfigSetting(moduleName, "font", L["Display Font:"], "font", "Friz Quadrata TT")
    SDT:AddModuleConfigSetting(moduleName, "fontSize", L["Font Size"], "fontSize", 12, 4, 40, 1)
    SDT:AddModuleConfigSetting(moduleName, "fontOutline", L["Font Outline"], "fontOutline", "NONE", {
        ["NONE"] = L["None"],
        ["OUTLINE"] = "Outline",
        ["THICKOUTLINE"] = "Thick Outline",
        ["MONOCHROME"] = "Monochrome",
        ["OUTLINE, MONOCHROME"] = "Outline + Monochrome",
        ["THICKOUTLINE, MONOCHROME"] = "Thick Outline + Monochrome",
    })

	-- Slot Controls
    SDT:AddModuleConfigSeparator(moduleName, L["Slot Controls"])
    SDT:AddModuleConfigSetting(moduleName, "anchorPoint", L["Anchor Point"], "anchorPoint", "CENTER")
    SDT:AddModuleConfigSetting(moduleName, "frameStrata", L["Frame Strata"], "frameStrata", "MEDIUM")
end

----------------------------------------------------
-- Menu List Handler (for right-click menus)
----------------------------------------------------
function SDT:HandleMenuList(root, menuList, submenu, depth)
    if submenu then root = submenu end

    for _, list in pairs(menuList) do
        local previous
        
        if list.isTitle then
            root:CreateTitle(list.text)
        elseif list.func or list.hasArrow then
            local name = list.text or ('test'..depth)

            local func = (list.arg1 or list.arg2) and (function() list.func(nil, list.arg1, list.arg2) end) or list.func
            local checked = list.checked and (not list.notCheckable and function() return list.checked(list) end or function() end)
            
            if checked then
                previous = root:CreateCheckbox(list.text or name, checked, func)
            else
                previous = root:CreateButton(list.text or name, func)
            end
        end

        if list.menuList then
            self:HandleMenuList(root, list.menuList, list.hasArrow and previous, depth + 1)
        end
    end
end

----------------------------------------------------
-- Module Settings (for modules that need config)
----------------------------------------------------
function SDT:AddModuleConfigSetting(moduleName, settingType, label, settingKey, defaultValue, ...)
    -- Queue settings to be added to the config system
    self.queuedModuleSettings = self.queuedModuleSettings or {}
    self.queuedModuleSettings[moduleName] = self.queuedModuleSettings[moduleName] or {}
    
    local setting = {
        settingType = settingType,
        label = label,
        settingKey = settingKey,
        defaultValue = defaultValue,
    }

    -- Handle extra parameters for different setting types
    if settingType == "select" or settingType == "fontOutline" then
        setting.values = select(1, ...)
    elseif settingType == "range" or settingType == "fontSize" then
        setting.min = select(1, ...)
        setting.max = select(2, ...)
        setting.step = select(3, ...)
    elseif settingType == "description" then
        -- Description can have optional fontSize parameter
        setting.fontSize = select(1, ...) or "medium"
    end
    
    table.insert(self.queuedModuleSettings[moduleName], setting)
end

----------------------------------------------------
-- Helper function to add a separator/newline
----------------------------------------------------
function SDT:AddModuleConfigSeparator(moduleName, label)
    self:AddModuleConfigSetting(moduleName, "header", label or " ", nil, nil)
end

----------------------------------------------------
-- Get Module Frame Strata
----------------------------------------------------
function SDT:GetModuleFrameStrata(moduleName)
    local strata = self:GetModuleSetting(moduleName, "frameStrata", "MEDIUM")
    -- Validate strata value
    local validStratas = {
        BACKGROUND = true,
        LOW = true,
        MEDIUM = true,
        HIGH = true,
        DIALOG = true,
        FULLSCREEN = true,
        FULLSCREEN_DIALOG = true,
        TOOLTIP = true,
    }
    if not validStratas[strata] then
        return "MEDIUM"
    end
    return strata
end

----------------------------------------------------
-- Bar ID Helper
----------------------------------------------------
function SDT:NextBarID()
    local n = 1
    while self.db.profile.bars["SDT_Bar" .. n] and self.db.profile.bars["SDT_Bar" .. n].name do
        n = n + 1
    end
    return n
end

----------------------------------------------------
-- Module List Creation
----------------------------------------------------
function SDT:CreateModuleList()
    wipe(self.cache.moduleNames)
    for name in pairs(self.modules) do
        table.insert(self.cache.moduleNames, name)
    end
    table.sort(self.cache.moduleNames)
end

----------------------------------------------------
-- Addon List Creation
----------------------------------------------------
function SDT:CreateAddonList()
    self.cache.addonList = self.cache.addonList or {}
    wipe(self.cache.addonList)
    
    local GetAddOnInfo = C_AddOns.GetAddOnInfo
    local GetNumAddOns = C_AddOns.GetNumAddOns
    local addOnCount = GetNumAddOns()
    local counter = 1
    
    for i = 1, addOnCount do
        local name, title, _, loadable, reason = GetAddOnInfo(i)
        if loadable or reason == "DEMAND_LOADED" then
            self.cache.addonList[counter] = {
                name = name,
                title = title,
                index = i
            }
            counter = counter + 1
        end
    end
end

----------------------------------------------------
-- Lock/Unlock Panels
----------------------------------------------------
function SDT:ToggleLock()
    self.db.profile.locked = not self.db.profile.locked
    
    if self.db.profile.locked then
        self:Print(L["Panels locked"])
    else
        self:Print(L["Panels unlocked"])
    end
    
    -- Update all bars to reflect the lock state
    for _, bar in pairs(self.bars) do
        if bar then
            if self.db.profile.locked then
                bar:EnableMouse(false)
                bar:SetMovable(false)
            else
                bar:EnableMouse(true)
                bar:SetMovable(true)
            end
        end
    end
end

----------------------------------------------------
-- Update Frame Strata for Active Modules
----------------------------------------------------
function SDT:UpdateAllModuleStrata()
    -- Iterate through all bars and their slots
    for _, bar in pairs(self.bars) do
        if bar.slots then
            for _, slot in ipairs(bar.slots) do
                -- Only update slots that have an active module
                if slot.module and slot.module ~= "(spacer)" and self.modules[slot.module] then
                    local strata = self:GetModuleFrameStrata(slot.module)
                    
                    -- Set strata on the slot itself (parent frame)
                    slot:SetFrameStrata(strata)
                    
                    -- Set strata on module frame if it exists
                    if slot.moduleFrame then
                        slot.moduleFrame:SetFrameStrata(strata)
                    end
                    
                    -- Set strata on secure button if it exists
                    if slot.secureButton then
                        slot.secureButton:SetFrameStrata(strata)
                    end
                end
            end
        end
    end
end

----------------------------------------------------
-- Update All Modules
----------------------------------------------------
function SDT:UpdateAllModules()
    for _, bar in pairs(self.bars) do
        if bar and bar.slots then
            for _, slot in ipairs(bar.slots) do
                if slot.moduleFrame and slot.moduleFrame.Update then
                    slot.moduleFrame:Update()
                end
            end
        end
    end
end

----------------------------------------------------
-- Global Gold Tracking (runs regardless of module loading)
----------------------------------------------------
function SDT:UpdateGlobalGold()
    if not IsLoggedIn() then return end
    if not self.cache then return end
    if not self.db.global.gold then return end
    
    local playerName = self.cache.playerName
    local realmName = self.cache.playerRealmProper
    local faction = self.cache.playerFaction
    
    -- Ensure the database structure exists
    self.db.global.gold = self.db.global.gold or {}
    self.db.global.gold[realmName] = self.db.global.gold[realmName] or {}
    self.db.global.gold[realmName][playerName] = self.db.global.gold[realmName][playerName] or {}
    
    -- Update faction and gold amount
    self.db.global.gold[realmName][playerName].faction = faction
    self.db.global.gold[realmName][playerName].amount = GetMoney()
end