class_name HitState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var health_system: HealthSystem
@export var audio: AudioStreamPlayer2D

signal hit_finished

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	audio.stream = preload("res://assets/Sounds/Game/Strange.wav")
	audio.play()
	await audio.finished
	hit_finished.emit()


func exit():
	set_physics_process(false)
	
