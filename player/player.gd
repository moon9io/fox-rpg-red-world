extends CharacterBody2D

# ═══════════════════════════════════════════════════
# 🎮 متغيرات العالم الأحمر/الأبيض
# ═══════════════════════════════════════════════════
var in_red_world = false
var health = 100
var max_health = 100
var health_timer = 0.0
var red_overlay = null
signal world_switched(is_red_world)
var world_tween: Tween

# ═══════════════════════════════════════════════════
# 🏃 متغيرات الحركة الأصلية
# ═══════════════════════════════════════════════════
const MAX_SPEED = 150
const ACCELERATION = 500
const FRICTION = 1000
const ROLL_SPEED = 1.5

enum { MOVE, ROLL, ATTACK }
var state = MOVE
var roll_vector = Vector2.RIGHT

# ═══════════════════════════════════════════════════
# 🔗 المراجع
# ═══════════════════════════════════════════════════
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sword_hitbox: Area2D = $SwordHitbox
@onready var hurt_box: Area2D = $HurtBox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar  # ⭐ جديد: شريط صحة
@onready var sprite: Sprite2D = $Sprite2D

var stats = PlayerStats
@onready var special_moves_node: SpecialMoves = $SpecialMoves


# ═══════════════════════════════════════════════════
# 🔄 دوال العالم الأحمر/الأبيض
# ═══════════════════════════════════════════════════

func switch_world():
	emit_signal("world_switched", !in_red_world)
	"""التبديل بين العالمين مع تأثيرات بصرية سلسة"""
	in_red_world = !in_red_world
	
	# إيجاد طبقة التغطية الحمراء إذا لم تكن موجودة
	if red_overlay == null:
		red_overlay = get_tree().get_first_node_in_group("red_overlay")
	
	# إيقاف أي تويين سابق
	if world_tween and world_tween.is_running():
		world_tween.kill()
	
	# إنشاء تويين جديد للتأثيرات السلسة
	world_tween = create_tween()
	world_tween.set_parallel(true)
	
	if in_red_world:
		# تأثير الانتقال إلى العالم الأحمر
		world_tween.tween_property(sprite, "modulate", Color(1, 0.5, 0.5), 0.3)
		if red_overlay:
			red_overlay.visible = true
			world_tween.tween_property(red_overlay, "modulate", Color(1, 1, 1, 0.3), 0.3)
	else:
		# العودة للعالم الطبيعي
		world_tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)
		if red_overlay:
			world_tween.tween_property(red_overlay, "modulate", Color(1, 1, 1, 0), 0.3).finished.connect(
				func(): red_overlay.visible = false
			)
	
	# إصدار صوت بسيط (اختياري)
	# $SwitchSound.play()


# ═══════════════════════════════════════════════════
# 🎬 دوال Godot الأساسية
# ═══════════════════════════════════════════════════

func _ready():
	add_child(preload("res://player/special_moves.gd").instantiate())
	get_node("SpecialMoves").player = self
	get_node("SpecialMoves").stats = PlayerStats
	stats.no_health.connect(_on_stats_no_health)
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector
	
	# ⭐ تحسينات إضافية
	initialize_health_bar()
	find_red_overlay()


func _process(delta):
	# نقص الصحة في العالم الأحمر
	if in_red_world:
		health_timer += delta
		if health_timer >= 1.0:
			health -= 10
			health_timer = 0.0
			print("Health: ", health)
			
			# تحديث شريط الصحة
			if health_bar:
				health_bar.value = health
			
			if health <= 0:
				die()


func _physics_process(delta: float) -> void:
	# استدعاء الحركات الخاصة
	if Input.is_action_just_pressed("special_move_1"):
		special_moves_node.use_special_move("dash_attack")
	elif Input.is_action_just_pressed("special_move_2"):
		special_moves_node.use_special_move("spin_attack")
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	# التبديل بين العالمين عند الضغط على Space
	if Input.is_action_just_pressed("ui_accept"):
		switch_world()


# ═══════════════════════════════════════════════════
# 🏃 دوال الحركة الأصلية (بدون تغيير)
# ═══════════════════════════════════════════════════

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)

	else:
		animation_state.travel("Idle")
		velocity = Vector2.ZERO

	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		hurt_box.start_invincibility(0.5)
		state = ROLL


func attack_state(delta):
	animation_state.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION / 10 * delta)
	move_and_slide()


func roll_state(delta):
	animation_state.travel("Roll")
	velocity = velocity.move_toward(roll_vector * MAX_SPEED * ROLL_SPEED, delta * ACCELERATION)
	move_and_slide()


func roll_finished():
	state = MOVE


func attack_finished():
	state = MOVE


# ═══════════════════════════════════════════════════
# 💥 دوال التفاعل مع الأذى
# ═══════════════════════════════════════════════════

func _on_hurt_box_area_entered(area: Area2D) -> void:
	hurt_box.start_invincibility(0.8)
	hurt_box.create_hit_effect()
	stats.aply_damage(1)
	
	# ⭐ تأثير اهتزاز بسيط عند الإصابة
	if health_bar:
		health_bar.value = stats.health


func _on_stats_no_health() -> void:
	queue_free()


func _on_hurt_box_invincibility_ended() -> void:
	blink_animation_player.play("stop")


func _on_hurt_box_invincibility_started() -> void:
	blink_animation_player.play("start")


# ═══════════════════════════════════════════════════
# ⚰️ الموت وإعادة التشغيل
# ═══════════════════════════════════════════════════

func die():
	print("Game Over!")
	
	# ⭐ تأثير بسيط قبل إعادة التشغيل
	modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.5).timeout
	
	get_tree().reload_current_scene()


# ═══════════════════════════════════════════════════
# 🛠️ دوال مساعدة جديدة
# ═══════════════════════════════════════════════════

func initialize_health_bar():
	"""إعداد شريط الصحة إذا كان موجوداً"""
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
		health_bar.modulate = Color(1, 1, 1, 0.8)


func find_red_overlay():
	"""البحث عن طبقة التغطية الحمراء في المشهد"""
	red_overlay = get_tree().get_first_node_in_group("red_overlay")
	if red_overlay == null:
		print("⚠️ تحذير: لم يتم العثور على red_overlay. تأكد من إضافته إلى مجموعة 'red_overlay'")
