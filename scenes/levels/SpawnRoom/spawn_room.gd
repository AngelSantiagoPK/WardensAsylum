extends Node2D

class_name Room

@export var player: Player

# Functions
func _ready() -> void:
	player.player_died.connect(on_player_died)
	if Global.get_spawn_point() == null:
		return
	player.global_position = Global.get_spawn_point()
	pass

func on_player_died():
	get_tree().reload_current_scene()
