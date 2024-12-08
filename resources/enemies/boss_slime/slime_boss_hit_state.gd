class_name SlimeBossHitState
extends State

@export var animator: AnimatedSprite2D
@export var actor: CharacterBody2D
@onready var test_label: Label = $"../../TestLabel"

signal hit_finished

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	test_label.text = "Hit"
	animator.play("hit")

func exit():
	test_label.text = ""
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	await animator.animation_finished
	hit_finished.emit()
	pass
