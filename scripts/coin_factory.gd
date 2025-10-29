class_name CoinFactory
extends Node

@export var coin_scene_1: PackedScene
# multiple coin scenes here can be added or an Array of packed scenes
var coin_types: Dictionary  # unique type key => scene variable value


func _ready() -> void:
	coin_types = {
	1: coin_scene_1,
}


func spawn_obstacle(lanes: int, type: int) -> void:
	var coin = coin_types[type].instantiate()
	coin.position = get_random_lane_position(lanes)
	add_child(coin)


func get_random_lane_position(lanes: int) -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var lane_width = screen_size.x / lanes
	var lane_x = (randi() % lanes) * lane_width + randi_range(0, lane_width)
	return Vector2(lane_x, 0)
