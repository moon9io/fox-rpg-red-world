extends CanvasLayer

# ═══════════════════════════════════════════════════
# 💬 مدير الحوارات (Dialogue Manager)
# ═══════════════════════════════════════════════════

@onready var dialogue_box: Panel = $DialogueBox
@onready var text_label: Label = $DialogueBox/TextLabel
@onready var name_label: Label = $DialogueBox/NameLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_dialogue: Array = []
var dialogue_index: int = 0
var is_active: bool = false

signal dialogue_finished

func _ready():
	dialogue_box.visible = false
	# إعدادات الخط العربي (يجب تحميل خط يدعم العربية لاحقاً)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func start_dialogue(dialogue_data: Array):
	if is_active: return
	
	current_dialogue = dialogue_data
	dialogue_index = 0
	is_active = true
	dialogue_box.visible = true
	
	# إيقاف حركة اللاعب أثناء الحوار
	get_tree().paused = true
	
	show_next_line()

func show_next_line():
	if dialogue_index < current_dialogue.size():
		var line = current_dialogue[dialogue_index]
		var lang = GameSettings.current_language
		
		# اختيار النص بناءً على اللغة
		var text = line["text"][lang]
		var name = line["name"][lang]
		
		name_label.text = name
		text_label.text = text
		
		# تأثير الكتابة التدريجية (اختياري)
		# text_label.visible_ratio = 0
		# create_tween().tween_property(text_label, "visible_ratio", 1.0, 1.0)
		
		dialogue_index += 1
	else:
		finish_dialogue()

func finish_dialogue():
	is_active = false
	dialogue_box.visible = false
	get_tree().paused = false
	emit_signal("dialogue_finished")

func _input(event):
	if is_active and event.is_action_pressed("ui_accept"):
		show_next_line()
