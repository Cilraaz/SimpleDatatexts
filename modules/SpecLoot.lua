-- modules/SpecLoot.lua
-- SpecLoot datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format  = format
local tinsert = table.insert
local strjoin = strjoin

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetLootSpecialization      = GetLootSpecialization
local GetNumSpecializations      = GetNumSpecializations
local GetSpecialization          = GetSpecialization
local GetSpecializationInfo      = GetSpecializationInfo
local GetSpecializationInfoByID  = GetSpecializationInfoByID
local SetLootSpecialization      = SetLootSpecialization
-- MenuUtil
local CreateContextMenu          = MenuUtil.CreateContextMenu

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local LOOT                        = LOOT
local UNKNOWN                     = UNKNOWN
local SELECT_LOOT_SPECIALIZATION  = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Loot Specialization"

----------------------------------------------------
-- Lists
----------------------------------------------------
local menuList = {
    { text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
    { checked = function() return GetLootSpecialization() == 0 end, func = function() SetLootSpecialization(0) end }
}

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", "Show Label", "showLabel", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Loot Specialization Icon"], "showLootSpecIcon", true)
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Loot Specialization Text"], "showLootSpecText", true)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Helpers
----------------------------------------------------
local function AddTexture(texture)
    if not texture then return '' end
    return format('|T%s:16:16:0:0:50:50:4:46:4:46|t', texture)
end

local function MenuChecked(data) return data and data.arg1 == GetLootSpecialization() end
local function MenuFunc(_, arg1) SetLootSpecialization(arg1) end

local function WrapMenuFunc(func)
    return function(self, arg1)
        if func then func(self, arg1) end
        if DropDownList1 then DropDownList1:Hide() end
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
    local menuFrame = CreateFrame("Frame", "SDT_LootSpecMenuFrame", UIParent, "UIDropDownMenuTemplate")

    ----------------------------------------------------
    -- Build/refresh the loot spec menu list
    ----------------------------------------------------
    local function BuildLootSpecList()
        if #menuList <= 2 then
            local n = GetNumSpecializations and GetNumSpecializations() or 0
            for index = 1, n do
                local id, name, _, icon = GetSpecializationInfo(index)
                if id then
                    tinsert(menuList, {
                        arg1 = id,
                        text = format('|T%s:16:16:0:0|t  %s', icon or "", name),
                        checked = MenuChecked,
                        func = WrapMenuFunc(MenuFunc)
                    })
                end
            end
        end

        -- Always keep entry 2 current (the "use current spec" default option)
        local _, curName = GetSpecializationInfo(GetSpecialization())
        if menuList[2] then
            menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, curName or UNKNOWN)
        end
    end

    ----------------------------------------------------
    -- Update displayed text
    ----------------------------------------------------
    local function UpdateDisplay()
        local settings = {
            showLabel           = SDT:GetModuleSetting(moduleName, "showLabel", true),
            showLootSpecIcon    = SDT:GetModuleSetting(moduleName, "showLootSpecIcon", true),
            showLootSpecText    = SDT:GetModuleSetting(moduleName, "showLootSpecText", true),
        }

        local specIndex = GetSpecialization()
        if not specIndex then
            text:SetText("|cff9d9d9d?")
            SDT.FontManager:ApplyModuleFont(moduleName, text)
            return
        end

        local lootTag = settings.showLabel and LOOT..": " or ""
        local specLoot = GetLootSpecialization()

        local function formatLootDisplay(icon, name, showIcon, showText)
            if not (showIcon or showText) then return "" end
            local parts = {}
            if lootTag ~= "" then parts[#parts + 1] = lootTag end
            if showIcon and icon then
                parts[#parts + 1] = format('|T%s:16:16:0:0:64:64:4:60:4:60|t', icon)
            end
            if showText then
                parts[#parts + 1] = name or UNKNOWN
            end
            return table.concat(parts, showIcon and showText and " " or "")
        end

        local display = ""

        if specLoot == 0 then
            -- Loot spec is set to "current spec"
            if settings.showLootSpecIcon or settings.showLootSpecText then
                local _, _, _, currentIcon = GetSpecializationInfo(specIndex)
                local parts = {}
                if lootTag ~= "" then parts[#parts + 1] = lootTag end
                if settings.showLootSpecIcon and currentIcon then
                    parts[#parts + 1] = format('|T%s:16:16:0:0:64:64:4:60:4:60|t', currentIcon)
                end
                if settings.showLootSpecText then
                    parts[#parts + 1] = L["Current"]
                end
                display = table.concat(parts, settings.showLootSpecIcon and settings.showLootSpecText and " " or "")
            end
        else
            local infoID, infoName, _, infoIcon = GetSpecializationInfo(specIndex)
            local lootID, lootName, _, lootIcon = GetSpecializationInfoByID(specLoot)
            if lootID then
                display = formatLootDisplay(lootIcon, lootName, settings.showLootSpecIcon, settings.showLootSpecText)
            end
        end

        if display == "" then
            display = "|cff9d9d9d?|r"
        end

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
            SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, SELECT_LOOT_SPECIALIZATION)
            SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        end

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

        for i = 1, GetNumSpecializations() or 0 do
            local id, name, _, icon = GetSpecializationInfo(i)
            if id and name then
                local isLootSpec = (specLoot == 0 and i == GetSpecialization()) or (specLoot ~= 0 and id == specLoot)
                local statusStr = isLootSpec
                    and strjoin('', '|cff00FF00', _G.ACTIVE_PETS or L["Active"], '|r')
                    or  strjoin('', '|cffFF0000', _G.FACTION_INACTIVE or L["Inactive"], '|r')
                SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, strjoin(' ', SDT.FormatUtils:ColorModuleText(moduleName, name), AddTexture(icon), statusStr), nil, 1, 1, 1)
            end
        end

        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, L["Left Click: Change Loot Specialization"])

        SDT.Tooltip:Show()
    end)
    slotFrame:SetScript("OnLeave", function() SDT.Tooltip:Hide() end)

    ----------------------------------------------------
    -- Click Handler
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            BuildLootSpecList()
            CreateContextMenu(menuFrame, function(_, root) SDT:HandleMenuList(root, menuList, nil, 1) end)
        end
    end)

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        BuildLootSpecList()
        UpdateDisplay()
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
    f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

    UpdateDisplay()

    return f
end

-- Register with SDT
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod