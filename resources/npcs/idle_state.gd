class_name NPCIdleState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var emoter: Sprite2D

signal idle_finished

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	emoter.texture = preload("res://assets/Ui/Emote/emote14.png")
	emoter.visible = true
	animator.play("idle")


func exit():
	emoter.visible = false
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	await get_tree().create_timer(1).timeout
	idle_finished.emit()
	pass
	
