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

    self.cache.validStratas = {
        BACKGROUND = true,
        LOW = true,
        MEDIUM = true,
        HIGH = true,
        DIALOG = true,
        FULLSCREEN = true,
        FULLSCREEN_DIALOG = true,
        TOOLTIP = true,
    }
end

function SDT:ScreenCache()
    local width, height = GetPhysicalScreenSize()
    self.cache.screenWidth = math.floor(GetScreenWidth())
    self.cache.screenHeight = math.floor(GetScreenHeight())
    self.cache.physicalWidth = width
    self.cache.physicalHeight = height
end

----------------------------------------------------
-- Create Local Tooltip
----------------------------------------------------
function SDT:CreateTooltip()
    -- If tooltip already exists, just update the fonts
    if self.Tooltip then
        local fontPath = SDT.LSM:Fetch("font", self.db.profile.tooltipFont)
        local outline = SDT.FontManager:GetTooltipOutline()
        local shadowEnabled = self.db.profile.tooltipShadowEnabled

        for i = 1, 30 do
            local leftName = "SimpleDatatextsTooltipTextLeft" .. i
            local rightName = "SimpleDatatextsTooltipTextRight" .. i
            local textLeft = _G[leftName]
            local textRight = _G[rightName]
            
            if textLeft then
                textLeft:SetFont(fontPath, self.db.profile.tooltipLineFontSize, outline)
                if shadowEnabled then
                    textLeft:SetShadowOffset(1, -1)
                    textLeft:SetShadowColor(0, 0, 0, 1)
                else
                    textLeft:SetShadowOffset(0, 0)
                end
            end
            if textRight then
                textRight:SetFont(fontPath, self.db.profile.tooltipLineFontSize, outline)
                if shadowEnabled then
                    textRight:SetShadowOffset(1, -1)
                    textRight:SetShadowColor(0, 0, 0, 1)
                else
                    textRight:SetShadowOffset(0, 0)
                end
            end
        end
        return
    end

    -- Create new tooltip
    local tooltip = CreateFrame("GameTooltip", "SimpleDatatextsTooltip", UIParent, "GameTooltipTemplate")
    
    -- Set default fonts for all lines
    local fontPath = SDT.LSM:Fetch("font", self.db.profile.tooltipFont) or STANDARD_TEXT_FONT
    local outline = SDT.FontManager:GetTooltipOutline()
    local shadowEnabled = self.db.profile.tooltipShadowEnabled

    for i = 1, 30 do
        local leftName = "SimpleDatatextsTooltipTextLeft" .. i
        local rightName = "SimpleDatatextsTooltipTextRight" .. i
        local textLeft = _G[leftName]
        local textRight = _G[rightName]
        
        if textLeft then
            textLeft:SetFont(fontPath, self.db.profile.tooltipLineFontSize, outline)
            if shadowEnabled then
                textLeft:SetShadowOffset(1, -1)
                textLeft:SetShadowColor(0, 0, 0, 1)
            else
                textLeft:SetShadowOffset(0, 0)
            end
        end
        if textRight then
            textRight:SetFont(fontPath, self.db.profile.tooltipLineFontSize, outline)
            if shadowEnabled then
                textRight:SetShadowOffset(1, -1)
                textRight:SetShadowColor(0, 0, 0, 1)
            else
                textRight:SetShadowOffset(0, 0)
            end
        end
    end
    
    SDT.Tooltip = tooltip
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
        SDT:ProfileFunction("CreateTooltip", function() self:CreateTooltip() end)
    else
        -- Build cache first
        self:BuildCache()

        -- Initialize database (handled in Database.lua)
        self:InitializeDatabase()

        -- Register slash commands
        self:RegisterSlashCommands()

        -- Create minimap button
        SDT.Icon:Register("SimpleDatatexts", obj, self.db.profile.minimap)

        -- Create local tooltip
        self:CreateTooltip()
    end
end

function SDT:OnEnable()
    -- DEBUG
    if SDT.db and SDT.db.profile and SDT.db.profile.debugMode then
        SDT:ProfileFunction("ScreenCache", function() self:ScreenCache() end)
        SDT:ProfileFunction("RegisterFonts", function() self.FontManager:RegisterFonts() end)
        SDT:ProfileFunction("CreateModuleList", function() self.ModuleRegistry:CreateModuleList() end)

        SDT:ProfileFunction("CreateBars", function()
            for barName, barData in pairs(self.db.profile.bars) do
                local id = tonumber(barName:match("SDT_Bar(%d+)"))
                if id and id > 0 then
                    self.BarManager:CreateDataBar(id, barData.numSlots)
                end
            end
        end)
    else
        -- Cache screen size
        self:ScreenCache()

        -- Register fonts
        self.FontManager:RegisterFonts()

        -- Create module list
        self.ModuleRegistry:CreateModuleList()

        -- Create bars from current profile
        self.BarManager:CreateFromProfile()
    end

    -- Per-spec profile switching
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function()
        self.ProfileManager:SwitchToSpecProfile()
    end)
    self.ProfileManager:SwitchToSpecProfile()

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
        self.BarManager:ToggleLock()
    elseif command == "toggle" then
        self.BarManager:ToggleAllPanels()
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
        self:Print("/sdt toggle - " .. L["Toggle All Panels"])
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