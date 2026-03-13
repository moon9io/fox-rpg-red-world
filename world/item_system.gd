extends Node

# ═══════════════════════════════════════════════════
# 🎒 نظام العناصر وبطاقات المهارات
# ═══════════════════════════════════════════════════

enum ItemType { STORY, SKILL, CONSUMABLE }

class Item:
	var id: String
	var name: Dictionary # { Language.ARABIC: "اسم", Language.ENGLISH: "Name" }
	var description: Dictionary # { Language.ARABIC: "وصف", Language.ENGLISH: "Description" }
	var type: ItemType
	var icon_path: String
	
	func _init(_id, _name, _desc, _type, _icon):
		id = _id
		name = _name
		description = _desc
		type = _type
		icon_path = _icon

var inventory: Array[Item] = []
var skills: Array[Item] = []

# قاعدة بيانات العناصر (مثال لقصة غامضة)
var item_database = {
	"broken_sword": Item.new(
		"broken_sword",
		{ GameSettings.Language.ARABIC: "سيف مكسور", GameSettings.Language.ENGLISH: "Broken Sword" },
		{ GameSettings.Language.ARABIC: "نصل قديم يحمل رائحة الدماء الجافة. يبدو أنه كان ملكاً لحارس الغابة قبل الانقسام.", 
		  GameSettings.Language.ENGLISH: "An old blade smelling of dried blood. It seems it belonged to the Forest Guardian before the split." },
		ItemType.STORY,
		"res://world/items/broken_sword.png"
	),
	"red_crystal": Item.new(
		"red_crystal",
		{ GameSettings.Language.ARABIC: "كريستالة حمراء", GameSettings.Language.ENGLISH: "Red Crystal" },
		{ GameSettings.Language.ARABIC: "قطعة من جوهر العالم الأحمر. تهمس بأصوات أولئك الذين فقدوا طريقهم.", 
		  GameSettings.Language.ENGLISH: "A piece of the Red World's essence. It whispers with the voices of those who lost their way." },
		ItemType.STORY,
		"res://world/items/red_crystal.png"
	),
	"skill_speed": Item.new(
		"skill_speed",
		{ GameSettings.Language.ARABIC: "بطاقة السرعة", GameSettings.Language.ENGLISH: "Speed Card" },
		{ GameSettings.Language.ARABIC: "تزيد من سرعة حركة الثعلب بنسبة 20%.", 
		  GameSettings.Language.ENGLISH: "Increases the Fox's movement speed by 20%." },
		ItemType.SKILL,
		"res://world/items/skill_speed.png"
	)
}

func add_item(item_id: String):
	if item_database.has(item_id):
		var item = item_database[item_id]
		if item.type == ItemType.SKILL:
			skills.append(item)
			apply_skill(item_id)
		else:
			inventory.append(item)
		
		# إطلاق إشارة لتحديث الواجهة
		emit_signal("inventory_updated")
		
		# التحقق من إنجاز "جامع القصص"
		check_story_collector_achievement()

func apply_skill(skill_id: String):
	# منطق تطبيق المهارة على اللاعب
	var player = get_tree().get_first_node_in_group("player")
	if player:
		match skill_id:
			"skill_speed":
				player.MAX_SPEED *= 1.2
			"skill_strength":
				# زيادة الضرر (يتطلب تعديل في نظام القتال)
				pass

func check_story_collector_achievement():
	if inventory.size() >= 5:
		# AchievementManager.unlock("story_collector")
		pass

signal inventory_updated
