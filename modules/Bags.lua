-- modules/Bags.lua
-- Bags datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame                = CreateFrame
local GameTooltip                = GameTooltip
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink       = GetInventoryItemLink
local GetInventoryItemQuality    = GetInventoryItemQuality
local GetInventoryItemTexture    = GetInventoryItemTexture
local ToggleAllBags              = ToggleAllBags
local ContainerIDToInventoryID   = C_Container.ContainerIDToInventoryID
local GetBagName                 = C_Container.GetBagName
local GetContainerNumFreeSlots   = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots       = C_Container.GetContainerNumSlots

----------------------------------------------------
-- Useful Tables
----------------------------------------------------
local bagData = {}

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
        return 1, 0.1 + 0.9 * t, 0.1
    else
        local t = (p - 0.5) / 0.5
        return 1 - 0.9 * t, 1, 0.1
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
        bagData = {}

        for i = 0, NUM_BAG_SLOTS do
            local freeSlots, bagType = GetContainerNumFreeSlots(i)
            local totalSlots = GetContainerNumSlots(i)
            bagData[i] = { free = freeSlots, total = totalSlots, bagType = bagType }

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

        local textString = L["Bags"] .. ": " .. (totalNormal - freeNormal) .. "/" .. totalNormal
        text:SetText(SDT:ColorText(textString))
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
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            _G.ToggleAllBags()
        end
    end)

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(L["Bags"])
        GameTooltip:AddLine(" ")

        for i = 0, NUM_BAG_SLOTS do
            local bagName = GetBagName(i)
            if bagName then
                local numSlots = bagData[i].total
                local freeSlots, bagType = bagData[i].free, bagData[i].bagType
                local usedSlots = numSlots - freeSlots

                local r1, g1, b1 = 1, 1, 1
                local r2, g2, b2 = ColorGradient(usedSlots / numSlots)

                if i > 0 then
                    local id = ContainerIDToInventoryID(i)
                    local icon = GetInventoryItemTexture('player', id)
                    local quality = GetInventoryItemQuality('player', id) or 1
                    r1, g1, b1 = GetItemQualityColor(quality)
                    GameTooltip:AddDoubleLine(format(iconString, icon or "", bagName), format('%d / %d', usedSlots, numSlots), r1, g1, b1, r2, g2, b2)
                else
                    GameTooltip:AddDoubleLine(bagName, format('%d / %d', usedSlots, numSlots), r1, g1, b1, r2, g2, b2)
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
SDT:RegisterDataText("Bags", mod)

return mod
