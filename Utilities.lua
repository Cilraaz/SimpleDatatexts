-- Utility Functions

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
local print            = print
local tonumber         = tonumber
local tostring         = tostring
local wipe             = table.wipe

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CopyTable                 = CopyTable
local GetAddOnMetadata          = C_AddOns.GetAddOnMetadata
local GetClassColor             = C_ClassColor.GetClassColor
local GetRealmName              = GetRealmName
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
-- Utility: No Operation Function
-------------------------------------------------
local noop = function() end

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
-- Utility: Find Best Anchor Point
-------------------------------------------------
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
            local checked = list.checked and (not list.notCheckable and function() return list.checked(list) end or noop)
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
-- Utility: Find next free bar ID
-------------------------------------------------
function SDT:NextBarID()
    local n = 1
    while SDT.profileBars["SDT_Bar" .. n] do
        n = n + 1
    end
    return n
end

-------------------------------------------------
-- Utility: Print Function
-------------------------------------------------
function SDT.Print(...)
    print("[|cFFFF6600SDT|r]", ...)
end

-------------------------------------------------
-- Utility: Profile Activate
-------------------------------------------------
function SDT:ProfileActivate(profileName, spec)
    SDT.SDTDB_CharDB.chosenProfile[spec] = profileName
    SDT.activeProfile = profileName

    for bar in pairs(SDT.bars) do
        SDT.bars[bar]:Hide()
    end
    wipe(SDT.bars)

    SDT.profileBars = SDTDB.profiles[profileName].bars

    for barName, barData in pairs(SDT.profileBars) do
        local id = tonumber(barName:match("SDT_Bar(%d+)"))
        local newBar = SDT:CreateDataBar(id, barData.numSlots)
        SDT.bars[barName] = newBar
        SDT.bars[barName]:Show()
    end

    SDT:RefreshProfileList()
    SDT:UpdateActiveProfile(profileName, spec)

    SDT:UpdateAllModules()
end

-------------------------------------------------
-- Utility: Profile Copy
-------------------------------------------------
function SDT:ProfileCopy(profileName)
    if not profileName or profileName == "" then return end
    if profileName == SDT.activeProfile then
        StaticPopup_Show("SDT_CANT_COPY_ACTIVE_PROFILE")
        return
    end
    local confirmString = format(L["Are you sure you want to overwrite your\n'%s' profile?\nThis action cannot be undone."], SDT.activeProfile)
    StaticPopupDialogs.SDT_CONFIRM_COPY_PROFILE.text = confirmString
    StaticPopup_Show("SDT_CONFIRM_COPY_PROFILE", nil, nil, profileName)
end

StaticPopupDialogs["SDT_CANT_COPY_ACTIVE_PROFILE"] = {
    text = L["You cannot copy the active profile onto itself. Please change your active profile first."],
    button1 = L["Ok"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}
StaticPopupDialogs["SDT_CONFIRM_COPY_PROFILE"] = {
    text = L["Are you sure you want to overwrite your\n'%s' profile?\nThis action cannot be undone."],
    button1 = L["Yes"],
    button2 = L["No"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnAccept = function(self, profileName)
        local src = SDTDB.profiles[profileName]
        if not src then
            SDT.Print(L["Invalid source profile specified."])
            SDT:RefreshProfileList()
            return
        end
        local newProfile = CopyTable(src)
        for bar in pairs(SDT.bars) do
            SDT.bars[bar]:Hide()
        end
        wipe(SDTDB.profiles[SDT.activeProfile])
        SDTDB.profiles[SDT.activeProfile] = newProfile
        SDT.profileBars = SDTDB.profiles[SDT.activeProfile].bars
        for barName, barData in pairs(SDT.profileBars) do
            local id = tonumber(barName:match("SDT_Bar(%d+)"))
            local newBar = SDT:CreateDataBar(id, barData.numSlots)
            SDT.bars[barName] = newBar
            SDT.bars[barName]:Show()
        end
        SDT:RefreshProfileList()
        SDT:UpdateAllModules()
    end,
}

-------------------------------------------------
-- Utility: Profile Create
-------------------------------------------------
function SDT:ProfileCreate(profileName)
    SDTDB.profiles[profileName] = { bars = {} }
    SDT.profileBars = SDTDB.profiles[profileName].bars
    SDT:CreateDataBar(1, 3)
    SDT:ProfileActivate(profileName, "generic")
end

-------------------------------------------------
-- Utility: Profile Delete
-------------------------------------------------
function SDT:ProfileDelete(profileName)
    if profileName == "" then return end
    if SDT.activeProfile == profileName then
        StaticPopup_Show("SDT_CANT_DELETE_ACTIVE_PROFILE")
        return
    else
        StaticPopup_Show("SDT_CONFIRM_DELETE_PROFILE", nil, nil, profileName)
    end
end

StaticPopupDialogs["SDT_CANT_DELETE_ACTIVE_PROFILE"] = {
    text = L["You cannot delete the active profile. Please change your active profile first."],
    button1 = L["Ok"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}
StaticPopupDialogs["SDT_CONFIRM_DELETE_PROFILE"] = {
    text = L["Are you sure you want to delete this profile?\nThis action cannot be undone."],
    button1 = L["Yes"],
    button2 = L["No"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnAccept = function(self, profileName)
        SDTDB.profiles[profileName] = nil
        SDT:RefreshProfileList()
    end,
}

-------------------------------------------------
-- Module Registration
-------------------------------------------------
function SDT:RegisterDataText(name, module)
    SDT.modules[name] = module
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
