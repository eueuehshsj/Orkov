class_name UpgradeData
extends Resource

@export var upgrade_name: String = ""
@export var description: String = ""
## 티어당 비용 (3단계 고정)
@export var costs: Array[int] = [50, 100, 200]
## 티어당 보너스 배율 (데미지+는 곱연산, 방어+는 감산)
@export var bonus_per_tier: float = 0.2
