local addonName, SDT = ...
local L = SDT.L

----------------------------------------------------
-- Migrate Old Data
----------------------------------------------------
function SDT:MigrateOldData()
    -- Check if old SDTDB exists
    if not _G.SDTDB then return end
    
    local charKey = SDT.cache.charKey
    local oldDB = _G.SDTDB

    -- Skip if already migrated
    if oldDB._migrated then
        return
    end

    SDT:Print(L["Migrating old settings to new profile system..."])
    
    -- Migrate ALL old profiles to AceDB profiles
    if oldDB.profiles then
        for profileName, oldProfile in pairs(oldDB.profiles) do
            -- Create this profile in AceDB if it doesn't exist
            local tempProfile = profileName
            SDT.db:SetProfile(tempProfile)
            
            -- Migrate bars
            if oldProfile.bars then
                for barName, barData in pairs(oldProfile.bars) do
                    SDT.db.profile.bars[barName] = CopyTable(barData)
                end
            end
            
            -- Migrate module settings
            if oldProfile.moduleSettings then
                for moduleName, settings in pairs(oldProfile.moduleSettings) do
                    SDT.db.profile.moduleSettings[moduleName] = CopyTable(settings)
                end
            end
        end
    end
    
    -- Switch back to this character's profile
    local activeProfileName = oldDB[charKey] and oldDB[charKey].chosenProfile and oldDB[charKey].chosenProfile.generic
    if activeProfileName then
        SDT.db:SetProfile(activeProfileName)
    else
        SDT.db:SetProfile(charKey)
    end
    
    -- Migrate character settings to current profile
    if oldDB[charKey] and oldDB[charKey].settings then
        local oldSettings = oldDB[charKey].settings
        
        SDT.db.profile.locked = oldSettings.locked or false
        SDT.db.profile.useClassColor = oldSettings.useClassColor or false
        SDT.db.profile.useCustomColor = oldSettings.useCustomColor or false
        SDT.db.profile.customColorHex = oldSettings.customColorHex or "#ffffff"
        SDT.db.profile.hideModuleTitle = oldSettings.hideModuleTitle or false
        SDT.db.profile.use24HourClock = oldSettings.use24HourClock or false
        SDT.db.profile.showLoginMessage = oldSettings.showLoginMessage ~= false
        SDT.db.profile.font = oldSettings.font or "Friz Quadrata TT"
        SDT.db.profile.fontSize = oldSettings.fontSize or 12
        SDT.db.profile.fontOutline = oldSettings.fontOutline or "NONE"
    end
    
    -- Migrate character profile choices
    if oldDB[charKey] then
        if oldDB[charKey].useSpecProfiles ~= nil then
            SDT.db.char.useSpecProfiles = oldDB[charKey].useSpecProfiles
        end
        
        if oldDB[charKey].chosenProfile then
            for k, v in pairs(oldDB[charKey].chosenProfile) do
                SDT.db.char.chosenProfile[k] = v
            end
        end
    end
    
    -- Migrate gold data
    if oldDB.gold then
        SDT.db.global.gold = CopyTable(oldDB.gold)
    end
    
    -- Migrate Ara Broker settings
    if oldDB.AraBroker then
        SDT.db.global.AraBroker = CopyTable(oldDB.AraBroker)
    end
    
    SDT:Print(L["Migration complete! All profiles have been migrated."])
    
    -- Mark as migrated
    oldDB._migrated = true
end