-- Simple DataTexts

----------------------------------------------------
-- Addon Locals
----------------------------------------------------
local addonName, addon = ...

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format           = string.format
local print            = print
local strsplit         = strsplit
local stringlower      = string.lower
local tconcat          = table.concat
local tinsert          = table.insert
local tonumber         = tonumber
local tostring         = tostring
local tsort            = table.sort
local wipe             = table.wipe

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame               = CreateFrame
local GetAddOnMetadata          = C_AddOns.GetAddOnMetadata
local GetClassColor             = C_ClassColor.GetClassColor
local ToggleDropDownMenu        = ToggleDropDownMenu
local UIDropDownMenu_AddButton  = UIDropDownMenu_AddButton
local UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize
local UIDropDownMenu_SetText    = UIDropDownMenu_SetText
local UIParent                  = UIParent
local UnitClass                 = UnitClass
local UnitName                  = UnitName

-- Defaults
_G.SDTDB = _G.SDTDB or {
    bars = {}, -- keyed by name: { numSlots = 3, slots = { [1] = "FPS", ... }, point = { point = ..., relativePoint = ..., x = ..., y = ... }, showBackground = true, showBorder = true, width = 300, height = 22, scale = 100, bgOpacity = 50 }
    settings = { locked = false, useClassColor = false },
    gold = {}
}

addon.modules = addon.modules or {}
addon.bars = addon.bars or {}

-------------------------------------------------
-- Build Our Cache
-------------------------------------------------
addon.cache = {}
addon.cache.playerName = UnitName("player")
addon.cache.playerClass = select(2, UnitClass("player"))
local colors = { GetClassColor(addon.cache.playerClass):GetRGB() }
addon.cache.colorR = colors[1]
addon.cache.colorG = colors[2]
addon.cache.colorB = colors[3]
--addon.cache.colorRGB = format("|cff%02x%02x%02x", addon.cache.colorR * 255, addon.cache.colorG * 255, addon.cache.colorB * 255)
addon.cache.colorHex = GetClassColor(addon.cache.playerClass):GenerateHexColor()
addon.cache.version = GetAddOnMetadata(addonName, "Version") or "not defined"
addon.cache.moduleNames = {}
SDTCache = addon.cache

-------------------------------------------------
-- Module Registration
-------------------------------------------------
function addon:RegisterDataText(name, module)
    addon.modules[name] = module
end

-------------------------------------------------
-- Utility: Print function
-------------------------------------------------
function addon.Print(...)
    print("[|cFFFF6600SDT|r]", ...)
end

-------------------------------------------------
-- Utility: Get Tag Color
-------------------------------------------------
function addon:GetTagColor()
    if SDTDB.settings.useClassColor then
        return addon.cache.colorHex
    end
    return "ffffffff"
end

-------------------------------------------------
-- Utility: Color Text
-------------------------------------------------
function addon:ColorText(text)
    local color = addon:GetTagColor()
    return "|c"..color..text.."|r"
end

-------------------------------------------------
-- Utility: Format Percentage
-------------------------------------------------
function addon:FormatPercent(v)
    return string.format("%.2f%%", v)
end

-------------------------------------------------
-- Utility: Format Percentage
-------------------------------------------------
function addon:FindBestAnchorPoint(frame)
    local x, y = frame:GetCenter()
    local screenWidth = UIParent:GetRight()
    local screenHeight = UIParent:GetTop()

    local anchor, relPoint
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

-------------------------------------------------
-- Utility: find next free bar ID
-------------------------------------------------
local function NextBarID()
    local n = 1
    while SDTDB.bars["SDT_Bar" .. n] do
        n = n + 1
    end
    return n
end

-------------------------------------------------
-- Movable Frame Helper
-------------------------------------------------
local function CreateMovableFrame(name)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")

    f:SetScript("OnDragStart", function(self)
        if not SDTDB.settings.locked then
            self:StartMoving()
        end
    end)

    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
        if SDTDB.bars[self:GetName()] then
            SDTDB.bars[self:GetName()].point = { point = point, relativePoint = relativePoint, x = xOfs, y = yOfs }
        end
    end)

    return f
end

-------------------------------------------------
-- Create or Restore a Data Bar
-------------------------------------------------
function addon:CreateDataBar(id, numSlots)
    local name = "SDT_Bar" .. id
    if not SDTDB.bars[name] then
        SDTDB.bars[name] = { numSlots = numSlots or 3, slots = {}, showBackground = true, showBorder = true, width = 300, height = 22, name = name }
    end
    local saved = SDTDB.bars[name]

    local bar = CreateMovableFrame(name)
    addon.bars[name] = bar

    bar:SetSize(300, 22)
    if saved.point then
        bar:SetPoint(saved.point.point, UIParent, saved.point.relativePoint, saved.point.x, saved.point.y)
    else
        bar:SetPoint("CENTER")
    end

    local scale = saved.scale or 100
    bar:SetScale(scale / 100)

    function bar:ApplyBackground()
        if saved.showBackground then
            bar:SetBackdrop({ 
                bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
                edgeFile = saved.showBorder and "Interface/Tooltips/UI-Tooltip-Border" or nil, 
                edgeSize = saved.showBorder and 8 or 0 
            })
            local alpha = (saved.bgOpacity or 50) / 100
            bar:SetBackdropColor(0,0,0,alpha)
        else
            bar:SetBackdrop(nil)
        end
    end

    bar:ApplyBackground()
    addon:RebuildSlots(bar)
    return bar
end

-------------------------------------------------
-- Rebuild Slots (size/assignments)
-------------------------------------------------
function addon:RebuildSlots(bar)
    if not bar then return end

    -- hide and clear existing slot frames
    for _, s in ipairs(bar.slots or {}) do
        s:SetParent(nil)
        s:Hide()
    end
    bar.slots = {}

    local saved = SDTDB.bars[bar:GetName()]
    if not saved then return end
    local numSlots = saved.numSlots or 3

    -- Horizontal layout
    local totalW = saved.width or 300
    local totalH = saved.height or 22
    local slotW = totalW / numSlots
    local slotH = totalH
    bar:SetSize(totalW, totalH)
    
    for i = 1, numSlots do
        local slotName = bar:GetName() .. "_Slot" .. i
        local slot = CreateFrame("Button", slotName, bar)
        slot:SetSize(slotW, slotH)
        slot.index = i
        slot:SetPoint("LEFT", bar, "LEFT", (i - 1) * slotW, 0)

        slot.text = slot.text or slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        slot.text:SetPoint("CENTER")
        slot.text:SetText("")

        local assignedName = saved.slots[i]
        if assignedName and addon.modules[assignedName] then
            local mod = addon.modules[assignedName]
            if slot.moduleFrame and slot.moduleFrame.Hide then slot.moduleFrame:Hide() end
            slot.module = assignedName
            slot.moduleFrame = mod.Create(slot)
        else
            slot.module = nil
            if slot.moduleFrame and slot.moduleFrame.Hide then slot.moduleFrame:Hide() end
            slot.text:SetText(assignedName or "(empty)")
        end

        slot:EnableMouse(true)
        slot:RegisterForClicks("RightButtonUp")
        slot:SetScript("OnMouseUp", function(self, btn)
            if btn == "RightButton" then
                addon:ShowSlotDropdown(self, bar)
            end
        end)

        -- Forward drag events to parent bar
        slot:RegisterForDrag("LeftButton")
        slot:SetScript("OnDragStart", function(self)
            if not SDTDB.settings.locked then
                bar:StartMoving()
            end
        end)
        slot:SetScript("OnDragStop", function(self)
            bar:StopMovingOrSizing()
            local point, relativeTo, relativePoint, xOfs, yOfs = bar:GetPoint()
            if SDTDB.bars[bar:GetName()] then
                SDTDB.bars[bar:GetName()].point = { point = point, relativePoint = relativePoint, x = xOfs, y = yOfs }
            end
        end)

        bar.slots[i] = slot
    end
end

-------------------------------------------------
-- Rebuild Slots on All Bars
-------------------------------------------------
function addon:RebuildAllSlots()
    for _, bar in pairs(SDTDB.bars) do
        addon.Print("Rebuilding slots for bar " .. bar.name)
        addon:RebuildSlots(bar)
    end
end

-------------------------------------------------
-- Update All Modules
-------------------------------------------------
function addon:UpdateAllModules()
    for _, bar in pairs(addon.bars) do
        for _, slot in pairs(bar.slots) do
            if slot.moduleFrame and slot.moduleFrame.Update then
                slot.moduleFrame.Update()
            end
        end
    end
end

-------------------------------------------------
-- Slot Selection Dropdown
-------------------------------------------------
local dropdownFrame = CreateFrame("Frame", addonName .. "_SlotDropdown", UIParent, "UIDropDownMenuTemplate")
function addon:ShowSlotDropdown(slot, bar)
    local function InitializeDropdown()
        local info = UIDropDownMenu_CreateInfo()
        info.notCheckable = true

        for _, moduleName in ipairs(addon.cache.moduleNames) do
            info.text = moduleName
            info.func = function()
                SDTDB.bars[bar:GetName()].slots[slot.index] = moduleName
                addon:RebuildSlots(bar)
            end
            UIDropDownMenu_AddButton(info)
        end
    end

	UIDropDownMenu_Initialize(dropdownFrame, InitializeDropdown)
    ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 0, 0)
end

-------------------------------------------------
-- Settings Panel UI
-------------------------------------------------
local panel = CreateFrame("Frame", addonName .. "_Settings", UIParent)
panel.name = "Simple DataTexts"

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(panel.name)

local version = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
version:SetPoint("LEFT", title, "RIGHT", 6, -1)
version:SetText("v" .. addon.cache.version)

local function MakeLabel(parent, text, point, x, y)
    local t = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    t:SetPoint(point, x, y)
    t:SetText(text)
    return t
end

local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
category.ID = panel.name
Settings.RegisterAddOnCategory(category)

-------------------------------------------------
-- Left Column Controls
-------------------------------------------------
-- Lock Panels
local lockCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
lockCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
lockCheckbox.Text:SetText("Lock Panels (disable movement)")
lockCheckbox:SetChecked(SDTDB.settings.locked)
lockCheckbox:SetScript("OnClick", function(self)
    SDTDB.settings.locked = self:GetChecked()
end)

-- Use Class Color
local classColorCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
classColorCheckbox:SetPoint("TOPLEFT", lockCheckbox, "BOTTOMLEFT", 0, -20)
classColorCheckbox.Text:SetText("Use Class Color")
classColorCheckbox:SetChecked(SDTDB.settings.useClassColor)
classColorCheckbox:SetScript("OnClick", function(self)
    SDTDB.settings.useClassColor = self:GetChecked()
    addon:UpdateAllModules()
end)

-- Add Panel
local addBarButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
addBarButton:SetPoint("TOPLEFT", classColorCheckbox, "BOTTOMLEFT", 0, -16)
addBarButton:SetSize(140, 24)
addBarButton:SetText("Create New Panel")

-- Panel Selector
local panelLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
panelLabel:SetPoint("TOPLEFT", addBarButton, "BOTTOMLEFT", 0, -16)
panelLabel:SetText("Select Panel:")
local panelDropdown = CreateFrame("Frame", addonName .. "_PanelDropdown", panel, "UIDropDownMenuTemplate")
panelDropdown:SetPoint("TOPLEFT", panelLabel, "BOTTOMLEFT", -20, -6)
UIDropDownMenu_SetWidth(panelDropdown, 160)

-- Rename Panel
local renameLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
renameLabel:SetPoint("TOPLEFT", panelDropdown, "BOTTOMLEFT", 20, -16)
renameLabel:SetText("Rename Panel:")
renameLabel:Hide()
local nameEditBox = CreateFrame("EditBox", addonName .. "_PanelNameEditBox", panel, "InputBoxTemplate")
nameEditBox:SetSize(170, 20)
nameEditBox:SetPoint("TOPLEFT", renameLabel, "BOTTOMLEFT", 4, -6)
nameEditBox:SetAutoFocus(false)
nameEditBox:SetJustifyH("CENTER")
nameEditBox:SetJustifyV("MIDDLE")
nameEditBox:SetText("")
nameEditBox:Hide()

nameEditBox:SetScript("OnEnterPressed", function(self)
    local newName = self:GetText():trim()
    if newName ~= "" and panel.selectedBar then
        SDTDB.bars[panel.selectedBar].name = newName
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
        UIDropDownMenu_SetText(panelDropdown, newName)
    end
end)

-------------------------------------------------
-- Right Column Controls (per-panel)
-------------------------------------------------
local removeBarButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
removeBarButton:SetSize(160, 24)
removeBarButton:SetPoint("LEFT", lockCheckbox, "RIGHT", 280, 0)
removeBarButton:SetText("Remove Selected Panel")
removeBarButton:Hide()

local bgCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
bgCheckbox:SetPoint("TOPLEFT", removeBarButton, "BOTTOMLEFT", 0, -12)
bgCheckbox.Text:SetText("Show Background")
bgCheckbox:Hide()

local borderCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
borderCheckbox:SetPoint("LEFT", bgCheckbox, "RIGHT", 100, 0)
borderCheckbox.Text:SetText("Show Border")
borderCheckbox:Hide()

local slotSelectors = {}
local function buildSlotSelectors(barName)
    for _, f in ipairs(slotSelectors) do f:Hide() end
    slotSelectors = {}

    local b = SDTDB.bars[barName]
    if not b then return end

    for i = 1, b.numSlots do
        local lbl = MakeLabel(panel, "Slot " .. i .. ":", "TOPLEFT", 320, -290 - ((i - 1) * 50))
        local dd = CreateFrame("Frame", addonName .. "_SlotSel_" .. i, panel, "UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", -20, -6)
        UIDropDownMenu_SetWidth(dd, 140)

        UIDropDownMenu_Initialize(dd, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.text = "(empty)"
            info.func = function()
                SDTDB.bars[barName].slots[i] = nil
                UIDropDownMenu_SetText(dd, "(empty)")
                if addon.bars[barName] then addon:RebuildSlots(addon.bars[barName]) end
            end
            UIDropDownMenu_AddButton(info)

            for _, name in ipairs(addon.cache.moduleNames) do
                local moduleName = name
                info.text = moduleName
                info.func = function()
                    SDTDB.bars[barName].slots[i] = name
                    UIDropDownMenu_SetText(dd, name)
                    if addon.bars[barName] then addon:RebuildSlots(addon.bars[barName]) end
                end
                UIDropDownMenu_AddButton(info)
            end
        end)

        UIDropDownMenu_SetText(dd, b.slots[i] or "(empty)")
        table.insert(slotSelectors, lbl)
        table.insert(slotSelectors, dd)
    end
end

-------------------------------------------------
-- Custom Slider with EditBox
-------------------------------------------------
local function CreateSliderWithBox(parent, name, text, min, max, step, attach, x, y)
    -- Slider
    local slider = CreateFrame("Slider", addonName.."_"..name.."Slider", parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", attach, "BOTTOMLEFT", x, y)
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetWidth(160)
    getglobal(slider:GetName().."Text"):SetText(text)
    getglobal(slider:GetName().."Low"):SetText(tostring(min))
    getglobal(slider:GetName().."High"):SetText(tostring(max))
    slider:Hide()
    
    -- Edit Box
    local eb = CreateFrame("EditBox", addonName.."_"..name.."EditBox", parent, "InputBoxTemplate")
    eb:SetSize(50, 20)
    eb:SetPoint("LEFT", slider, "RIGHT", 25, 0)
    eb:SetAutoFocus(false)
    eb:SetJustifyH("CENTER")
    eb:SetJustifyV("MIDDLE")
    eb:SetText(min)
    eb:Hide()
    
    -- Sync slider -> editbox
    slider:SetScript("OnValueChanged", function(self, value)
        local val = math.floor(value + 0.5)
        eb:SetText(val)
        if panel.selectedBar then
            local barData = SDTDB.bars[panel.selectedBar]
            if name == "Slots" then
                barData.numSlots = val
            elseif name == "Width" then
                barData.width = val
            elseif name == "Height" then
                barData.height = val
            elseif name == "Scale" then
                barData.scale = val
                if addon.bars[panel.selectedBar] then
                    addon.bars[panel.selectedBar]:SetScale(val / 100)
                end
            elseif name == "Background Opacity" then
                barData.bgOpacity = val
                if addon.bars[panel.selectedBar] then
                    addon.bars[panel.selectedBar]:ApplyBackground()
                end
            end
            if addon.bars[panel.selectedBar] then
                addon:RebuildSlots(addon.bars[panel.selectedBar])
            end
            if name == "Slots" then
                buildSlotSelectors(panel.selectedBar)
            end
        end
    end)
    
    -- Sync editbox -> slider
    eb:SetScript("OnEnterPressed", function(self)
        local val = tonumber(self:GetText())
        if val then
            val = math.max(min, math.min(max, val))
            slider:SetValue(val)
            self:SetText(val)
            if name == "Scale" and addon.bars[panel.selectedBar] then
                addon.bars[panel.selectedBar]:SetScale(val / 100)
            elseif name == "Background Opacity" and addon.bars[panel.selectedBar] then
                addon.bars[panel.selectedBar]:ApplyBackground()
            end
        else
            -- reset to slider value if invalid
            self:SetText(math.floor(slider:GetValue()+0.5))
        end
    end)
    
    return slider, eb
end

local opacitySlider, opacityBox = CreateSliderWithBox(panel, "Background Opacity", "Background Opacity", 0, 100, 1, bgCheckbox, 0, -20)
local slotSlider, slotBox = CreateSliderWithBox(panel, "Slots", "Slots", 1, 5, 1, opacitySlider, 0, -20)
local widthSlider, widthBox = CreateSliderWithBox(panel, "Width", "Width", 100, 800, 1, slotSlider, 0, -20)
local heightSlider, heightBox = CreateSliderWithBox(panel, "Height", "Height", 16, 128, 1, widthSlider, 0, -20)
local scaleSlider, scaleBox = CreateSliderWithBox(panel, "Scale", "Scale", 50, 500, 1, nameEditBox, 3, -30)

-- Panel dropdown initializer
local function PanelDropdown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for barName, _ in pairs(SDTDB.bars) do
        local displayName = SDTDB.bars[barName].name or barName
        info.text = displayName
        info.func = function()
            UIDropDownMenu_SetText(panelDropdown, displayName)
            panel.selectedBar = barName
            updateSelectedBarControls()
        end
        UIDropDownMenu_AddButton(info)
    end
end
UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)

-- Update per-panel controls
function updateSelectedBarControls()
    local barName = panel.selectedBar
    if not barName then
        removeBarButton:Hide()
        bgCheckbox:Hide()
        borderCheckbox:Hide()
        slotSlider:Hide()
        slotBox:Hide()
        widthSlider:Hide()
        widthBox:Hide()
        heightSlider:Hide()
        heightBox:Hide()
        renameLabel:Hide()
        nameEditBox:Hide()
        scaleSlider:Hide()
        scaleBox:Hide()
        opacitySlider:Hide()
        opacityBox:Hide()
        for _, f in ipairs(slotSelectors) do f:Hide() end
        return
    end

    removeBarButton:Show()
    bgCheckbox:Show()
    borderCheckbox:Show()
    slotSlider:Show()
    slotBox:Show()
    widthSlider:Show()
    widthBox:Show()
    heightSlider:Show()
    heightBox:Show()
    renameLabel:Show()
    nameEditBox:SetText(SDTDB.bars[barName].name or barName)
    nameEditBox:Show()
    scaleSlider:Show()
    scaleBox:Show()
    opacitySlider:Show()
    opacityBox:Show()

    local b = SDTDB.bars[barName]
    if not b then return end

    -- Background / Border
    bgCheckbox:SetChecked(b.showBackground)
    bgCheckbox:SetScript("OnClick", function(self)
        b.showBackground = self:GetChecked()
        if addon.bars[barName] then addon.bars[barName]:ApplyBackground() end
    end)
    borderCheckbox:SetChecked(b.showBorder)
    borderCheckbox:SetScript("OnClick", function(self)
        b.showBorder = self:GetChecked()
        if addon.bars[barName] then addon.bars[barName]:ApplyBackground() end
    end)

    -- Slots
    local numSlots = b.numSlots or 3
    slotSlider:SetValue(numSlots)
    slotBox:SetText(numSlots)

    -- Width
    local width = b.width or 300
    widthSlider:SetValue(width)
    widthBox:SetText(width)

    -- Height
    local height = b.height or 22
    heightSlider:SetValue(height)
    heightBox:SetText(height)

    -- Scale
    local scale = b.scale or 100
    scaleSlider:SetValue(scale)
    scaleBox:SetText(scale)

    -- Opacity
    local opacity = b.bgOpacity or 50
    opacitySlider:SetValue(opacity)
    opacityBox:SetText(opacity)

    -- Rebuild slots & selectors
    if addon.bars[barName] then addon:RebuildSlots(addon.bars[barName]) end
    buildSlotSelectors(barName)
end


-- Add Panel button click
addBarButton:SetScript("OnClick", function()
    local id = NextBarID()
    local name = "SDT_Bar" .. id
    SDTDB.bars[name] = { numSlots = 3, slots = {}, showBackground = true, showBorder = true, width = 300, height = 22 }
    addon:CreateDataBar(id, 3)
    UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
    UIDropDownMenu_SetText(panelDropdown, name)
    panel.selectedBar = name
    updateSelectedBarControls()
end)

-- Remove selected panel
removeBarButton:SetScript("OnClick", function()
    local barName = panel.selectedBar
    if not barName then return end
    if addon.bars[barName] then addon.bars[barName]:Hide() addon.bars[barName] = nil end
    SDTDB.bars[barName] = nil
    panel.selectedBar = nil
    UIDropDownMenu_SetText(panelDropdown, "(none)")
    UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
    for _, f in ipairs(slotSelectors) do f:Hide() end
    slotSelectors = {}
end)

-------------------------------------------------
-- Create Module List
-------------------------------------------------
local function CreateModuleList()
    wipe(addon.cache.moduleNames)
    for name in pairs(addon.modules) do
        tinsert(addon.cache.moduleNames, name)
    end
    tsort(addon.cache.moduleNames)
end

-------------------------------------------------
-- Loader to restore bars on addon load
-------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, arg)
    if arg == addonName then
        CreateModuleList()      

        if not next(SDTDB.bars) then
            SDTDB.bars["SDT_Bar1"] = { numSlots = 3, slots = {}, showBackground = true, showBorder = true }
        end
        for barName, data in pairs(SDTDB.bars) do
            local id = tonumber(barName:match("SDT_Bar(%d+)") or "0")
            if id > 0 and not addon.bars[barName] then
                addon:CreateDataBar(id, data.numSlots)
            end
        end
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)

        -- Sync settings after the addon is fully loaded
        lockCheckbox:SetChecked(SDTDB.settings.locked)
        classColorCheckbox:SetChecked(SDTDB.settings.useClassColor)
    end
end)

local function SlashHelp()
    addon.Print("|cffffff00--[Options]--|r")
    addon.Print("Lock/Unlock: |cff8888ff/sdt lock|r")
    addon.Print("Width: |cff8888ff/sdt width <barName> <newWidth>|r")
    addon.Print("Height: |cff8888ff/sdt height <barName> <newHeight>|r")
    addon.Print("Scale: |cff8888ff/sdt scale <barName> <newScale>|r")
    addon.Print("Settings: |cff8888ff/sdt config|r")
    addon.Print("Version: |cff8888ff/sdt version|r")
end

local function BarAdjustments(adj, bar, num)
    -- Make sure we have all of our values
    if not adj or not bar or not num then
        addon.Print("Usage: /sdt " .. adj .. " <barName> <value>")
        SlashHelp()
        return
    end

    -- Check custom name if supplied instead of the bar key
    if not SDTDB.bars[bar] then
        local resolved = nil
        for barItem, settings in pairs(SDTDB.bars) do
            if stringlower(settings.name) == stringlower(bar) then
                resolved = barItem
                break
            end
        end
        if not resolved then
            addon.Print("Invalid panel name supplied. Valid panel names are:")
            for j,k in pairs(SDTDB.bars) do
                addon.Print("- ", tostring(j), "("..tostring(k.name)..")")
            end
            return
        end
        bar = resolved
    end

    -- Validate the number supplied
    if type(num) ~= "number" then
        addon.Print("A valid numeric value for the adjustment must be specified.")
        SlashHelp()
        return
    end

    -- Further validate the value is within parameters, then make the adjustment
    if adj == "width" then
        if num >= 100 and num <= 800 then
            SDTDB.bars[bar].width = num
            widthSlider:SetValue(num)
            widthBox:SetText(num)
            addon:RebuildSlots(addon.bars[bar])
        else
            addon.Print("Invalid panel width specified.")
        end
    elseif adj == "height" then
        if num >= 16 and num <= 128 then
            SDTDB.bars[bar].height = num
            heightSlider:SetValue(num)
            heightBox:SetText(num)
            addon:RebuildSlots(addon.bars[bar])
        else
            addon.Print("Invalid panel height specified.")
        end
    elseif adj == "scale" then
        if num >= 50 and num <= 500 then
            SDTDB.bars[bar].scale = num
            scaleSlider:SetValue(num)
            scaleBox:SetText(num)
            addon.bars[bar]:SetScale(num / 100)
        else
            addon.Print("Invalid panel scale specified.")
        end
    else
        addon.Print("Invalid adjustment type specified.")
    end
end

-- Slash command
SLASH_SDT1 = "/sdt"
SlashCmdList["SDT"] = function(msg)
    local args = {}
    for word in msg:gmatch("%S+") do
        tinsert(args, word)
    end
    local command = args[1] and stringlower(args[1]) or ""
    local bar, num
    if #args > 2 then
        num = tonumber(args[#args])
        bar = tconcat(args, " ", 2, #args - 1)
    end
    if command == "config" then
        Settings.OpenToCategory(panel.name)
    elseif command == "lock" then
        SDTDB.settings.locked = not SDTDB.settings.locked
        lockCheckbox:SetChecked(SDTDB.settings.locked)
        addon.Print("SDT panels are now: ", SDTDB.settings.locked and "|cffff0000LOCKED|r" or "|cff00ff00UNLOCKED|r")
    elseif command == "width" or command == "height" or command == "scale" then
        BarAdjustments(command, bar, num)
    elseif command == "update" then
        addon:UpdateAllModules()
    elseif command == "version" then
        addon.Print("Simple Datatexts Version: |cff8888ff" ..tostring(addon.cache.version) .. "|r")
    else
        SlashHelp()
    end
end
