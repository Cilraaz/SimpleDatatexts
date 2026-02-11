local addonName, SDT = ...
local L = SDT.L
SDT.FormatUtils = {}

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local BreakUpLargeNumbers = BreakUpLargeNumbers

----------------------------------------------------
-- Add Tooltip Header
----------------------------------------------------
function SDT.FormatUtils:AddTooltipHeader(tooltip, fontSize, text, r, g, b, wrap)
    tooltip = tooltip or GameTooltip
    r = r or 1
    g = g or 0.82
    b = b or 0
    
    tooltip:AddLine(text, r, g, b, wrap or false)
    
    -- Force the header to use a specific font size
    local textLeft = _G[tooltip:GetName() .. "TextLeft" .. tooltip:NumLines()]
    if textLeft then
        local font, _, flags = textLeft:GetFont()
        textLeft:SetFont(font, fontSize or 14, flags)
    end
end

----------------------------------------------------
-- Add Tooltip Line
----------------------------------------------------
function SDT.FormatUtils:AddTooltipLine(tooltip, fontSize, textLeft, textRight, r1, g1, b1, r2, g2, b2, wrap)
    tooltip = tooltip or GameTooltip

    -- Handle single or double lines
    if textRight then
        r1 = r1 or 1
        g1 = g1 or 1
        b1 = b1 or 1
        r2 = r2 or 0.5
        g2 = g2 or 0.5
        b2 = b2 or 0.5
        tooltip:AddDoubleLine(textLeft, textRight, r1, g1, b1, r2, g2, b2, wrap or false)
    else
        r1 = r1 or 1
        g1 = g1 or 1
        b1 = b1 or 1
        tooltip:AddLine(textLeft, r1, g1, b1, wrap or false)
    end

    -- Apply font size to the line
    local lineNum = tooltip:NumLines()
    local textLeftObj = _G[tooltip:GetName() .. "TextLeft" .. lineNum]
    local textRightObj = _G[tooltip:GetName() .. "TextRight" .. lineNum]
    
    if textLeftObj then
        local font, _, flags = textLeftObj:GetFont()
        textLeftObj:SetFont(font, fontSize or 12, flags)
    end
    if textRightObj then
        local font, _, flags = textRightObj:GetFont()
        textRightObj:SetFont(font, fontSize or 12, flags)
    end
end

----------------------------------------------------
-- Format Large Numbers
----------------------------------------------------
function SDT.FormatUtils:FormatLargeNumbers(n)
    local locale = SDT.cache.locale
    local sep

    if locale == "frFR" then
        sep = " "
    elseif locale == "deDE" then
        sep = "."
    elseif locale == "enUS" or locale == "enGB" then
        sep = ","
    else
        return BreakUpLargeNumbers(n)
    end

    local s = tostring(math.floor(n))
    while true do
        local k
        s, k = s:gsub("^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
        if k == 0 then break end
    end
    return s
end

----------------------------------------------------
-- Format Percent
----------------------------------------------------
function SDT.FormatUtils:FormatPercent(v, hideDecimals, roundDown)
    if hideDecimals then
        if roundDown then
            return format("%d%%", v)
        else
            -- Round to nearest integer using standard rounding (>= 0.5 rounds up)
            return format("%d%%", v + 0.5)
        end
    else
        return format("%.2f%%", v)
    end
end

----------------------------------------------------
-- Get Tag Color
----------------------------------------------------
function SDT.FormatUtils:GetTagColor()
    if SDT.db.profile.useCustomColor then
        local color = SDT.db.profile.customColorHex:gsub("#", "")
        return "ff"..color
    elseif SDT.db.profile.useClassColor then
        return SDT.cache.colorHex
    end
    return "ffffffff"
end

----------------------------------------------------
-- Color Text
----------------------------------------------------
function SDT.FormatUtils:ColorText(text)
    local color = self:GetTagColor()
    return "|c"..color..text.."|r"
end

----------------------------------------------------
-- Color Module Text
----------------------------------------------------
function SDT.FormatUtils:ColorModuleText(moduleName, text)
    local overrideColor = SDT:GetModuleSetting(moduleName, "overrideTextColor", false)
    if overrideColor then
        local colorSetting = SDT:GetModuleSetting(moduleName, "customTextColor", "#FFFFFF")
        return format("|cff%s%s|r", colorSetting:gsub("#", ""), text)
    else
        return SDT.FormatUtils:ColorText(text)
    end
end

----------------------------------------------------
-- Find Best Anchor Point
----------------------------------------------------
function SDT.FormatUtils:FindBestAnchorPoint(frame)
    local x, y = frame:GetCenter()
    local screenWidth = UIParent:GetRight()
    local screenHeight = UIParent:GetTop()

    if not x or not y then
        return "ANCHOR_BOTTOM"
    else
        if y < screenHeight / 2 then
            return "ANCHOR_TOP"
        else
            return "ANCHOR_BOTTOM"
        end
    end
end