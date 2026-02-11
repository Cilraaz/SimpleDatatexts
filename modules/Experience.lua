-- modules/Experience.lua
-- Experience datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Library Instances
----------------------------------------------------
local LSM = LibStub("LibSharedMedia-3.0")

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local UnitXP          = UnitXP
local UnitXPMax       = UnitXPMax
local UnitLevel       = UnitLevel
local GetBuildInfo    = GetBuildInfo
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion

----------------------------------------------------
-- Constants
----------------------------------------------------
local EXPERIENCE_BAR_DIVIDERS = 9

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Experience"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    -- Format dropdown
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "select", L["Display Format"], "expFormat", 1, {
        [1] = "XP / Max",
        [2] = "XP / Max (Percent)",
        [3] = "XP / Max (Percent) (Remaining)"
    })

    -- Bar Toggles
    SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, L["Bar Toggles"])
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Graphical Bar"], "expShowGraphicalBar", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Hide Blizzard XP Bar"], "expHideBlizzardBar", false)

    -- Bar Appearance Settings
    SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, L["Bar Appearance"])
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Bar Use Class Color"], "expBarUseClassColor", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "color", L["Bar Custom Color"], "expBarColor", "#4080FF")
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "range", L["Bar Height (%)"], "expBarHeightPercent", 100, 10, 100, 5)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "statusbar", L["Bar Texture"], "expBarTexture", "Blizzard")

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Helper Function: Format Large Numbers
----------------------------------------------------
local function FormatValue(value)
    if value >= 1000000 then
        return format("%.2fM", value / 1000000)
    elseif value >= 1000 then
        return format("%.2fK", value / 1000)
    else
        return tostring(value)
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

    -- Bar frame for graphical display
    local barFrame
    local barBg
    local barFill
    local barDividers
    local barText

    local function CreateBarDisplay()
        if barFrame then return end

        -- Verify slotFrame is valid before creating children
        if not slotFrame or not slotFrame:IsObjectType("Frame") then
            error("CreateBarDisplay called with invalid slotFrame")
            return
        end

        barFrame = CreateFrame("Frame", nil, slotFrame)
        barFrame:SetAllPoints(slotFrame)
        barFrame:EnableMouse(false)

        -- Background
        barBg = barFrame:CreateTexture(nil, "BACKGROUND")
        barBg:SetColorTexture(0, 0, 0, 0.5)

        -- Fill
        barFill = barFrame:CreateTexture(nil, "ARTWORK")
        barFill:SetColorTexture(1, 1, 1, 0.8)
    
        -- Text overlay
        barText = barFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        barText:SetPoint("CENTER", barFrame, "CENTER")
        barText:SetShadowColor(0, 0, 0, 1)
        barText:SetShadowOffset(1, -1)

        -- Dividers (every 10%)
        barDividers = {}
        for i = 1, EXPERIENCE_BAR_DIVIDERS do  -- 9 dividers for 10%, 20%, 30%, etc.
            local divider = barFrame:CreateTexture(nil, "OVERLAY")
            divider:SetWidth(1)
            divider:SetColorTexture(0.3, 0.3, 0.3, 0.8)
            table.insert(barDividers, divider)
        end

        -- Hide by default
        barFrame:Hide()
    end

    local function UpdateBarHeight()
        if not barBg or not barFill then return end
    
        local heightPercent = SDT:GetModuleSetting(moduleName, "expBarHeightPercent", 100)
        local slotHeight = slotFrame:GetHeight()
        local barHeight = (slotHeight * heightPercent) / 100
        local slotWidth = slotFrame:GetWidth()
    
        -- Position background - centered
        barBg:SetHeight(barHeight)
        barBg:SetWidth(slotWidth)
        barBg:SetPoint("CENTER", barFrame, "CENTER", 0, 0)
        
        -- Position fill - anchor to left center
        barFill:SetHeight(barHeight)
        barFill:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
    end

    local function UpdateBarDividers()
        if not barDividers or #barDividers == 0 then return end
    
        local heightPercent = SDT:GetModuleSetting(moduleName, "expBarHeightPercent", 100)
        local slotHeight = slotFrame:GetHeight()
        local barHeight = (slotHeight * heightPercent) / 100
    
        local slotWidth = slotFrame:GetWidth()
        for i, divider in ipairs(barDividers) do
            local xPos = (slotWidth * (i / 10))
            divider:SetPoint("CENTER", barFrame, "CENTER", xPos - slotWidth / 2, 0)
            divider:SetHeight(barHeight)
        end
    end

    local function GetBarColor()
        if SDT:GetModuleSetting(moduleName, "expBarUseClassColor", true) then
            return SDTC.colorR, SDTC.colorG, SDTC.colorB, 1
        else
            local colorSetting = SDT:GetModuleSetting(moduleName, "expBarColor", "#4080FF")
            local color = colorSetting:gsub("#", "")
            local r = tonumber(color:sub(1, 2), 16) / 255
            local g = tonumber(color:sub(3, 4), 16) / 255
            local b = tonumber(color:sub(5, 6), 16) / 255
            return r, g, b, 1
        end
    end

    local currentXP = 0
    local maxXP = 0
    local xpPercent = 0

    local function UpdateExperience()
        -- Check if player is max level
        local _, _, _, TOC = GetBuildInfo()
        local isMaxLevel = SDTC.playerLevel >= GetMaxLevelForPlayerExpansion()
        
        if isMaxLevel then
            text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, L["Max Level"]))
            SDT.FontManager:ApplyModuleFont(moduleName, text)
            if barFrame then barFrame:Hide() end
            return
        end

        currentXP = UnitXP("player")
        maxXP = UnitXPMax("player")

        if maxXP <= 0 then
            text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, L["N/A"]))
            SDT.FontManager:ApplyModuleFont(moduleName, text)
            if barFrame then barFrame:Hide() end
            return
        end

        xpPercent = (currentXP / maxXP) * 100
        local xpRemaining = maxXP - currentXP

        local textString = ""
        local format_mode = SDT:GetModuleSetting(moduleName, "expFormat", 1)

        local showingBar = SDT:GetModuleSetting(moduleName, "expShowGraphicalBar", true)

        -- Format mode 1: XP / XPMax
        if format_mode == 1 then
            textString = format("%s / %s", 
                FormatValue(currentXP), 
                FormatValue(maxXP))

        -- Format mode 2: XP / XPMax (Percent %)
        elseif format_mode == 2 then
            textString = format("%s / %s (%.1f%%)", 
                FormatValue(currentXP), 
                FormatValue(maxXP),
                xpPercent)

        -- Format mode 3: XP / XPMax (Percent %) (Remaining)
        elseif format_mode == 3 then
            textString = format("%s / %s (%.1f%%) (%s)", 
                FormatValue(currentXP), 
                FormatValue(maxXP),
                xpPercent,
                FormatValue(xpRemaining))
        end

        if showingBar and barFrame then
            barFrame:Show()
        elseif barFrame then
            barFrame:Hide()
        end

        -- If bar should be shown, render it
        if not barFrame then CreateBarDisplay(); barFrame:Show() end
        if showingBar and barFrame:IsShown() then
            -- Update bar height based on setting
            UpdateBarHeight()
            UpdateBarDividers()

            -- Apply statusbar texture
            local textureName = SDT:GetModuleSetting(moduleName, "expBarTexture", "Blizzard")
            local texturePath = LSM:Fetch("statusbar", textureName)
            barFill:SetTexture(texturePath)

            -- Crop to XP percentage
            local slotWidth = slotFrame:GetWidth()
            local fillPercent = currentXP / maxXP
            if fillPercent > 0 then
                -- Set width and texture coordinates
                barFill:SetWidth(slotWidth * fillPercent)
                barFill:SetTexCoord(0, fillPercent, 0, 1)

                -- Apply selected color
                local r, g, b, a = GetBarColor()
                barFill:SetVertexColor(r, g, b, 0.8)

                -- Show the bar
                barFill:Show()
            else
                -- Hide at 0% XP to avoid rendering issue
                barFill:Hide()
            end

            -- Update font size from settings
            SDT.FontManager:ApplyModuleFont(moduleName, barText)
        elseif barFrame then
            barFrame:Hide()
        end

        local textOutput = SDT.FormatUtils:ColorModuleText(moduleName, textString)
        if showingBar then
            text:SetText("")
            barText:SetText(textOutput)
        else
            barText:SetText("")
            text:SetText(textOutput)
        end

        -- Apply Module Font
        SDT.FontManager:ApplyModuleFont(moduleName, text)

        -- Hide Blizzard XP bar
        if SDT:GetModuleSetting(moduleName, "expHideBlizzardBar", false) then
            StatusTrackingBarManager:UnregisterAllEvents()
		    StatusTrackingBarManager:Hide()
            SDT.BlizzardXPBarHidden = true
        else
            if SDT.BlizzardXPBarHidden then
                StatusTrackingBarManager:Show()
                StatusTrackingBarManager:OnLoad()
                SDT.BlizzardXPBarHidden = false
            end
        end
    end

    f.Update = UpdateExperience
    SDT.ExperienceModuleUpdate = UpdateExperience

    -- Event Handlers
    local function OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD"
        or event == "PLAYER_XP_UPDATE"
        or event == "PLAYER_LEVEL_UP" then
            if event == "PLAYER_LEVEL_UP" then
                SDTC.playerLevel = UnitLevel("player")
            end
            UpdateExperience()
        end
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_XP_UPDATE")
    f:RegisterEvent("PLAYER_LEVEL_UP")

    -- Tooltip
    slotFrame:SetScript("OnEnter", function(self)
        local _, _, _, TOC = GetBuildInfo()
        local isMaxLevel = TOC < 120000 and SDTC.playerLevel >= 80 or SDTC.playerLevel >= 90
        
        if isMaxLevel then return end

        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        if not SDT.db.profile.hideModuleTitle then
            SDT.FormatUtils:AddTooltipHeader(GameTooltip, 14, L["Experience"])
            SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
        end

        local level = UnitLevel("player")
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, format(L["Level %d"], SDTC.playerLevel), 1, 1, 1)
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12,
            "Progress:",
            format("%s / %s", 
                FormatValue(currentXP), 
                FormatValue(maxXP)),
            1, 0.82, 0, 1, 1, 1
        )
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12,
            "Remaining:",
            FormatValue(maxXP - currentXP),
            1, 0.82, 0, 1, 1, 1
        )
        SDT.FormatUtils:AddTooltipLine(GameTooltip, 12,
            "Percentage:",
            format("%.2f%%", xpPercent),
            1, 0.82, 0, 1, 1, 1
        )

        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdateExperience()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod