extends State

class_name GoalGeniusPursue

@export var object: CharacterBody2D
@export var success_distance: int = 10
@export var min_pursue_time: float = 10.0
@export var max_pursue_time: float = 20.0

@onready var emote: Sprite2D = %Emote

signal success
signal failure

func _ready() -> void:
	set_physics_process(false)

func enter():
	print("pursuing...")
	set_physics_process(true)
	await get_tree().create_timer(1.0).timeout

func exit():
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	object.context_map.set_reverse(false)
	var dir = object.context_map.get_resultant_force()
	object.velocity = dir * object.speed
	object.move_and_slide()
	
	if object.global_position.distance_to(object.target.global_position) < success_distance:
		success.emit()


func _on_timer_timeout() -> void:
	object.context_map.set_target_position(object.target.position)
	object.animator.play_movement_animation(object.velocity)
	
	if object.velocity > Vector2(-1, -1) and object.velocity < Vector2(1, 1):
		object.animator.play_idle_animation()
