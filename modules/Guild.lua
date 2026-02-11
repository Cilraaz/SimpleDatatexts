-- modules/Guild.lua
-- Guild list datatext imported from Ara_Broker_Guild_Friends for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L
local LDB = SDT.LDB

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format
local strfind     = string.find
local strlenutf8  = strlenutf8
local strsplit    = string.split
local strsub      = string.sub
local strtrim     = string.trim

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Guild"

----------------------------------------------------
-- LDB Object Local
----------------------------------------------------
local ara = LDB:GetDataObjectByName("|cFFFFB366Ara|r Guild")

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "range", L["Max Guild Name Length"], "maxGuildNameLength", 12, 1, 50, 1)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Module wrapper for SDT
----------------------------------------------------
function mod.Create(slotFrame)
    if not ara then
        SDT.Print(L["Ara Guild LDB object not found! SDT Guild datatext disabled."])
        return
    end
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)

    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end

    ----------------------------------------------------
    -- Shorten Ara's text, if guild name is too long
    ----------------------------------------------------
    local function shortenText(txt)
        local colonPos = strfind(txt, ":")
        if not colonPos then
            return txt
        end

        local left = strsub(txt, 1, colonPos - 1)
        local right = strsub(txt, colonPos + 1)
        right = strtrim(right)

        local maxLen = SDT:GetModuleSetting(moduleName, "maxGuildNameLength", 12)
        if strlenutf8(left) > maxLen + 3 then
            left = strsub(left, 1, maxLen) .. "…"
        end

        return format("%s: %s", left, right)
    end

    ----------------------------------------------------
    -- Update function simply reflects Ara's text
    ----------------------------------------------------
    local function Update()
        local txt = ara.text or ""
        txt = shortenText(txt)
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, txt))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = Update
    SDT.guildFrame = f

    ----------------------------------------------------
    -- Tooltip from Ara
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        if ara.OnEnter then ara.OnEnter(self) end
    end)
    slotFrame:SetScript("OnLeave", function(self)
        if ara.OnLeave then ara.OnLeave(self) end
    end)

    ----------------------------------------------------
    -- Click from Ara
    ----------------------------------------------------
    slotFrame:RegisterForClicks("AnyUp")
    slotFrame:SetScript("OnClick", function(self, button)
        if ara.OnClick then ara.OnClick(self, button) end
    end)

    Update()

    return f
end

----------------------------------------------------
-- Update the frame when an Ara option changes
----------------------------------------------------
function SDT:UpdateGuild()
    if self.guildFrame then
        self.guildFrame:Update()
    end
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
