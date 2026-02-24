-- modules/SpecSwitch.lua
-- SpecSwitch datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
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
local moduleName = "Talent/Loot Specialization"

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
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", "Show Label", "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Specialization Icon"], "showSpecIcon", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Specialization Text"], "showSpecText", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Loot Specialization Icon"], "showLootSpecIcon", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Loot Specialization Text"], "showLootSpecText", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Loot Spec When Current"], "showLootSpecCurrent", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Loadout"], "showLoadout", true)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

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

local function WrapMenuFunc(func)
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

    -- Create the menu frame for this module
    local menuFrame = CreateFrame("Frame", "SDT_SpecMenuFrame", UIParent, "UIDropDownMenuTemplate")

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
                    tinsert(menuList, { arg1 = id, text = name, checked = MenuChecked, func = WrapMenuFunc(MenuFunc) })
                    tinsert(specList, { arg1 = index, text = format('|T%s:16:16:0:0|t  %s', icon or "", name), checked = SpecChecked, func = WrapMenuFunc(SpecFunc) })
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
                        func = WrapMenuFunc(LoadoutFunc),
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
                        func = WrapMenuFunc(LoadoutFunc),
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

        -- Get our module settings
        local settings = {
            showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true),
            showSpecIcon = SDT:GetModuleSetting(moduleName, "showSpecIcon", true),
            showSpecText = SDT:GetModuleSetting(moduleName, "showSpecText", true),
            showLootSpecIcon = SDT:GetModuleSetting(moduleName, "showLootSpecIcon", true),
            showLootSpecText = SDT:GetModuleSetting(moduleName, "showLootSpecText", true),
            showLootSpecCurrent = SDT:GetModuleSetting(moduleName, "showLootSpecCurrent", true),
            showLoadout = SDT:GetModuleSetting(moduleName, "showLoadout", true)
        }

        local specIndex = GetSpecialization()
        if not specIndex then
            text:SetText("|cff9d9d9d?") -- can't determine spec yet
            SDT.FontManager:ApplyModuleFont(moduleName, text)
            return
        end

        local infoID, infoName, _, infoIcon = GetSpecializationInfo(specIndex)
        if not infoID then
            text:SetText("|cff9d9d9d?") -- can't determine spec yet
            SDT.FontManager:ApplyModuleFont(moduleName, text)
            return
        end

        activeSpecIndex = specIndex

        -- Build activeLoadoutText
        local activeLoadoutText = ""
        if CanUseClassTalents and CanUseClassTalents() and GetLastSelectedSavedConfigID then
            local classTalentID = GetLastSelectedSavedConfigID(infoID)
            if classTalentID == STARTER_ID then
                activeLoadoutText = "|cff00aaffStarter|r"
            elseif classTalentID then
                local cfg = C_Traits_GetConfigInfo and C_Traits_GetConfigInfo(classTalentID)
                activeLoadoutText = cfg and cfg.name or ""
            end
        end

        -- Helper function to format spec display
        local function formatSpecDisplay(icon, name, showIcon, showText, tag)
            if not (showIcon or showText) then return "" end

            local parts = {}
            if tag then parts[#parts + 1] = tag end
            if showIcon and icon then
                parts[#parts + 1] = format('|T%s:16:16:0:0:64:64:4:60:4:60|t', icon)
            end
            if showText then
                parts[#parts + 1] = name or UNKNOWN
            end

            return table.concat(parts, showIcon and showText and " " or "")
        end

        -- Start to build our display
        local displayParts = {}

        -- Main spec display
        local specTag = settings.showLabel and L["Spec"]..": " or ""
        local specDisplay = formatSpecDisplay(infoIcon, infoName, settings.showSpecIcon, settings.showSpecText, specTag)
        if specDisplay ~= "" then
            displayParts[#displayParts + 1] = specDisplay
        end

        -- Loot spec
        local specLoot = GetLootSpecialization()
        if specLoot == 0 then
            if settings.showLootSpecCurrent and (settings.showLootSpecIcon or settings.showLootSpecText) then
                local lootTag = settings.showLabel and LOOT..": " or ""
                local _, _, _, currentIcon = GetSpecializationInfo(specIndex)
                local parts = {}
                if lootTag ~= "" then parts[#parts + 1] = lootTag end
                if settings.showLootSpecIcon and currentIcon then
                    parts[#parts + 1] = format('|T%s:16:16:0:0:64:64:4:60:4:60|t', currentIcon)
                end
                if settings.showLootSpecText then
                    parts[#parts + 1] = L["Current"]
                end
                local lootDisplay = table.concat(parts, settings.showLootSpecIcon and settings.showLootSpecText and " " or "")
                if lootDisplay ~= "" then
                    displayParts[#displayParts + 1] = lootDisplay
                end
            end
        elseif specLoot ~= infoID or settings.showLootSpecCurrent then
            local lootID, lootName, _, lootIcon = GetSpecializationInfoByID(specLoot)
            if lootID then
                local lootTag = settings.showLabel and LOOT..": " or ""
                local lootDisplay = formatSpecDisplay(lootIcon, lootName, settings.showLootSpecIcon, settings.showLootSpecText, lootTag)
                if lootDisplay ~= "" then
                    displayParts[#displayParts + 1] = lootDisplay
                end
            end
        end

        -- Loadout
        if settings.showLoadout and activeLoadoutText ~= "" then
            displayParts[#displayParts + 1] = activeLoadoutText
        end

        local display = table.concat(displayParts, " / ")
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, display))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end

    f.Update = UpdateDisplay

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnEnter", function(self)
        SDT.Tooltip:SetOwner(self, SDT.FormatUtils:FindBestAnchorPoint(self))
        SDT.Tooltip:ClearLines()
        if not SDT.db.profile.hideModuleTitle then
            SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, SPECIALIZATION)
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end

        for i = 1, GetNumSpecializations() or 0 do
            local id, name, _, icon = GetSpecializationInfo(i)
            if id and name then
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, strjoin(' ', SDT.FormatUtils:ColorModuleText(moduleName, name), AddTexture(icon), (i == activeSpecIndex and activeString or inactiveString)), nil, 1, 1, 1)
            end
        end

        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")

        local specLoot = GetLootSpecialization()
        local sameSpec = (specLoot == 0) and GetSpecialization()
        local specIndex = (sameSpec and sameSpec) or specLoot
        if specIndex and specIndex ~= 0 then
            local id, name, _, icon = GetSpecializationInfo((specIndex ~= 0 and specIndex) or GetSpecialization())
            if name then
                if specLoot == 0 then
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, format(LOOT_SPECIALIZATION_DEFAULT, name)))
                else
                    SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, format('|cffFFFFFF%s:|r %s', SELECT_LOOT_SPECIALIZATION, name))
                end
            end
        end

        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Loadouts"], nil, 0.69, 0.31, 0.31)

        BuildLoadoutList()
        for index, loadout in ipairs(loadoutList) do
            if index > 1 then
                local textStr = (type(loadout.checked) == "function" and loadout.checked(loadout) and activeString) or inactiveString
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, strjoin(' - ', loadout.text, textStr), nil, 1, 1, 1)
            end
        end

        if C_SpecializationInfo_GetAllSelectedPvpTalentIDs then
            local pvpTalents = C_SpecializationInfo_GetAllSelectedPvpTalentIDs()
            if pvpTalents and next(pvpTalents) then
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, PVP_TALENTS, nil, 0.69, 0.31, 0.31)
                local i = 0
                for _, talentID in next, pvpTalents do
                    i = i + 1
                    if i > 4 then break end
                    local name, _, icon, _, _, _, unlocked = GetPvpTalentInfoByID and GetPvpTalentInfoByID(talentID) or nil
                    if name and unlocked then
                        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, AddTexture(icon) .. ' ' .. name)
                    end
                end
            end
        end

        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, "|cffFFFFFF" .. L["Left Click: Change Talent Specialization"] .. "|r")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, "|cffFFFFFF" .. L["Control + Left Click: Change Loadout"] .. "|r")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, "|cffFFFFFF" .. L["Shift + Left Click: Show Talent Specialization UI"] .. "|r")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, "|cffFFFFFF" .. L["Shift + Right Click: Change Loot Specialization"] .. "|r")
        SDT.Tooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function (self, button)
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
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
