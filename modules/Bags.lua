-- modules/Bags.lua
-- Bags datatext adapted from ElvUI for Simple DataTexts (SDT)
local addonName, addon = ...
local SDTC = addon.cache

local mod = {}

----------------------------------------------------
-- Utility
----------------------------------------------------
local NUM_BAG_SLOTS = NUM_BAG_SLOTS + (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and 1 or 0)
local REAGENT_CONTAINER = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and Enum.BagIndex.ReagentBag or math.huge

local function ColorGradient(p)
    if not p then return 1, 1, 1 end
    if p <= 0 then return 1, 0.1, 0.1 end
    if p >= 1 then return 0.1, 1, 0.1 end
    if p < 0.5 then
        local t = p / 0.5
        return 1, 0.1 + (1 - 0.1) * t, 0.1
    else
        local t = (p - 0.5) / 0.5
        return 1 - (1 - 0.1) * t, 1, 0.1
    end
end

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

    local displayString = ""
    local iconString = '|T%s:14:14:0:0:64:64:4:60:4:60|t  %s'

    ----------------------------------------------------
    -- Update Logic
    ----------------------------------------------------
    local function UpdateBags()
        local freeNormal, totalNormal, freeReagent, totalReagent = 0, 0, 0, 0

        for i = 0, NUM_BAG_SLOTS do
            local freeSlots, bagType = C_Container.GetContainerNumFreeSlots(i)
            local totalSlots = C_Container.GetContainerNumSlots(i)

            if not bagType or bagType == 0 then
                if i == REAGENT_CONTAINER then
                    totalReagent = totalReagent + totalSlots
                    freeReagent = freeReagent + freeSlots
                else
                    totalNormal = totalNormal + totalSlots
                    freeNormal = freeNormal + freeSlots
                end
            end
        end

        text:SetFormattedText("|c%sBags: %d/%d|r", addon:GetTagColor(), totalNormal - freeNormal, totalNormal)
    end
    f.Update = UpdateBags

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        UpdateBags()
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("BAG_UPDATE")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function()
        _G.ToggleAllBags()
    end)

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:ClearLines()
        GameTooltip:AddLine("Bags")
        GameTooltip:AddLine(" ")

        for i = 0, NUM_BAG_SLOTS do
            local bagName = C_Container.GetBagName(i)
            if bagName then
                local numSlots = C_Container.GetContainerNumSlots(i)
                local freeSlots, bagType = C_Container.GetContainerNumFreeSlots(i)
                local usedSlots = numSlots - freeSlots

                local r1, g1, b1 = 1, 1, 1
                local r2, g2, b2 = ColorGradient(usedSlots / numSlots)

                if i > 0 then
                    local id = C_Container.ContainerIDToInventoryID(i)
                    local icon = GetInventoryItemTexture('player', id)
                    local quality = GetInventoryItemQuality('player', id) or 1
                    r1, g1, b1 = GetItemQualityColor(quality)
                    GameTooltip:AddDoubleLine(string.format(iconString, icon or "", bagName), string.format('%d / %d', usedSlots, numSlots), r1, g1, b1, r2, g2, b2)
                else
                    GameTooltip:AddDoubleLine(bagName, string.format('%d / %d', usedSlots, numSlots), r1, g1, b1, r2, g2, b2)
                end
            end
        end

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateBags()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
addon:RegisterDataText("Bags", mod)

return mod
