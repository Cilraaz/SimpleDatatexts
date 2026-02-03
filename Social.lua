-- SDT_Social.lua
-- Social (Guild & Friends) datatext core for Simple Datatexts
-- Rewritten from Ara_Broker_Guild_Friends for SimpleDatatexts integration

local addonName, SDT = ...
local L = SDT.L

-- Create the social module namespace
if not SDT.Social then SDT.Social = {} end
local Social = SDT.Social

----------------------------------------------------
-- Lua/WoW API Locals
----------------------------------------------------
local floor, max, min, sort, wipe, next, pairs, ipairs, type, unpack, select, tonumber, tostring, format, log10 = 
	math.floor, math.max, math.min, table.sort, wipe, next, pairs, ipairs, type, unpack, select, tonumber, tostring, string.format, math.log10

local CreateFrame, UIParent, GameTooltip = CreateFrame, UIParent, GameTooltip
local GetRealmName, UnitFactionGroup, UnitName, GetNumGroupMembers, IsInRaid, UnitInRaid, UnitInParty =
	GetRealmName, UnitFactionGroup, UnitName, GetNumGroupMembers, IsInRaid, UnitInRaid, UnitInParty
local GetGuildRosterInfo, GetGuildRosterShowOffline, IsInGuild =
	GetGuildRosterInfo, GetGuildRosterShowOffline, IsInGuild
local GuildRoster = C_GuildInfo and C_GuildInfo.GuildRoster or GuildRoster
local ShowFriends = C_FriendList and C_FriendList.ShowFriends or ShowFriends
local ToggleGuildFrame, ToggleFriendsFrame = ToggleGuildFrame, ToggleFriendsFrame
local BNGetNumFriends = BNGetNumFriends
local GetQuestDifficultyColor = GetQuestDifficultyColor
local Ambiguate = Ambiguate
local LOCALIZED_CLASS_NAMES_MALE, LOCALIZED_CLASS_NAMES_FEMALE, CLASS_ICON_TCOORDS =
	LOCALIZED_CLASS_NAMES_MALE, LOCALIZED_CLASS_NAMES_FEMALE, CLASS_ICON_TCOORDS
local FRIENDS, GUILD = FRIENDS, GUILD

-- Compat for different WoW versions
local C_FriendList = C_FriendList
local C_BattleNet = C_BattleNet
local C_GuildInfo = C_GuildInfo
local GetFriendInfo = C_FriendList and C_FriendList.GetFriendInfoByIndex or GetFriendInfo
local CanEditPublicNote = CanEditPublicNote or (C_GuildInfo and C_GuildInfo.CanEditPublicNote)
local CanEditOfficerNote = CanEditOfficerNote or (C_GuildInfo and C_GuildInfo.CanEditOfficerNote)
local RemoveFriend = RemoveFriend or (C_FriendList and C_FriendList.RemoveFriend)
local InviteUnit = InviteUnit or (C_PartyInfo and C_PartyInfo.InviteUnit)

-- TOC version check
local wowTOC = select(4, GetBuildInfo())

----------------------------------------------------
-- Utility Functions
----------------------------------------------------

-- Deep copy a table
local function CopyTable(src, dest)
	if type(src) ~= "table" then return src end
	if type(dest) ~= "table" then dest = {} end
	for k, v in pairs(src) do
		if type(v) == "table" then
			dest[k] = CopyTable(v, dest[k])
		else
			dest[k] = v
		end
	end
	return dest
end

----------------------------------------------------
-- Constants
----------------------------------------------------
local BUTTON_HEIGHT = 20
local ICON_SIZE = 16
local GAP = 6
local TEXT_OFFSET = 3

----------------------------------------------------
-- Module Variables
----------------------------------------------------
local tooltip -- Main tooltip frame
local playerRealm, horde
local config, colors
local guildEntries, friendEntries = {}, {}
local buttons, toasts = {}, {}
local isGuild = false
local nbRealFriends, nbBroadcast = 0, 0
local realFriendsHeight = 0
local preformatedStatusText
local sortIndexes
local ClassL = {}

-- Color helpers
local function CreateColor(r, g, b, a)
	return {r, g, b, a}
end

----------------------------------------------------
-- Configuration Defaults
----------------------------------------------------
local defaultConfig = {
	scale = 1.0,
	showGuildName = true,
	showGuildTag = true,
	showGuildTotal = true,
	showFriendsTag = true,
	showFriendsTotal = true,
	showGuildXP = false,
	showGuildXPTooltip = true,
	showOwnBroadcast = true,
	enableBnetFriendsBroadcasts = true,
	showGuildNotes = true,
	showFriendNotes = true,
	showUngroupedClassIcon = false,
	highlightOrder = true,
	highlightMode = "simple",
	statusMode = "classColored",
	realID = "before",
	alignName = "LEFT",
	alignZone = "LEFT",
	alignNote = "LEFT",
	alignRank = "LEFT",
	useTipTacSkin = false,
	showBlockHints = true,
	hideHints = false,
	-- Block hints
	hbOpenPanel = true,
	hbConfig = true,
	hbToggleNotes = true,
	hbAddFriend = true,
	-- Interaction hints
	hWhisp = true,
	hInvite = true,
	hQuery = true,
	hNote = true,
	hONote = true,
	hOrderA = true,
	hOrderB = true,
	hOrderC = true,
	hResizeTip = true,
	hRemoveFriend = true,
	-- Sorting
	sortCols = {
		[true] = { "name", "rank", "level" },  -- Guild
		[false] = { "name", "level", "zone" }  -- Friends
	},
	sortASC = {
		[true] = { true, true, false },  -- Guild
		[false] = { true, false, true }  -- Friends
	},
	-- Colors
	colors = {
		background = { 0, 0, 0, 0.9 },
		border = { 0.6, 0.6, 0.6, 1 },
		orderA = { 0.2, 1, 0.2, 0.5 },
		title = { 0.9, 0.9, 0, 1 },
		motd = { 0, 1, 0, 1 },
		friendlyZone = { 0.1, 1, 0.1, 1 },
		contestedZone = { 1, 0.7, 0, 1 },
		enemyZone = { 1, 0.1, 0.1, 1 },
		note = { 0.14, 1, 0.14, 1 },
		officerNote = { 1, 0.6, 0.2, 1 },
		status = { 0.65, 0.65, 0.65, 1 },
		rank = { 0.28, 0.70, 0.28, 1 },
		broadcast = { 0.51, 0.77, 1, 1 },
		realm = { 0.51, 0.77, 1, 1 },
	}
}

-- Column sorting pairs
local colpairs = {
	name = "name",
	level = "level",
	zone = "zone",
	note = "note",
	rank = "rank"
}

----------------------------------------------------
-- Helper Functions
----------------------------------------------------

-- Short number display (1234 -> 1.2k)
local function ShortNumber(value)
	if type(value) ~= "number" or value < 1e3 then
		return tostring(value)
	end
	local l = floor(log10(value))
	return format("%%.%if%s", 2 - l % 3, l < 6 and "k" or "m"):format(value / 10^(floor(l / 3) * 3)):gsub('%.?0+([km])$', '%1')
end

-- Preformat status text based on config
local function PreFormatStatusText(color)
	if config.statusMode == "classColored" then
		preformatedStatusText = "%s "
	elseif config.statusMode == "customColored" then
		local r, g, b = unpack(color)
		preformatedStatusText = format("|cff%.2x%.2x%.2x%%s|r ", r * 255, g * 255, b * 255)
	elseif config.statusMode == "icon" then
		preformatedStatusText = ""
	end
end

-- Get BattleNet friend info (cross-version compatible)
local function GetBNFriendInfo(friendIndex)
	if wowTOC >= 90000 then
		local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex) or {}
		local gameInfo = accountInfo.gameAccountInfo or {}
		
		return accountInfo.bnetAccountID,
			accountInfo.accountName,
			accountInfo.battleTag,
			gameInfo.characterName or "",
			gameInfo.gameAccountID or 0,
			gameInfo.clientProgram or "",
			gameInfo.isOnline or false,
			accountInfo.lastOnlineTime or 0,
			accountInfo.isAFK or false,
			accountInfo.isDND or false,
			accountInfo.note or "",
			accountInfo.noteText or "",
			gameInfo.realmName or "",
			gameInfo.factionName or "",
			gameInfo.className or "",
			gameInfo.raceName or "",
			gameInfo.areaName or "",
			gameInfo.characterLevel or 0,
			gameInfo.richPresence or "",
			accountInfo.customMessage or "",
			gameInfo.wowProjectID or 0
	else
		-- Classic/older versions
		return BNGetFriendInfo(friendIndex)
	end
end

----------------------------------------------------
-- Configuration Management
----------------------------------------------------

function Social:GetConfig()
	if not config then
		-- Make sure SDT.db exists
		if not SDT or not SDT.db or not SDT.db.global then
			-- Return default config if DB isn't ready yet
			config = CopyTable(defaultConfig)
			colors = config.colors
			sortIndexes = {
				[true] = {
					colpairs[config.sortCols[true][1]],
					colpairs[config.sortCols[true][2]],
					colpairs[config.sortCols[true][3]]
				},
				[false] = {
					colpairs[config.sortCols[false][1]],
					colpairs[config.sortCols[false][2]],
					colpairs[config.sortCols[false][3]]
				}
			}
			PreFormatStatusText(colors.status)
			return config
		end
		
		-- Initialize from saved variables or defaults
		if not SDT.db.global.SDTSocial then
			SDT.db.global.SDTSocial = CopyTable(defaultConfig)
		end
		config = SDT.db.global.SDTSocial
		colors = config.colors
		
		-- Initialize sort indexes
		sortIndexes = {
			[true] = {
				colpairs[config.sortCols[true][1]],
				colpairs[config.sortCols[true][2]],
				colpairs[config.sortCols[true][3]]
			},
			[false] = {
				colpairs[config.sortCols[false][1]],
				colpairs[config.sortCols[false][2]],
				colpairs[config.sortCols[false][3]]
			}
		}
		
		PreFormatStatusText(colors.status)
	end
	return config
end

function Social:Initialize()
	-- Get configuration
	self:GetConfig()
	
	-- Initialize player info
	playerRealm = GetRealmName()
	horde = UnitFactionGroup("player") == "Horde"
	
	-- Build class localization table
	for eng, loc in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		ClassL[loc] = eng
	end
	for eng, loc in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
		ClassL[loc] = eng
	end
	
	-- Create tooltip frame
	if not tooltip then
		tooltip = CreateFrame("Frame", "SDT_SocialTooltip", UIParent, BackdropTemplateMixin and "BackdropTemplate")
		tooltip:SetFrameStrata("TOOLTIP")
		tooltip:SetClampedToScreen(true)
		tooltip:Hide()
		
		-- Make it interactive
		tooltip:EnableMouse(true)
		tooltip:SetScript("OnLeave", function(self)
			if not self:IsMouseOver() then
				self:Hide()
			end
		end)
	end
	
	return true
end

----------------------------------------------------
-- Data Collection
----------------------------------------------------

function Social:UpdateGuildData()
	if not IsInGuild() then
		wipe(guildEntries)
		return
	end
	
	GuildRoster()
	wipe(guildEntries)
	
	local numTotal, numOnline = GetNumGuildMembers()
	local showOffline = GetGuildRosterShowOffline()
	
	for i = 1, numTotal do
		local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, 
			achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
		
		if name and (isOnline or showOffline) then
			-- Parse name and realm
			local charName, realm = name:match("^([^-]+)-?(.*)$")
			if not realm or realm == "" then
				realm = playerRealm
			end
			
			local entry = {
				name = charName,
				realm = realm,
				fullName = name,
				rank = rankName,
				rankIndex = rankIndex,
				level = level,
				class = class,
				classDisplayName = classDisplayName,
				zone = zone or "",
				note = publicNote or "",
				officerNote = officerNote or "",
				isOnline = isOnline,
				status = status,
				isMobile = isMobile,
				index = i
			}
			
			table.insert(guildEntries, entry)
		end
	end
end

function Social:UpdateFriendsData()
	ShowFriends()
	wipe(friendEntries)
	
	local numFriends = C_FriendList and C_FriendList.GetNumFriends() or GetNumFriends()
	
	for i = 1, numFriends do
		local info
		if C_FriendList and C_FriendList.GetFriendInfoByIndex then
			info = C_FriendList.GetFriendInfoByIndex(i)
		else
			local name, level, class, area, connected, status, note = GetFriendInfo(i)
			info = {
				name = name,
				level = level,
				className = class,
				area = area,
				connected = connected,
				status = status,
				notes = note
			}
		end
		
		if info and info.connected then
			local entry = {
				name = info.name,
				level = info.level,
				class = info.className,
				zone = info.area or "",
				note = info.notes or "",
				status = info.status,
				index = i,
				isBNet = false
			}
			
			table.insert(friendEntries, entry)
		end
	end
end

----------------------------------------------------
-- Sorting
----------------------------------------------------

local function SortComparator(a, b)
	local s = sortIndexes[isGuild]
	local si, lv = s[1], 1
	
	if a[si] == b[si] then
		si, lv = s[2], 2
		if a[si] == b[si] then
			si, lv = s[3], 3
		end
	end
	
	if config.sortASC[isGuild][lv] then
		return a[si] < b[si]
	else
		return a[si] > b[si]
	end
end

----------------------------------------------------
-- LDB Objects Creation
----------------------------------------------------

function Social:CreateGuildLDBObject()
	local LDB = LibStub("LibDataBroker-1.1")
	
	local obj = LDB:NewDataObject("SDT Guild", {
		type = "data source",
		text = GUILD,
		icon = [[Interface\AddOns\SimpleDatatexts\textures\guild]],
		
		OnEnter = function(self)
			isGuild = true
			Social:UpdateGuildData()
			Social:ShowTooltip(self)
		end,
		
		OnLeave = function(self)
			if tooltip then
				tooltip:Hide()
			end
		end,
		
		OnClick = function(self, button)
			if button == "LeftButton" then
				ToggleGuildFrame()
			elseif button == "RightButton" then
				-- Could open config menu here
			end
		end,
	})
	
	-- Update text display
	self:UpdateGuildText(obj)
	
	return obj
end

function Social:CreateFriendsLDBObject()
	local LDB = LibStub("LibDataBroker-1.1")
	
	local obj = LDB:NewDataObject("SDT Friends", {
		type = "data source",
		text = FRIENDS,
		icon = [[Interface\AddOns\SimpleDatatexts\textures\friends]],
		
		OnEnter = function(self)
			isGuild = false
			Social:UpdateFriendsData()
			Social:ShowTooltip(self)
		end,
		
		OnLeave = function(self)
			if tooltip then
				tooltip:Hide()
			end
		end,
		
		OnClick = function(self, button)
			if button == "LeftButton" then
				ToggleFriendsFrame(1)
			elseif button == "MiddleButton" then
				if FriendsFrameAddFriendButton then
					FriendsFrameAddFriendButton:Click()
				end
			end
		end,
	})
	
	-- Update text display
	self:UpdateFriendsText(obj)
	
	return obj
end

----------------------------------------------------
-- Text Updates
----------------------------------------------------

function Social:UpdateGuildText(obj)
	if not obj then return end
	
	if not IsInGuild() then
		obj.text = L["No Guild"] or "No Guild"
		return
	end
	
	local numTotal, numOnline = GetNumGuildMembers()
	local guildName = GetGuildInfo("player")
	
	local parts = {}
	
	if config.showGuildName and guildName then
		table.insert(parts, guildName)
	end
	
	if config.showGuildTag and not (config.showGuildName and guildName) then
		table.insert(parts, GUILD)
	end
	
	if config.showGuildTotal then
		table.insert(parts, format("%d/%d", numOnline or 0, numTotal or 0))
	end
	
	obj.text = table.concat(parts, " ")
end

function Social:UpdateFriendsText(obj)
	if not obj then return end
	
	local numFriends = C_FriendList and C_FriendList.GetNumFriends() or GetNumFriends()
	local numOnline = C_FriendList and C_FriendList.GetNumOnlineFriends() or 0
	
	-- Count online friends manually if needed
	if numOnline == 0 then
		for i = 1, numFriends do
			local info
			if C_FriendList and C_FriendList.GetFriendInfoByIndex then
				info = C_FriendList.GetFriendInfoByIndex(i)
				if info and info.connected then
					numOnline = numOnline + 1
				end
			else
				local _, _, _, _, connected = GetFriendInfo(i)
				if connected then
					numOnline = numOnline + 1
				end
			end
		end
	end
	
	local parts = {}
	
	if config.showFriendsTag then
		table.insert(parts, FRIENDS)
	end
	
	if config.showFriendsTotal then
		table.insert(parts, format("%d", numOnline))
	end
	
	obj.text = table.concat(parts, " ")
end

----------------------------------------------------
-- Tooltip Display
----------------------------------------------------

function Social:ShowTooltip(anchor)
	if not tooltip then return end
	
	-- This would create the full interactive tooltip
	-- For now, use GameTooltip as fallback
	GameTooltip:SetOwner(anchor, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
	GameTooltip:ClearLines()
	
	if isGuild then
		self:PopulateGuildTooltip(GameTooltip)
	else
		self:PopulateFriendsTooltip(GameTooltip)
	end
	
	GameTooltip:Show()
end

function Social:PopulateGuildTooltip(tt)
	if not IsInGuild() then
		tt:AddLine(L["No Guild"] or "No Guild")
		return
	end
	
	local guildName = GetGuildInfo("player")
	if guildName then
		tt:AddLine(guildName, 1, 0.82, 0)
	end
	
	-- Sort entries
	sort(guildEntries, SortComparator)
	
	-- Add entries
	for _, entry in ipairs(guildEntries) do
		if entry.isOnline then
			local classColor = RAID_CLASS_COLORS[entry.class] or CreateColor(1, 1, 1, 1)
			local levelColor = GetQuestDifficultyColor(entry.level)
			
			local line = format("|c%s%s|r |cff%.2x%.2x%.2x%d|r %s",
				classColor.colorStr or "ffffffff",
				entry.name,
				levelColor.r * 255, levelColor.g * 255, levelColor.b * 255,
				entry.level,
				entry.zone
			)
			
			tt:AddLine(line)
		end
	end
end

function Social:PopulateFriendsTooltip(tt)
	tt:AddLine(FRIENDS, 1, 0.82, 0)
	
	-- Sort entries
	sort(friendEntries, SortComparator)
	
	-- Add entries
	for _, entry in ipairs(friendEntries) do
		local classColor = RAID_CLASS_COLORS[entry.class] or CreateColor(1, 1, 1, 1)
		local levelColor = GetQuestDifficultyColor(entry.level)
		
		local line = format("|c%s%s|r |cff%.2x%.2x%.2x%d|r %s",
			classColor.colorStr or "ffffffff",
			entry.name,
			levelColor.r * 255, levelColor.g * 255, levelColor.b * 255,
			entry.level,
			entry.zone
		)
		
		tt:AddLine(line)
	end
	
	if #friendEntries == 0 then
		tt:AddLine(L["No friends online."] or "No friends online.", 0.5, 0.5, 0.5)
	end
end

----------------------------------------------------
-- Event Handlers
----------------------------------------------------

function Social:RegisterEvents()
	local frame = CreateFrame("Frame")
	
	frame:RegisterEvent("GUILD_ROSTER_UPDATE")
	frame:RegisterEvent("FRIENDLIST_UPDATE")
	frame:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	frame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	frame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	
	frame:SetScript("OnEvent", function(self, event, ...)
		if event == "GUILD_ROSTER_UPDATE" then
			Social:UpdateGuildData()
			-- Update guild LDB object if it exists
			local obj = LibStub("LibDataBroker-1.1"):GetDataObjectByName("|cFFFFB366Ara|r Guild")
			if obj then
				Social:UpdateGuildText(obj)
			end
		elseif event:find("FRIEND") or event:find("BN_") then
			Social:UpdateFriendsData()
			-- Update friends LDB object if it exists
			local obj = LibStub("LibDataBroker-1.1"):GetDataObjectByName("|cFFFFB366Ara|r Friends")
			if obj then
				Social:UpdateFriendsText(obj)
			end
		end
	end)
end

----------------------------------------------------
-- Module Export
----------------------------------------------------

-- Defer initialization until SDT is ready
local function OnSDTReady()
	-- Initialize when SDT database is available
	if SDT and SDT.db then
		Social:Initialize()
		Social:RegisterEvents()
		
		-- Create LDB objects
		Social:CreateGuildLDBObject()
		Social:CreateFriendsLDBObject()
		
		return true
	end
	return false
end

-- Try to initialize immediately if SDT is ready
if not OnSDTReady() then
	-- Otherwise wait for PLAYER_LOGIN
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:SetScript("OnEvent", function(self, event)
		OnSDTReady()
		self:UnregisterAllEvents()
	end)
end

return Social