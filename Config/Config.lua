-- Config.lua - AceConfig GUI
local addonName, SDT = ...
local L = SDT.L

----------------------------------------------------
-- Helper Functions
----------------------------------------------------
local function GetBorderList()
    local borderList = SDT.LSM:HashTable("border")
    local sortedBorderNames = {}
    
    for name in pairs(borderList) do
        if name ~= "None" then
            sortedBorderNames[#sortedBorderNames+1] = name
        end
    end
    table.sort(sortedBorderNames)
    
    local borders = { ["None"] = "None" }
    for _, name in ipairs(sortedBorderNames) do
        borders[name] = name
    end
    
    return borders
end

local function GetBarList()
    local bars = {}
    for barName, barData in pairs(SDT.db.profile.bars) do
        bars[barName] = barData.name or barName
    end
    return bars
end

local function GetModuleList()
    local modules = { [""] = L["(empty)"], ["(spacer)"] = L["(spacer)"] }
    for _, name in ipairs(SDT.cache.moduleNames) do
        modules[name] = name
    end
    return modules
end

----------------------------------------------------
-- Register Config
----------------------------------------------------
function SDT:RegisterConfig()
    local AceConfig = LibStub("AceConfig-3.0")
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    local AceDBOptions = LibStub("AceDBOptions-3.0")
    
    -- Main options table
    local options = {
        type = "group",
        name = format("%s - %s: |cff8888ff%s|r", L["Simple Datatexts"], L["Version"], SDT.cache.version),
        childGroups = "tab",
        args = {
            general = self:GetGeneralOptions(),
            panels = self:GetPanelOptions(),
            modules = self:GetModuleOptions(),
            profiles = self:GetProfileOptions(),
            importexport = self:GetImportExportOptions(),
        }
    }
    
    -- Register options
    AceConfig:RegisterOptionsTable("SimpleDatatexts", options)
    
    -- Create dialog
    self.configDialog = AceConfigDialog:AddToBlizOptions("SimpleDatatexts", "Simple DataTexts")
    
    -- Register as standalone dialog too
    AceConfigDialog:SetDefaultSize("SimpleDatatexts", 850, 650)
end

----------------------------------------------------
-- Rebuild Config (for dynamic updates)
----------------------------------------------------
function SDT:RebuildConfig()
    local AceConfig = LibStub("AceConfig-3.0")
    local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
    
    -- Re-register the options table to rebuild it
    local options = {
        type = "group",
        name = "Simple DataTexts",
        childGroups = "tab",
        args = {
            general = self:GetGeneralOptions(),
            panels = self:GetPanelOptions(),
            modules = self:GetModuleOptions(),
            profiles = self:GetProfileOptions(),
            importexport = self:GetImportExportOptions(),
        }
    }
    
    AceConfig:RegisterOptionsTable("SimpleDatatexts", options)
    AceConfigRegistry:NotifyChange("SimpleDatatexts")
end

function SDT:OpenConfig()
    if not self.configRegistered then
        SDT:ProfileFunction("RegisterConfig (Lazy)", function()
            self:RegisterConfig()
        end)
        self.configRegistered = true
        SDT:ShowProfileData()
    end
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    AceConfigDialog:Open("SimpleDatatexts")

    -- Clamp the config window to the screen
    local frame = AceConfigDialog.OpenFrames["SimpleDatatexts"]
    if frame and frame.frame then
        frame.frame:SetClampedToScreen(true)
    end
end

----------------------------------------------------
-- Profile Options (extends AceDBOptions with per-spec profiles)
----------------------------------------------------
function SDT:GetProfileOptions()
    local tbl = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- Order 42 puts it right after "Existing Profiles" (40).
    local specArgs = {
        specDesc = {
            type = "description",
            name = L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."],
            order = 41,
        },
        useSpecProfiles = {
            type = "toggle",
            name = function()
                return NORMAL_FONT_COLOR_CODE .. L["Enable Per-Spec Profiles"] .. FONT_COLOR_CODE_CLOSE
            end,
            width = "full",
            get = function() return self.db.char.useSpecProfiles end,
            set = function(_, val)
                self.db.char.useSpecProfiles = val
                if val then
                    self.ProfileManager:SwitchToSpecProfile()
                end
            end,
            order = 42,
        },
    }

    -- Per-spec dropdowns at 43, 44, 45 … : directly below the toggle,
    -- still above copydesc (50).
    local numSpecs = GetNumSpecializations()
    for i = 1, numSpecs do
        local _, specName = GetSpecializationInfo(i)
        if specName then
            specArgs["spec_" .. i] = {
                type = "select",
                name = specName,
                values = function()
                    local profiles = {}
                    for _, name in pairs(self.db:GetProfiles()) do
                        profiles[name] = name
                    end
                    -- Same well-known defaults the built-in "Existing Profiles"
                    -- dropdown includes (via arg="common" / defaultProfiles).
                    profiles["Default"] = "Default"
                    profiles[self.db.keys.char] = self.db.keys.char
                    profiles[self.db.keys.realm] = self.db.keys.realm
                    profiles[self.db.keys.class] = UnitClass("player")
                    return profiles
                end,
                get = function()
                    return self.db.char.chosenProfile[specName]
                end,
                set = function(_, val)
                    self.db.char.chosenProfile[specName] = val
                    if self.db.char.useSpecProfiles then
                        local activeIndex = GetSpecialization()
                        if activeIndex == i then
                            self.db:SetProfile(val)
                        end
                    end
                end,
                disabled = function()
                    return not self.db.char.useSpecProfiles
                end,
                order = 43 + i,
            }
        end
    end

    tbl.plugins = tbl.plugins or {}
    tbl.plugins["specprofiles"] = specArgs

    return tbl
end

----------------------------------------------------
-- General Options
----------------------------------------------------
function SDT:GetGeneralOptions()
    return {
        type = "group",
        name = L["Global"],
        order = 1,
        args = {
            header = {
                type = "header",
                name = L["Global Settings"],
                order = 1,
            },
            locked = {
                type = "toggle",
                name = L["Lock Panels"],
                desc = L["Prevent panels from being moved"],
                get = function() return self.db.profile.locked end,
                set = function(_, val)
                    self.db.profile.locked = val
                end,
                order = 2,
            },
            showPanels = {
                type = "toggle",
                name = L["Show All Panels"],
                desc = L["Toggle visibility of all panels. Individual panels can also be hidden in their own settings."],
                get = function() return self.db.profile.showPanels end,
                set = function(_, val)
                    self.db.profile.showPanels = val
                    self.BarManager:ApplyVisibilityAll()
                end,
                order = 3,
            },
            showLoginMessage = {
                type = "toggle",
                name = L["Show Login Message"],
                get = function() return self.db.profile.showLoginMessage end,
                set = function(_, val) self.db.profile.showLoginMessage = val end,
                order = 4,
            },
            minimapIcon = {
                type = "toggle",
                name = L["Show Minimap Icon"],
                desc = L["Toggle the minimap button on or off"],
                get = function() return not self.db.profile.minimap.hide end,
                set = function(_, val)
                    self.db.profile.minimap.hide = not val
                    if val then
                        SDT.Icon:Show("SimpleDatatexts")
                    else
                        SDT.Icon:Hide("SimpleDatatexts")
                    end
                end,
                order = 5,
            },
            hideModuleTitle = {
                type = "toggle",
                name = L["Hide Module Title in Tooltip"],
                get = function() return self.db.profile.hideModuleTitle end,
                set = function(_, val)
                    self.db.profile.hideModuleTitle = val
                    self.ModuleRegistry:UpdateAllModules()
                end,
                order = 6,
            },
            use24HourClock = {
                type = "toggle",
                name = L["Use 24Hr Clock"],
                get = function() return self.db.profile.use24HourClock end,
                set = function(_, val)
                    self.db.profile.use24HourClock = val
                    self.ModuleRegistry:UpdateAllModules()
                end,
                order = 7,
            },
            spacer1 = {
                type = "header",
                name = L["Colors"],
                order = 10,
            },
            useClassColor = {
                type = "toggle",
                name = L["Use Class Color"],
                get = function() return self.db.profile.useClassColor end,
                set = function(_, val)
                    self.db.profile.useClassColor = val
                    if val then
                        self.db.profile.useCustomColor = false
                    end
                    self.ModuleRegistry:UpdateAllModules()
                end,
                order = 11,
            },
            useCustomColor = {
                type = "toggle",
                name = L["Use Custom Color"],
                get = function() return self.db.profile.useCustomColor end,
                set = function(_, val)
                    self.db.profile.useCustomColor = val
                    if val then
                        self.db.profile.useClassColor = false
                    end
                    self.ModuleRegistry:UpdateAllModules()
                end,
                order = 12,
            },
            customColorHex = {
                type = "color",
                name = L["Custom Color"],
                disabled = function() return not self.db.profile.useCustomColor end,
                get = function()
                    local hex = self.db.profile.customColorHex:gsub("#", "")
                    local r = tonumber(hex:sub(1, 2), 16) / 255
                    local g = tonumber(hex:sub(3, 4), 16) / 255
                    local b = tonumber(hex:sub(5, 6), 16) / 255
                    return r, g, b
                end,
                set = function(_, r, g, b)
                    self.db.profile.customColorHex = format("#%02X%02X%02X", r*255, g*255, b*255)
                    self.ModuleRegistry:UpdateAllModules()
                end,
                order = 13,
            },
            spacer2 = {
                type = "header",
                name = L["Font Settings"],
                order = 20,
            },
            font = {
                type = "select",
                name = L["Display Font:"],
                dialogControl = "LSM30_Font",
                values = function() return SDT.LSM:HashTable("font") end,
                get = function() return self.db.profile.font end,
                set = function(_, val)
                    self.db.profile.font = val
                    self.FontManager:ApplyFont()
                end,
                order = 21,
            },
            fontOutline = {
                type = "select",
                name = L["Font Outline"],
                values = {
                    ["NONE"] = L["None"],
                    ["OUTLINE"] = "Outline",
                    ["THICKOUTLINE"] = "Thick Outline",
                    ["MONOCHROME"] = "Monochrome",
                    ["OUTLINE, MONOCHROME"] = "Outline + Monochrome",
                    ["THICKOUTLINE, MONOCHROME"] = "Thick Outline + Monochrome",
                },
                get = function() return self.db.profile.fontOutline end,
                set = function(_, val)
                    self.db.profile.fontOutline = val
                    self.FontManager:ApplyFont()
                end,
                order = 22,
            },
            fontSize = {
                type = "range",
                name = L["Font Size"],
                min = 4,
                max = 40,
                step = 1,
                get = function() return self.db.profile.fontSize end,
                set = function(_, val)
                    self.db.profile.fontSize = val
                    self.FontManager:ApplyFont()
                end,
                order = 23,
            },
            fontShadowEnabled = {
                type = "toggle",
                name = L["Enable Font Text Shadow"],
                desc = L["Add a subtle shadow to datatexts for better readability"],
                get = function() return self.db.profile.fontShadowEnabled end,
                set = function(_, val)
                    self.db.profile.fontShadowEnabled = val
                    self.FontManager:ApplyFont()
                end,
                order = 24,
            },
            tooltipHeader = {
                type = "header",
                name = L["Tooltip Settings"],
                order = 30,
            },
            tooltipFont = {
                type = "select",
                dialogControl = "LSM30_Font",
                name = L["Tooltip Font"],
                desc = L["Font used for all addon tooltips"],
                values = SDT.LSM:HashTable("font"),
                get = function() return self.db.profile.tooltipFont end,
                set = function(_, val)
                    self.db.profile.tooltipFont = val
                    -- Recreate tooltip with new font
                    if SDT.Tooltip then
                        SDT:CreateTooltip()
                    end
                end,
                order = 31,
            },
            tooltipFontOutline = {
                type = "select",
                name = L["Tooltip Font Outline"],
                desc = L["Font outline for all addon tooltips"],
                values = {
                    ["NONE"] = L["None"],
                    ["OUTLINE"] = "Outline",
                    ["THICKOUTLINE"] = "Thick Outline",
                    ["MONOCHROME"] = "Monochrome",
                    ["OUTLINE, MONOCHROME"] = "Outline + Monochrome",
                    ["THICKOUTLINE, MONOCHROME"] = "Thick Outline + Monochrome",
                },
                get = function() return self.db.profile.tooltipFontOutline end,
                set = function(_, val)
                    self.db.profile.tooltipFontOutline = val
                    -- Recreate tooltip with new outline
                    if SDT.Tooltip then
                        SDT:CreateTooltip()
                    end
                end,
                order = 32,
            },
            tooltipHeaderFontSize = {
                type = "range",
                name = L["Tooltip Header Font Size"],
                desc = L["Font size for tooltip headers"],
                min = 8,
                max = 24,
                step = 1,
                get = function() return self.db.profile.tooltipHeaderFontSize end,
                set = function(_, val)
                    self.db.profile.tooltipHeaderFontSize = val
                    -- Recreate tooltip with new font size
                    if SDT.Tooltip then
                        SDT:CreateTooltip()
                    end
                end,
                order = 33,
            },
            tooltipLineFontSize = {
                type = "range",
                name = L["Tooltip Line Font Size"],
                desc = L["Font size for tooltip content lines"],
                min = 8,
                max = 20,
                step = 1,
                get = function() return self.db.profile.tooltipLineFontSize end,
                set = function(_, val)
                    self.db.profile.tooltipLineFontSize = val
                    -- Recreate tooltip with new font size
                    if SDT.Tooltip then
                        SDT:CreateTooltip()
                    end
                end,
                order = 34,
            },
            tooltipShadowEnabled = {
                type = "toggle",
                name = L["Enable Tooltip Text Shadow"],
                desc = L["Add a subtle shadow to tooltip text for better readability"],
                get = function() return self.db.profile.tooltipShadowEnabled end,
                set = function(_, val)
                    self.db.profile.tooltipShadowEnabled = val
                    -- Recreate tooltip with new shadow setting
                    if SDT.Tooltip then
                        SDT:CreateTooltip()
                    end
                end,
                order = 35,
            },
        }
    }
end

----------------------------------------------------
-- Panel Options
----------------------------------------------------
function SDT:GetPanelOptions()
    local options = {
        type = "group",
        name = L["Panels"],
        order = 2,
        args = {
            createBar = {
                type = "execute",
                name = L["Create New Panel"],
                func = function()
                    local id = self.BarManager:GetNextBarID()
                    local name = "SDT_Bar" .. id
                    self.db.profile.bars[name] = CopyTable(self.db.profile.bars['*'])
                    self.db.profile.bars[name].name = name
                    self.BarManager:CreateDataBar(id, 3)
                    LibStub("AceConfigRegistry-3.0"):NotifyChange("SimpleDatatexts")
                end,
                order = 1,
            },
            selectBar = {
                type = "select",
                name = L["Select Panel:"],
                values = GetBarList,
                get = function() return self.selectedBar end,
                set = function(_, val)
                    self.selectedBar = val
                    self:RebuildConfig()
                    LibStub("AceConfigRegistry-3.0"):NotifyChange("SimpleDatatexts")
                end,
                order = 2,
            },
            barSettings = {
                type = "group",
                name = L["Panel Settings"],
                inline = true,
                disabled = function() return not self.selectedBar end,
                order = 3,
                args = {
                    name = {
                        type = "input",
                        name = L["Rename Panel:"],
                        get = function()
                            if not self.selectedBar then return "" end
                            return self.db.profile.bars[self.selectedBar].name or self.selectedBar
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].name = val
                            end
                        end,
                        order = 1,
                    },
                    hidden = {
                        type = "toggle",
                        name = L["Hide Panel"],
                        desc = L["Hide this panel. Panels are always visible while unlocked."],
                        get = function()
                            if not self.selectedBar then return false end
                            return self.db.profile.bars[self.selectedBar].hidden or false
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].hidden = val
                                if self.bars[self.selectedBar] then
                                    self.BarManager:ApplyVisibility(self.bars[self.selectedBar])
                                end
                            end
                        end,
                        order = 2,
                    },
                    delete = {
                        type = "execute",
                        name = L["Remove Selected Panel"],
                        confirm = function() return L["Are you sure you want to delete this bar?\nThis action cannot be undone."] end,
                        func = function()
                            if self.selectedBar and self.bars[self.selectedBar] then
                                self.bars[self.selectedBar]:Hide()
                                self.bars[self.selectedBar] = nil
                            end
                            self.db.profile.bars[self.selectedBar] = nil
                            self.selectedBar = nil
                            LibStub("AceConfigRegistry-3.0"):NotifyChange("SimpleDatatexts")
                        end,
                        order = 3,
                    },
                    spacer1 = {
                        type = "header",
                        name = L["Size & Scale"],
                        order = 10,
                    },
                    width = {
                        type = "range",
                        name = L["Width"],
                        min = 100,
                        max = self.cache.screenWidth,
                        step = 1,
                        get = function()
                            if not self.selectedBar then return 300 end
                            return self.db.profile.bars[self.selectedBar].width
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].width = val
                                self.BarManager:RebuildSlots(self.bars[self.selectedBar])
                            end
                        end,
                        order = 11,
                    },
                    height = {
                        type = "range",
                        name = L["Height"],
                        min = 16,
                        max = 128,
                        step = 1,
                        get = function()
                            if not self.selectedBar then return 22 end
                            return self.db.profile.bars[self.selectedBar].height
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].height = val
                                self.BarManager:RebuildSlots(self.bars[self.selectedBar])
                            end
                        end,
                        order = 12,
                    },
                    scale = {
                        type = "range",
                        name = L["Scale"],
                        min = 50,
                        max = 500,
                        step = 1,
                        get = function()
                            if not self.selectedBar then return 100 end
                            return self.db.profile.bars[self.selectedBar].scale
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].scale = val
                                if self.bars[self.selectedBar] then
                                    self.bars[self.selectedBar]:SetScale(val / 100)
                                end
                            end
                        end,
                        order = 13,
                    },
                    frameStrata = {
                        type = "select",
                        name = L["Frame Strata"],
                        desc = L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."],
                        values = {
                            ["BACKGROUND"] = "BACKGROUND (0)",
                            ["LOW"] = "LOW (1)",
                            ["MEDIUM"] = "MEDIUM (2) - Default",
                            ["HIGH"] = "HIGH (3)",
                            ["DIALOG"] = "DIALOG (4)",
                            ["FULLSCREEN"] = "FULLSCREEN (5)",
                            ["FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG (6)",
                            ["TOOLTIP"] = "TOOLTIP (7)",
                        },
                        sorting = { "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP" },
                        get = function()
                            if not self.selectedBar then return "MEDIUM" end
                            return self.db.profile.bars[self.selectedBar].frameStrata or "MEDIUM"
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].frameStrata = val
                                if self.bars[self.selectedBar] then
                                    -- Set strata on the panel frame
                                    self.bars[self.selectedBar]:SetFrameStrata(val)
                                    -- Also update all slot/module strata to be relative
                                    self.ModuleRegistry:UpdateAllModuleStrata()
                                end
                            end
                        end,
                        order = 14,
                    },
                    spacer2 = {
                        type = "header",
                        name = L["Appearance"],
                        order = 20,
                    },
                    bgOpacity = {
                        type = "range",
                        name = L["Background Opacity"],
                        min = 0,
                        max = 100,
                        step = 1,
                        get = function()
                            if not self.selectedBar then return 50 end
                            return self.db.profile.bars[self.selectedBar].bgOpacity
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].bgOpacity = val
                                if self.bars[self.selectedBar] then
                                    self.bars[self.selectedBar]:ApplyBackground()
                                end
                            end
                        end,
                        order = 21,
                    },
                    border = {
                        type = "select",
                        name = L["Select Border:"],
                        values = GetBorderList,
                        get = function()
                            if not self.selectedBar then return "None" end
                            return self.db.profile.bars[self.selectedBar].borderName or "None"
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                local borderList = SDT.LSM:HashTable("border")
                                self.db.profile.bars[self.selectedBar].borderName = val
                                self.db.profile.bars[self.selectedBar].border = borderList[val]
                                if self.bars[self.selectedBar] then
                                    self.bars[self.selectedBar]:ApplyBackground()
                                end
                            end
                        end,
                        order = 22,
                    },
                    borderSize = {
                        type = "range",
                        name = L["Border Size"],
                        min = 1,
                        max = 40,
                        step = 1,
                        disabled = function()
                            if not self.selectedBar then return true end
                            return self.db.profile.bars[self.selectedBar].borderName == "None"
                        end,
                        get = function()
                            if not self.selectedBar then return 8 end
                            return self.db.profile.bars[self.selectedBar].borderSize
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].borderSize = val
                                if self.bars[self.selectedBar] then
                                    self.bars[self.selectedBar]:ApplyBackground()
                                end
                            end
                        end,
                        order = 23,
                    },
                    borderColor = {
                        type = "color",
                        name = L["Border Color"],
                        disabled = function()
                            if not self.selectedBar then return true end
                            return self.db.profile.bars[self.selectedBar].borderName == "None"
                        end,
                        get = function()
                            if not self.selectedBar then return 0, 0, 0 end
                            local color = self.db.profile.bars[self.selectedBar].borderColor:gsub("#", "")
                            local r = tonumber(color:sub(1, 2), 16) / 255
                            local g = tonumber(color:sub(3, 4), 16) / 255
                            local b = tonumber(color:sub(5, 6), 16) / 255
                            return r, g, b
                        end,
                        set = function(_, r, g, b)
                            if self.selectedBar then
                                self.db.profile.bars[self.selectedBar].borderColor = format("#%02X%02X%02X", r*255, g*255, b*255)
                                if self.bars[self.selectedBar] then
                                    self.bars[self.selectedBar]:ApplyBackground()
                                end
                            end
                        end,
                        order = 24,
                    },
                    spacer3 = {
                        type = "header",
                        name = L["Slots"],
                        order = 30,
                    },
                    numSlots = {
                        type = "range",
                        name = L["Number of Slots"],
                        min = 1,
                        max = 12,
                        step = 1,
                        get = function()
                            if not self.selectedBar then return 3 end
                            return self.db.profile.bars[self.selectedBar].numSlots
                        end,
                        set = function(_, val)
                            if self.selectedBar then
                                local oldValue = self.db.profile.bars[self.selectedBar].numSlots
                                self.db.profile.bars[self.selectedBar].numSlots = val
                                self.BarManager:RebuildSlots(self.bars[self.selectedBar])

                                if oldValue ~= val then
                                    self.needsSlotRebuild = true
                                end
                            end
                        end,
                        order = 31,
                    },
                    applySlots = {
                        type = "execute",
                        name = L["Apply Slot Changes"],
                        desc = L["Update slot assignment dropdowns after changing number of slots"],
                        disabled = function() return not self.needsSlotRebuild end,
                        func = function()
                            self.needsSlotRebuild = false
                            self:RebuildConfig()
                        end,
                        order = 32,
                    },
                },
            },
            slots = {
                type = "group",
                name = L["Slot Assignments"],
                inline = true,
                disabled = function() return not self.selectedBar end,
                order = 4,
                args = {},
            },
        }
    }

    -- Populate slot dropdowns dynamically based on current selection
    if self.selectedBar then
        local slotArgs = self:GetSlotArgs()
        for k, v in pairs(slotArgs) do
            options.args.slots.args[k] = v
        end
    end

    return options
end

----------------------------------------------------
-- Slot Args (Dynamic)
----------------------------------------------------
function SDT:GetSlotArgs()
    local args = {}
    
    if not self.selectedBar then return args end
    
    local numSlots = self.db.profile.bars[self.selectedBar].numSlots or 3
    
    for i = 1, numSlots do
        args["slot" .. i] = {
            type = "select",
            name = format(L["Slot %d:"], i),
            values = GetModuleList,
            get = function()
                if not self.selectedBar or not self.db.profile.bars[self.selectedBar] then
                    return ""
                end
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                if type(slotData) == "string" then
                    return slotData
                elseif type(slotData) == "table" then
                    return slotData.module
                end
                return ""
            end,
            set = function(_, val)
                if val == "" then
                    self.db.profile.bars[self.selectedBar].slots[i] = nil
                else
                    -- Convert to new table format
                    local oldData = self.db.profile.bars[self.selectedBar].slots[i]
                    local offsetX, offsetY = 0, 0
                    if type(oldData) == "table" then
                        offsetX = oldData.offsetX or 0
                        offsetY = oldData.offsetY or 0
                    end
                    
                    self.db.profile.bars[self.selectedBar].slots[i] = {
                        module = val,
                        offsetX = offsetX,
                        offsetY = offsetY,
                    }
                end
                self.BarManager:RebuildSlots(self.bars[self.selectedBar])
            end,
            order = i * 10,
        }

        -- Offset X
        args["slot" .. i .. "_offsetX"] = {
            type = "range",
            name = L["X Offset"],
            min = -200,
            max = 200,
            step = 1,
            disabled = function()
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                return not slotData or (type(slotData) == "string" and slotData == "")
            end,
            get = function()
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                if type(slotData) == "table" then
                    return slotData.offsetX or 0
                end
                return 0
            end,
            set = function(_, val)
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                if type(slotData) == "string" then
                    -- Convert to table format
                    self.db.profile.bars[self.selectedBar].slots[i] = {
                        module = slotData,
                        offsetX = val,
                        offsetY = 0,
                    }
                elseif type(slotData) == "table" then
                    slotData.offsetX = val
                end
                self.BarManager:RebuildSlots(self.bars[self.selectedBar])
            end,
            order = i * 10 + 1,
        }

        -- Offset Y
        args["slot" .. i .. "_offsetY"] = {
            type = "range",
            name = L["Y Offset"],
            min = -100,
            max = 100,
            step = 1,
            disabled = function()
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                return not slotData or (type(slotData) == "string" and slotData == "")
            end,
            get = function()
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                if type(slotData) == "table" then
                    return slotData.offsetY or 0
                end
                return 0
            end,
            set = function(_, val)
                local slotData = self.db.profile.bars[self.selectedBar].slots[i]
                if type(slotData) == "string" then
                    -- Convert to table format
                    self.db.profile.bars[self.selectedBar].slots[i] = {
                        module = slotData,
                        offsetX = 0,
                        offsetY = val,
                    }
                elseif type(slotData) == "table" then
                    slotData.offsetY = val
                end
                self.BarManager:RebuildSlots(self.bars[self.selectedBar])
            end,
            order = i * 10 + 2,
        }

        -- Separator
        if i < numSlots then
            args["slot" .. i .. "_spacer"] = {
                type = "header",
                name = "",
                order = i * 10 + 3,
            }
        end
    end
    
    return args
end

----------------------------------------------------
-- Module Options (Dynamic)
----------------------------------------------------
function SDT:GetModuleOptions()
    return {
        type = "group",
        name = L["Module Settings"],
        order = 3,
        childGroups = "select",
        args = self:BuildModuleArgs(),
    }
end

function SDT:BuildModuleArgs()
    local args = {}
    
    for _, moduleName in ipairs(self.cache.moduleNames) do
        -- Note: Not currently excluding any modules, but keeping the framework.
        --if not self.ModuleRegistry:ExcludedModule(moduleName) then
            args[moduleName] = {
                type = "group",
                name = moduleName,
                args = self:GetModuleSpecificArgs(moduleName),
            }
        --end
    end
    
    return args
end

function SDT:GetModuleSpecificArgs(moduleName)
    -- This will be populated by modules using SDT:AddModuleConfigSetting
    local args = {
        header = {
            type = "header",
            name = moduleName .. " " .. L["Settings"],
            order = 1,
        }
    }
    
    -- Add any queued settings
    if self.queuedModuleSettings and self.queuedModuleSettings[moduleName] then
        for idx, setting in ipairs(self.queuedModuleSettings[moduleName]) do
            args["setting" .. idx] = self:ConvertSettingToArg(moduleName, setting, idx + 1)
        end
    end
    
    return args
end

function SDT:ConvertSettingToArg(moduleName, setting, order)
    if setting.settingType == "checkbox" then
        return {
            type = "toggle",
            name = setting.label,
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            order = order,
        }
    elseif setting.settingType == "select" then
        return {
            type = "select",
            name = setting.label,
            values = setting.values or {},
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            order = order,
        }
    elseif setting.settingType == "range" then
        return {
            type = "range",
            name = setting.label,
            min = setting.min or 0,
            max = setting.max or 100,
            step = setting.step or 1,
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            order = order,
        }
    elseif setting.settingType == "color" then
        return {
            type = "color",
            name = setting.label,
            hasAlpha = false,
            get = function()
                local hexColor = self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue)
                local color = hexColor:gsub("#", "")
                local r = tonumber(color:sub(1, 2), 16) / 255
                local g = tonumber(color:sub(3, 4), 16) / 255
                local b = tonumber(color:sub(5, 6), 16) / 255
                return r, g, b
            end,
            set = function(_, r, g, b)
                local hexColor = string.format("#%02X%02X%02X", r*255, g*255, b*255)
                self:SetModuleSetting(moduleName, setting.settingKey, hexColor)
                self.ModuleRegistry:UpdateAllModules()
            end,
            order = order,
        }
    elseif setting.settingType == "font" then
        return {
            type = "select",
            name = setting.label,
            dialogControl = "LSM30_Font",
            values = function() return SDT.LSM:HashTable("font") end,
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            disabled = function()
                -- Disable font settings if override is not enabled
                return not self:GetModuleSetting(moduleName, "overrideFont", false)
            end,
            order = order,
        }
    elseif setting.settingType == "fontOutline" then
        return {
            type = "select",
            name = setting.label,
            values = setting.values or {},
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            disabled = function()
                -- Disable font settings if override is not enabled
                return not self:GetModuleSetting(moduleName, "overrideFont", false)
            end,
            order = order,
        }
    elseif setting.settingType == "fontSize" then
        return {
            type = "range",
            name = setting.label,
            min = setting.min or 0,
            max = setting.max or 100,
            step = setting.step or 1,
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            disabled = function()
                -- Disable font settings if override is not enabled
                return not self:GetModuleSetting(moduleName, "overrideFont", false)
            end,
            order = order,
        }
    elseif setting.settingType == "description" then
        return {
            type = "description",
            name = setting.label,
            fontSize = setting.fontSize or "medium",
            order = order,
        }
    elseif setting.settingType == "header" then
        return {
            type = "header",
            name = setting.label,
            order = order,
        }
    elseif setting.settingType == "statusbar" then
        return {
            type = "select",
            name = setting.label,
            dialogControl = "LSM30_Statusbar",
            values = function() return SDT.LSM:HashTable("statusbar") end,
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            order = order,
        }
    elseif setting.settingType == "frameStrata" then
        return {
            type = "select",
            name = setting.label,
            desc = L["Set the frame strata (layer) for this module. Higher values appear above lower values."],
            values = {
                ["BACKGROUND"] = "BACKGROUND (0)",
                ["LOW"] = "LOW (1)",
                ["MEDIUM"] = "MEDIUM (2) - Default",
                ["HIGH"] = "HIGH (3)",
                ["DIALOG"] = "DIALOG (4)",
                ["FULLSCREEN"] = "FULLSCREEN (5)",
                ["FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG (6)",
                ["TOOLTIP"] = "TOOLTIP (7)",
            },
            sorting = { "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP" },
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                self.ModuleRegistry:UpdateAllModuleStrata()
            end,
            order = order,
        }
    elseif setting.settingType == "anchorPoint" then
        return {
            type = "select",
            name = setting.label,
            desc = L["Set the anchor point for this module."],
            values = {
                ["LEFT"] = "LEFT",
                ["CENTER"] = "CENTER - Default",
                ["RIGHT"] = "RIGHT",
            },
            sorting = { "CENTER", "LEFT", "RIGHT" },
            get = function() return self:GetModuleSetting(moduleName, setting.settingKey, setting.defaultValue) end,
            set = function(_, val)
                self:SetModuleSetting(moduleName, setting.settingKey, val)
                for barName, barData in pairs(self.db.profile.bars) do
                    for _, slotData in pairs(barData.slots) do
                        local module = type(slotData) == "table" and slotData.module or slotData
                        if module == moduleName then
                            if self.bars[barName] then
                                self.BarManager:RebuildSlots(self.bars[barName])
                            end
                            break
                        end
                    end
                end
            end,
            order = order,
        }
    elseif setting.settingType == "currencyOrder" then
        -- Get number of currently tracked currencies dynamically
        local function GetNumTrackedCurrencies()
            local count = 0
            for i = 1, 8 do
                local info = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
                if info and info.name then
                    count = count + 1
                else
                    break
                end
            end
            return count
        end

        -- Build a map of currencyTypesID to backpack index
        local function GetCurrencyTypeIDToIndex()
            local typeIDToIndex = {}
            for i = 1, 8 do
                local info = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
                if info and info.name and info.currencyTypesID then
                    typeIDToIndex[info.currencyTypesID] = i
                end
            end
            return typeIDToIndex
        end

        -- Build dropdown values for available currencies
        -- Returns a table mapping currencyTypesID to display string
        local function GetCurrencyValues()
            local values = {}
            local typeIDToIndex = GetCurrencyTypeIDToIndex()

            for typeID, backpackIndex in pairs(typeIDToIndex) do
                local info = C_CurrencyInfo.GetBackpackCurrencyInfo(backpackIndex)
                if info and info.name and info.iconFileID then
                    values[typeID] = string.format('|T%s:16:16:0:0:64:64:4:60:4:60|t %s', info.iconFileID, info.name)
                end
            end

            return values
        end

        -- Convert setting key from currencyOrder# to currencyTypeID#
        local typeIDKey = setting.settingKey:gsub("currencyOrder", "currencyTypeID")

        return {
            type = "select",
            name = setting.label,
            values = function() return GetCurrencyValues() end,
            get = function() 
                -- Return the currencyTypesID stored for this position
                return self:GetModuleSetting(moduleName, typeIDKey, nil)
            end,
            set = function(_, val)
                -- Store the currencyTypesID (not the backpack index)
                self:SetModuleSetting(moduleName, typeIDKey, val)
                self.ModuleRegistry:UpdateAllModules()
            end,
            disabled = function()
                -- Extract position number from setting key (e.g., "currencyOrder3" -> 3)
                local position = tonumber(setting.settingKey:match("%d+"))
                local trackedQty = self:GetModuleSetting(moduleName, "trackedQty", 3)
                local numTracked = GetNumTrackedCurrencies()

                -- Disable if position is beyond tracked quantity or actual tracked currencies
                return position > trackedQty or position > numTracked
            end,
            order = order,
        }
    end

    -- Fallback
    return nil
end

----------------------------------------------------
-- Import/Export Options
----------------------------------------------------
function SDT:GetImportExportOptions()
    return {
        type = "group",
        name = L["Import/Export"],
        order = 5,
        args = {
            header = {
                type = "header",
                name = L["Profile Import/Export"],
                order = 1,
            },
            description = {
                type = "description",
                name = L["Export your current profile to share with others, or import a profile string.\n"],
                order = 2,
            },
            -- EXPORT SECTION
            exportHeader = {
                type = "header",
                name = L["Export"],
                order = 10,
            },
            exportButton = {
                type = "execute",
                name = L["Generate Export String"],
                desc = L["Create an export string for your current profile"],
                func = function()
                    local exportString = self:ExportProfile()
                    if exportString then
                        self.exportString = exportString
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("SimpleDatatexts")
                        self:Print(L["Export string generated! Copy it from the box below."])
                    end
                end,
                order = 11,
            },
            exportString = {
                type = "input",
                name = L["Export String"],
                desc = L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"],
                multiline = 8,
                width = "full",
                get = function() return self.exportString or "" end,
                set = function() end,
                order = 12,
            },
            -- IMPORT SECTION
            importHeader = {
                type = "header",
                name = L["Import"],
                order = 20,
            },
            importString = {
                type = "input",
                name = L["Import String"],
                desc = L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"],
                multiline = 8,
                width = "full",
                get = function() return self.importString or "" end,
                set = function(_, val) 
                    self.importString = val
                end,
                order = 21,
            },
            importButton = {
                type = "execute",
                name = L["Import Profile"],
                desc = L["Import the profile string from above (after clicking Accept)"],
                confirm = function() return L["This will overwrite your current profile. Are you sure?"] end,
                func = function()
                    if not self.importString or self.importString == "" then
                        self:Print(L["Please paste an import string and click Accept first"])
                        return
                    end
                    
                    local success = self:ImportProfile(self.importString)
                    if success then
                        self.importString = "" -- Clear after successful import
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("SimpleDatatexts")
                    end
                end,
                order = 22,
            },
        }
    }
end