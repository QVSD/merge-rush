class_name BonusFactory
extends Node

@export var bonus_scenes: Dictionary = {
	1: preload("res://scenes/bonus_multishot.tscn"),
	2: preload("res://scenes/bonus_rapidshot.tscn")
}
var active_types: Array[int] = [1,2] 

# Instantiates a bonus randomly from the active type list
func spawn_bonus() -> Node:
	if active_types.is_empty(): return null
	var type = active_types[randi() % active_types.size()]
	var bonus = bonus_scenes[type].instantiate()
	bonus.position = get_random_drop_position()
	add_child(bonus)
	return bonus

# Returns an random position on horizontal axis (X) to spawn the bonus
func get_random_drop_position() -> Vector2:
	var size = get_viewport().get_visible_rect().size
	return Vector2(randi_range(0, size.x), -32)
