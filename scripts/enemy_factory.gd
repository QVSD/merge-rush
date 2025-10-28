class_name EnemyFactory
extends Node

@export var enemy_scene_1: PackedScene
@export var enemy_scene_2_big: PackedScene
@export var enemy_scene_3_fast: PackedScene
# multiple enemy scenes here can be added or an Array of packed scenes
var enemy_types: Dictionary  # unique type key => scene variable value


func _ready() -> void:
	enemy_types = {
	1: enemy_scene_1,
	2: enemy_scene_2_big,
	3: enemy_scene_3_fast,
}


func spawn_enemy(lanes: int, type: int) -> void:
	var enemy = enemy_types[type].instantiate()
	enemy.position = get_random_lane_position(lanes)
	add_child(enemy)


func get_random_lane_position(lanes: int) -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var lane_width = screen_size.x / lanes
	var lane_x = (randi() % lanes) * lane_width + randi_range(0, lane_width)
	return Vector2(lane_x, 0)
