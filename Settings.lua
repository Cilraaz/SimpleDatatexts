-- Settings Panel

----------------------------------------------------
-- Addon Locals
----------------------------------------------------
local addonName, SDT = ...

----------------------------------------------------
-- Library Instances
----------------------------------------------------
local LSM = LibStub("LibSharedMedia-3.0")

----------------------------------------------------
-- Register Fonts
----------------------------------------------------
LSM:Register("font", "Action Man", [[Interface\AddOns\SimpleDatatexts\fonts\ActionMan.ttf]])
LSM:Register("font", "Continuum Medium", [[Interface\AddOns\SimpleDatatexts\fonts\ContinuumMedium.ttf]])
LSM:Register("font", "Die Die Die", [[Interface\AddOns\SimpleDatatexts\fonts\DieDieDie.ttf]])
LSM:Register("font", "Expressway", [[Interface\AddOns\SimpleDatatexts\fonts\Expressway.ttf]])
LSM:Register("font", "Homespun", [[Interface\AddOns\SimpleDatatexts\fonts\Homespun.ttf]])
LSM:Register("font", "Invisible", [[Interface\AddOns\SimpleDatatexts\fonts\Invisible.ttf]])
LSM:Register("font", "PT Sans Narrow", [[Interface\AddOns\SimpleDatatexts\fonts\PTSansNarrow.ttf]])

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format           = string.format
local tonumber         = tonumber
local tostring         = tostring
local tsort            = table.sort

----------------------------------------------------
-- File Locals
----------------------------------------------------
local charKey = SDT:GetCharKey()

-------------------------------------------------
-- Early DB Defaults
-------------------------------------------------
local charDefaultsTable = {
    useSpecProfiles = false,
    chosenProfile = {
        generic = charKey,
    },
    settings = { 
        locked = false,
        useClassColor = false,
        useCustomColor = false,
        customColorHex = "#ffffff",
        use24HourClock = false,
        font = "Friz Quadrata TT",
        fontSize = 12,
        debug = false,
    }
}

local function checkDefaultDB()
    SDTDB.gold = SDTDB.gold or {}
    SDTDB.profiles = SDTDB.profiles or {}
    SDTDB[charKey] = SDTDB[charKey] or {}
    SDT.SDTDB_CharDB = SDTDB[charKey]

    local charDB = SDTDB[charKey]
    
    -- Migrate from old structure
    if (not charDB.bars and SDTDB.bars) then
        charDB.bars = CopyTable(SDTDB.bars)
    end
    if (not charDB.settings and SDTDB.settings) then
        charDB.settings = CopyTable(SDTDB.settings)
    end
    if (not SDTDB.profiles[charKey] and charDB.bars) then
        SDTDB.profiles[charKey] = {}
        SDTDB.profiles[charKey].bars = CopyTable(charDB.bars)
    end

    -- Fill in missing defaults
    charDB.useSpecProfiles = charDB.useSpecProfiles or charDefaultsTable.useSpecProfiles
    charDB.chosenProfile   = charDB.chosenProfile or charDefaultsTable.chosenProfile
    charDB.settings        = charDB.settings or CopyTable(charDefaultsTable.settings)
    for k, v in pairs(charDefaultsTable.settings) do
        if charDB.settings[k] == nil then charDB.settings[k] = v end
    end

    -- Remove top-level bars/settings after migration
    if SDTDB.bars and next(SDTDB.bars) and next(charDB.bars) then
        SDTDB.bars = nil
    end
    if SDTDB.settings and next(SDTDB.settings) and next(charDB.settings) then
        SDTDB.settings = nil
    end
    if charDB.bars and next(charDB.bars) and next(SDTDB.profiles[charKey].bars) then
        charDB.bars = nil
    end

    SDT.SDTDB_CharDB = charDB

    for i = 1, GetNumSpecializations() do
        local _, specName = GetSpecializationInfo(i)
        local specNameLower = specName:lower()
        if not charDB.chosenProfile[specName] then
            charDB.chosenProfile[specName] = charKey.."-"..specNameLower
        end
    end

    for _, profileName in pairs(charDB.chosenProfile) do
        if not SDTDB.profiles[profileName] then
            SDTDB.profiles[profileName] = { 
                bars = {
                    SDT_Bar1 = {
                        numSlots = 3,
                        slots = {},
                        showBackground = true,
                        showBorder = true,
                        width = 300,
                        height = 22,
                        name = "SDT_Bar1",
                    }
                }
            }
        end
    end

    local profileName
    if charDB.useSpecProfiles then
        local _, currentSpec = GetSpecializationInfo(GetSpecialization())
        profileName = charDB.chosenProfile[currentSpec]
    else
        profileName = charDB.chosenProfile.generic
    end
    SDT.profileBars = SDTDB.profiles[profileName].bars
end

_G.SDTDB = _G.SDTDB or {}
local earlyDefaults = CopyTable(charDefaultsTable)
SDT.SDTDB_CharDB = (_G.SDTDB and _G.SDTDB[SDT:GetCharKey()]) or earlyDefaults

-------------------------------------------------
-- Settings Panel UI
-------------------------------------------------
local panel = CreateFrame("Frame", addonName .. "_Settings", UIParent)
panel.name = "Simple DataTexts"
SDT.SettingsPanel = panel

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(panel.name .. " - Global Settings")

local version = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
version:SetPoint("TOPRIGHT", -16, -17)
version:SetText("v" .. SDT.cache.version)

local function MakeLabel(parent, text, point, x, y)
    local t = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    t:SetPoint(point, x, y)
    t:SetText(text)
    return t
end

local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
category.ID = panel.name
Settings.RegisterAddOnCategory(category)

-------------------------------------------------
-- Settings Sub-Panels
-------------------------------------------------
local globalSubPanel = CreateFrame("Frame", addonName .. "_GlobalSubPanel", UIParent)
globalSubPanel.name = "Global"
globalSubPanel.parent = panel.name
SDT.GlobalSubPanel = globalSubPanel

local globalTitle = globalSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
globalTitle:SetPoint("TOPLEFT", 16, -16)
globalTitle:SetText("Simple DataTexts - Global Settings")

local globalVersion = globalSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
globalVersion:SetPoint("TOPRIGHT", -16, -17)
globalVersion:SetText("v" .. SDT.cache.version)

local globalCategory = Settings.RegisterCanvasLayoutSubcategory(category, globalSubPanel, "Global")
Settings.RegisterAddOnCategory(globalCategory)

local panelsSubPanel = CreateFrame("Frame", addonName .. "_PanelsSubPanel", UIParent)
panelsSubPanel.name = "Panels"
panelsSubPanel.parent = panel.name
SDT.PanelsSubPanel = panelsSubPanel

local panelsTitle = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
panelsTitle:SetPoint("TOPLEFT", 16, -16)
panelsTitle:SetText("Simple DataTexts - Panel Settings")

local panelsVersion = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
panelsVersion:SetPoint("TOPRIGHT", -16, -17)
panelsVersion:SetText("v" .. SDT.cache.version)

local panelsCategory = Settings.RegisterCanvasLayoutSubcategory(category, panelsSubPanel, "Panels")
Settings.RegisterAddOnCategory(panelsCategory)

local profilesSubPanel = CreateFrame("Frame", addonName .. "_ProfilesSubPanel", UIParent)
profilesSubPanel.name = "Profiles"
profilesSubPanel.parent = panel.name
SDT.ProfilesSubPanel = profilesSubPanel

local profilesTitle = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
profilesTitle:SetPoint("TOPLEFT", 16, -16)
profilesTitle:SetText("Simple DataTexts - Profile Settings")

local profilesVersion = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profilesVersion:SetPoint("TOPRIGHT", -16, -17)
profilesVersion:SetText("v" .. SDT.cache.version)

local profilesCategory = Settings.RegisterCanvasLayoutSubcategory(category, profilesSubPanel, "Profiles")
Settings.RegisterAddOnCategory(profilesCategory)

-------------------------------------------------
-- Global Settings
-------------------------------------------------
local lockCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
lockCheckbox:SetPoint("TOPLEFT", globalTitle, "BOTTOMLEFT", 0, -20)
lockCheckbox.Text:SetText("Lock Panels (disable movement)")
lockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.locked)
lockCheckbox:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.settings.locked = self:GetChecked()
end)

local classColorCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
classColorCheckbox:SetPoint("TOPLEFT", lockCheckbox, "BOTTOMLEFT", 0, -20)
classColorCheckbox.Text:SetText("Use Class Color")
classColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useClassColor)

local use24HourClockCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
use24HourClockCheckbox:SetPoint("LEFT", classColorCheckbox, "RIGHT", 100, 0)
use24HourClockCheckbox.Text:SetText("Use 24Hr Clock")
use24HourClockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.use24HourClock)
use24HourClockCheckbox:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.settings.use24HourClock = self:GetChecked()
    SDT:UpdateAllModules()
end)

local customColorCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
customColorCheckbox:SetPoint("TOPLEFT", classColorCheckbox, "BOTTOMLEFT", 0, -20)
customColorCheckbox.Text:SetText("Use Custom Color")
customColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useCustomColor)

classColorCheckbox:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.settings.useClassColor = self:GetChecked()
    if self:GetChecked() then
        SDT.SDTDB_CharDB.settings.useCustomColor = false
        customColorCheckbox:SetChecked(false)
    end
    SDT:UpdateAllModules()
end)
customColorCheckbox:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.settings.useCustomColor = self:GetChecked()
    if self:GetChecked() then
        SDT.SDTDB_CharDB.settings.useClassColor = false
        classColorCheckbox:SetChecked(false)
    end
    SDT:UpdateAllModules()
end)

local colorPickerButton = CreateFrame("Button", nil, globalSubPanel, "UIPanelButtonTemplate")
colorPickerButton:SetPoint("LEFT", customColorCheckbox, "RIGHT", 120, 0)
colorPickerButton:SetSize(80, 24)
colorPickerButton:SetScript("OnShow", function(self)
    self:SetText(SDT.SDTDB_CharDB.settings.customColorHex)
end)

local function showColorPicker()
    ColorPickerFrame:Hide()
    
    local initColor = SDT.SDTDB_CharDB.settings.customColorHex:gsub("#", "")
    local initR = tonumber(initColor:sub(1, 2), 16) / 255
    local initG = tonumber(initColor:sub(3, 4), 16) / 255
    local initB = tonumber(initColor:sub(5, 6), 16) / 255

    local function onColorPicked()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        SDT.SDTDB_CharDB.settings.customColorHex = format("#%02X%02X%02X", r*255, g*255, b*255)
        SDT:UpdateAllModules()
        colorPickerButton:SetText(SDT.SDTDB_CharDB.settings.customColorHex)
    end

    local function onCancel()
        SDT.SDTDB_CharDB.settings.customColorHex = format("#%02X%02X%02X", initR*255, initG*255, initB*255)
        SDT:UpdateAllModules()
        colorPickerButton:SetText(SDT.SDTDB_CharDB.settings.customColorHex)
    end

    local previousValues = { initR, initG, initB }

    local options = {
        swatchFunc = onColorPicked,
        cancelFunc = onCancel,
        hasOpacity = false,
        opacity = 1,
        r = initR,
        g = initG,
        b = initB,
    }
    
    ColorPickerFrame:SetupColorPickerAndShow(options)
end

colorPickerButton:SetScript("OnClick", function()
    showColorPicker()
end)

local fontLabel = globalSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
fontLabel:SetPoint("TOPLEFT", customColorCheckbox, "BOTTOMLEFT", 0, -20)
fontLabel:SetText("Display Font:")

local fontDropdown = CreateFrame("Frame", addonName .. "_FontDropdown", globalSubPanel, "UIDropDownMenuTemplate")
fontDropdown:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", -20, -4)
UIDropDownMenu_SetWidth(fontDropdown, 160)

local fontSizeSlider = CreateFrame("Slider", addonName.."_FontSizeSlider", globalSubPanel, "OptionsSliderTemplate")
fontSizeSlider:SetPoint("TOPLEFT", fontDropdown, "BOTTOMLEFT", 20, -20)
fontSizeSlider:SetMinMaxValues(4, 40)
fontSizeSlider:SetValueStep(1)
fontSizeSlider:SetWidth(160)
getglobal(fontSizeSlider:GetName().."Text"):SetText("Font Size")
getglobal(fontSizeSlider:GetName().."Low"):SetText(tostring(4))
getglobal(fontSizeSlider:GetName().."High"):SetText(tostring(40))
fontSizeSlider:SetScript("OnShow", function(self)
    self:SetValue(SDT.SDTDB_CharDB.settings.fontSize)
end)

local fontSizeBox = CreateFrame("EditBox", addonName.."_FontSizeEditBox", globalSubPanel, "InputBoxTemplate")
fontSizeBox:SetSize(50, 20)
fontSizeBox:SetPoint("LEFT", fontSizeSlider, "RIGHT", 25, 0)
fontSizeBox:SetAutoFocus(false)
fontSizeBox:SetJustifyH("CENTER")
fontSizeBox:SetJustifyV("MIDDLE")
fontSizeBox:SetScript("OnShow", function(self)
    self:SetText(SDT.SDTDB_CharDB.settings.fontSize)
end)

-- Sync slider -> editbox
fontSizeSlider:SetScript("OnValueChanged", function(self, value)
    local val = math.floor(value + 0.5)
    fontSizeBox:SetText(val)
    SDT.SDTDB_CharDB.settings.fontSize = val
    SDT:ApplyFont()
end)
    
    -- Sync editbox -> slider
fontSizeBox:SetScript("OnEnterPressed", function(self)
    local val = tonumber(self:GetText())
    if val then
        val = math.max(4, math.min(40, val))
        fontSizeSlider:SetValue(val)
        self:SetText(val)
    else
        self:SetText(math.floor(fontSizeSlider:GetValue()+0.5))
    end
    SDT:ApplyFont()
end)

-------------------------------------------------
-- Panels Settings - Left Column
-------------------------------------------------
local addBarButton = CreateFrame("Button", nil, panelsSubPanel, "UIPanelButtonTemplate")
addBarButton:SetPoint("TOPLEFT", panelsTitle, "BOTTOMLEFT", 0, -20)
addBarButton:SetSize(160, 24)
addBarButton:SetText("Create New Panel")

-- Panel Selector
local panelLabel = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
panelLabel:SetPoint("TOPLEFT", addBarButton, "BOTTOMLEFT", 0, -16)
panelLabel:SetText("Select Panel:")
local panelDropdown = CreateFrame("Frame", addonName .. "_PanelDropdown", panelsSubPanel, "UIDropDownMenuTemplate")
panelDropdown:SetPoint("TOPLEFT", panelLabel, "BOTTOMLEFT", -20, -6)
UIDropDownMenu_SetWidth(panelDropdown, 160)

-- Rename Panel
local renameLabel = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
renameLabel:SetPoint("TOPLEFT", panelDropdown, "BOTTOMLEFT", 20, -16)
renameLabel:SetText("Rename Panel:")
renameLabel:Hide()
local nameEditBox = CreateFrame("EditBox", addonName .. "_PanelNameEditBox", panelsSubPanel, "InputBoxTemplate")
nameEditBox:SetSize(170, 20)
nameEditBox:SetPoint("TOPLEFT", renameLabel, "BOTTOMLEFT", 4, -6)
nameEditBox:SetAutoFocus(false)
nameEditBox:SetJustifyH("CENTER")
nameEditBox:SetJustifyV("MIDDLE")
nameEditBox:SetText("")
nameEditBox:Hide()

nameEditBox:SetScript("OnEnterPressed", function(self)
    local newName = self:GetText():trim()
    if newName ~= "" and panelsSubPanel.selectedBar then
        SDT.profileBars[panelsSubPanel.selectedBar].name = newName
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
        UIDropDownMenu_SetText(panelDropdown, newName)
    end
end)

-------------------------------------------------
-- Panels Settings - Right Column
-------------------------------------------------
local removeBarButton = CreateFrame("Button", nil, panelsSubPanel, "UIPanelButtonTemplate")
removeBarButton:SetSize(160, 24)
removeBarButton:SetPoint("LEFT", addBarButton, "RIGHT", 140, 0)
removeBarButton:SetText("Remove Selected Panel")
removeBarButton:Hide()

local bgCheckbox = CreateFrame("CheckButton", nil, panelsSubPanel, "InterfaceOptionsCheckButtonTemplate")
bgCheckbox:SetPoint("TOPLEFT", removeBarButton, "BOTTOMLEFT", 0, -12)
bgCheckbox.Text:SetText("Show Background")
bgCheckbox:Hide()

local borderCheckbox = CreateFrame("CheckButton", nil, panelsSubPanel, "InterfaceOptionsCheckButtonTemplate")
borderCheckbox:SetPoint("LEFT", bgCheckbox, "RIGHT", 100, 0)
borderCheckbox.Text:SetText("Show Border")
borderCheckbox:Hide()

local slotSelectors = {}
local function buildSlotSelectors(barName)
    for _, f in ipairs(slotSelectors) do f:Hide() end
    slotSelectors = {}

    local b = SDT.profileBars[barName]
    if not b then return end

    for i = 1, b.numSlots do
        local lbl = MakeLabel(panelsSubPanel, "Slot " .. i .. ":", "TOPLEFT", 320, -290 - ((i - 1) * 50))
        local dd = CreateFrame("Frame", addonName .. "_SlotSel_" .. i, panelsSubPanel, "UIDropDownMenuTemplate")
        dd:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", -20, -6)
        UIDropDownMenu_SetWidth(dd, 140)

        UIDropDownMenu_Initialize(dd, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.text = "(empty)"
            info.func = function()
                SDT.profileBars[barName].slots[i] = nil
                UIDropDownMenu_SetText(dd, "(empty)")
                if SDT.bars[barName] then SDT:RebuildSlots(SDT.bars[barName]) end
            end
            UIDropDownMenu_AddButton(info)

            for _, name in ipairs(SDT.cache.moduleNames) do
                local moduleName = name
                info.text = moduleName
                info.func = function()
                    SDT.profileBars[barName].slots[i] = name
                    UIDropDownMenu_SetText(dd, name)
                    if SDT.bars[barName] then SDT:RebuildSlots(SDT.bars[barName]) end
                end
                UIDropDownMenu_AddButton(info)
            end
        end)

        UIDropDownMenu_SetText(dd, b.slots[i] or "(empty)")
        table.insert(slotSelectors, lbl)
        table.insert(slotSelectors, dd)
    end
end

-------------------------------------------------
-- Custom Slider with EditBox
-------------------------------------------------
local function CreateSliderWithBox(parent, name, text, min, max, step, attach, x, y)
    -- Slider
    local slider = CreateFrame("Slider", addonName.."_"..name.."Slider", parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", attach, "BOTTOMLEFT", x, y)
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetWidth(160)
    getglobal(slider:GetName().."Text"):SetText(text)
    getglobal(slider:GetName().."Low"):SetText(tostring(min))
    getglobal(slider:GetName().."High"):SetText(tostring(max))
    slider:Hide()
    
    -- Edit Box
    local eb = CreateFrame("EditBox", addonName.."_"..name.."EditBox", parent, "InputBoxTemplate")
    eb:SetSize(50, 20)
    eb:SetPoint("LEFT", slider, "RIGHT", 25, 0)
    eb:SetAutoFocus(false)
    eb:SetJustifyH("CENTER")
    eb:SetJustifyV("MIDDLE")
    eb:SetText(min)
    eb:Hide()
    
    -- Sync slider -> editbox
    slider:SetScript("OnValueChanged", function(self, value)
        local val = math.floor(value + 0.5)
        eb:SetText(val)
        if panelsSubPanel.selectedBar then
            local barData = SDT.profileBars[panelsSubPanel.selectedBar]
            if name == "Slots" then
                barData.numSlots = val
            elseif name == "Width" then
                barData.width = val
            elseif name == "Height" then
                barData.height = val
            elseif name == "Scale" then
                barData.scale = val
                if SDT.bars[panelsSubPanel.selectedBar] then
                    SDT.bars[panelsSubPanel.selectedBar]:SetScale(val / 100)
                end
            elseif name == "Background Opacity" then
                barData.bgOpacity = val
                if SDT.bars[panelsSubPanel.selectedBar] then
                    SDT.bars[panelsSubPanel.selectedBar]:ApplyBackground()
                end
            end
            if SDT.bars[panelsSubPanel.selectedBar] then
                SDT:RebuildSlots(SDT.bars[panelsSubPanel.selectedBar])
            end
            if name == "Slots" then
                buildSlotSelectors(panelsSubPanel.selectedBar)
            end
        end
    end)
    
    -- Sync editbox -> slider
    eb:SetScript("OnEnterPressed", function(self)
        local val = tonumber(self:GetText())
        if val then
            val = math.max(min, math.min(max, val))
            slider:SetValue(val)
            self:SetText(val)
            if name == "Scale" and SDT.bars[panelsSubPanel.selectedBar] then
                SDT.bars[panelsSubPanel.selectedBar]:SetScale(val / 100)
            elseif name == "Background Opacity" and SDT.bars[panelsSubPanel.selectedBar] then
                SDT.bars[panelsSubPanel.selectedBar]:ApplyBackground()
            end
        else
            -- reset to slider value if invalid
            self:SetText(math.floor(slider:GetValue()+0.5))
        end
    end)
    
    return slider, eb
end

local opacitySlider, opacityBox = CreateSliderWithBox(panelsSubPanel, "Background Opacity", "Background Opacity", 0, 100, 1, bgCheckbox, 5, -20)
local slotSlider, slotBox = CreateSliderWithBox(panelsSubPanel, "Slots", "Slots", 1, 5, 1, opacitySlider, 0, -20)
local widthSlider, widthBox = CreateSliderWithBox(panelsSubPanel, "Width", "Width", 100, 800, 1, slotSlider, 0, -20)
local heightSlider, heightBox = CreateSliderWithBox(panelsSubPanel, "Height", "Height", 16, 128, 1, widthSlider, 0, -20)
local scaleSlider, scaleBox = CreateSliderWithBox(panelsSubPanel, "Scale", "Scale", 50, 500, 1, nameEditBox, 3, -30)

-- Panel dropdown initializer
local function PanelDropdown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for barName, _ in pairs(SDT.profileBars) do
        local displayName = SDT.profileBars[barName].name or barName
        info.text = displayName
        info.func = function()
            UIDropDownMenu_SetText(panelDropdown, displayName)
            panelsSubPanel.selectedBar = barName
            updateSelectedBarControls()
        end
        UIDropDownMenu_AddButton(info)
    end
end

-- Font dropdown initializer
local function FontDropdown_Initialize(self, level)
    for _, fontName in ipairs(SDT.fonts) do
        local info = UIDropDownMenu_CreateInfo()
        info.notCheckable = true
        info.text = fontName
        info.value = fontName
        info.func = function()
            SDT.SDTDB_CharDB.settings.font = fontName
            UIDropDownMenu_SetSelectedValue(fontDropdown, fontName)
            UIDropDownMenu_SetText(fontDropdown, fontName)
            SDT:ApplyFont()
        end
        UIDropDownMenu_AddButton(info)
    end
end

-- Update per-panel controls
function updateSelectedBarControls()
    local barName = panelsSubPanel.selectedBar
    if not barName then
        removeBarButton:Hide()
        bgCheckbox:Hide()
        borderCheckbox:Hide()
        opacitySlider:Hide()
        opacityBox:Hide()
        slotSlider:Hide()
        slotBox:Hide()
        widthSlider:Hide()
        widthBox:Hide()
        heightSlider:Hide()
        heightBox:Hide()
        renameLabel:Hide()
        nameEditBox:Hide()
        scaleSlider:Hide()
        scaleBox:Hide()
        for _, f in ipairs(slotSelectors) do f:Hide() end
        return
    end

    removeBarButton:Show()
    bgCheckbox:Show()
    borderCheckbox:Show()
    opacitySlider:Show()
    opacityBox:Show()
    slotSlider:Show()
    slotBox:Show()
    widthSlider:Show()
    widthBox:Show()
    heightSlider:Show()
    heightBox:Show()
    renameLabel:Show()
    nameEditBox:SetText(SDT.profileBars[barName].name or barName)
    nameEditBox:Show()
    scaleSlider:Show()
    scaleBox:Show()

    local b = SDT.profileBars[barName]
    if not b then return end

    -- Background / Border
    bgCheckbox:SetChecked(b.showBackground)
    bgCheckbox:SetScript("OnClick", function(self)
        b.showBackground = self:GetChecked()
        if SDT.bars[barName] then SDT.bars[barName]:ApplyBackground() end
    end)
    borderCheckbox:SetChecked(b.showBorder)
    borderCheckbox:SetScript("OnClick", function(self)
        b.showBorder = self:GetChecked()
        if SDT.bars[barName] then SDT.bars[barName]:ApplyBackground() end
    end)

    -- Slots
    local numSlots = b.numSlots or 3
    slotSlider:SetValue(numSlots)
    slotBox:SetText(numSlots)

    -- Width
    local width = b.width or 300
    widthSlider:SetValue(width)
    widthBox:SetText(width)

    -- Height
    local height = b.height or 22
    heightSlider:SetValue(height)
    heightBox:SetText(height)

    -- Scale
    local scale = b.scale or 100
    scaleSlider:SetValue(scale)
    scaleBox:SetText(scale)

    -- Opacity
    local opacity = b.bgOpacity or 50
    opacitySlider:SetValue(opacity)
    opacityBox:SetText(opacity)

    -- Rebuild slots & selectors
    if SDT.bars[barName] then SDT:RebuildSlots(SDT.bars[barName]) end
    buildSlotSelectors(barName)
end

-- Add Panel button click
addBarButton:SetScript("OnClick", function()
    local id = SDT:NextBarID()
    local name = "SDT_Bar" .. id
    SDT.profileBars[name] = { numSlots = 3, slots = {}, showBackground = true, showBorder = true, width = 300, height = 22 }
    SDT:CreateDataBar(id, 3)
    UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
    UIDropDownMenu_SetText(panelDropdown, name)
    panelsSubPanel.selectedBar = name
    updateSelectedBarControls()
end)

-- Remove selected panel
removeBarButton:SetScript("OnClick", function()
    local barName = panelsSubPanel.selectedBar
    if not barName then return end

    StaticPopup_Show("SDT_CONFIRM_DELETE_BAR", nil, nil, barName)
end)

-- Confirmation Pop-up
StaticPopupDialogs["SDT_CONFIRM_DELETE_BAR"] = {
    text = "Are you sure you want to delete this bar?\nThis action cannot be undone.",
    button1 = "Yes",
    button2 = "No",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnAccept = function(self, barName)
        -- Perform the delete
        if SDT.bars[barName] then
            SDT.bars[barName]:Hide()
            SDT.bars[barName] = nil
        end
        SDT.profileBars[barName] = nil

        -- Clear UI state
        panelsSubPanel.selectedBar = nil
        UIDropDownMenu_SetText(panelDropdown, "(none)")
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)

        for _, f in ipairs(slotSelectors) do f:Hide() end
        slotSelectors = {}

        removeBarButton:Hide()
        bgCheckbox:Hide()
        borderCheckbox:Hide()
        opacitySlider:Hide()
        opacityBox:Hide()
        slotSlider:Hide()
        slotBox:Hide()
        widthSlider:Hide()
        widthBox:Hide()
        heightSlider:Hide()
        heightBox:Hide()
        renameLabel:Hide()
        nameEditBox:Hide()
        scaleSlider:Hide()
        scaleBox:Hide()
    end,
}

-------------------------------------------------
-- Profiles Settings
-------------------------------------------------
local profileCreateLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profileCreateLabel:SetPoint("TOPLEFT", profilesTitle, "BOTTOMLEFT", 0, -16)
profileCreateLabel:SetText("Create New Profile:")

local profileCreateName = CreateFrame("EditBox", nil, profilesSubPanel, "InputBoxTemplate")
profileCreateName:SetSize(160, 24)
profileCreateName:SetPoint("TOPLEFT", profileCreateLabel, "BOTTOMLEFT", 0, -2)
profileCreateName:SetAutoFocus(false)
profileCreateName:SetJustifyH("CENTER")
profileCreateName:SetJustifyV("MIDDLE")
profileCreateName:SetScript("OnEnterPressed", function(self)
    local name = self:GetText():trim()
    if name ~= "" then
        if not SDT.profiles[name] then
            SDT.profiles[name] = { bars = {} }
        else
            StaticPopup_Show("SDT_PROFILE_ALREADY_EXISTS")
        end
    end
end)

StaticPopupDialogs["SDT_PROFILE_ALREADY_EXISTS"] = {
    text = "The profile name you have entered already exists. Please enter a new name.",
    button1 = "Ok",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

local profileSelectLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profileSelectLabel:SetPoint("LEFT", profileCreateLabel, "RIGHT", 100, 0)
profileSelectLabel:SetText("Existing Profile:")

local profileSelectDropdown = CreateFrame("Frame", addonName .. "_ProfileSelectDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
profileSelectDropdown:SetPoint("LEFT", profileCreateName, "RIGHT", 20, -4)
UIDropDownMenu_SetWidth(profileSelectDropdown, 140)

local function ProfileSelectDropdown_Init(self, level)
    for profileName in pairs(SDTDB.profiles) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = profileName
        info.func = function()
            SDT:SetActiveProfile(profileName)
            UIDropDownMenu_SetSelectedValue(profileSelectDropdown, profileName)
            UIDropDownMenu_SetText(profileSelectDropdown, profileName)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

local perSpecCheck = CreateFrame("CheckButton", nil, profilesSubPanel, "InterfaceOptionsCheckButtonTemplate")
perSpecCheck:SetPoint("TOPLEFT", profileCreateName, "BOTTOMLEFT", 0, -20)
perSpecCheck.Text:SetText("Enable Per-Spec Profiles")
perSpecCheck:SetChecked(SDT.SDTDB_CharDB.useSpecProfiles)
perSpecCheck:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.useSpecProfiles = self:GetChecked()
end)

local specOneLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
specOneLabel:SetPoint("TOPLEFT", perSpecCheck, "BOTTOMLEFT", 0, 0)
specOneLabel:SetText("")

local specOneDropdown = CreateFrame("Frame", addonName .. "_SpecOneDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
specOneDropdown:SetPoint("TOPLEFT", specOneLabel, "BOTTOMLEFT", -20, -4)
UIDropDownMenu_SetWidth(specOneDropdown, 120)

local specTwoLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
specTwoLabel:SetPoint("LEFT", specOneLabel, "LEFT", 150, 0)
specTwoLabel:SetText("")

local specTwoDropdown = CreateFrame("Frame", addonName .. "_SpecTwoDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
specTwoDropdown:SetPoint("LEFT", specOneDropdown, "RIGHT", -20, 0)
UIDropDownMenu_SetWidth(specTwoDropdown, 120)

local specThreeLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
specThreeLabel:SetPoint("LEFT", specTwoLabel, "LEFT", 150, 0)
specThreeLabel:SetText("")

local specThreeDropdown = CreateFrame("Frame", addonName .. "_SpecThreeDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
specThreeDropdown:SetPoint("LEFT", specTwoDropdown, "RIGHT", -20, 0)
UIDropDownMenu_SetWidth(specThreeDropdown, 120)

local specFourLabel
local specFourDropdown
if SDT.cache.playerClass == "DRUID" then
    specFourLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    specFourLabel:SetPoint("LEFT", specThreeLabel, "LEFT", 150, 0)
    specFourLabel:SetText("")

    specFourDropdown = CreateFrame("Frame", addonName .. "_SpecFourDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
    specFourDropdown:SetPoint("LEFT", specThreeDropdown, "RIGHT", -20, 0)
    UIDropDownMenu_SetWidth(specFourDropdown, 120)
end

local function UpdateProfileSpecs()
    local _, specOneName = GetSpecializationInfo(1)
    local _, specTwoName = GetSpecializationInfo(2)
    local _, specThreeName = GetSpecializationInfo(3)
    specOneLabel:SetText(specOneName..":")
    specTwoLabel:SetText(specTwoName..":")
    specThreeLabel:SetText(specThreeName..":")
    local specFourName
    if SDT.cache.playerClass == "DRUID" then
        _, specFourName = GetSpecializationInfo(4)
        specFourLabel:SetText(specFourName..":")
    end
end

-------------------------------------------------
-- Loader!
-------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self, event, arg)
    --if event == "ADDON_LOADED" and arg == addonName then        
    if event == "PLAYER_ENTERING_WORLD" then
        checkDefaultDB()

        UpdateProfileSpecs()

        -- Create and verify our fonts
        SDT.fonts = LSM:List("font")
        tsort(SDT.fonts)
        local currentFont = SDT.SDTDB_CharDB.settings.font
        local found = false
        for _, f in ipairs(SDT.fonts) do
            if f == currentFont then
                found = true
                break
            end
        end
        if not found then
            SDT.Print("Saved font not found. Resetting font to Friz Quadrata TT.")
            currentFont = "Friz Quadrata TT"
            SDT.SDTDB_CharDB.settings.font = currentFont
        end

        -- Sync settings after the addon is fully loaded
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
        UIDropDownMenu_Initialize(fontDropdown, FontDropdown_Initialize)
        UIDropDownMenu_SetSelectedValue(fontDropdown, currentFont)
        UIDropDownMenu_SetText(fontDropdown, currentFont)
        UIDropDownMenu_Initialize(profileSelectDropdown, ProfileSelectDropdown_Init)
        local activeProfile
        if SDT.SDTDB_CharDB.useSpecProfiles then
            local _, currentSpec = GetSpecializationInfo(GetSpecialization())
            activeProfile = SDT.SDTDB_CharDB.chosenProfile[currentSpec]
        else
            activeProfile = SDT.SDTDB_CharDB.chosenProfile.generic
        end
        UIDropDownMenu_SetSelectedValue(profileSelectDropdown, activeProfile)
        UIDropDownMenu_SetText(profileSelectDropdown, activeProfile)
        UIDropDownMenu_Initialize(specOneDropdown, ProfileSelectDropdown_Init)
        local _, specOne = GetSpecializationInfo(1)
        UIDropDownMenu_SetSelectedValue(specOneDropdown, SDT.SDTDB_CharDB.chosenProfile[specOne])
        UIDropDownMenu_SetText(specOneDropdown, SDT.SDTDB_CharDB.chosenProfile[specOne])
        UIDropDownMenu_Initialize(specTwoDropdown, ProfileSelectDropdown_Init)
        local _, specTwo = GetSpecializationInfo(2)
        UIDropDownMenu_SetSelectedValue(specTwoDropdown, SDT.SDTDB_CharDB.chosenProfile[specTwo])
        UIDropDownMenu_SetText(specTwoDropdown, SDT.SDTDB_CharDB.chosenProfile[specTwo])
        UIDropDownMenu_Initialize(specThreeDropdown, ProfileSelectDropdown_Init)
        local _, specThree = GetSpecializationInfo(3)
        UIDropDownMenu_SetSelectedValue(specThreeDropdown, SDT.SDTDB_CharDB.chosenProfile[specThree])
        UIDropDownMenu_SetText(specThreeDropdown, SDT.SDTDB_CharDB.chosenProfile[specThree])
        if SDT.cache.playerClass == "DRUID" then
            UIDropDownMenu_Initialize(specFourDropdown, ProfileSelectDropdown_Init)
            local _, specFour = GetSpecializationInfo(4)
            UIDropDownMenu_SetSelectedValue(specFourDropdown, SDT.SDTDB_CharDB.chosenProfile[specFour])
            UIDropDownMenu_SetText(specFourDropdown, SDT.SDTDB_CharDB.chosenProfile[specFour])
        end
        lockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.locked)
        classColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useClassColor)
        customColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useCustomColor)
        colorPickerButton:SetText(SDT.SDTDB_CharDB.settings.customColorHex)
        fontSizeSlider:SetValue(SDT.SDTDB_CharDB.settings.fontSize)
        fontSizeBox:SetText(tostring(SDT.SDTDB_CharDB.settings.fontSize))
        fontSizeBox:SetCursorPosition(0)

        -- Update modules to be safe
        SDT:UpdateAllModules()
    end
end)