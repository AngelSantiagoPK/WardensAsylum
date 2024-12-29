extends Node2D

class_name SpawnRoom

@export var player: Player
@export var spawnfire: Spawnfire

# Functions
func _ready() -> void:
	player.player_died.connect(on_player_died)
	spawnfire.rest.connect(on_rest)
	
	var initial_spawn = spawnfire.spawn_point
	WorldNavigationManager.set_current_spawn_location(initial_spawn)
	
	if Global.get_spawn_point() == null:
		return
	
	player.global_position = Global.get_spawn_point()
	var inventory = InventoryStateManager.get_inventory()
	for i in inventory:
		player.inventory.add_item(i, i.stacks)
	var weapon_right = InventoryStateManager.get_right_weapon()
	var weapon_left = InventoryStateManager.get_left_weapon()
	if weapon_right:
		player.inventory.on_item_equipped(weapon_right, "Right_Hand")
	if weapon_left:
		player.inventory.on_item_equipped(weapon_left, "Left_Hand")


func on_player_died():
	TransitionChangeManager.change_scene("res://scenes/levels/SpawnRoom/spawn_room.tscn")

func on_rest():
	TransitionChangeManager.change_scene("res://scenes/levels/SpawnRoom/spawn_room.tscn")
