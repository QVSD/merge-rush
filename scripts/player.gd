extends Area2D

@export var speed = 500
var screen_size
var spriteSize = Vector2(50, 50)
@export var bulletScene: PackedScene
signal damage_taken
var active_modifiers = {}



func _ready() -> void:
	screen_size = get_viewport_rect().size
	

func _process(delta: float) -> void:
	var marginVector = Vector2(0, 0)
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1


	if velocity.length() > 0:
		velocity *= speed
		# play the move animation  eg. $AnimatedSprite2D.play()
	#else:
		# replay the idle animation e.g. $AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + spriteSize, screen_size - spriteSize)

# Applies the effects of a collected bonus
# @param effect   :  type of bonus (multishot or rapidshot)
# @param duration :  time slice while the bonus is still active
func apply_bonus(effect: String, duration: float) -> void:
	match effect:
		"multishot":
			if not active_modifiers.has("multishot"):
				active_modifiers["multishot"] = 0
			if active_modifiers["multishot"] < 7: # max 7 stacks
				active_modifiers["multishot"] += 1
				_add_bonus_timer("multishot", duration)
				
		"rapidshot":
			if not active_modifiers.has("rapidshot"):
				active_modifiers["rapidshot"] = 0
			if active_modifiers["rapidshot"] < 3: # a max of 3 stacks
				active_modifiers["rapidshot"] += 1
				_add_bonus_timer("rapidshot", duration)
			
	print("Player applying bonus: ", effect)

# Manages shooting bullets
# Creates the central bullet and if there is a bonus active: 
# - multishot : adds multiple bullets
# - rapidshot : reduces the cooldown time of the bullet based on the current stack
func _on_shoot_timer_timeout():
	var bullet = bulletScene.instantiate()
	bullet.global_position = global_position + Vector2(0, -200)
	get_parent().add_child(bullet)

	if active_modifiers.has("multishot"):
		var count = active_modifiers["multishot"] # how many bonusses
		for i in range(count):
			var offset = (i + 1) * 30  # arrow distance
			
			var left = bulletScene.instantiate()
			left.global_position = global_position + Vector2(-offset, -200)
			get_parent().add_child(left)

			var right = bulletScene.instantiate()
			right.global_position = global_position + Vector2(offset, -200)
			get_parent().add_child(right)
			
	if active_modifiers.has("rapidshot"):
		var stacks = active_modifiers["rapidshot"]
		# each stack is going down by 0.1 seconds, but not under 0.1
		$ShootTimer.wait_time = max(0.1, 0.4 - (stacks * 0.1))
	else:
		$ShootTimer.wait_time = 0.5

# Adds a timer for a bonus
# When the timer expires, it will call 'remove_on_stack' to reduce the effect
# 	of the bonus.
# @param name : the name of the bonus
# @param duration : duration of the bonus
func _add_bonus_timer(name: String, duration: float):
	var t = Timer.new()
	t.one_shot = true
	add_child(t)
	t.wait_time = duration
	t.connect("timeout", Callable(self, "_remove_one_stack").bind(name))
	t.start()


# Removes a stack from an active bonus
# If the stack reaches the 0 value, the bonus is being complitely deleted from
#	the 'active_modifiers'.
# @param name : the name of the expiring bonus
func _remove_one_stack(name: String):
	if name == "multishot" and active_modifiers.has("multishot"):
		active_modifiers["multishot"] -= 1
		if active_modifiers["multishot"] <= 0:
			active_modifiers.erase("multishot")

	elif name == "rapidshot":
		if active_modifiers.has("rapidshot"):
			active_modifiers["rapidshot"] -= 1
			if active_modifiers["rapidshot"] <= 0:
				active_modifiers.erase("rapidshot")
		print("Rapidshot expired -> ", active_modifiers)
	
	print("Bonus expired: ", name, " -> ", active_modifiers)


func _on_health_limit_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"): # only the enemy reduces the health bar
		print("HealthLimit touched by enemy")
		emit_signal("damage_taken")
	elif area.is_in_group("bonus"): # the bonus is not our enemy
		print("HealthLimit ignored bonus")
		area.queue_free()
	else:
		print("Ignored collision with: ", area.name)
