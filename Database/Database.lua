-- Database.lua - AceDB Integration and Migration
local addonName, SDT = ...
local L = SDT.L

----------------------------------------------------
-- Database Defaults
----------------------------------------------------
local defaults = {
    profile = {
        -- Global settings
        locked = false,
        debugMode = false,
        useClassColor = false,
        useCustomColor = false,
        customColorHex = "#ffffff",
        hideModuleTitle = false,
        use24HourClock = false,
        showLoginMessage = true,
        font = "Friz Quadrata TT",
        fontSize = 12,
        fontOutline = "NONE",
        
        -- Panel/bar data
        bars = {
            ['*'] = {
                numSlots = 3,
                slots = {},
                bgOpacity = 50,
                borderName = "None",
                border = "None",
                borderSize = 8,
                borderColor = "#000000",
                width = 300,
                height = 22,
                scale = 100,
                name = nil,
                point = nil,
                frameStrata = "MEDIUM",
            }
        },
        
        -- Module settings
        moduleSettings = {
            ['*'] = {}
        },

        -- Minimap button setting
        minimap = {
            hide = false,
        }
    },
    
    -- Character-specific data
    char = {
        useSpecProfiles = false,
        chosenProfile = {
            generic = nil, -- Will be set to charKey on init
            ['*'] = nil,
        }
    },
    
    -- Global (account-wide) data
    global = {
        gold = {
            ['*'] = { -- realm
                ['*'] = { -- character
                    amount = 0,
                    faction = "Neutral",
                }
            }
        },
        
        -- Ara Broker settings migration
        AraBroker = {},
    }
}

----------------------------------------------------
-- Initialize Database
----------------------------------------------------
function SDT:InitializeDatabase()
    -- Create AceDB instance
    self.db = LibStub("AceDB-3.0"):New("SimpleDatatextsDB", defaults, true)
    
    -- Migrate old data if it exists
    self:MigrateOldData()
    
    -- Set default profile name if needed
    if not self.db.char.chosenProfile.generic then
        self.db.char.chosenProfile.generic = self.cache.charKey
    end
    
    -- Initialize spec profiles
    self.ProfileManager:InitializeSpecProfiles()
    
    -- Register profile callbacks
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    
    -- Ensure at least one bar exists
    if not next(self.db.profile.bars) then
        self:CreateDefaultBar()
    end
end

----------------------------------------------------
-- Create Default Bar
----------------------------------------------------
function SDT:CreateDefaultBar()
    self.db.profile.bars.SDT_Bar1 = {
        numSlots = 3,
        slots = {},
        bgOpacity = 50,
        borderName = "None",
        border = "None",
        borderSize = 8,
        borderColor = "#000000",
        width = 300,
        height = 22,
        scale = 100,
        name = "SDT_Bar1",
    }
end

----------------------------------------------------
-- Refresh Config
----------------------------------------------------
function SDT:RefreshConfig()
    -- Reload all bars
    for barName, bar in pairs(self.bars) do
        if bar then
            bar:Hide()
        end
    end
    wipe(self.bars)
    
    -- Recreate bars from current profile
    for barName, barData in pairs(self.db.profile.bars) do
        local id = tonumber(barName:match("SDT_Bar(%d+)"))
        if id and id > 0 then
            self.BarManager:CreateDataBar(id, barData.numSlots)
        end
    end
    
    -- Update all modules
    self.ModuleRegistry:UpdateAllModules()
    
    -- Update config GUI if open
    if self.configDialog and self.configDialog:IsShown() then
        LibStub("AceConfigRegistry-3.0"):NotifyChange("SimpleDatatexts")
    end
end

----------------------------------------------------
-- Get Module Setting
----------------------------------------------------
function SDT:GetModuleSetting(moduleName, settingKey, default)
    if self.db.profile.moduleSettings[moduleName] and self.db.profile.moduleSettings[moduleName][settingKey] ~= nil then
        return self.db.profile.moduleSettings[moduleName][settingKey]
    end
    return default
end

----------------------------------------------------
-- Set Module Setting
----------------------------------------------------
function SDT:SetModuleSetting(moduleName, settingKey, value)
    if not self.db.profile.moduleSettings[moduleName] then
        self.db.profile.moduleSettings[moduleName] = {}
    end
    self.db.profile.moduleSettings[moduleName][settingKey] = value
end

----------------------------------------------------
-- Helper: Count Table Keys
----------------------------------------------------
function SDT:CountTableKeys(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

----------------------------------------------------
-- Export Profile
----------------------------------------------------
function SDT:ExportProfile()
    local profileData = {
        profile = CopyTable(self.db.profile),
        version = self.cache.version,
    }
    
    local serialized = self.AceSerializer:Serialize(profileData)
    if not serialized then
        self:Print(L["Error serializing profile data"])
        return nil
    end
    
    local compressed = self.LibDeflate:CompressDeflate(serialized)
    if not compressed then
        self:Print(L["Error compressing profile data"])
        return nil
    end
    
    local encoded = self.LibDeflate:EncodeForPrint(compressed)
    return "SDT1:" .. encoded
end

----------------------------------------------------
-- Import Profile
----------------------------------------------------
function SDT:ImportProfile(importString)
    if not importString or importString == "" then
        self:Print(L["No import string provided"])
        return false
    end

    if #importString > 100000 then  -- 100 KB
        self:Print(L["Import string is too large"])
        return false
    end

    -- Strip whitespace and newlines
    importString = importString:gsub("%s", "")

    if not importString:match("^SDT1:") then
        self:Print(L["Invalid import string format"])
        return false
    end
    
    -- Strip version prefix
    local encoded = importString:sub(6)

    local decoded = self.LibDeflate:DecodeForPrint(encoded)
    if not decoded then
        self:Print(L["Error decoding import string"])
        return false
    end

    if #decoded > 150000 then  -- 150 KB (allows for encoding overhead)
        self:Print(L["Import data too large"])
        return false
    end
    
    local decompressed = self.LibDeflate:DecompressDeflate(decoded)
    if not decompressed then
        self:Print(L["Error decompressing data"])
        return false
    end

    if #decompressed > 500000 then  -- 500 KB uncompressed (very generous)
        self:Print(L["Import data too large after decompression"])
        return false
    end
    
    local success, profileData = self.AceSerializer:Deserialize(decompressed)
    if not success or not profileData then
        self:Print(L["Error deserializing profile data"])
        return false
    end
    
    -- Validate version (optional)
    if profileData.version then
        self:Print(format(L["Importing profile from version %s"], profileData.version))
    end
    
    -- Import the profile
    if profileData.profile then
        -- Clear current profile
        wipe(self.db.profile)
        
        -- Copy imported data
        for k, v in pairs(profileData.profile) do
            if type(v) == "table" then
                self.db.profile[k] = CopyTable(v)
            else
                self.db.profile[k] = v
            end
        end
        
        self:Print(L["Profile imported successfully!"])

        -- Refresh config
        self:RefreshConfig()

        -- Rebuild our config
        if self.configDialog and self.configDialog:IsShown() then
            self:RebuildConfig()
        end

        -- Apply the font settings
        self.FontManager:ApplyFont()

        return true
    else
        self:Print(L["Invalid profile data"])
        return false
    end
end