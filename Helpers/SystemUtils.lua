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
-- Addon List Creation
----------------------------------------------------
local function CreateAddonList()
    SDT.cache.addonList = SDT.cache.addonList or {}
    wipe(SDT.cache.addonList)
    
    local GetAddOnInfo = C_AddOns.GetAddOnInfo
    local GetNumAddOns = C_AddOns.GetNumAddOns
    local addOnCount = GetNumAddOns()
    local counter = 1
    
    for i = 1, addOnCount do
        local name, title, _, loadable, reason = GetAddOnInfo(i)
        if loadable or reason == "DEMAND_LOADED" then
            SDT.cache.addonList[counter] = {
                name = name,
                title = title,
                index = i
            }
            counter = counter + 1
        end
    end
end

function SDT:GetAddonList()
    if not self.cache.addonList or #self.cache.addonList == 0 then
        CreateAddonList()
    end
    return self.cache.addonList
end

----------------------------------------------------
-- Get Character Key
----------------------------------------------------
function SDT:GetCharKey()
    return self.cache.charKey
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
-- CVar Management
----------------------------------------------------
function SDT:SetCVar(cvar, value)
    local valStr = ((type(value) == "boolean") and (value and '1' or '0')) or tostring(value)
    if GetCVar(cvar) ~= valStr then
        SetCVar(cvar, valStr)
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