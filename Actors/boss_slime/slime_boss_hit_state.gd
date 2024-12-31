class_name SlimeBossHitState
extends State

@export var animator: AnimatedSprite2D
@export var actor: CharacterBody2D
@onready var test_label: Label = $"../../TestLabel"
@export var hurt_box: Area2D

signal hit_finished

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	hurt_box.set_collision_layer_value(6, false)
	test_label.text = "Hit"
	animator.play("hit")

func exit():
	test_label.text = ""
	hurt_box.set_collision_layer_value(6, true)
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	await animator.animation_finished
	hit_finished.emit()
	pass
