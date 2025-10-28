class_name GameManager
extends Node

@export var config: GameConfig
@export var enemy_factory: EnemyFactory
@export var player_scene: PackedScene
@export var bonus_factory: BonusFactory
var player
var enemy_spawn_timer: Timer
var difficulty_increase_timer: Timer
var bonus_timer: Timer

func _ready() -> void:
	self.enemy_spawn_timer = Timer.new()
	self.enemy_spawn_timer.one_shot = false
	self.add_child(self.enemy_spawn_timer)
	self.enemy_spawn_timer.start(config.enemy_spawn_interval)
	self.enemy_spawn_timer.connect("timeout", Callable(self, "_on_enemy_spawn_timer_timeout"))
	
	self.difficulty_increase_timer = Timer.new()
	self.difficulty_increase_timer.one_shot = false
	self.add_child(self.difficulty_increase_timer)
	self.difficulty_increase_timer.start(config.difficulty_step_time)
	self.difficulty_increase_timer.connect("timeout", Callable(self, "_on_difficulty_increase_timer_timeout"))
	
	self.player = self.player_scene.instantiate()
	self.add_child(self.player)
	var result = player.get_node("Player").connect("damage_taken", Callable(self, "_on_player_damage_taken"))

	bonus_timer = Timer.new()
	bonus_timer.one_shot = false
	add_child(bonus_timer)
	bonus_timer.wait_time = config.bonus_config.spawn_interval
	bonus_timer.connect("timeout", Callable(self, "_on_bonus_timer_timeout"))
	bonus_timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
	self.enemy_factory.spawn_enemy(self.config.lanes, 
			self.config.enemy_type_options[randi() % self.config.enemy_type_options.size()])

# Raises difficulty of the game and updates the timers.
# It verifies if there should be unlocked another bonus type with the respect of 'BonusConfig.unlocks'
func _on_difficulty_increase_timer_timeout() -> void:
	self.config.increase_difficulty()
	self.enemy_spawn_timer.wait_time = self.config.enemy_spawn_interval
	self.difficulty_increase_timer.wait_time = self.config.difficulty_step_time

	if self.config.bonus_config != null:
		for key in self.config.bonus_config.unlocks.keys():
			if int(key) == self.config.difficulty:
				var new_type = self.config.bonus_config.unlocks[key]
				if not new_type in bonus_factory.active_types:
					bonus_factory.active_types.append(new_type)
					print("Unlocked bonus: ", new_type)

func _on_player_damage_taken() -> void:
	print(self.config.difficulty)
	self.config.playerLife -= 1
	if (self.config.playerLife <= 0):
		get_tree().quit()

func _on_bonus_timer_timeout():
	var bonus = bonus_factory.spawn_bonus()
	if bonus:
		bonus.connect("collected", Callable(self, "_on_bonus_collected"))

# Callback invoked when the player collects a bonus
# It is transmiting the efect towards the Player to apply the modification.
# @param effect   : type of bonus
# @param duration : duration of the effect
func _on_bonus_collected(effect: String, duration: float):
	player.get_node("Player").apply_bonus(effect, duration)
	print("GameManager received bonus: ", effect)
