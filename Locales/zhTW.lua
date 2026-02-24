local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "zhTW" then
    return
end

-- ----------------------------
-- Global - Multiple Files
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(空)"
L["(spacer)"] = "(間隔)"
L["Display Font:"] = "顯示字型："
L["Font Settings"] = "字型設定"
L["Font Size"] = "字型大小"
L["Font Outline"] = "字型描邊"
L["GOLD"] = "金幣"
L["Override Global Font"] = "覆蓋全域字型"
L["Override Text Color"] = "覆蓋文字顏色"
L["Settings"] = "設定"
L["Frame Strata"] = "框架層級"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "設定此模組的框架層級。數值越高顯示在越上層。"
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "設定此面板的框架層級。模組將相對於此顯示。數值越高顯示在越上層。"
L["Slot Controls"] = "欄位控制"
L["Anchor Point"] = "錨點"
L["Set the anchor point for this module."] = "設定此模組的錨點。"
L["Yes"] = "是"
L["No"] = "否"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "除錯模式已停用"
L["Debug Mode Enabled"] = "除錯模式已啟用"
L["Left Click to open settings"] = "左鍵點擊開啟設定"
L["Lock/Unlock"] = "鎖定/解鎖"
L["Minimap Icon Disabled"] = "小地圖圖示已停用"
L["Minimap Icon Enabled"] = "小地圖圖示已啟用"
L["Not Defined"] = "未定義"
L["Toggle Minimap Icon"] = "切換小地圖圖示"
L["Usage"] = "用法"
L["Version"] = "版本"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "壓縮設定檔資料時發生錯誤"
L["Error decoding import string"] = "解碼匯入字串時發生錯誤"
L["Error decompressing data"] = "解壓縮資料時發生錯誤"
L["Error deserializing profile data"] = "反序列化設定檔資料時發生錯誤"
L["Error serializing profile data"] = "序列化設定檔資料時發生錯誤"
L["Import data too large"] = "匯入資料過大"
L["Import data too large after decompression"] = "解壓縮後匯入資料過大"
L["Import string is too large"] = "匯入字串過大"
L["Importing profile from version %s"] = "正在從版本 %s 匯入設定檔"
L["Invalid import string format"] = "無效的匯入字串格式"
L["Invalid profile data"] = "無效的設定檔資料"
L["Migrating old settings to new profile system..."] = "正在將舊設定遷移至新設定檔系統..."
L["Migration complete! All profiles have been migrated."] = "遷移完成！所有設定檔已遷移。"
L["No import string provided"] = "未提供匯入字串"
L["Profile imported successfully!"] = "設定檔匯入成功！"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "顏色"
L["Custom Color"] = "自訂顏色"
L["Enable Per-Spec Profiles"] = "啟用專精設定檔"
L["Global"] = "全域"
L["Global Settings"] = "全域設定"
L["Hide Module Title in Tooltip"] = "在提示框中隱藏模組標題"
L["Lock Panels"] = "鎖定面板"
L["Prevent panels from being moved"] = "防止面板被移動"
L["Show Login Message"] = "顯示登入訊息"
L["Show Minimap Icon"] = "顯示小地圖圖示"
L["Toggle the minimap button on or off"] = "開啟或關閉小地圖按鈕"
L["Use 24Hr Clock"] = "使用24小時制"
L["Use Class Color"] = "使用職業顏色"
L["Use Custom Color"] = "使用自訂顏色"
L["X Offset"] = "X偏移"
L["Y Offset"] = "Y偏移"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "啟用後，每次更改專精時，插件將自動切換至不同的設定檔。在下面選擇每個專精應使用的設定檔。"
L["Enable Font Text Shadow"] = "啟用字型文字陰影"
L["Add a subtle shadow to datatexts for better readability"] = "為資料文字添加細微陰影以提高可讀性"
L["Enable Tooltip Text Shadow"] = "啟用提示框文字陰影"
L["Add a subtle shadow to tooltip text for better readability"] = "為提示框文字添加細微陰影以提高可讀性"
L["Tooltip Settings"] = "提示框設定"
L["Tooltip Font"] = "提示框字型"
L["Font used for all addon tooltips"] = "用於所有插件提示框的字型"
L["Tooltip Font Outline"] = "提示框字型外框"
L["Font outline for all addon tooltips"] = "所有插件提示框的字型外框"
L["Tooltip Header Font Size"] = "提示框標題字型大小"
L["Font size for tooltip headers"] = "提示框標題的字型大小"
L["Tooltip Line Font Size"] = "提示框行字型大小"
L["Font size for tooltip content lines"] = "提示框內容行的字型大小"
L["Show All Panels"] = "顯示所有面板"
L["Toggle visibility of all panels. Individual panels can also be hidden in their own settings."] = "切換所有面板的顯示狀態。也可在各面板的獨立設定中將其隱藏。"
L["Panels shown"] = "面板已顯示"
L["Panels hidden"] = "面板已隱藏"
L["Toggle All Panels"] = "切換所有面板"

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "外觀"
L["Apply Slot Changes"] = "套用插槽變更"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "確定要刪除此列嗎？\n此操作無法復原。"
L["Background Opacity"] = "背景不透明度"
L["Border Color"] = "邊框顏色"
L["Border Size"] = "邊框大小"
L["Create New Panel"] = "建立新面板"
L["Height"] = "高度"
L["Number of Slots"] = "插槽數量"
L["Panel Settings"] = "面板設定"
L["Panels"] = "面板"
L["Remove Selected Panel"] = "移除選定面板"
L["Rename Panel:"] = "重新命名面板："
L["Scale"] = "縮放"
L["Select Border:"] = "選擇邊框："
L["Select Panel:"] = "選擇面板："
L["Size & Scale"] = "大小和縮放"
L["Slot Assignments"] = "插槽分配"
L["Slot %d:"] = "插槽 %d："
L["Slots"] = "插槽"
L["Update slot assignment dropdowns after changing number of slots"] = "變更插槽數量後更新插槽分配下拉選單"
L["Width"] = "寬度"
L["Hide Panel"] = "隱藏面板"
L["Hide this panel. Panels are always visible while unlocked."] = "隱藏此面板。面板在解鎖狀態下始終可見。"

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "模組設定"
L["Hide Decimals"] = "隱藏小數"
L["Show Label"] = "顯示標籤"
L["Show Short Label"] = "顯示短標籤"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. 點擊上面的「產生匯出字串」\n2. 點擊此框\n3. 按 Ctrl+A 全選\n4. 按 Ctrl+C 複製"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. 在下面的框中貼上匯入字串\n2. 點擊接受\n3. 點擊「匯入設定檔」"
L["Create an export string for your current profile"] = "為目前設定檔建立匯出字串"
L["Export"] = "匯出"
L["Export String"] = "匯出字串"
L["Export string generated! Copy it from the box below."] = "匯出字串已產生！從下面的框中複製它。"
L["Export your current profile to share with others, or import a profile string.\n"] = "匯出目前設定檔以與他人分享，或匯入設定檔字串。\n"
L["Generate Export String"] = "產生匯出字串"
L["Import"] = "匯入"
L["Import/Export"] = "匯入/匯出"
L["Import Profile"] = "匯入設定檔"
L["Import String"] = "匯入字串"
L["Import the profile string from above (after clicking Accept)"] = "匯入上面的設定檔字串（點擊接受後）"
L["Please paste an import string and click Accept first"] = "請先貼上匯入字串並點擊接受"
L["Profile Import/Export"] = "設定檔匯入/匯出"
L["This will overwrite your current profile. Are you sure?"] = "這將覆蓋你目前的設定檔。確定嗎？"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "面板已鎖定"
L["Panels unlocked"] = "面板已解鎖"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "敏捷"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "按等級減傷："
L["Level %d"] = "等級 %d"
L["Target Mitigation"] = "目標減傷"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "攻強"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "背包"

-- ----------------------------
-- modules/CombatTimer.lua
-- ----------------------------
L["Combat"] = "戰鬥"
L["combat duration"] = "戰鬥持續時間"
L["Combat Timer"] = "戰鬥計時器"
L["Current"] = "目前"
L["Currently out of combat"] = "目前未進入戰鬥"
L["Display Duration"] = "顯示持續時間"
L["Enter combat to start tracking"] = "進入戰鬥開始追蹤"
L["Last"] = "上次"
L["Left-click"] = "左鍵點擊"
L["Out of Combat"] = "脫離戰鬥"
L["to reset"] = "重設"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "致命一擊"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "貨幣"
L["Tracked Currency Qty"] = "追蹤貨幣數量"
L["Currency Display Order"] = "貨幣顯示順序"
L["Position %d"] = "位置 %d"
L["Empty Slot"] = "空位"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "耐久："
L["Durability:"] = "耐久度："

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "滿級"
L["N/A"] = "不適用"
L["Experience"] = "經驗值"
L["Display Format"] = "顯示格式"
L["Bar Toggles"] = "條列切換"
L["Show Graphical Bar"] = "顯示圖形條"
L["Hide Blizzard XP Bar"] = "隱藏暴雪經驗條"
L["Bar Appearance"] = "條列外觀"
L["Bar Height (%)"] = "條列高度（%）"
L["Bar Use Class Color"] = "條列使用職業顏色"
L["Bar Custom Color"] = "條列自訂顏色"
L["Bar Texture"] = "條列材質"
L["Text Color"] = "文字顏色"
L["Text Use Class Color"] = "文字使用職業顏色"
L["Text Custom Color"] = "文字自訂顏色"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "未找到 Ara Friends LDB 物件！SDT 好友資料文字已停用。"

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "顯示銀幣"
L["Show Copper"] = "顯示銅幣"
L["Use Coin Icons"] = "使用貨幣圖示"
L["Display Quantities"] = "顯示數量"
L["Characters to Show"] = "顯示角色"
L["Servers to Show"] = "顯示伺服器"
L["Session:"] = "本次登入："
L["Earned:"] = "獲得："
L["Spent:"] = "花費："
L["Profit:"] = "盈利："
L["Deficit:"] = "虧損："
L["Character:"] = "角色："
L["Server:"] = "伺服器："
L["Faction:"] = "陣營："
L["Alliance:"] = "聯盟："
L["Horde:"] = "部落："
L["Total:"] = "總計："
L["Warband:"] = "戰隊："
L["WoW Token:"] = "WoW 時光徽章："
L["Reset Session Data: Hold Ctrl + Right Click"] = "重設工作階段資料：按住 Ctrl + 右鍵點擊"
L["Gold: All data reset!"] = "金幣：所有資料已重置！"
L["Gold: Data reset for %s!"] = "金幣：%s 的資料已重置！"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "你確定要刪除以下角色的金幣資料嗎：\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000所有角色|r"
L["|cFF808080No character data found|r"] = "|cFF808080未找到角色資料|r"
L["Reset Session Data:"] = "重置階段資料："
L["Hold Shift + Right Click"] = "按住 Shift + 右鍵點擊"
L["Reset Character Gold Data:"] = "重置角色金幣資料："
L["Hold Alt + Right Click"] = "按住 Alt + 右鍵點擊"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "未找到 Ara Guild LDB 物件！SDT 公會資料文字已停用。"
L["Max Guild Name Length"] = "最大公會名稱長度"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "加速："

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "爐石"
L["Selected Hearthstone"] = "已選擇的爐石"
L["Random"] = "隨機"
L["Selected:"] = "已選擇："
L["Available Hearthstones:"] = "可用的爐石："
L["Left Click: Use Hearthstone"] = "左鍵點擊：使用爐石"
L["Right Click: Select Hearthstone"] = "右鍵點擊：選擇爐石"
L["Cannot use hearthstone while in combat"] = "戰鬥中無法使用爐石"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "智力"

-- ----------------------------
-- modules/ItemLevel.lua
-- ----------------------------
L["Item Level"] = "物品等級"
L["ilvl"] = "裝等"
L["Equipped Item Level"] = "已裝備物品等級"
L["Maximum Item Level"] = "最高物品等級"
L["Show Max Item Level"] = "顯示最高物品等級"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "無文字"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "新郵件"
L["No Mail"] = "無郵件"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "地圖名稱"
L["Zone Name"] = "區域名稱"
L["Subzone Name"] = "子區域名稱"
L["Zone - Subzone"] = "區域 - 子區域"
L["Zone / Subzone (Two Lines)"] = "區域 / 子區域（兩行）"
L["Minimap Zone"] = "小地圖區域"
L["Show Zone on Tooltip"] = "在提示框中顯示區域"
L["Show Coordinates on Tooltip"] = "在提示框中顯示座標"
L["Zone:"] = "區域："
L["Subzone:"] = "子區域："
L["Coordinates:"] = "座標："

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "精通："

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "傳奇鑰石"
L["No Mythic+ Keystone"] = "無傳奇鑰石"
L["Current Key:"] = "目前鑰石："
L["Dungeon Teleport is on cooldown for "] = "地城傳送冷卻中，剩餘 "
L[" more seconds."] = " 秒。"
L["You do not know the teleport spell for "] = "你不知道傳送法術："
L["Key: "] = "鑰石："
L["None"] = "無"
L["No Key"] = "無鑰石"
L["Left Click: Teleport to Dungeon"] = "左鍵點擊：傳送到地城"
L["Right Click: List Group in Finder"] = "右鍵點擊：在尋求中列出隊伍"

-- ----------------------------
-- modules/Quests.lua
-- ----------------------------
L["Quests"] = "任務"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "啟用"
L["Inactive"] = "未啟用"
L["Loadouts"] = "配裝"
L["Failed to load Blizzard_PlayerSpells: %s"] = "載入 Blizzard_PlayerSpells 失敗：%s"
L["Starter Build"] = "新手配置"
L["Spec"] = "專精"
L["Left Click: Change Talent Specialization"] = "左鍵點擊：變更天賦專精"
L["Control + Left Click: Change Loadout"] = "Ctrl + 左鍵點擊：變更配裝"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + 左鍵點擊：顯示天賦專精介面"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + 右鍵點擊：變更拾取專精"
L["Show Specialization Icon"] = "顯示專精圖示"
L["Show Specialization Text"] = "顯示專精文字"
L["Show Loot Specialization Icon"] = "顯示拾取專精圖示"
L["Show Loot Specialization Text"] = "顯示拾取專精文字"
L["Show Loot Spec When Current"] = "當前專精時顯示戰利品專精"
L["Show Loadout"] = "顯示配裝"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "速度："

-- ----------------------------
-- modules/Stagger.lua
-- ----------------------------
L["Stagger Amount:"] = "醉拳量:"

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "力量"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "MB"
L["KB_SUFFIX"] = "KB"
L["SYSTEM"] = "系統"
L["FPS:"] = "畫面更新率："
L["Home Latency:"] = "本地延遲："
L["World Latency:"] = "世界延遲："
L["Total Memory:"] = "總記憶體："
L["(Shift Click) Collect Garbage"] = "（Shift 點擊）垃圾回收"
L["FPS"] = "畫面更新率"
L["MS"] = "毫秒"
L["Top Addons by Memory:"] = "記憶體佔用最高的插件："
L["Top Addons in Tooltip"] = "在提示框中顯示佔用最高的插件"
L["Total CPU:"] = "總 CPU："
L["Top Addons by CPU:"] = "按 CPU 排名前列的插件："

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "時間"
L["Saved Raid(s)"] = "已儲存的團隊副本"
L["Saved Dungeon(s)"] = "已儲存的地城"
L["Display Realm Time"] = "顯示伺服器時間"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "臨機應變："

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "選擇音量串流"
L["Toggle Volume Stream"] = "切換音量串流"
L["Output Audio Device"] = "輸出音訊裝置"
L["Active Output Audio Device"] = "活動輸出音訊裝置"
L["Volume Streams"] = "音量串流"
L["Left Click: Select Volume Stream"] = "左鍵點擊：選擇音量串流"
L["Middle Click: Toggle Mute Master Stream"] = "中鍵點擊：切換主音量靜音"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + 中鍵點擊：切換音量串流"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + 左鍵點擊：開啟系統音訊面板"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + 右鍵點擊：選擇輸出音訊裝置"
L["M. Vol"] = "主音量"
L["FX"] = "音效"
L["Amb"] = "環境"
L["Dlg"] = "對話"
L["Mus"] = "音樂"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "公會"
L["No Guild"] = "無公會"
L["Friends"] = "好友"
L["<Mobile>"] = "<行動版>"
L["Hints"] = "提示"
L["Block"] = "封鎖"
L["Click"] = "點擊"
L["RightClick"] = "右鍵點擊"
L["MiddleClick"] = "中鍵點擊"
L["Modifier+Click"] = "修飾鍵+點擊"
L["Shift+Click"] = "Shift+點擊"
L["Shift+RightClick"] = "Shift+右鍵點擊"
L["Ctrl+Click"] = "Ctrl+點擊"
L["Ctrl+RightClick"] = "Ctrl+右鍵點擊"
L["Alt+RightClick"] = "Alt+右鍵點擊"
L["Ctrl+MouseWheel"] = "Ctrl+滑鼠滾輪"
L["Button4"] = "按鈕4"
L["to open panel."] = "開啟面板。"
L["to display config menu."] = "顯示設定選單。"
L["to add a friend."] = "新增好友。"
L["to toggle notes."] = "切換備註。"
L["to whisper."] = "密語。"
L["to invite."] = "邀請。"
L["to query information."] = "查詢資訊。"
L["to edit note."] = "編輯備註。"
L["to edit officer note."] = "編輯幹部備註。"
L["to remove friend."] = "移除好友。"
L["to sort main column."] = "排序主欄。"
L["to sort second column."] = "排序第二欄。"
L["to sort third column."] = "排序第三欄。"
L["to resize tooltip."] = "調整提示框大小。"
L["Mobile App"] = "行動應用程式"
L["Desktop App"] = "桌面應用程式"
L["OFFLINE FAVORITE"] = "離線收藏"
L["MOTD"] = "今日訊息"
L["No friends online."] = "沒有線上好友。"
L["Broadcast"] = "廣播"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "無效的縮放。\n應為 70 到 200% 之間的數字"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "設定自訂提示框縮放。\n輸入 70 到 200（%%）之間的值。"
L["Simple Datatexts Favorite"] = "Simple Datatexts 收藏"
L["Guilded"] = "Guilded"
L["Battle.net App"] = "Battle.net 應用程式"
L["Invite"] = "邀請"
L["Leave/Hide"] = "離開/隱藏"
L["In-game"] = "遊戲中"
L["Away"] = "離開"
L["Busy"] = "忙碌"