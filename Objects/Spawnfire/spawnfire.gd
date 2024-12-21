extends StaticBody2D

class_name Spawnfire

# Signals
signal rest
signal reached

# Variables
var active: bool = false
var interactable: bool = false
var player: Player

# Components
@onready var area_2d: Area2D = $Area2D
@onready var label: Label = $Label
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var spawn_point: Marker2D = $Marker2D
@onready var fire_audio: AudioStreamPlayer2D = $FireAudio

# Functions
func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	label.visible = interactable

func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("right_hand_action") and interactable:
		interact()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		self.player = body
		interactable = true
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interactable = false


func interact():
	if !active:
		active = true
		label.text = "rest"
		animator.visible = true
		animator.play("spark_up")
		await animator.animation_finished
		animator.play("fire")
		fire_audio.play()
		light.visible = true
	else:
		Global.set_spawn_point(spawn_point.global_position)
		player.health_system.apply_heal(999)
		InventoryStateManager.update_inventory(player.inventory.items)
		rest.emit()
		pass
