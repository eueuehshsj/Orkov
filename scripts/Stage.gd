extends Node2D

func _ready() -> void:
	_setup_navigation()

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
