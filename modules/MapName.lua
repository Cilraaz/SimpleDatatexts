-- modules/MapName.lua
-- Map Name datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local C_Map = C_Map
local GetZoneText = GetZoneText
local GetSubZoneText = GetSubZoneText
local GetMinimapZoneText = GetMinimapZoneText

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Map Name"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "select", L["Display Format"], "displayFormat", 1, {
        [1] = L["Zone Name"],
        [2] = L["Subzone Name"],
        [3] = L["Zone - Subzone"],
        [4] = L["Zone / Subzone (Two Lines)"],
        [5] = L["Minimap Zone"],
    })

    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Zone on Tooltip"], "showZoneTooltip", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Coordinates on Tooltip"], "showCoordinates", true)

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

    local currentZone = ""
    local currentSubzone = ""
    local currentMapID = 0

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateMapName()
        local zone = GetZoneText() or ""
        local subzone = GetSubZoneText() or ""
        local minimapZone = GetMinimapZoneText() or ""
        
        currentZone = zone
        currentSubzone = subzone
        currentMapID = C_Map.GetBestMapForUnit("player") or 0

        local displayFormat = SDT:GetModuleSetting(moduleName, "displayFormat", 1)
        local textString = ""

        if displayFormat == 1 then
            -- Zone Name
            textString = zone
        elseif displayFormat == 2 then
            -- Subzone Name
            textString = subzone ~= "" and subzone or zone
        elseif displayFormat == 3 then
            -- Zone - Subzone
            if subzone ~= "" and subzone ~= zone then
                textString = zone .. " - " .. subzone
            else
                textString = zone
            end
        elseif displayFormat == 4 then
            -- Zone / Subzone (Two Lines)
            if subzone ~= "" and subzone ~= zone then
                textString = zone .. "\n" .. subzone
            else
                textString = zone
            end
        elseif displayFormat == 5 then
            -- Minimap Zone
            textString = minimapZone
        end

        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateMapName

    ----------------------------------------------------
    -- Tooltip Handler
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local showZoneTooltip = SDT:GetModuleSetting(moduleName, "showZoneTooltip", true)
        local showCoordinates = SDT:GetModuleSetting(moduleName, "showCoordinates", true)

        if not showZoneTooltip then return end

        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        SDT.Tooltip:SetOwner(self, anchor)
        SDT.Tooltip:ClearLines()

        if not SDT.db.profile.hideModuleTitle then
            SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, L["Map Name"])
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end

        -- Zone info
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Zone:"], currentZone, 1, 0.82, 0, 1, 1, 1)
        
        if currentSubzone ~= "" and currentSubzone ~= currentZone then
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Subzone:"], currentSubzone, 1, 0.82, 0, 1, 1, 1)
        end

        -- Coordinates
        if showCoordinates then
            local mapID = C_Map.GetBestMapForUnit("player")
            if mapID then
                local position = C_Map.GetPlayerMapPosition(mapID, "player")
                if position then
                    local x, y = position:GetXY()
                    if x and y then
                        local coordString = string.format("%.1f, %.1f", x * 100, y * 100)
                        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Coordinates:"], coordString, 1, 0.82, 0, 1, 1, 1)
                    end
                end
            end
        end

        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "ZONE_CHANGED"
        or event == "ZONE_CHANGED_INDOORS"
        or event == "ZONE_CHANGED_NEW_AREA" then
            UpdateMapName()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("ZONE_CHANGED")
    f:RegisterEvent("ZONE_CHANGED_INDOORS")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    UpdateMapName()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod