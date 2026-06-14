class_name EnemyBase
extends CharacterBody2D

enum State { PATROL, CHASE, ATTACK, DEAD }

@export var data: EnemyData

var current_hp: float
var state: State = State.PATROL
var _player: Node2D = null

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: Area2D = $DetectionArea

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	if data:
		current_hp = data.max_hp
		_apply_detection_range()
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)

func _apply_detection_range() -> void:
	var col := detection_area.get_node("CollisionShape2D") as CollisionShape2D
	var new_shape := CircleShape2D.new()
	new_shape.radius = data.detection_range
	col.shape = new_shape

func _physics_process(delta: float) -> void:
	match state:
		State.PATROL: _do_patrol(delta)
		State.CHASE:  _do_chase(delta)
		State.ATTACK: _do_attack(delta)
		State.DEAD:   pass

func _do_patrol(_delta: float) -> void:
	pass

func _do_chase(_delta: float) -> void:
	if not is_instance_valid(_player):
		state = State.PATROL
		return
	if global_position.distance_to(_player.global_position) <= data.attack_range:
		state = State.ATTACK
		return
	_navigate_to(_player.global_position)

func _do_attack(_delta: float) -> void:
	if not is_instance_valid(_player):
		state = State.PATROL
		return
	if global_position.distance_to(_player.global_position) > data.attack_range * 1.1:
		state = State.CHASE
	velocity = Vector2.ZERO
	move_and_slide()
	look_at(_player.global_position)

func _navigate_to(target_pos: Vector2) -> void:
	nav_agent.target_position = target_pos
	var next := nav_agent.get_next_path_position()
	# fallback to direct movement when no navmesh is available
	var dir := (next - global_position).normalized() if next.distance_to(global_position) > 2.0 \
		else (target_pos - global_position).normalized()
	velocity = dir * data.move_speed
	move_and_slide()

func take_damage(amount: float) -> void:
	if state == State.DEAD:
		return
	current_hp -= amount
	if current_hp <= 0.0:
		die()

func die() -> void:
	state = State.DEAD
	if data:
		GameManager.add_scrap(data.scrap_drop)
	_on_die()
	queue_free()

func _on_die() -> void:
	pass

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and state != State.DEAD:
		_player = body
		state = State.CHASE

func _on_detection_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
		if state != State.DEAD:
			state = State.PATROL
