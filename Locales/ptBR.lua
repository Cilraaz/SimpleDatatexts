local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "ptBR" then
    return
end

-- ----------------------------
-- Global
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(vazio)"
L["(spacer)"] = "(espaço)"
L["Display Font:"] = "Fonte:"
L["Font Settings"] = "Configurações de Fonte"
L["Font Size"] = "Tamanho da Fonte"
L["Font Outline"] = "Contorno da Fonte"
L["GOLD"] = "OURO"
L["Override Global Font"] = "Substituir fonte global"
L["Override Text Color"] = "Substituir cor do texto"
L["Settings"] = "Configurações"
L["Frame Strata"] = "Estrato de quadro"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "Define o estrato de quadro (camada) para este módulo. Valores mais altos aparecem acima de valores mais baixos."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "Define o estrato de quadro (camada) para este painel. Os módulos aparecerão em relação a isto. Valores mais altos aparecem acima de valores mais baixos."
L["Slot Controls"] = "Controles de Slot"
L["Anchor Point"] = "Ponto de Ancoragem"
L["Set the anchor point for this module."] = "Define o ponto de ancoragem para este módulo."
L["Yes"] = "Sim"
L["No"] = "Não"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "Modo de depuração desativado"
L["Debug Mode Enabled"] = "Modo de depuração ativado"
L["Left Click to open settings"] = "Clique esquerdo para abrir as configurações"
L["Lock/Unlock"] = "Bloquear/Desbloquear"
L["Minimap Icon Disabled"] = "Ícone do minimapa desativado"
L["Minimap Icon Enabled"] = "Ícone do minimapa ativado"
L["Not Defined"] = "Não definido"
L["Toggle Minimap Icon"] = "Alternar ícone do minimapa"
L["Usage"] = "Uso"
L["Version"] = "Versão"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "Erro ao comprimir os dados do perfil"
L["Error decoding import string"] = "Erro ao decodificar a string de importação"
L["Error decompressing data"] = "Erro ao descomprimir os dados"
L["Error deserializing profile data"] = "Erro ao desserializar os dados do perfil"
L["Error serializing profile data"] = "Erro ao serializar os dados do perfil"
L["Import data too large"] = "Dados de importação muito grandes"
L["Import data too large after decompression"] = "Dados de importação muito grandes após descompressão"
L["Import string is too large"] = "A string de importação é muito grande"
L["Importing profile from version %s"] = "Importando perfil da versão %s"
L["Invalid import string format"] = "Formato de string de importação inválido"
L["Invalid profile data"] = "Dados do perfil inválidos"
L["Migrating old settings to new profile system..."] = "Migrando configurações antigas para o novo sistema de perfis..."
L["Migration complete! All profiles have been migrated."] = "Migração completa! Todos os perfis foram migrados."
L["No import string provided"] = "Nenhuma string de importação fornecida"
L["Profile imported successfully!"] = "Perfil importado com sucesso!"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "Cores"
L["Custom Color"] = "Cor Personalizada"
L["Enable Per-Spec Profiles"] = "Ativar perfis por especialização"
L["Global"] = "Global"
L["Global Settings"] = "Configurações Globais"
L["Hide Module Title in Tooltip"] = "Ocultar título do módulo no tooltip"
L["Lock Panels"] = "Bloquear Painéis"
L["Prevent panels from being moved"] = "Evitar que os painéis se movam"
L["Show Login Message"] = "Mostrar mensagem de login"
L["Show Minimap Icon"] = "Mostrar ícone do minimapa"
L["Toggle the minimap button on or off"] = "Ativar/desativar botão do minimapa"
L["Use 24Hr Clock"] = "Usar relógio 24h"
L["Use Class Color"] = "Usar cor da classe"
L["Use Custom Color"] = "Usar cor personalizada"
L["X Offset"] = "Deslocamento X"
L["Y Offset"] = "Deslocamento Y"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "Quando ativado, o addon mudará automaticamente para um perfil diferente toda vez que você alterar a especialização. Escolha abaixo qual perfil cada especialização deve usar."

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "Aparência"
L["Apply Slot Changes"] = "Aplicar alterações de slot"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Tem certeza de que deseja excluir esta barra?\nEsta ação não pode ser desfeita."
L["Background Opacity"] = "Opacidade de fundo"
L["Border Color"] = "Cor da borda"
L["Border Size"] = "Tamanho da borda"
L["Create New Panel"] = "Criar novo painel"
L["Height"] = "Altura"
L["Number of Slots"] = "Número de slots"
L["Panel Settings"] = "Configurações do painel"
L["Panels"] = "Painéis"
L["Remove Selected Panel"] = "Remover painel selecionado"
L["Rename Panel:"] = "Renomear painel:"
L["Scale"] = "Escala"
L["Select Border:"] = "Selecionar borda:"
L["Select Panel:"] = "Selecionar painel:"
L["Size & Scale"] = "Tamanho & Escala"
L["Slot Assignments"] = "Atribuição de slots"
L["Slot %d:"] = "Slot %d:"
L["Slots"] = "Slots"
L["Update slot assignment dropdowns after changing number of slots"] = "Atualizar dropdowns de slots após alterar o número de slots"
L["Width"] = "Largura"

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "Configurações do Módulo"
L["Hide Decimals"] = "Ocultar casas decimais"
L["Show Label"] = "Mostrar rótulo"
L["Show Short Label"] = "Mostrar rótulo curto"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. Clique em 'Gerar String de Exportação' acima\n2. Clique nesta caixa\n3. Pressione Ctrl+A para selecionar tudo\n4. Pressione Ctrl+C para copiar"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. Cole uma string de importação na caixa abaixo\n2. Clique em Aceitar\n3. Clique em 'Importar Perfil'"
L["Create an export string for your current profile"] = "Criar uma string de exportação para seu perfil atual"
L["Export"] = "Exportar"
L["Export String"] = "String de exportação"
L["Export string generated! Copy it from the box below."] = "String de exportação gerada! Copie-a da caixa abaixo."
L["Export your current profile to share with others, or import a profile string.\n"] = "Exporte seu perfil atual para compartilhar ou importe uma string de perfil.\n"
L["Generate Export String"] = "Gerar String de Exportação"
L["Import"] = "Importar"
L["Import/Export"] = "Importar/Exportar"
L["Import Profile"] = "Importar Perfil"
L["Import String"] = "String de Importação"
L["Import the profile string from above (after clicking Accept)"] = "Importe a string de perfil de cima (após clicar Aceitar)"
L["Please paste an import string and click Accept first"] = "Cole primeiro uma string de importação e clique em Aceitar"
L["Profile Import/Export"] = "Importar/Exportar Perfil"
L["This will overwrite your current profile. Are you sure?"] = "Isso irá sobrescrever seu perfil atual. Tem certeza?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "Painéis bloqueados"
L["Panels unlocked"] = "Painéis desbloqueados"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "Agi"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Mitigação por nível:"
L["Level %d"] = "Nível %d"
L["Target Mitigation"] = "Mitigação do alvo"

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
L["combat duration"] = "duração do combate"
L["Current"] = "Atual"
L["Currently out of combat"] = "Atualmente fora de combate"
L["Display Duration"] = "Duração da exibição"
L["Enter combat to start tracking"] = "Entre em combate para iniciar o rastreamento"
L["Last"] = "Último"
L["Left-click"] = "Clique esquerdo"
L["Out of Combat"] = "Fora de combate"
L["to reset"] = "para redefinir"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "Crítico"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "MOEDAS"
L["Tracked Currency Qty"] = "Qtd. de Moeda Rastreada"
L["Currency Display Order"] = "Ordem de Exibição de Moeda"
L["Position %d"] = "Posição %d"
L["Empty Slot"] = "Espaço Vazio"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "Dur:"
L["Durability:"] = "Durabilidade:"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "Nível Máximo"
L["N/A"] = "N/D"
L["Experience"] = "Experiência"
L["Display Format"] = "Formato de exibição"
L["Bar Toggles"] = "Opções de barra"
L["Show Graphical Bar"] = "Mostrar barra gráfica"
L["Hide Blizzard XP Bar"] = "Ocultar barra de EXP da Blizzard"
L["Bar Appearance"] = "Aparência da barra"
L["Bar Height (%)"] = "Altura da barra (%)"
L["Bar Use Class Color"] = "Usar cor de classe para barra"
L["Bar Custom Color"] = "Cor personalizada da barra"
L["Bar Texture"] = "Textura da barra"
L["Text Color"] = "Cor do texto"
L["Text Use Class Color"] = "Usar cor de classe para texto"
L["Text Custom Color"] = "Cor personalizada do texto"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Objeto LDB Ara Friends não encontrado! Datatext Amigos SDT desativado."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "Mostrar prata"
L["Show Copper"] = "Mostrar cobre"
L["Use Coin Icons"] = "Usar ícones de moedas"
L["Display Quantities"] = "Exibir quantidades"
L["Characters to Show"] = "Personagens a exibir"
L["Servers to Show"] = "Servidores a exibir"
L["Session:"] = "Sessão:"
L["Earned:"] = "Ganho:"
L["Spent:"] = "Gasto:"
L["Profit:"] = "Lucro:"
L["Deficit:"] = "Déficit:"
L["Character:"] = "Personagem:"
L["Server:"] = "Servidor:"
L["Faction:"] = "Facção:"
L["Alliance:"] = "Aliança:"
L["Horde:"] = "Horda:"
L["Total:"] = "Total:"
L["Warband:"] = "Grupo de guerra:"
L["WoW Token:"] = "Token WoW:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Redefinir dados da sessão: Segure Ctrl + clique direito"
L["Gold: All data reset!"] = "Ouro: Todos os dados redefinidos!"
L["Gold: Data reset for %s!"] = "Ouro: Dados redefinidos para %s!"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "Tem certeza de que deseja excluir os dados de ouro para:\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000TODOS OS PERSONAGENS|r"
L["|cFF808080No character data found|r"] = "|cFF808080Nenhum dado de personagem encontrado|r"
L["Reset Session Data:"] = "Redefinir dados da sessão:"
L["Hold Shift + Right Click"] = "Manter Shift + Botão direito"
L["Reset Character Gold Data:"] = "Redefinir dados de ouro do personagem:"
L["Hold Alt + Right Click"] = "Manter Alt + Botão direito"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Objeto LDB Ara Guild não encontrado! Datatext Guilda SDT desativado."
L["Max Guild Name Length"] = "Tam. máx. nome da guilda"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "Aceleração:"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "Pedra de Regresso"
L["Selected Hearthstone"] = "Pedra de Regresso Selecionada"
L["Random"] = "Aleatório"
L["Selected:"] = "Selecionado:"
L["Available Hearthstones:"] = "Pedras de Regresso Disponíveis:"
L["Left Click: Use Hearthstone"] = "Clique Esquerdo: Usar Pedra de Regresso"
L["Right Click: Select Hearthstone"] = "Clique Direito: Selecionar Pedra de Regresso"
L["Cannot use hearthstone while in combat"] = "Não é possível usar a pedra de regresso em combate"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "Int"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "SEM TEXTO"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "Nova mensagem"
L["No Mail"] = "Sem mensagens"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "Nome do mapa"
L["Zone Name"] = "Nome da zona"
L["Subzone Name"] = "Nome da subzona"
L["Zone - Subzone"] = "Zona - Subzona"
L["Zone / Subzone (Two Lines)"] = "Zona / Subzona (Duas linhas)"
L["Minimap Zone"] = "Zona do minimapa"
L["Show Zone on Tooltip"] = "Mostrar zona no tooltip"
L["Show Coordinates on Tooltip"] = "Mostrar coordenadas no tooltip"
L["Zone:"] = "Zona:"
L["Subzone:"] = "Subzona:"
L["Coordinates:"] = "Coordenadas:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "Maestria:"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "Pedra-chave mítica+"
L["No Mythic+ Keystone"] = "Sem pedra-chave mítica+"
L["Current Key:"] = "Chave atual:"
L["Dungeon Teleport is on cooldown for "] = "O teletransporte para a masmorra está em recarga por "
L[" more seconds."] = " segundos a mais."
L["You do not know the teleport spell for "] = "Você não conhece o feitiço de teletransporte para "
L["Key: "] = "Chave: "
L["None"] = "Nenhum"
L["No Key"] = "Sem chave"
L["Left Click: Teleport to Dungeon"] = "Clique esquerdo: Teletransportar para a masmorra"
L["Right Click: List Group in Finder"] = "Clique direito: Listar grupo no localizador"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Ativo"
L["Inactive"] = "Inativo"
L["Loadouts"] = "Configurações"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Falha ao carregar Blizzard_PlayerSpells: %s"
L["Starter Build"] = "Build inicial"
L["Spec"] = "Spec"
L["Left Click: Change Talent Specialization"] = "Clique esquerdo: alterar especialização de talentos"
L["Control + Left Click: Change Loadout"] = "Ctrl + clique esquerdo: alterar configuração"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + clique esquerdo: mostrar interface de especialização"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + clique direito: alterar especialização de saque"
L["Show Specialization Icon"] = "Mostrar ícone de especialização"
L["Show Specialization Text"] = "Mostrar texto de especialização"
L["Show Loot Specialization Icon"] = "Mostrar ícone de especialização de saque"
L["Show Loot Specialization Text"] = "Mostrar texto de especialização de saque"
L["Show Loadout"] = "Mostrar configuração"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "Velocidade: "

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
L["Home Latency:"] = "Latência local:"
L["World Latency:"] = "Latência global:"
L["Total Memory:"] = "Memória total:"
L["(Shift Click) Collect Garbage"] = "(Shift + Clique) Limpar memória"
L["FPS"] = "FPS"
L["MS"] = "MS"
L["Top Addons by Memory:"] = "Top de addons por memória:"
L["Top Addons in Tooltip"] = "Melhores addons no tooltip"
L["Total CPU:"] = "CPU total:"
L["Top Addons by CPU:"] = "Principais addons por CPU:"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "TEMPO"
L["Saved Raid(s)"] = "Raids salvos"
L["Saved Dungeon(s)"] = "Masmorras salvas"
L["Display Realm Time"] = "Exibir horário do reino"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "Vers:"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Selecionar stream de volume"
L["Toggle Volume Stream"] = "Ativar/desativar stream de volume"
L["Output Audio Device"] = "Dispositivo de áudio de saída"
L["Active Output Audio Device"] = "Dispositivo de áudio de saída ativo"
L["Volume Streams"] = "Streams de volume"
L["Left Click: Select Volume Stream"] = "Clique esquerdo: selecionar stream de volume"
L["Middle Click: Toggle Mute Master Stream"] = "Clique do meio: silenciar stream principal"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + clique do meio: ativar/desativar stream de volume"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + clique esquerdo: abrir painel de áudio do sistema"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + clique direito: selecionar dispositivo de saída de áudio"
L["M. Vol"] = "Vol. Pr"
L["FX"] = "Efeit"
L["Amb"] = "Amb"
L["Dlg"] = "Diál"
L["Mus"] = "Mús"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Guilda"
L["No Guild"] = "Sem guilda"
L["Friends"] = "Amigos"
L["<Mobile>"] = "<Mobile>"
L["Hints"] = "Dicas"
L["Block"] = "Bloquear"
L["Click"] = "Clique"
L["RightClick"] = "Clique direito"
L["MiddleClick"] = "Clique do meio"
L["Modifier+Click"] = "Modificador+Clique"
L["Shift+Click"] = "Shift+Clique"
L["Shift+RightClick"] = "Shift+Clique direito"
L["Ctrl+Click"] = "Ctrl+Clique"
L["Ctrl+RightClick"] = "Ctrl+Clique direito"
L["Alt+RightClick"] = "Alt+Clique direito"
L["Ctrl+MouseWheel"] = "Ctrl+Roda do mouse"
L["Button4"] = "Botão4"
L["to open panel."] = "para abrir o painel."
L["to display config menu."] = "para exibir o menu de configuração."
L["to add a friend."] = "para adicionar um amigo."
L["to toggle notes."] = "para mostrar/ocultar notas."
L["to whisper."] = "para sussurrar."
L["to invite."] = "para convidar."
L["to query information."] = "para consultar informações."
L["to edit note."] = "para editar nota."
L["to edit officer note."] = "para editar nota de oficial."
L["to remove friend."] = "para remover amigo."
L["to sort main column."] = "para ordenar coluna principal."
L["to sort second column."] = "para ordenar segunda coluna."
L["to sort third column."] = "para ordenar terceira coluna."
L["to resize tooltip."] = "para redimensionar tooltip."
L["Mobile App"] = "App móvel"
L["Desktop App"] = "App desktop"
L["OFFLINE FAVORITE"] = "FAVORITO OFFLINE"
L["MOTD"] = "MdD"
L["No friends online."] = "Nenhum amigo online."
L["Broadcast"] = "Broadcast"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Escala inválida.\nDeve ser um número entre 70 e 200%"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Defina uma escala de tooltip personalizada.\nInsira um valor entre 70 e 200 (%%)."
L["Guild & Friends"] = "Guilda e amigos"
L["Show guild name"] = "Mostrar nome da guilda"
L["Show 'Guild' tag"] = "Mostrar etiqueta 'Guilda'"
L["Show total number of guildmates"] = "Mostrar número total de membros da guilda"
L["Show 'Friends' tag"] = "Mostrar etiqueta 'Amigos'"
L["Show total number of friends"] = "Mostrar número total de amigos"
L["Show guild XP"] = "Mostrar XP da guilda"
L["Show guild XP tooltip"] = "Mostrar tooltip de XP da guilda"
L["Show own broadcast"] = "Mostrar seu broadcast"
L["Show bnet friends broadcast"] = "Mostrar broadcast de amigos Battle.net"
L["Show guild notes"] = "Mostrar notas da guilda"
L["Show friend notes"] = "Mostrar notas de amigos"
L["Show class icon when grouped"] = "Mostrar ícone da classe em grupo"
L["Highlight sorted column"] = "Destacar coluna ordenada"
L["Simple"] = "Simples"
L["Gradient"] = "Gradiente"
L["Reverse gradient"] = "Gradiente invertido"
L["Status as..."] = "Status como..."
L["Class colored text"] = "Texto colorido por classe"
L["Custom colored text"] = "Texto com cor personalizada"
L["Icon"] = "Ícone"
L["Real ID..."] = "ID real..."
L["Before nickname"] = "Antes do apelido"
L["Instead of nickname"] = "No lugar do apelido"
L["After nickname"] = "Depois do apelido"
L["Don't show"] = "Não mostrar"
L["Column alignments"] = "Alinhamento das colunas"
L["Name"] = "Nome"
L["Zone"] = "Zona"
L["Notes"] = "Notas"
L["Rank"] = "Rank"
L["Tooltip Size"] = "Tamanho do tooltip"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Personalizado..."
L["Use TipTac skin (requires TipTac)"] = "Usar skin TipTac (requer TipTac)"
L["Colors"] = "Cores"
L["Background"] = "Fundo"
L["Borders"] = "Bordas"
L["Order highlight"] = "Destacar ordenação"
L["Headers"] = "Cabeçalhos"
L["MotD / broadcast"] = "MdD / broadcast"
L["Friendly zone"] = "Zona amiga"
L["Contested zone"] = "Zona contestada"
L["Enemy zone"] = "Zona inimiga"
L["Officer notes"] = "Notas de oficial"
L["Status"] = "Status"
L["Ranks"] = "Ranks"
L["Friends broadcast"] = "Broadcast de amigos"
L["Realms"] = "Reinos"
L["Restore default colors"] = "Restaurar cores padrão"
L["Show Block Hints"] = "Mostrar dicas do bloco"
L["Open panel"] = "Abrir painel"
L["Config menu"] = "Menu de configuração"
L["Toggle notes"] = "Mostrar/ocultar notas"
L["Add a friend"] = "Adicionar amigo"
L["Show Hints"] = "Mostrar dicas"
L["Whisper"] = "Sussurrar"
L["Invite"] = "Convidar"
L["Query"] = "Consultar"
L["Edit note"] = "Editar nota"
L["Edit officer note"] = "Editar nota de oficial"
L["Sort main column"] = "Ordenar coluna principal"
L["Sort second column"] = "Ordenar segunda coluna"
L["Sort third column"] = "Ordenar terceira coluna"
L["Resize tooltip"] = "Redimensionar tooltip"
L["Remove friend"] = "Remover amigo"
