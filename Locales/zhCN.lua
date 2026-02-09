local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "zhCN" then
    return
end

-- ----------------------------
-- Global - Multiple Files
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(空)"
L["(spacer)"] = "(间隔)"
L["Display Font:"] = "显示字体："
L["Font Settings"] = "字体设置"
L["Font Size"] = "字体大小"
L["Font Outline"] = "字体描边"
L["GOLD"] = "金币"
L["Override Global Font"] = "覆盖全局字体"
L["Override Text Color"] = "覆盖文本颜色"
L["Settings"] = "设置"
L["Frame Strata"] = "框架层级"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "设置此模块的框架层级。数值越高显示在越上层。"
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "设置此面板的框架层级。模块将相对于此显示。数值越高显示在越上层。"
L["Slot Controls"] = "槽位控制"
L["Anchor Point"] = "锚点"
L["Set the anchor point for this module."] = "设置此模块的锚点。"
L["Yes"] = "是"
L["No"] = "否"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "调试模式已禁用"
L["Debug Mode Enabled"] = "调试模式已启用"
L["Left Click to open settings"] = "左键点击打开设置"
L["Lock/Unlock"] = "锁定/解锁"
L["Minimap Icon Disabled"] = "小地图图标已禁用"
L["Minimap Icon Enabled"] = "小地图图标已启用"
L["Not Defined"] = "未定义"
L["Toggle Minimap Icon"] = "切换小地图图标"
L["Usage"] = "用法"
L["Version"] = "版本"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "压缩配置文件数据时出错"
L["Error decoding import string"] = "解码导入字符串时出错"
L["Error decompressing data"] = "解压数据时出错"
L["Error deserializing profile data"] = "反序列化配置文件数据时出错"
L["Error serializing profile data"] = "序列化配置文件数据时出错"
L["Import data too large"] = "导入数据过大"
L["Import data too large after decompression"] = "解压后导入数据过大"
L["Import string is too large"] = "导入字符串过大"
L["Importing profile from version %s"] = "正在从版本 %s 导入配置文件"
L["Invalid import string format"] = "无效的导入字符串格式"
L["Invalid profile data"] = "无效的配置文件数据"
L["Migrating old settings to new profile system..."] = "正在将旧设置迁移到新配置文件系统..."
L["Migration complete! All profiles have been migrated."] = "迁移完成！所有配置文件已迁移。"
L["No import string provided"] = "未提供导入字符串"
L["Profile imported successfully!"] = "配置文件导入成功！"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "颜色"
L["Custom Color"] = "自定义颜色"
L["Enable Per-Spec Profiles"] = "启用专精配置文件"
L["Global"] = "全局"
L["Global Settings"] = "全局设置"
L["Hide Module Title in Tooltip"] = "在提示框中隐藏模块标题"
L["Lock Panels"] = "锁定面板"
L["Prevent panels from being moved"] = "防止面板被移动"
L["Show Login Message"] = "显示登录消息"
L["Show Minimap Icon"] = "显示小地图图标"
L["Toggle the minimap button on or off"] = "打开或关闭小地图按钮"
L["Use 24Hr Clock"] = "使用24小时制"
L["Use Class Color"] = "使用职业颜色"
L["Use Custom Color"] = "使用自定义颜色"
L["X Offset"] = "X偏移"
L["Y Offset"] = "Y偏移"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "启用后，每次更改专精时，插件将自动切换到不同的配置文件。在下面选择每个专精应使用的配置文件。"

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "外观"
L["Apply Slot Changes"] = "应用插槽更改"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "确定要删除此栏吗？\n此操作无法撤销。"
L["Background Opacity"] = "背景不透明度"
L["Border Color"] = "边框颜色"
L["Border Size"] = "边框大小"
L["Create New Panel"] = "创建新面板"
L["Height"] = "高度"
L["Number of Slots"] = "插槽数量"
L["Panel Settings"] = "面板设置"
L["Panels"] = "面板"
L["Remove Selected Panel"] = "移除选定面板"
L["Rename Panel:"] = "重命名面板："
L["Scale"] = "缩放"
L["Select Border:"] = "选择边框："
L["Select Panel:"] = "选择面板："
L["Size & Scale"] = "大小和缩放"
L["Slot Assignments"] = "插槽分配"
L["Slot %d:"] = "插槽 %d："
L["Slots"] = "插槽"
L["Update slot assignment dropdowns after changing number of slots"] = "更改插槽数量后更新插槽分配下拉列表"
L["Width"] = "宽度"

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "模块设置"
L["Hide Decimals"] = "隐藏小数"
L["Show Label"] = "显示标签"
L["Show Short Label"] = "显示短标签"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. 点击上面的"生成导出字符串"\n2. 点击此框\n3. 按 Ctrl+A 全选\n4. 按 Ctrl+C 复制"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. 在下面的框中粘贴导入字符串\n2. 点击接受\n3. 点击"导入配置文件""
L["Create an export string for your current profile"] = "为当前配置文件创建导出字符串"
L["Export"] = "导出"
L["Export String"] = "导出字符串"
L["Export string generated! Copy it from the box below."] = "导出字符串已生成！从下面的框中复制它。"
L["Export your current profile to share with others, or import a profile string.\n"] = "导出当前配置文件以与他人共享，或导入配置文件字符串。\n"
L["Generate Export String"] = "生成导出字符串"
L["Import"] = "导入"
L["Import/Export"] = "导入/导出"
L["Import Profile"] = "导入配置文件"
L["Import String"] = "导入字符串"
L["Import the profile string from above (after clicking Accept)"] = "导入上面的配置文件字符串（点击接受后）"
L["Please paste an import string and click Accept first"] = "请先粘贴导入字符串并点击接受"
L["Profile Import/Export"] = "配置文件导入/导出"
L["This will overwrite your current profile. Are you sure?"] = "这将覆盖你当前的配置文件。确定吗？"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "面板已锁定"
L["Panels unlocked"] = "面板已解锁"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "敏捷"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "按等级减伤："
L["Level %d"] = "等级 %d"
L["Target Mitigation"] = "目标减伤"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "攻强"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "背包"

-- ----------------------------
-- modules/CombatTime.lua
-- ----------------------------
L["Combat"] = "战斗"
L["combat duration"] = "战斗持续时间"
L["Current"] = "当前"
L["Currently out of combat"] = "当前未进入战斗"
L["Display Duration"] = "显示持续时间"
L["Enter combat to start tracking"] = "进入战斗开始追踪"
L["Last"] = "上次"
L["Left-click"] = "左键点击"
L["Out of Combat"] = "脱离战斗"
L["to reset"] = "重置"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "暴击"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "货币"
L["Tracked Currency Qty"] = "追踪货币数量"
L["Currency Display Order"] = "货币显示顺序"
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
L["Max Level"] = "满级"
L["N/A"] = "不适用"
L["Experience"] = "经验"
L["Display Format"] = "显示格式"
L["Bar Toggles"] = "条栏切换"
L["Show Graphical Bar"] = "显示图形条"
L["Hide Blizzard XP Bar"] = "隐藏暴雪经验条"
L["Bar Appearance"] = "条栏外观"
L["Bar Height (%)"] = "条栏高度（%）"
L["Bar Use Class Color"] = "条栏使用职业颜色"
L["Bar Custom Color"] = "条栏自定义颜色"
L["Bar Texture"] = "条栏材质"
L["Text Color"] = "文本颜色"
L["Text Use Class Color"] = "文本使用职业颜色"
L["Text Custom Color"] = "文本自定义颜色"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "未找到 Ara Friends LDB 对象！SDT 好友数据文本已禁用。"

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "显示银币"
L["Show Copper"] = "显示铜币"
L["Use Coin Icons"] = "使用货币图标"
L["Display Quantities"] = "显示数量"
L["Characters to Show"] = "显示角色"
L["Servers to Show"] = "显示服务器"
L["Session:"] = "本次登录："
L["Earned:"] = "获得："
L["Spent:"] = "花费："
L["Profit:"] = "盈利："
L["Deficit:"] = "亏损："
L["Character:"] = "角色："
L["Server:"] = "服务器："
L["Faction:"] = "阵营："
L["Alliance:"] = "联盟："
L["Horde:"] = "部落："
L["Total:"] = "总计："
L["Warband:"] = "战团："
L["WoW Token:"] = "WoW 时光徽章："
L["Reset Session Data: Hold Ctrl + Right Click"] = "重置会话数据：按住 Ctrl + 右键点击"
L["Gold: All data reset!"] = "金币：所有数据已重置！"
L["Gold: Data reset for %s!"] = "金币：%s 的数据已重置！"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "你确定要删除以下角色的金币数据吗：\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000所有角色|r"
L["|cFF808080No character data found|r"] = "|cFF808080未找到角色数据|r"
L["Reset Session Data:"] = "重置会话数据："
L["Hold Shift + Right Click"] = "按住 Shift + 右键点击"
L["Reset Character Gold Data:"] = "重置角色金币数据："
L["Hold Alt + Right Click"] = "按住 Alt + 右键点击"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "未找到 Ara Guild LDB 对象！SDT 公会数据文本已禁用。"
L["Max Guild Name Length"] = "最大公会名称长度"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "急速："

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "炉石"
L["Selected Hearthstone"] = "已选择的炉石"
L["Random"] = "随机"
L["Selected:"] = "已选择："
L["Available Hearthstones:"] = "可用的炉石："
L["Left Click: Use Hearthstone"] = "左键点击：使用炉石"
L["Right Click: Select Hearthstone"] = "右键点击：选择炉石"
L["Cannot use hearthstone while in combat"] = "战斗中无法使用炉石"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "智力"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "无文本"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "新邮件"
L["No Mail"] = "无邮件"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "地图名称"
L["Zone Name"] = "区域名称"
L["Subzone Name"] = "子区域名称"
L["Zone - Subzone"] = "区域 - 子区域"
L["Zone / Subzone (Two Lines)"] = "区域 / 子区域（两行）"
L["Minimap Zone"] = "小地图区域"
L["Show Zone on Tooltip"] = "在提示框中显示区域"
L["Show Coordinates on Tooltip"] = "在提示框中显示坐标"
L["Zone:"] = "区域："
L["Subzone:"] = "子区域："
L["Coordinates:"] = "坐标："

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "精通："

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "史诗钥石"
L["No Mythic+ Keystone"] = "无史诗钥石"
L["Current Key:"] = "当前钥石："
L["Dungeon Teleport is on cooldown for "] = "地下城传送冷却中，剩余 "
L[" more seconds."] = " 秒。"
L["You do not know the teleport spell for "] = "你不知道传送法术："
L["Key: "] = "钥石："
L["None"] = "无"
L["No Key"] = "无钥石"
L["Left Click: Teleport to Dungeon"] = "左键点击：传送到地下城"
L["Right Click: List Group in Finder"] = "右键点击：在查找器中列出队伍"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "激活"
L["Inactive"] = "未激活"
L["Loadouts"] = "配装"
L["Failed to load Blizzard_PlayerSpells: %s"] = "加载 Blizzard_PlayerSpells 失败：%s"
L["Starter Build"] = "新手配置"
L["Spec"] = "专精"
L["Left Click: Change Talent Specialization"] = "左键点击：更改天赋专精"
L["Control + Left Click: Change Loadout"] = "Ctrl + 左键点击：更改配装"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + 左键点击：显示天赋专精界面"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + 右键点击：更改拾取专精"
L["Show Specialization Icon"] = "显示专精图标"
L["Show Specialization Text"] = "显示专精文本"
L["Show Loot Specialization Icon"] = "显示拾取专精图标"
L["Show Loot Specialization Text"] = "显示拾取专精文本"
L["Show Loadout"] = "显示配装"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "速度："

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "力量"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "兆"
L["KB_SUFFIX"] = "千"
L["SYSTEM"] = "系统"
L["FPS:"] = "帧数："
L["Home Latency:"] = "本地延迟："
L["World Latency:"] = "世界延迟："
L["Total Memory:"] = "总内存："
L["(Shift Click) Collect Garbage"] = "（Shift 点击）垃圾回收"
L["FPS"] = "帧数"
L["MS"] = "毫秒"
L["Top Addons by Memory:"] = "内存占用最高的插件："
L["Top Addons in Tooltip"] = "在提示框中显示占用最高的插件"
L["Total CPU:"] = "总 CPU："
L["Top Addons by CPU:"] = "按 CPU 排名前列的插件："

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "时间"
L["Saved Raid(s)"] = "已保存的团队副本"
L["Saved Dungeon(s)"] = "已保存的地下城"
L["Display Realm Time"] = "显示服务器时间"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "全能："

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "选择音量流"
L["Toggle Volume Stream"] = "切换音量流"
L["Output Audio Device"] = "输出音频设备"
L["Active Output Audio Device"] = "活动输出音频设备"
L["Volume Streams"] = "音量流"
L["Left Click: Select Volume Stream"] = "左键点击：选择音量流"
L["Middle Click: Toggle Mute Master Stream"] = "中键点击：切换主音量静音"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + 中键点击：切换音量流"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + 左键点击：打开系统音频面板"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + 右键点击：选择输出音频设备"
L["M. Vol"] = "主音量"
L["FX"] = "音效"
L["Amb"] = "环境"
L["Dlg"] = "对话"
L["Mus"] = "音乐"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "公会"
L["No Guild"] = "无公会"
L["Friends"] = "好友"
L["<Mobile>"] = "<移动版>"
L["Hints"] = "提示"
L["Block"] = "屏蔽"
L["Click"] = "点击"
L["RightClick"] = "右键点击"
L["MiddleClick"] = "中键点击"
L["Modifier+Click"] = "修饰键+点击"
L["Shift+Click"] = "Shift+点击"
L["Shift+RightClick"] = "Shift+右键点击"
L["Ctrl+Click"] = "Ctrl+点击"
L["Ctrl+RightClick"] = "Ctrl+右键点击"
L["Alt+RightClick"] = "Alt+右键点击"
L["Ctrl+MouseWheel"] = "Ctrl+鼠标滚轮"
L["Button4"] = "按钮4"
L["to open panel."] = "打开面板。"
L["to display config menu."] = "显示配置菜单。"
L["to add a friend."] = "添加好友。"
L["to toggle notes."] = "切换备注。"
L["to whisper."] = "密语。"
L["to invite."] = "邀请。"
L["to query information."] = "查询信息。"
L["to edit note."] = "编辑备注。"
L["to edit officer note."] = "编辑官员备注。"
L["to remove friend."] = "移除好友。"
L["to sort main column."] = "排序主列。"
L["to sort second column."] = "排序第二列。"
L["to sort third column."] = "排序第三列。"
L["to resize tooltip."] = "调整提示框大小。"
L["Mobile App"] = "移动应用"
L["Desktop App"] = "桌面应用"
L["OFFLINE FAVORITE"] = "离线收藏"
L["MOTD"] = "今日消息"
L["No friends online."] = "没有在线好友。"
L["Broadcast"] = "广播"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "无效的缩放。\n应为 70 到 200% 之间的数字"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "设置自定义提示框缩放。\n输入 70 到 200（%%）之间的值。"
L["Simple Datatexts Favorite"] = "Simple Datatexts 收藏"
L["Guilded"] = "Guilded"
L["Battle.net App"] = "战网应用"
L["Invite"] = "邀请"
L["Leave/Hide"] = "离开/隐藏"
L["In-game"] = "游戏中"
L["Away"] = "离开"
L["Busy"] = "忙碌"