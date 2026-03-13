extends Control

# ═══════════════════════════════════════════════════
# 🏠 القائمة الرئيسية
# ═══════════════════════════════════════════════════

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var title_label: Label = $TitleLabel

func _ready():
	# ربط الأزرار بالدوال
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# تحديث النصوص بناءً على اللغة المختارة
	update_ui_text()
	
	# ربط إشارة تغيير اللغة
	GameSettings.language_changed.connect(update_ui_text)

func update_ui_text():
	start_button.text = GameSettings.get_text("MAIN_MENU_START")
	settings_button.text = GameSettings.get_text("MAIN_MENU_SETTINGS")
	exit_button.text = GameSettings.get_text("MAIN_MENU_EXIT")
	
	# ضبط اتجاه النص (RTL للعربية)
	if GameSettings.current_language == GameSettings.Language.ARABIC:
		layout_direction = Control.LAYOUT_DIRECTION_RTL
	else:
		layout_direction = Control.LAYOUT_DIRECTION_LTR

func _on_start_pressed():
	# الانتقال إلى مشهد اللعبة الأول (الغابة)
	get_tree().change_scene_to_file("res://world/world.tscn")

func _on_settings_pressed():
	# فتح قائمة الإعدادات (سيتم تنفيذها لاحقاً)
	print("Settings Pressed")

func _on_exit_pressed():
	get_tree().quit()
