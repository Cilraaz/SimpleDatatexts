-- Settings Panel

----------------------------------------------------
-- Addon Locals
----------------------------------------------------
local addonName, SDT = ...
local L = SDT.L

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format           = string.format
local mathfloor        = math.floor
local mathmax          = math.max
local tonumber         = tonumber
local tostring         = tostring
local tsort            = table.sort

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local CreateFrame      = CreateFrame
local GetScreenWidth   = GetScreenWidth

----------------------------------------------------
-- File Locals
----------------------------------------------------
local charKey = SDT:GetCharKey()
local MAX_VISIBLE_SLOTS = 5
local SLOT_HEIGHT = 50

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
-- Create Borders List
----------------------------------------------------
local borderList = LSM:HashTable("border")
local sortedBorderNames = {}

for name in pairs(borderList) do
    if name ~= "None" then
        sortedBorderNames[#sortedBorderNames+1] = name
    end
end
tsort(sortedBorderNames)

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
                        bgOpacity = 50,
                        border = "None",
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
panel.name = L["Simple DataTexts"]
SDT.SettingsPanel = panel

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(panel.name)

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
--category.ID = panel.name
SDT.SettingsPanel.ID = category.ID
Settings.RegisterAddOnCategory(category)

-------------------------------------------------
-- Settings Sub-Panels
-------------------------------------------------
local globalSubPanel = CreateFrame("Frame", addonName .. "_GlobalSubPanel", UIParent)
globalSubPanel.name = L["Global"]
globalSubPanel.parent = panel.name
SDT.GlobalSubPanel = globalSubPanel

local globalTitle = globalSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
globalTitle:SetPoint("TOPLEFT", 16, -16)
globalTitle:SetText(L["Simple DataTexts - Global Settings"])

local globalVersion = globalSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
globalVersion:SetPoint("TOPRIGHT", -16, -17)
globalVersion:SetText("v" .. SDT.cache.version)

local globalCategory = Settings.RegisterCanvasLayoutSubcategory(category, globalSubPanel, L["Global"])
Settings.RegisterAddOnCategory(globalCategory)

local panelsSubPanel = CreateFrame("Frame", addonName .. "_PanelsSubPanel", UIParent)
panelsSubPanel.name = L["Panels"]
panelsSubPanel.parent = panel.name
SDT.PanelsSubPanel = panelsSubPanel

local slotScrollFrame = CreateFrame(
    "ScrollFrame",
    addonName .. "_SlotScrollFrame",
    panelsSubPanel,
    "UIPanelScrollFrameTemplate"
)

slotScrollFrame:SetPoint("TOPLEFT", panelsSubPanel, "TOPLEFT", 315, -290)
slotScrollFrame:SetPoint("BOTTOMRIGHT", panelsSubPanel, "BOTTOMRIGHT", -30, 20)
slotScrollFrame:SetHeight(MAX_VISIBLE_SLOTS * SLOT_HEIGHT)

local slotScrollChild = CreateFrame("Frame", nil, slotScrollFrame)
slotScrollChild:SetSize(1, 1)
slotScrollFrame:SetScrollChild(slotScrollChild)

slotScrollFrame:EnableMouseWheel(true)
slotScrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local newValue = self:GetVerticalScroll() - delta * 30
    newValue = math.max(0, math.min(newValue, self:GetVerticalScrollRange()))
    self:SetVerticalScroll(newValue)
end)

slotScrollFrame:Hide()
slotScrollFrame.ScrollBar:Hide()
slotScrollFrame:SetVerticalScroll(0)

local panelsTitle = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
panelsTitle:SetPoint("TOPLEFT", 16, -16)
panelsTitle:SetText(L["Simple DataTexts - Panel Settings"])

local panelsVersion = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
panelsVersion:SetPoint("TOPRIGHT", -16, -17)
panelsVersion:SetText("v" .. SDT.cache.version)

local panelsCategory = Settings.RegisterCanvasLayoutSubcategory(category, panelsSubPanel, L["Panels"])
Settings.RegisterAddOnCategory(panelsCategory)

local profilesSubPanel = CreateFrame("Frame", addonName .. "_ProfilesSubPanel", UIParent)
profilesSubPanel.name = L["Profiles"]
profilesSubPanel.parent = panel.name
SDT.ProfilesSubPanel = profilesSubPanel

local profilesTitle = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
profilesTitle:SetPoint("TOPLEFT", 16, -16)
profilesTitle:SetText(L["Simple DataTexts - Profile Settings"])

local profilesVersion = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profilesVersion:SetPoint("TOPRIGHT", -16, -17)
profilesVersion:SetText("v" .. SDT.cache.version)

local profilesCategory = Settings.RegisterCanvasLayoutSubcategory(category, profilesSubPanel, L["Profiles"])
Settings.RegisterAddOnCategory(profilesCategory)

-------------------------------------------------
-- Global Settings
-------------------------------------------------
local lockCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
lockCheckbox:SetPoint("TOPLEFT", globalTitle, "BOTTOMLEFT", 0, -20)
lockCheckbox.Text:SetText(L["Lock Panels (disable movement)"])
lockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.locked)
lockCheckbox:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.settings.locked = self:GetChecked()
end)

local classColorCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
classColorCheckbox:SetPoint("TOPLEFT", lockCheckbox, "BOTTOMLEFT", 0, -20)
classColorCheckbox.Text:SetText(L["Use Class Color"])
classColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useClassColor)

local use24HourClockCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
use24HourClockCheckbox:SetPoint("LEFT", classColorCheckbox, "RIGHT", 100, 0)
use24HourClockCheckbox.Text:SetText(L["Use 24Hr Clock"])
use24HourClockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.use24HourClock)
use24HourClockCheckbox:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.settings.use24HourClock = self:GetChecked()
    SDT:UpdateAllModules()
end)

local customColorCheckbox = CreateFrame("CheckButton", nil, globalSubPanel, "InterfaceOptionsCheckButtonTemplate")
customColorCheckbox:SetPoint("TOPLEFT", classColorCheckbox, "BOTTOMLEFT", 0, -20)
customColorCheckbox.Text:SetText(L["Use Custom Color"])
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
fontLabel:SetText(L["Display Font:"])

local fontDropdown = CreateFrame("Frame", addonName .. "_FontDropdown", globalSubPanel, "UIDropDownMenuTemplate")
fontDropdown:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", -20, -4)
UIDropDownMenu_SetWidth(fontDropdown, 160)

local fontSizeSlider = CreateFrame("Slider", addonName.."_FontSizeSlider", globalSubPanel, "OptionsSliderTemplate")
fontSizeSlider:SetPoint("TOPLEFT", fontDropdown, "BOTTOMLEFT", 20, -20)
fontSizeSlider:SetMinMaxValues(4, 40)
fontSizeSlider:SetValueStep(1)
fontSizeSlider:SetWidth(160)
getglobal(fontSizeSlider:GetName().."Text"):SetText(L["Font Size"])
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
    self:ClearFocus()
end)

-------------------------------------------------
-- Panels Settings - Left Column
-------------------------------------------------
local addBarButton = CreateFrame("Button", nil, panelsSubPanel, "UIPanelButtonTemplate")
addBarButton:SetPoint("TOPLEFT", panelsTitle, "BOTTOMLEFT", 0, -20)
addBarButton:SetSize(160, 24)
addBarButton:SetText(L["Create New Panel"])

-- Panel Selector
local panelLabel = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
panelLabel:SetPoint("TOPLEFT", addBarButton, "BOTTOMLEFT", 0, -16)
panelLabel:SetText(L["Select Panel:"])
local panelDropdown = CreateFrame("Frame", addonName .. "_PanelDropdown", panelsSubPanel, "UIDropDownMenuTemplate")
panelDropdown:SetPoint("TOPLEFT", panelLabel, "BOTTOMLEFT", -20, -6)
UIDropDownMenu_SetWidth(panelDropdown, 160)

-- Rename Panel
local renameLabel = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
renameLabel:SetPoint("TOPLEFT", panelDropdown, "BOTTOMLEFT", 20, -16)
renameLabel:SetText(L["Rename Panel:"])
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
    self:ClearFocus()
end)

-------------------------------------------------
-- Panels Settings - Right Column
-------------------------------------------------
local removeBarButton = CreateFrame("Button", nil, panelsSubPanel, "UIPanelButtonTemplate")
removeBarButton:SetSize(160, 24)
removeBarButton:SetPoint("LEFT", addBarButton, "RIGHT", 140, 0)
removeBarButton:SetText(L["Remove Selected Panel"])
removeBarButton:Hide()

local slotSelectors = {}
local function buildSlotSelectors(barName)
    for _, f in ipairs(slotSelectors) do f:Hide() end
    slotSelectors = {}

    local b = SDT.profileBars[barName]
    if not b then return end

    for i = 1, b.numSlots do
        local lbl = MakeLabel(slotScrollChild, format(L["Slot %d:"], i), "TOPLEFT", 320, -300 - ((i - 1) * 50))
        local dd = CreateFrame("Frame", addonName .. "_SlotSel_" .. i, slotScrollChild, "UIDropDownMenuTemplate")
        lbl:SetPoint("TOPLEFT", slotScrollChild, "TOPLEFT", 0, -((i - 1) * 50))
        dd:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", -15, -6)
        UIDropDownMenu_SetWidth(dd, 140)

        UIDropDownMenu_Initialize(dd, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.text = L["(empty)"]
            info.func = function()
                SDT.profileBars[barName].slots[i] = nil
                UIDropDownMenu_SetText(dd, L["(empty)"])
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

        UIDropDownMenu_SetText(dd, b.slots[i] or L["(empty)"])
        table.insert(slotSelectors, lbl)
        table.insert(slotSelectors, dd)
    end

    local totalHeight = b.numSlots * SLOT_HEIGHT + 10
    slotScrollChild:SetHeight(totalHeight)

    if b.numSlots > MAX_VISIBLE_SLOTS then
        slotScrollFrame:Show()
        slotScrollFrame.ScrollBar:Show()
    else
        slotScrollFrame.ScrollBar:Hide()
        slotScrollFrame:SetVerticalScroll(0)
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

        -- Do nothing if the value didn't change
        if self._lastValue == val then return end
        self._lastValue = val

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
            elseif name == "Border Size" then
                barData.borderSize = val
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
            val = mathmax(min, math.min(max, val))
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
        self:ClearFocus()
    end)
    
    return slider, eb
end

-- Create sliders
local scaleSlider, scaleBox = CreateSliderWithBox(panelsSubPanel, "Scale", L["Scale"], 50, 500, 1, removeBarButton, 5, -30)
local opacitySlider, opacityBox = CreateSliderWithBox(panelsSubPanel, "Background Opacity", L["Background Opacity"], 0, 100, 1, scaleSlider, 0, -20)
local slotSlider, slotBox = CreateSliderWithBox(panelsSubPanel, "Slots", L["Slots"], 1, 12, 1, opacitySlider, 0, -20)
local widthSlider, widthBox = CreateSliderWithBox(panelsSubPanel, "Width", L["Width"], 100, mathfloor(GetScreenWidth()), 1, slotSlider, 0, -20)
local heightSlider, heightBox = CreateSliderWithBox(panelsSubPanel, "Height", L["Height"], 16, 128, 1, widthSlider, 0, -20)

-- Store sliders in the SDT namespace for accessibility
SDT.UI = SDT.UI or {}
SDT.UI.lockCheckbox = lockCheckbox
SDT.UI.scaleSlider = scaleSlider
SDT.UI.scaleBox = scaleBox
SDT.UI.widthSlider = widthSlider
SDT.UI.widthBox = widthBox
SDT.UI.heightSlider = heightSlider
SDT.UI.heightBox = heightBox

local borderLabel = panelsSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
borderLabel:SetPoint("TOPLEFT", nameEditBox, "BOTTOMLEFT", -5, -20)
borderLabel:SetText(L["Select Border:"])
borderLabel:Hide()
local borderDropdown = CreateFrame("Frame", addonName .. "_BorderDropdown", panelsSubPanel, "UIDropDownMenuTemplate")
borderDropdown:SetPoint("TOPLEFT", borderLabel, "BOTTOMLEFT", -20, -6)
UIDropDownMenu_SetWidth(borderDropdown, 160)
borderDropdown:Hide()

local borderSizeSlider, borderSizeBox = CreateSliderWithBox(panelsSubPanel, "Border Size", L["Border Size"], 1, 40, 1, borderDropdown, 30, -20)

local borderColorPicker = CreateFrame("Button", nil, panelsSubPanel, "UIPanelButtonTemplate")
borderColorPicker:SetPoint("LEFT", borderDropdown, "RIGHT", -2, 2)
borderColorPicker:SetSize(80, 24)
borderColorPicker:SetScript("OnShow", function(self)
    self:SetText(SDT.profileBars[panelsSubPanel.selectedBar].borderColor or "#000000")
end)
borderColorPicker:Hide()

local function showBorderColorPicker()
    ColorPickerFrame:Hide()

    local currColor = SDT.profileBars[panelsSubPanel.selectedBar].borderColor or "#ffffff"
    local initColor = currColor:gsub("#", "")
    local initR = tonumber(initColor:sub(1, 2), 16) / 255
    local initG = tonumber(initColor:sub(3, 4), 16) / 255
    local initB = tonumber(initColor:sub(5, 6), 16) / 255

    local function onColorPicked()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        SDT.profileBars[panelsSubPanel.selectedBar].borderColor = format("#%02X%02X%02X", r*255, g*255, b*255)
        SDT.bars[panelsSubPanel.selectedBar]:ApplyBackground()
        borderColorPicker:SetText(SDT.profileBars[panelsSubPanel.selectedBar].borderColor)
    end

    local function onCancel()
        SDT.profileBars[panelsSubPanel.selectedBar].borderColor = format("#%02X%02X%02X", initR*255, initG*255, initB*255)
        SDT.bars[panelsSubPanel.selectedBar]:ApplyBackground()
        borderColorPicker:SetText(SDT.profileBars[panelsSubPanel.selectedBar].borderColor)
    end

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

borderColorPicker:SetScript("OnClick", function()
    showBorderColorPicker()
end)

local function BorderDropdown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = "None"
    info.func = function()
        SDT.profileBars[panelsSubPanel.selectedBar].borderName = "None"
        SDT.profileBars[panelsSubPanel.selectedBar].border = "None"
        UIDropDownMenu_SetSelectedName(borderDropdown, "None")
        UIDropDownMenu_SetText(borderDropdown, "None")
        SDT.bars[panelsSubPanel.selectedBar]:ApplyBackground()
        borderSizeSlider:Hide()
        borderSizeBox:Hide()
        borderColorPicker:Hide()
    end
    UIDropDownMenu_AddButton(info)
    for _, name in ipairs(sortedBorderNames) do
        info = UIDropDownMenu_CreateInfo()
        info.text = name
        info.func = function()
            local border = borderList[name]
            SDT.profileBars[panelsSubPanel.selectedBar].borderName = name
            SDT.profileBars[panelsSubPanel.selectedBar].border = border
            UIDropDownMenu_SetSelectedName(borderDropdown, name)
            UIDropDownMenu_SetText(borderDropdown, name)
            SDT.bars[panelsSubPanel.selectedBar]:ApplyBackground()
            borderSizeSlider:Show()
            borderSizeBox:Show()
            borderColorPicker:Show()
        end
        UIDropDownMenu_AddButton(info)
    end
end

-- Panel dropdown initializer
local function PanelDropdown_Initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for barName, _ in pairs(SDT.profileBars) do
        local displayName = SDT.profileBars[barName].name or barName
        info.text = displayName
        info.func = function()
            UIDropDownMenu_SetText(panelDropdown, displayName)
            panelsSubPanel.selectedBar = barName
            SDT:UpdateSelectedBarControls()
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
function SDT:UpdateSelectedBarControls()
    local barName = panelsSubPanel.selectedBar
    if not barName then
        removeBarButton:Hide()
        borderLabel:Hide()
        borderDropdown:Hide()
        borderSizeSlider:Hide()
        borderSizeBox:Hide()
        borderColorPicker:Hide()
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
        slotScrollFrame:Hide()
        slotScrollFrame.ScrollBar:Hide()
        slotScrollFrame:SetVerticalScroll(0)
        for _, f in ipairs(slotSelectors) do f:Hide() end
        return
    end

    removeBarButton:Show()
    borderLabel:Show()
    borderDropdown:Show()
    if not SDT.profileBars[barName].borderName or SDT.profileBars[barName].borderName == "None" then
        borderSizeSlider:Hide()
        borderSizeBox:Hide()
        borderColorPicker:Hide()
    else
        borderSizeSlider:Show()
        borderSizeBox:Show()
        borderColorPicker:Show()
        borderColorPicker:SetText(SDT.profileBars[barName].borderColor or "#000000")
    end
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
    slotScrollFrame:Show()

    local b = SDT.profileBars[barName]
    if not b then return end

    -- Border
    UIDropDownMenu_Initialize(borderDropdown, BorderDropdown_Initialize)
    UIDropDownMenu_SetSelectedName(borderDropdown, b.borderName or "None")
    UIDropDownMenu_SetText(borderDropdown, b.borderName or "None")

    -- Border Size
    local borderSize = b.borderSize or 8
    borderSizeSlider:SetValue(borderSize)
    borderSizeBox:SetText(borderSize)

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
    SDT.profileBars[name] = { numSlots = 3, slots = {}, bgOpacity = 50, border = "None", width = 300, height = 22 }
    SDT:CreateDataBar(id, 3)
    UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
    UIDropDownMenu_SetText(panelDropdown, name)
    panelsSubPanel.selectedBar = name
    SDT:UpdateSelectedBarControls()
end)

-- Remove selected panel
removeBarButton:SetScript("OnClick", function()
    local barName = panelsSubPanel.selectedBar
    if not barName then return end

    StaticPopup_Show("SDT_CONFIRM_DELETE_BAR", nil, nil, barName)
end)

-- Confirmation Pop-up
StaticPopupDialogs["SDT_CONFIRM_DELETE_BAR"] = {
    text = L["Are you sure you want to delete this bar?\nThis action cannot be undone."],
    button1 = L["Yes"],
    button2 = L["No"],
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
        UIDropDownMenu_SetText(panelDropdown, L["(none)"])
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)

        for _, f in ipairs(slotSelectors) do f:Hide() end
        slotSelectors = {}

        removeBarButton:Hide()
        borderLabel:Hide()
        borderDropdown:Hide()
        borderSizeSlider:Hide()
        borderSizeBox:Hide()
        borderColorPicker:Hide()
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
profileCreateLabel:SetText(L["Create New Profile:"])

local profileCreateName = CreateFrame("EditBox", nil, profilesSubPanel, "InputBoxTemplate")
profileCreateName:SetSize(160, 24)
profileCreateName:SetPoint("TOPLEFT", profileCreateLabel, "BOTTOMLEFT", 0, -2)
profileCreateName:SetAutoFocus(false)
profileCreateName:SetJustifyH("CENTER")
profileCreateName:SetJustifyV("MIDDLE")

local profileSelectLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
profileSelectLabel:SetPoint("LEFT", profileCreateLabel, "RIGHT", 100, 0)
profileSelectLabel:SetText(L["Current Profile:"])

local profileSelectDropdown = CreateFrame("Frame", addonName .. "_ProfileSelectDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
profileSelectDropdown:SetPoint("LEFT", profileCreateName, "RIGHT", 20, -4)
UIDropDownMenu_SetWidth(profileSelectDropdown, 140)

local perSpecCheck = CreateFrame("CheckButton", nil, profilesSubPanel, "InterfaceOptionsCheckButtonTemplate")
perSpecCheck:SetPoint("TOPLEFT", profileCreateName, "BOTTOMLEFT", 0, -20)
perSpecCheck.Text:SetText(L["Enable Per-Spec Profiles"])
perSpecCheck:SetChecked(false)
perSpecCheck:SetScript("OnClick", function(self)
    SDT.SDTDB_CharDB.useSpecProfiles = self:GetChecked()
    if SDT.SDTDB_CharDB.useSpecProfiles then
        local specNum = GetSpecialization()
        local _, specName = GetSpecializationInfo(specNum)
        SDT:ProfileActivate(SDT.SDTDB_CharDB.chosenProfile[specName], specName)
    else
        SDT:ProfileActivate(SDT.SDTDB_CharDB.chosenProfile.generic, "generic")
    end
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

local copyProfileLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
copyProfileLabel:SetPoint("TOPLEFT", specOneDropdown, "BOTTOMLEFT", 20, -20)
copyProfileLabel:SetText(L["Copy Profile:"])

local copyProfileDropdown = CreateFrame("Frame", addonName .. "_CopyProfileDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
copyProfileDropdown:SetPoint("TOPLEFT", copyProfileLabel, "BOTTOMLEFT", -20, -4)
UIDropDownMenu_SetWidth(copyProfileDropdown, 120)
UIDropDownMenu_SetSelectedName(copyProfileDropdown, "")
UIDropDownMenu_SetText(copyProfileDropdown, "")

local deleteProfileLabel = profilesSubPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
deleteProfileLabel:SetPoint("TOPLEFT", copyProfileDropdown, "BOTTOMLEFT", 20, -20)
deleteProfileLabel:SetText(L["Delete Profile:"])

local deleteProfileDropdown = CreateFrame("Frame", addonName .. "_DeleteProfileDropdown", profilesSubPanel, "UIDropDownMenuTemplate")
deleteProfileDropdown:SetPoint("TOPLEFT", deleteProfileLabel, "BOTTOMLEFT", -20, -4)
UIDropDownMenu_SetWidth(deleteProfileDropdown, 120)
UIDropDownMenu_SetSelectedName(deleteProfileDropdown, "")
UIDropDownMenu_SetText(deleteProfileDropdown, "")

local function UpdateProfileSpecs()
    local _, specOneName = GetSpecializationInfo(1)
    local _, specTwoName = GetSpecializationInfo(2)
    local _, specThreeName = GetSpecializationInfo(3)
    specOneLabel:SetText(specOneName..":")
    specTwoLabel:SetText(specTwoName..":")
    -- If on 11.2.7 Retail, DH doesn't yet have 3 specs.
    -- This can be removed once 12.0 hits.
    if specThreeName then
        specThreeLabel:SetText(specThreeName..":")
    else
        specThreeLabel:SetText(L["NYI:"])
    end
    local specFourName
    if SDT.cache.playerClass == "DRUID" then
        _, specFourName = GetSpecializationInfo(4)
        specFourLabel:SetText(specFourName..":")
    end
end

local function ProfileSelectDropdown_Init(self, level)
    local sortedProfiles = {}
    for profileText in pairs(SDTDB.profiles) do
        tinsert(sortedProfiles, profileText)
    end
    tsort(sortedProfiles)
    for _, profileName in pairs(sortedProfiles) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = profileName
        info.func = function()
            local dropdownName = self:GetName()
            local spec = "generic"
            if dropdownName == "SimpleDatatexts_SpecOneDropdown" then
                spec = specOneLabel:GetText():gsub(":$", "")
            elseif dropdownName == "SimpleDatatexts_SpecTwoDropdown" then
                spec = specTwoLabel:GetText():gsub(":$", "")
            elseif dropdownName == "SimpleDatatexts_SpecThreeDropdown" then
                spec = specThreeLabel:GetText():gsub(":$", "")
            elseif dropdownName == "SimpleDatatexts_SpecFourDropdown" then
                spec = specFourLabel:GetText():gsub(":$", "")
            end
            SDT:ProfileActivate(profileName, spec)
            UIDropDownMenu_SetSelectedValue(self, profileName)
            UIDropDownMenu_SetText(self, profileName)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

local function ProfileCopyDropdown_Init(self, level)
    local blankEntry = UIDropDownMenu_CreateInfo()
    blankEntry.text = ""
    UIDropDownMenu_AddButton(blankEntry, level)
    local sortedProfiles = {}
    for profileText in pairs(SDTDB.profiles) do
        tinsert(sortedProfiles, profileText)
    end
    tsort(sortedProfiles)
    for _, profileName in pairs(sortedProfiles) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = profileName
        info.func = function()
            SDT:ProfileCopy(profileName)
            UIDropDownMenu_SetSelectedName(self, "")
            UIDropDownMenu_SetText(self, "")
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

local function ProfileDeleteDropdown_Init(self, level)
    local blankEntry = UIDropDownMenu_CreateInfo()
    blankEntry.text = ""
    UIDropDownMenu_AddButton(blankEntry, level)
    local sortedProfiles = {}
    for profileText in pairs(SDTDB.profiles) do
        tinsert(sortedProfiles, profileText)
    end
    tsort(sortedProfiles)
    for _, profileName in pairs(sortedProfiles) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = profileName
        info.func = function()
            SDT:ProfileDelete(profileName)
            UIDropDownMenu_SetSelectedName(self, "")
            UIDropDownMenu_SetText(self, "")
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

profileCreateName:SetScript("OnEnterPressed", function(self)
    local name = self:GetText():trim()
    if name and name ~= "" then
        if not SDTDB.profiles[name] then
            SDT:ProfileCreate(name)
        else
            StaticPopup_Show("SDT_PROFILE_ALREADY_EXISTS")
            return
        end
    end
    self:SetText("")
    self:ClearFocus()
    UIDropDownMenu_Initialize(profileSelectDropdown, ProfileSelectDropdown_Init)
    UIDropDownMenu_SetSelectedValue(profileSelectDropdown, name)
    UIDropDownMenu_SetText(profileSelectDropdown, name)
end)

StaticPopupDialogs["SDT_PROFILE_ALREADY_EXISTS"] = {
    text = L["The profile name you have entered already exists. Please enter a new name."],
    button1 = L["Ok"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

function SDT:UpdateActiveProfile(profileName, spec)
    if spec == "generic" then
        UIDropDownMenu_SetSelectedValue(profileSelectDropdown, profileName)
        UIDropDownMenu_SetText(profileSelectDropdown, profileName)
    else
        local ddList = { specOneDropdown, specTwoDropdown, specThreeDropdown, specFourDropdown }
        for i = 1, GetNumSpecializations() do
            local _, specName = GetSpecializationInfo(i)
            if specName == spec then
                UIDropDownMenu_SetSelectedValue(ddList[i], profileName)
                UIDropDownMenu_SetText(ddList[i], profileName)
            end
        end
    end
end

function SDT:RefreshProfileList()
    UIDropDownMenu_Initialize(profileSelectDropdown, ProfileSelectDropdown_Init)
    UIDropDownMenu_SetSelectedValue(profileSelectDropdown, SDT.activeProfile)
    UIDropDownMenu_SetText(profileSelectDropdown, SDT.activeProfile)
    UIDropDownMenu_Initialize(specOneDropdown, ProfileSelectDropdown_Init)
    UIDropDownMenu_Initialize(specTwoDropdown, ProfileSelectDropdown_Init)
    UIDropDownMenu_Initialize(specThreeDropdown, ProfileSelectDropdown_Init)
    UIDropDownMenu_Initialize(copyProfileDropdown, ProfileCopyDropdown_Init)
    UIDropDownMenu_Initialize(deleteProfileDropdown, ProfileDeleteDropdown_Init)

    UIDropDownMenu_Refresh(profileSelectDropdown)
    UIDropDownMenu_Refresh(specOneDropdown)
    UIDropDownMenu_Refresh(specTwoDropdown)
    UIDropDownMenu_Refresh(specThreeDropdown)
    UIDropDownMenu_Refresh(copyProfileDropdown)
    UIDropDownMenu_Refresh(deleteProfileDropdown)

    if SDT.cache.playerClass == "DRUID" then
        UIDropDownMenu_Initialize(specFourDropdown, ProfileSelectDropdown_Init)
        UIDropDownMenu_Refresh(specFourDropdown)
    end

    UIDropDownMenu_SetSelectedName(copyProfileDropdown, "")
    UIDropDownMenu_SetText(copyProfileDropdown, "")
    UIDropDownMenu_SetSelectedName(deleteProfileDropdown, "")
    UIDropDownMenu_SetText(deleteProfileDropdown, "")
end
-------------------------------------------------
-- Spec Switch Watcher
-------------------------------------------------
local specSwitchWatcher = CreateFrame("Frame")
specSwitchWatcher:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
specSwitchWatcher:SetScript("OnEvent", function(self, event, arg)
    local dbInfo = SDTDB[SDT:GetCharKey()]
    if dbInfo.useSpecProfiles then
        local _, specName = GetSpecializationInfo(GetSpecialization())
        SDT:ProfileActivate(dbInfo.chosenProfile[specName], specName)
    end
end)

-------------------------------------------------
-- Loader!
-------------------------------------------------
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", function(self, event, arg)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Reset widthSlider's max width once the UI is initialized
        local maxWidth = mathfloor(GetScreenWidth())
        widthSlider:SetMinMaxValues(100, maxWidth)
        getglobal(widthSlider:GetName().."High"):SetText(tostring(maxWidth))

        -- Check our database
        checkDefaultDB()

        -- Update the available specs for this character
        UpdateProfileSpecs()

        -- Set our profile variable
        local profileName
        local dbInfo = SDTDB[SDT:GetCharKey()]
        if dbInfo.useSpecProfiles then
            local _, currentSpec = GetSpecializationInfo(GetSpecialization())
            profileName = dbInfo.chosenProfile[currentSpec]
        else
            profileName = dbInfo.chosenProfile.generic
        end
        SDT.profileBars = SDTDB.profiles[profileName].bars
        SDT.activeProfile = profileName

        -- If no bars exist, create our first bar
        if not next(SDT.profileBars) then
            SDT.profileBars["SDT_Bar1"] = { numSlots = 3, slots = {}, bgOpacity = 50, border = "None", width = 300, height = 22 }
        end

        -- Create our bars
        for barName, data in pairs(SDT.profileBars) do
            local id = tonumber(barName:match("SDT_Bar(%d+)") or "0")
            if id > 0 and not SDT.bars[barName] then
                SDT:CreateDataBar(id, data.numSlots)
            end
        end

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
            SDT.Print(L["Saved font not found. Resetting font to Friz Quadrata TT."])
            currentFont = "Friz Quadrata TT"
            SDT.SDTDB_CharDB.settings.font = currentFont
        end

        -- Sync settings after the addon is fully loaded
        UIDropDownMenu_Initialize(panelDropdown, PanelDropdown_Initialize)
        UIDropDownMenu_Initialize(fontDropdown, FontDropdown_Initialize)
        UIDropDownMenu_SetSelectedValue(fontDropdown, currentFont)
        UIDropDownMenu_SetText(fontDropdown, currentFont)
        UIDropDownMenu_Initialize(borderDropdown, BorderDropdown_Initialize)
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
        UIDropDownMenu_Initialize(copyProfileDropdown, ProfileCopyDropdown_Init)
        UIDropDownMenu_Initialize(deleteProfileDropdown, ProfileDeleteDropdown_Init)
        lockCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.locked)
        classColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useClassColor)
        customColorCheckbox:SetChecked(SDT.SDTDB_CharDB.settings.useCustomColor)
        colorPickerButton:SetText(SDT.SDTDB_CharDB.settings.customColorHex)
        fontSizeSlider:SetValue(SDT.SDTDB_CharDB.settings.fontSize)
        fontSizeBox:SetText(tostring(SDT.SDTDB_CharDB.settings.fontSize))
        fontSizeBox:SetCursorPosition(0)
        perSpecCheck:SetChecked(SDT.SDTDB_CharDB.useSpecProfiles)

        -- Update modules to be safe
        SDT:UpdateAllModules()
    end
end)
