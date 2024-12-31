class_name SlimeBossIdleState
extends State

@export var animator: AnimatedSprite2D
@export var actor: CharacterBody2D
@onready var test_label: Label = $"../../TestLabel"

signal idle_timeout

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	test_label.text = "Idle"
	animator.play("idle")


func exit():
	test_label.text = ""
	set_physics_process(false)


func _physics_process(_delta: float) -> void:
	await get_tree().create_timer(1.0).timeout
	idle_timeout.emit()
	pass
