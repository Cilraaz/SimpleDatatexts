-- modules/SpecSwitch.lua
-- SpecSwitch datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local SDTC = SDT.cache
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local ipairs = ipairs
local tinsert = table.insert
local tremove = table.remove
local format = format
local next = next
local strjoin = strjoin

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetLootSpecialization   = GetLootSpecialization
local GetNumSpecializations   = GetNumSpecializations
local GetPvpTalentInfoByID    = GetPvpTalentInfoByID
local GetSpecialization       = GetSpecialization
local GetSpecializationInfo   = GetSpecializationInfo
local IsControlKeyDown        = IsControlKeyDown
local IsShiftKeyDown          = IsShiftKeyDown
local SetLootSpecialization   = SetLootSpecialization
local TogglePlayerSpellsFrame = TogglePlayerSpellsFrame
-- C_AddOns
local IsAddOnLoaded           = C_AddOns.IsAddOnLoaded
local LoadAddOn               = C_AddOns.LoadAddOn
-- C_ClassTalents
local GetActiveConfigID       = C_ClassTalents.GetActiveConfigID
local GetHasStarterBuild      = C_ClassTalents.GetHasStarterBuild
local GetStarterBuildActive   = C_ClassTalents.GetStarterBuildActive
local GetConfigIDsBySpecID    = C_ClassTalents.GetConfigIDsBySpecID
local GetLastSelectedSavedConfigID = C_ClassTalents.GetLastSelectedSavedConfigID
local LoadConfig              = C_ClassTalents.LoadConfig
local SetStarterBuildActive   = C_ClassTalents.SetStarterBuildActive
-- C_SpecializationInfo
local C_SpecializationInfo_GetAllSelectedPvpTalentIDs = C_SpecializationInfo.GetAllSelectedPvpTalentIDs
local SetSpecialization       = C_SpecializationInfo.SetSpecialization or SetSpecialization
-- C_Timer
local Delay                   = C_Timer.After
-- C_Traits
local C_Traits_GetConfigInfo  = C_Traits.GetConfigInfo
-- MenuUtil
local CreateContextMenu       = MenuUtil.CreateContextMenu
-- PlayerUtil
local CanUseClassTalents      = PlayerUtil.CanUseClassTalents
local GetCurrentSpecID        = PlayerUtil.GetCurrentSpecID

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local LOOT                    = LOOT
local UNKNOWN                 = UNKNOWN
local PVP_TALENTS             = PVP_TALENTS
local BLUE_FONT_COLOR         = BLUE_FONT_COLOR
local SELECT_LOOT_SPECIALIZATION  = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT
local STARTER_ID              = Constants.TraitConsts.STARTER_BUILD_TRAIT_CONFIG_ID

----------------------------------------------------
-- File Locals
----------------------------------------------------
local activeString = strjoin('', '|cff00FF00', _G.ACTIVE_PETS or L["Active"], '|r')
local inactiveString = strjoin('', '|cffFF0000', _G.FACTION_INACTIVE or L["Inactive"], '|r')

----------------------------------------------------
-- Lists
----------------------------------------------------
local menuList = {
    { text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
    { checked = function() return GetLootSpecialization() == 0 end, func = function() SetLootSpecialization(0) end }
}

local specList = { { text = SPECIALIZATION, isTitle = true, notCheckable = true } }
local loadoutList = { { text = L["Loadouts"], isTitle = true, notCheckable = true } }

----------------------------------------------------
-- Helpers
----------------------------------------------------
local function AddTexture(texture)
    if not texture then return '' end
    local icon = format('|T%s:16:16:0:0:50:50:4:46:4:46|t', texture)
    return icon
end

local function StarterChecked()
    return GetStarterBuildActive and GetStarterBuildActive()
end

local function EnsureTalentUI()
    if IsAddOnLoaded("Blizzard_PlayerSpells") then
        return true
    end

    local loaded, reason = UIParentLoadAddOn("Blizzard_PlayerSpells")

    if not loaded then
        print(format(L["Failed to load Blizzard_PlayerSpells: %s"], tostring(reason)))
        return false
    end

    return true
end

local queuedLoadoutID
local LoadoutFunc
do
    LoadoutFunc = function(_, arg1)
        if arg1 == STARTER_ID then
            if GetStarterBuildActive() then
                return
            end
            if not InCombatLockdown() then
                SetStarterBuildActive(true)
            end
            return
        end

        if not InCombatLockdown() then
            queuedLoadoutID = arg1
            C_ClassTalents.LoadConfig(arg1, true)
        end
    end
end

local function MenuChecked(data) return data and data.arg1 == GetLootSpecialization() end
local function MenuFunc(_, arg1) SetLootSpecialization(arg1) end

local function SpecChecked(data) return data and data.arg1 == GetSpecialization() end
local function SpecFunc(_, arg1) SetSpecialization(arg1) end

local function WrapMenuFunc(func, closeMenu)
    return function(self, arg1)
        --print("Wrapped menu func called", tostring(func))
        if func then
            func(self, arg1)
        end
        if DropDownList1 then
            DropDownList1:Hide()
        end
    end
end

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end

    local activeSpecIndex = nil
    local activeLoadoutText = ""

    ----------------------------------------------------
    -- Build/refresh menus and lists (called from OnEvent once)
    ----------------------------------------------------
    local function BuildSpecAndLootLists()
        if #menuList <= 2 then
            local n = GetNumSpecializations and GetNumSpecializations() or 0
            for index = 1, n do
                local id, name, _, icon = GetSpecializationInfo(index)
                if id then
                    tinsert(menuList, { arg1 = id, text = name, checked = MenuChecked, func = WrapMenuFunc(MenuFunc, menuFrame) })
                    tinsert(specList, { arg1 = index, text = format('|T%s:16:16:0:0|t  %s', icon or "", name), checked = SpecChecked, func = WrapMenuFunc(SpecFunc, menuFrame) })
                end
            end
        end
    end

    local function BuildLoadoutList()
        local builds = nil
        local classTalentsAvailable = GetConfigIDsBySpecID and GetLastSelectedSavedConfigID
        local specIndex = GetSpecialization()
        local info = specIndex and (select(1, GetSpecializationInfo(specIndex)) and { id = select(1, GetSpecializationInfo(specIndex)), icon = select(4, GetSpecializationInfo(specIndex)), name = select(2, GetSpecializationInfo(specIndex)) } or nil)

        loadoutList = { { text = L["Loadouts"], isTitle = true, notCheckable = true } } -- recreate
        if classTalentsAvailable and info and info.id then
            builds = GetConfigIDsBySpecID(info.id) or {}
            -- include starter if supported
            if GetHasStarterBuild and GetHasStarterBuild() and STARTER_ID then
                tinsert(builds, STARTER_ID)
            end

            for idx, configID in ipairs(builds) do
                if configID == STARTER_ID then
                    tinsert(loadoutList, {
                        text = format('|cff%02x%02x%02x%s|r', BLUE_FONT_COLOR.r*255, BLUE_FONT_COLOR.g*255, BLUE_FONT_COLOR.b*255, L["Starter Build"]),
                        checked = StarterChecked,
                        func = WrapMenuFunc(LoadoutFunc, menuFrame),
                        arg1 = STARTER_ID
                    })
                else
                    local configInfo = C_Traits_GetConfigInfo and C_Traits_GetConfigInfo(configID)
                    tinsert(loadoutList, {
                        text = (configInfo and configInfo.name) or UNKNOWN,
                        checked = function(data) 
                            local active = GetLastSelectedSavedConfigID and GetLastSelectedSavedConfigID(info.id) or nil
                            return active and data.arg1 == active
                        end,
                        func = WrapMenuFunc(LoadoutFunc, menuFrame),
                        arg1 = configID })
                end
            end
        end
    end

    ----------------------------------------------------
    -- Update displayed text
    ----------------------------------------------------
    local function UpdateDisplay()
        BuildSpecAndLootLists()

        local specLoot = GetLootSpecialization()
        local specIndex = GetSpecialization()
        local infoName, infoIcon, infoID

        if specIndex then
            local id, name, _, icon = GetSpecializationInfo(specIndex)
            infoName = name
            infoIcon = icon
            infoID = id
        end

        if not infoID then
            text:SetText("|cff9d9d9d?") -- can't determine spec yet
            return
        end

        activeSpecIndex = specIndex

        -- Build activeLoadoutText (if class talents supported)
        local activeLoadout = ""
        if CanUseClassTalents and CanUseClassTalents() and GetLastSelectedSavedConfigID then
            local classTalentID = GetLastSelectedSavedConfigID(infoID)
            if classTalentID == STARTER_ID then
                activeLoadout = "|cff00aaffStarter|r"
            elseif classTalentID then
                local cfg = C_Traits_GetConfigInfo and C_Traits_GetConfigInfo(classTalentID)
                activeLoadout = cfg and cfg.name or ""
            end
        end

        activeLoadoutText = activeLoadout or ""

        -- Compose main display: icon + spec name (and optionally loadout)
        local mainIconSize = 16
        local specIcon = infoIcon and format('|T%s:%d:%d:0:0:64:64:4:60:4:60|t', infoIcon, mainIconSize, mainIconSize) or ""
        local display = specIcon .. " " .. (infoName or UNKNOWN)

        -- If loot spec differs or has special case, show both icons (mimic ElvUI logic)
        if specLoot and specLoot ~= 0 and specLoot ~= infoID then
            local lootIcon
            -- get icon for loot spec if possible (need to map loot spec id to index)
            for idx = 1, GetNumSpecializations() or 0 do
                local id2, name2, _, icon2 = GetSpecializationInfo(idx)
                if id2 == specLoot then
                    lootIcon = icon2
                    break
                end
            end
            if lootIcon then
                display = format('%s: %s %s: %s', L["Spec"], specIcon .. " " .. infoName or UNKNOWN, LOOT, format('|T%s:%d:%d:0:0:64:64:4:60:4:60|t', lootIcon, mainIconSize, mainIconSize))
            end
        end

        if activeLoadoutText and activeLoadoutText ~= "" then
            display = SDT:ColorText(strjoin('', display, ' / ', activeLoadoutText))
        end

        text:SetText(display)
    end

    f.Update = UpdateDisplay

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, SDT:FindBestAnchorPoint(self))
        GameTooltip:ClearLines()
        GameTooltip:AddLine(SDT:ColorText(SPECIALIZATION))
        GameTooltip:AddLine(" ")

        for i = 1, GetNumSpecializations() or 0 do
            local id, name, _, icon = GetSpecializationInfo(i)
            if id and name then
                local activeMark = (i == activeSpecIndex) and activeString or inactiveString
                GameTooltip:AddLine(strjoin(' ', SDT:ColorText(name), AddTexture(icon), (i == activeSpecIndex and activeString or inactiveString)), 1, 1, 1)
            end
        end

        GameTooltip:AddLine(' ')

        local specLoot = GetLootSpecialization()
        local sameSpec = (specLoot == 0) and GetSpecialization()
        local specIndex = (sameSpec and sameSpec) or specLoot
        if specIndex and specIndex ~= 0 then
            local id, name, _, icon = GetSpecializationInfo((specIndex ~= 0 and specIndex) or GetSpecialization())
            if name then
                if specLoot == 0 then
                    GameTooltip:AddLine(format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, format(LOOT_SPECIALIZATION_DEFAULT, name)))
                else
                    GameTooltip:AddLine(format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, name))
                end
            end
        end

        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(L["Loadouts"], 0.69, 0.31, 0.31)

        BuildLoadoutList()
        for index, loadout in ipairs(loadoutList) do
            if index > 1 then
                local textStr = (type(loadout.checked) == "function" and loadout.checked(loadout) and activeString) or inactiveString
                GameTooltip:AddLine(strjoin(' - ', loadout.text, textStr), 1, 1, 1)
            end
        end

        if C_SpecializationInfo_GetAllSelectedPvpTalentIDs then
            local pvpTalents = C_SpecializationInfo_GetAllSelectedPvpTalentIDs()
            if pvpTalents and next(pvpTalents) then
                GameTooltip:AddLine(' ')
                GameTooltip:AddLine(PVP_TALENTS, 0.69, 0.31, 0.31)
                local i = 0
                for _, talentID in next, pvpTalents do
                    i = i + 1
                    if i > 4 then break end
                    local name, _, icon, _, _, _, unlocked = GetPvpTalentInfoByID and GetPvpTalentInfoByID(talentID) or nil
                    if name and unlocked then
                        GameTooltip:AddLine(AddTexture(icon) .. ' ' .. name)
                    end
                end
            end
        end

        GameTooltip:AddLine(' ')
        GameTooltip:AddLine("|cffFFFFFF" .. L["Left Click: Change Talent Specialization"] .. "|r")
        GameTooltip:AddLine("|cffFFFFFF" .. L["Control + Left Click: Change Loadout"] .. "|r")
        GameTooltip:AddLine("|cffFFFFFF" .. L["Shift + Left Click: Show Talent Specialization UI"] .. "|r")
        GameTooltip:AddLine("|cffFFFFFF" .. L["Shift + Right Click: Change Loot Specialization"] .. "|r")
        GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function (self, button)
        local menuFrame = CreateFrame("Frame", "SDT_SpecMenuFrame", UIParent, "UIDropDownMenuTemplate")
        local specIndex = GetSpecialization()
        if not specIndex then return end

        if button == "LeftButton" then
            if IsShiftKeyDown() then
                if not InCombatLockdown() then
                    TogglePlayerSpellsFrame()
                end
                return
            end

            if IsControlKeyDown() then
                BuildLoadoutList()
                CreateContextMenu(menuFrame, function(_, root) SDT:HandleMenuList(root, loadoutList, nil, 1) end)
            else
                BuildSpecAndLootLists()
                CreateContextMenu(menuFrame, function(_, root) SDT:HandleMenuList(root, specList, nil, 1) end)
            end
        elseif button == "RightButton" and IsShiftKeyDown() then
            BuildSpecAndLootLists()
            local _, curName = GetSpecializationInfo(GetSpecialization())
            if menuList[2] then
                menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, curName or UNKNOWN)
            end
            CreateContextMenu(menuFrame, function(_, root) SDT:HandleMenuList(root, menuList, nil, 1) end)
        end
    end)

    ----------------------------------------------------
    -- Event handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        if event == "TRAIT_CONFIG_UPDATED" and queuedLoadoutID then
            C_ClassTalents.UpdateLastSelectedSavedConfigID(GetCurrentSpecID(), queuedLoadoutID)
            queuedLoadoutID = nil
        elseif event == "CONFIG_COMMIT_FAILED" then
            queuedLoadoutID = nil
        end
        BuildSpecAndLootLists()
        BuildLoadoutList()

        UpdateDisplay()
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
    f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    f:RegisterEvent("PLAYER_TALENT_UPDATE")
    f:RegisterEvent("TRAIT_CONFIG_DELETED")
    f:RegisterEvent("TRAIT_CONFIG_UPDATED")
    f:RegisterEvent("CONFIG_COMMIT_FAILED")

    UpdateDisplay()

    return f
end

-- Register with SDT
SDT:RegisterDataText("Talent/Loot Specialization", mod)

return mod
