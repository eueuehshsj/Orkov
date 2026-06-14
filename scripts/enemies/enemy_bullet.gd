class_name EnemyBullet
extends Area2D

const SPEED := 300.0
const LIFETIME := 3.0

var damage: float = 10.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	get_tree().create_timer(LIFETIME).timeout.connect(queue_free)

func _process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent.has_method("take_damage"):
		parent.take_damage(damage)
	queue_free()
