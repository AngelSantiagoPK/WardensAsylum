extends Node2D

func _physics_process(delta: float) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/SpawnRoom/spawn_room.tscn")
