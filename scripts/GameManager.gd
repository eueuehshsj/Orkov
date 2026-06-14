extends Node

const SCENE_MAIN_MENU := "res://scenes/main_menu.tscn"
const SCENE_STAGE := "res://scenes/stage.tscn"
const SCENE_BASE := "res://scenes/base.tscn"

const UPGRADE_DAMAGE_COSTS := [50, 100, 200]
const UPGRADE_DEFENSE_COSTS := [50, 100, 200]

var scrap: int = 0
var upgrade_damage: int = 0   # 0~2 (3단계)
var upgrade_defense: int = 0  # 0~2 (3단계)
var last_stage_result: Dictionary = {}
var has_quest_item: bool = false

var _stage_scrap_at_start: int = 0

# ── 씬 전환 ──────────────────────────────────────────

func go_to_main_menu() -> void:
	get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func go_to_stage() -> void:
	_stage_scrap_at_start = scrap
	has_quest_item = false
	get_tree().change_scene_to_file(SCENE_STAGE)

func go_to_base(result: Dictionary = {}) -> void:
	if not result.has("scrap_gained"):
		result["scrap_gained"] = scrap - _stage_scrap_at_start
	if not result.has("quest_complete"):
		result["quest_complete"] = has_quest_item
	last_stage_result = result
	get_tree().change_scene_to_file(SCENE_BASE)

# ── 자원 ─────────────────────────────────────────────

func add_scrap(amount: int) -> void:
	scrap += amount

func lose_all_scrap() -> void:
	scrap = 0

func pick_up_quest_item() -> void:
	has_quest_item = true

# ── 강화 스탯 계산 ────────────────────────────────────

## 기본 데미지에 곱할 배율 (강화 0단계 = 1.0, 3단계 = 1.6)
func get_damage_multiplier() -> float:
	return 1.0 + upgrade_damage * 0.2

## 받는 데미지 감소율 (강화 0단계 = 0.0, 3단계 = 0.3)
func get_defense_reduction() -> float:
	return upgrade_defense * 0.1

# ── 강화 구매 ─────────────────────────────────────────

func can_upgrade_damage() -> bool:
	return upgrade_damage < 3 and scrap >= UPGRADE_DAMAGE_COSTS[upgrade_damage]

func buy_upgrade_damage() -> void:
	if not can_upgrade_damage():
		return
	scrap -= UPGRADE_DAMAGE_COSTS[upgrade_damage]
	upgrade_damage += 1

func can_upgrade_defense() -> bool:
	return upgrade_defense < 3 and scrap >= UPGRADE_DEFENSE_COSTS[upgrade_defense]

func buy_upgrade_defense() -> void:
	if not can_upgrade_defense():
		return
	scrap -= UPGRADE_DEFENSE_COSTS[upgrade_defense]
	upgrade_defense += 1
