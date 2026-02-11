-- modules/Agility.lua
-- Agility datatext adapted from ElvUI for Simple DataTexts (SDT)
local SDT = SimpleDatatexts
local L = SDT.L

local mod = {}

----------------------------------------------------
-- Lua Locals
----------------------------------------------------
local format = format
local ipairs = ipairs
local strfind = strfind
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local twipe = table.wipe

----------------------------------------------------
-- WoW API Locals
----------------------------------------------------
local GetCVar = C_CVar.GetCVar
local GetCVarBool = C_CVar.GetCVarBool
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local IsShiftKeyDown = IsShiftKeyDown
local ShowOptionsPanel = ShowOptionsPanel
local Sound_GameSystem_GetNumOutputDrivers = Sound_GameSystem_GetNumOutputDrivers
local Sound_GameSystem_GetOutputDriverNameByIndex = Sound_GameSystem_GetOutputDriverNameByIndex
local Sound_GameSystem_RestartSoundSystem = Sound_GameSystem_RestartSoundSystem
-- MenuUtil
local CreateContextMenu = MenuUtil.CreateContextMenu

----------------------------------------------------
-- WoW Data Tables
----------------------------------------------------
local Sound_CVars = {
	Sound_EnableAllSound = true,
	Sound_EnableSFX = true,
	Sound_EnableAmbience = true,
	Sound_EnableDialog = true,
	Sound_EnableMusic = true,
	Sound_MasterVolume = true,
	Sound_SFXVolume = true,
	Sound_AmbienceVolume = true,
	Sound_DialogVolume = true,
	Sound_MusicVolume = true
}

local AudioStreams = {
	{ Name = _G.MASTER_VOLUME, Volume = 'Sound_MasterVolume', Enabled = 'Sound_EnableAllSound' },
	{ Name = _G.SOUND_VOLUME or _G.FX_VOLUME, Volume = 'Sound_SFXVolume', Enabled = 'Sound_EnableSFX' },
	{ Name = _G.AMBIENCE_VOLUME, Volume = 'Sound_AmbienceVolume', Enabled = 'Sound_EnableAmbience' },
	{ Name = _G.DIALOG_VOLUME, Volume = 'Sound_DialogVolume', Enabled = 'Sound_EnableDialog' },
	{ Name = _G.MUSIC_VOLUME, Volume = 'Sound_MusicVolume', Enabled = 'Sound_EnableMusic' }
}

local panelText
local activeIndex = 1
local activeStream = AudioStreams[activeIndex]
local menu = {{ text = L["Select Volume Stream"], isTitle = true, notCheckable = true }}
local toggleMenu = {{ text = L["Toggle Volume Stream"], isTitle = true, notCheckable = true }}
local deviceMenu = {{ text = L["Output Audio Device"], isTitle = true, notCheckable = true }}

----------------------------------------------------
-- Constants Locals
----------------------------------------------------
local SOUND = SOUND

----------------------------------------------------
-- File Locals
----------------------------------------------------
local moduleName = "Volume"

----------------------------------------------------
-- Module Config Settings
----------------------------------------------------
local function SetupModuleConfig()
    SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Label"], "showLabel", true)
	SDT.ModuleRegistry:AddModuleConfigSetting(moduleName, "checkbox", L["Show Short Label"], "showShortLabel", false)

	SDT.ModuleRegistry:GlobalModuleSettings(moduleName)
end

SetupModuleConfig()

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

    ----------------------------------------------------
    -- Helper Functions
    ----------------------------------------------------
    local function GetStreamString(stream, tooltip)
	    if not stream then stream = AudioStreams[1] end

	    local color = GetCVarBool(AudioStreams[1].Enabled) and GetCVarBool(stream.Enabled) and '00FF00' or 'FF3333'
	    local level = (GetCVar(stream.Volume) or 0) * 100

		local showLabel = SDT:GetModuleSetting(moduleName, "showLabel", true)
		local showShortLabel = SDT:GetModuleSetting(moduleName, "showShortLabel", false)
		local shortLabels = {
			[MASTER_VOLUME] = L["M. Vol"],
			[FX_VOLUME] = L["FX"],
			[AMBIENCE_VOLUME] = L["Amb"],
			[DIALOG_VOLUME] = L["Dlg"],
			[MUSIC_VOLUME] = L["Mus"]
		}
		local label = showLabel and (showShortLabel and shortLabels[stream.Name] or stream.Name) .. ": " or ""

	    return (tooltip and format('|cFF%s%.f%%|r', color, level)) or format('%s|cFF%s%.f%%|r', label, color, level)
    end

    local function SelectStream(_, arg1)
	    activeIndex = arg1
	    activeStream = AudioStreams[arg1]

	    slotFrame.text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, GetStreamString(activeStream)))
    end

    local function ToggleStream(_, arg1)
	    local Stream = AudioStreams[arg1]

        SDT:SetCVar(Stream.Enabled, GetCVarBool(Stream.Enabled) and 0 or 1)

	    slotFrame.text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, GetStreamString(activeStream)))
    end

	twipe(menu)
	twipe(toggleMenu)
    for Index, Stream in ipairs(AudioStreams) do
	    tinsert(menu, { text = Stream.Name, checked = function() return Index == activeIndex end, func = SelectStream, arg1 = Index })
	    tinsert(toggleMenu, { text = Stream.Name, checked = function() return GetCVarBool(Stream.Enabled) end, func = ToggleStream, arg1 = Index})
    end

    local function SelectSoundOutput(_, arg1)
        SDT:SetCVar('Sound_OutputDriverIndex', arg1)
	    Sound_GameSystem_RestartSoundSystem()
    end

	twipe(deviceMenu)
    for i = 0, Sound_GameSystem_GetNumOutputDrivers() - 1 do
	    tinsert(deviceMenu, { text = Sound_GameSystem_GetOutputDriverNameByIndex(i), checked = function() return i == tonumber(GetCVar('Sound_OutputDriverIndex')) end, func = SelectSoundOutput, arg1 = i })
    end

	----------------------------------------------------
    -- Update displayed text
    ----------------------------------------------------
	local function UpdateDisplay()
		slotFrame.text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, GetStreamString(activeStream)))
		SDT.FontManager:ApplyModuleFont(moduleName, slotFrame.text)
	end
	f.Update = UpdateDisplay

    ----------------------------------------------------
    -- Event Handler
    ----------------------------------------------------
    local function OnEvent(self, event, ...)
        activeStream = AudioStreams[activeIndex]
	    text = self.text

		self:EnableMouseWheel(true)
		self:SetScript('OnMouseWheel', OnMouseWheel)

		UpdateDisplay()
    end

    f:SetScript("OnEvent", OnEvent)
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("CVAR_UPDATE")

    ----------------------------------------------------
    -- Mouse Wheel Control
    ----------------------------------------------------
    slotFrame:EnableMouse(true)
    slotFrame:SetScript("OnMouseWheel", function(self, delta)
        local vol = GetCVar(activeStream.Volume)
	    local scale = 100

	    if IsShiftKeyDown() then
		    scale = 10
	    end

	    vol = vol + (delta / scale)

	    if vol >= 1 then
		    vol = 1
	    elseif vol <= 0 then
		    vol = 0
	    end

	    SDT:SetCVar(activeStream.Volume, vol)
	    slotFrame.text:SetText(SDT.FormatUtils:ColorModuleText(moduleName, GetStreamString(activeStream)))
    end)

    ----------------------------------------------------
    -- Tooltip
    ----------------------------------------------------
    slotFrame:SetScript("OnEnter", function(self)
        local anchor = SDT.FormatUtils:FindBestAnchorPoint(self)
        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()

		SDT.FormatUtils:AddTooltipHeader(GameTooltip, 14, L["Active Output Audio Device"], 1, 1, 1)
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, Sound_GameSystem_GetOutputDriverNameByIndex(GetCVar('Sound_OutputDriverIndex')), nil, 1, 0.82, 0)
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 14, L["Volume Streams"], nil, 1, 1, 1)

	    for _, Stream in ipairs(AudioStreams) do
			SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, Stream.Name, GetStreamString(Stream, true), 1, 0.82, 0)
	    end

		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, " ")

		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cFFffffff" .. L["Left Click: Select Volume Stream"] .. "|r")
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cFFffffff" .. L["Middle Click: Toggle Mute Master Stream"] .. "|r")
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cFFffffff" .. L["Shift + Middle Click: Toggle Volume Stream"] .. "|r")
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cFFffffff" .. L["Shift + Left Click: Open System Audio Panel"] .. "|r")
		SDT.FormatUtils:AddTooltipLine(GameTooltip, 12, "|cFFffffff" .. L["Shift + Right Click: Select Output Audio Device"] .. "|r")

	    GameTooltip:Show()
    end)

    slotFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    ----------------------------------------------------
    -- Handle Clicks
    ----------------------------------------------------
    slotFrame:SetScript("OnClick", function(self, button)
		local volumeMenu = CreateFrame('Frame', 'Volume_Menu', UIParent, 'UIDropDownMenuTemplate')
        if button == 'LeftButton' then
		    if IsShiftKeyDown() then
				_G.Settings.OpenToCategory(_G.Settings.AUDIO_CATEGORY_ID)
			    return
		    end

            CreateContextMenu(volumeMenu, function(_, root) SDT:HandleMenuList(root, menu, nil, 1) end)
	    elseif button == 'MiddleButton' then
            if IsShiftKeyDown() then
                CreateContextMenu(volumeMenu, function(_, root) SDT:HandleMenuList(root, toggleMenu, nil, 1) end)
            else
		        SDT:SetCVar(AudioStreams[1].Enabled, GetCVarBool(AudioStreams[1].Enabled) and 0 or 1)
            end
	    elseif button == 'RightButton' and IsShiftKeyDown() then
            CreateContextMenu(volumeMenu, function(_, root) SDT:HandleMenuList(root, deviceMenu, nil, 1) end)
	    end
    end)

	UpdateDisplay()

    return f
end

----------------------------------------------------
-- Register with SDT
----------------------------------------------------
SDT.ModuleRegistry:RegisterDatatext(moduleName, mod)

return mod
