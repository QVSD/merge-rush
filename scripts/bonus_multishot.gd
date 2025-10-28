class_name BonusMultishot
extends Area2D

@export var fall_speed := 150.0
@export var effect: String = "multishot"
@export var duration: float = 10.0

signal collected(effect: String, duration: float)

func _process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport().get_visible_rect().size.y + 100:
		queue_free()

# Detects the collision with the Player or the Bullet
# If its being collected it sends the signal 'collected' with the effect 'multishot'
func _on_area_entered(area: Area2D):
	print("Bonus collided with: ", area.name, " groups: ", area.get_groups())
	if area.is_in_group("player") or area.is_in_group("bullet"):
		print("Emitting bonus: ", effect)
		emit_signal("collected", effect, duration)
		queue_free()
