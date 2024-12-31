class_name SlimeBossDeadState
extends State

@export var animator: AnimatedSprite2D
@export var actor: CharacterBody2D
@onready var test_label: Label = $"../../TestLabel"
@onready var collision_shape_2d: CollisionShape2D = $"../../CollisionShape2D"
@onready var hurt_box: Area2D = $"../../HurtBox"
@onready var detection_area: Area2D = $"../../DetectionArea"

signal death_finished

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	test_label.text = "Dead"
	animator.play("dead")


func exit():
	test_label.text = ""
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	await animator.animation_finished
	death_finished.emit()
	pass
