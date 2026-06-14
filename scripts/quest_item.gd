class_name QuestItem
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.pick_up_quest_item()
		QuestManager.on_quest_item_picked_up()
		queue_free()
