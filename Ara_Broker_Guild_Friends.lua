-- TODO  translate zones.
-- TODO? don't recreate guild/friend entries, replace values in the table if char is present, remove disconnected, add connected.
-- TODO  make real friend with broadcast a double sized button unless the broadcast has a link (in this case, click broadcast to copy link).
-- TODO? defaultConfig as config metatable / remove old values only (don't add new ones).
-- TODO  split column "notes" to "notes" and "officier notes" (change sort columns accordingly and add a button.offNotes).
local _, _, _, wowTOC = GetBuildInfo()
local SDT = SimpleDatatexts

local BUTTON_HEIGHT, ICON_SIZE, GAP, TEXT_OFFSET, INFO_HEIGHT, FONT_SIZE, MAX_ENTRIES = 15, 13, 10, 5, 25, 12

local f = CreateFrame( "Frame", "AraBrokerGuildFriends", UIParent)
Mixin(f, BackdropTemplateMixin)
f:Hide()
local t = CreateFrame"Frame"
local addonName, _ = ...
local L = SDT.L
local ClassL = {}

local defaultConfig = {
	highlightOrder = true,
	highlightMode = "gradientAZ",
	showGuildTotal = true,
	showFriendsTotal = true,
	showGuildNotes = true,
	showFriendNotes = true,
	showGuildName = false,
	showGuildTag = false,
	showFriendsTag = false,
	showGuildXP = true,
	showGuildXPTooltip = false,
	showOwnBroadcast = true,
	sortCols = { [true] = { "class", "name", "name" }, [false] = { "name", "name", "name" } },
	sortASC = { [true] = { true, true, true }, [false] = { true, true, true } },
	scale = 1,
	statusMode = "icon",
	realID = "before",
	showUngroupedClassIcon = true,
	alignName = "LEFT",
	alignZone = "CENTER",
	alignNote = "CENTER",
	alignRank = "RIGHT",
	colors = {
		background = { .1, .1, .1, .85 },
		border = { .3, .3, .3, .9 },
		note = { .14, .76, .15 },
		officerNote = { 1, .56, .25 },
		motd = { 1, .8, 0 },
		broadcast = { 1, .1, .1 },
		title = { 1, 1, 1 },
		rank = { .1, .9, 1 },
		realm = { 1, .8, 0 },
		status = { .7, .7, .7 },
		orderA = { 1, 1, 1, .1 },
		contestedZone = { 1, 1, 0 },
		friendlyZone = { 0, 1, 0 },
		enemyZone = { 1, 0, 0 },
	},
	useTipTacSkin = true,
	hideHints = true,
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
	showBlockHints = true,
	hbOpenPanel = true,
	hbConfig = true,
	hbToggleNotes = true,
	hbAddFriend = true,
	enableBnetFriendsBroadcasts = true,
}
local dontShow, block, horde, config, isGuild, tip = true
local guildEntries, friendEntries, motd, slider, nbEntries = {}, {}
local sliderValue, hasSlider, UpdateTablet, extraHeight = 0
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local info, buttons, toasts, playerRealm = {}
local totalFriends, onlineFriends, nbRealFriends, realFriendsHeight, nbBroadcast = 0, 0, 0
local clientsTable = {
	["BSAp"] = 0,--Battle.net Mobile
	["WoW"] = 1,--World of Warcraft
	["S2"] = 2,--Starcraft 2
	["D3"] = 3,--Diablo 3
	["WTCG"] = 4,--Hearthstone
	["App"] = 5,--Battle.net Client
	["Hero"] = 6,--Heroes of the Storm
	["Pro"] = 7,--Overwatch
	["CLNT"] = 8,--Battle.net Client alternate (Unused?)
	["S1"] = 9,--Starcraft 1
	["DST2"] = 10,--Destiny 2
	["VIPR"] = 11,--COD
	["ODIN"] = 12,--COD MW
	["LAZR"] = 13,--COD MW2
	["ZEUS"] = 14,--COD BOCW
	["W3"] = 15,--Warcraft 3 Reforged
	["RTRO"] = 16,--Blizzard Arcane
	["WLBY"] = 17,--Crash 4
	["OSI"] = 18,--Diablo 2
	["Fen"] = 19--Diablo 4
}
local configMenu, options, c, cname, SetOption, UpdateColor, ColorPickerChange, ColorPickerCancel, OpenColorPicker, ColorPickerOpacity, colors
local preformatedStatusText, sortIndexes

local backdrop =  {
	bgFile = "Interface\\Buttons\\WHITE8X8",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize=16, tile = false, tileSize=0,
	insets = { left=3, right=3, top=3, bottom=3 } }

local wipe, next, GetGuildRosterInfo, GetGuildRosterShowOffline, GetFriendInfo, IsInGuild, GuildRoster, ShowFriends, CLASS_BUTTONS, GetDifficultyColor, Ambiguate =
	wipe, next, GetGuildRosterInfo, GetGuildRosterShowOffline, C_FriendList and C_FriendList.GetFriendInfoByIndex or GetFriendInfo, IsInGuild, GuildRoster, ShowFriends, CLASS_ICON_TCOORDS, GetQuestDifficultyColor, Ambiguate
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

--Not renamed in legion yet but might be
local BNGetNumFriends = BNGetNumFriends

--Begin Compat wrappers for retail and classic to access same functions and expect same returns
--Retail kind of has these for now, but won't forever, and classic is not expected to make same API restructuring, so this ugly mess is probably required forever
local function GetBNGetFriendInfo(friendIndex)
		if wowTOC >= 90000 then
			local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex) or {};
			local wowProjectID = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.wowProjectID or 0;
			local clientProgram = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.clientProgram ~= "" and accountInfo.gameAccountInfo.clientProgram or nil;
			local characterName = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.characterName or "";
			local gameAccountID = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.gameAccountID or 0;
			local isOnline = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.isOnline or false;
			local isWowMobile = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.isWowMobile or false;

			return	accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, accountInfo.isBattleTagFriend,
					characterName, gameAccountID, clientProgram,
					isOnline, accountInfo.lastOnlineTime, accountInfo.isAFK, accountInfo.isDND, accountInfo.customMessage, accountInfo.note, accountInfo.isFriend,
					accountInfo.customMessageTime, wowProjectID, accountInfo.rafLinkType == Enum.RafLinkType.Recruit, false, accountInfo.isFavorite, isWowMobile;
	else
		return BNGetFriendInfo(friendIndex)
	end
end

local function GetBNGetGameAccountInfo(toonId)
	if wowTOC >= 90000 then
		local gameAccountInfo = _G.C_BattleNet.GetGameAccountInfoByID(toonId) or {}
		local wowProjectID = gameAccountInfo.wowProjectID or 0;
		local characterName = gameAccountInfo.characterName or "";
		local realmName = gameAccountInfo.realmName or "";
		local realmID = gameAccountInfo.realmID or 0;
		local factionName = gameAccountInfo.factionName or "";
		local raceName = gameAccountInfo.raceName or "";
		local className = gameAccountInfo.className or "";
		local areaName = gameAccountInfo.areaName or "";
		local characterLevel = gameAccountInfo.characterLevel or "";
		local richPresence = gameAccountInfo.richPresence or "";
		local gameAccountID = gameAccountInfo.gameAccountID or 0;
		local playerGuid = gameAccountInfo.playerGuid or 0;
		local isOnline = gameAccountInfo.isOnline or false;
		local isGameAFK = gameAccountInfo.isGameAFK or false;
		local isGameBusy = gameAccountInfo.isGameBusy or false;
		local isWowMobile = gameAccountInfo.isWowMobile or false;
		return	gameAccountInfo.hasFocus, characterName, gameAccountInfo.clientProgram,
			realmName, realmID, factionName, raceName, className, "", areaName, characterLevel,
				richPresence, nil, nil,
				isOnline, gameAccountID, nil, isGameAFK, isGameBusy,
				playerGuid, wowProjectID, isWowMobile
	else
		return BNGetGameAccountInfo(toonId)
	end
end
--End Compat wrappers for retail and classic to access same functions and expect same returns

local colpairs = { ["class"] = 1, ["name"] = 2, ["level"] = 3, ["zone"] = 4, ["note"] = 5, ["status"] = 6, ["rank"] = 7 }


local new, del

do
	local tables = setmetatable( {}, { __mode = "k" } )

	new = function(...)
		local t = next(tables)
		if t then tables[t] = nil else t = {} end
		for i=1, select("#",...) do t[i] = select(i,...) end
		return t
	end

	del = function(t)
		tables[wipe(t)] = true
	end

end


local function UpdateGuildBlockText()
	if IsInGuild() then
		local guildName = config.showGuildName and GetGuildInfo("player") or ""
		if guildName == "" and config.showGuildTag then guildName = L["Guild"] end
		if guildName ~= "" then guildName = guildName .. ": " end
		f.GuildBlock.text = (config.showGuildTotal and "%s%d/%d" or "%s%d"):format(guildName, #guildEntries, (GetNumGuildMembers()))
	else
		f.GuildBlock.text = L["No Guild"]
	end
	SDT:UpdateGuild()
end

local function UpdateFriendBlockText(updatePanel)
	local totalRF, onlineRF = BNGetNumFriends()
	local friendsTag = config.showFriendsTag and L["Friends: "] or ""
	f.FriendsBlock.text = (config.showFriendsTotal and "%s%d/%d" or "%s%d"):format( friendsTag, onlineFriends + onlineRF, totalFriends + totalRF )
	SDT:UpdateFriends()
	if updatePanel then f:BN_FRIEND_INFO_CHANGED() end
end


local friendOnline, friendOffline = ERR_FRIEND_ONLINE_SS:gsub("|Hplayer:%%s|h%[%%s%]|h",""), ERR_FRIEND_OFFLINE_S:gsub("%%s","")
function f:CHAT_MSG_SYSTEM( msg )
	if msg:find(friendOnline) or msg:find(friendOffline) then ShowFriends() end
end

function f:FRIENDLIST_UPDATE()
	--None bnet friends
	for k,v in next,friendEntries do del(v) friendEntries[k]=nil end
	onlineFriends = C_FriendList.GetNumOnlineFriends()
	for i = 1, onlineFriends do	
		local name, level, class, zone, connected, status, note
		local info = GetFriendInfo(i)
		name, level, class, zone, connected, note = info.name, info.level, info.className, info.area, info.isOnline, info.notes
		if (info.afk) then
			status = CHAT_FLAG_AFK
		elseif (info.dnd) then
			status = CHAT_FLAG_DND
		else
			status = ""
		end
		friendEntries[i] = new( ClassL[class] or "", name or "", level or "", zone or UNKNOWN, note or "|cffffcc00-", status or "", "", "", i )
	end
	UpdateFriendBlockText()
	if not isGuild and f:IsShown() then UpdateTablet() end
end


function f:GUILD_ROSTER_UPDATE()
	for k, v in next, guildEntries do del(v) guildEntries[k]=nil end
	local r,g,b = unpack(colors.officerNote)
	local officerColor = ("\124cff%.2x%.2x%.2x"):format( r*255, g*255, b*255 )
	local totalMembers, onlineMembers = GetNumGuildMembers()
	local scanTotal = GetGuildRosterShowOffline() and totalMembers or onlineMembers--Attempt CPU saving, if "show offline" is unchecked, we can reliably scan only online members instead of whole roster
	for i=1, scanTotal do
		local name, rank, rankIndex, level, class, zone, note, offnote, connected, status, engClass, achPoints, achRank, isMobile = GetGuildRosterInfo(i)
		if not name then break end
		if connected or isMobile then
		name = Ambiguate(name, "none")
		local notes = note ~= "" and (offnote == "" and note or ("%s |cffffcc00-|r %s%s"):format(note, officerColor, offnote)) or
			offnote == "" and "|cffffcc00-" or officerColor..offnote
			if status == 0 then status = ""
			elseif status == 1 then status = CHAT_FLAG_AFK
			elseif status == 2 then status = CHAT_FLAG_DND
			end
		if(isMobile and not connected) then zone = REMOTE_CHAT; end;--They are mobile only.
		guildEntries[#guildEntries+1] = new( ClassL[class] or "", name or "", level or "", zone or UNKNOWN, notes, isMobile and L["<Mobile>"] or status or "", rankIndex or 0, rank or 0, i, isMobile )
	end end
	UpdateGuildBlockText()
	if isGuild and f:IsShown() then UpdateTablet() end
end

function f:PLAYER_GUILD_UPDATE(unit)
	if unit and unit ~= "player" then return end
	if IsInGuild() then GuildRoster() end
end

local hordeZones = "Orgrimmar,Undercity,Thunder Bluff,Silvermoon City,Durotar,Tirisfal Glades,Mulgore,Eversong Woods,Northern Barrens,Silverpine Forest,Ghostlands,Lost Isles,Kezan,Azshara,Shrine of Two Moons,Frostfire Ridge,Warspear,Zuldazar,Vol'dun,Zuldazar,Nazmir,"
local allianceZones = "Ironforge,Stormwind City,Darnassus,The Exodar,Redridge Mountains,Azuremyst Isle,Bloodmyst Isle,Darkshore,Deeprun Tram,Dun Morogh,Elwynn Forest,Loch Modan,Teldrassil,Westfall,Gilneas City,Gilneas,Shrine of Seven Stars,Shadowmoon Valley,Stormshield,Boralus Harbor,Drustvar,Stormsong Valley,Tiragarde Sound,"
local sanctuaryZones = "Shattrath,Dalaran,Oribos,Valdrakken,"

local function GetZoneColor(zone)
	return unpack( colors[
		sanctuaryZones:find(zone..",") and "friendlyZone" or
		hordeZones:find(zone..",") and (horde and "friendlyZone" or "enemyZone") or
		allianceZones:find(zone..",") and (horde and "enemyZone" or "friendlyZone") or
		"contestedZone"
	] )
end

local function UpdateBlockHints()
	if f.onBlock then
		if config.showBlockHints then
			tip:SetOwner(f, "ANCHOR_NONE")
			tip:SetPoint( f.isTop and "TOP" or "BOTTOM", f, f.isTop and "BOTTOM" or "TOP" )
			tip:AddLine(L["Hints [|cffffffffBlock|r]"])
			if config.hbOpenPanel then tip:AddLine(L["|cffff8020Click|r to open panel."], 0.2, 1, 0.2) end
			if config.hbConfig then tip:AddLine(L["|cffff8020RightClick|r to display config menu."], 0.2, 1, 0.2) end
			if not isGuild then
				if config.hbAddFriend then
					tip:AddLine(L["|cffff8020MiddleClick|r to add a friend."], 0.2, 1, 0.2)
					tip:AddLine(L["|cffff8020Modifier+Click|r to add a friend."], 0.2, 1, 0.2)
				end
			end
			if config.hbToggleNotes then tip:AddLine(L["|cffff8020Button4|r to toggle notes."], 0.2, 1, 0.2) end
			if tip:NumLines() > 1 then tip:Show() else tip:Hide() end
		else
			tip:Hide()
		end
	end
end

local CanEditOfficerNote = CanEditOfficerNote or C_GuildInfo.CanEditOfficerNote
local function ShowHints(btn,config)
	if not config.hideHints and btn and btn.unit then
		local showBelow = UIParent:GetHeight()/config.scale-f:GetTop() < f:GetBottom()
		tip:SetOwner(f, "ANCHOR_NONE")
		tip:SetPoint(showBelow and "TOP" or "BOTTOM", f, showBelow and "BOTTOM" or "TOP")
		tip:AddLine(L["Hints"])
		if config.hWhisp then tip:AddLine(L["|cffff8020Click|r to whisper."], .2,1,.2) end
		if config.hInvite and (not btn.presenceID or btn.sameRealm) then tip:AddLine(L["|cffff8020Alt+Click|r to invite."], .2,1,.2) end
		if config.hQuery and not btn.presenceID then tip:AddLine(L["|cffff8020Shift+Click|r to query informations."], .2, 1, .2) end
		if config.hNote and (not isGuild or CanEditPublicNote()) then tip:AddLine(L["|cffff8020Ctrl+Click|r to edit note."], .2, 1, .2) end
		if isGuild then
			if config.hONote and CanEditOfficerNote() then tip:AddLine(L["|cffff8020Ctrl+RightClick|r to edit officer note."], .2, 1, .2) end
		else
			if config.hRemoveFriend then tip:AddLine(L["|cffff8020MiddleClick|r to remove friend."], .2, 1, .2) end
		end
		if not btn.presenceID then
			if config.hOrderA then tip:AddLine(L["|cffff8020RightClick|r to sort main column."], .2, 1, .2) end
			if config.hOrderB then tip:AddLine(L["|cffff8020Shift+RightClick|r to sort second column."], .2, 1, .2) end
			if config.hOrderC then tip:AddLine(L["|cffff8020Alt+RightClick|r to sort third column."], .2, 1, .2) end
		end
		if config.hResizeTip then tip:AddLine(L["|cffff8020Ctrl+MouseWheel|r to resize tooltip."], .2, 1, .2) end
		if tip:NumLines() > 1 then tip:Show() end
	end
end

local highlight = f:CreateTexture()
highlight:SetTexture"Interface\\QuestFrame\\UI-QuestTitleHighlight"
highlight:SetBlendMode"ADD"
highlight:SetAlpha(0)

local function Menu_OnEnter(b)
	if b and b.index then
		if b.index > 0 then
			highlight:SetAllPoints(b)
			highlight:SetAlpha(1)
			ShowHints(b,config)
	--	elseif not isGuild and config.showOwnBroadcast or CanEditMOTD() then
	--		highlight:ClearAllPoints()
	--		highlight:SetPoint("TOPLEFT", b, GAP, 2)
	--		highlight:SetSize(b:GetWidth()-GAP, b:GetHeight()-BUTTON_HEIGHT+4)
	--		highlight:SetAlpha(1)
		end
	end
end

local function Menu_OnLeave(b)
	highlight:ClearAllPoints()
	tip:Hide()
	if b then highlight:SetAlpha(0) end
	if not f:IsMouseOver() then f:Hide() end
end

local function MOTD_OnClose(edit)
	edit:ClearAllPoints()
	edit:SetParent(edit.prevParent)
	edit:SetPoint(unpack(edit.prevPoint))
end

local function LoadBlizzardAddons()
	if IsAddOnLoaded"Blizzard_GuildUI" then return end
	LoadAddOn"Blizzard_Calendar"
	LoadAddOn"Blizzard_GuildUI"
end

local function EditMOTD()
	f:Hide()
	LoadBlizzardAddons()
	local edit = GuildTextEditFrame
	edit.prevPoint = { edit:GetPoint() }
	edit.prevParent = edit:GetParent()
	edit:ClearAllPoints()
	edit:SetParent(UIParent)
	edit:SetPoint("CENTER", 0, 180)
	GuildTextEditFrame_Show"motd"
	edit:HookScript("OnHide", MOTD_OnClose)
end

local function EditBroadcast()
	f:Hide()
	StaticPopup_Show"SET_BN_BROADCAST"
end

local InviteUnit = InviteUnit or C_PartyInfo.InviteUnit
local function OnGuildmateClick( self, button )
	if not( self and self.unit ) then return end
	if (isGuild or not self.presenceID) and button == "RightButton" and not IsControlKeyDown() then
		local level = IsShiftKeyDown() and 2 or IsAltKeyDown() and 3 or 1
		local btn, ofx = buttons[1], GAP*.25
		local pos = GetCursorPosition() / self:GetEffectiveScale()
		for v, i in next, colpairs do
			local b = btn[v]
			if b:IsShown() and pos >= b:GetLeft() - ofx and pos <= b:GetRight() + ofx then
				local sortCols, sortASC = config.sortCols[isGuild], config.sortASC[isGuild]
				if sortCols[level] == v then
					sortASC[level] = not sortASC[level]
				else
					sortCols[level] = v
					sortASC[level] = v ~= "level"
				end
				sortIndexes[isGuild][level] = i
				return f:IsShown() and UpdateTablet()
			end
		end
	elseif button == "MiddleButton" and not isGuild then
		if self.presenceID then
			StaticPopup_Show("CONFIRM_REMOVE_FRIEND", self.realID, nil, self.presenceID)
		else
			RemoveFriend( self.unit )
		end
	elseif IsAltKeyDown() then
		if self.presenceID and self.unitrealm ~= "" then
			local name = self.unit.."-"..self.unitrealm
			InviteUnit(name)
		else
			InviteUnit( self.unit )
		end
	elseif IsControlKeyDown() then
		if not isGuild then
			FriendsFrame.NotesID = self.presenceID or self.realIndex
			if self.presenceID then
				StaticPopup_Show( "SET_BNFRIENDNOTE", self.realID )
			else
				StaticPopup_Show( "SET_FRIENDNOTE", self.unit )
			end
		elseif button == "LeftButton" and CanEditPublicNote() or button ~= "LeftButton" and CanEditOfficerNote() then
			SetGuildRosterSelection( self.realIndex )
			StaticPopup_Show( button == "LeftButton" and "SET_GUILDPLAYERNOTE" or "SET_GUILDOFFICERNOTE" )
		end
	else
		if self.presenceID then
			local name = self.realID..":"..self.presenceID
			SetItemRef( "BNplayer:"..name, ("|HBNplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )           
		else
			SetItemRef( "player:"..self.unit, ("|Hplayer:%1$s|h[%1$s]|h"):format(self.unit), "LeftButton" )
		end
	end
end

local function Scroll(self, delta)
	if IsControlKeyDown() then
		config.scale = config.scale - delta * 0.05
		UpdateTablet()
--	elseif IsShiftKeyDown() then
--		GAP = GAP - delta
--		UpdateTablet()
	else
		slider:SetValue( sliderValue - delta * (IsModifierKeyDown() and 10 or 3) )
	end
end


local function CreateFS( parent, justify, anchor, offsetX, color )
	local fs = parent:CreateFontString( nil, "OVERLAY", "SystemFont_Shadow_Med1" )
	if justify then fs:SetJustifyH( justify ) end
	if anchor then fs:SetPoint( "LEFT", anchor, "RIGHT", offsetX or GAP, 0 ) end
	if color then fs:SetTextColor(unpack(color)) end
	return fs
end

local function CreateTex( parent, anchor, offsetX )
	local tex = parent:CreateTexture()
	tex:SetSize( ICON_SIZE, ICON_SIZE )
	tex:SetPoint( "LEFT", anchor or parent, anchor and "RIGHT" or "LEFT", offsetX or 0, 0 )
	return tex
end


local sep = f:CreateTexture()

--local function FriendBroadcast_OnClick()
	-- TODO: detect URL and copy to input box
--end

local broadcasts = setmetatable( {}, { __index = function( table, index )
	local bc = CreateFrame( "Button", nil, f )
	table[index] = bc
	bc:SetHeight(BUTTON_HEIGHT)
	bc:SetNormalFontObject(GameFontNormal)
--	bc:RegisterForClicks"LeftButtonUp"
--	bc:SetScript("OnClick", FriendBroadcast_OnClick)
	bc.icon = CreateTex( bc, nil, ICON_SIZE + TEXT_OFFSET )
	bc.icon:SetTexture"Interface\\FriendsFrame\\BroadcastIcon"
	bc.icon:SetTexCoord(.1,.9,.1,.9)
	bc.text = CreateFS( bc, "LEFT", bc.icon, TEXT_OFFSET, colors.broadcast )
	bc.text:SetHeight(BUTTON_HEIGHT)
	return bc
end } )

toasts = setmetatable( {}, { __index = function( table, key )
	local button = CreateFrame( "Button", nil, f )
	table[key] = button
	button.index = key
	button:SetNormalFontObject(GameFontNormal)
	button:RegisterForClicks"AnyUp"
	button:SetScript( "OnEnter", Menu_OnEnter )
	button:SetScript( "OnLeave", Menu_OnLeave )
	button:SetScript( "OnClick", OnGuildmateClick )

	button:SetHeight( BUTTON_HEIGHT )

	button.class = CreateTex( button )
	button.status = CreateTex( button, button.class, TEXT_OFFSET )
	button.status:SetTexCoord(.1, .9, .1, .9)
	button.name  = CreateFS( button, config.alignName, button.status, TEXT_OFFSET )
	button.level = CreateFS( button, "CENTER", button.name, GAP )
	button.faction = CreateTex( button, button.level, GAP )
	button.zone  = CreateFS( button, config.alignZone, button.faction, TEXT_OFFSET )
	button.note = CreateFS( button, config.alignNote, button.zone, GAP, colors.note )
	return button
end } )

buttons = setmetatable( { }, { __index = function( table, key )
	local button = CreateFrame( "Button", nil, f )
	table[key] = button
	button.index = key
	button:SetNormalFontObject(GameFontNormal)
	button:RegisterForClicks"AnyUp"
	button:SetScript( "OnEnter", Menu_OnEnter )
	button:SetScript( "OnLeave", Menu_OnLeave )

	if key == 0 then
		motd = button
		motd.name = CreateFS( motd, "LEFT" )
		motd:Show()
		motd.name:SetJustifyV"TOP"
		motd.name:SetPoint( "TOPLEFT", motd, "TOPLEFT" )

		sep = motd:CreateTexture()
		sep:SetTexture"Interface\\FriendsFrame\\UI-FriendsFrame-OnlineDivider"
		sep:SetPoint("TOPLEFT", motd, "BOTTOMLEFT", 0, BUTTON_HEIGHT)
		sep:SetPoint("BOTTOMRIGHT", motd, "BOTTOMRIGHT", 0, 0)
	else
		button:SetHeight( BUTTON_HEIGHT )
		button.class = button:CreateTexture()
		button.class:SetSize( ICON_SIZE, ICON_SIZE )
		button.class:SetPoint( "LEFT", button, "LEFT" )

		button.status = CreateTex( button, button.class, TEXT_OFFSET )
		button.status:SetTexCoord(.1, .9, .1, .9)

		button.name = CreateFS( button, config.alignName )
		button.name:SetPoint( "LEFT", button.class, "RIGHT", TEXT_OFFSET, 0 )
		button.level = CreateFS( button, "CENTER", button.name )
		button.zone  = CreateFS( button, config.alignZone, button.level )
		button.note = CreateFS( button, config.alignNote, button.zone, GAP, colors.note )
		button.rank  = CreateFS( button, config.alignRank,  button.note, GAP, colors.rank )
	end
	return button
end } )


local function SetClassOrCheckIcon( tex, inGroup, name, class )
	local isGrouped = inGroup and inGroup(name)
	if inGroup and (isGrouped or not config.showUngroupedClassIcon) then
		tex:SetTexture( isGrouped and "Interface\\Buttons\\UI-CheckBox-Check" or "" )
		tex:SetTexCoord( .15, .85, .15, .85 )
	else
		tex:SetTexture"Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
		local offset, left, right, bottom, top = 0.025, unpack( CLASS_BUTTONS[class] )
		tex:SetTexCoord( left+offset, right-offset, bottom+offset, top-offset )
	end
end

local function SetStatusLayout( isMobile, isAFK, isDND, statusTex, fs )
	if config.statusMode == "icon" then
		if isMobile then
			statusTex:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ArmoryChat")
			if	isAFK then	statusTex:SetVertexColor(1,.6,.1)
			elseif	isDND then	statusTex:SetVertexColor(1,.1,.1)
			else			statusTex:SetVertexColor(.1,1,.1--[[.4,.4,1]]) end
		else
			statusTex:SetTexture("Interface\\FriendsFrame\\StatusIcon-"..(isAFK and "Away" or isDND and "DnD" or "Online"))
			statusTex:SetVertexColor(1,1,1)
		end
		statusTex:Show()
		fs:SetPoint("LEFT", statusTex, "RIGHT", TEXT_OFFSET, 0)
	else
		statusTex:Hide()
		fs:SetPoint("LEFT", statusTex, "LEFT")
	end
end

local function SetButtonData( index, inGroup )
	local button = buttons[index]

	if index == 0 then
		button.name:SetText(inGroup)
		return button, button.name:GetStringWidth()
	end

	local class, name, level, zone, notes, status, _, rank, realIndex, isMobile = unpack( (isGuild and guildEntries or friendEntries)[index] )
	button.unit = name
	button.realIndex = realIndex
	button.name:SetFormattedText( (status and preformatedStatusText or "")..(name or""), status )
	if name and class and class ~= "" then
		local color = RAID_CLASS_COLORS[class]
		if color then--Check if this is nil, in case some mod or user corrupted RAID_CLASS_COLORS or CUSTOM_CLASS_COLORS
			button.name:SetTextColor( color.r, color.g, color.b )
			SetClassOrCheckIcon( button.class, inGroup, name, class )
	--		SetStatusLayout( random() > .5, random() > 2/3, random() > .5, button.status, button.name ) -- DEBUG
			SetStatusLayout( isMobile, status == CHAT_FLAG_AFK, status == CHAT_FLAG_DND, button.status, button.name )
			color = GetDifficultyColor(level)
			button.level:SetTextColor( color.r, color.g, color.b )
			button.zone:SetTextColor( GetZoneColor(zone) )
		end
	end

	button.level:SetText( level or "" )
	button.zone:SetText( zone or "" )
	button.note:SetText( notes or "" )
	button.rank:SetText( rank or "" )

	return	button,
		button.name:GetStringWidth(),
		button.level:GetStringWidth(),
		button.zone:GetStringWidth(),
		button.note:GetStringWidth(),
		rank and button.rank:GetStringWidth() or -GAP
end


local function SetToastData( index, inGroup )
	local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcast, notes, _, _, _, _, _, isFavorite = GetBNGetFriendInfo(index)
	--toasts[index].isOnline = isOnline
	--toasts[index].isFavorite = isFavorite
	if not isOnline and not isFavorite then return nil end
	local toast, bc, color = toasts[index]
	local _, _, game, realm, realmID, faction, race, class, guild, zone, level, gameText, _, _, _, _, _, isGameAFK, isGameBusy, guid, wowProjectID = GetBNGetGameAccountInfo(toonID or 0)
	local statusText = config.statusMode ~= "icon" and (isAFK or isDND) and (preformatedStatusText):format(isAFK and CHAT_FLAG_AFK or isDND and CHAT_FLAG_DND) or ""

    if (config.enableBnetFriendsBroadcasts) then
        if broadcast and broadcast ~= "" then
        	nbBroadcast = nbBroadcast + 1
        	bc = broadcasts[nbBroadcast]
        	bc.text:SetText(broadcast)
        	toast.bcIndex = nbBroadcast
        else
        	toast.bcIndex = nil
        end
	else
	    toast.bcIndex = nil
    end
	toast.presenceID = presenceID
	toast.unit = BNet_GetValidatedCharacterName and BNet_GetValidatedCharacterName(toonName, battleTag, client) or toonName
	toast.realID = presenceName
	toast.unitrealm = realm

	SetStatusLayout( --[[isMobile]]false, isAFK, isDND, toast.status, toast.name )
	client = clientsTable[client] or 5--Set client to desktop app if unknown
	toast.client = client
	if client == 1 then--World of Warcraft
		toast.faction:SetTexture"Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions"
		toast.faction:SetTexCoord( faction == "Alliance" and 0.03 or 0.53, faction == "Alliance" and 0.47 or 0.97, 0.03, 0.97 )
		if type(wowProjectID) ~= "boolean" and wowProjectID ~= WOW_PROJECT_ID then--WOW_PROJECT_ID should be the users client, so if it doesn't match users client the zone is in gameText
			zone = gameText or UNKNOWN
			local zonesplit, realmSplit = strsplit("-", zone)
			if zonesplit and realmSplit then--gameText was actuall zone-realm
				zone = zonesplit
				realm = realmSplit
				toast.unitrealm = realmSplit
			end
		else
			zone = not gameText and (not zone or zone == "") and UNKNOWN or gameText or zone
		end
		toast.zone:SetPoint("TOPLEFT", toast.faction, "TOPRIGHT", TEXT_OFFSET, 0)
		toast.zone:SetTextColor( GetZoneColor(zone) )
		toast.sameRealm = realm == "" or realm == playerRealm

		if not toast.sameRealm then
			-- hide faction icon and move zone to level
			local r,g,b = unpack(colors.realm)
			zone = ("%1$s |cff%3$.2x%4$.2x%5$.2x- %2$s"):format(zone, realm or UNKNOWN, r*255, g*255, b*255)
		end
		class = ClassL[class]
		if class and class~="" then
			SetClassOrCheckIcon( toast.class, inGroup, toonName, class )
			color = RAID_CLASS_COLORS[class]
			toast.name:SetTextColor( color.r, color.g, color.b )
		else
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-WoWicon"
			toast.class:SetTexCoord( .2, .8, .2, .8 )
			toast.name:SetTextColor(.8,.8,.8)
		end
	elseif client == 0 then--Battle.net Mobile
		toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-Battleneticon"
		toast.class:SetTexCoord( .2, .8, .2, .8 )
		toast.name:SetTextColor( .8, .8, .8 )
		toast.faction:SetTexture""
		zone = L["Mobile App"]
		toast.zone:SetPoint("TOPLEFT", toast.name, "TOPRIGHT", GAP, 0)
		toast.zone:SetTextColor( 1, .77, 0 )
	elseif client == 5 or client == 8 then--Battle.net Desktop
		toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-Battleneticon"
		toast.class:SetTexCoord( .2, .8, .2, .8 )
		toast.name:SetTextColor( .8, .8, .8 )
		toast.faction:SetTexture""
		if isOnline then
			zone = L["Desktop App"]
		else
			zone = L["OFFLINE FAVORITE"]
			toast.class:SetTexture"Interface\\FriendsFrame\\StatusIcon-Offline"
		end
		toast.zone:SetPoint("TOPLEFT", toast.name, "TOPRIGHT", GAP, 0)
		toast.zone:SetTextColor( 1, .77, 0 )
	else
		if client == 2 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-Sc2icon"
		elseif client == 3 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-D3icon"
		elseif client == 4 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-WTCGicon"
		elseif client == 6 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-HotSicon"
		elseif client == 7 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-Overwatchicon"
		elseif client == 9 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-SCicon"
		elseif client == 10 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-Destiny2icon"
		elseif client == 11 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-CallOfDutyBlackOps4icon"
		elseif client == 12 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-CallOfDutyMWicon"
		elseif client == 13 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-CallOfDutyMW2icon"
		elseif client == 14 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-CallOfDutyBlackOpsColdWaricon"
		elseif client == 15 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-Warcraft3Reforged"
		elseif client == 16 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-BlizzardArcadeCollectionicon"
		elseif client == 17 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-CrashBandicoot4icon"
		elseif client == 18 then
			toast.class:SetTexture"Interface\\FriendsFrame\\Battlenet-DiabloIIResurrectedicon"
		elseif client == 19 then
			toast.class:SetTexture"Cache\\TitleIcons\\225231c6bc737ca317db2e94565b1820d8a25a7e6c24f92f0e37fe2fbdb63f54.png"
		end
		toast.class:SetTexCoord( .2, .8, .2, .8 )
		toast.name:SetTextColor( .8, .8, .8 )
		toast.faction:SetTexture""
		zone = gameText
		toast.zone:SetPoint("TOPLEFT", toast.name, "TOPRIGHT", GAP, 0)
		toast.zone:SetTextColor( 1, .77, 0 )
	end
	if config.realID == "none" then
		toast.name:SetText(toast.unit or "")
	else
		local rid = "|cff00b2f0"..toast.realID.."|r"
		if config.realID == "instead" then
			toast.name:SetText( statusText.. rid)
		else
			toast.name:SetFormattedText( statusText..(config.realID=="before" and "%1$s - %2$s" or "%2$s - %1$s"), rid, toast.unit or "")
		end
	end

	if level and level ~= "" and level ~= 0 then
		toast.level:SetText(level)
		color = GetDifficultyColor(tonumber(level))
		toast.level:SetTextColor( color.r, color.g, color.b )
	else	toast.level:SetText"" end

--	toast.raceIcon:SetTexture"Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races"
--	toast.raceIcon:SetTexCoord(  )
	toast.zone:SetText(zone or "")
	toast.note:SetText(notes or "")

	return	toast, client,
		toast.name:GetStringWidth(),
		client == 1 and toast.level:GetStringWidth() or -GAP,
		toast.zone:GetStringWidth(),
		toast.note:GetStringWidth()
end

local function UpdateScrollButtons(nbEntries)
	for i=1, #buttons do buttons[i]:Hide() end
	local baseOffset = -realFriendsHeight
	local sliderValue = hasSlider and sliderValue or 0
	for i=1, nbEntries do
		local button = buttons[sliderValue+i]
		button:SetPoint("TOPLEFT", motd, "BOTTOMLEFT", 0, baseOffset - (i-1)*BUTTON_HEIGHT)
		button:Show()
	end
end


local tiptacBKG = { tile = false, insets = {} }
-- Setup Gradient Tip (from TipTac)
local function SetupGradientTip(tip,cfg)
	local g = tip.ttGradient;
	if (not cfg.gradientTip) then
		if (g) then
			g:Hide();
		end
		return;
	elseif (not g) then
		g = tip:CreateTexture();
		g:SetTexture(1,1,1,1);
		tip.ttGradient = g;
	end
	g:SetGradient("VERTICAL",CreateColor(0,0,0,0),CreateColor(unpack(cfg.gradientColor)));
	g:SetPoint("TOPLEFT",cfg.backdropInsets,cfg.backdropInsets * -1);
	g:SetPoint("BOTTOMRIGHT",tip,"TOPRIGHT",cfg.backdropInsets * -1,-36);
	g:Show();
end


local function AnchorTablet(frame)
	CloseDropDownMenus()
--	f:GUILD_ROSTER_UPDATE()
	f:Show()
	f.isTop, f.onBlock = select(2, frame:GetCenter()) > UIParent:GetHeight() / 2, true
	f:ClearAllPoints()
	f:SetPoint(f.isTop and "TOP" or "BOTTOM", frame, f.isTop and "BOTTOM" or "TOP")
	if config.useTipTacSkin and TipTac then
		local playerName = UnitName("player")
		local realmName = GetRealmName()
		local keyName = playerName .. " - " .. realmName
		local TTProfileKey = TipTac_Config.profileKeys[keyName]
		local cfg = TipTac_Config.profiles[TTProfileKey]
		tiptacBKG.bgFile = cfg.tipBackdropBG
		tiptacBKG.edgeFile = cfg.tipBackdropEdge
		tiptacBKG.edgeSize = cfg.backdropEdgeSize
		tiptacBKG.insets.left = cfg.backdropInsets
		tiptacBKG.insets.right = cfg.backdropInsets
		tiptacBKG.insets.top = cfg.backdropInsets
		tiptacBKG.insets.bottom = cfg.backdropInsets
		f:SetBackdrop(tiptacBKG)
		f:SetBackdropColor(unpack(cfg.tipColor))
		f:SetBackdropBorderColor(unpack(cfg.tipBorderColor))
		SetupGradientTip(f,cfg)
	elseif Skinner then
		Skinner:applySkin(f)
	else
		f:SetBackdrop(backdrop)
		if f.ttGradient then f.ttGradient:Hide() end
		f:SetBackdropColor( unpack( colors.background ) )
		f:SetBackdropBorderColor( unpack( colors.border ) )
	end
	UpdateBlockHints()
	UpdateTablet()
end

local texOrder1 = f:CreateTexture()
texOrder1:SetTexture"Interface\\Buttons\\WHITE8X8"
texOrder1:SetBlendMode"ADD"


local function SortMates(a,b)
	local s = sortIndexes[isGuild]
	local si, lv = s[1], 1
	if a[si] == b[si] then
		si, lv = s[2], 2
		if a[si] ==  b[si] then
			si, lv = s[3], 3
		end
	end
	if config.sortASC[isGuild][lv] then
		return a[si] < b[si]
	else
		return a[si] > b[si]
	end
end


local function si(value)
	if type(value) ~= "number" or value < 1e3 then return tostring(value) end
	local l = floor(log10(value))
	return ("%%.%if%s"):format(2-l%3, l<6 and"k"or"m"):format( value/10^(floor(l/3)*3) ):gsub('%.?0+([km])$', '%1')
end

local baseFont = GameFontNormal:GetFont()


UpdateTablet = function()
	f:SetScale(config.scale)

	local totalRF, onlineRF, entries = 0, 0

	if isGuild then
		entries = guildEntries
		nbRealFriends = 0
	else
		entries = friendEntries
		totalRF, onlineRF, numBNetFavorite, numBNetFavoriteOnline = BNGetNumFriends()
		local offlineFavorites = 0
		if numBNetFavorite and numBNetFavoriteOnline then--Don't exist in classic at this time
			offlineFavorites = numBNetFavorite - numBNetFavoriteOnline
		end
		nbRealFriends = onlineRF + offlineFavorites--Adjust for offline favorites that are stuck taking up entry spaces
	end

	local nbTotalEntries = #entries + nbRealFriends
	local rid_width, button = 0

	realFriendsHeight = 0

	local nameC, levelC, zoneC, notesC, rankC = 0, 0, 0, 0, -GAP
	local nameW, levelW, zoneW, notesW, rankW
	local hideNotes = isGuild and not config.showGuildNotes or not (isGuild or config.showFriendNotes)
	local inGroup = GetNumGroupMembers()>0 and (IsInRaid() and UnitInRaid or UnitInParty or nil)
	local tnC, lC, zC, nC = 0, -GAP, -GAP, 0
	local spanZoneC = 0

	--Pulls bnet friend toast data
	if nbRealFriends > 0 then
		nbBroadcast = 0
		for i=1, nbRealFriends do
			local button, client, tnW, lW, zW, nW, spanZoneW = SetToastData(i,inGroup)
			
			if button then--Rejects offline friends (except for favorates)
				if tnW>tnC then tnC=tnW end

				if client == 1 then
					if lW>lC then lC=lW end
					if zW>zC then zC=zW end
				else
					if zW > spanZoneC then spanZoneC = zW end
				end

				if nW>nC then nC=nW end
			end
		end

		realFriendsHeight = (nbRealFriends+nbBroadcast) * BUTTON_HEIGHT + (#entries>0 and GAP or 0)
		
		if hideNotes then nC = -GAP end

		spanZoneC = max( spanZoneC, lC + GAP + ICON_SIZE + TEXT_OFFSET + zC )
		rid_width = ICON_SIZE + TEXT_OFFSET + tnC + spanZoneC + nC + 2*GAP
	end
	
	--Handles non bnet friends and guild members
	sort(entries,SortMates)
	for i = 1, #entries do
		button, nameW, levelW, zoneW, notesW, rankW = SetButtonData( i, inGroup )
		button:SetScript( "OnClick", OnGuildmateClick )
		if nameW > nameC then nameC = nameW end
		if levelW and levelW>0 then
			if levelW > levelC then levelC = levelW end
			if  zoneW >  zoneC then  zoneC = zoneW  end
			if notesW > notesC then notesC = notesW end
			if  rankW >  rankC then  rankC = rankW  end
			if hideNotes then button.note:Hide() else button.note:Show() end
			button.rank:SetPoint( "TOPLEFT", hideNotes and button.zone or button.note, "TOPRIGHT", GAP, 0 )
		end
	end

	if hideNotes then notesC = -GAP end
	local maxWidth = max( rid_width, ICON_SIZE + TEXT_OFFSET + nameC + levelC + zoneC + notesC + rankC + GAP * 4 )
	if config.statusMode=="icon" then maxWidth = maxWidth + ICON_SIZE + TEXT_OFFSET end

	-- guild xp / motd / broadcast
	local canEditMOTD = CanEditMOTD()
	motd:SetPoint("TOPLEFT", GAP, -GAP)
	motd:SetScript("OnClick",nil)
	local guildMOTD = isGuild and GetGuildRosterMOTD()
	if isGuild and (nbTotalEntries>0 and guildMOTD or nbTotalEntries==0) or not isGuild and (BNFeaturesEnabled() and totalRF>0 and config.showOwnBroadcast or nbTotalEntries==0) then
		motd.name:SetJustifyH"LEFT"
		motd.name:SetTextColor( unpack(colors.title) )
		local r, g, b = unpack(colors.motd)
		local motdText = ("%%s:  |cff%.2x%.2x%.2x%%s"):format(r*255, g*255, b*255)
		if isGuild then
			SetButtonData( 0, nbTotalEntries>0 and motdText:format(L["MOTD"], guildMOTD) or "     |cffff2020"..ERR_GUILD_PLAYER_NOT_IN_GUILD )
			if nbTotalEntries>0 and canEditMOTD then motd:SetScript( "OnClick", EditMOTD ) end
		else
			if nbTotalEntries == 0 then
				SetButtonData( 0, "     |cffff2020"..L["No friends online."] )
			elseif not BNConnected() then
				motd.name:SetJustifyH"CENTER"
				SetButtonData( 0, "|cffff2020"..BATTLENET_UNAVAILABLE )
			else
				SetButtonData( 0, motdText:format(L["Broadcast"], select(4, BNGetInfo()) or "") )
				motd:SetScript("OnClick", EditBroadcast)
			end
		end
		if nbTotalEntries==0 then
			extraHeight = 0
			maxWidth = min( motd.name:GetStringWidth()+GAP*2, 300 )
		else
			extraHeight = BUTTON_HEIGHT
			sep:Show()
		end
		motd.name:SetWidth( maxWidth )
		extraHeight = extraHeight + motd.name:GetHeight()

		motd:SetSize( maxWidth, extraHeight )

		buttons[1]:SetPoint("TOPLEFT", motd, "BOTTOMLEFT", 0, -realFriendsHeight)
	else
		extraHeight = 0
		motd.name:SetText""
		motd:SetSize( maxWidth, .1 )
		buttons[1]:SetPoint("TOPLEFT", f, GAP, -GAP)
	end
	if nbTotalEntries==0 or not (isGuild or config.showOwnBroadcast) then sep:Hide() end

	for i=1, #toasts do toasts[i]:Hide() end
	for i=1, #broadcasts do broadcasts[i]:Hide() end
	if not isGuild and nbRealFriends>0 then
		local header, bcOffset = motd, 0
		local bcWidth = maxWidth - 2*(ICON_SIZE - TEXT_OFFSET) -2*GAP
		for i=1, #toasts do
			local b = toasts[i]
			b:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, (1-i-bcOffset)*BUTTON_HEIGHT)
			if b.bcIndex then
				bcOffset = bcOffset + 1
				local bc = broadcasts[b.bcIndex]
				bc.text:SetWidth(bcWidth)
				bc:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, (1-i-bcOffset)*BUTTON_HEIGHT)
				bc:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", -ICON_SIZE-TEXT_OFFSET, (-i-bcOffset)*BUTTON_HEIGHT)
				bc:Show()
			end
			b:Show()
		end
	end

	MAX_ENTRIES = floor( (UIParent:GetHeight()/config.scale - extraHeight - GAP*2) / BUTTON_HEIGHT - (config.hideHints and 2 or ((not isGuild or canEditMOTD) and 11 or 9)) / config.scale )
	slider:SetHeight(BUTTON_HEIGHT*MAX_ENTRIES)
	hasSlider = #entries > MAX_ENTRIES
	if hasSlider then
		slider:SetMinMaxValues( 0, #entries - MAX_ENTRIES )
		slider:SetValue(sliderValue)
		slider:Show()
	else	slider:Hide() end
	nbEntries = math.min( MAX_ENTRIES, #entries )

	UpdateScrollButtons(nbEntries)

	for i=1, nbRealFriends do
		button = toasts[i]
		button:SetWidth( maxWidth )
		button.name:SetWidth(tnC)
		if button.client == 1 then
			button.level:SetWidth(lC)
			button.zone:SetWidth(zC)
		else
			button.zone:SetWidth(spanZoneC)
		end
		button.note:SetWidth(nC)
	end

	for i=1, #entries do
		button = buttons[i]
		button:SetWidth( maxWidth )
		button.name:SetWidth(nameC)
		button.level:SetWidth(levelC)
		button.zone:SetWidth(zoneC)
		button.note:SetWidth(notesC)
		button.rank:SetWidth(rankC)
	end

	if nbEntries>0 and config.highlightOrder then
		local col = config.sortCols[isGuild][1]
		local obj = buttons[1][col]
		if obj:IsShown() then
			texOrder1:SetPoint("TOPLEFT", obj, "TOPLEFT", -.25*GAP, 2 )
			texOrder1:SetSize(obj:GetWidth()+GAP*.5, nbEntries*BUTTON_HEIGHT+1)
			local asc = config.sortASC[isGuild][1]
			if col == "level" then asc = not asc end
			if config.highlightMode == "simple" then
				local r,g,b,a = unpack(colors.orderA)
				texOrder1:SetGradient("VERTICAL", CreateColor(r,g,b,a), CreateColor(r,g,b,a))
			else
				if config.highlightMode == "gradientZA" then asc = not asc end
				local a1, r1, g1, b1 = colors.orderA[4], unpack(colors.orderA)
				local a2, r2, g2, b2 = 0, unpack(colors.background)
				if asc then r1,g1,b1,a1, r2,g2,b2,a2 = r2,g2,b2,a2, r1,g1,b1,a1 end
				texOrder1:SetGradient("VERTICAL", CreateColor(r1,g1,b1,a1), CreateColor(r2,g2,b2,a2))
			end
		else
			texOrder1:SetAlpha(0)
		end
	else
		texOrder1:SetAlpha(0)
	end

	if hasSlider then slider:SetPoint("TOPRIGHT", buttons[1], "TOPRIGHT", 19 + TEXT_OFFSET, 0) end

	f:SetSize( 
		maxWidth + GAP*2 + (hasSlider and 16 + TEXT_OFFSET*2 or 0),
		extraHeight + realFriendsHeight + BUTTON_HEIGHT * nbEntries + GAP*2 
	)

	if not (f.onBlock or f:IsMouseOver()) then f:Hide() end
end

local function Block_OnLeave(self)
	f.onBlock = nil
	tip:Hide()
	if not f:IsMouseOver() then
		f:Hide()
	end
end

local function PreFormatStatusText(color)
	if config.statusMode == "classColored" then
		preformatedStatusText = "%s "
	elseif config.statusMode == "customColored" then
		local r,g,b = unpack(color)
		preformatedStatusText = ("|cff%.2x%.2x%.2x%%s|r "):format(r*255,g*255,b*255)
	elseif config.statusMode == "icon" then
		preformatedStatusText = ""
	end
end


local function UpdateAlignments(var, val)
	local fs = var:sub(6):lower()
	for _, b in ipairs(buttons) do
		b[fs]:SetJustifyH(val)
	end
end


function f:SetupConfigMenu()
	configMenu = CreateFrame("Frame", "AraGuildFriendsConfigMenu")
	configMenu.displayMode = "MENU"

	f.SetCustomScale = function(dialog)
		local val = tonumber( dialog.editBox:GetText():match"(%d+)" )
		if not val or val<70 or val>200 then
			baseScript = BasicScriptErrors:GetScript"OnHide"
			BasicScriptErrors:SetScript("OnHide",Error_OnHide)
			BasicScriptErrorsText:SetText(L["Invalid scale.\nShould be a number between 70 and 200%"])
			return BasicScriptErrors:Show()
		end
		config.scale = val/100
	end

	StaticPopupDialogs.SET_ABGF_SCALE = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."],
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		maxLetters = 4,
		OnAccept = AraBrokerGuildFriends.SetCustomScale,
		OnShow = function(self) CloseDropDownMenus() self.editBox:SetText(config.scale*100) self.editBox:SetFocus() end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self) local p=self:GetParent() AraBrokerGuildFriends.SetCustomScale(p) p:Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	options = {
		{ text = format(L["|cffffb366Ara|r Guild & Friends (%s)"], GetAddOnMetadata( addonName, "Version" ) ), isTitle = true },
		{ text = L["Show guild name"], check = "showGuildName" },
		{ text = L["Show 'Guild' tag"], check = "showGuildTag" },
		{ text = L["Show total number of guildmates"], check = "showGuildTotal" },
		{ text = L["Show 'Friends' tag"], check = "showFriendsTag" },
		{ text = L["Show total number of friends"], check = "showFriendsTotal" },
		{ text = L["Show guild XP"], check = "showGuildXP", submenu = {
			{ text = L["Show guild XP tooltip"], check = "showGuildXPTooltip" },
		} },
		{ text = L["Show own broadcast"], check = "showOwnBroadcast" },
		{ text = L["Show bnet friends broadcast"], check = "enableBnetFriendsBroadcasts" },
		{ text = L["Show guild notes"], check = "showGuildNotes" },
		{ text = L["Show friend notes"], check = "showFriendNotes" },
		{ text = L["Show class icon when grouped"], check = "showUngroupedClassIcon" },
		{ text = L["Highlight sorted column"], check = "highlightOrder", submenu = {
			{ text = L["Simple"], radio = "highlightMode", val = "simple" },
			{ text = L["Gradient"], radio = "highlightMode", val = "gradientAZ" },
			{ text = L["Reverse gradient"], radio = "highlightMode", val = "gradientZA" },
			} },
		{ text = L["Status as..."], submenu = {
			{ text = L["Class colored text"], radio = "statusMode", val = "classColored" },
			{ text = L["Custom colored text"], radio = "statusMode", val = "customColored" },
			{ text = L["Icon"], radio = "statusMode", val = "icon" },
		} },
		{ text = L["Real ID..."], submenu = {
			{ text = L["Before nickname"], radio = "realID", val = "before" },
			{ text = L["Instead of nickname"], radio = "realID", val = "instead" },
			{ text = L["After nickname"], radio = "realID", val = "after" },
			{ text = L["Don't show"], radio = "realID", val = "none" }
			} },
		{ text = L["Column alignments"], submenu = {
			{ text = L["Name"], submenu = "alignName" },
			{ text = L["Zone"], submenu = "alignZone" },
			{ text = L["Notes"],submenu = "alignNote" },
			{ text = L["Rank"], submenu = "alignRank" },
		} },
		{ text = L["Tooltip Size"], submenu = {
			{ text = L["90%"], radio = "scale", val = 0.9 },
			{ text = L["100%"], radio = "scale", val = 1.0 },
			{ text = L["110%"], radio = "scale", val = 1.1 },
			{ text = L["120%"], radio = "scale", val = 1.2 },
			{ text = L["Custom..."], radio="scaleX", func=function() StaticPopup_Show"SET_ABGF_SCALE" end }, } },
		{ text = L["Use TipTac skin (requires TipTac)"], check = "useTipTacSkin" },
		{ text = L["Colors"], submenu = {
			{ text = L["Background"], color = "background" },
			{ text = L["Borders"], color = "border" },
			{ text = L["Order highlight"], color = "orderA" },
			{ text = L["Headers"], color = "title" },
			{ text = L["MotD / broadcast"], color = "motd" },
			{ text = L["Friendly zone"], color = "friendlyZone" },
			{ text = L["Contested zone"], color = "contestedZone" },
			{ text = L["Enemy zone"], color = "enemyZone" },
			{ text = L["Notes"], color = "note" },
			{ text = L["Officer notes"], color = "officerNote" },
			{ text = L["Status"], color = "status" },
			{ text = L["Ranks"], color = "rank" },
			{ text = L["Friends broadcast"], color = "broadcast" },
			{ text = L["Realms"], color = "realm" },
			{ text = L["|cffaaaaffRestore default colors"], func=
				function()
					for k, v in next, defaultConfig.colors do
						local color = colors[k]
						color[1], color[2], color[3], color[4] = unpack(v)
						UpdateColor(k, color)
					end
				end }
		} },
		{ text = L["Show Block Hints"], check = "showBlockHints", submenu = {
			{ text = L["Open panel"], check = "hbOpenPanel" },
			{ text = L["Config menu"], check = "hbConfig" },
			{ text = L["Toggle notes"], check = "hbToggleNotes" },
			{ text = L["Add a friend"], check = "hbAddFriend" },
		} },
		{ text = L["Show Hints"], check = "hideHints", inv=true, submenu = {
			{ text = L["Whisper"], check = "hWhisp" },
			{ text = L["Invite"], check = "hInvite" },
			{ text = L["Query"], check = "hQuery" },
			{ text = L["Edit note"], check = "hNote" },
			{ text = L["Edit officer note"], check = "hONote" },
			{ text = L["Sort main column"], check = "hOrderA" },
			{ text = L["Sort second column"], check = "hOrderB" },
			{ text = L["Sort third column"], check = "hOrderC" },
			{ text = L["Resize tooltip"], check = "hResizeTip" },
			{ text = L["Remove friend"], check = "hRemoveFriend" },
		} }
	}
	local aligns = { "LEFT", "CENTER", "RIGHT" }

	configMenu.initialize = function(self, level)
		if not level then return end
		local opt = level > 1 and UIDROPDOWNMENU_MENU_VALUE or options
		if type(opt)=="string" and opt:find("^align") then
			for _, pos in ipairs(aligns) do
				info = wipe(info)
				info.text = pos
				info.checked = config[opt] == pos
				info.func, info.arg1, info.arg2 = SetOption, opt, pos
				info.keepShownOnClick = true
				UIDropDownMenu_AddButton( info, level )
			end
			return
		end
		for i, v in ipairs( opt ) do
			info = wipe(info)
			info.text = v.text
			info.isTitle = v.isTitle
			local adjust
			if v.radio then
				if v.radio == "scaleX" then
					info.checked = config.scale ~= .9 and config.scale ~= 1 and config.scale ~= 1.1 and config.scale ~= 1.2
					info.func = v.func
					if info.checked then
						info.text = ("%s (%i%%)"):format(info.text, config.scale*100)
					end
				else
					info.checked = config[v.radio] == v.val
					info.func, info.arg1, info.arg2 = SetOption, v.radio, v.val
					info.keepShownOnClick = true
				end
			elseif v.check then
				info.checked = v.inv and not config[v.check] or not v.inv and config[v.check]
				info.func, info.arg1 = SetOption, v.check
				info.isNotRadio = true
				info.keepShownOnClick = true
			elseif v.color then
				info.hasColorSwatch, info.notCheckable = true, true
				info.r, info.g, info.b = unpack(colors[v.color])
				info.func, info.arg1 = OpenColorPicker, v.color
				info.padding = 10
			else
				info.func = v.func
				info.notCheckable = true
				if level == 1 then adjust = true end
			end
			info.hasArrow, info.value = v.submenu, v.submenu
			UIDropDownMenu_AddButton( info, level )
			if adjust then
				local button = _G[("DropDownList1Button%i"):format(DropDownList1.numButtons)]
				local normalText = _G[("DropDownList1Button%iNormalText"):format(DropDownList1.numButtons)]
    
				normalText:ClearAllPoints()
				normalText:SetPoint("LEFT", button, "LEFT", 20, 0)
    
				local framePoint, relativeFrame, framePoint, _, offsetY =  button:GetPoint()
				button:SetPoint(framePoint, relativeFrame, framePoint, 11, offsetY)
			end
		end
	end

	local hasNoColorProcessing = { ["background"]=1, ["orderA"]=1, ["order"]=1, ["officerNote"]=1, ["motd"]=1, ["friendlyZone"]=1, ["contestedZone"]=1, ["enemyZone"]=1 }

	UpdateColor = function(cname, _c)
		c = _c or c
		if hasNoColorProcessing[cname] then return end
		if cname == "status" then return PreFormatStatusText(c) end
		local r,g,b = unpack(c)
		if cname == "broadcast" or cname == "note" or cname == "realm" then
			for i, toast in next, toasts do
				local fs = toast[cname]
				if fs then fs:SetTextColor(r,g,b) end
			end
		end
		if cname == "rank" or cname == "note" then
			for i, btn in next, buttons do
				if i>0 then btn[cname]:SetTextColor(r,g,b) end
			end
		end
	end
	ColorPickerOpacity = function()
		c[4] = 1 - OpacitySliderFrame:GetValue()
	end
	ColorPickerChange = function()
		c[1], c[2], c[3] = ColorPickerFrame:GetColorRGB()
		UpdateColor(cname)
	end
	ColorPickerCancel = function(prev)
		c[1], c[2], c[3], c[4] = unpack(prev)
		UpdateColor(cname)
	end
	OpenColorPicker = function(self, colorName)
		ColorPickerFrame:Hide()
		cname = colorName
		c = colors[colorName]
		local hasOpacity = c[4]
		if hasOpacity then ColorPickerFrame.opacity = 1 - c[4] end
		ColorPickerFrame.hasOpacity = hasOpacity
		ColorPickerFrame.opacityFunc = hasOpacity and ColorPickerOpacity or nil
		ColorPickerFrame.func = ColorPickerChange
		ColorPickerFrame.cancelFunc = ColorPickerCancel
		ColorPickerFrame.previousValues = {unpack(c)}
		ColorPickerFrame:SetColorRGB( unpack(c) )
		ShowUIPanel(ColorPickerFrame)--:Show()
	end

	SetOption = function(bt, var, val)
		config[var] = val or not config[var]
		if var == "showGuildName" or var == "showGuildTag" or var == "showGuildTotal" then
			UpdateGuildBlockText()
		elseif var == "showFriendsTag" or var == "showFriendsTotal" then
			UpdateFriendBlockText()
		elseif var == "statusMode" then
			PreFormatStatusText(colors.status)
		elseif var:find"^align" then
			UpdateAlignments(var, val)
		end
		if not val then return end

		local sub = bt:GetName():sub(1, 19).."%i"
		for i = 1, bt:GetParent().numButtons do
			local subi = sub:format(i)
			if _G[subi] == bt then
				_G[subi.."Check"]:Show()
			else
				_G[subi.."Check"]:Hide()
				_G[subi.."UnCheck"]:Show()
			end
		end
	end

	f.SetupConfigMenu = nil
end

local function DisplayConfigMenu( anchor )
	if not configMenu then f:SetupConfigMenu() end
	f:Hide() tip:Hide()
	configMenu.scale = UIParent:GetScale()
	ToggleDropDownMenu(1, nil, configMenu, anchor, 0, 0)
end


local ldb = LibStub("LibDataBroker-1.1")

local orgGuildRoster = GuildRoster or C_GuildInfo.GuildRoster
f.GuildBlock = ldb:NewDataObject( "|cFFFFB366Ara|r Guild", {
	type = "data source",
	text = GUILD,
	icon = [[Interface\AddOns\Ara_Broker_Guild_Friends\guild]],
	OnEnter = function(self)
		isGuild = true
		if IsInGuild() then orgGuildRoster() end
		f:GUILD_ROSTER_UPDATE()--Force update in case user changed checkbox option for "show offline"
		AnchorTablet(self)
	end,
	OnLeave = Block_OnLeave,
	OnClick = function(self, button)
		if button == "LeftButton" then
			ToggleGuildFrame()
			if GuildFrame and GuildFrame:IsShown() then
				GuildFrameTab2:Click()
				f.GuildBlock.OnLeave(self)
			else	f.GuildBlock.OnEnter(self) end
		elseif button == "RightButton" then
			DisplayConfigMenu(self)
		elseif button == "Button4" then
			config.showGuildNotes = not config.showGuildNotes
			UpdateTablet()
		end
	end,
} )

f.FriendsBlock = ldb:NewDataObject( "|cFFFFB366Ara|r Friends", {
	type = "data source",
	text = FRIENDS,
	icon = [[Interface\AddOns\Ara_Broker_Guild_Friends\friends]],
	OnEnter = function(self)
		isGuild = false
		ShowFriends()
		AnchorTablet(self)
	end,
	OnLeave = Block_OnLeave,
	OnClick = function(self, button)
		if button == "MiddleButton" or IsModifierKeyDown() then
			f:Hide() tip:Hide()
			FriendsFrameAddFriendButton:Click()
		elseif button == "LeftButton" then
			if not (FriendsFrame and FriendsFrame:IsShown()) then
				f.FriendsBlock.OnLeave(self)
			elseif not f:IsShown() then
				f.FriendsBlock.OnEnter(self)
			end
			ToggleFriendsFrame(1)
		elseif button == "RightButton" then
			DisplayConfigMenu(self)
		elseif button == "Button4" then
			config.showFriendNotes = not config.showFriendNotes
			UpdateTablet()
		end
	end,
} )

local guildTimer, friendTimer = 0, 0

GuildRoster = function(...)
	guildTimer = 0
	return orgGuildRoster(...)
end

local orgShowFriends = C_FriendList and C_FriendList.ShowFriends or ShowFriends
ShowFriends = function(...)
	friendTimer = 0
	return orgShowFriends(...)
end


local function OnUpdate( self )
	if IsInGuild() then GuildRoster() end
	ShowFriends()
end


function f:BN_FRIEND_INFO_CHANGED()
	if f:IsShown() then
		UpdateTablet()
	end
end
f.BN_CUSTOM_MESSAGE_CHANGED = f.BN_FRIEND_INFO_CHANGED

f.BN_FRIEND_ACCOUNT_ONLINE = UpdateFriendBlockText
f.BN_FRIEND_ACCOUNT_OFFLINE = UpdateFriendBlockText
f.BN_CONNECTED = UpdateFriendBlockText
f.BN_DISCONNECTED = UpdateFriendBlockText

-- add/remove new/obsolete config var
local function UpdateConfig( baseConfig, currentConfig, deep, remove )
	for var, defaultValue in next, baseConfig do
		local currentValue = currentConfig[var]
		if currentValue == nil then
			if remove then baseConfig[var] = nil else currentConfig[var] = defaultValue end
		elseif type(currentValue) == "table" and type(defaultValue) == "table" then
			UpdateConfig( defaultValue, currentValue, true, remove )
		end
	end
	-- if top level first call and config isn't new, remove obsolete var
	if not deep and defaultConfig ~= config then UpdateConfig( currentConfig, baseConfig, true, true ) end
end


function f:ADDON_LOADED( addon )
	if addon ~= addonName then return end

	SDTDB = SDTDB or {}
	SDTDB.AraBroker = SDTDB.AraBroker or {}

	-- Migrate old settings if they exist
	if AraBrokerGuildFriendsDB and not SDTDB.AraBroker.migrated then
		SDTDB.AraBroker = AraBrokerGuildFriendsDB
		SDTDB.AraBroker.migrated = true
	end

	SDTDB.AraBroker = SDTDB.AraBroker or defaultConfig
	config = SDTDB.AraBroker
	UpdateConfig( defaultConfig, config )

	colors = config.colors
	PreFormatStatusText(colors.status)
	sortIndexes = {
		[true] = { colpairs[config.sortCols[true ][1]], colpairs[config.sortCols[true ][2]], colpairs[config.sortCols[true ][3]] },
		[false] ={ colpairs[config.sortCols[false][1]], colpairs[config.sortCols[false][2]], colpairs[config.sortCols[false][3]] },
	}
	texOrder1:SetVertexColor(unpack(colors.orderA))

for eng, loc in next, LOCALIZED_CLASS_NAMES_MALE   do ClassL[loc] = eng end
for eng, loc in next, LOCALIZED_CLASS_NAMES_FEMALE do ClassL[loc] = eng end

	tip = GameTooltip
	horde = UnitFactionGroup"player" == "Horde"
	playerRealm = GetRealmName()
	f:SetBackdrop(backdrop)
	f:SetFrameStrata"TOOLTIP"
	f:SetClampedToScreen(true)
	f:EnableMouse(true)

	StaticPopupDialogs.SET_BN_BROADCAST = {
		preferredIndex = STATICPOPUP_NUMDIALOGS,
		text = BN_BROADCAST_TOOLTIP,
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
		OnShow = function(self) self.editBox:SetText( select(4, BNGetInfo()) ) self.editBox:SetFocus() end,
		OnHide = ChatEdit_FocusActiveWindow,
		EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1,
	}

	if not t.ticker then
		t.ticker = C_Timer.NewTicker(15, function() OnUpdate(t) end)
	end
	f:SetScript( "OnEnter", Menu_OnEnter )
	f:SetScript( "OnLeave", Menu_OnLeave )
	f:SetScript( "OnMouseWheel", Scroll )

	f:RegisterEvent"GUILD_ROSTER_UPDATE"
	f:RegisterEvent"PLAYER_GUILD_UPDATE"
	f:RegisterEvent"FRIENDLIST_UPDATE"
	f:RegisterEvent"CHAT_MSG_SYSTEM"

	f:RegisterEvent"BN_FRIEND_INFO_CHANGED"
	f:RegisterEvent"BN_FRIEND_ACCOUNT_ONLINE"
	f:RegisterEvent"BN_FRIEND_ACCOUNT_OFFLINE"
	f:RegisterEvent"BN_CUSTOM_MESSAGE_CHANGED"
	f:RegisterEvent"BN_CONNECTED"
	f:RegisterEvent"BN_DISCONNECTED"

	slider = CreateFrame("Slider", nil, f)
	Mixin(slider, BackdropTemplateMixin)
	slider:SetWidth(16)
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	slider:SetBackdrop( {
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		edgeSize = 8, tile = true, tileSize = 8,
		insets = { left=3, right=3, top=6, bottom=6 }
	} )
	slider:SetValueStep(1)
	slider:SetScript( "OnLeave", Menu_OnLeave )
	slider:SetScript( "OnValueChanged", function(self, value)
		if hasSlider then
			sliderValue = value
			if f:IsMouseOver() then UpdateScrollButtons(MAX_ENTRIES) end
		end
	end )

	motd = buttons[0]
	ShowFriends()
	guildTimer = 14 -- delay update to avoid d/c
	f:GUILD_ROSTER_UPDATE()

	f:UnregisterEvent"ADDON_LOADED"
	f.ADDON_LOADED = nil
end

f:RegisterEvent"ADDON_LOADED"
f:SetScript( "OnEvent", function(self, event, ...) return self[event](self, ...) end )
