extends Node2D

const TILE_SIZE := 64

const ENEMY_RIFLE_SCENE := preload("res://scenes/enemies/enemy_rifle.tscn")
const ENEMY_BURST_SCENE := preload("res://scenes/enemies/enemy_burst.tscn")
const ENEMY_ELITE_SCENE := preload("res://scenes/enemies/enemy_elite.tscn")

# 0 = 바닥, 1 = 벽/엄폐물
const MAP_LAYOUT := [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1],
	[1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1],
	[1,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
]

# (scene, row, col) — 마지막 항목은 반드시 elite
const ENEMY_SPAWN_DEFS := [
	["rifle",  2, 15],
	["rifle",  4, 10],
	["burst",  8,  5],
	["rifle", 11, 12],
	["elite", 12, 17],
]

func _ready() -> void:
	QuestManager.reset()
	_setup_navigation()
	_build_map()
	_spawn_enemies()

func _setup_navigation() -> void:
	var nav_region := $NavigationRegion2D as NavigationRegion2D
	var nav_poly := NavigationPolygon.new()
	nav_poly.vertices = PackedVector2Array([
		Vector2(-2000, -2000),
		Vector2(2000, -2000),
		Vector2(2000, 2000),
		Vector2(-2000, 2000),
	])
	nav_poly.add_polygon(PackedInt32Array([0, 1, 2, 3]))
	nav_region.navigation_polygon = nav_poly

func _build_map() -> void:
	var wall_parent := Node2D.new()
	wall_parent.name = "Walls"
	add_child(wall_parent)

	for row in MAP_LAYOUT.size():
		for col in MAP_LAYOUT[row].size():
			if MAP_LAYOUT[row][col] == 1:
				_spawn_wall(wall_parent, col * TILE_SIZE, row * TILE_SIZE)

func _spawn_wall(parent: Node2D, x: float, y: float) -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = Vector2(x + TILE_SIZE * 0.5, y + TILE_SIZE * 0.5)

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(TILE_SIZE, TILE_SIZE)
	shape.shape = rect
	body.add_child(shape)

	var visual := ColorRect.new()
	visual.size = Vector2(TILE_SIZE, TILE_SIZE)
	visual.position = Vector2(-TILE_SIZE * 0.5, -TILE_SIZE * 0.5)
	visual.color = Color(0.25, 0.25, 0.30)
	body.add_child(visual)

	parent.add_child(body)

func _spawn_enemies() -> void:
	var container: Node2D = $Enemies
	for def in ENEMY_SPAWN_DEFS:
		var scene: PackedScene
		match def[0]:
			"rifle": scene = ENEMY_RIFLE_SCENE
			"burst": scene = ENEMY_BURST_SCENE
			"elite": scene = ENEMY_ELITE_SCENE
		var enemy: Node2D = scene.instantiate()
		enemy.global_position = Vector2(
			def[2] * TILE_SIZE + TILE_SIZE * 0.5,
			def[1] * TILE_SIZE + TILE_SIZE * 0.5
		)
		container.add_child(enemy)
	QuestManager.register_enemies(ENEMY_SPAWN_DEFS.size())
