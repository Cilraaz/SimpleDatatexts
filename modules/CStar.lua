-- modules/Intellect.lua
-- Intellect datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local COLLAPSING_STAR = 1221150
local VOID_META = 1217607

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Collapsing Star"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Short Label"], "showShortLabel", false)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end

    if not SDTC.DDH then SDTC.DDH = {} end
    SDTC.DDH.CStarCount = 0
    SDTC.DDH.priorMetaStatus = false

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateCStars(reset)
        if reset then
            SDTC.DDH.CStarCount = 0
        else
            SDTC.DDH.CStarCount = SDTC.DDH.CStarCount + 1
        end
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local showShortLabel = SDT:GetModuleSetting(moduleName, "showShortLabel", false)
        local textString = (showLabel and (showShortLabel and L["CStar"] or L["Collapsing Star"]) .. ": " or "") .. SDTC.DDH.CStarCount
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateCStars

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" or
           event == "PLAYER_REGEN_DISABLED" then
            SDT:Print("Collapsing Star Counter Reset (event: " .. event .. ")")
            UpdateCStars(true)
        elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            local unit, castGUID, spellID = ...
            if type(castGUID) == "number" then spellID = castGUID end
            if unit == "player" and spellID == COLLAPSING_STAR then
                UpdateCStars(false)
            end
        elseif event == "UNIT_AURA" then
            local metaStatus = C_UnitAuras.GetPlayerAuraBySpellID(VOID_META) ~= nil
            local before = SDTC.DDH.priorMetaStatus
            SDTC.DDH.priorMetaStatus = metaStatus
            if not before and metaStatus then
                SDT:Print("Collapsing Star Counter Reset (meta)")
                UpdateCStars(true)
            end
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_REGEN_DISABLED")
    f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    f:RegisterEvent("UNIT_AURA")

    UpdateCStars(true)

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
