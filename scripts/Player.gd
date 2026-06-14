extends CharacterBody2D

signal health_changed(current: int, max_hp: int)
signal died

const SPEED := 200.0

@export var max_hp: int = 100
var current_hp: int
var _dead := false

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	current_hp = max_hp
	add_to_group("player")
	health_changed.emit(current_hp, max_hp)

func _physics_process(_delta: float) -> void:
	var dir := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	velocity = dir * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()

func take_damage(amount: int) -> void:
	if _dead:
		return
	var reduction := GameManager.get_defense_reduction()
	current_hp -= int(amount * (1.0 - reduction))
	current_hp = max(current_hp, 0)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		die()

func die() -> void:
	if _dead:
		return
	_dead = true
	set_physics_process(false)
	GameManager.lose_all_scrap()
	died.emit()
