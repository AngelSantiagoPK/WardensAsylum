class_name NPCWanderState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var emoter: Sprite2D

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	emoter.texture = preload("res://assets/Ui/Emote/emote19.png")
	emoter.visible = true
	animator.play("wander")
	
	if actor.velocity == Vector2.ZERO:
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed


func exit():
	emoter.visible = false
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	animator.scale.x = -sign(actor.velocity.x)
	if animator.scale.x == 0.0: animator.scale.x = 1.0
	
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
