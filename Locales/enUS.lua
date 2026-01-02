local _, SDT = ...
local L = SDT.L

-- ----------------------------
-- SimpleDatatexts.lua
-- ----------------------------
-- Used in: Settings.lua, SimpleDatatexts.lua
L["(empty)"] = "(empty)"
L["Loaded. Total modules: %d"] = "Loaded. Total modules: %d"
L["|cffffff00--[Options]--|r"] = "|cffffff00--[Options]--|r"
L["Lock/Unlock: |cff8888ff/sdt lock|r"] = "Lock/Unlock: |cff8888ff/sdt lock|r"
L["Width: |cff8888ff/sdt width <barName> <newWidth>|r"] = "Width: |cff8888ff/sdt width <barName> <newWidth>|r"
L["Height: |cff8888ff/sdt height <barName> <newHeight>|r"] = "Height: |cff8888ff/sdt height <barName> <newHeight>|r"
L["Scale: |cff8888ff/sdt scale <barName> <newScale>|r"] = "Scale: |cff8888ff/sdt scale <barName> <newScale>|r"
L["Settings: |cff8888ff/sdt config|r"] = "Settings: |cff8888ff/sdt config|r"
L["Version: |cff8888ff/sdt version|r"] = "Version: |cff8888ff/sdt version|r"
L["Usage: /sdt %s <barName> <value>"] = "Usage: /sdt %s <barName> <value>"
L["Invalid panel name supplied. Valid panel names are:"] = "Invalid panel name supplied. Valid panel names are:"
L["A valid numeric value for the adjustment must be specified."] = "A valid numeric value for the adjustment must be specified."
L["Invalid panel width specified."] = "Invalid panel width specified."
L["Invalid panel height specified."] = "Invalid panel height specified."
L["Invalid panel scale specified."] = "Invalid panel scale specified."
L["Invalid adjustment type specified."] = "Invalid adjustment type specified."
L["SDT panels are now: "] = "SDT panels are now: "
L["|cffff0000LOCKED|r"] = "|cffff0000LOCKED|r"
L["|cff00ff00UNLOCKED|r"] = "|cff00ff00UNLOCKED|r"
L["Simple Datatexts Version: |cff8888ff%s|r"] = "Simple Datatexts Version: |cff8888ff%s|r"

-- ----------------------------
-- Settings.lua
-- ----------------------------
L["Simple DataTexts"] = "Simple DataTexts"
L["Global"] = "Global"
L["Simple DataTexts - Global Settings"] = "Simple DataTexts - Global Settings"
L["Panels"] = "Panels"
L["Simple DataTexts - Panel Settings"] = "Simple DataTexts - Panel Settings"
L["Profiles"] = "Profiles"
L["Simple DataTexts - Profile Settings"] = "Simple DataTexts - Profile Settings"
L["Lock Panels (disable movement)"] = "Lock Panels (disable movement)"
L["Use Class Color"] = "Use Class Color"
L["Use 24Hr Clock"] = "Use 24Hr Clock"
L["Use Custom Color"] = "Use Custom Color"
L["Display Font:"] = "Display Font:"
L["Font Size"] = "Font Size"
L["Create New Panel"] = "Create New Panel"
L["Select Panel:"] = "Select Panel:"
L["Rename Panel:"] = "Rename Panel:"
L["Remove Selected Panel"] = "Remove Selected Panel"
L["Slot %d:"] = "Slot %d:"
L["Scale"] = "Scale"
L["Background Opacity"] = "Background Opacity"
L["Slots"] = "Slots"
L["Width"] = "Width"
L["Height"] = "Height"
L["Select Border:"] = "Select Border:"
L["Border Size"] = "Border Size"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Are you sure you want to delete this bar?\nThis action cannot be undone."
-- Used in: Settings.lua, Utilities.lua
L["Yes"] = "Yes"
-- Used in: Settings.lua, Utilities.lua
L["No"] = "No"
L["(none)"] = "(none)"
L["Create New Profile:"] = "Create New Profile:"
L["Current Profile:"] = "Current Profile:"
L["Enable Per-Spec Profiles"] = "Enable Per-Spec Profiles"
L["Copy Profile:"] = "Copy Profile:"
L["Delete Profile:"] = "Delete Profile:"
L["NYI:"] = "NYI:"
L["The profile name you have entered already exists. Please enter a new name."] = "The profile name you have entered already exists. Please enter a new name."
-- Used in: Settings.lua, Utilities.lua
L["Ok"] = "Ok"
L["Saved font not found. Resetting font to Friz Quadrata TT."] = "Saved font not found. Resetting font to Friz Quadrata TT."

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Are you sure you want to overwrite your\n'%s' profile?\nThis action cannot be undone."] = "Are you sure you want to overwrite your\n'%s' profile?\nThis action cannot be undone."
L["You cannot copy the active profile onto itself. Please change your active profile first."] = "You cannot copy the active profile onto itself. Please change your active profile first."
L["Invalid source profile specified."] = "Invalid source profile specified."
L["You cannot delete the active profile. Please change your active profile first."] = "You cannot delete the active profile. Please change your active profile first."
L["Are you sure you want to delete this profile?\nThis action cannot be undone."] = "Are you sure you want to delete this profile?\nThis action cannot be undone."

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Mitigation By Level:"
L["Level %d"] = "Level %d"
L["Target Mitigation"] = "Target Mitigation"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Bags"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit: "] = "Crit: "

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "CURRENCIES"
-- Used in: modules/Currency.lua, modules/Gold.lua
L["GOLD"] = "GOLD"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Durability: "] = "Durability: "

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Ara Friends LDB object not found! SDT Friends datatext disabled."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Session:"] = "Session:"
L["Earned:"] = "Earned:"
L["Spent:"] = "Spent:"
L["Profit:"] = "Profit:"
L["Deficit:"] = "Deficit:"
L["Character:"] = "Character:"
L["Server:"] = "Server:"
L["Alliance:"] = "Alliance:"
L["Horde:"] = "Horde:"
L["Total:"] = "Total:"
L["Warband:"] = "Warband:"
L["WoW Token:"] = "WoW Token:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Reset Session Data: Hold Ctrl + Right Click"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Ara Guild LDB object not found! SDT Guild datatext disabled."

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste: "] = "Haste: "

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "NO TEXT"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "New Mail"
L["No Mail"] = "No Mail"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery: "] = "Mastery: "

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Active"
L["Inactive"] = "Inactive"
L["Loadouts"] = "Loadouts"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Failed to load Blizzard_PlayerSpells: %s"
L["Starter Build"] = "Starter Build"
L["Spec"] = "Spec"
L["Left Click: Change Talent Specialization"] = "Left Click: Change Talent Specialization"
L["Control + Left Click: Change Loadout"] = "Control + Left Click: Change Loadout"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + Left Click: Show Talent Specialization UI"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + Right Click: Change Loot Specialization"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "mb"
L["KB_SUFFIX"] = "kb"
L["SYSTEM"] = "SYSTEM"
L["FPS:"] = "FPS:"
L["Home Latency:"] = "Home Latency:"
L["World Latency:"] = "World Latency:"
L["Total Memory:"] = "Total Memory:"
L["(Shift Click) Collect Garbage"] = "(Shift Click) Collect Garbage"
L["FPS"] = "FPS"
L["MS"] = "MS"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "TIME"
L["Saved Raid(s)"] = "Saved Raid(s)"
L["Saved Dungeon(s)"] = "Saved Dungeon(s)"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers: "] = "Vers: "

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Select Volume Stream"
L["Toggle Volume Stream"] = "Toggle Volume Stream"
L["Output Audio Device"] = "Output Audio Device"
L["Active Output Audio Device"] = "Active Output Audio Device"
L["Volume Streams"] = "Volume Streams"
L["Left Click: Select Volume Stream"] = "Left Click: Select Volume Stream"
L["Middle Click: Toggle Mute Master Stream"] = "Middle Click: Toggle Mute Master Stream"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + Middle Click: Toggle Volume Stream"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + Left Click: Open System Audio Panel"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + Right Click: Select Output Audio Device"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Guild"
L["No Guild"] = "No Guild"
L["Friends: "] = "Friends: "
L["<Mobile>"] = "<Mobile>"
L["Hints [|cffffffffBlock|r]"] = "Hints [|cffffffffBlock|r]"
L["|cffff8020Click|r to open panel."] = "|cffff8020Click|r to open panel."
L["|cffff8020RightClick|r to display config menu."] = "|cffff8020RightClick|r to display config menu."
L["|cffff8020MiddleClick|r to add a friend."] = "|cffff8020MiddleClick|r to add a friend."
L["|cffff8020Modifier+Click|r to add a friend."] = "|cffff8020Modifier+Click|r to add a friend."
L["|cffff8020Button4|r to toggle notes."] = "|cffff8020Button4|r to toggle notes."
L["Hints"] = "Hints"
L["|cffff8020Click|r to whisper."] = "|cffff8020Click|r to whisper."
L["|cffff8020Alt+Click|r to invite."] = "|cffff8020Alt+Click|r to invite."
L["|cffff8020Shift+Click|r to query informations."] = "|cffff8020Shift+Click|r to query informations."
L["|cffff8020Ctrl+Click|r to edit note."] = "|cffff8020Ctrl+Click|r to edit note."
L["|cffff8020Ctrl+RightClick|r to edit officer note."] = "|cffff8020Ctrl+RightClick|r to edit officer note."
L["|cffff8020MiddleClick|r to remove friend."] = "|cffff8020MiddleClick|r to remove friend."
L["|cffff8020RightClick|r to sort main column."] = "|cffff8020RightClick|r to sort main column."
L["|cffff8020Shift+RightClick|r to sort second column."] = "|cffff8020Shift+RightClick|r to sort second column."
L["|cffff8020Alt+RightClick|r to sort third column."] = "|cffff8020Alt+RightClick|r to sort third column."
L["|cffff8020Ctrl+MouseWheel|r to resize tooltip."] = "|cffff8020Ctrl+MouseWheel|r to resize tooltip."
L["Mobile App"] = "Mobile App"
L["Desktop App"] = "Desktop App"
L["OFFLINE FAVORITE"] = "OFFLINE FAVORITE"
L["MOTD"] = "MOTD"
L["No friends online."] = "No friends online."
L["Broadcast"] = "Broadcast"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Invalid scale.\nShould be a number between 70 and 200%"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."
L["|cffffb366Ara|r Guild & Friends (%s)"] = "|cffffb366Ara|r Guild & Friends (%s)"
L["Show guild name"] = "Show guild name"
L["Show 'Guild' tag"] = "Show 'Guild' tag"
L["Show total number of guildmates"] = "Show total number of guildmates"
L["Show 'Friends' tag"] = "Show 'Friends' tag"
L["Show total number of friends"] = "Show total number of friends"
L["Show guild XP"] = "Show guild XP"
L["Show guild XP tooltip"] = "Show guild XP tooltip"
L["Show own broadcast"] = "Show own broadcast"
L["Show bnet friends broadcast"] = "Show bnet friends broadcast"
L["Show guild notes"] = "Show guild notes"
L["Show friend notes"] = "Show friend notes"
L["Show class icon when grouped"] = "Show class icon when grouped"
L["Highlight sorted column"] = "Highlight sorted column"
L["Simple"] = "Simple"
L["Gradient"] = "Gradient"
L["Reverse gradient"] = "Reverse gradient"
L["Status as..."] = "Status as..."
L["Class colored text"] = "Class colored text"
L["Custom colored text"] = "Custom colored text"
L["Icon"] = "Icon"
L["Real ID..."] = "Real ID..."
L["Before nickname"] = "Before nickname"
L["Instead of nickname"] = "Instead of nickname"
L["After nickname"] = "After nickname"
L["Don't show"] = "Don't show"
L["Column alignments"] = "Column alignments"
L["Name"] = "Name"
L["Zone"] = "Zone"
L["Notes"] = "Notes"
L["Rank"] = "Rank"
L["Tooltip Size"] = "Tooltip Size"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Custom..."
L["Use TipTac skin (requires TipTac)"] = "Use TipTac skin (requires TipTac)"
L["Colors"] = "Colors"
L["Background"] = "Background"
L["Borders"] = "Borders"
L["Order highlight"] = "Order highlight"
L["Headers"] = "Headers"
L["MotD / broadcast"] = "MotD / broadcast"
L["Friendly zone"] = "Friendly zone"
L["Contested zone"] = "Contested zone"
L["Enemy zone"] = "Enemy zone"
L["Officer notes"] = "Officer notes"
L["Status"] = "Status"
L["Ranks"] = "Ranks"
L["Friends broadcast"] = "Friends broadcast"
L["Realms"] = "Realms"
L["|cffaaaaffRestore default colors"] = "|cffaaaaffRestore default colors"
L["Show Block Hints"] = "Show Block Hints"
L["Open panel"] = "Open panel"
L["Config menu"] = "Config menu"
L["Toggle notes"] = "Toggle notes"
L["Add a friend"] = "Add a friend"
L["Show Hints"] = "Show Hints"
L["Whisper"] = "Whisper"
L["Invite"] = "Invite"
L["Query"] = "Query"
L["Edit note"] = "Edit note"
L["Edit officer note"] = "Edit officer note"
L["Sort main column"] = "Sort main column"
L["Sort second column"] = "Sort second column"
L["Sort third column"] = "Sort third column"
L["Resize tooltip"] = "Resize tooltip"
L["Remove friend"] = "Remove friend"

