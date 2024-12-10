class_name SlimeBossChaseState
extends State

@export var closing_range: int = 30
@export var actor: CharacterBody2D
@export var animator: AnimatedSprite2D
@export var audio: AudioStreamPlayer2D

@onready var target: Node2D = actor.target
@onready var detection_area: Area2D = $"../../DetectionArea"
@onready var test_label: Label = $"../../TestLabel"

signal close_to

func _ready() -> void:
	set_physics_process(false)

func enter():
	test_label.text = "Chase"
	animator.play("idle")
	set_physics_process(true)


func exit():
	test_label.text = ""
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if target:	
		var velocity = actor.global_position.direction_to(target.global_position)
		actor.move_and_collide(velocity * actor.max_speed * delta)
		
		if actor.global_position.distance_to(target.global_position) < closing_range:
			close_to.emit()
