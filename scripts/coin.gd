class_name Coin
extends Area2D
@export var value: int = 100;
@export var fall_speed := 150.0

signal score_add(value: int)

func _process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport().get_visible_rect().size.y + 100:
		queue_free()

func _on_area_entered(area: Area2D):
	print("Bonus collided with: ", area.name, " groups: ", area.get_groups())
	if area.is_in_group("player"):
		print("Coin collected value: ", value)
		emit_signal("score_add", value)
		queue_free()
