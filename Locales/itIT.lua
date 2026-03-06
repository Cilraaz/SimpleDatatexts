local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "itIT" then
    return
end

-- ----------------------------
-- Global
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(vuoto)"
L["(spacer)"] = "(spazio)"
L["Display Font:"] = "Font:"
L["Font Settings"] = "Impostazioni Font"
L["Font Size"] = "Dimensione Font"
L["Font Outline"] = "Contorno Font"
L["GOLD"] = "ORO"
L["Override Global Font"] = "Sostituisci carattere globale"
L["Override Text Color"] = "Sostituisci colore testo"
L["Settings"] = "Impostazioni"
L["Frame Strata"] = "Strato del frame"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "Imposta lo strato del frame (livello) per questo modulo. I valori più alti appaiono sopra i valori più bassi."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "Imposta lo strato del frame (livello) per questo pannello. I moduli appariranno relativamente a questo. I valori più alti appaiono sopra i valori più bassi."
L["Slot Controls"] = "Controlli Slot"
L["Anchor Point"] = "Punto di Ancoraggio"
L["Set the anchor point for this module."] = "Imposta il punto di ancoraggio per questo modulo."
L["Yes"] = "Sì"
L["No"] = "No"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "Modalità debug disabilitata"
L["Debug Mode Enabled"] = "Modalità debug abilitata"
L["Left Click to open settings"] = "Clic sinistro per aprire le impostazioni"
L["Lock/Unlock"] = "Blocca/Sblocca"
L["Minimap Icon Disabled"] = "Icona della minimappa disattivata"
L["Minimap Icon Enabled"] = "Icona della minimappa attivata"
L["Not Defined"] = "Non definito"
L["Toggle Minimap Icon"] = "Attiva/disattiva icona minimappa"
L["Usage"] = "Uso"
L["Version"] = "Versione"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "Errore durante la compressione dei dati del profilo"
L["Error decoding import string"] = "Errore durante la decodifica della stringa di importazione"
L["Error decompressing data"] = "Errore durante la decompressione dei dati"
L["Error deserializing profile data"] = "Errore durante la deserializzazione dei dati del profilo"
L["Error serializing profile data"] = "Errore durante la serializzazione dei dati del profilo"
L["Import data too large"] = "Dati di importazione troppo grandi"
L["Import data too large after decompression"] = "Dati di importazione troppo grandi dopo la decompressione"
L["Import string is too large"] = "La stringa di importazione è troppo grande"
L["Importing profile from version %s"] = "Importazione del profilo dalla versione %s"
L["Invalid import string format"] = "Formato della stringa di importazione non valido"
L["Invalid profile data"] = "Dati del profilo non validi"
L["Migrating old settings to new profile system..."] = "Migrazione delle vecchie impostazioni nel nuovo sistema di profili..."
L["Migration complete! All profiles have been migrated."] = "Migrazione completata! Tutti i profili sono stati migrati."
L["No import string provided"] = "Nessuna stringa di importazione fornita"
L["Profile imported successfully!"] = "Profilo importato con successo!"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "Colori"
L["Custom Color"] = "Colore Personalizzato"
L["Enable Per-Spec Profiles"] = "Abilita profili per specializzazione"
L["Global"] = "Globale"
L["Global Settings"] = "Impostazioni Globali"
L["Hide Module Title in Tooltip"] = "Nascondi titolo modulo nel tooltip"
L["Lock Panels"] = "Blocca Pannelli"
L["Prevent panels from being moved"] = "Impedisci lo spostamento dei pannelli"
L["Show Login Message"] = "Mostra messaggio login"
L["Show Minimap Icon"] = "Mostra icona minimappa"
L["Toggle the minimap button on or off"] = "Attiva/disattiva icona minimappa"
L["Use 24Hr Clock"] = "Usa orologio 24h"
L["Use Class Color"] = "Usa colore classe"
L["Use Custom Color"] = "Usa colore personalizzato"
L["X Offset"] = "Offset X"
L["Y Offset"] = "Offset Y"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "Quando abilitato, l'addon passerà automaticamente a un profilo diverso ogni volta che cambi specializzazione. Scegli qui sotto quale profilo usare per ciascuna specializzazione."
L["Enable Font Text Shadow"] = "Abilita ombra testo carattere"
L["Add a subtle shadow to datatexts for better readability"] = "Aggiunge un'ombra sottile ai testi dati per una migliore leggibilità"
L["Enable Tooltip Text Shadow"] = "Abilita ombra testo"
L["Add a subtle shadow to tooltip text for better readability"] = "Aggiunge un'ombra sottile al testo per una migliore leggibilità"
L["Tooltip Settings"] = "Impostazioni suggerimenti"
L["Tooltip Font"] = "Carattere suggerimenti"
L["Font used for all addon tooltips"] = "Carattere utilizzato per tutti i suggerimenti dell'addon"
L["Tooltip Font Outline"] = "Contorno carattere suggerimenti"
L["Font outline for all addon tooltips"] = "Contorno carattere per tutti i suggerimenti dell'addon"
L["Tooltip Header Font Size"] = "Dimensione carattere intestazione"
L["Font size for tooltip headers"] = "Dimensione carattere per intestazioni suggerimenti"
L["Tooltip Line Font Size"] = "Dimensione carattere riga"
L["Font size for tooltip content lines"] = "Dimensione carattere per righe di contenuto"
L["Show All Panels"] = "Mostra tutti i pannelli"
L["Toggle visibility of all panels. Individual panels can also be hidden in their own settings."] = "Attiva/disattiva la visibilità di tutti i pannelli. I singoli pannelli possono anche essere nascosti nelle loro impostazioni."
L["Panels shown"] = "Pannelli mostrati"
L["Panels hidden"] = "Pannelli nascosti"
L["Toggle All Panels"] = "Attiva/disattiva tutti i pannelli"

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "Aspetto"
L["Apply Slot Changes"] = "Applica modifiche slot"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Sei sicuro di voler eliminare questa barra?\nQuesta azione non può essere annullata."
L["Background Opacity"] = "Opacità sfondo"
L["Border Color"] = "Colore bordo"
L["Border Size"] = "Dimensione bordo"
L["Create New Panel"] = "Crea nuovo pannello"
L["Height"] = "Altezza"
L["Number of Slots"] = "Numero di slot"
L["Panel Settings"] = "Impostazioni pannello"
L["Panels"] = "Pannelli"
L["Remove Selected Panel"] = "Rimuovi pannello selezionato"
L["Rename Panel:"] = "Rinomina pannello:"
L["Scale"] = "Scala"
L["Select Border:"] = "Seleziona bordo:"
L["Select Panel:"] = "Seleziona pannello:"
L["Size & Scale"] = "Dimensione & Scala"
L["Slot Assignments"] = "Assegnazioni slot"
L["Slot %d:"] = "Slot %d:"
L["Slots"] = "Slot"
L["Update slot assignment dropdowns after changing number of slots"] = "Aggiorna i menu a tendina degli slot dopo aver cambiato il numero di slot"
L["Width"] = "Larghezza"
L["Hide Panel"] = "Nascondi pannello"
L["Hide this panel. Panels are always visible while unlocked."] = "Nascondi questo pannello. I pannelli sono sempre visibili quando sono sbloccati."

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "Impostazioni Modulo"
L["Hide Decimals"] = "Nascondi decimali"
L["Show Label"] = "Mostra etichetta"
L["Show Short Label"] = "Mostra etichetta breve"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. Clicca su 'Genera stringa di esportazione' sopra\n2. Clicca in questa casella\n3. Premi Ctrl+A per selezionare tutto\n4. Premi Ctrl+C per copiare"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. Incolla una stringa di importazione nella casella sottostante\n2. Clicca Accetta\n3. Clicca 'Importa Profilo'"
L["Create an export string for your current profile"] = "Crea una stringa di esportazione per il tuo profilo attuale"
L["Export"] = "Esporta"
L["Export String"] = "Stringa di esportazione"
L["Export string generated! Copy it from the box below."] = "Stringa di esportazione generata! Copiala dalla casella sottostante."
L["Export your current profile to share with others, or import a profile string.\n"] = "Esporta il tuo profilo attuale per condividerlo o importa una stringa di profilo.\n"
L["Generate Export String"] = "Genera stringa di esportazione"
L["Import"] = "Importa"
L["Import/Export"] = "Importa/Esporta"
L["Import Profile"] = "Importa Profilo"
L["Import String"] = "Stringa di importazione"
L["Import the profile string from above (after clicking Accept)"] = "Importa la stringa di profilo da sopra (dopo aver cliccato Accetta)"
L["Please paste an import string and click Accept first"] = "Incolla prima una stringa di importazione e clicca Accetta"
L["Profile Import/Export"] = "Importa/Esporta Profilo"
L["This will overwrite your current profile. Are you sure?"] = "Questo sovrascriverà il tuo profilo attuale. Sei sicuro?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "Pannelli bloccati"
L["Panels unlocked"] = "Pannelli sbloccati"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "Agi"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Mitigazione per livello:"
L["Level %d"] = "Livello %d"
L["Target Mitigation"] = "Mitigazione bersaglio"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "AP"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Borse"

-- ----------------------------
-- modules/CombatTimer.lua
-- ----------------------------
L["Combat"] = "Combattimento"
L["combat duration"] = "durata del combattimento"
L["Combat Timer"] = "Timer di Combattimento"
L["Current"] = "Attuale"
L["Currently out of combat"] = "Attualmente fuori dal combattimento"
L["Display Duration"] = "Durata visualizzazione"
L["Enter combat to start tracking"] = "Entra in combattimento per iniziare il monitoraggio"
L["Last"] = "Ultimo"
L["Left-click"] = "Clic sinistro"
L["Out of Combat"] = "Fuori dal combattimento"
L["to reset"] = "per reimpostare"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "Critico"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "VALUTE"
L["Tracked Currency Qty"] = "Qtà Valuta Tracciata"
L["Currency Display Order"] = "Ordine Visualizzazione Valuta"
L["Position %d"] = "Posizione %d"
L["Empty Slot"] = "Slot Vuoto"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "Dur:"
L["Durability:"] = "Durabilità:"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "Livello Massimo"
L["N/A"] = "N/D"
L["Experience"] = "Esperienza"
L["Display Format"] = "Formato visualizzazione"
L["Bar Toggles"] = "Opzioni barra"
L["Show Graphical Bar"] = "Mostra barra grafica"
L["Hide Blizzard XP Bar"] = "Nascondi barra EXP di Blizzard"
L["Bar Appearance"] = "Aspetto barra"
L["Bar Height (%)"] = "Altezza barra (%)"
L["Bar Use Class Color"] = "Usa colore classe per barra"
L["Bar Custom Color"] = "Colore personalizzato barra"
L["Bar Texture"] = "Struttura barra"
L["Text Color"] = "Colore del testo"
L["Text Use Class Color"] = "Usa colore classe per testo"
L["Text Custom Color"] = "Colore personalizzato testo"
L["Show Rested XP Bar"] = "Mostra barra XP di riposo"
L["Override Default Rested Color"] = "Sostituisci colore di riposo predefinito"
L["Rested Custom Color"] = "Colore personalizzato di riposo"
L["Rested:"] = "Riposato:"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Oggetto LDB Ara Friends non trovato! Datatext Amici SDT disabilitato."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "Mostra argento"
L["Show Copper"] = "Mostra rame"
L["Use Coin Icons"] = "Usa icone monete"
L["Display Quantities"] = "Mostra quantità"
L["Characters to Show"] = "Personaggi da mostrare"
L["Servers to Show"] = "Server da mostrare"
L["Session:"] = "Sessione:"
L["Earned:"] = "Guadagnato:"
L["Spent:"] = "Speso:"
L["Profit:"] = "Profitto:"
L["Deficit:"] = "Deficit:"
L["Character:"] = "Personaggio:"
L["Server:"] = "Server:"
L["Faction:"] = "Fazione:"
L["Alliance:"] = "Alleanza:"
L["Horde:"] = "Orda:"
L["Total:"] = "Totale:"
L["Warband:"] = "Branco di guerra:"
L["WoW Token:"] = "WoW Token:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Reimposta dati sessione: tieni Ctrl + clic destro"
L["Gold: All data reset!"] = "Oro: Tutti i dati ripristinati!"
L["Gold: Data reset for %s!"] = "Oro: Dati ripristinati per %s!"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "Sei sicuro di voler eliminare i dati dell'oro per:\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000TUTTI I PERSONAGGI|r"
L["|cFF808080No character data found|r"] = "|cFF808080Nessun dato personaggio trovato|r"
L["Reset Session Data:"] = "Ripristina dati sessione:"
L["Hold Shift + Right Click"] = "Tieni premuto Maiusc + Clic destro"
L["Reset Character Gold Data:"] = "Ripristina dati oro personaggio:"
L["Hold Alt + Right Click"] = "Tieni premuto Alt + Clic destro"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Oggetto LDB Ara Guild non trovato! Datatext Gilda SDT disabilitato."
L["Max Guild Name Length"] = "Lung. max nome gilda"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "Celerità:"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "Pietra del ritorno"
L["Selected Hearthstone"] = "Pietra del ritorno selezionata"
L["Random"] = "Casuale"
L["Selected:"] = "Selezionato:"
L["Available Hearthstones:"] = "Pietre del ritorno disponibili:"
L["Left Click: Use Hearthstone"] = "Click sinistro: Usa pietra del ritorno"
L["Right Click: Select Hearthstone"] = "Click destro: Seleziona pietra del ritorno"
L["Cannot use hearthstone while in combat"] = "Impossibile usare la pietra del ritorno in combattimento"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "Int"

-- ----------------------------
-- modules/ItemLevel.lua
-- ----------------------------
L["Item Level"] = "Livello oggetto"
L["ilvl"] = "lOgg"
L["Equipped Item Level"] = "Livello oggetto equipaggiato"
L["Maximum Item Level"] = "Livello oggetto massimo"
L["Show Max Item Level"] = "Mostra livello oggetto massimo"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "NESSUN TESTO"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "Nuova posta"
L["No Mail"] = "Nessuna posta"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "Nome della mappa"
L["Zone Name"] = "Nome zona"
L["Subzone Name"] = "Nome sottozona"
L["Zone - Subzone"] = "Zona - Sottozona"
L["Zone / Subzone (Two Lines)"] = "Zona / Sottozona (Due righe)"
L["Minimap Zone"] = "Zona minimappa"
L["Show Zone on Tooltip"] = "Mostra zona nel tooltip"
L["Show Coordinates on Tooltip"] = "Mostra coordinate nel tooltip"
L["Zone:"] = "Zona:"
L["Subzone:"] = "Sottozona:"
L["Coordinates:"] = "Coordinate:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "Maestria:"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "Pietra portale mitica+"
L["No Mythic+ Keystone"] = "Nessuna pietra portale mitica+"
L["Current Key:"] = "Chiave attuale:"
L["Dungeon Teleport is on cooldown for "] = "Il teletrasporto al dungeon è in ricarica per "
L[" more seconds."] = " secondi ancora."
L["You do not know the teleport spell for "] = "Non conosci l'incantesimo di teletrasporto per "
L["Key: "] = "Chiave: "
L["None"] = "Nessuno"
L["No Key"] = "Nessuna chiave"
L["Left Click: Teleport to Dungeon"] = "Clic sinistro: Teletrasportati al dungeon"
L["Right Click: List Group in Finder"] = "Clic destro: Crea gruppo nel cercatore"

-- ----------------------------
-- modules/Quests.lua
-- ----------------------------
L["Quests"] = "Missioni"

-- ----------------------------
-- modules/SpecLoot.lua
-- ----------------------------
L["Left Click: Change Loot Specialization"] = "Clic sinistro: Cambia specializzazione bottino"
L["Current"] = "Attuale"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Attivo"
L["Inactive"] = "Inattivo"
L["Loadouts"] = "Configurazioni"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Impossibile caricare Blizzard_PlayerSpells: %s"
L["Starter Build"] = "Build iniziale"
L["Spec"] = "Spec"
L["Left Click: Change Talent Specialization"] = "Click sinistro: cambia specializzazione talenti"
L["Control + Left Click: Change Loadout"] = "Ctrl + click sinistro: cambia configurazione"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + click sinistro: mostra interfaccia specializzazione talenti"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + click destro: cambia specializzazione bottino"
L["Show Specialization Icon"] = "Mostra icona specializzazione"
L["Show Specialization Text"] = "Mostra testo specializzazione"
L["Show Loot Specialization Icon"] = "Mostra icona specializzazione bottino"
L["Show Loot Specialization Text"] = "Mostra testo specializzazione bottino"
L["Show Loot Spec When Current"] = "Mostra spec bottino quando è 'corrente'"
L["Show Loadout"] = "Mostra configurazione"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "Velocità: "

-- ----------------------------
-- modules/Stagger.lua
-- ----------------------------
L["Stagger Amount:"] = "Quantità di Scaglionamento:"

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "Str"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "MB"
L["KB_SUFFIX"] = "KB"
L["SYSTEM"] = "SISTEMA"
L["FPS:"] = "FPS:"
L["Home Latency:"] = "Latenza locale:"
L["World Latency:"] = "Latenza mondo:"
L["Total Memory:"] = "Memoria totale:"
L["(Shift Click) Collect Garbage"] = "(Shift + Click) Pulisci memoria"
L["FPS"] = "FPS"
L["MS"] = "MS"
L["Top Addons by Memory:"] = "Top addon per memoria:"
L["Top Addons in Tooltip"] = "Migliori addon nel tooltip"
L["Total CPU:"] = "CPU totale:"
L["Top Addons by CPU:"] = "Principali addon per CPU:"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "TEMPO"
L["Saved Raid(s)"] = "Raid salvati"
L["Saved Dungeon(s)"] = "Dungeon salvati"
L["Display Realm Time"] = "Mostra ora del regno"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "Vers:"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Seleziona stream volume"
L["Toggle Volume Stream"] = "Attiva/disattiva stream volume"
L["Output Audio Device"] = "Dispositivo audio in uscita"
L["Active Output Audio Device"] = "Dispositivo audio in uscita attivo"
L["Volume Streams"] = "Stream volume"
L["Left Click: Select Volume Stream"] = "Click sinistro: seleziona stream volume"
L["Middle Click: Toggle Mute Master Stream"] = "Click centrale: silenzia stream principale"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + click centrale: attiva/disattiva stream volume"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + click sinistro: apri pannello audio"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + click destro: seleziona dispositivo audio uscita"
L["M. Vol"] = "Vol. Pr"
L["FX"] = "Eff"
L["Amb"] = "Amb"
L["Dlg"] = "Dial"
L["Mus"] = "Mus"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Gilda"
L["No Guild"] = "Nessuna gilda"
L["Friends"] = "Amici"
L["<Mobile>"] = "<Mobile>"
L["Hints"] = "Suggerimenti"
L["Block"] = "Blocca"
L["Click"] = "Click"
L["RightClick"] = "Click destro"
L["MiddleClick"] = "Click centrale"
L["Modifier+Click"] = "Modificatore+Click"
L["Shift+Click"] = "Shift+Click"
L["Shift+RightClick"] = "Shift+Click destro"
L["Ctrl+Click"] = "Ctrl+Click"
L["Ctrl+RightClick"] = "Ctrl+Click destro"
L["Alt+Click"] = "Alt+Click"
L["Alt+RightClick"] = "Alt+Click destro"
L["Ctrl+MouseWheel"] = "Ctrl+Rotellina"
L["Button4"] = "Pulsante4"
L["to open panel."] = "per aprire il pannello."
L["to display config menu."] = "per mostrare il menu di configurazione."
L["to add a friend."] = "per aggiungere un amico."
L["to toggle notes."] = "per mostrare/nascondere note."
L["to whisper."] = "per sussurrare."
L["to invite."] = "per invitare."
L["to query information."] = "per richiedere informazioni."
L["to edit note."] = "per modificare la nota."
L["to edit officer note."] = "per modificare nota ufficiale."
L["to remove friend."] = "per rimuovere un amico."
L["to sort main column."] = "per ordinare colonna principale."
L["to sort second column."] = "per ordinare seconda colonna."
L["to sort third column."] = "per ordinare terza colonna."
L["to resize tooltip."] = "per ridimensionare tooltip."
L["Mobile App"] = "App mobile"
L["Desktop App"] = "App desktop"
L["OFFLINE FAVORITE"] = "FAVORITO OFFLINE"
L["MOTD"] = "MdG"
L["No friends online."] = "Nessun amico online."
L["Broadcast"] = "Broadcast"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Scala non valida.\nDeve essere un numero tra 70 e 200%"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Imposta scala tooltip personalizzata.\nInserisci un valore tra 70 e 200 (%%)."
L["Guild & Friends"] = "Gilda e amici"
L["Show guild name"] = "Mostra nome gilda"
L["Show 'Guild' tag"] = "Mostra etichetta 'Gilda'"
L["Show total number of guildmates"] = "Mostra numero totale membri gilda"
L["Show 'Friends' tag"] = "Mostra etichetta 'Amici'"
L["Show total number of friends"] = "Mostra numero totale amici"
L["Show guild XP"] = "Mostra XP gilda"
L["Show guild XP tooltip"] = "Mostra tooltip XP gilda"
L["Show own broadcast"] = "Mostra il tuo broadcast"
L["Show bnet friends broadcast"] = "Mostra broadcast amici Battle.net"
L["Show guild notes"] = "Mostra note gilda"
L["Show friend notes"] = "Mostra note amici"
L["Show class icon when grouped"] = "Mostra icona classe in gruppo"
L["Highlight sorted column"] = "Evidenzia colonna ordinata"
L["Simple"] = "Semplice"
L["Gradient"] = "Gradiente"
L["Reverse gradient"] = "Gradiente inverso"
L["Status as..."] = "Stato come..."
L["Class colored text"] = "Testo colorato per classe"
L["Custom colored text"] = "Testo colore personalizzato"
L["Icon"] = "Icona"
L["Real ID..."] = "Real ID..."
L["Before nickname"] = "Prima del soprannome"
L["Instead of nickname"] = "Al posto del soprannome"
L["After nickname"] = "Dopo il soprannome"
L["Don't show"] = "Non mostrare"
L["Column alignments"] = "Allineamento colonne"
L["Name"] = "Nome"
L["Zone"] = "Zona"
L["Notes"] = "Note"
L["Rank"] = "Rango"
L["Tooltip Size"] = "Dimensione tooltip"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Personalizzato..."
L["Use TipTac skin (requires TipTac)"] = "Usa skin TipTac (richiede TipTac)"
L["Colors"] = "Colori"
L["Background"] = "Sfondo"
L["Borders"] = "Bordi"
L["Order highlight"] = "Evidenzia ordine"
L["Headers"] = "Intestazioni"
L["MotD / broadcast"] = "MdG / broadcast"
L["Friendly zone"] = "Zona amica"
L["Contested zone"] = "Zona contesa"
L["Enemy zone"] = "Zona nemica"
L["Officer notes"] = "Note ufficiali"
L["Status"] = "Stato"
L["Ranks"] = "Ranghi"
L["Friends broadcast"] = "Broadcast amici"
L["Realms"] = "Reami"
L["Restore default colors"] = "Ripristina colori predefiniti"
L["Show Block Hints"] = "Mostra suggerimenti blocco"
L["Open panel"] = "Apri pannello"
L["Config menu"] = "Menu configurazione"
L["Toggle notes"] = "Mostra/nascondi note"
L["Add a friend"] = "Aggiungi amico"
L["Show Hints"] = "Mostra suggerimenti"
L["Whisper"] = "Sussurra"
L["Invite"] = "Invita"
L["Query"] = "Richiedi"
L["Edit note"] = "Modifica nota"
L["Edit officer note"] = "Modifica nota ufficiale"
L["Sort main column"] = "Ordina colonna principale"
L["Sort second column"] = "Ordina seconda colonna"
L["Sort third column"] = "Ordina terza colonna"
L["Resize tooltip"] = "Ridimensiona tooltip"
L["Remove friend"] = "Rimuovi amico"
