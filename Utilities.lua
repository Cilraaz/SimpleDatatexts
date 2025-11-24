-- Utility Functions

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
local GetScreenWidth            = GetScreenWidth
local GetScreenHeight           = GetScreenHeight
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
-- Build Our Addon Table and Cache
-------------------------------------------------
SDT.modules = SDT.modules or {}
SDT.bars = SDT.bars or {}
SimpleDatatexts = SDT

SDT.cache = {}
SDT.cache.playerName = UnitName("player")
SDT.cache.playerNameLower = SDT.cache.playerName:lower()
SDT.cache.playerClass = select(2, UnitClass("player"))
SDT.cache.playerRealm = GetRealmName():gsub("[^%w]", ""):lower()
SDT.cache.charKey = SDT.cache.playerNameLower.."-"..SDT.cache.playerRealm
local colors = { GetClassColor(SDT.cache.playerClass):GetRGB() }
SDT.cache.colorR = colors[1]
SDT.cache.colorG = colors[2]
SDT.cache.colorB = colors[3]
SDT.cache.colorHex = GetClassColor(SDT.cache.playerClass):GenerateHexColor()
SDT.cache.version = GetAddOnMetadata(addonName, "Version") or "not defined"
SDT.cache.moduleNames = {}

-------------------------------------------------
-- Utility: Apply Chosen Font
-------------------------------------------------
function SDT:ApplyFont()
    local fontPath = LSM:Fetch("font", SDT.SDTDB_CharDB.settings.font) or STANDARD_TEXT_FONT
    local fontSize = SDT.SDTDB_CharDB.settings.fontSize or 12

    for _, bar in pairs(SDT.bars) do
        for k, slot in pairs(bar.slots) do
            if slot.text then
                slot.text:SetFont(fontPath, fontSize, "")
            end
            if slot.moduleFrame and slot.moduleFrame.text and slot.moduleFrame.text.SetFont then
                slot.moduleFrame.text:SetFont(fontPath, fontSize, "")
            end
        end
    end
end

-------------------------------------------------
-- Utility: Color Text
-------------------------------------------------
function SDT:ColorText(text)
    local color = SDT:GetTagColor()
    return "|c"..color..text.."|r"
end

-------------------------------------------------
-- Utility: Format Percentage
-------------------------------------------------
function SDT:FindBestAnchorPoint(frame)
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
-- Utility: Format Percentage
-------------------------------------------------
function SDT:FormatPercent(v)
    return string.format("%.2f%%", v)
end

-------------------------------------------------
-- Utility: Get Character Key
-------------------------------------------------
function SDT:GetCharKey()
    return SDT.cache.charKey
end

-------------------------------------------------
-- Utility: Get Tag Color
-------------------------------------------------
function SDT:GetTagColor()
    if SDT.SDTDB_CharDB.settings.useCustomColor then
        local color = SDT.SDTDB_CharDB.settings.customColorHex:gsub("#", "")
        return "ff"..color
    elseif SDT.SDTDB_CharDB.settings.useClassColor then
        return SDT.cache.colorHex
    end
    return "ffffffff"
end

-------------------------------------------------
-- Utility: Handle Menu List
-------------------------------------------------
function SDT:HandleMenuList(root, menuList, submenu, depth)
    if submenu then root = submenu end

    for _, list in next, menuList do
        local previous
		if list.isTitle then
			root:CreateTitle(list.text)
		elseif list.func or list.hasArrow then
			local name = list.text or ('test'..depth)

			local func = (list.arg1 or list.arg2) and (function() list.func(nil, list.arg1, list.arg2) end) or list.func
			local checked = list.checked and (not list.notCheckable and function() return list.checked(list) end or E.noop)
			if checked then
				previous = root:CreateCheckbox(list.text or name, checked, func)
			else
				previous = root:CreateButton(list.text or name, func)
			end
		end

		if list.menuList then -- loop it
			HandleMenuList(root, list.menuList, list.hasArrow and previous, depth + 1)
		end
	end
end

-------------------------------------------------
-- Utility: find next free bar ID
-------------------------------------------------
function SDT:NextBarID()
    local n = 1
    while SDT.profileBars["SDT_Bar" .. n] do
        n = n + 1
    end
    return n
end

-------------------------------------------------
-- Utility: Print function
-------------------------------------------------
function SDT.Print(...)
    print("[|cFFFF6600SDT|r]", ...)
end

-------------------------------------------------
-- Module Registration
-------------------------------------------------
function SDT:RegisterDataText(name, module)
    SDT.modules[name] = module
end

-------------------------------------------------
-- Utility: SetActiveProfile
-------------------------------------------------
function SDT:SetActiveProfile(profileName)
end

-------------------------------------------------
-- Utility: SetCVar
-------------------------------------------------
function SDT:SetCVar(cvar, value)
    local valStr = ((type(value) == "boolean") and (value and '1' or '0')) or tostring(value)
    if GetCVar(cvar) ~= valStr then
        SetCVar(cvar, valStr)
    end
end

-------------------------------------------------
-- Utility: Functions for Profile Handling
-------------------------------------------------
function SDT:GetAllProfileKeys()
    local keys = {}
    for k in pairs(SDTDB) do
        if k ~= "defaults" then
            table.insert(keys, k)
        end
    end
    return keys
end

function SDT:CopyProfile(fromKey, toKey)
    SDTDB[toKey] = CopyTable(SDTDB[fromKey])
    print("Profile copied from "..fromKey.." to "..toKey)
end

function SDT:DeleteProfile(key)
    if SDTDB[key] then
        SDTDB[key] = nil
        print("Profile "..key.." deleted")
        -- Ensure the current charDB points somewhere valid
        if SDT:getCharKey() == key then
            SDT.SDTDB_CharDB = SDTDB[SDT:getCharKey()] or CopyTable(charDefaultsTable)
        end
    end
end

function SDT:ResetProfile(key)
    SDTDB[key] = CopyTable(charDefaultsTable)
    print("Profile "..key.." reset to defaults")
end
