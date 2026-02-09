local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "esES" and SDT.cache.locale ~= "esMX" then
    return
end

-- ----------------------------
-- Global
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(vacío)"
L["(spacer)"] = "(espaciador)"
L["Display Font:"] = "Fuente:"
L["Font Settings"] = "Configuración de Fuente"
L["Font Size"] = "Tamaño de Fuente"
L["Font Outline"] = "Contorno de Fuente"
L["GOLD"] = "ORO"
L["Override Global Font"] = "Anular fuente global"
L["Override Text Color"] = "Anular color de texto"
L["Settings"] = "Opciones"
L["Frame Strata"] = "Estrato de marco"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "Establece el estrato de marco (capa) para este módulo. Los valores más altos aparecen sobre los valores más bajos."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "Establece el estrato de marco (capa) para este panel. Los módulos aparecerán en relación a esto. Los valores más altos aparecen sobre los valores más bajos."
L["Slot Controls"] = "Controles de Ranura"
L["Anchor Point"] = "Punto de Anclaje"
L["Set the anchor point for this module."] = "Establece el punto de anclaje para este módulo."
L["Yes"] = "Sí"
L["No"] = "No"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "Modo de depuración desactivado"
L["Debug Mode Enabled"] = "Modo de depuración activado"
L["Left Click to open settings"] = "Clic izquierdo para abrir opciones"
L["Lock/Unlock"] = "Bloquear/Desbloquear"
L["Minimap Icon Disabled"] = "Icono del minimapa desactivado"
L["Minimap Icon Enabled"] = "Icono del minimapa activado"
L["Not Defined"] = "No definido"
L["Toggle Minimap Icon"] = "Alternar icono del minimapa"
L["Usage"] = "Uso"
L["Version"] = "Versión"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "Error al comprimir los datos del perfil"
L["Error decoding import string"] = "Error al decodificar la cadena de importación"
L["Error decompressing data"] = "Error al descomprimir los datos"
L["Error deserializing profile data"] = "Error al deserializar los datos del perfil"
L["Error serializing profile data"] = "Error al serializar los datos del perfil"
L["Import data too large"] = "Datos de importación demasiado grandes"
L["Import data too large after decompression"] = "Datos de importación demasiado grandes después de la descompresión"
L["Import string is too large"] = "La cadena de importación es demasiado grande"
L["Importing profile from version %s"] = "Importando perfil de la versión %s"
L["Invalid import string format"] = "Formato de cadena de importación no válido"
L["Invalid profile data"] = "Datos de perfil inválidos"
L["Migrating old settings to new profile system..."] = "Migrando configuraciones antiguas al nuevo sistema de perfiles..."
L["Migration complete! All profiles have been migrated."] = "¡Migración completa! Todos los perfiles han sido migrados."
L["No import string provided"] = "No se proporcionó cadena de importación"
L["Profile imported successfully!"] = "¡Perfil importado con éxito!"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "Colores"
L["Custom Color"] = "Color Personalizado"
L["Enable Per-Spec Profiles"] = "Activar perfiles por especialización"
L["Global"] = "Global"
L["Global Settings"] = "Opciones Globales"
L["Hide Module Title in Tooltip"] = "Ocultar título del módulo en tooltip"
L["Lock Panels"] = "Bloquear Paneles"
L["Prevent panels from being moved"] = "Evitar que los paneles se muevan"
L["Show Login Message"] = "Mostrar mensaje de inicio"
L["Show Minimap Icon"] = "Mostrar ícono del minimapa"
L["Toggle the minimap button on or off"] = "Activar/desactivar el botón del minimapa"
L["Use 24Hr Clock"] = "Usar reloj de 24 horas"
L["Use Class Color"] = "Usar color de clase"
L["Use Custom Color"] = "Usar color personalizado"
L["X Offset"] = "Desplazamiento X"
L["Y Offset"] = "Desplazamiento Y"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "Cuando está activado, el addon cambiará automáticamente a un perfil diferente cada vez que cambies de especialización. Selecciona a continuación qué perfil debe usar cada especialización."

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "Apariencia"
L["Apply Slot Changes"] = "Aplicar cambios de ranura"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "¿Estás seguro de que deseas eliminar esta barra?\nEsta acción no se puede deshacer."
L["Background Opacity"] = "Opacidad de fondo"
L["Border Color"] = "Color del borde"
L["Border Size"] = "Tamaño del borde"
L["Create New Panel"] = "Crear nuevo panel"
L["Height"] = "Altura"
L["Number of Slots"] = "Número de ranuras"
L["Panel Settings"] = "Configuración del panel"
L["Panels"] = "Paneles"
L["Remove Selected Panel"] = "Eliminar panel seleccionado"
L["Rename Panel:"] = "Renombrar panel:"
L["Scale"] = "Escala"
L["Select Border:"] = "Seleccionar borde:"
L["Select Panel:"] = "Seleccionar panel:"
L["Size & Scale"] = "Tamaño y escala"
L["Slot Assignments"] = "Asignación de ranuras"
L["Slot %d:"] = "Ranura %d:"
L["Slots"] = "Ranuras"
L["Update slot assignment dropdowns after changing number of slots"] = "Actualizar los menús desplegables de asignación de ranuras después de cambiar el número de ranuras"
L["Width"] = "Ancho"

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "Configuración de Módulo"
L["Hide Decimals"] = "Ocultar decimales"
L["Show Label"] = "Mostrar etiqueta"
L["Show Short Label"] = "Mostrar etiqueta corta"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. Haz clic en 'Generar cadena de exportación' arriba\n2. Haz clic en este cuadro\n3. Presiona Ctrl+A para seleccionar todo\n4. Presiona Ctrl+C para copiar"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. Pega una cadena de importación en el cuadro de abajo\n2. Haz clic en Aceptar\n3. Haz clic en 'Importar Perfil'"
L["Create an export string for your current profile"] = "Crear una cadena de exportación para tu perfil actual"
L["Export"] = "Exportar"
L["Export String"] = "Cadena de exportación"
L["Export string generated! Copy it from the box below."] = "Cadena de exportación generada! Cópiala del cuadro de abajo."
L["Export your current profile to share with others, or import a profile string.\n"] = "Exporta tu perfil actual para compartirlo o importa una cadena de perfil.\n"
L["Generate Export String"] = "Generar cadena de exportación"
L["Import"] = "Importar"
L["Import/Export"] = "Importar/Exportar"
L["Import Profile"] = "Importar perfil"
L["Import String"] = "Cadena de importación"
L["Import the profile string from above (after clicking Accept)"] = "Importa la cadena de perfil de arriba (después de hacer clic en Aceptar)"
L["Please paste an import string and click Accept first"] = "Por favor, pega primero una cadena de importación y haz clic en Aceptar"
L["Profile Import/Export"] = "Importar/Exportar perfil"
L["This will overwrite your current profile. Are you sure?"] = "Esto sobrescribirá tu perfil actual. ¿Estás seguro?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "Paneles bloqueados"
L["Panels unlocked"] = "Paneles desbloqueados"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "Agi"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Mitigación por nivel:"
L["Level %d"] = "Nivel %d"
L["Target Mitigation"] = "Mitigación del objetivo"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "AP"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Bolsas"

-- ----------------------------
-- modules/CombatTime.lua
-- ----------------------------
L["Combat"] = "Combate"
L["combat duration"] = "duración del combate"
L["Current"] = "Actual"
L["Currently out of combat"] = "Actualmente fuera de combate"
L["Display Duration"] = "Duración de visualización"
L["Enter combat to start tracking"] = "Entra en combate para comenzar el seguimiento"
L["Last"] = "Último"
L["Left-click"] = "Clic izquierdo"
L["Out of Combat"] = "Fuera de combate"
L["to reset"] = "para restablecer"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "Crítico"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "MONEDAS"
L["Tracked Currency Qty"] = "Cantidad de Moneda Rastreada"
L["Currency Display Order"] = "Orden de Visualización de Moneda"
L["Position %d"] = "Posición %d"
L["Empty Slot"] = "Ranura Vacía"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "Dur:"
L["Durability:"] = "Durabilidad:"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "Nivel Máximo"
L["N/A"] = "N/D"
L["Experience"] = "Experiencia"
L["Display Format"] = "Formato de visualización"
L["Bar Toggles"] = "Opciones de barra"
L["Show Graphical Bar"] = "Mostrar barra gráfica"
L["Hide Blizzard XP Bar"] = "Ocultar barra de EXP de Blizzard"
L["Bar Appearance"] = "Apariencia de barra"
L["Bar Height (%)"] = "Altura de barra (%)"
L["Bar Use Class Color"] = "Usar color de clase para barra"
L["Bar Custom Color"] = "Color personalizado de barra"
L["Bar Texture"] = "Textura de barra"
L["Text Color"] = "Color de texto"
L["Text Use Class Color"] = "Usar color de clase para texto"
L["Text Custom Color"] = "Color personalizado de texto"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Objeto Ara Friends LDB no encontrado! Datatext SDT Friends deshabilitado."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "Mostrar plata"
L["Show Copper"] = "Mostrar cobre"
L["Use Coin Icons"] = "Usar iconos de monedas"
L["Display Quantities"] = "Mostrar cantidades"
L["Characters to Show"] = "Personajes a mostrar"
L["Servers to Show"] = "Servidores a mostrar"
L["Session:"] = "Sesión:"
L["Earned:"] = "Ganado:"
L["Spent:"] = "Gastado:"
L["Profit:"] = "Beneficio:"
L["Deficit:"] = "Déficit:"
L["Character:"] = "Personaje:"
L["Server:"] = "Servidor:"
L["Faction:"] = "Facción:"
L["Alliance:"] = "Alianza:"
L["Horde:"] = "Horda:"
L["Total:"] = "Total:"
L["Warband:"] = "Banda de Guerra:"
L["WoW Token:"] = "Token WoW:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Restablecer datos de sesión: Mantén Ctrl + clic derecho"
L["Gold: All data reset!"] = "Oro: ¡Todos los datos reiniciados!"
L["Gold: Data reset for %s!"] = "Oro: ¡Datos reiniciados para %s!"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "¿Estás seguro de que quieres eliminar los datos de oro para:\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000TODOS LOS PERSONAJES|r"
L["|cFF808080No character data found|r"] = "|cFF808080No se encontraron datos de personajes|r"
L["Reset Session Data:"] = "Reiniciar datos de sesión:"
L["Hold Shift + Right Click"] = "Mantener Mayús + Clic derecho"
L["Reset Character Gold Data:"] = "Reiniciar datos de oro del personaje:"
L["Hold Alt + Right Click"] = "Mantener Alt + Clic derecho"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Objeto Ara Guild LDB no encontrado! Datatext SDT Guild deshabilitado."
L["Max Guild Name Length"] = "Long. máx. nombre hermandad"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "Celeridad:"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "Piedra de hogar"
L["Selected Hearthstone"] = "Piedra de hogar seleccionada"
L["Random"] = "Aleatorio"
L["Selected:"] = "Seleccionado:"
L["Available Hearthstones:"] = "Piedras de hogar disponibles:"
L["Left Click: Use Hearthstone"] = "Clic izquierdo: Usar piedra de hogar"
L["Right Click: Select Hearthstone"] = "Clic derecho: Seleccionar piedra de hogar"
L["Cannot use hearthstone while in combat"] = "No se puede usar la piedra de hogar en combate"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "Int"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "SIN TEXTO"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "Correo nuevo"
L["No Mail"] = "Sin correo"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "Nombre del mapa"
L["Zone Name"] = "Nombre de zona"
L["Subzone Name"] = "Nombre de subzona"
L["Zone - Subzone"] = "Zona - Subzona"
L["Zone / Subzone (Two Lines)"] = "Zona / Subzona (Dos líneas)"
L["Minimap Zone"] = "Zona del minimapa"
L["Show Zone on Tooltip"] = "Mostrar zona en tooltip"
L["Show Coordinates on Tooltip"] = "Mostrar coordenadas en tooltip"
L["Zone:"] = "Zona:"
L["Subzone:"] = "Subzona:"
L["Coordinates:"] = "Coordenadas:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "Maestría:"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "Piedra angular mítica+"
L["No Mythic+ Keystone"] = "Sin piedra angular mítica+"
L["Current Key:"] = "Clave actual:"
L["Dungeon Teleport is on cooldown for "] = "El teletransporte a la mazmorra está en recarga durante "
L[" more seconds."] = " segundos más."
L["You do not know the teleport spell for "] = "No conoces el hechizo de teletransporte para "
L["Key: "] = "Clave: "
L["None"] = "Ninguno"
L["No Key"] = "Sin clave"
L["Left Click: Teleport to Dungeon"] = "Clic izquierdo: Teletransportar a la mazmorra"
L["Right Click: List Group in Finder"] = "Clic derecho: Listar grupo en el buscador"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Activo"
L["Inactive"] = "Inactivo"
L["Loadouts"] = "Loadouts"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Error al cargar Blizzard_PlayerSpells: %s"
L["Starter Build"] = "Build inicial"
L["Spec"] = "Espec."
L["Left Click: Change Talent Specialization"] = "Clic izquierdo: Cambiar especialización"
L["Control + Left Click: Change Loadout"] = "Ctrl + clic izquierdo: Cambiar Loadout"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + clic izquierdo: Mostrar UI de especialización"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + clic derecho: Cambiar especialización de botín"
L["Show Specialization Icon"] = "Mostrar icono de especialización"
L["Show Specialization Text"] = "Mostrar texto de especialización"
L["Show Loot Specialization Icon"] = "Mostrar icono de especialización de botín"
L["Show Loot Specialization Text"] = "Mostrar texto de especialización de botín"
L["Show Loadout"] = "Mostrar configuración"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "Velocidad: "

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "Str"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "mb"
L["KB_SUFFIX"] = "kb"
L["SYSTEM"] = "SISTEMA"
L["FPS:"] = "FPS:"
L["Home Latency:"] = "Latencia local:"
L["World Latency:"] = "Latencia mundial:"
L["Total Memory:"] = "Memoria total:"
L["(Shift Click) Collect Garbage"] = "(Shift + clic) Liberar memoria"
L["FPS"] = "FPS"
L["MS"] = "MS"
L["Top Addons by Memory:"] = "Top de addons por memoria:"
L["Top Addons in Tooltip"] = "Mejores addons en tooltip"
L["Total CPU:"] = "CPU total:"
L["Top Addons by CPU:"] = "Principales addons por CPU:"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "TIEMPO"
L["Saved Raid(s)"] = "Banda(s) guardada(s)"
L["Saved Dungeon(s)"] = "Mazmorra(s) guardada(s)"
L["Display Realm Time"] = "Mostrar hora del reino"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "Vers:"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Seleccionar flujo de audio"
L["Toggle Volume Stream"] = "Alternar flujo de audio"
L["Output Audio Device"] = "Dispositivo de salida"
L["Active Output Audio Device"] = "Dispositivo de salida activo"
L["Volume Streams"] = "Flujos de audio"
L["Left Click: Select Volume Stream"] = "Clic izquierdo: Seleccionar flujo"
L["Middle Click: Toggle Mute Master Stream"] = "Clic central: Silenciar flujo principal"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + clic central: Alternar flujo"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + clic izquierdo: Abrir panel de audio del sistema"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + clic derecho: Seleccionar dispositivo de salida"
L["M. Vol"] = "Vol. Pr"
L["FX"] = "Efec"
L["Amb"] = "Amb"
L["Dlg"] = "Diá"
L["Mus"] = "Mús"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Hermandad"
L["No Guild"] = "Sin hermandad"
L["Friends"] = "Amigos"
L["<Mobile>"] = "<Móvil>"
L["Hints"] = "Sugerencias"
L["Block"] = "Bloquear"
L["Click"] = "Clic"
L["RightClick"] = "Clic derecho"
L["MiddleClick"] = "Clic central"
L["Modifier+Click"] = "Modificador+clic"
L["Shift+Click"] = "Shift+clic"
L["Shift+RightClick"] = "Shift+clic derecho"
L["Ctrl+Click"] = "Ctrl+clic"
L["Ctrl+RightClick"] = "Ctrl+clic derecho"
L["Alt+RightClick"] = "Alt+clic derecho"
L["Ctrl+MouseWheel"] = "Ctrl+rueda del ratón"
L["Button4"] = "Botón4"
L["to open panel."] = "para abrir el panel."
L["to display config menu."] = "para mostrar el menú de configuración."
L["to add a friend."] = "para agregar un amigo."
L["to toggle notes."] = "para alternar notas."
L["to whisper."] = "para susurrar."
L["to invite."] = "para invitar."
L["to query information."] = "para consultar información."
L["to edit note."] = "para editar nota."
L["to edit officer note."] = "para editar nota de oficial."
L["to remove friend."] = "para eliminar amigo."
L["to sort main column."] = "para ordenar columna principal."
L["to sort second column."] = "para ordenar segunda columna."
L["to sort third column."] = "para ordenar tercera columna."
L["to resize tooltip."] = "para redimensionar tooltip."
L["Mobile App"] = "App móvil"
L["Desktop App"] = "App de escritorio"
L["OFFLINE FAVORITE"] = "FAVORITO DESCONECTADO"
L["MOTD"] = "MOTD"
L["No friends online."] = "No hay amigos en línea."
L["Broadcast"] = "Transmisión"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Escala inválida.\nDebe estar entre 70 y 200%"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Configurar escala personalizada del tooltip.\nIngresa un valor entre 70 y 200 (%%)."
L["Guild & Friends"] = "Hermandad y amigos"
L["Show guild name"] = "Mostrar nombre de hermandad"
L["Show 'Guild' tag"] = "Mostrar etiqueta 'Hermandad'"
L["Show total number of guildmates"] = "Mostrar número total de miembros"
L["Show 'Friends' tag"] = "Mostrar etiqueta 'Amigos'"
L["Show total number of friends"] = "Mostrar número total de amigos"
L["Show guild XP"] = "Mostrar XP de hermandad"
L["Show guild XP tooltip"] = "Mostrar tooltip de XP de hermandad"
L["Show own broadcast"] = "Mostrar transmisión propia"
L["Show bnet friends broadcast"] = "Mostrar transmisión de amigos de bnet"
L["Show guild notes"] = "Mostrar notas de hermandad"
L["Show friend notes"] = "Mostrar notas de amigos"
L["Show class icon when grouped"] = "Mostrar icono de clase en grupo"
L["Highlight sorted column"] = "Resaltar columna ordenada"
L["Simple"] = "Simple"
L["Gradient"] = "Degradado"
L["Reverse gradient"] = "Invertir degradado"
L["Status as..."] = "Estado como..."
L["Class colored text"] = "Texto con color de clase"
L["Custom colored text"] = "Texto con color personalizado"
L["Icon"] = "Icono"
L["Real ID..."] = "Real ID..."
L["Before nickname"] = "Antes del apodo"
L["Instead of nickname"] = "En lugar del apodo"
L["After nickname"] = "Después del apodo"
L["Don't show"] = "No mostrar"
L["Column alignments"] = "Alineación de columnas"
L["Name"] = "Nombre"
L["Zone"] = "Zona"
L["Notes"] = "Notas"
L["Rank"] = "Rango"
L["Tooltip Size"] = "Tamaño del tooltip"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Personalizado..."
L["Use TipTac skin (requires TipTac)"] = "Usar skin TipTac (requiere TipTac)"
L["Colors"] = "Colores"
L["Background"] = "Fondo"
L["Borders"] = "Bordes"
L["Order highlight"] = "Resaltar orden"
L["Headers"] = "Encabezados"
L["MotD / broadcast"] = "MotD / transmisión"
L["Friendly zone"] = "Zona amistosa"
L["Contested zone"] = "Zona disputada"
L["Enemy zone"] = "Zona enemiga"
L["Officer notes"] = "Notas de oficiales"
L["Status"] = "Estado"
L["Ranks"] = "Rangos"
L["Friends broadcast"] = "Transmisión de amigos"
L["Realms"] = "Reinos"
L["Restore default colors"] = "Restaurar colores por defecto"
L["Show Block Hints"] = "Mostrar sugerencias de bloque"
L["Open panel"] = "Abrir panel"
L["Config menu"] = "Menú de configuración"
L["Toggle notes"] = "Alternar notas"
L["Add a friend"] = "Agregar amigo"
L["Show Hints"] = "Mostrar sugerencias"
L["Whisper"] = "Susurrar"
L["Invite"] = "Invitar"
L["Query"] = "Consultar"
L["Edit note"] = "Editar nota"
L["Edit officer note"] = "Editar nota de oficial"
L["Sort main column"] = "Ordenar columna principal"
L["Sort second column"] = "Ordenar segunda columna"
L["Sort third column"] = "Ordenar tercera columna"
L["Resize tooltip"] = "Redimensionar tooltip"
L["Remove friend"] = "Eliminar amigo"
