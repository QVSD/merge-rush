extends Area2D

@export var health = 1
@export var speedTuple: Vector2 = Vector2(100, 300)
@export var difficultyPoints = 1
var movementSpeed
var velocity = Vector2.ZERO

func _ready() -> void:
	movementSpeed = randi_range(speedTuple.x, speedTuple.y)

func _process(delta: float) -> void:
	position += Vector2(0, movementSpeed) * delta


func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("enemy")):
		return
	queue_free()
