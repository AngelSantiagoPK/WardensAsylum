extends Node2D

class_name Game

# VARIABLES
var paused: bool = false
@export var initial_spawn_location: Marker2D

func _ready() -> void:
	WorldNavigationManager.set_current_spawn_location(initial_spawn_location)
