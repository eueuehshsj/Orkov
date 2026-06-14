class_name WeaponData
extends Resource

@export var weapon_name: String = ""
@export var damage: float = 10.0
@export var attack_range: float = 80.0
@export var cooldown: float = 0.5
## 1.0 = 완전 정확, 낮을수록 발사각 오프셋 증가
@export var accuracy: float = 1.0
@export var is_melee: bool = false
