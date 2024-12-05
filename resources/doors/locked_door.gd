extends StaticBody2D

class_name LockedDoor

@onready var label: Label = $Label
@onready var door_audio: AudioStreamPlayer2D = $DoorAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var key_name: String = "key"
var is_unlockable = false
var has_key = false
var player: Player
var is_open: bool = false


func _input(event: InputEvent) -> void: 
	if Input.is_action_just_pressed("shop_toggle") and is_unlockable and has_key:
		unlock_door()


func unlock_door():	
	has_key = false
	label.visible = false
	door_audio.play()
	animation_player.play('open')
	await door_audio.finished
	is_open = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_unlockable = false
		label.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body as Player
		is_unlockable = true
		if !is_open:
			label.visible = true
		has_key = true
	
