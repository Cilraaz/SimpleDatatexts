local addonName, SDT = ...
local L = SDT.L
SDT.ModuleRegistry = {}

----------------------------------------------------
-- Helper function to add a separator/newline
----------------------------------------------------
function SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, label)
    self:AddModuleConfigSetting(moduleName, "header", label or " ", nil, nil)
end

----------------------------------------------------
-- Module Settings (for modules that need config)
----------------------------------------------------
function SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, settingType, label, settingKey, defaultValue, ...)
    -- Queue settings to be added to the config system
    SDT.queuedModuleSettings = SDT.queuedModuleSettings or {}
    SDT.queuedModuleSettings[moduleName] = SDT.queuedModuleSettings[moduleName] or {}
    
    local setting = {
        settingType = settingType,
        label = label,
        settingKey = settingKey,
        defaultValue = defaultValue,
    }

    -- Handle extra parameters for different setting types
    if settingType == "select" or settingType == "fontOutline" then
        setting.values = select(1, ...)
    elseif settingType == "range" or settingType == "fontSize" then
        setting.min = select(1, ...)
        setting.max = select(2, ...)
        setting.step = select(3, ...)
    elseif settingType == "description" then
        -- Description can have optional fontSize parameter
        setting.fontSize = select(1, ...) or "medium"
    end
    
    table.insert(SDT.queuedModuleSettings[moduleName], setting)
end

----------------------------------------------------
-- Create Module List
----------------------------------------------------
function SDT.ModuleRegistry:CreateModuleList()
    if SDT.cache.moduleNamesDirty or not SDT.cache.moduleNames then
        wipe(SDT.cache.moduleNames)
        for name in pairs(SDT.modules) do
            tinsert(SDT.cache.moduleNames, name)
        end
        table.sort(SDT.cache.moduleNames)
        SDT.cache.moduleNamesDirty = false
    end
end

----------------------------------------------------
-- Module Settings Exclusions
----------------------------------------------------
--[[ Note: Not currently excluding any modules, but keeping the framework.
SDT.ModuleRegistry.excludedModules = {
    ["HidingBar1"] = true,
}

function SDT.ModuleRegistry:ExcludedModule(moduleName)
    if self.excludedModules[moduleName] then return true end
    return false
end]]

----------------------------------------------------
-- Get Module Frame Strata
----------------------------------------------------
function SDT.ModuleRegistry:GetModuleFrameStrata(moduleName)
    local strata = SDT:GetModuleSetting(moduleName, "frameStrata", "MEDIUM")
    -- Validate strata value
    if not SDT.cache.validStratas[strata] then
        return "MEDIUM"
    end
    return strata
end

----------------------------------------------------
-- Global Module Settings
----------------------------------------------------
function SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
    -- Text Settings
    SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, L["Text Color"])
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Override Text Color"], "overrideTextColor", false)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "color", L["Text Custom Color"], "customTextColor", "#FFFFFF")

	-- Font Settings
    SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, L["Font Settings"])
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Override Global Font"], "overrideFont", false)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "font", L["Display Font:"], "font", "Friz Quadrata TT")
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "fontSize", L["Font Size"], "fontSize", 12, 4, 40, 1)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "fontOutline", L["Font Outline"], "fontOutline", "NONE", {
        ["NONE"] = L["None"],
        ["OUTLINE"] = "Outline",
        ["THICKOUTLINE"] = "Thick Outline",
        ["MONOCHROME"] = "Monochrome",
        ["OUTLINE, MONOCHROME"] = "Outline + Monochrome",
        ["THICKOUTLINE, MONOCHROME"] = "Thick Outline + Monochrome",
    })

	-- Slot Controls
    SDT.ModuleRegistry:AddModuleConfigSeparator(moduleName, L["Slot Controls"])
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "anchorPoint", L["Anchor Point"], "anchorPoint", "CENTER")
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "frameStrata", L["Frame Strata"], "frameStrata", "MEDIUM")
end

----------------------------------------------------
-- Module Registration
----------------------------------------------------
function SDT.ModuleRegistry:RegisterDatatext(name, module)
    SDT.modules[name] = module
    SDT.cache.moduleNamesDirty = true
end

----------------------------------------------------
-- Update Frame Strata for Active Modules
----------------------------------------------------
function SDT.ModuleRegistry:UpdateAllModuleStrata()
    -- Iterate through all bars and their slots
    for _, bar in pairs(SDT.bars) do
        if bar.slots then
            for _, slot in ipairs(bar.slots) do
                -- Only update slots that have an active module
                if slot.module and slot.module ~= "(spacer)" and SDT.modules[slot.module] then
                    local strata = SDT.ModuleRegistry:GetModuleFrameStrata(slot.module)
                    
                    -- Set strata on the slot itself (parent frame)
                    slot:SetFrameStrata(strata)
                    
                    -- Set strata on module frame if it exists
                    if slot.moduleFrame then
                        slot.moduleFrame:SetFrameStrata(strata)
                    end
                    
                    -- Set strata on secure button if it exists
                    if slot.secureButton then
                        slot.secureButton:SetFrameStrata(strata)
                    end
                end
            end
        end
    end
end

----------------------------------------------------
-- Update All Modules
----------------------------------------------------
function SDT.ModuleRegistry:UpdateAllModules()
    for _, bar in pairs(SDT.bars) do
        if bar and bar.slots then
            for _, slot in ipairs(bar.slots) do
                if slot.moduleFrame and slot.moduleFrame.Update then
                    slot.moduleFrame:Update()
                end
            end
        end
    end
end