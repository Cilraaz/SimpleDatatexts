local _, SDT = ...
local L = SDT.L

if GetLocale() ~= "frFR" then
    return
end

-- ----------------------------
-- SimpleDatatexts.lua
-- ----------------------------
-- Used in: Settings.lua, SimpleDatatexts.lua
L["(empty)"] = "(vide)"
L["Loaded. Total modules: %d"] = "Chargé. Nombre total de modules : %d"
L["|cffffff00--[Options]--|r"] = "|cffffff00--[Options]--|r"
L["Lock/Unlock: |cff8888ff/sdt lock|r"] = "Verrouiller/Déverrouiller : |cff8888ff/sdt lock|r"
L["Width: |cff8888ff/sdt width <barName> <newWidth>|r"] = "Largeur : |cff8888ff/sdt width <barName> <newWidth>|r"
L["Height: |cff8888ff/sdt height <barName> <newHeight>|r"] = "Hauteur : |cff8888ff/sdt height <barName> <newHeight>|r"
L["Scale: |cff8888ff/sdt scale <barName> <newScale>|r"] = "Échelle : |cff8888ff/sdt scale <barName> <newScale>|r"
L["Settings: |cff8888ff/sdt config|r"] = "Paramètres : |cff8888ff/sdt config|r"
L["Version: |cff8888ff/sdt version|r"] = "Version : |cff8888ff/sdt version|r"
L["Usage: /sdt %s <barName> <value>"] = "Utilisation : /sdt %s <nomBarre> <valeur>"
L["Invalid panel name supplied. Valid panel names are:"] = "Nom de panneau invalide. Les noms valides sont :"
L["A valid numeric value for the adjustment must be specified."] = "Une valeur numérique valide doit être spécifiée pour l’ajustement."
L["Invalid panel width specified."] = "Largeur de panneau invalide."
L["Invalid panel height specified."] = "Hauteur de panneau invalide."
L["Invalid panel scale specified."] = "Échelle de panneau invalide."
L["Invalid adjustment type specified."] = "Type d'ajustement invalide."
L["SDT panels are now: "] = "Les panneaux SDT sont maintenant : "
L["|cffff0000LOCKED|r"] = "|cffff0000VERROUILLÉS|r"
L["|cff00ff00UNLOCKED|r"] = "|cff00ff00DÉVERROUILLÉS|r"
L["Simple Datatexts Version: |cff8888ff%s|r"] = "Version de Simple Datatexts : |cff8888ff%s|r"

-- ----------------------------
-- Settings.lua
-- ----------------------------
L["Simple DataTexts"] = "Simple DataTexts"
L["Global"] = "Global"
L["Simple DataTexts - Global Settings"] = "Simple DataTexts - Paramètres globaux"
L["Panels"] = "Panneaux"
L["Simple DataTexts - Panel Settings"] = "Simple DataTexts - Paramètres des panneaux"
L["Profiles"] = "Profils"
L["Simple DataTexts - Profile Settings"] = "Simple DataTexts - Paramètres des profils"
L["Lock Panels (disable movement)"] = "Verrouiller les panneaux (désactiver le déplacement)"
L["Use Class Color"] = "Utiliser la couleur de classe"
L["Use 24Hr Clock"] = "Utiliser l'horloge 24h"
L["Use Custom Color"] = "Utiliser une couleur personnalisée"
L["Display Font:"] = "Police d’affichage :"
L["Font Size"] = "Taille de la police"
L["Create New Panel"] = "Créer un nouveau panneau"
L["Select Panel:"] = "Sélectionner un panneau :"
L["Rename Panel:"] = "Renommer le panneau :"
L["Remove Selected Panel"] = "Supprimer le panneau sélectionné"
L["Slot %d:"] = "Emplacement %d :"
L["Scale"] = "Échelle"
L["Background Opacity"] = "Opacité de l’arrière-plan"
L["Slots"] = "Emplacements"
L["Width"] = "Largeur"
L["Height"] = "Hauteur"
L["Select Border:"] = "Sélectionner une bordure :"
L["Border Size"] = "Taille de la bordure"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Voulez-vous vraiment supprimer cette barre ?\nCette action est irréversible."
-- Used in: Settings.lua, Utilities.lua
L["Yes"] = "Oui"
-- Used in: Settings.lua, Utilities.lua
L["No"] = "Non"
L["(none)"] = "(aucun)"
L["Create New Profile:"] = "Créer un nouveau profil :"
L["Current Profile:"] = "Profil actuel :"
L["Enable Per-Spec Profiles"] = "Activer les profils par spécialisation"
L["Copy Profile:"] = "Copier le profil :"
L["Delete Profile:"] = "Supprimer le profil :"
L["NYI:"] = "À venir :"
L["The profile name you have entered already exists. Please enter a new name."] = "Le nom de profil que vous avez saisi existe déjà. Veuillez entrer un nouveau nom."
-- Used in: Settings.lua, Utilities.lua
L["Ok"] = "OK"
L["Saved font not found. Resetting font to Friz Quadrata TT."] = "Police enregistrée introuvable. Réinitialisation sur Friz Quadrata TT."

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Are you sure you want to overwrite your\n'%s' profile?\nThis action cannot be undone."] = "Voulez-vous vraiment écraser votre profil\n'%s' ?\nCette action est irréversible."
L["You cannot copy the active profile onto itself. Please change your active profile first."] = "Vous ne pouvez pas copier le profil actif sur lui-même. Veuillez d'abord changer votre profil actif."
L["Invalid source profile specified."] = "Profil source invalide."
L["You cannot delete the active profile. Please change your active profile first."] = "Vous ne pouvez pas supprimer le profil actif. Veuillez d'abord changer votre profil actif."
L["Are you sure you want to delete this profile?\nThis action cannot be undone."] = "Voulez-vous vraiment supprimer ce profil ?\nCette action est irréversible."

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Réduction par niveau :"
L["Level %d"] = "Niveau %d"
L["Target Mitigation"] = "Réduction sur la cible"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Sacs"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit: "] = "Crit : "

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "MONNAIES"
-- Used in: modules/Currency.lua, modules/Gold.lua
L["GOLD"] = "OR"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Durability: "] = "Durabilité : "

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Objet LDB Ara Friends introuvable ! Datatext Amis SDT désactivé."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Session:"] = "Session :"
L["Earned:"] = "Gagné :"
L["Spent:"] = "Dépensé :"
L["Profit:"] = "Bénéfice :"
L["Deficit:"] = "Déficit :"
L["Character:"] = "Personnage :"
L["Server:"] = "Serveur :"
L["Alliance:"] = "Alliance :"
L["Horde:"] = "Horde :"
L["Total:"] = "Total :"
L["Warband:"] = "Bande de guerre :"
L["WoW Token:"] = "Jeton WoW :"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Réinitialiser les données de session : maintenir Ctrl + clic droit"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Objet LDB Ara Guild introuvable ! Datatext Guilde SDT désactivé."

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste: "] = "Hâte : "

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
-- modules/Mastery.lua
-- ----------------------------
L["Mastery: "] = "Maîtrise : "

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
L["Shift + Left Click: Show Talent Specialization UI"] = "Maj + clic gauche : afficher l’interface des spécialisations"
L["Shift + Right Click: Change Loot Specialization"] = "Maj + clic droit : changer la spécialisation du butin"

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

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "HEURE"
L["Saved Raid(s)"] = "Raids sauvegardés"
L["Saved Dungeon(s)"] = "Donjons sauvegardés"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers: "] = "Poly : "

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

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Guilde"
L["No Guild"] = "Aucune guilde"
L["Friends: "] = "Amis : "
L["<Mobile>"] = "<Mobile>"
L["Hints [|cffffffffBlock|r]"] = "Astuces [|cffffffffBloc|r]"
L["|cffff8020Click|r to open panel."] = "|cffff8020Clic|r pour ouvrir le panneau."
L["|cffff8020RightClick|r to display config menu."] = "|cffff8020Clic droit|r pour afficher le menu de configuration."
L["|cffff8020MiddleClick|r to add a friend."] = "|cffff8020Clic milieu|r pour ajouter un ami."
L["|cffff8020Modifier+Click|r to add a friend."] = "|cffff8020Modificateur + clic|r pour ajouter un ami."
L["|cffff8020Button4|r to toggle notes."] = "|cffff8020Bouton 4|r pour afficher/masquer les notes."
L["Hints"] = "Astuces"
L["|cffff8020Click|r to whisper."] = "|cffff8020Clic|r pour chuchoter."
L["|cffff8020Alt+Click|r to invite."] = "|cffff8020Alt + clic|r pour inviter."
L["|cffff8020Shift+Click|r to query informations."] = "|cffff8020Maj + clic|r pour demander des informations."
L["|cffff8020Ctrl+Click|r to edit note."] = "|cffff8020Ctrl + clic|r pour modifier la note."
L["|cffff8020Ctrl+RightClick|r to edit officer note."] = "|cffff8020Ctrl + clic droit|r pour modifier la note d'officier."
L["|cffff8020MiddleClick|r to remove friend."] = "|cffff8020Clic milieu|r pour supprimer un ami."
L["|cffff8020RightClick|r to sort main column."] = "|cffff8020Clic droit|r pour trier la colonne principale."
L["|cffff8020Shift+RightClick|r to sort second column."] = "|cffff8020Maj + clic droit|r pour trier la deuxième colonne."
L["|cffff8020Alt+RightClick|r to sort third column."] = "|cffff8020Alt + clic droit|r pour trier la troisième colonne."
L["|cffff8020Ctrl+MouseWheel|r to resize tooltip."] = "|cffff8020Ctrl + molette|r pour redimensionner l’infobulle."
L["Mobile App"] = "Application mobile"
L["Desktop App"] = "Application de bureau"
L["OFFLINE FAVORITE"] = "FAVORI HORS LIGNE"
L["MOTD"] = "MdJ"
L["No friends online."] = "Aucun ami en ligne."
L["Broadcast"] = "Message"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Échelle invalide.\nDoit être un nombre entre 70 et 200 %"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Définir une échelle d’infobulle personnalisée.\nEntrez une valeur entre 70 et 200 (%%)."
L["|cffffb366Ara|r Guild & Friends (%s)"] = "|cffffb366Ara|r Guilde et amis (%s)"
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
L["|cffaaaaffRestore default colors"] = "|cffaaaaffRétablir les couleurs par défaut"
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

