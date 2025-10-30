# GameConfig.gd
class_name GameConfig
extends Resource

@export var playerLife: int = 3 # starting player life points

@export var lanes: int = 1 # current number of lanes, where lanes should permit for futher logic of splitting game screen into zones
@export var max_lanes: int = 10 # maximum number of lanes permited, if further logic not added it doesn't have an impact

@export var difficulty: int = 10 # measure for game difficulty
@export var maximum_difficulty: int = 300 # maximum allowed for game difficulty
@export var difficulty_step_increase: int = 5 # by how much does the difficulty increase
@export var enemy_type_options: Array[int] = [1] # 3 unique types with different frequencies based on number of appeareances
@export var difficulty_step_time: float = 15.0 # after how much time in seconds does the game increase in difficulty

@export var enemy_spawn_interval: float = 3
@export var fastest_enemy_spawn_interval:float = 1
@export var spawn_interval_decrement: float = 0.1

@export var bonus_spawn_chance: float = 0.1
@export var bonus_config: BonusConfig

@export var coin_type_options: Array[int] = [1]
@export var coin_spawn_interval: float = 3
@export var fastest_coin_spawn_interval: float = 0.1
@export var coin_spawn_interval_decrement: float = 0.05

@export var score_increase_based_on_time_interval: float = 1


func increase_difficulty() -> void:
	self.difficulty = min(self.maximum_difficulty, 
			(self.difficulty + self.difficulty_step_increase))
	print("Current difficulty: ", self.difficulty) 
	
	self.coin_spawn_interval = max(self.fastest_coin_spawn_interval,
			(self.coin_spawn_interval - self.coin_spawn_interval_decrement))

	if lanes < max_lanes:
		lanes += 1

	self.enemy_spawn_interval = max(self.fastest_enemy_spawn_interval, 
			(self.enemy_spawn_interval - self.spawn_interval_decrement))

	if (self.difficulty == 50): # 1 1 2
		self.enemy_type_options.append(1)
		self.enemy_type_options.append(2)
	if (self.difficulty == 100): # 1 1 1 1 2 2 3
		self.enemy_type_options.append(1)
		self.enemy_type_options.append(1)
		self.enemy_type_options.append(2)
		self.enemy_type_options.append(3)
	if (self.difficulty == 150): # 1 1 1 1 2 2 2 3
		self.enemy_type_options.append(2)
	if (self.difficulty == 200): # 1 1 1 1 2 2 2 3 3
		self.enemy_type_options.append(3)
	if (self.difficulty == 250): # 1 1 1 1 2 2 2 3 3 3
		self.enemy_type_options.append(3)
	if (self.difficulty == 300):
		pass

	# -------------------------------
	# BONUS scaling
	# -------------------------------
	# Adjusting the rate and frequency of the bonus spawning.
	if bonus_config != null:
		# higher no. of bonusses (not under 3 sec)
		bonus_config.spawn_interval = max(3.0, bonus_config.spawn_interval - 0.5)

		# the chance of spawning a bonus raises (not higher than 50%)
		self.bonus_spawn_chance = min(0.5, self.bonus_spawn_chance + 0.02)

		print("Bonus spawn interval: ", bonus_config.spawn_interval)
		print("Bonus spawn chance: ", self.bonus_spawn_chance)
	else:
		print("!!!!! bonus_config is NULL")
