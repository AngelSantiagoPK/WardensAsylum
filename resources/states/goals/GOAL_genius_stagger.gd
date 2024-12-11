extends State

class_name GoalGeniusStagger

@export var object: CharacterBody2D

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	print("Staggered...")
	object.particle_fx.restart()
	object.particle_fx.emitting = true
	object.hit_animator.play("hit_flash")
	await object.hit_animator.animation_finished
	await get_tree().create_timer(1.0).timeout
	success.emit()

func _physics_process(delta: float) -> void:
	object.context_map.set_reverse(false)


func exit():
	set_physics_process(false)
