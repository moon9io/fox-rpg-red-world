extends CharacterBody2D

# ═══════════════════════════════════════════════════
# 🦉 سكربت الشخصيات (NPC Script)
# ═══════════════════════════════════════════════════

@export var npc_name_ar: String = "بومة حكيمة"
@export var npc_name_en: String = "Wise Owl"
@export var dialogue_ar: Array[String] = ["مرحباً بك أيها الثعلب.", "العالم ينقسم، وعليك جمعه."]
@export var dialogue_en: Array[String] = ["Welcome, little fox.", "The world is splitting, you must unite it."]

var player_in_range = false

func _ready():
	# إعداد منطقة التفاعل (Area2D) برمجياً إذا لم تكن موجودة
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 40
	collision.shape = circle
	area.add_child(collision)
	add_child(area)
	
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		# إظهار تلميح للتفاعل (اختياري)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _input(event):
	if player_in_range and event.is_action_pressed("ui_accept"):
		start_dialogue()

func start_dialogue():
	var dialogue_data = []
	for i in range(dialogue_ar.size()):
		dialogue_data.append({
			"name": { GameSettings.Language.ARABIC: npc_name_ar, GameSettings.Language.ENGLISH: npc_name_en },
			"text": { GameSettings.Language.ARABIC: dialogue_ar[i], GameSettings.Language.ENGLISH: dialogue_en[i] }
		})
	
	DialogueManager.start_dialogue(dialogue_data)
