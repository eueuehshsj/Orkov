extends Node

signal main_objective_completed
signal secondary_objective_completed

var quest_item_collected := false
var all_enemies_killed := false
var total_enemies := 0
var _killed_count := 0

func reset() -> void:
	quest_item_collected = false
	all_enemies_killed = false
	total_enemies = 0
	_killed_count = 0

func register_enemies(count: int) -> void:
	total_enemies = count
	_killed_count = 0

func on_enemy_killed(_is_elite: bool = false) -> void:
	_killed_count += 1
	if _killed_count >= total_enemies and total_enemies > 0:
		all_enemies_killed = true
		secondary_objective_completed.emit()

func on_quest_item_picked_up() -> void:
	quest_item_collected = true
	main_objective_completed.emit()

func is_main_objective_done() -> bool:
	return quest_item_collected
