extends Area2D

@export var speed = 600
var velocity = Vector2.ZERO
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
	if position.y < -100:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		return
	queue_free()
