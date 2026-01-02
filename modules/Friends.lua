-- modules/Friends.lua
-- Friends list datatext imported from Ara_Broker_Guild_Friends for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L
local LDB = LibStub("LibDataBroker-1.1")

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format

----------------------------------------------------
-- LDB Object Local
----------------------------------------------------
local ara = LDB:GetDataObjectByName("|cFFFFB366Ara|r Friends")

----------------------------------------------------
-- Module wrapper for SDT
----------------------------------------------------
function mod.Create(slotFrame)
    if not ara then
        SDT.Print(L["Ara Friends LDB object not found! SDT Friends datatext disabled."])
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
    -- Update function simply reflects Ara's text
    ----------------------------------------------------
    local function Update()
        local txt = ara.text or ""
        text:SetText(SDT:ColorText(txt))
    end
    f.Update = Update
    SDT.friendFrame = f

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
function SDT:UpdateFriends()
    if self.friendFrame then
        self.friendFrame:Update()
    end
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Friends", mod)

return mod
