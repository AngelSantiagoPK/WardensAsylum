extends State

class_name GoalGeniusAttack

@export var object: CharacterBody2D

@onready var emote: Sprite2D = %Emote

signal success
signal failure

func enter():
	set_physics_process(true)
	print('attacking...')
	emote.texture = preload("res://assets/Ui/Emote/emote22.png")
	object.velocity = Vector2.ZERO
	object.animator.play_attack_animation()
	await object.animator.animation_finished
	success.emit()

func _physics_process(delta: float) -> void:
	object.context_map.set_reverse(false)


func exit():
	set_physics_process(false)
