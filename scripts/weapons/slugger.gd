class_name Slugger
extends Weapon

@export var bullet_scene: PackedScene

func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("attack_ranged") and _is_ready():
		_shoot()

func _shoot() -> void:
	if not bullet_scene:
		return
	_start_cooldown()

	var bullet: Node2D = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position

	# accuracy 낮을수록 발사각 오프셋 증가
	var accuracy := data.accuracy if data else 1.0
	var spread := (1.0 - accuracy) * PI * 0.3
	var angle := global_rotation + randf_range(-spread, spread)
	bullet.direction = Vector2.from_angle(angle)
	bullet.damage = int(data.damage * GameManager.get_damage_multiplier()) if data else 8
