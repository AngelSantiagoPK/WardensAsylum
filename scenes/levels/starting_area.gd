extends Node2D

class_name StartingArea

@onready var player_spawn_point: Marker2D = $POI/PlayerSpawnPoint
@onready var player: Player = $Player
@onready var key_drop_animator: AnimationPlayer = $KeyDropAnimator

func _ready() -> void:
	player.position = player_spawn_point.position
	key_drop_animator.play("drop_key")
	print("drop")
	
	
