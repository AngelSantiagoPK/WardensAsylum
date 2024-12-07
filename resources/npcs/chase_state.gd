class_name NPCChaseState
extends State

@export var closing_range: int = 30
@export var lost_range: int = 125
@export var actor: NPC
@export var animator: AnimatedSprite2D
@export var audio: AudioStreamPlayer2D
@export var emoter: Sprite2D

@onready var target: Node2D = actor.target
@onready var detection_area: Area2D = $"../../DetectionArea"

signal close_to
signal lost_target

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	emoter.texture = preload("res://assets/Ui/Emote/emote22.png")
	emoter.visible = true
	animator.play("chase")
	audio.stream = preload("res://assets/Sounds/Game/Voice1.wav")
	audio.pitch_scale = randf_range(1, 1.2)
	audio.play()


func exit():
	emoter.visible = false
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if target:	
		var velocity = actor.global_position.direction_to(target.global_position)
		actor.move_and_collide(velocity * actor.max_speed * delta)
		if actor.global_position.distance_to(target.global_position) < closing_range:
			close_to.emit()
		elif actor.global_position.distance_to(target.global_position) > lost_range:
			lost_target.emit()
