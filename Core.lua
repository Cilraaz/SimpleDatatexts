-- Core.lua - Main addon initialization
local addonName, SDT = ...

----------------------------------------------------
-- Debug Stuffs
----------------------------------------------------
SDT.profileData = {}

function SDT:ProfileFunction(name, func)
    local startTime = debugprofilestop()
    local startMemory = collectgarbage("count")
    
    func()
    
    local endTime = debugprofilestop()
    local endMemory = collectgarbage("count")
    
    -- Store instead of print immediately
    SDT.profileData[#SDT.profileData + 1] = {
        name = name,
        time = endTime - startTime,
        memory = endMemory - startMemory
    }
end

function SDT:ShowProfileData()
    if #SDT.profileData == 0 then return end
    
    print("|cff00ff00[SDT Profile Results]|r")
    
    -- Sort by time (descending)
    table.sort(SDT.profileData, function(a, b) return a.time > b.time end)
    
    local totalTime = 0
    local totalMemory = 0
    
    for _, data in ipairs(SDT.profileData) do
        totalTime = totalTime + data.time
        totalMemory = totalMemory + data.memory
        
        print(format("  %s: |cffff8800%.3f ms|r | |cff8888ff%.2f KB|r", 
            data.name, 
            data.time, 
            data.memory))
    end
    
    print(format("|cff00ff00Total: %.3f ms | %.2f KB|r", totalTime, totalMemory))
    
    -- Clear the data
    wipe(SDT.profileData)
end

-- Create the addon object using Ace3
LibStub("AceAddon-3.0"):NewAddon(SDT, addonName, "AceEvent-3.0")
_G.SimpleDatatexts = SDT

----------------------------------------------------
-- Initialize Localization
----------------------------------------------------
SDT.L = SDT.L or {}
local L = SDT.L

if not getmetatable(L) then
    setmetatable(L, {
        __index = function(_, key)
            if SDT.db and SDT.db.profile.debugMode then
                SDT:Print("DEBUG - Missing translation: '" .. key .. "'")
            end
            return key
        end
    })
end

----------------------------------------------------
-- Library Instances
----------------------------------------------------
SDT.LSM = LibStub("LibSharedMedia-3.0")
SDT.LDB = LibStub("LibDataBroker-1.1")
SDT.Icon = LibStub("LibDBIcon-1.0")
SDT.LibDeflate = LibStub:GetLibrary("LibDeflate")
SDT.AceSerializer = LibStub("AceSerializer-3.0")

----------------------------------------------------
-- Create LDB Object
----------------------------------------------------
local obj = SDT.LDB:NewDataObject("SimpleDatatexts", {
    type = "data source",
    text = "SimpleDatatexts",
    icon = "Interface\\AddOns\\SimpleDatatexts\\textures\\SDT_Minimap_Icon",
    OnClick = function(_, button)
        if button == "LeftButton" then SDT:OpenConfig() end
    end,
    OnTooltipShow = function(tt)
        tt:AddLine(L["Simple Datatexts"])
        tt:AddLine(format("|cff8888ff%s: %s|r", L["Version"], SDT.cache.version), 1, 1, 1)
        tt:AddLine(L["Left Click to open settings"], 1, 1, 1)
    end,
})

----------------------------------------------------
-- Addon Tables
----------------------------------------------------
SDT.modules = SDT.modules or {}
SDT.bars = SDT.bars or {}
SDT.cache = SDT.cache or {}
SDT.cache.locale = GetLocale()

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetClassColor = C_ClassColor.GetClassColor
local GetRealmName = GetRealmName
local UnitClass = UnitClass
local UnitName = UnitName

----------------------------------------------------
-- Build Cache
----------------------------------------------------
function SDT:BuildCache()
    self.cache.playerName = UnitName("player")
    self.cache.playerNameLower = self.cache.playerName:lower()
    self.cache.playerClass = select(2, UnitClass("player"))
    self.cache.playerRealmProper = GetRealmName()
    self.cache.playerRealm = self.cache.playerRealmProper:gsub("[^%w]", ""):lower()
    self.cache.playerFaction = UnitFactionGroup("player")
    self.cache.playerLevel = UnitLevel("player")
    self.cache.charKey = self.cache.playerNameLower.."-"..self.cache.playerRealm
    
    local colors = { GetClassColor(self.cache.playerClass):GetRGB() }
    self.cache.colorR = colors[1]
    self.cache.colorG = colors[2]
    self.cache.colorB = colors[3]
    self.cache.colorHex = GetClassColor(self.cache.playerClass):GenerateHexColor()
    self.cache.version = GetAddOnMetadata(addonName, "Version") or L["Not Defined"]
    self.cache.moduleNames = {}
end

function SDT:ScreenCache()
    local width, height = GetPhysicalScreenSize()
    self.cache.screenWidth = math.floor(GetScreenWidth())
    self.cache.screenHeight = math.floor(GetScreenHeight())
    self.cache.physicalWidth = width
    self.cache.physicalHeight = height
end

----------------------------------------------------
-- Addon Initialization
----------------------------------------------------
function SDT:OnInitialize()
    -- DEBUG
    if SDT.db and SDT.db.profile and SDT.db.profile.debugMode then
        SDT:ProfileFunction("BuildCache", function() self:BuildCache() end)
        SDT:ProfileFunction("InitializeDatabase", function() self:InitializeDatabase() end)
        SDT:ProfileFunction("RegisterSlashCommands", function() self:RegisterSlashCommands() end)
        SDT:ProfileFunction("Minimap Icon", function() 
            SDT.Icon:Register("SimpleDatatexts", obj, self.db.profile.minimap)
        end)
    else
        -- Build cache first
        self:BuildCache()

        -- Initialize database (handled in Database.lua)
        self:InitializeDatabase()

        -- Register slash commands
        self:RegisterSlashCommands()

        -- Create minimap button
        SDT.Icon:Register("SimpleDatatexts", obj, self.db.profile.minimap)
    end
end

function SDT:OnEnable()
    -- DEBUG
    if SDT.db and SDT.db.profile and SDT.db.profile.debugMode then
        SDT:ProfileFunction("ScreenCache", function() self:ScreenCache() end)
        SDT:ProfileFunction("RegisterFonts", function() self:RegisterFonts() end)
        SDT:ProfileFunction("CreateModuleList", function() self:CreateModuleList() end)

        SDT:ProfileFunction("CreateBars", function()
            for barName, barData in pairs(self.db.profile.bars) do
                local id = tonumber(barName:match("SDT_Bar(%d+)"))
                if id and id > 0 then
                    self:CreateDataBar(id, barData.numSlots)
                end
            end
        end)
    else
        -- Cache screen size
        self:ScreenCache()

        -- Register fonts
        self:RegisterFonts()

        -- Create module list
        self:CreateModuleList()

        -- Create bars from current profile
        for barName, barData in pairs(self.db.profile.bars) do
            local id = tonumber(barName:match("SDT_Bar(%d+)"))
            if id and id > 0 then
                self:CreateDataBar(id, barData.numSlots)
            end
        end
    end

    -- Per-spec profile switching
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "SwitchToSpecProfile")
    self:SwitchToSpecProfile()

    -- Update the global gold cache
    self:RegisterEvent("PLAYER_MONEY", "UpdateGlobalGold")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateGlobalGold")
    self:RegisterEvent("SEND_MAIL_MONEY_CHANGED", "UpdateGlobalGold")
    self:RegisterEvent("SEND_MAIL_COD_CHANGED", "UpdateGlobalGold")
    self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGlobalGold")
    self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGlobalGold")
    self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "UpdateGlobalGold")
    self:UpdateGlobalGold()

    if SDT.db.profile.debugMode then
        C_Timer.After(1, function() self:ShowProfileData() end)
    end
end

----------------------------------------------------
-- Register Fonts
----------------------------------------------------
function SDT:RegisterFonts()
    self.LSM:Register("font", "Action Man", [[Interface\AddOns\SimpleDatatexts\fonts\ActionMan.ttf]])
    self.LSM:Register("font", "Continuum Medium", [[Interface\AddOns\SimpleDatatexts\fonts\ContinuumMedium.ttf]])
    self.LSM:Register("font", "Die Die Die!", [[Interface\AddOns\SimpleDatatexts\fonts\DieDieDie.ttf]])
    self.LSM:Register("font", "Expressway", [[Interface\AddOns\SimpleDatatexts\fonts\Expressway.ttf]])
    self.LSM:Register("font", "Homespun", [[Interface\AddOns\SimpleDatatexts\fonts\Homespun.ttf]])
    --self.LSM:Register("font", "Invisible", [[Interface\AddOns\SimpleDatatexts\fonts\Invisible.ttf]])
    self.LSM:Register("font", "PT Sans Narrow", [[Interface\AddOns\SimpleDatatexts\fonts\PTSansNarrow.ttf]])
end

----------------------------------------------------
-- Create Module List
----------------------------------------------------
function SDT:CreateModuleList()
    if self.cache.moduleNamesDirty or not self.cache.moduleNames then
        wipe(self.cache.moduleNames)
        for name in pairs(self.modules) do
            tinsert(self.cache.moduleNames, name)
        end
        table.sort(self.cache.moduleNames)
        self.cache.moduleNamesDirty = false
    end
end

----------------------------------------------------
-- Create Addon List
----------------------------------------------------
function SDT:CreateAddonList()
    self.cache.addonList = self.cache.addonList or {}
    wipe(self.cache.addonList)
    local addOnCount = C_AddOns.GetNumAddOns()
    local counter = 1
    for i = 1, addOnCount do
        local name, title, _, loadable, reason = C_AddOns.GetAddOnInfo(i)
        if loadable or reason == "DEMAND_LOADED" then
            self.cache.addonList[counter] = {name = name, title = title, index = i}
            counter = counter + 1
        end
    end
end

----------------------------------------------------
-- Slash Commands
----------------------------------------------------
function SDT:RegisterSlashCommands()
    SLASH_SIMPLEDATATEXTS1 = "/sdt"
    SLASH_SIMPLEDATATEXTS2 = "/simpledatatexts"
    
    SlashCmdList["SIMPLEDATATEXTS"] = function(msg)
        self:HandleSlashCommand(msg)
    end

    if not SlashCmdList["RELOADUI"] then
        SLASH_RELOADUI1 = "/rl"
        SlashCmdList["RELOADUI"] = _G.ReloadUI
    end

end

function SDT:HandleSlashCommand(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        tinsert(args, word)
    end
    local command = args[1] and args[1]:lower() or ""
    
    if command == "config" or command == "" then
        -- Open config GUI
        self:OpenConfig()
    elseif command == "lock" then
        self:ToggleLock()
    elseif command == "minimap" then
        self.db.profile.minimap.hide = not self.db.profile.minimap.hide
        if self.db.profile.minimap.hide then
            SDT.Icon:Hide("SimpleDatatexts")
            self:Print(L["Minimap Icon Disabled"])
        else
            SDT.Icon:Show("SimpleDatatexts")
            self:Print(L["Minimap Icon Enabled"])
        end
    elseif command == "version" then
        self:Print(format("%s %s: |cff8888ff%s|r", L["Simple Datatexts"], L["Version"], self.cache.version))
    elseif command == "debug" then
        self.db.profile.debugMode = not self.db.profile.debugMode
        if self.db.profile.debugMode then
            self:Print(L["Debug Mode Enabled"])
        else
            self:Print(L["Debug Mode Disabled"])
        end
    else
        self:Print(L["Usage"] .. ":")
        self:Print("/sdt config - " .. L["Settings"])
        self:Print("/sdt lock - " .. L["Lock/Unlock"])
        self:Print("/sdt minimap - " .. L["Toggle Minimap Icon"])
        self:Print("/sdt version - " .. L["Version"])
    end
end

----------------------------------------------------
-- Utility: Print Function
----------------------------------------------------
function SDT:Print(...)
    print("[|cFFFF6600SDT|r]", ...)
end

----------------------------------------------------
-- Utility: Get Character Key
----------------------------------------------------
function SDT:GetCharKey()
    return self.cache.charKey
end

----------------------------------------------------
-- Module Registration
----------------------------------------------------
function SDT:RegisterDataText(name, module)
    self.modules[name] = module
    self.cache.moduleNamesDirty = true
end

----------------------------------------------------
-- Save Bar Position
----------------------------------------------------
local function SaveBarPosition(bar)
    local point, _, relativePoint, x, y = bar:GetPoint()
    local barName = bar:GetName()
    SDT.db.profile.bars[barName].point = {
        point = point,
        relativePoint = relativePoint,
        x = x,
        y = y
    }
end

----------------------------------------------------
-- Create Movable Frame
----------------------------------------------------
local function CreateMovableFrame(name)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetClampedToScreen(true)

    f:SetScript("OnDragStart", function(self)
        if not SDT.db.profile.locked then
            self:StartMoving()
        end
    end)

    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        SaveBarPosition(self)
    end)

    return f
end

----------------------------------------------------
-- Create Data Bar
----------------------------------------------------
function SDT:CreateDataBar(id, numSlots)
    local name = "SDT_Bar" .. id
    if not self.db.profile.bars[name] then
        self.db.profile.bars[name] = {
            numSlots = numSlots or 3,
            slots = {},
            bgOpacity = 50,
            borderName = "None",
            border = "None",
            width = 300,
            height = 22,
            name = name
        }
    end
    
    local saved = self.db.profile.bars[name]
    local bar = CreateMovableFrame(name)
    self.bars[name] = bar

    bar:SetSize(300, 22)
    if saved.point then
        bar:SetPoint(saved.point.point, UIParent, saved.point.relativePoint, saved.point.x, saved.point.y)
    else
        bar:SetPoint("CENTER")
    end

    local scale = saved.scale or 100
    bar:SetScale(scale / 100)

    function bar:ApplyBackground()
        local hasBackground = saved.bgOpacity and saved.bgOpacity > 0
        local hasBorder = saved.borderName and saved.borderName ~= "None"

        if hasBackground or hasBorder then
            bar:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = hasBorder and saved.border or nil,
                edgeSize = hasBorder and saved.borderSize or 0
            })
            local alpha = (saved.bgOpacity or 50) / 100
            bar:SetBackdropColor(0, 0, 0, alpha)
            if saved.borderColor then
                local color = saved.borderColor:gsub("#", "")
                local r = tonumber(color:sub(1, 2), 16) / 255
                local g = tonumber(color:sub(3, 4), 16) / 255
                local b = tonumber(color:sub(5, 6), 16) / 255
                bar:SetBackdropBorderColor(r, g, b, alpha)
            end
        else
            bar:SetBackdrop(nil)
        end
    end

    bar:ApplyBackground()
    self:RebuildSlots(bar)
    return bar
end

----------------------------------------------------
-- Rebuild Slots
----------------------------------------------------
function SDT:RebuildSlots(bar)
    if not bar then return end

    local barName = bar:GetName()
    local saved = self.db.profile.bars[barName]
    if not saved then return end

    local numSlots = saved.numSlots or 3
    local totalW = saved.width or 300
    local totalH = saved.height or 22
    local slotW = totalW / numSlots
    local slotH = totalH
    
    bar:SetSize(totalW, totalH)

    bar.slots = bar.slots or {}

    -- Hide/cleanup extra slots if we have more than needed
    for i = numSlots + 1, #bar.slots do
        local slot = bar.slots[i]
        if slot then
            if slot.moduleFrame then
                slot.moduleFrame:UnregisterAllEvents()
                slot.moduleFrame:SetScript("OnUpdate", nil)
                slot.moduleFrame:SetScript("OnEvent", nil)
                slot.moduleFrame:Hide()
                
                if SDT.UpdateTicker then
                    SDT.UpdateTicker:UnregisterPrefix(slot.module .. "_")
                end
            end
            slot:Hide()
        end
    end

    for i = 1, numSlots do
        local slot = bar.slots[i]
        
        -- Reuse existing slot frame if possible
        if not slot then
            local slotName = barName .. "_Slot" .. i
            slot = CreateFrame("Button", slotName, bar)
            slot.text = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            slot.text:SetPoint("CENTER")
            
            -- Set up mouse events once
            slot:EnableMouse(true)
            slot:RegisterForClicks("AnyUp")
            slot:RegisterForDrag("LeftButton")
            
            bar.slots[i] = slot
        end
        
        -- Update slot properties
        slot.index = i
        slot:SetSize(slotW, slotH)
        slot:ClearAllPoints()
        slot:SetPoint("LEFT", bar, "LEFT", (i - 1) * slotW, 0)
        slot:Show()
        
        -- Read slot data
        local slotData = saved.slots[i]
        local assignedName, offsetX, offsetY
        
        if type(slotData) == "string" then
            assignedName = slotData
            offsetX, offsetY = 0, 0
        elseif type(slotData) == "table" then
            assignedName = slotData.module
            offsetX = slotData.offsetX or 0
            offsetY = slotData.offsetY or 0
        else
            assignedName = nil
            offsetX, offsetY = 0, 0
        end
        
        -- Only recreate module frame if the module changed
        if slot.module ~= assignedName then
            if slot.moduleFrame then
                slot.moduleFrame:UnregisterAllEvents()
                slot.moduleFrame:SetScript("OnUpdate", nil)
                slot.moduleFrame:SetScript("OnEvent", nil)
                slot.moduleFrame:Hide()
                
                if SDT.UpdateTicker then
                    SDT.UpdateTicker:UnregisterPrefix(slot.module .. "_")
                end
                slot.moduleFrame = nil
            end
            
            if assignedName == "(spacer)" then
                slot.module = "(spacer)"
                slot.text:SetText("")
            elseif assignedName and self.modules[assignedName] then
                slot.module = assignedName
                slot.moduleFrame = self.modules[assignedName].Create(slot)
            else
                slot.module = nil
                slot.text:SetText(assignedName or L["(empty)"])
            end
        end

        -- Apply frame strata
        if assignedName and assignedName ~= "(spacer)" and self.modules[assignedName] then
            local strata = self:GetModuleFrameStrata(assignedName)
            
            -- Set strata on the slot itself (parent frame)
            slot:SetFrameStrata(strata)
            
            -- Set strata on the module frame if it exists
            if slot.moduleFrame then
                slot.moduleFrame:SetFrameStrata(strata)
            end
            
            -- Set strata on secure button if it exists
            if slot.secureButton then
                slot.secureButton:SetFrameStrata(strata)
            end
        end
        
        -- Apply offset
        if slot.text then
            local anchorPoint = self:GetModuleSetting(assignedName, "anchorPoint", "CENTER")
            slot.text:ClearAllPoints()
            slot.text:SetPoint(anchorPoint, slot, anchorPoint, offsetX, offsetY)
        end
        
        -- Set up event handlers (these need to capture current values)
        slot:SetScript("OnMouseUp", function(self, btn)
            if btn == "RightButton" and IsControlKeyDown() then
                SDT:ShowSlotDropdown(self, bar)
            end
        end)
        
        slot:SetScript("OnDragStart", function(self)
            if not SDT.db.profile.locked then
                bar:StartMoving()
            end
        end)
        
        slot:SetScript("OnDragStop", function(self)
            bar:StopMovingOrSizing()
            SaveBarPosition(bar)
        end)
    end

    self:ApplyFont()
end

----------------------------------------------------
-- Rebuild All Slots
----------------------------------------------------
function SDT:RebuildAllSlots()
    for _, bar in pairs(self.bars) do
        self:RebuildSlots(bar)
    end
end

----------------------------------------------------
-- Slot Selection Dropdown
----------------------------------------------------
function SDT:ShowSlotDropdown(slot, bar)
    local maxVisibleItems = 20 -- Maximum items to show before scrolling
    local totalItems = 2 + #self.cache.moduleNames -- (empty) + (spacer) + modules
    
    if totalItems <= maxVisibleItems then
        -- Use normal context menu for small lists
        MenuUtil.CreateContextMenu(slot, function(owner, root)
            -- Empty option
            root:CreateButton(L["(empty)"], function()
                self.db.profile.bars[bar:GetName()].slots[slot.index] = nil
                self:RebuildSlots(bar)
            end)

            -- Spacer option
            root:CreateButton(L["(spacer)"], function()
                self.db.profile.bars[bar:GetName()].slots[slot.index] = "(spacer)"
                self:RebuildSlots(bar)
            end)

            -- Module options
            for _, moduleName in ipairs(self.cache.moduleNames) do
                root:CreateButton(moduleName, function()
                    self.db.profile.bars[bar:GetName()].slots[slot.index] = moduleName
                    self:RebuildSlots(bar)
                end)
            end
        end)
    else
        -- Close any existing custom dropdown
        if self.customDropdown then
            self.customDropdown:Hide()
            self.customDropdown = nil
        end
        
        -- Create custom scrollable dropdown
        local dropdown = CreateFrame("Frame", "SDT_CustomSlotDropdown", UIParent, "BackdropTemplate")
        self.customDropdown = dropdown
        
        local itemHeight = 18
        local visibleHeight = maxVisibleItems * itemHeight
        local dropdownWidth = 200
        local backdropInsets = 4 -- top (2) + bottom (2) insets from backdrop
        
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
        
        -- Create scrollbar
        local scrollbar = CreateFrame("Slider", nil, dropdown, "UIPanelScrollBarTemplate")
        scrollbar:SetPoint("TOPRIGHT", dropdown, "TOPRIGHT", -3, -18)
        scrollbar:SetPoint("BOTTOMRIGHT", dropdown, "BOTTOMRIGHT", -3, 18)
        scrollbar:SetMinMaxValues(0, math.max(0, (totalItems * itemHeight) - visibleHeight))
        scrollbar:SetValueStep(itemHeight)
        scrollbar:SetObeyStepOnDrag(true)
        scrollbar:SetWidth(18)
        
        scrollbar:SetScript("OnValueChanged", function(self, value)
            scrollFrame:SetVerticalScroll(value)
        end)
        
        -- Mouse wheel scrolling
        scrollFrame:EnableMouseWheel(true)
        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local current = scrollbar:GetValue()
            local minVal, maxVal = scrollbar:GetMinMaxValues()
            local newValue = current - (delta * itemHeight * 3) -- Scroll 3 items at a time
            newValue = math.max(minVal, math.min(maxVal, newValue))
            scrollbar:SetValue(newValue)
        end)
        
        -- Create buttons
        local buttons = {}
        local itemIndex = 0
        
        local function CreateButton(text, onClick)
            local btn = CreateFrame("Button", nil, scrollChild)
            btn:SetSize(dropdownWidth - 22, itemHeight)
            btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(itemIndex * itemHeight))
            
            btn:SetNormalFontObject("GameFontHighlightSmall")
            btn:SetHighlightFontObject("GameFontHighlightSmall")
            
            local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            btnText:SetPoint("LEFT", btn, "LEFT", 5, 0)
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
        
        -- Add (empty) option
        CreateButton(L["(empty)"], function()
            self.db.profile.bars[bar:GetName()].slots[slot.index] = nil
            self:RebuildSlots(bar)
        end)
        
        -- Add (spacer) option
        CreateButton(L["(spacer)"], function()
            self.db.profile.bars[bar:GetName()].slots[slot.index] = "(spacer)"
            self:RebuildSlots(bar)
        end)
        
        -- Add module options
        for _, moduleName in ipairs(self.cache.moduleNames) do
            CreateButton(moduleName, function()
                self.db.profile.bars[bar:GetName()].slots[slot.index] = moduleName
                self:RebuildSlots(bar)
            end)
        end
        
        -- Close on click outside
        dropdown:SetScript("OnHide", function()
            self.customDropdown = nil
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
            self.customDropdown = nil
        end)
        
        -- Show the dropdown after close button so it's on top
        closeButton:SetFrameLevel(dropdown:GetFrameLevel() - 1)
        dropdown:Show()
        
        -- Set initial scroll position
        scrollbar:SetValue(0)
    end
end