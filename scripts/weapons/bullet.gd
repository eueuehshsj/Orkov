class_name Bullet
extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 400.0
var damage: int = 8
var _lifetime: float = 2.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, Color.YELLOW)

func _process(delta: float) -> void:
	position += direction * speed * delta
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent()
	if enemy.has_method("take_damage"):
		enemy.take_damage(damage)
		queue_free()

# 벽(StaticBody2D)에 맞으면 소멸
func _on_body_entered(_body: Node2D) -> void:
	queue_free()
