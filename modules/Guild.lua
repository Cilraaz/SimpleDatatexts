-- modules/Guild.lua
-- Guild datatext for Simple DataTexts (SDT)
-- Uses SDT_Social core for guild member tracking

local SDT = SimpleDatatexts
local L = SDT.L
local LDB = LibStub("LibDataBroker-1.1")

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format      = string.format

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Guild"
local ldbObject

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    -- Text Settings
    SDT:AddModuleConfigSeparator(moduleName, L["Text Color"])
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Override Text Color"], "overrideTextColor", false)
    SDT:AddModuleConfigSetting(moduleName, "color", L["Text Custom Color"], "customTextColor", "#FFFFFF")

    -- Font Settings
    SDT:AddModuleConfigSeparator(moduleName, L["Font Settings"])
    SDT:AddModuleConfigSetting(moduleName, "checkbox", L["Override Global Font"], "overrideFont", false)
    SDT:AddModuleConfigSetting(moduleName, "font", L["Display Font:"], "font", "Friz Quadrata TT")
    SDT:AddModuleConfigSetting(moduleName, "fontSize", L["Font Size"], "fontSize", 12, 4, 40, 1)
    SDT:AddModuleConfigSetting(moduleName, "fontOutline", L["Font Outline"], "fontOutline", "NONE", {
        ["NONE"] = L["None"],
        ["OUTLINE"] = "Outline",
        ["THICKOUTLINE"] = "Thick Outline",
        ["MONOCHROME"] = "Monochrome",
        ["OUTLINE, MONOCHROME"] = "Outline + Monochrome",
        ["THICKOUTLINE, MONOCHROME"] = "Thick Outline + Monochrome",
    })
end

SetupModuleConfig()

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)

    local text = f:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER")
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")
    f.text = text

    -- Try to get LDB object, with retry logic
    local function TryGetLDBObject()
        ldbObject = LDB:GetDataObjectByName("SDT Guild")
        return ldbObject ~= nil
    end

    -- If LDB object doesn't exist yet, wait for it
    if not TryGetLDBObject() then
        local retryFrame = CreateFrame("Frame")
        local attempts = 0
        retryFrame:SetScript("OnUpdate", function(self, elapsed)
            attempts = attempts + 1
            if TryGetLDBObject() or attempts > 100 then  -- Try for ~1.6 seconds
                self:SetScript("OnUpdate", nil)
                if ldbObject then
                    f.Update()
                else
                    SDT.Print(L["Ara Guild LDB object not found! SDT Guild datatext disabled."] or "Guild LDB object not found!")
                end
            end
        end)
    end

    ----------------------------------------------------
    -- Update Function
    ----------------------------------------------------
    local function Update()
        if not ldbObject then return end

        -- Apply font settings
        local overrideFont = SDT:GetModuleSetting(moduleName, "overrideFont", false)
        if overrideFont then
            local font = SDT:GetModuleSetting(moduleName, "font", "Friz Quadrata TT")
            local fontSize = SDT:GetModuleSetting(moduleName, "fontSize", 12)
            local fontOutline = SDT:GetModuleSetting(moduleName, "fontOutline", "NONE")
            local fontPath = SDT.LSM:Fetch("font", font)
            if fontPath then
                text:SetFont(fontPath, fontSize, fontOutline)
            end
        else
            local globalFont = SDT.LSM:Fetch("font", SDT.db.profile.font)
            if globalFont then
                text:SetFont(globalFont, SDT.db.profile.fontSize, SDT.db.profile.fontOutline)
            end
        end

        -- Get text from LDB object
        local displayText = ldbObject.text or L["No Guild"]

        -- Apply color and set text
        text:SetText(SDT:ColorModuleText(moduleName, displayText))
    end

    f.Update = Update

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        if ldbObject and ldbObject.OnEnter then
            ldbObject.OnEnter(self)
        elseif ldbObject and ldbObject.OnTooltipShow then
            local anchor = SDT:FindBestAnchorPoint(self)
            GameTooltip:SetOwner(self, anchor)
            GameTooltip:ClearLines()
            ldbObject.OnTooltipShow(GameTooltip)
            GameTooltip:Show()
        end
    end)

    slotFrame:SetScript("OnLeave", function(self)
        if ldbObject and ldbObject.OnLeave then
            ldbObject.OnLeave(self)
        end
        GameTooltip:Hide()
    end)

    ----------------------------------------------------
    -- Click Handling
    ----------------------------------------------------
    slotFrame:RegisterForClicks("AnyUp")
    slotFrame:SetScript("OnClick", function(self, button)
        if ldbObject and ldbObject.OnClick then
            ldbObject.OnClick(self, button)
        end
    end)

    ----------------------------------------------------
    -- LDB Callback for Updates
    ----------------------------------------------------
    LDB.RegisterCallback(f, "LibDataBroker_AttributeChanged", function(event, name, attr, value)
        if name == "SDT Guild" and attr == "text" then
            Update()
        end
    end)

    Update()

    return f
end

----------------------------------------------------
-- Register Module
----------------------------------------------------
SDT:RegisterDataText(moduleName, mod)