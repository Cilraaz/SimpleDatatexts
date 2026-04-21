local addonName, SDT = ...
local L = SDT.L
SDT.FontManager = {}

----------------------------------------------------
-- Apply Font
----------------------------------------------------
function SDT.FontManager:ApplyFont()
    local fontPath = SDT.LSM:Fetch("font", SDT.db.profile.font) or STANDARD_TEXT_FONT
    local fontSize = SDT.db.profile.fontSize or 12
    local fontOutline = SDT.db.profile.fontOutline or "NONE"

    -- Convert "NONE" to empty string for SetFont
    local outline = (fontOutline == "NONE") and "" or fontOutline

    for _, bar in pairs(SDT.bars) do
        for _, slot in ipairs(bar.slots) do
            if slot.text then
                slot.text:SetFont(fontPath, fontSize, outline)
                if SDT.db.profile.fontShadowEnabled then
                    slot.text:SetShadowOffset(1, -1)
                    slot.text:SetShadowColor(0, 0, 0, 1)
                else
                    slot.text:SetShadowOffset(0, 0)
                end
            end
            if slot.moduleFrame and slot.moduleFrame.text and slot.moduleFrame.text.SetFont then
                slot.moduleFrame.text:SetFont(fontPath, fontSize, outline)
                if SDT.db.profile.fontShadowEnabled then
                    slot.moduleFrame.text:SetShadowOffset(1, -1)
                    slot.moduleFrame.text:SetShadowColor(0, 0, 0, 1)
                else
                    slot.moduleFrame.text:SetShadowOffset(0, 0)
                end
            end
        end
    end
end

----------------------------------------------------
-- Apply Module Font
----------------------------------------------------
function SDT.FontManager:ApplyModuleFont(moduleName, textObject)
    if not moduleName or not textObject then return end
    
    local overrideFont = SDT:GetModuleSetting(moduleName, "overrideFont", false)
    if overrideFont then
        -- Apply module font when override is enabled
        local fontName = SDT:GetModuleSetting(moduleName, "font", "Friz Quadrata TT")
        local fontSize = SDT:GetModuleSetting(moduleName, "fontSize", 12)
        local fontOutline = SDT:GetModuleSetting(moduleName, "fontOutline", "NONE")
        
        local fontPath = SDT.LSM:Fetch("font", fontName) or STANDARD_TEXT_FONT
        local outline = (fontOutline == "NONE") and "" or fontOutline
        
        textObject:SetFont(fontPath, fontSize, outline)
        return true
    else
        -- Apply global font when override is disabled
        local fontPath = SDT.LSM:Fetch("font", SDT.db.profile.font) or STANDARD_TEXT_FONT
        local fontSize = SDT.db.profile.fontSize or 12
        local fontOutline = SDT.db.profile.fontOutline or "NONE"
        local outline = (fontOutline == "NONE") and "" or fontOutline
        
        textObject:SetFont(fontPath, fontSize, outline)
        return false
    end
    
    return false
end

----------------------------------------------------
-- Get Tooltip Font Outline
----------------------------------------------------
function SDT.FontManager:GetTooltipOutline()
    local outline = SDT.db.profile.tooltipFontOutline or "NONE"
    return (outline == "NONE") and "" or outline
end

----------------------------------------------------
-- Register Fonts
----------------------------------------------------
function SDT.FontManager:RegisterFonts()
    SDT.LSM:Register("font", "Action Man", [[Interface\AddOns\SimpleDatatexts\fonts\ActionMan.ttf]])
    SDT.LSM:Register("font", "Continuum Medium", [[Interface\AddOns\SimpleDatatexts\fonts\ContinuumMedium.ttf]])
    SDT.LSM:Register("font", "Die Die Die!", [[Interface\AddOns\SimpleDatatexts\fonts\DieDieDie.ttf]])
    SDT.LSM:Register("font", "Expressway", [[Interface\AddOns\SimpleDatatexts\fonts\Expressway.ttf]])
    SDT.LSM:Register("font", "Homespun", [[Interface\AddOns\SimpleDatatexts\fonts\Homespun.ttf]])
    SDT.LSM:Register("font", "PT Sans Narrow", [[Interface\AddOns\SimpleDatatexts\fonts\PTSansNarrow.ttf]])
end