extends Control

@onready var scrap_label: Label = $VBoxContainer/ScrapLabel
@onready var result_label: Label = $VBoxContainer/ResultLabel
@onready var acquired_label: Label = $VBoxContainer/AcquiredLabel
@onready var quest_label: Label = $VBoxContainer/QuestLabel
@onready var dmg_upgrade_button: Button = $VBoxContainer/DmgUpgradeButton
@onready var def_upgrade_button: Button = $VBoxContainer/DefUpgradeButton

func _ready() -> void:
	_refresh_ui()
	$VBoxContainer/StageButton.pressed.connect(_on_stage_pressed)
	dmg_upgrade_button.pressed.connect(_on_dmg_upgrade_pressed)
	def_upgrade_button.pressed.connect(_on_def_upgrade_pressed)

func _refresh_ui() -> void:
	scrap_label.text = "보유 스크랩: %d" % GameManager.scrap

	var result := GameManager.last_stage_result
	if result.is_empty():
		result_label.text = ""
		acquired_label.text = ""
		quest_label.text = ""
	elif result.get("died", false):
		result_label.text = "임무 실패 — 스크랩 손실"
		acquired_label.text = "획득 스크랩: 0 (전량 손실)"
		quest_label.text = "목표 달성: 실패"
	elif result.get("success", false):
		result_label.text = "임무 완료"
		acquired_label.text = "획득 스크랩: +%d" % result.get("scrap_gained", 0)
		var quest_done: bool = result.get("quest_complete", false)
		quest_label.text = "목표 달성: %s" % ("완료" if quest_done else "미완료")

	var dmg_tier := GameManager.upgrade_damage
	if dmg_tier < 3:
		dmg_upgrade_button.text = "데미지 강화 (Tier %d → %d)  비용: %d 스크랩" % [
			dmg_tier, dmg_tier + 1, GameManager.UPGRADE_DAMAGE_COSTS[dmg_tier]
		]
		dmg_upgrade_button.disabled = not GameManager.can_upgrade_damage()
	else:
		dmg_upgrade_button.text = "데미지 강화 MAX"
		dmg_upgrade_button.disabled = true

	var def_tier := GameManager.upgrade_defense
	if def_tier < 3:
		def_upgrade_button.text = "방어 강화 (Tier %d → %d)  비용: %d 스크랩" % [
			def_tier, def_tier + 1, GameManager.UPGRADE_DEFENSE_COSTS[def_tier]
		]
		def_upgrade_button.disabled = not GameManager.can_upgrade_defense()
	else:
		def_upgrade_button.text = "방어 강화 MAX"
		def_upgrade_button.disabled = true

func _on_stage_pressed() -> void:
	GameManager.go_to_stage()

func _on_dmg_upgrade_pressed() -> void:
	GameManager.buy_upgrade_damage()
	_refresh_ui()

func _on_def_upgrade_pressed() -> void:
	GameManager.buy_upgrade_defense()
	_refresh_ui()
