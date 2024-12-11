extends State

class_name GoalGeniusEvade

@export var object: CharacterBody2D
@export var evasion_distance: int = 50
var spawn_point: Vector2

@onready var emote: Sprite2D = %Emote

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	print("evading")
	set_physics_process(true)

func exit():
	object.context_map.set_reverse(false)
	set_physics_process(false)

func _physics_process(delta: float) -> void:	
	object.nav_agent.target_position = object.context_map.spawn_point
	var dir = object.context_map.get_resultant_force()
	object.velocity = dir * object.speed
	object.move_and_slide()
	
	if object.position.distance_to(object.target.position) > evasion_distance:
		print('evaded')
		success.emit()
