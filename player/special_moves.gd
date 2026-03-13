extends Node

# ═══════════════════════════════════════════════════
# ⚔️ نظام الحركات الخاصة (Special Moves)
# ═══════════════════════════════════════════════════

@onready var player = get_parent()
@onready var stats = PlayerStats

var special_moves = {
	"dash_attack": { "cost": 20, "unlocked": false, "name": { GameSettings.Language.ARABIC: "هجوم الاندفاع", GameSettings.Language.ENGLISH: "Dash Attack" } },
	"spin_attack": { "cost": 50, "unlocked": false, "name": { GameSettings.Language.ARABIC: "الهجوم الدوار", GameSettings.Language.ENGLISH: "Spin Attack" } },
	"world_burst": { "cost": 100, "unlocked": false, "name": { GameSettings.Language.ARABIC: "انفجار العالمين", GameSettings.Language.ENGLISH: "World Burst" } }
}

func _input(event):
	if event.is_action_pressed("special_move_1"):
		use_special_move("dash_attack")
	elif event.is_action_pressed("special_move_2"):
		use_special_move("spin_attack")

func use_special_move(move_id: String):
	if special_moves.has(move_id) and AchievementManager.score >= special_moves[move_id]["cost"]:
		# خصم النقاط (اختياري، أو جعلها تعتمد على طاقة Mana)
		# AchievementManager.add_score(-special_moves[move_id]["cost"])
		
		match move_id:
			"dash_attack":
				perform_dash_attack()
			"spin_attack":
				perform_spin_attack()
			"world_burst":
				perform_world_burst()

func perform_dash_attack():
	# منطق الهجوم المندفع
	player.state = player.ROLL
	player.sword_hitbox.damage = 2 # ضرر مضاعف
	await get_tree().create_timer(0.3).timeout
	player.sword_hitbox.damage = 1

func perform_spin_attack():
	# منطق الهجوم الدوار (360 درجة)
	player.animation_state.travel("Attack")
	# هنا يمكن إضافة تأثير بصري دائري (Circle Effect)
	print("Spin Attack Activated!")

func perform_world_burst():
	# حركة قوية تدمج العالمين للحظة وتدمر جميع الأعداء القريبين
	if player.in_red_world:
		# تأثير بصري قوي
		print("World Burst: Merging Realities!")
		# هزيمة الأعداء في دائرة معينة
		pass
