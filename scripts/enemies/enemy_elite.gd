class_name EnemyElite
extends EnemyRifle

const QUEST_ITEM_SCENE := preload("res://scenes/quest_item.tscn")
const STAT_MULTIPLIER := 1.3

func _ready() -> void:
	super._ready()
	if data:
		current_hp = data.max_hp * STAT_MULTIPLIER

func _fire_single() -> void:
	if not is_instance_valid(_player) or state != State.ATTACK:
		return
	var bullet := BULLET_SCENE.instantiate() as EnemyBullet
	bullet.damage = data.attack_damage * STAT_MULTIPLIER
	bullet.direction = (_player.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position

func _on_die() -> void:
	var item := QUEST_ITEM_SCENE.instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = global_position
