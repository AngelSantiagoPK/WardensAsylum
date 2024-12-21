extends State

class_name GoalGeniusStagger

@export var object: CharacterBody2D

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	object.disable_collisions()
	var rand = randi_range(0, object.MONSTER_GURGLES.size() - 1)
	object.ai_audio.stream = object.MONSTER_GURGLES[rand]
	object.ai_audio.pitch_scale = randf_range(0.8, 1.6)
	object.ai_audio.play()
	object.velocity = Vector2.ZERO
	object.move_and_slide()
	object.disable_collisions()
	object.hit_animator.play("hit_flash")
	await object.hit_animator.animation_finished
	success.emit()

func _physics_process(_delta: float) -> void:
	pass


func exit():
	set_physics_process(false)
	object.enable_collisions()
