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
	animator.play('hit')
	Global.score += 10


func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	await animator.animation_finished
	hit_finished.emit()
