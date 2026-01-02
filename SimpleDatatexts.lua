-- Simple DataTexts

----------------------------------------------------
-- Addon Locals
----------------------------------------------------
local addonName, SDT = ...
local L = SDT.L

----------------------------------------------------
-- Library Instances
----------------------------------------------------
local LSM = LibStub("LibSharedMedia-3.0")

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format           = string.format
local mathfloor        = math.floor
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
local CopyTable                 = CopyTable
local CreateFrame               = CreateFrame
local Delay                     = C_Timer.After
local GetAddOnInfo              = C_AddOns.GetAddOnInfo
local GetAddOnMetadata          = C_AddOns.GetAddOnMetadata
local GetClassColor             = C_ClassColor.GetClassColor
local GetNumAddOns              = C_AddOns.GetNumAddOns
local GetRealmName              = GetRealmName
local GetScreenWidth            = GetScreenWidth
local IsControlKeyDown          = IsControlKeyDown
local IsShiftKeyDown            = IsShiftKeyDown
local ToggleDropDownMenu        = ToggleDropDownMenu
local UIDropDownMenu_AddButton  = UIDropDownMenu_AddButton
local UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize
local UIDropDownMenu_SetText    = UIDropDownMenu_SetText
local UIParent                  = UIParent
local UnitClass                 = UnitClass
local UnitName                  = UnitName

-------------------------------------------------
-- Bar Position Helper
-------------------------------------------------
local function SaveBarPosition(bar)
    local point, _, relativePoint, xOfs, yOfs = bar:GetPoint()
    if SDT.profileBars[bar:GetName()] then
        SDT.profileBars[bar:GetName()].point = {
            point = point,
            relativePoint = relativePoint,
            x = xOfs,
            y = yOfs
        }
    end
end

-------------------------------------------------
-- Movable Frame Helper
-------------------------------------------------
local function CreateMovableFrame(name)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetClampedToScreen(true)

    f:SetScript("OnDragStart", function(self)
        if not SDT.SDTDB_CharDB.settings.locked then
            self:StartMoving()
        end
    end)

    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        SaveBarPosition(self)
    end)

    return f
end

-------------------------------------------------
-- Create or Restore a Data Bar
-------------------------------------------------
function SDT:CreateDataBar(id, numSlots)
    local name = "SDT_Bar" .. id
    if not SDT.profileBars[name] then
        SDT.profileBars[name] = { numSlots = numSlots or 3, slots = {}, bgOpacity = 50, borderName = "None", border = "None", width = 300, height = 22, name = name }
    end
    local saved = SDT.profileBars[name]

    local bar = CreateMovableFrame(name)
    SDT.bars[name] = bar

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
            bar:SetBackdropColor(0,0,0,alpha)
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
    SDT:RebuildSlots(bar)
    return bar
end

-------------------------------------------------
-- Rebuild Slots (size/assignments)
-------------------------------------------------
function SDT:RebuildSlots(bar)
    if not bar then return end

    -- hide and clear existing slot frames
    for _, s in ipairs(bar.slots or {}) do
        if s.moduleFrame then
            if s.moduleFrame.Hide then s.moduleFrame:Hide() end
            if s.moduleFrame.SetParent then s.moduleFrame:SetParent(nil) end
            s.moduleFrame = nil
        end
        s:SetParent(nil)
        s:Hide()
    end
    bar.slots = {}

    local saved = SDT.profileBars[bar:GetName()]
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
        if assignedName and SDT.modules[assignedName] then
            local mod = SDT.modules[assignedName]
            if slot.moduleFrame and slot.moduleFrame.Hide then slot.moduleFrame:Hide() end
            slot.module = assignedName
            slot.moduleFrame = mod.Create(slot)
        else
            slot.module = nil
            if slot.moduleFrame and slot.moduleFrame.Hide then slot.moduleFrame:Hide() end
            slot.text:SetText(assignedName or L["(empty)"])
        end

        slot:EnableMouse(true)
        slot:RegisterForClicks("AnyUp")
        slot:SetScript("OnMouseUp", function(self, btn)
            if btn == "RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() then
                SDT:ShowSlotDropdown(self, bar)
            end
        end)

        -- Forward drag events to parent bar
        slot:RegisterForDrag("LeftButton")
        slot:SetScript("OnDragStart", function(self)
            if not SDT.SDTDB_CharDB.settings.locked then
                bar:StartMoving()
            end
        end)
        slot:SetScript("OnDragStop", function(self)
            bar:StopMovingOrSizing()
            SaveBarPosition(bar)
        end)

        bar.slots[i] = slot
    end

    SDT:ApplyFont()
end

-------------------------------------------------
-- Rebuild Slots on All Bars
-------------------------------------------------
function SDT:RebuildAllSlots()
    for _, bar in pairs(SDT.bars) do
        SDT:RebuildSlots(bar)
    end
end

-------------------------------------------------
-- Update All Modules
-------------------------------------------------
function SDT:UpdateAllModules()
    for _, bar in pairs(SDT.bars) do
        if bar.slots then
            for _, slot in pairs(bar.slots) do
                if slot.moduleFrame and slot.moduleFrame.Update then
                    slot.moduleFrame.Update()
                end
            end
        end
    end
end

-------------------------------------------------
-- Slot Selection Dropdown
-------------------------------------------------
local dropdownFrame = CreateFrame("Frame", addonName .. "_SlotDropdown", UIParent, "UIDropDownMenuTemplate")
function SDT:ShowSlotDropdown(slot, bar)
    local function InitializeDropdown()
        local info = UIDropDownMenu_CreateInfo()
        info.notCheckable = true

        for _, moduleName in ipairs(SDT.cache.moduleNames) do
            info.text = moduleName
            info.func = function()
                if SDT.profileBars[bar:GetName()] then
                    SDT.profileBars[bar:GetName()].slots[slot.index] = moduleName
                    SDT:RebuildSlots(bar)
                end
            end
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_Initialize(dropdownFrame, InitializeDropdown)
    ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 0, 0)
end

-------------------------------------------------
-- Create Module List
-------------------------------------------------
local function CreateModuleList()
    wipe(SDT.cache.moduleNames)
    for name in pairs(SDT.modules) do
        tinsert(SDT.cache.moduleNames, name)
    end
    tsort(SDT.cache.moduleNames)
end

-------------------------------------------------
-- Create Addon List
-------------------------------------------------
local function CreateAddonList()
    if SDT.cache.addonList then
        wipe(SDT.cache.addonList)
    else
        SDT.cache.addonList = {}
    end
    local addOnCount = GetNumAddOns()
    local counter = 1
    for i = 1, addOnCount do
        local name, title, _, loadable, reason = GetAddOnInfo(i)
        if loadable or reason == "DEMAND_LOADED" then
            SDT.cache.addonList[counter] = {name = name, title = title, index = i}
            counter = counter + 1
        end
    end
end

-------------------------------------------------
-- Loader to restore bars on addon load
-------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self, event, arg)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    CreateModuleList()
    CreateAddonList()

    -- Update modules to be safe
    SDT:UpdateAllModules()

    -- Init print
    Delay(2, function()
        SDT.Print(format(L["Loaded. Total modules: %d"], #SDT.cache.moduleNames))
    end)
end)

local function SlashHelp()
    SDT.Print(L["|cffffff00--[Options]--|r"])
    SDT.Print(L["Lock/Unlock: |cff8888ff/sdt lock|r"])
    SDT.Print(L["Width: |cff8888ff/sdt width <barName> <newWidth>|r"])
    SDT.Print(L["Height: |cff8888ff/sdt height <barName> <newHeight>|r"])
    SDT.Print(L["Scale: |cff8888ff/sdt scale <barName> <newScale>|r"])
    SDT.Print(L["Settings: |cff8888ff/sdt config|r"])
    SDT.Print(L["Version: |cff8888ff/sdt version|r"])
end

local function BarAdjustments(adj, bar, num)
    -- Make sure we have all of our values
    if not adj or not bar or not num then
        SDT.Print(format(L["Usage: /sdt %s <barName> <value>"], adj))
        SlashHelp()
        return
    end

    -- Check custom name if supplied instead of the bar key
    if not SDT.profileBars[bar] then
        local resolved = nil
        for barItem, settings in pairs(SDT.profileBars) do
            if stringlower(settings.name) == stringlower(bar) then
                resolved = barItem
                break
            end
        end
        if not resolved then
            SDT.Print(L["Invalid panel name supplied. Valid panel names are:"])
            for j,k in pairs(SDT.profileBars) do
                SDT.Print("- ", tostring(j), "("..tostring(k.name)..")")
            end
            return
        end
        bar = resolved
    end

    -- Validate the number supplied
    if type(num) ~= "number" then
        SDT.Print(L["A valid numeric value for the adjustment must be specified."])
        SlashHelp()
        return
    end

    -- Further validate the value is within parameters, then make the adjustment
    if adj == "width" then
        if num >= 100 and num <= mathfloor(GetScreenWidth()) then
            SDT.profileBars[bar].width = num
            if SDT.UI and SDT.UI.widthSlider then SDT.UI.widthSlider:SetValue(num) end
            if SDT.UI and SDT.UI.widthBox then SDT.UI.widthBox:SetText(num) end
            SDT:RebuildSlots(SDT.bars[bar])
        else
            SDT.Print(L["Invalid panel width specified."])
        end
    elseif adj == "height" then
        if num >= 16 and num <= 128 then
            SDT.profileBars[bar].height = num
            if SDT.UI and SDT.UI.heightSlider then SDT.UI.heightSlider:SetValue(num) end
            if SDT.UI and SDT.UI.heightBox then SDT.UI.heightBox:SetText(num) end
            SDT:RebuildSlots(SDT.bars[bar])
        else
            SDT.Print(L["Invalid panel height specified."])
        end
    elseif adj == "scale" then
        if num >= 50 and num <= 500 then
            SDT.profileBars[bar].scale = num
            if SDT.UI and SDT.UI.scaleSlider then SDT.UI.scaleSlider:SetValue(num) end
            if SDT.UI and SDT.UI.scaleBox then SDT.UI.scaleBox:SetText(num) end
            SDT.bars[bar]:SetScale(num / 100)
        else
            SDT.Print(L["Invalid panel scale specified."])
        end
    else
        SDT.Print(L["Invalid adjustment type specified."])
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
        Settings.OpenToCategory(SDT.SettingsPanel.ID)
    elseif command == "lock" then
        SDT.SDTDB_CharDB.settings.locked = not SDT.SDTDB_CharDB.settings.locked
        if SDT.UI and SDT.UI.lockCheckbox then
            SDT.UI.lockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.locked)
        end
        SDT.Print(L["SDT panels are now: "], SDT.SDTDB_CharDB.settings.locked and L["|cffff0000LOCKED|r"] or L["|cff00ff00UNLOCKED|r"])
    elseif command == "width" or command == "height" or command == "scale" then
        BarAdjustments(command, bar, num)
    elseif command == "update" then
        SDT:UpdateAllModules()
    elseif command == "version" then
        SDT.Print(format(L["Simple Datatexts Version: |cff8888ff%s|r"], tostring(SDT.cache.version)))
    else
        SlashHelp()
    end
end
