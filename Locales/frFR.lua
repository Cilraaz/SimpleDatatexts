local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "frFR" then
    return
end

-- ----------------------------
-- Global
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(vide)"
L["(spacer)"] = "(espace)"
L["Display Font:"] = "Police :"
L["Font Settings"] = "Paramètres de Police"
L["Font Size"] = "Taille de Police"
L["Font Outline"] = "Contour de Police"
L["GOLD"] = "OR"
L["Override Global Font"] = "Remplacer la police globale"
L["Override Text Color"] = "Remplacer la couleur du texte"
L["Settings"] = "Paramètres"
L["Frame Strata"] = "Strate de cadre"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "Définit la strate de cadre (couche) pour ce module. Les valeurs plus élevées apparaissent au-dessus des valeurs plus basses."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "Définit la strate de cadre (couche) pour ce panneau. Les modules apparaîtront par rapport à ceci. Les valeurs plus élevées apparaissent au-dessus des valeurs plus basses."
L["Slot Controls"] = "Contrôles d'Emplacement"
L["Anchor Point"] = "Point d'Ancrage"
L["Set the anchor point for this module."] = "Définit le point d'ancrage pour ce module."
L["Yes"] = "Oui"
L["No"] = "Non"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "Mode débogage désactivé"
L["Debug Mode Enabled"] = "Mode débogage activé"
L["Left Click to open settings"] = "Clic gauche pour ouvrir les paramètres"
L["Lock/Unlock"] = "Verrouiller/Déverrouiller"
L["Minimap Icon Disabled"] = "Icône de la mini-carte désactivée"
L["Minimap Icon Enabled"] = "Icône de la mini-carte activée"
L["Not Defined"] = "Non défini"
L["Toggle Minimap Icon"] = "Basculer l'icône de la mini-carte"
L["Usage"] = "Utilisation"
L["Version"] = "Version"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "Erreur lors de la compression des données du profil"
L["Error decoding import string"] = "Erreur lors du décodage de la chaîne d'importation"
L["Error decompressing data"] = "Erreur lors de la décompression des données"
L["Error deserializing profile data"] = "Erreur lors de la désérialisation des données du profil"
L["Error serializing profile data"] = "Erreur lors de la sérialisation des données du profil"
L["Import data too large"] = "Données d'importation trop volumineuses"
L["Import data too large after decompression"] = "Données d'importation trop volumineuses après décompression"
L["Import string is too large"] = "La chaîne d'importation est trop grande"
L["Importing profile from version %s"] = "Importation du profil depuis la version %s"
L["Invalid import string format"] = "Format de chaîne d'importation non valide"
L["Invalid profile data"] = "Données de profil invalides"
L["Migrating old settings to new profile system..."] = "Migration des anciennes options vers le nouveau système de profils..."
L["Migration complete! All profiles have been migrated."] = "Migration terminée ! Tous les profils ont été migrés."
L["No import string provided"] = "Aucune chaîne d'importation fournie"
L["Profile imported successfully!"] = "Profil importé avec succès !"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "Couleurs"
L["Custom Color"] = "Couleur Personnalisée"
L["Enable Per-Spec Profiles"] = "Activer les profils par spécialisation"
L["Global"] = "Global"
L["Global Settings"] = "Paramètres Globaux"
L["Hide Module Title in Tooltip"] = "Masquer le titre du module dans l'infobulle"
L["Lock Panels"] = "Verrouiller les panneaux"
L["Prevent panels from being moved"] = "Empêcher le déplacement des panneaux"
L["Show Login Message"] = "Afficher le message de connexion"
L["Show Minimap Icon"] = "Afficher l'icône de la mini-carte"
L["Toggle the minimap button on or off"] = "Activer/désactiver le bouton de la mini-carte"
L["Use 24Hr Clock"] = "Utiliser l'horloge 24h"
L["Use Class Color"] = "Utiliser la couleur de classe"
L["Use Custom Color"] = "Utiliser une couleur personnalisée"
L["X Offset"] = "Décalage X"
L["Y Offset"] = "Décalage Y"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "Lorsqu'activé, l'addon basculera automatiquement vers un profil différent à chaque fois que vous changez de spécialisation. Choisissez ci-dessous quel profil chaque spécialisation doit utiliser."
L["Enable Font Text Shadow"] = "Activer l'ombre du texte de police"
L["Add a subtle shadow to datatexts for better readability"] = "Ajoute une ombre subtile aux textes de données pour une meilleure lisibilité"
L["Enable Tooltip Text Shadow"] = "Activer l'ombre du texte"
L["Add a subtle shadow to tooltip text for better readability"] = "Ajoute une ombre subtile au texte pour une meilleure lisibilité"
L["Tooltip Settings"] = "Paramètres d'info-bulle"
L["Tooltip Font"] = "Police d'info-bulle"
L["Font used for all addon tooltips"] = "Police utilisée pour toutes les info-bulles de l'addon"
L["Tooltip Font Outline"] = "Contour de police d'info-bulle"
L["Font outline for all addon tooltips"] = "Contour de police pour toutes les info-bulles de l'addon"
L["Tooltip Header Font Size"] = "Taille de police d'en-tête"
L["Font size for tooltip headers"] = "Taille de police pour les en-têtes d'info-bulle"
L["Tooltip Line Font Size"] = "Taille de police de ligne"
L["Font size for tooltip content lines"] = "Taille de police pour les lignes de contenu"
L["Show All Panels"] = "Afficher tous les panneaux"
L["Toggle visibility of all panels. Individual panels can also be hidden in their own settings."] = "Basculer la visibilité de tous les panneaux. Les panneaux individuels peuvent également être masqués dans leurs propres paramètres."
L["Panels shown"] = "Panneaux affichés"
L["Panels hidden"] = "Panneaux masqués"
L["Toggle All Panels"] = "Basculer tous les panneaux"

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "Apparence"
L["Apply Slot Changes"] = "Appliquer les modifications de slot"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Êtes-vous sûr de vouloir supprimer cette barre ?\nCette action est irréversible."
L["Background Opacity"] = "Opacité de fond"
L["Border Color"] = "Couleur de la bordure"
L["Border Size"] = "Taille de la bordure"
L["Create New Panel"] = "Créer un nouveau panneau"
L["Height"] = "Hauteur"
L["Number of Slots"] = "Nombre de slots"
L["Panel Settings"] = "Paramètres du panneau"
L["Panels"] = "Panneaux"
L["Remove Selected Panel"] = "Supprimer le panneau sélectionné"
L["Rename Panel:"] = "Renommer le panneau :"
L["Scale"] = "Échelle"
L["Select Border:"] = "Sélectionner la bordure :"
L["Select Panel:"] = "Sélectionner le panneau :"
L["Size & Scale"] = "Taille & Échelle"
L["Slot Assignments"] = "Attributions des slots"
L["Slot %d:"] = "Slot %d :"
L["Slots"] = "Slots"
L["Update slot assignment dropdowns after changing number of slots"] = "Mettre à jour les menus déroulants des slots après modification du nombre de slots"
L["Width"] = "Largeur"
L["Hide Panel"] = "Masquer le panneau"
L["Hide this panel. Panels are always visible while unlocked."] = "Masquer ce panneau. Les panneaux sont toujours visibles lorsqu'ils sont déverrouillés."

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "Paramètres du Module"
L["Hide Decimals"] = "Masquer les décimales"
L["Show Label"] = "Afficher le libellé"
L["Show Short Label"] = "Afficher le libellé court"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. Cliquez sur 'Générer la chaîne d'export' ci-dessus\n2. Cliquez dans cette boîte\n3. Appuyez sur Ctrl+A pour tout sélectionner\n4. Appuyez sur Ctrl+C pour copier"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. Collez une chaîne d'importation dans le champ ci-dessous\n2. Cliquez sur Accepter\n3. Cliquez sur 'Importer le profil'"
L["Create an export string for your current profile"] = "Créer une chaîne d'export pour votre profil actuel"
L["Export"] = "Exporter"
L["Export String"] = "Chaîne d'export"
L["Export string generated! Copy it from the box below."] = "Chaîne d'export générée ! Copiez-la depuis le champ ci-dessous."
L["Export your current profile to share with others, or import a profile string.\n"] = "Exportez votre profil actuel pour le partager ou importez une chaîne de profil.\n"
L["Generate Export String"] = "Générer la chaîne d'export"
L["Import"] = "Importer"
L["Import/Export"] = "Importer/Exporter"
L["Import Profile"] = "Importer le profil"
L["Import String"] = "Chaîne d'import"
L["Import the profile string from above (after clicking Accept)"] = "Importez la chaîne de profil ci-dessus (après avoir cliqué sur Accepter)"
L["Please paste an import string and click Accept first"] = "Veuillez d'abord coller une chaîne d'import et cliquer sur Accepter"
L["Profile Import/Export"] = "Import/Export de profil"
L["This will overwrite your current profile. Are you sure?"] = "Cela remplacera votre profil actuel. Êtes-vous sûr ?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "Panneaux verrouillés"
L["Panels unlocked"] = "Panneaux déverrouillés"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "Agi"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Réduction par niveau :"
L["Level %d"] = "Niveau %d"
L["Target Mitigation"] = "Réduction sur la cible"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "AP"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Sacs"

-- ----------------------------
-- modules/CombatTimer.lua
-- ----------------------------
L["Combat"] = "Combat"
L["combat duration"] = "durée du combat"
L["Combat Timer"] = "Chronomètre de Combat"
L["Current"] = "Actuel"
L["Currently out of combat"] = "Actuellement hors combat"
L["Display Duration"] = "Durée d'affichage"
L["Enter combat to start tracking"] = "Entrez en combat pour commencer le suivi"
L["Last"] = "Dernier"
L["Left-click"] = "Clic gauche"
L["Out of Combat"] = "Hors combat"
L["to reset"] = "pour réinitialiser"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "Crit"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "MONNAIES"
L["Tracked Currency Qty"] = "Qté de Devise Suivie"
L["Currency Display Order"] = "Ordre d'Affichage des Devises"
L["Position %d"] = "Position %d"
L["Empty Slot"] = "Emplacement Vide"

-- ----------------------------
-- modules/Date.lua
-- ----------------------------
L["Date"] = "Date"
L["Date Format"] = "Format de date"
L["MM/DD/YYYY"] = "MM/JJ/AAAA"
L["DD/MM/YYYY"] = "JJ/MM/AAAA"
L["YYYY-MM-DD"] = "AAAA-MM-JJ"
L["Month DD, YYYY"] = "Mois JJ, AAAA"
L["DD Month YYYY"] = "JJ Mois AAAA"
L["Weekday, Month DD"] = "Jour de semaine, Mois JJ"
L["Abbrev. (Mon, Jan 1)"] = "Abrév. (Lun, Jan 1)"
L["Show Day of Week on Tooltip"] = "Afficher le jour de la semaine dans l'infobulle"
L["Show Day of Year on Tooltip"] = "Afficher le jour de l'année dans l'infobulle"
L["Day of Week:"] = "Jour de la semaine :"
L["Day of Year:"] = "Jour de l'année :"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "Durée:"
L["Durability:"] = "Durabilité :"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "Niveau Maximum"
L["N/A"] = "N/A"
L["Experience"] = "Expérience"
L["Display Format"] = "Format d'affichage"
L["Bar Toggles"] = "Options de barre"
L["Show Graphical Bar"] = "Afficher la barre graphique"
L["Hide Blizzard XP Bar"] = "Masquer la barre d'EXP de Blizzard"
L["Bar Appearance"] = "Apparence de la barre"
L["Bar Height (%)"] = "Hauteur de la barre (%)"
L["Bar Use Class Color"] = "Utiliser la couleur de classe pour la barre"
L["Bar Custom Color"] = "Couleur personnalisée de la barre"
L["Bar Texture"] = "Texture de la barre"
L["Text Color"] = "Couleur du texte"
L["Text Use Class Color"] = "Utiliser la couleur de classe pour le texte"
L["Text Custom Color"] = "Couleur personnalisée du texte"
L["Show Rested XP Bar"] = "Afficher la barre XP de repos"
L["Override Default Rested Color"] = "Remplacer la couleur de repos par défaut"
L["Rested Custom Color"] = "Couleur personnalisée de repos"
L["Rested:"] = "Reposé :"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Objet LDB Ara Friends introuvable ! Datatext Amis SDT désactivé."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "Afficher l'argent"
L["Show Copper"] = "Afficher le cuivre"
L["Use Coin Icons"] = "Utiliser les icônes de pièces"
L["Display Quantities"] = "Afficher les quantités"
L["Characters to Show"] = "Personnages à afficher"
L["Servers to Show"] = "Serveurs à afficher"
L["Session:"] = "Session :"
L["Earned:"] = "Gagné :"
L["Spent:"] = "Dépensé :"
L["Profit:"] = "Bénéfice :"
L["Deficit:"] = "Déficit :"
L["Character:"] = "Personnage :"
L["Server:"] = "Serveur :"
L["Faction:"] = "Faction :"
L["Alliance:"] = "Alliance :"
L["Horde:"] = "Horde :"
L["Total:"] = "Total :"
L["Warband:"] = "Bande de guerre :"
L["WoW Token:"] = "Jeton WoW :"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Réinitialiser les données de session : maintenir Ctrl + clic droit"
L["Gold: All data reset!"] = "Or : Toutes les données réinitialisées !"
L["Gold: Data reset for %s!"] = "Or : Données réinitialisées pour %s !"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "Êtes-vous sûr de vouloir supprimer les données d'or pour :\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000TOUS LES PERSONNAGES|r"
L["|cFF808080No character data found|r"] = "|cFF808080Aucune donnée de personnage trouvée|r"
L["Reset Session Data:"] = "Réinitialiser les données de session :"
L["Hold Shift + Right Click"] = "Maintenir Maj + Clic droit"
L["Reset Character Gold Data:"] = "Réinitialiser les données d'or du personnage :"
L["Hold Alt + Right Click"] = "Maintenir Alt + Clic droit"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Objet LDB Ara Guild introuvable ! Datatext Guilde SDT désactivé."
L["Max Guild Name Length"] = "Long. max. nom de guilde"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "Hâte :"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "Pierre de foyer"
L["Selected Hearthstone"] = "Pierre de foyer sélectionnée"
L["Random"] = "Aléatoire"
L["Selected:"] = "Sélectionné :"
L["Available Hearthstones:"] = "Pierres de foyer disponibles :"
L["Left Click: Use Hearthstone"] = "Clic gauche : Utiliser la pierre de foyer"
L["Right Click: Select Hearthstone"] = "Clic droit : Sélectionner la pierre de foyer"
L["Cannot use hearthstone while in combat"] = "Impossible d'utiliser la pierre de foyer en combat"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "Int"

-- ----------------------------
-- modules/ItemLevel.lua
-- ----------------------------
L["Item Level"] = "Niveau d'objet"
L["ilvl"] = "nObj"
L["Equipped Item Level"] = "Niveau d'objet équipé"
L["Maximum Item Level"] = "Niveau d'objet maximum"
L["Show Max Item Level"] = "Afficher le niveau d'objet maximum"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "PAS DE TEXTE"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "Nouveau courrier"
L["No Mail"] = "Aucun courrier"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "Nom de la carte"
L["Zone Name"] = "Nom de zone"
L["Subzone Name"] = "Nom de sous-zone"
L["Zone - Subzone"] = "Zone - Sous-zone"
L["Zone / Subzone (Two Lines)"] = "Zone / Sous-zone (Deux lignes)"
L["Minimap Zone"] = "Zone de la minicarte"
L["Show Zone on Tooltip"] = "Afficher la zone dans l'infobulle"
L["Show Coordinates on Tooltip"] = "Afficher les coordonnées dans l'infobulle"
L["Zone:"] = "Zone:"
L["Subzone:"] = "Sous-zone:"
L["Coordinates:"] = "Coordonnées:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "Maîtrise :"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "Pierre de clé mythique+"
L["No Mythic+ Keystone"] = "Pas de pierre de clé mythique+"
L["Current Key:"] = "Clé actuelle :"
L["Dungeon Teleport is on cooldown for "] = "La téléportation vers le donjon est en recharge pendant "
L[" more seconds."] = " secondes de plus."
L["You do not know the teleport spell for "] = "Vous ne connaissez pas le sort de téléportation pour "
L["Key: "] = "Clé : "
L["None"] = "Aucun"
L["No Key"] = "Pas de clé"
L["Left Click: Teleport to Dungeon"] = "Clic gauche : Se téléporter au donjon"
L["Right Click: List Group in Finder"] = "Clic droit : Créer un groupe dans le chercheur"

-- ----------------------------
-- modules/Quests.lua
-- ----------------------------
L["Quests"] = "Quêtes"

-- ----------------------------
-- modules/SpecLoot.lua
-- ----------------------------
L["Left Click: Change Loot Specialization"] = "Clic gauche : Changer la spécialisation de butin"
L["Current"] = "Actuelle"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Actif"
L["Inactive"] = "Inactif"
L["Loadouts"] = "Configurations"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Échec du chargement de Blizzard_PlayerSpells : %s"
L["Starter Build"] = "Configuration de départ"
L["Spec"] = "Spéc."
L["Left Click: Change Talent Specialization"] = "Clic gauche : changer la spécialisation de talents"
L["Control + Left Click: Change Loadout"] = "Ctrl + clic gauche : changer la configuration"
L["Shift + Left Click: Show Talent Specialization UI"] = "Maj + clic gauche : afficher l’interface des spécialisations de talents"
L["Shift + Right Click: Change Loot Specialization"] = "Maj + clic droit : changer la spécialisation du butin"
L["Show Specialization Icon"] = "Afficher l'icône de spécialisation"
L["Show Specialization Text"] = "Afficher le texte de spécialisation"
L["Show Loot Specialization Icon"] = "Afficher l'icône de spécialisation de butin"
L["Show Loot Specialization Text"] = "Afficher le texte de spécialisation de butin"
L["Show Loot Spec When Current"] = "Afficher la spé de butin quand 'Actuelle'"
L["Show Loadout"] = "Afficher la configuration"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "Vitesse : "

-- ----------------------------
-- modules/Stagger.lua
-- ----------------------------
L["Stagger Amount:"] = "Montant d'Échelonnement :"

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "Str"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "Mo"
L["KB_SUFFIX"] = "Ko"
L["SYSTEM"] = "SYSTÈME"
L["FPS:"] = "FPS :"
L["Home Latency:"] = "Latence locale :"
L["World Latency:"] = "Latence monde :"
L["Total Memory:"] = "Mémoire totale :"
L["(Shift Click) Collect Garbage"] = "(Maj + clic) Collecter les déchets"
L["FPS"] = "FPS"
L["MS"] = "MS"
L["Top Addons by Memory:"] = "Top des addons par mémoire:"
L["Top Addons in Tooltip"] = "Meilleurs addons dans l'infobulle"
L["Total CPU:"] = "CPU total :"
L["Top Addons by CPU:"] = "Addons principaux par CPU :"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "HEURE"
L["Saved Raid(s)"] = "Raids sauvegardés"
L["Saved Dungeon(s)"] = "Donjons sauvegardés"
L["Display Realm Time"] = "Afficher l'heure du royaume"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "Poly :"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Sélectionner le flux de volume"
L["Toggle Volume Stream"] = "Activer/désactiver le flux de volume"
L["Output Audio Device"] = "Périphérique audio de sortie"
L["Active Output Audio Device"] = "Périphérique audio de sortie actif"
L["Volume Streams"] = "Flux de volume"
L["Left Click: Select Volume Stream"] = "Clic gauche : sélectionner le flux de volume"
L["Middle Click: Toggle Mute Master Stream"] = "Clic milieu : activer/désactiver le flux principal"
L["Shift + Middle Click: Toggle Volume Stream"] = "Maj + clic milieu : activer/désactiver le flux de volume"
L["Shift + Left Click: Open System Audio Panel"] = "Maj + clic gauche : ouvrir le panneau audio système"
L["Shift + Right Click: Select Output Audio Device"] = "Maj + clic droit : sélectionner le périphérique audio de sortie"
L["M. Vol"] = "Vol. Pr"
L["FX"] = "Eff"
L["Amb"] = "Amb"
L["Dlg"] = "Disc"
L["Mus"] = "Mus"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Guilde"
L["No Guild"] = "Aucune guilde"
L["Friends"] = "Amis"
L["<Mobile>"] = "<Mobile>"
L["Hints"] = "Astuces"
L["Block"] = "Bloc"
L["Click"] = "Clic"
L["RightClick"] = "Clic droit"
L["MiddleClick"] = "Clic milieu"
L["Modifier+Click"] = "Modificateur + clic"
L["Shift+Click"] = "Maj + clic"
L["Shift+RightClick"] = "Maj + clic droit"
L["Ctrl+Click"] = "Ctrl + clic"
L["Ctrl+RightClick"] = "Ctrl + clic droit"
L["Alt+Click"] = "Alt + clic"
L["Alt+RightClick"] = "Alt + clic droit"
L["Ctrl+MouseWheel"] = "Ctrl + molette"
L["Button4"] = "Bouton 4"
L["to open panel."] = "pour ouvrir le panneau."
L["to display config menu."] = "pour afficher le menu de configuration."
L["to add a friend."] = "pour ajouter un ami."
L["to toggle notes."] = "pour afficher/masquer les notes."
L["to whisper."] = "pour chuchoter."
L["to invite."] = "pour inviter."
L["to query information."] = "pour demander des informations."
L["to edit note."] = "pour modifier la note."
L["to edit officer note."] = "pour modifier la note d'officier."
L["to remove friend."] = "pour supprimer un ami."
L["to sort main column."] = "pour trier la colonne principale."
L["to sort second column."] = "pour trier la deuxième colonne."
L["to sort third column."] = "pour trier la troisième colonne."
L["to resize tooltip."] = "pour redimensionner l’infobulle."
L["Mobile App"] = "Application mobile"
L["Desktop App"] = "Application de bureau"
L["OFFLINE FAVORITE"] = "FAVORI HORS LIGNE"
L["MOTD"] = "MdJ"
L["MOTD Unavailable due to combat lockdown."] = "MdJ indisponible en raison du verrouillage de combat."
L["No friends online."] = "Aucun ami en ligne."
L["Broadcast"] = "Message"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Échelle invalide.\nDoit être un nombre entre 70 et 200 %"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Définir une échelle d’infobulle personnalisée.\nEntrez une valeur entre 70 et 200 (%%)."
L["Guild & Friends"] = "Guilde et amis"
L["Show guild name"] = "Afficher le nom de la guilde"
L["Show 'Guild' tag"] = "Afficher l'étiquette \"Guilde\""
L["Show total number of guildmates"] = "Afficher le nombre total de membres de la guilde"
L["Show 'Friends' tag"] = "Afficher l'étiquette \"Amis\""
L["Show total number of friends"] = "Afficher le nombre total d'amis"
L["Show guild XP"] = "Afficher l'XP de guilde"
L["Show guild XP tooltip"] = "Afficher l'infobulle d'XP de guilde"
L["Show own broadcast"] = "Afficher votre message"
L["Show bnet friends broadcast"] = "Afficher les messages des amis Battle.net"
L["Show guild notes"] = "Afficher les notes de guilde"
L["Show friend notes"] = "Afficher les notes d'amis"
L["Show class icon when grouped"] = "Afficher l'icône de classe en groupe"
L["Highlight sorted column"] = "Surligner la colonne triée"
L["Simple"] = "Simple"
L["Gradient"] = "Dégradé"
L["Reverse gradient"] = "Dégradé inversé"
L["Status as..."] = "Statut en..."
L["Class colored text"] = "Texte coloré par classe"
L["Custom colored text"] = "Texte de couleur personnalisée"
L["Icon"] = "Icône"
L["Real ID..."] = "Identifiant réel..."
L["Before nickname"] = "Avant le surnom"
L["Instead of nickname"] = "À la place du surnom"
L["After nickname"] = "Après le surnom"
L["Don't show"] = "Ne pas afficher"
L["Column alignments"] = "Alignement des colonnes"
L["Name"] = "Nom"
L["Zone"] = "Zone"
L["Notes"] = "Notes"
L["Rank"] = "Rang"
L["Tooltip Size"] = "Taille de l’infobulle"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Personnalisé..."
L["Use TipTac skin (requires TipTac)"] = "Utiliser le thème TipTac (nécessite TipTac)"
L["Colors"] = "Couleurs"
L["Background"] = "Arrière-plan"
L["Borders"] = "Bordures"
L["Order highlight"] = "Surlignage du tri"
L["Headers"] = "En-têtes"
L["MotD / broadcast"] = "MdJ / message"
L["Friendly zone"] = "Zone amie"
L["Contested zone"] = "Zone contestée"
L["Enemy zone"] = "Zone ennemie"
L["Officer notes"] = "Notes d'officier"
L["Status"] = "Statut"
L["Ranks"] = "Rangs"
L["Friends broadcast"] = "Messages d'amis"
L["Realms"] = "Royaumes"
L["Restore default colors"] = "Rétablir les couleurs par défaut"
L["Show Block Hints"] = "Afficher les astuces du bloc"
L["Open panel"] = "Ouvrir le panneau"
L["Config menu"] = "Menu de configuration"
L["Toggle notes"] = "Afficher/masquer les notes"
L["Add a friend"] = "Ajouter un ami"
L["Show Hints"] = "Afficher les astuces"
L["Whisper"] = "Chuchoter"
L["Invite"] = "Inviter"
L["Query"] = "Interroger"
L["Edit note"] = "Modifier la note"
L["Edit officer note"] = "Modifier la note d'officier"
L["Sort main column"] = "Trier la colonne principale"
L["Sort second column"] = "Trier la deuxième colonne"
L["Sort third column"] = "Trier la troisième colonne"
L["Resize tooltip"] = "Redimensionner l’infobulle"
L["Remove friend"] = "Supprimer un ami"
