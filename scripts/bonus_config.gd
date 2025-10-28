# Here the configuration of the bonuses is being defined:
class_name BonusConfig
extends Resource

@export var spawn_interval: float = 10.0
@export var bonus_type_options: Array[int] = [1]
@export var unlocks: Dictionary = {  
	10: 1,  
	30: 2  
}
