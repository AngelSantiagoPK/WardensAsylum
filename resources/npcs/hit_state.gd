class_name HitState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var health_system: HealthSystem
@export var audio: AudioStreamPlayer2D
@export var particles: GPUParticles2D
@export var hit_animator: AnimationPlayer

signal hit_finished

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	print_debug("Hit")
	print_debug("")
	animator.play('hit')
	particles.restart()
	particles.emitting = true
	hit_animator.play("hit_flash")
	Global.score += 10


func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	await animator.animation_finished
	hit_finished.emit()
