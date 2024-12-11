extends Node2D

class_name StartingArea

@onready var player_spawn_point: Marker2D = $POI/PlayerSpawnPoint
@onready var player: Player = $Player
@onready var key_drop_animator: AnimationPlayer = $KeyDropAnimator
@onready var level_sfx: AudioStreamPlayer2D = $LevelSFX


func _ready() -> void:
	player.position = player_spawn_point.position
	key_drop_animator.play("drop_key")


func on_key_drop():
	level_sfx.stream = preload("res://assets/Sounds/Game/Voice3.wav")
	level_sfx.pitch_scale = randf_range(0.8, 1.2)
	level_sfx.play()
