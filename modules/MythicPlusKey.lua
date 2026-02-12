-- modules/MythicPlusKey.lua
-- Mythic+ Keystone datatext for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local CreateFrame = CreateFrame
local format = string.format

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local C_MythicPlus = C_MythicPlus
local C_ChallengeMode = C_ChallengeMode
local C_Container = C_Container
local C_Spell_GetSpellCooldown = C_Spell.GetSpellCooldown
local C_SpellBook_IsSpellKnown = C_SpellBook.IsSpellKnown
local PVEFrame_ShowFrame = PVEFrame_ShowFrame

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Mythic+ Keystone"
local keystoneItemID = 180653 -- Mythic Keystone item ID

----------------------------------------------------
-- Dungeon Name Abbreviations
----------------------------------------------------
local dungeonAbbreviations = {
    -- Wrath of the Lich King
    ["Pit of Saron"] = "PIT",

    -- Cataclysm
    ["The Vortex Pinnacle"] = "VP",
    ["Throne of the Tides"] = "TOTT",
    ["Grim Batol"] = "GB",

    -- Mists of Pandaria
    ["Temple of the Jade Serpent"] = "TJS",
    ["Stormstout Brewery"] = "SSB",
    ["Gate of the Setting Sun"] = "GOTSS",
    ["Shado-Pan Monastery"] = "SPM",
    ["Siege of Niuzao Temple"] = "SNT",
    ["Mogu'shan Palace"] = "MSP",
    ["Scholomance"] = "SCHOLO",
    ["Scarlet Halls"] = "SH",
    ["Scarlet Monastery"] = "SM",

    -- Warlords of Draenor
    ["Skyreach"] = "SKY",
    ["Bloodmaul Slag Mines"] = "BSM",
    ["Auchindoun"] = "AUCH",
    ["Shadowmoon Burial Grounds"] = "SBG",
    ["Grimrail Depot"] = "GD",
    ["Upper Blackrock Spire"] = "UBRS",
    ["The Everbloom"] = "EB",
    ["Iron Docks"] = "ID",

    -- Legion
    ["Eye of Azshara"] = "EOA",
    ["Darkheart Thicket"] = "DT",
    ["Black Rook Hold"] = "BRH",
    ["Halls of Valor"] = "HOV",
    ["Neltharion's Lair"] = "NL",
    ["Vault of the Wardens"] = "VAULT",
    ["Maw of Souls"] = "MOS",
    ["The Arcway"] = "ARC",
    ["Court of Stars"] = "COS",
    ["Return to Karazhan: Lower"] = "LKARA",
    ["Cathedral of Eternal Night"] = "CATH",
    ["Return to Karazhan: Upper"] = "UKARA",
    ["Seat of the Triumvirate"] = "SEAT",

    -- Battle for Azeroth
    ["Atal'Dazar"] = "AD",
    ["Freehold"] = "FH",
    ["Tol Dagor"] = "TD",
    ["The MOTHERLODE!!"] = "ML",
    ["Waycrest Manor"] = "WM",
    ["Kings' Rest"] = "KR",
    ["Temple of Sethraliss"] = "SETH",
    ["The Underrot"] = "UNDR",
    ["Shrine of the Storm"] = "SHRINE",
    ["Siege of Boralus"] = "SIEGE",
    ["Operation: Mechagon - Junkyard"] = "YARD",
    ["Operation: Mechagon - Workshop"] = "WORK",

    -- Shadowlands
    ["Mists of Tirna Scithe"] = "MISTS",
    ["The Necrotic Wake"] = "NW",
    ["De Other Side"] = "DOS",
    ["Halls of Atonement"] = "HOA",
    ["Plaguefall"] = "PF",
    ["Sanguine Depths"] = "SD",
    ["Spires of Ascension"] = "SOA",
    ["Theater of Pain"] = "TOP",
    ["Tazavesh: Streets of Wonder"] = "STRT",
    ["Tazavesh: So'leah's Gambit"] = "GMBT",

    -- Dragonflight
    ["Ruby Life Pools"] = "RLP",
    ["The Nokhud Offensive"] = "NO",
    ["The Azure Vault"] = "AV",
    ["Algeth'ar Academy"] = "AA",
    ["Uldaman: Legacy of Tyr"] = "ULD",
    ["Neltharus"] = "NELTH",
    ["Brackenhide Hollow"] = "BH",
    ["Halls of Infusion"] = "HOI",
    ["Dawn of the Infinite: Galakrond's Fall"] = "DOTI",
    ["Dawn of the Infinite: Murozond's Rise"] = "DOTI",

    -- The War Within
    ["Priory of the Sacred Flame"] = "PSF",
    ["The Rookery"] = "ROOK",
    ["The Stonevault"] = "SV",
    ["City of Threads"] = "COT",
    ["Ara-Kara, City of Echoes"] = "ARA",
    ["Darkflame Cleft"] = "DFC",
    ["The Dawnbreaker"] = "DAWN",
    ["Cinderbrew Meadery"] = "BREW",
    ["Operation: Floodgate"] = "FLOOD",
    ["Eco-Dome Al'dani"] = "EDA",

    -- Midnight (12.x)
    ["Windrunner Spire"] = "WIND",
    ["Magisters' Terrace"] = "MAGI",
    ["Nexus-Point Xenas"] = "XENAS",
    ["Maisara Caverns"] = "CAVNS",
    ["Murder Row"] = "MURDR",
    ["The Blinding Vale"] = "BLIND",
    ["Den of Nalorakk"] = "NALO",
    ["The Foraging"] = "FORAG",
    ["Voidscar Arena"] = "VSCAR",
    ["The Heart of Rage"] = "RAGE",
    ["Voidstorm"] = "VSTORM",
    -- Fallback: take first letters of each word
}

local dungeonTeleportSpells = {
    -- Wrath of the Lick King
    [556] = {1254555},  -- Pit of Saron

    -- Cataclysm
    [438] = {410080},  -- The Vortex Pinnacle
    [456] = {424142},  -- Throne of the Tides
    [507] = {445424},  -- Grim Batol
    
    -- Pandaria
    [2]   = {131204},  -- Temple of the Jade Serpent
    [56]  = {131205},  -- Stormstout Brewery
    [57]  = {131225},  -- Gate of the Setting Sun
    [58]  = {131206},  -- Shado-Pan Monastery
    [59]  = {131228},  -- Siege of Niuzao Temple
    [60]  = {131222},  -- Mogu'shan Palace
    [76]  = {131232},  -- Scholomance
    [77]  = {131231},  -- Scarlet Halls
    [78]  = {131229},  -- Scarlet Monastery
    
    -- Warlords of Draenor
    [161] = {159898, 1254557}, -- Skyreach
    [163] = {159895},  -- Bloodmaul Slag Mines
    [164] = {159897},  -- Auchindoun
    [165] = {159899},  -- Shadowmoon Burial Grounds
    [166] = {159900},  -- Grimrail Depot
    [167] = {159902},  -- Upper Blackrock Spire
    [168] = {159901},  -- The Everbloom
    [169] = {159896},  -- Iron Docks
    
    -- Legion
    [197] = {},        -- Eye of Azshara
    [198] = {424163},  -- Darkheart Thicket
    [199] = {424153},  -- Black Rook Hold
    [200] = {393764},  -- Halls of Valor
    [206] = {410078},  -- Neltharion's Lair
    [207] = {},        -- Vault of the Wardens
    [208] = {},        -- Maw of Souls
    [209] = {},        -- The Arcway
    [210] = {393766},  -- Court of Stars
    [227] = {373262},  -- Lower Karazhan
    [233] = {},        -- Cathedral of Eternal Night
    [234] = {373262},  -- Upper Karazhan
    [239] = {1254551}, -- Seat of the Triumvirate
    
    -- Battle for Azeroth
    [244] = {424187},  -- Atal'Dazar
    [245] = {410071},  -- Freehold
    [246] = {},        -- Tol Dagor
    [247] = {467553, 467555}, -- The MOTHERLODE!!
    [248] = {424167},  -- Waycrest Manor
    [249] = {},        -- Kings' Rest
    [250] = {},        -- Temple of Sethraliss
    [251] = {410074},  -- The Underrot
    [252] = {},        -- Shrine of the Storm
    [353] = {445418, 464256}, -- Siege of Boralus
    [369] = {373274},  -- Mechagon Junkyard
    [370] = {373274},  -- Mechagon Workshop
    
    -- Shadowlands
    [375] = {354464},  -- Mists of Tirna Scithe
    [376] = {354462},  -- The Necrotic Wake
    [377] = {354468},  -- De Other Side
    [378] = {354465},  -- Halls of Atonement
    [379] = {354463},  -- Plaguefall
    [380] = {354469},  -- Sanguine Depths
    [381] = {354466},  -- Spires of Ascension
    [382] = {354467},  -- Theater of Pain
    [391] = {367416},  -- Tazavesh: Streets of Wonder
    [392] = {367416},  -- Tazavesh: So'leah's Gambit
    
    -- Dragonflight
    [399] = {393256},  -- Ruby Life Pools
    [400] = {393262},  -- The Nokhud Offensive
    [401] = {393279},  -- The Azure Vault
    [402] = {393273},  -- Algeth'ar Academy
    [403] = {393222},  -- Uldaman: Legacy of Tyr
    [404] = {393276},  -- Neltharus
    [405] = {393267},  -- Brackenhide Hollow
    [406] = {393283},  -- Halls of Infusion
    [463] = {424197},  -- Dawn of the Infinite: Galakrond's Fall
    [464] = {424197},  -- Dawn of the Infinite: Murozond's Rise
    
    -- The War Within
    [499] = {445444},  -- Priory of the Sacred Flame
    [500] = {445443},  -- The Rookery
    [501] = {445269},  -- The Stonevault
    [502] = {445416},  -- City of Threads
    [503] = {445417},  -- Ara-Kara, City of Echoes
    [504] = {445441},  -- Darkflame Cleft
    [505] = {445414},  -- The Dawnbreaker
    [506] = {445440},  -- Cinderbrew Meadery
    [525] = {1216786}, -- Operation: Floodgate
    [542] = {1237215}, -- Eco-Dome Al'dani
	
	-- Midnight
	[557] = {1254400}, -- Windrunner Spire
	[558] = {1254572}, -- Magisters' Terrace
	[559] = {1254563}, -- Nexus-Point Xenas
	[560] = {1254559}, -- Maisara Caverns
}

local function GetDungeonAbbreviation(fullName)
    if dungeonAbbreviations[fullName] then
        return dungeonAbbreviations[fullName]
    end
    
    -- Fallback: Create abbreviation from first letters
    local abbrev = ""
    for word in fullName:gmatch("%S+") do
        -- Skip common articles and prepositions
        local lowerWord = word:lower()
        if lowerWord ~= "the" and lowerWord ~= "of" and lowerWord ~= "a" and lowerWord ~= "an" then
            abbrev = abbrev .. word:sub(1, 1):upper()
        end
    end
    
    return abbrev ~= "" and abbrev or fullName:sub(1, 4):upper()
end

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)

    SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

----------------------------------------------------
-- Tooltip Functions
----------------------------------------------------
local function ShowTooltip(slotFrame, keystoneLevel, dungeonName)
    local anchor = SDT.FormatUtils:FindBestAnchorPoint(slotFrame)
    SDT.Tooltip:SetOwner(slotFrame, anchor)
    SDT.Tooltip:ClearLines()

    if not SDT.db.profile.hideModuleTitle then
        SDT.FormatUtils:AddTooltipHeader(SDT.Tooltip, nil, L["Mythic+ Keystone"])
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
    end

    if keystoneLevel and dungeonName then
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, SDT.db.profile.tooltipLineFontSize + 2, L["Current Key:"], format("+%d %s", keystoneLevel, dungeonName), 1, 0.82, 0, 1, 1, 1)
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, " ")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, "|cFFffffff" .. L["Left Click: Teleport to Dungeon"] .. "|r")
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, nil, "|cFFffffff" .. L["Right Click: List Group in Finder"] .. "|r")
    else
        SDT.FormatUtils:AddTooltipLine(SDT.Tooltip, SDT.db.profile.tooltipLineFontSize + 2, L["No Mythic+ Keystone"], nil, 1, 0.82, 0)
    end

    SDT.Tooltip:Show()
end

----------------------------------------------------
-- Keystone Functions
----------------------------------------------------
local function FindKeystoneInBags()
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemID = C_Container.GetContainerItemID(bag, slot)
            if itemID == keystoneItemID then
                return bag, slot
            end
        end
    end
    return nil, nil
end

local function GetKeystoneInfo()
    local mapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    local level = C_MythicPlus.GetOwnedKeystoneLevel()
    
    if mapID and level then
        local name = C_ChallengeMode.GetMapUIInfo(mapID)
        if name then
            return level, name, mapID
        end
    end
    
    return nil, nil, nil
end

----------------------------------------------------
-- Click Functions
----------------------------------------------------
local function UpdateSecureAttributes(slotFrame)
    if InCombatLockdown() then
        return
    end
    
    local secureButton = slotFrame.secureButton
    if not secureButton then
        return
    end
    
    local _, dungeonName, mapID = GetKeystoneInfo()
    if not mapID then return end
    
    local teleportKnown = false
    for _, spellID in ipairs(dungeonTeleportSpells[mapID]) do
        if C_SpellBook_IsSpellKnown(spellID) then
            teleportKnown = true
            local CDInfo = C_Spell_GetSpellCooldown(spellID)
            local CDR = CDInfo.timeUntilEndOfStartRecovery or 0
            if CDInfo.startTime == 0 then
                secureButton:SetAttribute("type", "spell")
                secureButton:SetAttribute("spell", spellID)
            else
                SDT:Print(L["Dungeon Teleport is on cooldown for "] .. math.floor(CDR) .. L[" more seconds."])
            end
            break
        end
    end

    if not teleportKnown then
        SDT:Print(L["You do not know the teleport spell for "] .. dungeonName .. ".")
    end
end

local function OnClick(slotFrame, button)
    if button == "RightButton" and not IsControlKeyDown() then
        -- Open group finder to list a group
        if not PVEFrame:IsShown() then
            PVEFrame_ShowFrame("GroupFinderFrame", LFGListPVEStub)
            C_Timer.After(0.1, function()
                GroupFinderFrameGroupButton3:Click()
                LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 2, 0)
                --LFGListFrame.CategorySelection.StartGroupButton:Click()
            end)
        else
            HideUIPanel(PVEFrame)
        end
    end
end

----------------------------------------------------
-- Module Creation
----------------------------------------------------
function mod.Create(slotFrame)
    -- Create a secure action button FIRST as a direct child of slotFrame
    local secureButton = CreateFrame("Button", nil, slotFrame, "SecureActionButtonTemplate")
    secureButton:SetAllPoints(slotFrame)
    secureButton:EnableMouse(true)
    secureButton:RegisterForClicks("LeftButtonDown", "RightButtonUp")
    secureButton:SetAttribute("type", "item")
    secureButton:SetFrameLevel(100)  -- Very high to ensure it's on top
    slotFrame.secureButton = secureButton

    -- Create our event frame
    local f = CreateFrame("Frame", nil, slotFrame)
    f:SetAllPoints(slotFrame)
    f:EnableMouse(false)

    local text = slotFrame.text
    if not text then
        text = slotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        slotFrame.text = text
    end

    local keystoneLevel, dungeonName, mapID

    ----------------------------------------------------
    -- Update logic
    ----------------------------------------------------
    local function UpdateKeystone()
        keystoneLevel, dungeonName, mapID = GetKeystoneInfo()
        
        local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", false)
        local displayText
        
        if keystoneLevel and dungeonName then
            local abbrev = GetDungeonAbbreviation(dungeonName)
            displayText = format("%s+%d %s", showLabel and L["Key: "] or "", keystoneLevel, abbrev)
        else
            displayText = showLabel and L["Key: "] .. L["None"] or L["No Key"]
        end
        
        text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, displayText))
        SDT.FontManager:ApplyModuleFont(moduleName, text)
    end
    f.Update = UpdateKeystone

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        UpdateKeystone()
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("CHALLENGE_MODE_KEYSTONE_SLOTTED")
    f:RegisterEvent("BAG_UPDATE")
    f:RegisterEvent("ITEM_CHANGED")

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    secureButton:SetScript("OnEnter", function(self)
        ShowTooltip(slotFrame, keystoneLevel, dungeonName)
    end)

    secureButton:SetScript("OnLeave", function()
        SDT.Tooltip:Hide()
    end)

    ----------------------------------------------------
    -- PreClick Handler - randomize hearthstone before click
    ----------------------------------------------------
    secureButton:SetScript("PreClick", function(self, button)
        if button == "LeftButton" and not InCombatLockdown() then
            UpdateSecureAttributes(slotFrame)
        end
    end)
    
    ----------------------------------------------------
    -- PostClick Handler - for right-click menu
    ----------------------------------------------------
    secureButton:SetScript("PostClick", function(self, button)
        if button == "RightButton" then
            if IsControlKeyDown() then
                -- Pass through to slotFrame for config menu
                local originalHandler = slotFrame:GetScript("OnMouseUp")
                if originalHandler then
                    originalHandler(slotFrame, button)
                end
            else
                -- Show hearthstone selection menu
                OnClick(slotFrame, button)
            end
        end
    end)

    UpdateKeystone()
    UpdateSecureAttributes(slotFrame)

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod