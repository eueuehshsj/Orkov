class_name EnemyBurst
extends EnemyRifle

const BURST_COUNT := 3
const BURST_INTERVAL := 0.15

var _burst_remaining: int = 0
var _burst_timer: float = 0.0

func _do_attack(delta: float) -> void:
	if not is_instance_valid(_player):
		state = State.PATROL
		return
	if global_position.distance_to(_player.global_position) > data.attack_range * 1.1:
		state = State.CHASE
	velocity = Vector2.ZERO
	move_and_slide()
	look_at(_player.global_position)

	if _burst_remaining > 0:
		_burst_timer -= delta
		if _burst_timer <= 0.0:
			_fire_single()
			_burst_remaining -= 1
			_burst_timer = BURST_INTERVAL
	else:
		_attack_cooldown -= delta
		if _attack_cooldown <= 0.0:
			_burst_remaining = BURST_COUNT
			_burst_timer = 0.0
			_attack_cooldown = data.fire_rate
