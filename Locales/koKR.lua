local SDT = _G.SimpleDatatexts
local L = SDT.L

if SDT.cache.locale ~= "koKR" then
    return
end

-- ----------------------------
-- Global - Multiple Files
-- ----------------------------
L["Simple Datatexts"] = "Simple Datatexts"
L["(empty)"] = "(비어있음)"
L["(spacer)"] = "(공백)"
L["Display Font:"] = "표시 글꼴:"
L["Font Settings"] = "글꼴 설정"
L["Font Size"] = "글꼴 크기"
L["Font Outline"] = "글꼴 외곽선"
L["GOLD"] = "골드"
L["Override Global Font"] = "전역 글꼴 재정의"
L["Override Text Color"] = "텍스트 색상 재정의"
L["Settings"] = "설정"
L["Frame Strata"] = "프레임 계층"
L["Set the frame strata (layer) for this module. Higher values appear above lower values."] = "이 모듈의 프레임 계층(레이어)을 설정합니다. 높은 값이 낮은 값 위에 표시됩니다."
L["Set the frame strata (layer) for this panel. Modules will appear relative to this. Higher values appear above lower values."] = "이 패널의 프레임 계층(레이어)을 설정합니다. 모듈은 이를 기준으로 표시됩니다. 높은 값이 낮은 값 위에 표시됩니다."
L["Slot Controls"] = "슬롯 제어"
L["Anchor Point"] = "기준점"
L["Set the anchor point for this module."] = "이 모듈의 기준점을 설정합니다."
L["Yes"] = "예"
L["No"] = "아니오"

-- ----------------------------
-- Core.lua
-- ----------------------------
L["Debug Mode Disabled"] = "디버그 모드 비활성화됨"
L["Debug Mode Enabled"] = "디버그 모드 활성화됨"
L["Left Click to open settings"] = "좌클릭하여 설정 열기"
L["Lock/Unlock"] = "잠금/잠금 해제"
L["Minimap Icon Disabled"] = "미니맵 아이콘 비활성화됨"
L["Minimap Icon Enabled"] = "미니맵 아이콘 활성화됨"
L["Not Defined"] = "정의되지 않음"
L["Toggle Minimap Icon"] = "미니맵 아이콘 전환"
L["Usage"] = "사용법"
L["Version"] = "버전"

-- ----------------------------
-- Database.lua
-- ----------------------------
L["Error compressing profile data"] = "프로필 데이터 압축 오류"
L["Error decoding import string"] = "가져오기 문자열 디코딩 오류"
L["Error decompressing data"] = "데이터 압축 해제 오류"
L["Error deserializing profile data"] = "프로필 데이터 역직렬화 오류"
L["Error serializing profile data"] = "프로필 데이터 직렬화 오류"
L["Import data too large"] = "가져오기 데이터가 너무 큼"
L["Import data too large after decompression"] = "압축 해제 후 가져오기 데이터가 너무 큼"
L["Import string is too large"] = "가져오기 문자열이 너무 큼"
L["Importing profile from version %s"] = "버전 %s에서 프로필 가져오는 중"
L["Invalid import string format"] = "잘못된 가져오기 문자열 형식"
L["Invalid profile data"] = "잘못된 프로필 데이터"
L["Migrating old settings to new profile system..."] = "이전 설정을 새 프로필 시스템으로 마이그레이션하는 중..."
L["Migration complete! All profiles have been migrated."] = "마이그레이션 완료! 모든 프로필이 마이그레이션되었습니다."
L["No import string provided"] = "가져오기 문자열이 제공되지 않음"
L["Profile imported successfully!"] = "프로필을 성공적으로 가져왔습니다!"

-- ----------------------------
-- Config.lua - Global
-- ----------------------------
L["Colors"] = "색상"
L["Custom Color"] = "사용자 지정 색상"
L["Enable Per-Spec Profiles"] = "전문화별 프로필 활성화"
L["Global"] = "전역"
L["Global Settings"] = "전역 설정"
L["Hide Module Title in Tooltip"] = "툴팁에서 모듈 제목 숨기기"
L["Lock Panels"] = "패널 잠금"
L["Prevent panels from being moved"] = "패널 이동 방지"
L["Show Login Message"] = "로그인 메시지 표시"
L["Show Minimap Icon"] = "미니맵 아이콘 표시"
L["Toggle the minimap button on or off"] = "미니맵 버튼 켜기/끄기"
L["Use 24Hr Clock"] = "24시간제 사용"
L["Use Class Color"] = "직업 색상 사용"
L["Use Custom Color"] = "사용자 지정 색상 사용"
L["X Offset"] = "X 오프셋"
L["Y Offset"] = "Y 오프셋"
L["When enabled, the addon will automatically switch to a different profile each time you change specialization. Pick which profile each spec should use below."] = "활성화하면 전문화를 변경할 때마다 애드온이 자동으로 다른 프로필로 전환됩니다. 아래에서 각 전문화가 사용할 프로필을 선택하세요."

-- ----------------------------
-- Config.lua - Panels
-- ----------------------------
L["Appearance"] = "외형"
L["Apply Slot Changes"] = "슬롯 변경 적용"
L["Are you sure you want to delete this bar?\nThis action cannot be undone."] = "이 바를 삭제하시겠습니까?\n이 작업은 취소할 수 없습니다."
L["Background Opacity"] = "배경 불투명도"
L["Border Color"] = "테두리 색상"
L["Border Size"] = "테두리 크기"
L["Create New Panel"] = "새 패널 만들기"
L["Height"] = "높이"
L["Number of Slots"] = "슬롯 수"
L["Panel Settings"] = "패널 설정"
L["Panels"] = "패널"
L["Remove Selected Panel"] = "선택한 패널 제거"
L["Rename Panel:"] = "패널 이름 변경:"
L["Scale"] = "크기"
L["Select Border:"] = "테두리 선택:"
L["Select Panel:"] = "패널 선택:"
L["Size & Scale"] = "크기 및 배율"
L["Slot Assignments"] = "슬롯 할당"
L["Slot %d:"] = "슬롯 %d:"
L["Slots"] = "슬롯"
L["Update slot assignment dropdowns after changing number of slots"] = "슬롯 수 변경 후 슬롯 할당 드롭다운 업데이트"
L["Width"] = "너비"

-- ----------------------------
-- Config.lua - Module Settings
-- ----------------------------
L["Module Settings"] = "모듈 설정"
L["Hide Decimals"] = "소수점 숨기기"
L["Show Label"] = "레이블 표시"
L["Show Short Label"] = "짧은 레이블 표시"

-- ----------------------------
-- Config.lua - Import/Export
-- ----------------------------
L["1. Click 'Generate Export String' above\n2. Click in this box\n3. Press Ctrl+A to select all\n4. Press Ctrl+C to copy"] = "1. 위의 '내보내기 문자열 생성' 클릭\n2. 이 상자 클릭\n3. Ctrl+A를 눌러 모두 선택\n4. Ctrl+C를 눌러 복사"
L["1. Paste an import string in the box below\n2. Click Accept\n3. Click 'Import Profile'"] = "1. 아래 상자에 가져오기 문자열 붙여넣기\n2. 수락 클릭\n3. '프로필 가져오기' 클릭"
L["Create an export string for your current profile"] = "현재 프로필에 대한 내보내기 문자열 생성"
L["Export"] = "내보내기"
L["Export String"] = "내보내기 문자열"
L["Export string generated! Copy it from the box below."] = "내보내기 문자열이 생성되었습니다! 아래 상자에서 복사하세요."
L["Export your current profile to share with others, or import a profile string.\n"] = "현재 프로필을 내보내 다른 사람과 공유하거나 프로필 문자열을 가져오세요.\n"
L["Generate Export String"] = "내보내기 문자열 생성"
L["Import"] = "가져오기"
L["Import/Export"] = "가져오기/내보내기"
L["Import Profile"] = "프로필 가져오기"
L["Import String"] = "가져오기 문자열"
L["Import the profile string from above (after clicking Accept)"] = "위의 프로필 문자열 가져오기 (수락 클릭 후)"
L["Please paste an import string and click Accept first"] = "먼저 가져오기 문자열을 붙여넣고 수락을 클릭하세요"
L["Profile Import/Export"] = "프로필 가져오기/내보내기"
L["This will overwrite your current profile. Are you sure?"] = "현재 프로필을 덮어씁니다. 계속하시겠습니까?"

-- ----------------------------
-- Utilities.lua
-- ----------------------------
L["Panels locked"] = "패널 잠김"
L["Panels unlocked"] = "패널 잠금 해제됨"

-- ----------------------------
-- modules/Agility.lua
-- ----------------------------
L["Agi"] = "민첩"

-- ----------------------------
-- modules/Armor.lua
-- ----------------------------
L["Mitigation By Level:"] = "레벨별 완화:"
L["Level %d"] = "레벨 %d"
L["Target Mitigation"] = "대상 완화"

-- ----------------------------
-- modules/AttackPower.lua
-- ----------------------------
L["AP"] = "AP"

-- ----------------------------
-- modules/Bags.lua
-- ----------------------------
L["Bags"] = "가방"

-- ----------------------------
-- modules/CombatTimer.lua
-- ----------------------------
L["Combat"] = "전투"
L["combat duration"] = "전투 지속시간"
L["Combat Timer"] = "전투 타이머"
L["Current"] = "현재"
L["Currently out of combat"] = "현재 전투 중 아님"
L["Display Duration"] = "지속시간 표시"
L["Enter combat to start tracking"] = "추적을 시작하려면 전투 진입"
L["Last"] = "마지막"
L["Left-click"] = "좌클릭"
L["Out of Combat"] = "비전투"
L["to reset"] = "재설정"

-- ----------------------------
-- modules/Crit.lua
-- ----------------------------
L["Crit"] = "치명타"

-- ----------------------------
-- modules/Currency.lua
-- ----------------------------
L["CURRENCIES"] = "화폐"
L["Tracked Currency Qty"] = "추적 중인 화폐 수량"
L["Currency Display Order"] = "화폐 표시 순서"
L["Position %d"] = "위치 %d"
L["Empty Slot"] = "빈 슬롯"

-- ----------------------------
-- modules/Durability.lua
-- ----------------------------
L["Dur:"] = "내구도:"
L["Durability:"] = "내구도:"

-------------------------------
-- modules/Experience.lua
-------------------------------
L["Max Level"] = "최대 레벨"
L["N/A"] = "해당 없음"
L["Experience"] = "경험치"
L["Display Format"] = "표시 형식"
L["Bar Toggles"] = "바 토글"
L["Show Graphical Bar"] = "그래픽 바 표시"
L["Hide Blizzard XP Bar"] = "블리자드 경험치 바 숨기기"
L["Bar Appearance"] = "바 외형"
L["Bar Height (%)"] = "바 높이 (%)"
L["Bar Use Class Color"] = "바 직업 색상 사용"
L["Bar Custom Color"] = "바 사용자 지정 색상"
L["Bar Texture"] = "바 텍스처"
L["Text Color"] = "텍스트 색상"
L["Text Use Class Color"] = "텍스트 직업 색상 사용"
L["Text Custom Color"] = "텍스트 사용자 지정 색상"

-- ----------------------------
-- modules/Friends.lua
-- ----------------------------
L["Ara Friends LDB object not found! SDT Friends datatext disabled."] = "Ara Friends LDB 객체를 찾을 수 없습니다! SDT 친구 데이터텍스트가 비활성화되었습니다."

-- ----------------------------
-- modules/Gold.lua
-- ----------------------------
L["Show Silver"] = "은화 표시"
L["Show Copper"] = "동화 표시"
L["Use Coin Icons"] = "화폐 아이콘 사용"
L["Display Quantities"] = "수량 표시"
L["Characters to Show"] = "표시할 캐릭터"
L["Servers to Show"] = "표시할 서버"
L["Session:"] = "세션:"
L["Earned:"] = "획득:"
L["Spent:"] = "지출:"
L["Profit:"] = "수익:"
L["Deficit:"] = "적자:"
L["Character:"] = "캐릭터:"
L["Server:"] = "서버:"
L["Faction:"] = "진영:"
L["Alliance:"] = "얼라이언스:"
L["Horde:"] = "호드:"
L["Total:"] = "총계:"
L["Warband:"] = "전투단:"
L["WoW Token:"] = "WoW 토큰:"
L["Reset Session Data: Hold Ctrl + Right Click"] = "세션 데이터 재설정: Ctrl + 우클릭 유지"
L["Gold: All data reset!"] = "골드: 모든 데이터 초기화!"
L["Gold: Data reset for %s!"] = "골드: %s 데이터 초기화!"
L["Are you sure you want to delete gold data for:\n\n|cFFFFFF00%s|r"] = "다음 캐릭터의 골드 데이터를 삭제하시겠습니까:\n\n|cFFFFFF00%s|r"
L["|cFFFF0000ALL CHARACTERS|r"] = "|cFFFF0000모든 캐릭터|r"
L["|cFF808080No character data found|r"] = "|cFF808080캐릭터 데이터를 찾을 수 없음|r"
L["Reset Session Data:"] = "세션 데이터 초기화:"
L["Hold Shift + Right Click"] = "Shift + 우클릭 유지"
L["Reset Character Gold Data:"] = "캐릭터 골드 데이터 초기화:"
L["Hold Alt + Right Click"] = "Alt + 우클릭 유지"

-- ----------------------------
-- modules/Guild.lua
-- ----------------------------
L["Ara Guild LDB object not found! SDT Guild datatext disabled."] = "Ara Guild LDB 객체를 찾을 수 없습니다! SDT 길드 데이터텍스트가 비활성화되었습니다."
L["Max Guild Name Length"] = "최대 길드 이름 길이"

-- ----------------------------
-- modules/Haste.lua
-- ----------------------------
L["Haste:"] = "가속:"

-- ----------------------------
-- modules/Hearthstone.lua
-- ----------------------------
L["Hearthstone"] = "귀환석"
L["Selected Hearthstone"] = "선택된 귀환석"
L["Random"] = "무작위"
L["Selected:"] = "선택됨:"
L["Available Hearthstones:"] = "사용 가능한 귀환석:"
L["Left Click: Use Hearthstone"] = "좌클릭: 귀환석 사용"
L["Right Click: Select Hearthstone"] = "우클릭: 귀환석 선택"
L["Cannot use hearthstone while in combat"] = "전투 중에는 귀환석을 사용할 수 없습니다"

-- ----------------------------
-- modules/Intellect.lua
-- ----------------------------
L["Int"] = "지능"

-- ----------------------------
-- modules/LDBObjects.lua
-- ----------------------------
L["NO TEXT"] = "텍스트 없음"

-- ----------------------------
-- modules/Mail.lua
-- ----------------------------
L["New Mail"] = "새 우편"
L["No Mail"] = "우편 없음"

-- ----------------------------
-- modules/MapName.lua
-- ----------------------------
L["Map Name"] = "지도 이름"
L["Zone Name"] = "지역 이름"
L["Subzone Name"] = "하위 지역 이름"
L["Zone - Subzone"] = "지역 - 하위 지역"
L["Zone / Subzone (Two Lines)"] = "지역 / 하위 지역 (두 줄)"
L["Minimap Zone"] = "미니맵 지역"
L["Show Zone on Tooltip"] = "툴팁에 지역 표시"
L["Show Coordinates on Tooltip"] = "툴팁에 좌표 표시"
L["Zone:"] = "지역:"
L["Subzone:"] = "하위 지역:"
L["Coordinates:"] = "좌표:"

-- ----------------------------
-- modules/Mastery.lua
-- ----------------------------
L["Mastery:"] = "특화:"

-- ----------------------------
-- modules/MythicPlusKey.lua
-- ----------------------------
L["Mythic+ Keystone"] = "신화+ 쐐기돌"
L["No Mythic+ Keystone"] = "신화+ 쐐기돌 없음"
L["Current Key:"] = "현재 쐐기돌:"
L["Dungeon Teleport is on cooldown for "] = "던전 순간이동 재사용 대기시간 "
L[" more seconds."] = "초 남음."
L["You do not know the teleport spell for "] = "순간이동 주문을 모릅니다: "
L["Key: "] = "쐐기돌: "
L["None"] = "없음"
L["No Key"] = "쐐기돌 없음"
L["Left Click: Teleport to Dungeon"] = "좌클릭: 던전으로 순간이동"
L["Right Click: List Group in Finder"] = "우클릭: 찾기에 그룹 등록"

-- ----------------------------
-- modules/SpecSwitch.lua
-- ----------------------------
L["Active"] = "활성"
L["Inactive"] = "비활성"
L["Loadouts"] = "장비 세트"
L["Failed to load Blizzard_PlayerSpells: %s"] = "Blizzard_PlayerSpells 로드 실패: %s"
L["Starter Build"] = "시작 빌드"
L["Spec"] = "전문화"
L["Left Click: Change Talent Specialization"] = "좌클릭: 특성 전문화 변경"
L["Control + Left Click: Change Loadout"] = "Ctrl + 좌클릭: 장비 세트 변경"
L["Shift + Left Click: Show Talent Specialization UI"] = "Shift + 좌클릭: 특성 전문화 UI 표시"
L["Shift + Right Click: Change Loot Specialization"] = "Shift + 우클릭: 전리품 전문화 변경"
L["Show Specialization Icon"] = "전문화 아이콘 표시"
L["Show Specialization Text"] = "전문화 텍스트 표시"
L["Show Loot Specialization Icon"] = "전리품 전문화 아이콘 표시"
L["Show Loot Specialization Text"] = "전리품 전문화 텍스트 표시"
L["Show Loadout"] = "장비 세트 표시"

-- ----------------------------
-- modules/Speed.lua
-- ----------------------------
L["Speed: "] = "속도: "

-- ----------------------------
-- modules/Stagger.lua
-- ----------------------------
L["Stagger Amount:"] = "완화량:"

-- ----------------------------
-- modules/Strength.lua
-- ----------------------------
L["Str"] = "힘"

-- ----------------------------
-- modules/System.lua
-- ----------------------------
L["MB_SUFFIX"] = "MB"
L["KB_SUFFIX"] = "KB"
L["SYSTEM"] = "시스템"
L["FPS:"] = "FPS:"
L["Home Latency:"] = "홈 지연시간:"
L["World Latency:"] = "월드 지연시간:"
L["Total Memory:"] = "총 메모리:"
L["(Shift Click) Collect Garbage"] = "(Shift 클릭) 가비지 수집"
L["FPS"] = "FPS"
L["MS"] = "MS"
L["Top Addons by Memory:"] = "메모리 사용량 상위 애드온:"
L["Top Addons in Tooltip"] = "툴팁에 상위 애드온 표시"
L["Total CPU:"] = "총 CPU:"
L["Top Addons by CPU:"] = "CPU 사용량 상위 애드온:"

-- ----------------------------
-- modules/Time.lua
-- ----------------------------
L["TIME"] = "시간"
L["Saved Raid(s)"] = "저장된 공격대"
L["Saved Dungeon(s)"] = "저장된 던전"
L["Display Realm Time"] = "서버 시간 표시"

-- ----------------------------
-- modules/Versatility.lua
-- ----------------------------
L["Vers:"] = "유연성:"

-- ----------------------------
-- modules/Volume.lua
-- ----------------------------
L["Select Volume Stream"] = "볼륨 스트림 선택"
L["Toggle Volume Stream"] = "볼륨 스트림 전환"
L["Output Audio Device"] = "출력 오디오 장치"
L["Active Output Audio Device"] = "활성 출력 오디오 장치"
L["Volume Streams"] = "볼륨 스트림"
L["Left Click: Select Volume Stream"] = "좌클릭: 볼륨 스트림 선택"
L["Middle Click: Toggle Mute Master Stream"] = "휠 클릭: 마스터 스트림 음소거 전환"
L["Shift + Middle Click: Toggle Volume Stream"] = "Shift + 휠 클릭: 볼륨 스트림 전환"
L["Shift + Left Click: Open System Audio Panel"] = "Shift + 좌클릭: 시스템 오디오 패널 열기"
L["Shift + Right Click: Select Output Audio Device"] = "Shift + 우클릭: 출력 오디오 장치 선택"
L["M. Vol"] = "마스터"
L["FX"] = "효과음"
L["Amb"] = "환경음"
L["Dlg"] = "대화"
L["Mus"] = "음악"

-- ----------------------------
-- Ara_Broker_Guild_Friends.lua
-- ----------------------------
L["Guild"] = "길드"
L["No Guild"] = "길드 없음"
L["Friends"] = "친구"
L["<Mobile>"] = "<모바일>"
L["Hints"] = "힌트"
L["Block"] = "차단"
L["Click"] = "클릭"
L["RightClick"] = "우클릭"
L["MiddleClick"] = "휠 클릭"
L["Modifier+Click"] = "조합키+클릭"
L["Shift+Click"] = "Shift+클릭"
L["Shift+RightClick"] = "Shift+우클릭"
L["Ctrl+Click"] = "Ctrl+클릭"
L["Ctrl+RightClick"] = "Ctrl+우클릭"
L["Alt+RightClick"] = "Alt+우클릭"
L["Ctrl+MouseWheel"] = "Ctrl+마우스 휠"
L["Button4"] = "버튼4"
L["to open panel."] = "패널 열기."
L["to display config menu."] = "설정 메뉴 표시."
L["to add a friend."] = "친구 추가."
L["to toggle notes."] = "메모 전환."
L["to whisper."] = "귓속말."
L["to invite."] = "초대."
L["to query information."] = "정보 조회."
L["to edit note."] = "메모 편집."
L["to edit officer note."] = "장교 메모 편집."
L["to remove friend."] = "친구 제거."
L["to sort main column."] = "메인 열 정렬."
L["to sort second column."] = "두 번째 열 정렬."
L["to sort third column."] = "세 번째 열 정렬."
L["to resize tooltip."] = "툴팁 크기 조정."
L["Mobile App"] = "모바일 앱"
L["Desktop App"] = "데스크톱 앱"
L["OFFLINE FAVORITE"] = "오프라인 즐겨찾기"
L["MOTD"] = "오늘의 메시지"
L["No friends online."] = "온라인 친구 없음."
L["Broadcast"] = "방송"
L["Invalid scale.\nShould be a number between 70 and 200%"] = "잘못된 크기입니다.\n70에서 200% 사이의 숫자여야 합니다"
L["Set a custom tooltip scale.\nEnter a value between 70 and 200 (%%)."] = "사용자 지정 툴팁 크기를 설정하세요.\n70에서 200(%%) 사이의 값을 입력하세요."
L["Simple Datatexts Favorite"] = "Simple Datatexts 즐겨찾기"
L["Guilded"] = "Guilded"
L["Battle.net App"] = "Battle.net 앱"
L["Invite"] = "초대"
L["Leave/Hide"] = "떠나기/숨기기"
L["In-game"] = "게임 내"
L["Away"] = "자리 비움"
L["Busy"] = "다른 용무 중"