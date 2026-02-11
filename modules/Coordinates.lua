-- modules/Coordinates.lua
-- Coordinates datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local floor  = math.floor
local format = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame    = CreateFrame
local CreateVector2D = CreateVector2D
local GetBestMap     = C_Map.GetBestMapForUnit
local GetWorldPos    = C_Map.GetWorldPosFromMapPos
local UnitPosition   = UnitPosition

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local NOT_APPLICABLE = NOT_APPLICABLE

----------------------------------------------------
-- File Locals
----------------------------------------------------
local inRestrictedArea = false
local moduleName = "Coordinates"

----------------------------------------------------
-- Map Helpers
----------------------------------------------------
local mapRects, tempVec2D = {}, CreateVector2D(0, 0)
local function GetPlayerMapPos(mapID)
    tempVec2D.x, tempVec2D.y = UnitPosition("player")
    if not tempVec2D.x then return end

    local mapRect = mapRects[mapID]
    if not mapRect then
        local _, pos1 = GetWorldPos(mapID, CreateVector2D(0, 0))
        local _, pos2 = GetWorldPos(mapID, CreateVector2D(1, 1))
        if not pos1 or not pos2 then return end

        mapRect = {pos1, pos2}
        mapRect[2]:Subtract(mapRect[1])
        mapRects[mapID] = mapRect
    end
    tempVec2D:Subtract(mapRect[1])

    return (tempVec2D.y/mapRect[2].y), (tempVec2D.x/mapRect[2].x)
end

local function mathround(num, idp)
    if type(num) ~= "number" then return end
    if idp and idp > 0 then
        local mult = 10 ^ idp
        return floor(num * mult + 0.5) / mult
    end

    return floor(num + 0.5)
end

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
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

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateCoordinates()
        local mapID = GetBestMap("player")
        local x, y
        if mapID then
            x, y = GetPlayerMapPos(mapID)
        end

        local xText, yText
        local textString
        if x and y then
            xText = mathround(100 * x, 2)
            yText = mathround(100 * y, 2)
            textString = format("%.2f, %.2f", xText, yText)
        else
            textString = NOT_APPLICABLE
        end
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateCoordinates

    local updateThrottle = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        updateThrottle = updateThrottle + elapsed
        if updateThrottle > 0.2 then
            UpdateCoordinates()
            updateThrottle = 0
        end
    end)

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "LOADING_SCREEN_DISABLED"
        or event == "ZONE_CHANGED"
        or event == "ZONE_CHANGED_INDOORS"
        or event == "ZONE_CHANGED_NEW_AREA" then
            UpdateCoordinates()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("LOADING_SCREEN_DISABLED")
    f:RegisterEvent("ZONE_CHANGED")
    f:RegisterEvent("ZONE_CHANGED_INDOORS")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            if not InCombatLockdown() then
                _G.ToggleFrame(_G.WorldMapFrame)
	        end
        end
    end)

    UpdateCoordinates()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
