# AUTHOR: ANGEL SANTIAGO - DEC 1, 2024
extends ProgressBar

class_name EnemyHealthBar

#VARIABLES
@onready var health_system: HealthSystem = $"../HealthSystem"

#FUNCTIONS
func _ready() -> void:
	visible = false
	max_value = health_system.max_health
	value = max_value
	health_system.damage_taken.connect(on_damage_taken)
	#end


func on_damage_taken(damage: int):
	if !visible:
		visible = true
	value -= damage
	#end
