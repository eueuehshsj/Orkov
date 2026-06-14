extends CharacterBody2D

const SPEED := 200.0

@export var max_hp: int = 100
var current_hp: int

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	current_hp = max_hp
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	velocity = dir * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()

func take_damage(amount: int) -> void:
	var reduction := GameManager.get_defense_reduction()
	current_hp -= int(amount * (1.0 - reduction))
	if current_hp <= 0:
		die()

func die() -> void:
	GameManager.lose_all_scrap()
	GameManager.go_to_base({"success": false, "died": true, "scrap_gained": 0, "quest_complete": false})
