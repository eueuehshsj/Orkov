class_name MeleeClaw
extends Weapon

@onready var _hitbox: Area2D = $ClawHitbox

func _ready() -> void:
	_hitbox.monitoring = false

func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("attack_melee") and _is_ready():
		_attack()

func _attack() -> void:
	_start_cooldown()
	_hitbox.monitoring = true

	# 임시 Tween 애니메이션: 전방으로 짧게 찌르기
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(8, 0), 0.06)
	tween.tween_property(self, "position", Vector2.ZERO, 0.08)

	await get_tree().create_timer(0.05).timeout

	for area in _hitbox.get_overlapping_areas():
		var enemy := area.get_parent()
		if enemy.has_method("take_damage"):
			var dmg := int(data.damage * GameManager.get_damage_multiplier()) if data else 10
			enemy.take_damage(dmg)

	await get_tree().create_timer(0.05).timeout
	_hitbox.monitoring = false
