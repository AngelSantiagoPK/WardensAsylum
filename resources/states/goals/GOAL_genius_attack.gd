extends State

class_name GoalGeniusAttack

@export var object: CharacterBody2D

signal success

func enter():
	set_physics_process(true)
	await object.animator.animation_finished
	object.animator.play_attack_animation()
	await object.animator.animation_finished
	success.emit()

func _physics_process(delta: float) -> void:
	pass


func exit():
	set_physics_process(false)
