class_name ObstacleFactory
extends Node

@export var obstacle_scene_1: PackedScene
@export var obstacle_scene_2_big: PackedScene
@export var obstacle_scene_3_fast: PackedScene
# multiple obstacle scenes here can be added or an Array of packed scenes
var obstacle_types: Dictionary  # unique type key => scene variable value


func _ready() -> void:
	obstacle_types = {
	1: obstacle_scene_1,
	2: obstacle_scene_2_big,
	3: obstacle_scene_3_fast,
}


func spawn_obstacle(lanes: int, type: int) -> void:
	var obstacle = obstacle_types[type].instantiate()
	obstacle.position = get_random_lane_position(lanes)
	add_child(obstacle)


func get_random_lane_position(lanes: int) -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var lane_width = screen_size.x / lanes
	var lane_x = (randi() % lanes) * lane_width + randi_range(0, lane_width)
	return Vector2(lane_x, 0)
