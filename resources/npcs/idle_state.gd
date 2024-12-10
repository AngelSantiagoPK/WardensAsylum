class_name NPCIdleState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var idle_timer: Timer

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	idle_timer.start()
	animator.play("idle")
	actor.velocity += Vector2.ZERO
	print_debug("Idle")
	print_debug("")


func exit():
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	pass
	
