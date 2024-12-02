extends Node

class_name StaminaSystem

# SIGNALS
signal drained
signal stamina_used(current_stamina: int)

# VARIABLES
@export var max_stamina: int
var current_stamina: int

# FUNCTIONS
func init(stamina: int):
	max_stamina = stamina
	current_stamina = stamina
	#end


func use_stamina(stamina_consumption: int):
	current_stamina = current_stamina - stamina_consumption
	stamina_used.emit(stamina_consumption)
	if current_stamina <= 0:
		drained.emit()
	#end
