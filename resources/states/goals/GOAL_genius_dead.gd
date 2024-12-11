extends State

class_name GoalGeniusDead

@export var object: CharacterBody2D

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	object.timer.stop()
	object.velocity = Vector2.ZERO
	object.health_bar.visible = false
	object.hit_animator.play("death_flash")
	object.animator.play("death")
	await object.animator.animation_finished
	Global.increase_score(100)
	Global.give_player_xp(100)
	Global.update_level()
	success.emit()

func _physics_process(delta: float) -> void:
	object.context_map.set_reverse(false)


func exit():
	set_physics_process(false)
