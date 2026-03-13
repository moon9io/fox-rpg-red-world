extends Node

# ═══════════════════════════════════════════════════
# ⚙️ إعدادات اللعبة المركزية
# ═══════════════════════════════════════════════════

enum Language { ARABIC, ENGLISH }

var current_language: Language = Language.ARABIC
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

# بيانات الترجمة
var translations = {
	"MAIN_MENU_START": { Language.ARABIC: "ابدأ اللعبة", Language.ENGLISH: "Start Game" },
	"MAIN_MENU_SETTINGS": { Language.ARABIC: "الإعدادات", Language.ENGLISH: "Settings" },
	"MAIN_MENU_EXIT": { Language.ARABIC: "خروج", Language.ENGLISH: "Exit" },
	"SETTINGS_LANGUAGE": { Language.ARABIC: "اللغة", Language.ENGLISH: "Language" },
	"SETTINGS_VOLUME": { Language.ARABIC: "مستوى الصوت", Language.ENGLISH: "Volume" },
	"SETTINGS_BACK": { Language.ARABIC: "عودة", Language.ENGLISH: "Back" },
	"GAME_OVER": { Language.ARABIC: "انتهت اللعبة", Language.ENGLISH: "Game Over" },
	"RETRY": { Language.ARABIC: "إعادة المحاولة", Language.ENGLISH: "Retry" },
	"SCORE": { Language.ARABIC: "النقاط: ", Language.ENGLISH: "Score: " },
	"HINT": { Language.ARABIC: "تلميح: ", Language.ENGLISH: "Hint: " }
}

func get_text(key: String) -> String:
	if translations.has(key):
		return translations[key][current_language]
	return key

func set_language(lang: Language):
	current_language = lang
	# هنا يمكن إضافة إشارة (Signal) لتحديث الواجهات تلقائياً
	emit_signal("language_changed")

signal language_changed
