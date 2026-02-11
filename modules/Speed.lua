-- modules/Speed.lua
-- Speed datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local floor = math.floor

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetGlidingInfo = C_PlayerInfo.GetGlidingInfo
local GetUnitSpeed = GetUnitSpeed
local IsFlying = IsFlying

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local BASE_MOVEMENT_SPEED = 7 -- Base player run speed in yards per second

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Speed"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show as Percentage"], "showAsPercentage", true)

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
    local function UpdateSpeed()
        local currentSpeed
        
        -- Check if player is flying and use appropriate speed calculation
        if IsFlying() then
            _, _, currentSpeed = GetGlidingInfo()
        else
            currentSpeed = GetUnitSpeed("player")
        end
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
        local showAsPercentage = SDT:GetModuleSetting(moduleName, "showAsPercentage", true)
        
        local displayValue
        if showAsPercentage then
            -- Convert to percentage (100% = base run speed)
            displayValue = floor((currentSpeed / BASE_MOVEMENT_SPEED) * 100).."%"
        else
            -- Show raw speed in yards per second
            displayValue = floor(currentSpeed * 10) / 10
        end
        
        local label = showLabel and L["Speed: "] or ""
        local textString = label..displayValue
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, textString))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateSpeed

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "UNIT_AURA"
        or event == "UNIT_SPELLCAST_SUCCEEDED" then
            UpdateSpeed()
        end
    end

    local updateKey = "Speed_" .. (slotFrame:GetName() or tostring(slotFrame))
    SDT.UpdateTicker:Register(updateKey, UpdateSpeed, 0.1)

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UNIT_AURA")
    f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

    UpdateSpeed()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod