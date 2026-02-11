local addonName, SDT = ...
local L = SDT.L
SDT.ProfileManager = {}

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetNumSpecializations = GetNumSpecializations
local GetSpecialization     = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo

----------------------------------------------------
-- Initialize Spec Profiles
----------------------------------------------------
function SDT.ProfileManager:InitializeSpecProfiles()
    for i = 1, GetNumSpecializations() do
        local _, specName = GetSpecializationInfo(i)
        if specName and not SDT.db.char.chosenProfile[specName] then
            SDT.db.char.chosenProfile[specName] = SDT.cache.charKey .. "-" .. specName:lower()
        end
    end
end

----------------------------------------------------
-- Switch to the Active Spec's Profile
----------------------------------------------------
function SDT.ProfileManager:SwitchToSpecProfile()
    if not SDT.db.char.useSpecProfiles then return end

    local specIndex = GetSpecialization()
    if not specIndex then return end

    local _, specName = GetSpecializationInfo(specIndex)
    if not specName then return end

    -- Ensure a profile name exists for this spec
    if not SDT.db.char.chosenProfile[specName] then
        SDT.db.char.chosenProfile[specName] = SDT.cache.charKey .. "-" .. specName:lower()
    end

    local targetProfile = SDT.db.char.chosenProfile[specName]
    if SDT.db:GetCurrentProfile() ~= targetProfile then
        SDT.db:SetProfile(targetProfile)
    end
end