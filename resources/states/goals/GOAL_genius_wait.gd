extends State

class_name GoalGeniusWait

@export var object: CharacterBody2D

signal success
signal failure

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	object.velocity = Vector2.ZERO
	object.move_and_slide()
	await get_tree().create_timer(0.5).timeout


func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	object.animator.play_idle_animation()
	pass
