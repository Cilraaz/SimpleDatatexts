-- modules/Mail.lua
-- Mail datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- WoW API locals
----------------------------------------------------
local HasNewMail = HasNewMail
local GetLatestThreeSenders = GetLatestThreeSenders
local HAVE_MAIL_FROM = HAVE_MAIL_FROM
local MAIL_LABEL = MAIL_LABEL

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
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        local mailText = HasNewMail() and L["New Mail"] or L["No Mail"]
        text:SetText(SDT:ColorText(mailText))
    end

    f.Update = function() OnEvent(f) end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("MAIL_INBOX_UPDATE")
    f:RegisterEvent("UPDATE_PENDING_MAIL")
    f:RegisterEvent("MAIL_CLOSED")
    f:RegisterEvent("MAIL_SHOW")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()

        local senders = { GetLatestThreeSenders() }
        if next(senders) then
            local header = HasNewMail() and HAVE_MAIL_FROM or MAIL_LABEL
            GameTooltip:AddLine(header, 1, 1, 1)
            GameTooltip:AddLine(" ")

            for _, sender in pairs(senders) do
                GameTooltip:AddLine(sender)
            end

            GameTooltip:Show()
        end
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    OnEvent(f)

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Mail", mod)

return mod
