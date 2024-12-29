extends Node

class_name PlayerInventoryTracker

static var player_inventory: Array[InventoryItem] = []
var current_weapon_left: int = 0
var current_weapon_right: int = 0

func get_inventory(): return player_inventory

func update_inventory(inventory: Array[InventoryItem]):
	self.player_inventory = inventory

func update_active_weapon(index: int, equip_to_slot: String):
	if equip_to_slot == "Right_Hand":
		current_weapon_right = index
	
	if equip_to_slot == "Left_Hand":
		current_weapon_left = index

func get_right_weapon():
	return current_weapon_right

func get_left_weapon():
	return current_weapon_left
