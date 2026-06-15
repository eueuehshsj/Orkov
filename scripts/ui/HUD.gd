extends CanvasLayer

@onready var hp_bar: ProgressBar = $Root/InfoPanel/VBox/HPRow/HPBar
@onready var scrap_label: Label = $Root/InfoPanel/VBox/ScrapLabel
@onready var main_obj_label: Label = $Root/InfoPanel/VBox/MainObjLabel
@onready var sec_obj_label: Label = $Root/InfoPanel/VBox/SecObjLabel
@onready var extraction_arrow: Control = $Root/ExtractionArrow
@onready var death_overlay: ColorRect = $Root/DeathOverlay
@onready var fade_overlay: ColorRect = $Root/FadeOverlay

var _player: CharacterBody2D = null
var _extraction_point: Node2D = null
var _dying := false

func _ready() -> void:
	death_overlay.visible = false
	fade_overlay.color = Color(0, 0, 0, 0)
	extraction_arrow.visible = false

	await get_tree().process_frame

	_player = get_tree().get_first_node_in_group("player")
	if _player:
		_player.health_changed.connect(_on_health_changed)
		_player.died.connect(_on_player_died)
		hp_bar.max_value = _player.max_hp
		hp_bar.value = _player.current_hp

	var ep_nodes := get_tree().get_nodes_in_group("extraction_point")
	if ep_nodes.size() > 0:
		_extraction_point = ep_nodes[0]
		_extraction_point.player_extracted.connect(start_extraction_fade)

	QuestManager.main_objective_completed.connect(_on_main_obj_completed)
	QuestManager.secondary_objective_completed.connect(_on_sec_obj_completed)

	_refresh_objectives()
	_refresh_scrap()

func _process(_delta: float) -> void:
	_refresh_scrap()
	_update_extraction_arrow()

func _refresh_scrap() -> void:
	scrap_label.text = "스크랩: %d" % GameManager.scrap

func _refresh_objectives() -> void:
	main_obj_label.text = "● 메인: %s" % ("완료 ✓" if QuestManager.quest_item_collected else "아이템 회수")
	sec_obj_label.text = "● 보조: %s" % ("완료 ✓" if QuestManager.all_enemies_killed else "전 적 섬멸")

func _update_extraction_arrow() -> void:
	if not _extraction_point or not is_instance_valid(_extraction_point):
		extraction_arrow.visible = false
		return

	var camera := get_viewport().get_camera_2d()
	if not camera:
		extraction_arrow.visible = false
		return

	var viewport_size := get_viewport().get_visible_rect().size
	var screen_center := camera.get_screen_center_position()
	var ext_world_pos: Vector2 = _extraction_point.global_position

	var local := ext_world_pos - screen_center + viewport_size * 0.5
	var margin := 60.0
	var on_screen := local.x > margin and local.x < viewport_size.x - margin \
		and local.y > margin and local.y < viewport_size.y - margin

	if on_screen:
		extraction_arrow.visible = false
		return

	extraction_arrow.visible = true

	var dir := (ext_world_pos - screen_center).normalized()
	var half := viewport_size * 0.5
	var tx := abs(half.x / dir.x) if dir.x != 0.0 else INF
	var ty := abs(half.y / dir.y) if dir.y != 0.0 else INF
	var t: float = min(tx, ty) - 50.0

	extraction_arrow.position = half + dir * t - Vector2(15.0, 15.0)
	extraction_arrow.rotation = dir.angle()

func _on_health_changed(current: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current

func _on_main_obj_completed() -> void:
	_refresh_objectives()

func _on_sec_obj_completed() -> void:
	_refresh_objectives()

func _on_player_died() -> void:
	if _dying:
		return
	_dying = true
	death_overlay.visible = true
	await get_tree().create_timer(2.5).timeout
	GameManager.go_to_base({"success": false, "died": true, "scrap_gained": 0, "quest_complete": false})

func start_extraction_fade(result: Dictionary) -> void:
	var tween := create_tween()
	tween.tween_property(fade_overlay, "color", Color(0, 0, 0, 1.0), 1.0)
	tween.tween_callback(func() -> void: GameManager.go_to_base(result))
