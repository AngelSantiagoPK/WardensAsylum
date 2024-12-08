class_name SlimeBossSlamState
extends State

@export var animator: AnimatedSprite2D
@export var actor: CharacterBody2D
@onready var test_label: Label = $"../../TestLabel"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@export var audio: AudioStreamPlayer2D

signal slam_finished

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	test_label.text = "Slam"
	audio.stream = preload("res://assets/Sounds/Game/Strange.wav")
	audio.play()
	animation_player.play('new_animation')


func exit():
	test_label.text = ""

	set_physics_process(false)


func _physics_process(delta: float) -> void:
	await animator.animation_finished
	audio.stream = preload("res://assets/Sounds/Game/Explosion.wav")
	audio.play()
	await audio.finished
	slam_finished.emit()
	pass
