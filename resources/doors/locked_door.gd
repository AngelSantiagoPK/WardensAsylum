extends StaticBody2D

class_name LockedDoor

@onready var label: Label = $Label
@onready var door_audio: AudioStreamPlayer2D = $DoorAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var player: Player
@export var key_name: String = "key"
var is_unlockable = false
var has_key = false
var is_open: bool = false


func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("ui_accept") and is_unlockable and has_key:
		unlock_door()


func unlock_door():	
	var idx = find_key_index()
	player.inventory.eject_item(idx)	
	
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
		is_unlockable = true
		
		if !is_open:
			label.visible = true
			check_inventory()
			#end


func check_inventory():
	if player.inventory.items.size() < 0:
		return
		
	var items = player.inventory.items
	for i in items.size():
		if items[i].name == key_name:
			label.text = "PRESS SPACE"
			has_key = true


func find_key_index():
	if player.inventory.items.size() < 0:
		return -1
	
	var items = player.inventory.items
	
	for i in items.size():
		if items[i].name == key_name:
			return i
	
	return -1
