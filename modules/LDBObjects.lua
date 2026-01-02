-- modules/LDBObjects.lua
-- Datatexts for LDB objects not already handled by other modules
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L
local LDB = LibStub("LibDataBroker-1.1")

if not SDT.LDBDatatexts then SDT.LDBDatatexts = {} end

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format
local tinsert     = table.insert
local tsort       = table.sort

----------------------------------------------------
-- Helper Functions
----------------------------------------------------
local function ShouldSkipLDBObject(name)
    return name == "Ara Friends" -- Handled by Friends module
      or name == "Ara Guild"  -- Handled by Guild module
      or name == "CraftSimLDB" -- Only opens the CraftSim config settings
      or name == "ALL THE THINGS" -- Appears to do nothing
end

local function StripColorCodes(text)
    if not text then return nil end
    return tostring(text):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
end

----------------------------------------------------
-- Module wrapper for SDT
----------------------------------------------------
local function HandleLDBObject(name, obj)
    local cleanName = StripColorCodes(name)

    -- Skip objects already handled by other modules or those that are known to be "blank".
    if ShouldSkipLDBObject(cleanName) then
        return
    end

    local mod = {}

    function mod.Create(slotFrame)
        local f = CreateFrame("Frame", nil, slotFrame)
        f:SetAllPoints(slotFrame)

        local text = slotFrame.text
        if not text then
            text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            text:SetPoint("CENTER")
            slotFrame.text = text
        end

        ----------------------------------------------------
        -- Update function
        ----------------------------------------------------
        local function Update()
            local cleanObjText = obj.text and StripColorCodes(obj.text)
            local txt = ""
            if cleanName == "BugSack" then
                txt = cleanName .. ": " .. (cleanObjText or "")
            elseif cleanName == "WIM" then
                txt = cleanName .. (cleanObjText and (": " .. cleanObjText) or "")
            elseif cleanName == "Core Loot Manager" then
                txt = "CLM" .. (cleanObjText and (": " .. cleanObjText) or "")
            else
                txt = cleanObjText or cleanName or L["NO TEXT"]
            end
            text:SetText(SDT:ColorText(txt))
        end
        f.Update = Update
        SDT.LDBDatatexts[cleanName] = f

        ----------------------------------------------------
        -- Tooltip from LDB object
        ----------------------------------------------------
        slotFrame:EnableMouse(true)
        slotFrame:SetScript("OnEnter", function(self)
            if obj.OnTooltipShow then
                local anchor = SDT:FindBestAnchorPoint(self)
                GameTooltip:SetOwner(self, anchor)
                GameTooltip:ClearLines()
                obj.OnTooltipShow(GameTooltip)
                GameTooltip:Show()
            elseif obj.OnEnter then
                obj.OnEnter(self)
            end
        end)
        slotFrame:SetScript("OnLeave", function(self)
            if obj.OnLeave then obj.OnLeave(self) end
            GameTooltip:Hide()
        end)

        ----------------------------------------------------
        -- Click from LDB object
        ----------------------------------------------------
        slotFrame:RegisterForClicks("AnyUp")
        slotFrame:SetScript("OnClick", function(self, button)
            if obj.OnClick then obj.OnClick(self, button) end
        end)

        Update()

        return f
    end

    ----------------------------------------------------
    -- Register with SDT
    ----------------------------------------------------
    SDT:RegisterDataText(cleanName, mod)

    return mod
end

for name, obj in LDB:DataObjectIterator() do
    HandleLDBObject(name, obj)
end

LDB:RegisterCallback("LibDataBroker_DataObjectCreated", function(_, name, obj)
    local cleanName = StripColorCodes(name)
    -- Skip objects already handled by other modules or those that are known to be "blank".
    if ShouldSkipLDBObject(cleanName) then
        return
    end
    HandleLDBObject(name, obj)
    tinsert(SDT.cache.moduleNames, cleanName)
    tsort(SDT.cache.moduleNames)
    SDT:RebuildAllSlots()
end)

LDB:RegisterCallback("LibDataBroker_AttributeChanged", function(_, name, attr, val)
    if attr == "text" or attr == "value" then
        local cleanName = StripColorCodes(name)
        local dt = SDT.LDBDatatexts[cleanName]
        if dt and dt.Update then
            dt.Update()
        end
    end
end)
