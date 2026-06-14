extends Control

@onready var scrap_label: Label = $VBoxContainer/ScrapLabel
@onready var result_label: Label = $VBoxContainer/ResultLabel
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
	if result.get("success", false):
		result_label.text = "임무 완료"
	elif result.get("failed", false):
		result_label.text = "임무 실패 — 스크랩 손실"
	else:
		result_label.text = ""

	var dmg_tier := GameManager.upgrade_damage
	if dmg_tier < 3:
		dmg_upgrade_button.text = "데미지 강화 (Tier %d → %d)  비용: %d" % [
			dmg_tier, dmg_tier + 1, GameManager.UPGRADE_DAMAGE_COSTS[dmg_tier]
		]
		dmg_upgrade_button.disabled = not GameManager.can_upgrade_damage()
	else:
		dmg_upgrade_button.text = "데미지 강화 MAX"
		dmg_upgrade_button.disabled = true

	var def_tier := GameManager.upgrade_defense
	if def_tier < 3:
		def_upgrade_button.text = "방어 강화 (Tier %d → %d)  비용: %d" % [
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
