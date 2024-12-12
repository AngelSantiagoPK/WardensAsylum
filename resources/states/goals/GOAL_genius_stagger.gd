extends State

class_name GoalGeniusStagger

@export var object: CharacterBody2D

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	object.velocity = Vector2.ZERO
	object.move_and_slide()
	
	object.particle_fx.restart()
	object.particle_fx.emitting = true
	object.hit_animator.play("hit_flash")
	await object.hit_animator.animation_finished
	success.emit()

func _physics_process(delta: float) -> void:
	pass


func exit():
	set_physics_process(false)
