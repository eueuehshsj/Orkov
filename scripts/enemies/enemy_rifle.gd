class_name EnemyRifle
extends EnemyBase

const BULLET_SCENE := preload("res://scenes/enemies/enemy_bullet.tscn")

@export var waypoints: Array[Vector2] = []

var _waypoint_idx: int = 0
var _attack_cooldown: float = 0.0

func _do_patrol(_delta: float) -> void:
	if waypoints.is_empty():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var target := waypoints[_waypoint_idx]
	if global_position.distance_to(target) < 8.0:
		_waypoint_idx = (_waypoint_idx + 1) % waypoints.size()
	else:
		_navigate_to(target)

func _do_attack(delta: float) -> void:
	super._do_attack(delta)
	_attack_cooldown -= delta
	if _attack_cooldown <= 0.0:
		_fire_single()
		_attack_cooldown = data.fire_rate

func _fire_single() -> void:
	if not is_instance_valid(_player) or state != State.ATTACK:
		return
	var bullet := BULLET_SCENE.instantiate() as EnemyBullet
	bullet.damage = data.attack_damage
	bullet.direction = (_player.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
