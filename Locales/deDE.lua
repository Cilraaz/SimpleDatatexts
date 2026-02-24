local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "deDE" then
    return
end

-- ----------------------------
-- Global
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(leer)"
L["(spacer)"] = "(Abstand)"
L["Display Font:"] = "Schriftart:"
L["Font Settings"] = "Schrifteinstellungen"
L["Font Size"] = "Schriftgröße"
L["Font Outline"] = "Schriftkontur"
L["GOLD"] = "GOLD"
L["Override Global Font"] = "Globale Schriftart überschreiben"
L["Override Text Color"] = "Textfarbe überschreiben"
L["Settings"] = "Einstellungen"
L["Frame Strata"] = "Frame-Ebene"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "Legt die Frame-Ebene (Schicht) für dieses Modul fest. Höhere Werte erscheinen über niedrigeren Werten."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "Legt die Frame-Ebene (Schicht) für dieses Panel fest. Module erscheinen relativ dazu. Höhere Werte erscheinen über niedrigeren Werten."
L["Slot Controls"] = "Slot-Steuerung"
L["Anchor Point"] = "Ankerpunkt"
L["Set the anchor point for this module."] = "Legt den Ankerpunkt für dieses Modul fest."
L["Yes"] = "Ja"
L["No"] = "Nein"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "Debug-Modus deaktiviert"
L["Debug Mode Enabled"] = "Debug-Modus aktiviert"
L["Left Click to open settings"] = "Linksklick zum Öffnen der Einstellungen"
L["Lock/Unlock"] = "Sperren/Entsperren"
L["Minimap Icon Disabled"] = "Minikartensymbol deaktiviert"
L["Minimap Icon Enabled"] = "Minikartensymbol aktiviert"
L["Not Defined"] = "Nicht definiert"
L["Toggle Minimap Icon"] = "Minikartensymbol umschalten"
L["Usage"] = "Verwendung"
L["Version"] = "Version"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "Fehler beim Komprimieren der Profildaten"
L["Error decoding import string"] = "Fehler beim Dekodieren der Importzeichenfolge"
L["Error decompressing data"] = "Fehler beim Dekomprimieren der Daten"
L["Error deserializing profile data"] = "Fehler beim Deserialisieren der Profildaten"
L["Error serializing profile data"] = "Fehler beim Serialisieren der Profildaten"
L["Import data too large"] = "Importdaten zu groß"
L["Import data too large after decompression"] = "Importdaten nach Dekomprimierung zu groß"
L["Import string is too large"] = "Import-Zeichenfolge ist zu groß"
L["Importing profile from version %s"] = "Importiere Profil von Version %s"
L["Invalid import string format"] = "Ungültiges Import-Zeichenfolgenformat"
L["Invalid profile data"] = "Ungültige Profildaten"
L["Migrating old settings to new profile system..."] = "Alte Einstellungen werden auf das neue Profilsystem migriert..."
L["Migration complete! All profiles have been migrated."] = "Migration abgeschlossen! Alle Profile wurden migriert."
L["No import string provided"] = "Keine Importzeichenfolge angegeben"
L["Profile imported successfully!"] = "Profil erfolgreich importiert!"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "Farben"
L["Custom Color"] = "Benutzerdefinierte Farbe"
L["Enable Per-Spec Profiles"] = "Profile pro Spezialisierung aktivieren"
L["Global"] = "Global"
L["Global Settings"] = "Globale Einstellungen"
L["Hide Module Title in Tooltip"] = "Modultitel im Tooltip ausblenden"
L["Lock Panels"] = "Panels sperren"
L["Prevent panels from being moved"] = "Verhindert das Verschieben der Panels"
L["Show Login Message"] = "Login-Nachricht anzeigen"
L["Show Minimap Icon"] = "Minikartensymbol anzeigen"
L["Toggle the minimap button on or off"] = "Minikartensymbol ein-/ausschalten"
L["Use 24Hr Clock"] = "24-Stunden-Uhr verwenden"
L["Use Class Color"] = "Klassenfarbe verwenden"
L["Use Custom Color"] = "Benutzerdefinierte Farbe verwenden"
L["X Offset"] = "X-Versatz"
L["Y Offset"] = "Y-Versatz"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "Wenn aktiviert, wechselt das Addon automatisch zu einem anderen Profil, jedes Mal, wenn du die Spezialisierung änderst. Wähle unten, welches Profil jede Spezialisierung verwenden soll."
L["Enable Font Text Shadow"] = "Schrift-Textschatten aktivieren"
L["Add a subtle shadow to datatexts for better readability"] = "Fügt einen dezenten Schatten zu Datentexten für bessere Lesbarkeit hinzu"
L["Enable Tooltip Text Shadow"] = "Tooltip-Textschatten aktivieren"
L["Add a subtle shadow to tooltip text for better readability"] = "Fügt einen dezenten Schatten zum Tooltip-Text für bessere Lesbarkeit hinzu"
L["Tooltip Settings"] = "Tooltip-Einstellungen"
L["Tooltip Font"] = "Tooltip-Schriftart"
L["Font used for all addon tooltips"] = "Schriftart für alle Addon-Tooltips"
L["Tooltip Font Outline"] = "Tooltip-Schriftkontur"
L["Font outline for all addon tooltips"] = "Schriftkontur für alle Addon-Tooltips"
L["Tooltip Header Font Size"] = "Tooltip-Überschrift Schriftgröße"
L["Font size for tooltip headers"] = "Schriftgröße für Tooltip-Überschriften"
L["Tooltip Line Font Size"] = "Tooltip-Zeile Schriftgröße"
L["Font size for tooltip content lines"] = "Schriftgröße für Tooltip-Inhaltszeilen"
L["Show All Panels"] = "Alle Panels anzeigen"
L["Toggle visibility of all panels. Individual panels can also be hidden in their own settings."] = "Sichtbarkeit aller Panels umschalten. Einzelne Panels können auch in ihren eigenen Einstellungen ausgeblendet werden."
L["Panels shown"] = "Panels eingeblendet"
L["Panels hidden"] = "Panels ausgeblendet"
L["Toggle All Panels"] = "Alle Panels umschalten"

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "Aussehen"
L["Apply Slot Changes"] = "Slot-Änderungen übernehmen"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Bist du sicher, dass du diese Leiste löschen möchtest?\nDiese Aktion kann nicht rückgängig gemacht werden."
L["Background Opacity"] = "Hintergrund-Transparenz"
L["Border Color"] = "Rahmenfarbe"
L["Border Size"] = "Rahmengröße"
L["Create New Panel"] = "Neues Panel erstellen"
L["Height"] = "Höhe"
L["Number of Slots"] = "Anzahl der Slots"
L["Panel Settings"] = "Panel-Einstellungen"
L["Panels"] = "Panels"
L["Remove Selected Panel"] = "Ausgewähltes Panel entfernen"
L["Rename Panel:"] = "Panel umbenennen:"
L["Scale"] = "Skalierung"
L["Select Border:"] = "Rahmen auswählen:"
L["Select Panel:"] = "Panel auswählen:"
L["Size & Scale"] = "Größe & Skalierung"
L["Slot Assignments"] = "Slot-Zuweisungen"
L["Slot %d:"] = "Slot %d:"
L["Slots"] = "Slots"
L["Update slot assignment dropdowns after changing number of slots"] = "Dropdowns nach Änderung der Slot-Anzahl aktualisieren"
L["Width"] = "Breite"
L["Hide Panel"] = "Panel ausblenden"
L["Hide this panel. Panels are always visible while unlocked."] = "Dieses Panel ausblenden. Panels sind immer sichtbar, wenn sie entsperrt sind."

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "Moduleinstellungen"
L["Hide Decimals"] = "Dezimalstellen ausblenden"
L["Show Label"] = "Bezeichnung anzeigen"
L["Show Short Label"] = "Kurze Bezeichnung anzeigen"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. Klicke oben auf 'Export-String generieren'\n2. Klicke in dieses Feld\n3. Drücke Strg+A um alles auszuwählen\n4. Drücke Strg+C um zu kopieren"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. Füge einen Import-String in das Feld unten ein\n2. Klicke auf Akzeptieren\n3. Klicke auf 'Profil importieren'"
L["Create an export string for your current profile"] = "Erstelle einen Export-String für dein aktuelles Profil"
L["Export"] = "Exportieren"
L["Export String"] = "Export-String"
L["Export string generated! Copy it from the box below."] = "Export-String erstellt! Kopiere ihn aus dem Feld unten."
L["Export your current profile to share with others, or import a profile string.\n"] = "Exportiere dein aktuelles Profil, um es zu teilen, oder importiere einen Profil-String.\n"
L["Generate Export String"] = "Export-String generieren"
L["Import"] = "Importieren"
L["Import/Export"] = "Import/Export"
L["Import Profile"] = "Profil importieren"
L["Import String"] = "Import-String"
L["Import the profile string from above (after clicking Accept)"] = "Importiere den Profil-String von oben (nach Klick auf Akzeptieren)"
L["Please paste an import string and click Accept first"] = "Bitte zuerst einen Import-String einfügen und Akzeptieren klicken"
L["Profile Import/Export"] = "Profil Import/Export"
L["This will overwrite your current profile. Are you sure?"] = "Dies überschreibt dein aktuelles Profil. Bist du sicher?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "Paneele gesperrt"
L["Panels unlocked"] = "Paneele entsperrt"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "Agi"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Schadensminderung nach Stufe:"
L["Level %d"] = "Stufe %d"
L["Target Mitigation"] = "Ziel-Schadensminderung"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "AP"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Taschen"

-- ----------------------------
-- modules/CombatTimer.lua
-- ----------------------------
L["Combat"] = "Kampf"
L["combat duration"] = "Kampfdauer"
L["Combat Timer"] = "Kampftimer"
L["Current"] = "Aktuell"
L["Currently out of combat"] = "Derzeit nicht im Kampf"
L["Display Duration"] = "Anzeigedauer"
L["Enter combat to start tracking"] = "Kampf beginnen, um die Verfolgung zu starten"
L["Last"] = "Letzter"
L["Left-click"] = "Linksklick"
L["Out of Combat"] = "Nicht im Kampf"
L["to reset"] = "zum Zurücksetzen"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "Krit"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "WÄHRUNGEN"
L["Tracked Currency Qty"] = "Verfolgte Währung Menge"
L["Currency Display Order"] = "Währung Anzeigereihenfolge"
L["Position %d"] = "Position %d"
L["Empty Slot"] = "Leerer Slot"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "Dauer:"
L["Durability:"] = "Haltbarkeit:"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "Maximale Stufe"
L["N/A"] = "N/V"
L["Experience"] = "Erfahrung"
L["Display Format"] = "Anzeigeformat"
L["Bar Toggles"] = "Leistenoptionen"
L["Show Graphical Bar"] = "Grafische Leiste anzeigen"
L["Hide Blizzard XP Bar"] = "Blizzard-EP-Leiste ausblenden"
L["Bar Appearance"] = "Leistenaussehen"
L["Bar Height (%)"] = "Leistenhöhe (%)"
L["Bar Use Class Color"] = "Klassenfarbe für Leiste verwenden"
L["Bar Custom Color"] = "Benutzerdefinierte Leistenfarbe"
L["Bar Texture"] = "Leistenstruktur"
L["Text Color"] = "Textfarbe"
L["Text Use Class Color"] = "Klassenfarbe für Text verwenden"
L["Text Custom Color"] = "Benutzerdefinierte Textfarbe"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Ara Friends LDB Objekt nicht gefunden! SDT Friends Datatext deaktiviert."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "Silber anzeigen"
L["Show Copper"] = "Kupfer anzeigen"
L["Use Coin Icons"] = "Münzsymbole verwenden"
L["Display Quantities"] = "Mengen anzeigen"
L["Characters to Show"] = "Anzuzeigende Charaktere"
L["Servers to Show"] = "Anzuzeigende Server"
L["Session:"] = "Sitzung:"
L["Earned:"] = "Erhalten:"
L["Spent:"] = "Ausgegeben:"
L["Profit:"] = "Gewinn:"
L["Deficit:"] = "Defizit:"
L["Character:"] = "Charakter:"
L["Server:"] = "Server:"
L["Faction:"] = "Fraktion:"
L["Alliance:"] = "Allianz:"
L["Horde:"] = "Horde:"
L["Total:"] = "Gesamt:"
L["Warband:"] = "Kriegstrupp:"
L["WoW Token:"] = "WoW Token:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Sitzungsdaten zurücksetzen: Halte Strg + Rechtsklick"
L["Gold: All data reset!"] = "Gold: Alle Daten zurückgesetzt!"
L["Gold: Data reset for %s!"] = "Gold: Daten für %s zurückgesetzt!"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "Möchten Sie wirklich die Golddaten löschen für:\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000ALLE CHARAKTERE|r"
L["|cFF808080No character data found|r"] = "|cFF808080Keine Charakterdaten gefunden|r"
L["Reset Session Data:"] = "Sitzungsdaten zurücksetzen:"
L["Hold Shift + Right Click"] = "Umschalt + Rechtsklick halten"
L["Reset Character Gold Data:"] = "Charakter-Golddaten zurücksetzen:"
L["Hold Alt + Right Click"] = "Alt + Rechtsklick halten"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Ara Guild LDB Objekt nicht gefunden! SDT Guild Datatext deaktiviert."
L["Max Guild Name Length"] = "Max. Gildennamen-Länge"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "Tempotwertung:"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "Ruhestein"
L["Selected Hearthstone"] = "Ausgewählter Ruhestein"
L["Random"] = "Zufällig"
L["Selected:"] = "Ausgewählt:"
L["Available Hearthstones:"] = "Verfügbare Ruhesteine:"
L["Left Click: Use Hearthstone"] = "Linksklick: Ruhestein benutzen"
L["Right Click: Select Hearthstone"] = "Rechtsklick: Ruhestein auswählen"
L["Cannot use hearthstone while in combat"] = "Ruhestein kann nicht im Kampf benutzt werden"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "Int"

-- ----------------------------
-- modules/ItemLevel.lua
-- ----------------------------
L["Item Level"] = "Gegenstandsstufe"
L["ilvl"] = "iLvl"
L["Equipped Item Level"] = "Ausgerüstete Gegenstandsstufe"
L["Maximum Item Level"] = "Maximale Gegenstandsstufe"
L["Show Max Item Level"] = "Max. Gegenstandsstufe anzeigen"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "KEIN TEXT"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "Neue Nachricht"
L["No Mail"] = "Keine Nachricht"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "Kartenname"
L["Zone Name"] = "Zonenname"
L["Subzone Name"] = "Unterzonenname"
L["Zone - Subzone"] = "Zone - Unterzone"
L["Zone / Subzone (Two Lines)"] = "Zone / Unterzone (Zwei Zeilen)"
L["Minimap Zone"] = "Minimap-Zone"
L["Show Zone on Tooltip"] = "Zone im Tooltip anzeigen"
L["Show Coordinates on Tooltip"] = "Koordinaten im Tooltip anzeigen"
L["Zone:"] = "Zone:"
L["Subzone:"] = "Unterzone:"
L["Coordinates:"] = "Koordinaten:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "Meisterschaft:"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "Mythisch+ Schlüsselstein"
L["No Mythic+ Keystone"] = "Kein Mythisch+ Schlüsselstein"
L["Current Key:"] = "Aktueller Schlüssel:"
L["Dungeon Teleport is on cooldown for "] = "Dungeon-Teleport ist noch "
L[" more seconds."] = " Sekunden im Cooldown."
L["You do not know the teleport spell for "] = "Du kennst den Teleportzauber für "
L["Key: "] = "Schlüssel: "
L["None"] = "Keiner"
L["No Key"] = "Kein Schlüssel"
L["Left Click: Teleport to Dungeon"] = "Linksklick: Zum Dungeon teleportieren"
L["Right Click: List Group in Finder"] = "Rechtsklick: Gruppe im Finder einstellen"

-- ----------------------------
-- modules/Quests.lua
-- ----------------------------
L["Quests"] = "Quests"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Aktiv"
L["Inactive"] = "Inaktiv"
L["Loadouts"] = "Loadouts"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Fehler beim Laden von Blizzard_PlayerSpells: %s"
L["Starter Build"] = "Starter-Build"
L["Spec"] = "Spez."
L["Left Click: Change Talent Specialization"] = "Linksklick: Talentspezialisierung ändern"
L["Control + Left Click: Change Loadout"] = "Strg + Linksklick: Loadout ändern"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + Linksklick: Talentspezialisierungs-UI öffnen"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + Rechtsklick: Beutespezialisierung ändern"
L["Show Specialization Icon"] = "Spezialisierungssymbol anzeigen"
L["Show Specialization Text"] = "Spezialisierungstext anzeigen"
L["Show Loot Specialization Icon"] = "Beutespezialisierungssymbol anzeigen"
L["Show Loot Specialization Text"] = "Beutespezialisierungstext anzeigen"
L["Show Loot Spec When Current"] = "Beutespezialisierung bei 'Aktuell' anzeigen"
L["Show Loadout"] = "Ausrüstung anzeigen"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "Geschwindigkeit: "

-- ----------------------------
-- modules/Stagger.lua
-- ----------------------------
L["Stagger Amount:"] = "Staffelungsmenge:"

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "Str"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "mb"
L["KB_SUFFIX"] = "kb"
L["SYSTEM"] = "SYSTEM"
L["FPS:"] = "FPS:"
L["Home Latency:"] = "Heimat-Latenz:"
L["World Latency:"] = "Welt-Latenz:"
L["Total Memory:"] = "Gesamtspeicher:"
L["(Shift Click) Collect Garbage"] = "(Shift-Klick) Speicher freigeben"
L["FPS"] = "FPS"
L["MS"] = "MS"
L["Top Addons by Memory:"] = "Top-Addons nach Speicher:"
L["Top Addons in Tooltip"] = "Top-Addons im Tooltip"
L["Total CPU:"] = "Gesamte CPU:"
L["Top Addons by CPU:"] = "Top-Addons nach CPU:"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "ZEIT"
L["Saved Raid(s)"] = "Gespeicherte Raids"
L["Saved Dungeon(s)"] = "Gespeicherte Dungeons"
L["Display Realm Time"] = "Realmzeit anzeigen"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "Vielseitig:"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Audiostream auswählen"
L["Toggle Volume Stream"] = "Audiostream umschalten"
L["Output Audio Device"] = "Ausgabegerät"
L["Active Output Audio Device"] = "Aktives Ausgabegerät"
L["Volume Streams"] = "Audiostreams"
L["Left Click: Select Volume Stream"] = "Linksklick: Audiostream auswählen"
L["Middle Click: Toggle Mute Master Stream"] = "Mittelklick: Masterstream stummschalten"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + Mittelklick: Audiostream umschalten"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + Linksklick: System-Audio-Panel öffnen"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + Rechtsklick: Ausgabegerät auswählen"
L["M. Vol"] = "Haupt"
L["FX"] = "Eff"
L["Amb"] = "Umg"
L["Dlg"] = "Dlg"
L["Mus"] = "Mus"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Gilde"
L["No Guild"] = "Keine Gilde"
L["Friends"] = "Freunde"
L["<Mobile>"] = "<Mobil>"
L["Hints"] = "Hinweise"
L["Block"] = "Blockieren"
L["Click"] = "Klick"
L["RightClick"] = "Rechtsklick"
L["MiddleClick"] = "Mittelklick"
L["Modifier+Click"] = "Modifikator+Klick"
L["Shift+Click"] = "Shift+Klick"
L["Shift+RightClick"] = "Shift+Rechtsklick"
L["Ctrl+Click"] = "Strg+Klick"
L["Ctrl+RightClick"] = "Strg+Rechtsklick"
L["Alt+RightClick"] = "Alt+Rechtsklick"
L["Ctrl+MouseWheel"] = "Strg+Mausrad"
L["Button4"] = "Taste4"
L["to open panel."] = "um Panel zu öffnen."
L["to display config menu."] = "um das Konfigurationsmenü zu öffnen."
L["to add a friend."] = "um einen Freund hinzuzufügen."
L["to toggle notes."] = "um Notizen umzuschalten."
L["to whisper."] = "um zu flüstern."
L["to invite."] = "um einzuladen."
L["to query information."] = "um Informationen abzufragen."
L["to edit note."] = "um Notiz zu bearbeiten."
L["to edit officer note."] = "um Offiziersnotiz zu bearbeiten."
L["to remove friend."] = "um Freund zu entfernen."
L["to sort main column."] = "um die Hauptspalte zu sortieren."
L["to sort second column."] = "um die zweite Spalte zu sortieren."
L["to sort third column."] = "um die dritte Spalte zu sortieren."
L["to resize tooltip."] = "um Tooltip zu skalieren."
L["Mobile App"] = "Mobile App"
L["Desktop App"] = "Desktop App"
L["OFFLINE FAVORITE"] = "OFFLINE FAVORIT"
L["MOTD"] = "MOTD"
L["No friends online."] = "Keine Freunde online."
L["Broadcast"] = "Broadcast"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Ungültige Skalierung.\nMuss zwischen 70 und 200% liegen."
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Benutzerdefinierte Tooltip-Skalierung setzen.\nWert zwischen 70 und 200 eingeben (%%)."
L["Guild & Friends"] = "Gilde & Freunde"
L["Show guild name"] = "Gildenname anzeigen"
L["Show 'Guild' tag"] = "'Gilde'-Tag anzeigen"
L["Show total number of guildmates"] = "Gesamtanzahl Gildenmitglieder anzeigen"
L["Show 'Friends' tag"] = "'Freunde'-Tag anzeigen"
L["Show total number of friends"] = "Gesamtanzahl Freunde anzeigen"
L["Show guild XP"] = "Gilden-XP anzeigen"
L["Show guild XP tooltip"] = "Gilden-XP Tooltip anzeigen"
L["Show own broadcast"] = "Eigenes Broadcast anzeigen"
L["Show bnet friends broadcast"] = "Broadcast von bnet-Freunden anzeigen"
L["Show guild notes"] = "Gilden-Notizen anzeigen"
L["Show friend notes"] = "Freundes-Notizen anzeigen"
L["Show class icon when grouped"] = "Klassen-Symbol in Gruppe anzeigen"
L["Highlight sorted column"] = "Sortierte Spalte hervorheben"
L["Simple"] = "Einfach"
L["Gradient"] = "Verlauf"
L["Reverse gradient"] = "Verlauf umkehren"
L["Status as..."] = "Status als..."
L["Class colored text"] = "Klassenfarbiger Text"
L["Custom colored text"] = "Eigene Farbe"
L["Icon"] = "Symbol"
L["Real ID..."] = "Real ID..."
L["Before nickname"] = "Vor dem Spitznamen"
L["Instead of nickname"] = "Statt Spitznamen"
L["After nickname"] = "Nach dem Spitznamen"
L["Don't show"] = "Nicht anzeigen"
L["Column alignments"] = "Spaltenausrichtung"
L["Name"] = "Name"
L["Zone"] = "Zone"
L["Notes"] = "Notizen"
L["Rank"] = "Rang"
L["Tooltip Size"] = "Tooltip-Größe"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Benutzerdefiniert..."
L["Use TipTac skin (requires TipTac)"] = "TipTac Skin verwenden (benötigt TipTac)"
L["Colors"] = "Farben"
L["Background"] = "Hintergrund"
L["Borders"] = "Ränder"
L["Order highlight"] = "Reihenfolge hervorheben"
L["Headers"] = "Überschriften"
L["MotD / broadcast"] = "MotD / Broadcast"
L["Friendly zone"] = "Freundliche Zone"
L["Contested zone"] = "Umstrittene Zone"
L["Enemy zone"] = "Feindliche Zone"
L["Officer notes"] = "Offiziersnotizen"
L["Status"] = "Status"
L["Ranks"] = "Ränge"
L["Friends broadcast"] = "Freundes-Broadcast"
L["Realms"] = "Server"
L["Restore default colors"] = "Standardfarben wiederherstellen"
L["Show Block Hints"] = "Block-Hinweise anzeigen"
L["Open panel"] = "Panel öffnen"
L["Config menu"] = "Konfigurationsmenü"
L["Toggle notes"] = "Notizen umschalten"
L["Add a friend"] = "Freund hinzufügen"
L["Show Hints"] = "Hinweise anzeigen"
L["Whisper"] = "Flüstern"
L["Invite"] = "Einladen"
L["Query"] = "Abfragen"
L["Edit note"] = "Notiz bearbeiten"
L["Edit officer note"] = "Offiziersnotiz bearbeiten"
L["Sort main column"] = "Hauptspalte sortieren"
L["Sort second column"] = "Zweite Spalte sortieren"
L["Sort third column"] = "Dritte Spalte sortieren"
L["Resize tooltip"] = "Tooltip skalieren"
L["Remove friend"] = "Freund entfernen"
