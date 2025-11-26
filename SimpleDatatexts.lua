-- Simple DataTexts

----------------------------------------------------
-- Addon Locals
----------------------------------------------------
local addonName, SDT = ...

----------------------------------------------------
-- Library Instances
----------------------------------------------------
local LSM = LibStub("LibSharedMedia-3.0")

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
local CopyTable                 = CopyTable
local CreateFrame               = CreateFrame
local GetAddOnMetadata          = C_AddOns.GetAddOnMetadata
local GetClassColor             = C_ClassColor.GetClassColor
local GetRealmName              = GetRealmName
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
-- Movable Frame Helper
-------------------------------------------------
local function CreateMovableFrame(name)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")

    f:SetScript("OnDragStart", function(self)
        if not SDT.SDTDB_CharDB.settings.locked then
            self:StartMoving()
        end
    end)

    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
        if SDT.profileBars[self:GetName()] then
            SDT.profileBars[self:GetName()].point = { point = point, relativePoint = relativePoint, x = xOfs, y = yOfs }
        end
    end)

    return f
end

-------------------------------------------------
-- Create or Restore a Data Bar
-------------------------------------------------
function SDT:CreateDataBar(id, numSlots)
    local name = "SDT_Bar" .. id
    if not SDT.profileBars[name] then
        SDT.profileBars[name] = { numSlots = numSlots or 3, slots = {}, showBackground = true, showBorder = true, width = 300, height = 22, name = name }
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
            slot.text:SetText(assignedName or "(empty)")
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
            local point, relativeTo, relativePoint, xOfs, yOfs = bar:GetPoint()
            if SDT.profileBars[bar:GetName()] then
                SDT.profileBars[bar:GetName()].point = { point = point, relativePoint = relativePoint, x = xOfs, y = yOfs }
            end
        end)

        bar.slots[i] = slot
    end

    SDT:ApplyFont()
end

-------------------------------------------------
-- Rebuild Slots on All Bars
-------------------------------------------------
function SDT:RebuildAllSlots()
    for _, bar in pairs(SDT.profileBars) do
        SDT:RebuildSlots(bar)
    end
end

-------------------------------------------------
-- Update All Modules
-------------------------------------------------
function SDT:UpdateAllModules()
    for _, bar in pairs(SDT.bars) do
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
function SDT:ShowSlotDropdown(slot, bar)
    local function InitializeDropdown()
        local info = UIDropDownMenu_CreateInfo()
        info.notCheckable = true

        for _, moduleName in ipairs(SDT.cache.moduleNames) do
            info.text = moduleName
            info.func = function()
                SDT.profileBars[bar:GetName()].slots[slot.index] = moduleName
                SDT:RebuildSlots(bar)
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
-- Loader to restore bars on addon load
-------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self, event, arg)
    --if arg == addonName then
        CreateModuleList()

        -- Set our profile variable
        local profileName
        local dbInfo = SDTDB[SDT:GetCharKey()]
        if dbInfo.useSpecProfiles then
            local _, currentSpec = GetSpecializationInfo(GetSpecialization())
            profileName = dbInfo.chosenProfile[currentSpec]
        else
            profileName = dbInfo.chosenProfile.generic
        end
        SDT.profileBars = SDTDB.profiles[profileName].bars
        SDT.activeProfile = profileName

        -- If no bars exist, create our first bar
        if not next(SDT.profileBars) then
            SDT.profileBars["SDT_Bar1"] = { numSlots = 3, slots = {}, showBackground = true, showBorder = true }
        end

        -- Create our bars
        for barName, data in pairs(SDT.profileBars) do
            local id = tonumber(barName:match("SDT_Bar(%d+)") or "0")
            if id > 0 and not SDT.bars[barName] then
                SDT:CreateDataBar(id, data.numSlots)
            end
        end

        -- Update modules to be safe
        SDT:UpdateAllModules()
    --end
end)

local function SlashHelp()
    SDT.Print("|cffffff00--[Options]--|r")
    SDT.Print("Lock/Unlock: |cff8888ff/sdt lock|r")
    SDT.Print("Width: |cff8888ff/sdt width <barName> <newWidth>|r")
    SDT.Print("Height: |cff8888ff/sdt height <barName> <newHeight>|r")
    SDT.Print("Scale: |cff8888ff/sdt scale <barName> <newScale>|r")
    SDT.Print("Settings: |cff8888ff/sdt config|r")
    SDT.Print("Version: |cff8888ff/sdt version|r")
end

local function BarAdjustments(adj, bar, num)
    -- Make sure we have all of our values
    if not adj or not bar or not num then
        SDT.Print("Usage: /sdt " .. adj .. " <barName> <value>")
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
            SDT.Print("Invalid panel name supplied. Valid panel names are:")
            for j,k in pairs(SDT.profileBars) do
                SDT.Print("- ", tostring(j), "("..tostring(k.name)..")")
            end
            return
        end
        bar = resolved
    end

    -- Validate the number supplied
    if type(num) ~= "number" then
        SDT.Print("A valid numeric value for the adjustment must be specified.")
        SlashHelp()
        return
    end

    -- Further validate the value is within parameters, then make the adjustment
    if adj == "width" then
        if num >= 100 and num <= 800 then
            SDT.profileBars[bar].width = num
            widthSlider:SetValue(num)
            widthBox:SetText(num)
            SDT:RebuildSlots(SDT.bars[bar])
        else
            SDT.Print("Invalid panel width specified.")
        end
    elseif adj == "height" then
        if num >= 16 and num <= 128 then
            SDT.profileBars[bar].height = num
            heightSlider:SetValue(num)
            heightBox:SetText(num)
            SDT:RebuildSlots(SDT.bars[bar])
        else
            SDT.Print("Invalid panel height specified.")
        end
    elseif adj == "scale" then
        if num >= 50 and num <= 500 then
            SDT.profileBars[bar].scale = num
            scaleSlider:SetValue(num)
            scaleBox:SetText(num)
            SDT.bars[bar]:SetScale(num / 100)
        else
            SDT.Print("Invalid panel scale specified.")
        end
    else
        SDT.Print("Invalid adjustment type specified.")
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
        Settings.OpenToCategory(SDT.SettingsPanel.name)
    elseif command == "lock" then
        SDT.SDTDB_CharDB.settings.locked = not SDT.SDTDB_CharDB.settings.locked
        lockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.locked)
        SDT.Print("SDT panels are now: ", SDT.SDTDB_CharDB.settings.locked and "|cffff0000LOCKED|r" or "|cff00ff00UNLOCKED|r")
    elseif command == "width" or command == "height" or command == "scale" then
        BarAdjustments(command, bar, num)
    elseif command == "update" then
        SDT:UpdateAllModules()
    elseif command == "version" then
        SDT.Print("Simple Datatexts Version: |cff8888ff" ..tostring(SDT.cache.version) .. "|r")
    else
        SlashHelp()
    end
end
