-- modules/Durability.lua
-- Durability datatext adapted ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = string.format
local min    = math.min
local pairs  = pairs
local wipe   = table.wipe

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GameTooltip                = GameTooltip
local GetCoinTextureString       = GetCoinTextureString
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItem           = C_TooltipInfo.GetInventoryItem
local GetInventoryItemLink       = GetInventoryItemLink
local GetInventoryItemTexture    = GetInventoryItemTexture
local GetRepairAllCost           = GetRepairAllCost
local InCombatLockdown           = InCombatLockdown
local MerchantFrame              = MerchantFrame
local ToggleCharacter            = ToggleCharacter

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local DURABILITY  = DURABILITY
local REPAIR_COST = REPAIR_COST
local UNKNOWN     = UNKNOWN

----------------------------------------------------
-- Inventory Slots
----------------------------------------------------
local slots = {
    [1]  = _G.INVTYPE_HEAD,
    [3]  = _G.INVTYPE_SHOULDER,
    [5]  = _G.INVTYPE_CHEST,
    [6]  = _G.INVTYPE_WAIST,
    [7]  = _G.INVTYPE_LEGS,
    [8]  = _G.INVTYPE_FEET,
    [9]  = _G.INVTYPE_WRIST,
    [10] = _G.INVTYPE_HAND,
    [16] = _G.INVTYPE_WEAPONMAINHAND,
    [17] = _G.INVTYPE_WEAPONOFFHAND,
    [18] = _G.INVTYPE_RANGED,
}

----------------------------------------------------
-- Color Formatting
----------------------------------------------------
local function ColorGradient(p)
    if not p then return 1, 1, 1 end
    if p <= 0 then return 1, 0.1, 0.1 end
    if p >= 1 then return 0.1, 1, 0.1 end

    if p < 0.5 then
        local t = p / 0.5
        -- red -> yellow
        local r = 1
        local g = 0.1 + (1 - 0.1) * t
        local b = 0.1
        return r, g, b
    else
        local t = (p - 0.5) / 0.5
        -- yellow -> green
        local r = 1 - (1 - 0.1) * t
        local g = 1
        local b = 0.1
        return r, g, b
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

    -- state
    local invDurability = {}
    local totalDurability = 100
    local totalRepairCost = 0
    local percThreshold = 25 -- default threshold for flashing/pulse

    -- pulse animation when low
    local pulse = slotFrame.pulseAnim
    if not pulse then
        local ag = slotFrame:CreateAnimationGroup()
        ag:SetLooping("REPEAT")
        local a1 = ag:CreateAnimation("Alpha")
        a1:SetFromAlpha(1)
        a1:SetToAlpha(0.3)
        a1:SetDuration(0.6)
        a1:SetSmoothing("IN_OUT")
        slotFrame.pulseAnim = ag
        pulse = ag
    end

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateDurability(self)
        totalDurability = 100
        totalRepairCost = 0
        wipe(invDurability)

        for index in pairs(slots) do
            local cur, max = GetInventoryItemDurability(index)
            if cur and max and max > 0 then
                local perc = (cur / max) * 100
                invDurability[index] = perc
                if perc < totalDurability then
                    totalDurability = perc
                end
                local data = GetInventoryItem("player", index)
                local repairCost = data and data.repairCost
                totalRepairCost = totalRepairCost + (repairCost or 0)
            end
        end

        -- colorize percent
        local r, g, b = ColorGradient(totalDurability / 100)
        local durabilityHex = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
        local textString = SDT:ColorText(L["Durability: "]) .. format("%s%s|r", durabilityHex, SDT:FormatPercent(totalDurability))
        text:SetText(textString)

        -- pulse if below threshold
        if totalDurability <= percThreshold then
            if not pulse:IsPlaying() then pulse:Play() end
        else
            if pulse:IsPlaying() then pulse:Stop() end
            slotFrame:SetAlpha(1)
        end
    end
    f.Update = UpdateDurability

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "UPDATE_INVENTORY_DURABILITY" or event == "PLAYER_EQUIPMENT_CHANGED" then
            UpdateDurability(self)
        elseif event == "MERCHANT_SHOW" or event == "MERCHANT_CLOSED" then
            UpdateDurability(self)
        elseif event == "PLAYER_ENTERING_WORLD" then
            UpdateDurability(self)
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
    f:RegisterEvent("MERCHANT_SHOW")
    f:RegisterEvent("MERCHANT_CLOSED")
    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(DURABILITY or "Durability")
        GameTooltip:AddLine(" ")

        for slotIndex, perc in pairs(invDurability) do
            local texture = GetInventoryItemTexture("player", slotIndex)
            local link = GetInventoryItemLink("player", slotIndex) or UNKNOWN
            local colorR, colorG, colorB = ColorGradient((perc or 0) / 100)
            local left = format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", texture or "", link)
            local right = SDT:FormatPercent(perc or 0)
            GameTooltip:AddDoubleLine(left, right, 1, 1, 1, colorR, colorG, colorB)
        end

        if totalRepairCost and totalRepairCost > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine(REPAIR_COST or "Repair Cost", GetCoinTextureString(totalRepairCost) or tostring(totalRepairCost), 0.6, 0.8, 1, 1, 1, 1)
        end

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            if not InCombatLockdown() then
                ToggleCharacter("PaperDollFrame")
            end
        end
    end)

    UpdateDurability()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT:RegisterDataText("Durability", mod)

return mod
