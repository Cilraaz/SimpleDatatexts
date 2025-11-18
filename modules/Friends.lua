-- modules/Friends.lua
-- Friends list datatext imported from Ara_Broker_Guild_Friends for Simple DataTexts (SDT)
local addonName, addon = ...
local LDB = LibStub("LibDataBroker-1.1")

local mod = {}

-- Find Ara's Friends LDB object
local ara = LDB:GetDataObjectByName("|cFFFFB366Ara|r Friends")

if not ara then
    print("|cffff0000[SDT]|r Ara Friends LDB object not found!")
    return
end

----------------------------------------------------
-- Module wrapper for SDT
----------------------------------------------------
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
    -- Update function simply reflects Ara's text
    ----------------------------------------------------
    local function Update()
        text:SetFormattedText("|c%s%s|r", addon:GetTagColor(), ara.text or "")
    end
    f.Update = Update

    ----------------------------------------------------
    -- Tooltip: forward to Ara
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        if ara.OnEnter then
            ara.OnEnter(self)
        end
    end)
    slotFrame:SetScript("OnLeave", function(self)
        if ara.OnLeave then
            ara.OnLeave(self)
        end
    end)

    ----------------------------------------------------
    -- Click: forward to Ara
    ----------------------------------------------------
    slotFrame:RegisterForClicks("AnyUp")
    slotFrame:SetScript("OnClick", function(self, button)
        if ara.OnClick then
            ara.OnClick(self, button)
        end
    end)

    -- Initial update
    Update()

    return f
end

addon:RegisterDataText("Friends", mod)

return mod
