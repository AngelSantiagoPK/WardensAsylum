class_name DeadState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var audio: AudioStreamPlayer2D

signal death_complete

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	animator.play("dead")
	await animator.animation_finished
	death_complete.emit()
	

func exit():
	set_physics_process(false)
	
