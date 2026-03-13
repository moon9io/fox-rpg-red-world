extends CanvasLayer

# ═══════════════════════════════════════════════════
# 🌦️ نظام الطقس الديناميكي (Weather System)
# ═══════════════════════════════════════════════════

@onready var rain_particles: GPUParticles2D = $RainParticles
@onready var fog_overlay: ColorRect = $FogOverlay
@onready var thunder_timer: Timer = $ThunderTimer

enum Weather { CLEAR, RAIN, FOG, BLOOD_STORM }
var current_weather = Weather.CLEAR

func _ready():
	# ربط نظام الطقس بتغيير العالم
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.connect("world_switched", _on_world_switched)

func _on_world_switched(is_red_world: bool):
	if is_red_world:
		set_weather(Weather.BLOOD_STORM)
	else:
		set_weather(Weather.RAIN if randf() > 0.5 else Weather.CLEAR)

func set_weather(weather: Weather):
	current_weather = weather
	match weather:
		Weather.CLEAR:
			rain_particles.emitting = false
			create_tween().tween_property(fog_overlay, "modulate:a", 0.0, 2.0)
		Weather.RAIN:
			rain_particles.emitting = true
			rain_particles.modulate = Color(0.5, 0.5, 1.0, 0.5)
		Weather.BLOOD_STORM:
			rain_particles.emitting = true
			rain_particles.modulate = Color(1.0, 0.0, 0.0, 0.6) # مطر أحمر
			create_tween().tween_property(fog_overlay, "modulate:a", 0.3, 1.0)
			start_thunder_effect()

func start_thunder_effect():
	# تأثير البرق في العالم الأحمر
	if current_weather == Weather.BLOOD_STORM:
		var flash = ColorRect.new()
		flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		flash.color = Color(1, 1, 1, 0.8)
		add_child(flash)
		await get_tree().create_timer(0.1).timeout
		flash.queue_free()
		
		# تكرار عشوائي
		get_tree().create_timer(randf_range(3, 7)).timeout.connect(start_thunder_effect)
