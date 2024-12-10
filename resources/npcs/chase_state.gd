class_name NPCChaseState
extends State

@export var actor: NPC
@export var animator: AnimatedSprite2D
@export var audio: AudioStreamPlayer2D

@onready var target: Node2D = actor.target
@onready var detection_area: Area2D = $"../../DetectionArea"

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	animator.play("chase")
	audio.stream = preload("res://assets/Sounds/Game/Voice1.wav")
	audio.pitch_scale = randf_range(1, 1.2)
	audio.play()


func exit():
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if target:	
		var velocity = actor.global_position.direction_to(target.global_position)
		actor.move_and_collide(velocity * actor.max_speed * delta)
