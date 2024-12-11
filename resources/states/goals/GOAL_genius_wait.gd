extends State

class_name GoalGeniusWait

@export var object: CharacterBody2D
@onready var emote: Sprite2D = %Emote

signal success
signal failure

func _ready() -> void:
	set_physics_process(false)

func enter():
	print("waiting...")
	set_physics_process(true)
	object.velocity = Vector2.ZERO
	await get_tree().create_timer(3.0).timeout
	success.emit()

func exit():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	object.context_map.set_reverse(false)
	pass
