extends Node2D

class_name StartingArea

@onready var player: Player = $Player
@onready var key_drop_animator: AnimationPlayer = $KeyDropAnimator
@onready var level_sfx: AudioStreamPlayer2D = $LevelSFX


func _ready() -> void:
	if Global.get_game_reset() == true:
		key_drop_animator.play("drop_key")
		Global.set_game_reset(false)
	else:
		player.global_position = Global.get_spawn_point()
	
	
	if InventoryStateManager.get_inventory().size() > 0:
		var inventory = InventoryStateManager.get_inventory()
		for i in inventory.size():
			var item: InventoryItem= inventory[i] as InventoryItem
			player.inventory.add_item(item, item.stacks)
			print("test", inventory)
		

func on_key_drop():
	level_sfx.stream = preload("res://assets/Sounds/Game/Voice3.wav")
	level_sfx.pitch_scale = randf_range(0.8, 1.2)
	level_sfx.play()
