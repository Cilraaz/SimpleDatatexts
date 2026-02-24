local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "ruRU" then
    return
end

-- ----------------------------
-- Global
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(пусто)"
L["(spacer)"] = "(пробел)"
L["Display Font:"] = "Шрифт:"
L["Font Settings"] = "Настройки шрифта"
L["Font Size"] = "Размер шрифта"
L["Font Outline"] = "Контур шрифта"
L["GOLD"] = "ЗОЛОТО"
L["Override Global Font"] = "Переопределить глобальный шрифт"
L["Override Text Color"] = "Переопределить цвет текста"
L["Settings"] = "Настройки"
L["Frame Strata"] = "Слой фрейма"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "Устанавливает слой фрейма для этого модуля. Более высокие значения отображаются над более низкими значениями."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "Устанавливает слой фрейма для этой панели. Модули будут отображаться относительно этого. Более высокие значения отображаются над более низкими значениями."
L["Slot Controls"] = "Управление слотами"
L["Anchor Point"] = "Точка привязки"
L["Set the anchor point for this module."] = "Устанавливает точку привязки для этого модуля."
L["Yes"] = "Да"
L["No"] = "Нет"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "Режим отладки отключён"
L["Debug Mode Enabled"] = "Режим отладки включён"
L["Left Click to open settings"] = "Левый клик для открытия настроек"
L["Lock/Unlock"] = "Заблокировать/Разблокировать"
L["Minimap Icon Disabled"] = "Иконка на миникарте отключена"
L["Minimap Icon Enabled"] = "Иконка на миникарте включена"
L["Not Defined"] = "Не определено"
L["Toggle Minimap Icon"] = "Переключить иконку на миникарте"
L["Usage"] = "Использование"
L["Version"] = "Версия"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "Ошибка сжатия данных профиля"
L["Error decoding import string"] = "Ошибка декодирования строки импорта"
L["Error decompressing data"] = "Ошибка распаковки данных"
L["Error deserializing profile data"] = "Ошибка десериализации данных профиля"
L["Error serializing profile data"] = "Ошибка сериализации данных профиля"
L["Import data too large"] = "Данные импорта слишком большие"
L["Import data too large after decompression"] = "Данные импорта слишком большие после распаковки"
L["Import string is too large"] = "Строка импорта слишком большая"
L["Importing profile from version %s"] = "Импорт профиля из версии %s"
L["Invalid import string format"] = "Неверный формат строки импорта"
L["Invalid profile data"] = "Недопустимые данные профиля"
L["Migrating old settings to new profile system..."] = "Миграция старых настроек в новую систему профилей..."
L["Migration complete! All profiles have been migrated."] = "Миграция завершена! Все профили были перенесены."
L["No import string provided"] = "Строка импорта не предоставлена"
L["Profile imported successfully!"] = "Профиль успешно импортирован!"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "Цвета"
L["Custom Color"] = "Пользовательский цвет"
L["Enable Per-Spec Profiles"] = "Включить профили для специализаций"
L["Global"] = "Глобально"
L["Global Settings"] = "Глобальные настройки"
L["Hide Module Title in Tooltip"] = "Скрыть название модуля в подсказке"
L["Lock Panels"] = "Заблокировать панели"
L["Prevent panels from being moved"] = "Запретить перемещение панелей"
L["Show Login Message"] = "Показать сообщение при входе"
L["Show Minimap Icon"] = "Показать значок на миникарте"
L["Toggle the minimap button on or off"] = "Включить/выключить кнопку на миникарте"
L["Use 24Hr Clock"] = "Использовать 24-часовой формат"
L["Use Class Color"] = "Использовать цвет класса"
L["Use Custom Color"] = "Использовать пользовательский цвет"
L["X Offset"] = "Смещение по X"
L["Y Offset"] = "Смещение по Y"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "Когда включено, аддон будет автоматически переключаться на другой профиль каждый раз при смене специализации. Выберите ниже, какой профиль использовать для каждой специализации."
L["Enable Font Text Shadow"] = "Включить тень текста шрифта"
L["Add a subtle shadow to datatexts for better readability"] = "Добавляет тонкую тень к текстам данных для лучшей читаемости"
L["Enable Tooltip Text Shadow"] = "Включить тень текста"
L["Add a subtle shadow to tooltip text for better readability"] = "Добавляет тонкую тень к тексту для лучшей читаемости"
L["Tooltip Settings"] = "Настройки подсказок"
L["Tooltip Font"] = "Шрифт подсказок"
L["Font used for all addon tooltips"] = "Шрифт для всех подсказок аддона"
L["Tooltip Font Outline"] = "Контур шрифта подсказок"
L["Font outline for all addon tooltips"] = "Контур шрифта для всех подсказок аддона"
L["Tooltip Header Font Size"] = "Размер шрифта заголовка"
L["Font size for tooltip headers"] = "Размер шрифта для заголовков подсказок"
L["Tooltip Line Font Size"] = "Размер шрифта строки"
L["Font size for tooltip content lines"] = "Размер шрифта для строк содержимого"
L["Show All Panels"] = "Показать все панели"
L["Toggle visibility of all panels. Individual panels can also be hidden in their own settings."] = "Переключить видимость всех панелей. Отдельные панели также можно скрыть в их собственных настройках."
L["Panels shown"] = "Панели показаны"
L["Panels hidden"] = "Панели скрыты"
L["Toggle All Panels"] = "Переключить все панели"

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "Внешний вид"
L["Apply Slot Changes"] = "Применить изменения слотов"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "Вы уверены, что хотите удалить эту панель?\nЭту операцию нельзя отменить."
L["Background Opacity"] = "Прозрачность фона"
L["Border Color"] = "Цвет рамки"
L["Border Size"] = "Размер рамки"
L["Create New Panel"] = "Создать новую панель"
L["Height"] = "Высота"
L["Number of Slots"] = "Количество слотов"
L["Panel Settings"] = "Настройки панели"
L["Panels"] = "Панели"
L["Remove Selected Panel"] = "Удалить выбранную панель"
L["Rename Panel:"] = "Переименовать панель:"
L["Scale"] = "Масштаб"
L["Select Border:"] = "Выбрать рамку:"
L["Select Panel:"] = "Выбрать панель:"
L["Size & Scale"] = "Размер и масштаб"
L["Slot Assignments"] = "Назначение слотов"
L["Slot %d:"] = "Слот %d:"
L["Slots"] = "Слоты"
L["Update slot assignment dropdowns after changing number of slots"] = "Обновить выпадающие списки после изменения числа слотов"
L["Width"] = "Ширина"
L["Hide Panel"] = "Скрыть панель"
L["Hide this panel. Panels are always visible while unlocked."] = "Скрыть эту панель. Панели всегда видны, пока они разблокированы."

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "Настройки модуля"
L["Hide Decimals"] = "Скрыть десятичные знаки"
L["Show Label"] = "Показывать метку"
L["Show Short Label"] = "Показывать краткую метку"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. Нажмите 'Сгенерировать строку экспорта' выше\n2. Кликните в это поле\n3. Нажмите Ctrl+A, чтобы выбрать всё\n4. Нажмите Ctrl+C, чтобы скопировать"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. Вставьте строку импорта в поле ниже\n2. Нажмите Принять\n3. Нажмите 'Импортировать профиль'"
L["Create an export string for your current profile"] = "Создать строку экспорта для вашего текущего профиля"
L["Export"] = "Экспорт"
L["Export String"] = "Строка экспорта"
L["Export string generated! Copy it from the box below."] = "Строка экспорта создана! Скопируйте её из поля ниже."
L["Export your current profile to share with others, or import a profile string.\n"] = "Экспортируйте текущий профиль для обмена или импортируйте строку профиля.\n"
L["Generate Export String"] = "Сгенерировать строку экспорта"
L["Import"] = "Импорт"
L["Import/Export"] = "Импорт/Экспорт"
L["Import Profile"] = "Импортировать профиль"
L["Import String"] = "Строка импорта"
L["Import the profile string from above (after clicking Accept)"] = "Импортируйте строку профиля сверху (после нажатия Принять)"
L["Please paste an import string and click Accept first"] = "Пожалуйста, сначала вставьте строку импорта и нажмите Принять"
L["Profile Import/Export"] = "Импорт/Экспорт профиля"
L["This will overwrite your current profile. Are you sure?"] = "Это перезапишет ваш текущий профиль. Вы уверены?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "Панели заблокированы"
L["Panels unlocked"] = "Панели разблокированы"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "Agi"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "Снижение урона по уровням:"
L["Level %d"] = "Уровень %d"
L["Target Mitigation"] = "Снижение урона цели"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "AP"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "Сумки"

-- ----------------------------
-- modules/CombatTimer.lua
-- ----------------------------
L["Combat"] = "Бой"
L["combat duration"] = "продолжительность боя"
L["Combat Timer"] = "Таймер боя"
L["Current"] = "Текущий"
L["Currently out of combat"] = "В данный момент вне боя"
L["Display Duration"] = "Длительность отображения"
L["Enter combat to start tracking"] = "Вступите в бой, чтобы начать отслеживание"
L["Last"] = "Последний"
L["Left-click"] = "Левый клик"
L["Out of Combat"] = "Вне боя"
L["to reset"] = "для сброса"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "Крит"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "ВАЛЮТЫ"
L["Tracked Currency Qty"] = "Отслеживаемая Валюта Кол-во"
L["Currency Display Order"] = "Порядок Отображения Валюты"
L["Position %d"] = "Позиция %d"
L["Empty Slot"] = "Пустой Слот"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "Длит:"
L["Durability:"] = "Прочность:"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "Максимальный Уровень"
L["N/A"] = "Н/Д"
L["Experience"] = "Опыт"
L["Display Format"] = "Формат отображения"
L["Bar Toggles"] = "Переключатели полосы"
L["Show Graphical Bar"] = "Показать графическую полосу"
L["Hide Blizzard XP Bar"] = "Скрыть полосу опыта Blizzard"
L["Bar Appearance"] = "Внешний вид полосы"
L["Bar Height (%)"] = "Высота полосы (%)"
L["Bar Use Class Color"] = "Использовать цвет класса для полосы"
L["Bar Custom Color"] = "Пользовательский цвет полосы"
L["Bar Texture"] = "Текстура полосы"
L["Text Color"] = "Цвет текста"
L["Text Use Class Color"] = "Использовать цвет класса для текста"
L["Text Custom Color"] = "Пользовательский цвет текста"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Объект LDB Ara Friends не найден! Datatext Друзья SDT отключён."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "Показать серебро"
L["Show Copper"] = "Показать медь"
L["Use Coin Icons"] = "Использовать значки монет"
L["Display Quantities"] = "Показать количество"
L["Characters to Show"] = "Персонажи для показа"
L["Servers to Show"] = "Серверы для показа"
L["Session:"] = "Сессия:"
L["Earned:"] = "Заработано:"
L["Spent:"] = "Потрачено:"
L["Profit:"] = "Прибыль:"
L["Deficit:"] = "Дефицит:"
L["Character:"] = "Персонаж:"
L["Server:"] = "Сервер:"
L["Faction:"] = "Фракция:"
L["Alliance:"] = "Альянс:"
L["Horde:"] = "Орда:"
L["Total:"] = "Итого:"
L["Warband:"] = "Боевой отряд:"
L["WoW Token:"] = "Токен WoW:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "Сбросить данные сессии: удерживайте Ctrl + правая кнопка мыши"
L["Gold: All data reset!"] = "Золото: Все данные сброшены!"
L["Gold: Data reset for %s!"] = "Золото: Данные сброшены для %s!"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "Вы уверены, что хотите удалить данные о золоте для:\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000ВСЕ ПЕРСОНАЖИ|r"
L["|cFF808080No character data found|r"] = "|cFF808080Данные персонажей не найдены|r"
L["Reset Session Data:"] = "Сбросить данные сессии:"
L["Hold Shift + Right Click"] = "Удерживать Shift + Правая кнопка мыши"
L["Reset Character Gold Data:"] = "Сбросить данные о золоте персонажа:"
L["Hold Alt + Right Click"] = "Удерживать Alt + Правая кнопка мыши"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Объект LDB Ara Guild не найден! Datatext Гильдия SDT отключён."
L["Max Guild Name Length"] = "Макс. длина названия гильдии"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "Скорость:"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "Камень возвращения"
L["Selected Hearthstone"] = "Выбранный камень возвращения"
L["Random"] = "Случайный"
L["Selected:"] = "Выбран:"
L["Available Hearthstones:"] = "Доступные камни возвращения:"
L["Left Click: Use Hearthstone"] = "ЛКМ: Использовать камень возвращения"
L["Right Click: Select Hearthstone"] = "ПКМ: Выбрать камень возвращения"
L["Cannot use hearthstone while in combat"] = "Невозможно использовать камень возвращения в бою"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "Int"

-- ----------------------------
-- modules/ItemLevel.lua
-- ----------------------------
L["Item Level"] = "Уровень предмета"
L["ilvl"] = "уПред"
L["Equipped Item Level"] = "Уровень экипированного предмета"
L["Maximum Item Level"] = "Максимальный уровень предмета"
L["Show Max Item Level"] = "Показать максимальный уровень предмета"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "НЕТ ТЕКСТА"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "Новая почта"
L["No Mail"] = "Нет писем"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "Название карты"
L["Zone Name"] = "Название зоны"
L["Subzone Name"] = "Название подзоны"
L["Zone - Subzone"] = "Зона - Подзона"
L["Zone / Subzone (Two Lines)"] = "Зона / Подзона (Две строки)"
L["Minimap Zone"] = "Зона миникарты"
L["Show Zone on Tooltip"] = "Показывать зону в подсказке"
L["Show Coordinates on Tooltip"] = "Показывать координаты в подсказке"
L["Zone:"] = "Зона:"
L["Subzone:"] = "Подзона:"
L["Coordinates:"] = "Координаты:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "Мастерство:"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "Ключ эпохального+"
L["No Mythic+ Keystone"] = "Нет ключа эпохального+"
L["Current Key:"] = "Текущий ключ:"
L["Dungeon Teleport is on cooldown for "] = "Телепорт в подземелье восстанавливается "
L[" more seconds."] = " секунд."
L["You do not know the teleport spell for "] = "Вы не знаете заклинание телепортации для "
L["Key: "] = "Ключ: "
L["None"] = "Нет"
L["No Key"] = "Нет ключа"
L["Left Click: Teleport to Dungeon"] = "Левый клик: Телепорт в подземелье"
L["Right Click: List Group in Finder"] = "Правый клик: Создать группу в поиске"

-- ----------------------------
-- modules/Quests.lua
-- ----------------------------
L["Quests"] = "Задания"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "Активен"
L["Inactive"] = "Неактивен"
L["Loadouts"] = "Сборки"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Не удалось загрузить Blizzard_PlayerSpells: %s"
L["Starter Build"] = "Начальная сборка"
L["Spec"] = "Спек"
L["Left Click: Change Talent Specialization"] = "Левый клик: изменить специализацию талантов"
L["Control + Left Click: Change Loadout"] = "Ctrl + левый клик: изменить сборку"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + левый клик: открыть интерфейс специализации"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + правый клик: изменить специализацию добычи"
L["Show Specialization Icon"] = "Показать значок специализации"
L["Show Specialization Text"] = "Показать текст специализации"
L["Show Loot Specialization Icon"] = "Показать значок специализации добычи"
L["Show Loot Specialization Text"] = "Показать текст специализации добычи"
L["Show Loadout"] = "Показать набор"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "Скорость: "

-- ----------------------------
-- modules/Stagger.lua
-- ----------------------------
L["Stagger Amount:"] = "Количество Отсрочки:"

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "Str"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "МБ"
L["KB_SUFFIX"] = "КБ"
L["SYSTEM"] = "СИСТЕМА"
L["FPS:"] = "FPS:"
L["Home Latency:"] = "Локальная задержка:"
L["World Latency:"] = "Глобальная задержка:"
L["Total Memory:"] = "Всего памяти:"
L["(Shift Click) Collect Garbage"] = "(Shift + клик) Очистить память"
L["FPS"] = "FPS"
L["MS"] = "мс"
L["Top Addons by Memory:"] = "Топ аддонов по памяти:"
L["Top Addons in Tooltip"] = "Лучшие аддоны в подсказке"
L["Total CPU:"] = "Всего CPU:"
L["Top Addons by CPU:"] = "Топ аддонов по CPU:"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "ВРЕМЯ"
L["Saved Raid(s)"] = "Сохранённые рейды"
L["Saved Dungeon(s)"] = "Сохранённые подземелья"
L["Display Realm Time"] = "Показать время сервера"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "Универс:"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "Выбрать поток громкости"
L["Toggle Volume Stream"] = "Включить/выключить поток громкости"
L["Output Audio Device"] = "Устройство вывода звука"
L["Active Output Audio Device"] = "Активное устройство вывода"
L["Volume Streams"] = "Потоки громкости"
L["Left Click: Select Volume Stream"] = "Левый клик: выбрать поток громкости"
L["Middle Click: Toggle Mute Master Stream"] = "Средний клик: включить/выключить основной поток"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + средний клик: включить/выключить поток громкости"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + левый клик: открыть аудиопанель системы"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + правый клик: выбрать устройство вывода"
L["M. Vol"] = "Осн"
L["FX"] = "Эфф"
L["Amb"] = "Окр"
L["Dlg"] = "Диал"
L["Mus"] = "Муз"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "Гильдия"
L["No Guild"] = "Нет гильдии"
L["Friends"] = "Друзья"
L["<Mobile>"] = "<Мобильный>"
L["Hints"] = "Подсказки"
L["Block"] = "Блокировать"
L["Click"] = "Клик"
L["RightClick"] = "Правый клик"
L["MiddleClick"] = "Средний клик"
L["Modifier+Click"] = "Модификатор+клик"
L["Shift+Click"] = "Shift+клик"
L["Shift+RightClick"] = "Shift+правый клик"
L["Ctrl+Click"] = "Ctrl+клик"
L["Ctrl+RightClick"] = "Ctrl+правый клик"
L["Alt+RightClick"] = "Alt+правый клик"
L["Ctrl+MouseWheel"] = "Ctrl+колёсико мыши"
L["Button4"] = "Кнопка4"
L["to open panel."] = "для открытия панели."
L["to display config menu."] = "для отображения меню настроек."
L["to add a friend."] = "для добавления друга."
L["to toggle notes."] = "для отображения/скрытия заметок."
L["to whisper."] = "для шёпота."
L["to invite."] = "для приглашения."
L["to query information."] = "для запроса информации."
L["to edit note."] = "для редактирования заметки."
L["to edit officer note."] = "для редактирования заметки офицера."
L["to remove friend."] = "для удаления друга."
L["to sort main column."] = "для сортировки основной колонки."
L["to sort second column."] = "для сортировки второй колонки."
L["to sort third column."] = "для сортировки третьей колонки."
L["to resize tooltip."] = "для изменения размера подсказки."
L["Mobile App"] = "Мобильное приложение"
L["Desktop App"] = "Десктоп приложение"
L["OFFLINE FAVORITE"] = "ИЗБРАННОЕ ОФФЛАЙН"
L["MOTD"] = "СД" -- Short for "Сообщение дня".
L["No friends online."] = "Друзей онлайн нет."
L["Broadcast"] = "Трансляция"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "Недопустимый масштаб.\nДолжно быть число от 70 до 200%"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "Установите пользовательский масштаб подсказки.\nВведите значение от 70 до 200 (%%)."
L["Guild & Friends"] = "Гильдия и друзья"
L["Show guild name"] = "Показать имя гильдии"
L["Show 'Guild' tag"] = "Показать метку 'Гильдия'"
L["Show total number of guildmates"] = "Показать общее количество членов гильдии"
L["Show 'Friends' tag"] = "Показать метку 'Друзья'"
L["Show total number of friends"] = "Показать общее количество друзей"
L["Show guild XP"] = "Показать опыт гильдии"
L["Show guild XP tooltip"] = "Показать подсказку опыта гильдии"
L["Show own broadcast"] = "Показать свои трансляции"
L["Show bnet friends broadcast"] = "Показать трансляции друзей Battle.net"
L["Show guild notes"] = "Показать заметки гильдии"
L["Show friend notes"] = "Показать заметки друзей"
L["Show class icon when grouped"] = "Показывать иконку класса в группе"
L["Highlight sorted column"] = "Выделять отсортированную колонку"
L["Simple"] = "Просто"
L["Gradient"] = "Градиент"
L["Reverse gradient"] = "Обратный градиент"
L["Status as..."] = "Статус как..."
L["Class colored text"] = "Текст цветом класса"
L["Custom colored text"] = "Текст пользовательского цвета"
L["Icon"] = "Иконка"
L["Real ID..."] = "Real ID..."
L["Before nickname"] = "Перед ником"
L["Instead of nickname"] = "Вместо ника"
L["After nickname"] = "После ника"
L["Don't show"] = "Не показывать"
L["Column alignments"] = "Выравнивание колонок"
L["Name"] = "Имя"
L["Zone"] = "Зона"
L["Notes"] = "Заметки"
L["Rank"] = "Ранг"
L["Tooltip Size"] = "Размер подсказки"
L["90%"] = "90%"
L["100%"] = "100%"
L["110%"] = "110%"
L["120%"] = "120%"
L["Custom..."] = "Пользовательский..."
L["Use TipTac skin (requires TipTac)"] = "Использовать тему TipTac (требуется TipTac)"
L["Colors"] = "Цвета"
L["Background"] = "Фон"
L["Borders"] = "Границы"
L["Order highlight"] = "Выделение порядка"
L["Headers"] = "Заголовки"
L["MotD / broadcast"] = "Сообщение дня / трансляция"
L["Friendly zone"] = "Дружественная зона"
L["Contested zone"] = "Оспариваемая зона"
L["Enemy zone"] = "Вражеская зона"
L["Officer notes"] = "Заметки офицера"
L["Status"] = "Статус"
L["Ranks"] = "Ранги"
L["Friends broadcast"] = "Трансляции друзей"
L["Realms"] = "Серверы"
L["Restore default colors"] = "Восстановить стандартные цвета"
L["Show Block Hints"] = "Показать подсказки блока"
L["Open panel"] = "Открыть панель"
L["Config menu"] = "Меню настроек"
L["Toggle notes"] = "Показать/скрыть заметки"
L["Add a friend"] = "Добавить друга"
L["Show Hints"] = "Показать подсказки"
L["Whisper"] = "Шёпот"
L["Invite"] = "Пригласить"
L["Query"] = "Запрос"
L["Edit note"] = "Редактировать заметку"
L["Edit officer note"] = "Редактировать заметку офицера"
L["Sort main column"] = "Сортировать основную колонку"
L["Sort second column"] = "Сортировать вторую колонку"
L["Sort third column"] = "Сортировать третью колонку"
L["Resize tooltip"] = "Изменить размер подсказки"
L["Remove friend"] = "Удалить друга"
