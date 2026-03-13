extends Node

# ═══════════════════════════════════════════════════
# 🏆 مدير الإنجازات (Achievement Manager)
# ═══════════════════════════════════════════════════

var achievements = {
	"explorer": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "المستكشف", GameSettings.Language.ENGLISH: "Explorer" }, "desc": { GameSettings.Language.ARABIC: "زيارة جميع المناطق الأربعة.", GameSettings.Language.ENGLISH: "Visit all four regions." } },
	"soul_hunter": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "صائد الأرواح", GameSettings.Language.ENGLISH: "Soul Hunter" }, "desc": { GameSettings.Language.ARABIC: "هزيمة 20 عدواً.", GameSettings.Language.ENGLISH: "Defeat 20 enemies." } },
	"story_collector": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "جامع القصص", GameSettings.Language.ENGLISH: "Story Collector" }, "desc": { GameSettings.Language.ARABIC: "قراءة جميع أوصاف العناصر.", GameSettings.Language.ENGLISH: "Read all item descriptions." } },
	"pacifist": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "المسالم", GameSettings.Language.ENGLISH: "Pacifist" }, "desc": { GameSettings.Language.ARABIC: "إنهاء منطقة الغابة دون قتل أي عدو.", GameSettings.Language.ENGLISH: "Finish the Forest region without killing any enemy." } },
	"world_master": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "سيد العالمين", GameSettings.Language.ENGLISH: "World Master" }, "desc": { GameSettings.Language.ARABIC: "التبديل بين العالمين 50 مرة.", GameSettings.Language.ENGLISH: "Switch between worlds 50 times." } },
	"detective": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "المحقق", GameSettings.Language.ENGLISH: "Detective" }, "desc": { GameSettings.Language.ARABIC: "التحدث مع جميع الشخصيات.", GameSettings.Language.ENGLISH: "Talk to all characters." } },
	"survivor": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "الناجي", GameSettings.Language.ENGLISH: "Survivor" }, "desc": { GameSettings.Language.ARABIC: "إنهاء اللعبة بصحة كاملة.", GameSettings.Language.ENGLISH: "Finish the game with full health." } },
	"spender": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "المبذر", GameSettings.Language.ENGLISH: "Spender" }, "desc": { GameSettings.Language.ARABIC: "شراء جميع التلميحات من المتجر.", GameSettings.Language.ENGLISH: "Buy all hints from the shop." } },
	"boss_slayer": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "قاهر الزعيم", GameSettings.Language.ENGLISH: "Boss Slayer" }, "desc": { GameSettings.Language.ARABIC: "هزيمة الزعيم النهائي.", GameSettings.Language.ENGLISH: "Defeat the final boss." } },
	"true_ending": { "unlocked": false, "name": { GameSettings.Language.ARABIC: "النهاية الحقيقية", GameSettings.Language.ENGLISH: "True Ending" }, "desc": { GameSettings.Language.ARABIC: "جمع كل قطع الذاكرة.", GameSettings.Language.ENGLISH: "Collect all memory fragments." } }
}

var score: int = 0
var enemies_killed: int = 0
var world_switches: int = 0

signal achievement_unlocked(id)
signal score_updated(new_score)

func add_score(points: int):
	score += points
	emit_signal("score_updated", score)

func unlock(id: String):
	if achievements.has(id) and not achievements[id]["unlocked"]:
		achievements[id]["unlocked"] = true
		emit_signal("achievement_unlocked", id)
		print("Achievement Unlocked: ", achievements[id]["name"][GameSettings.current_language])
		# هنا يمكن إضافة إشعار بوب-أب (Popup Notification)

func on_enemy_killed():
	enemies_killed += 1
	add_score(10)
	if enemies_killed >= 20:
		unlock("soul_hunter")

func on_world_switch():
	world_switches += 1
	if world_switches >= 50:
		unlock("world_master")
