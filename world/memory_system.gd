extends Node

# ═══════════════════════════════════════════════════
# 🧩 نظام الذاكرة المفقودة (Memory Fragments)
# ═══════════════════════════════════════════════════

var collected_memories: Array[String] = []

# قاعدة بيانات الذكريات (قصة مخفية)
var memory_database = {
	"memory_1": {
		"title": { GameSettings.Language.ARABIC: "ذكرى: يوم الانقسام", GameSettings.Language.ENGLISH: "Memory: The Day of Split" },
		"text": { GameSettings.Language.ARABIC: "رأيت السماء تتحول للون الأحمر. لم يكن غضباً، بل كان حزناً عميقاً من الأرض نفسها.", 
				  GameSettings.Language.ENGLISH: "I saw the sky turn red. It wasn't anger, but a deep sorrow from the earth itself." }
	},
	"memory_2": {
		"title": { GameSettings.Language.ARABIC: "ذكرى: الحارس المفقود", GameSettings.Language.ENGLISH: "Memory: The Lost Guardian" },
		"text": { GameSettings.Language.ARABIC: "الثعلب لم يكن مجرد حيوان، كان روحاً اختارت هذا الشكل لتبقى قريبة من البشر.", 
				  GameSettings.Language.ENGLISH: "The Fox wasn't just an animal; it was a spirit that chose this form to stay close to humans." }
	}
}

func collect_memory(memory_id: String):
	if not collected_memories.has(memory_id):
		collected_memories.append(memory_id)
		show_memory_popup(memory_id)
		
		# التحقق من إنجاز "النهاية الحقيقية"
		if collected_memories.size() >= memory_database.size():
			AchievementManager.unlock("true_ending")

func show_memory_popup(memory_id: String):
	var data = memory_database[memory_id]
	var lang = GameSettings.current_language
	
	# استدعاء نظام الحوارات لعرض الذكرى
	var dialogue = [
		{ "name": data["title"], "text": data["text"] }
	]
	DialogueManager.start_dialogue(dialogue)

signal memory_collected(id)
