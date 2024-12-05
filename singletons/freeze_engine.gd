extends Node

class_name FreezeEngine


 # VARIABLES
var time_scale = 0.1
var time_duration = 0.4


# FUNCTIONS
func frameFreeze():
	Engine.time_scale = time_scale
	await get_tree().create_timer(time_scale * time_duration).timeout
	Engine.time_scale = 1.0
