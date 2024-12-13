extends Node

class_name PlayerInventoryTracker

static var player_inventory: Array[InventoryItem] = []


func get_inventory(): return player_inventory

func update_inventory(inventory: Array[InventoryItem]):
	self.player_inventory = inventory
