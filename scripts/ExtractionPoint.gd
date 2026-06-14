extends Area2D

signal player_extracted(result: Dictionary)

@onready var warning_label: Label = $WarningLabel

func _ready() -> void:
	add_to_group("extraction_point")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if QuestManager.is_main_objective_done():
		player_extracted.emit({
			"success": true,
			"all_enemies_killed": QuestManager.all_enemies_killed,
		})
	else:
		_show_warning()

func _show_warning() -> void:
	warning_label.visible = true
	await get_tree().create_timer(2.5).timeout
	if is_instance_valid(warning_label):
		warning_label.visible = false
