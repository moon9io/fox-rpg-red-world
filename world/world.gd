extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	spawn_npcs()

func spawn_npcs():
	# إضافة شخصية البومة الحكيمة برمجياً
	var owl = CharacterBody2D.new()
	owl.name = "WiseOwl"
	owl.position = Vector2(100, 100)
	owl.set_script(load("res://world/npc.gd"))
	owl.set("npc_name_ar", "البومة الحكيمة")
	owl.set("npc_name_en", "Wise Owl")
	owl.set("dialogue_ar", ["أهلاً بك في عالم إيريثيا.", "العالم الأحمر ليس شراً، بل هو ذكرى."])
	owl.set("dialogue_en", ["Welcome to Erytheia.", "The Red World is not evil, it's a memory."])
	add_child(owl)
	
	# إضافة روح تائهة
	var soul = CharacterBody2D.new()
	soul.name = "LostSoul"
	soul.position = Vector2(300, 200)
	soul.set_script(load("res://world/npc.gd"))
	soul.set("npc_name_ar", "روح تائهة")
	soul.set("npc_name_en", "Lost Soul")
	soul.set("dialogue_ar", ["هل رأيت سيفي المكسور؟", "لقد فقدته في الغابة."])
	soul.set("dialogue_en", ["Have you seen my broken sword?", "I lost it in the forest."])
	add_child(soul)
