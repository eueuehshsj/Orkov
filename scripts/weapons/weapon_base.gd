class_name Weapon
extends Node2D

@export var data: WeaponData

var _cooldown_remaining: float = 0.0

func _process(delta: float) -> void:
	if _cooldown_remaining > 0.0:
		_cooldown_remaining -= delta

func _is_ready() -> bool:
	return _cooldown_remaining <= 0.0

func _start_cooldown() -> void:
	_cooldown_remaining = data.cooldown if data else 0.5
