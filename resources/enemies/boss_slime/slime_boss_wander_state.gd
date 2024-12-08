class_name SlimeBossWanderState
extends State

@export var animator: AnimatedSprite2D
@export var actor: CharacterBody2D
@onready var test_label: Label = $"../../TestLabel"

signal target_found

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	test_label.text = "Wander"
	animator.play("idle")
	
	if actor.velocity == Vector2.ZERO:
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func exit():
	test_label.text = ""
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
