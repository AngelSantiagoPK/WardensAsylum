extends CanvasLayer

class_name MerchantUI

var items_to_buy: Array[InventoryItem]
var items_to_sell: Array[InventoryItem]

var selected_sell_item_indexes: Array[int] = []
var selected_buy_item_indexes: Array[int]= []

@onready var buying_grid_container: GridContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MerchantColumn/BuyingGridContainer
@onready var selling_grid_container: GridContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/PlayerColumn/SellingGridContainer

@onready var buy_button: Button = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MerchantColumn/BuyButton
@onready var sell_button: Button = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/PlayerColumn/SellButton

const INVENTORY_SLOT = preload("res://resources/UI/inventory_slot.tscn")
var gold_coin_inventory_item = preload("res://resources/gold_coin/gold_coin.tres")

func setup_buying_grid():
	for child in buying_grid_container.get_children():
		child.queue_free()
	
	for i in items_to_buy.size():
		var buying_slot = INVENTORY_SLOT.instantiate() as InventorySlot
		buying_slot.single_button_press = true
		buying_grid_container.add_child(buying_slot)
		buying_slot.add_item(items_to_buy[i])
		buying_slot.show_price_tag(items_to_buy[i].price * items_to_buy[i].stacks)
		buying_slot.slot_clicked.connect(on_buy_slot_clicked.bind(i))


func setup_selling_grid():
	for child in selling_grid_container.get_children():
		child.queue_free()
	
	for i in items_to_sell.size():
		var selling_slot = INVENTORY_SLOT.instantiate() as InventorySlot
		selling_slot.single_button_press = true
		selling_grid_container.add_child(selling_slot)
		selling_slot.add_item(items_to_sell[i])
		selling_slot.show_price_tag(items_to_sell[i].price * items_to_sell[i].stacks)
		selling_slot.slot_clicked.connect(on_selling_slot_clicked.bind(i))


func on_buy_slot_clicked(index: int):
	if selected_buy_item_indexes.has(index):
		buying_grid_container.get_child(index).toggle_button_selected_variation(false)
		selected_buy_item_indexes.erase(index)
	else:
		buying_grid_container.get_child(index).toggle_button_selected_variation(true)
		selected_buy_item_indexes.append(index)
	
	buy_button.disabled = selected_buy_item_indexes.size() == 0



func on_selling_slot_clicked(index: int):
	if selected_sell_item_indexes.has(index):
		selling_grid_container.get_child(index).toggle_button_selected_variation(false)
		selected_sell_item_indexes.erase(index)
	else:
		selling_grid_container.get_child(index).toggle_button_selected_variation(true)
		selected_sell_item_indexes.append(index)
	
	sell_button.disabled = selected_sell_item_indexes.size() == 0


func _on_buy_button_pressed() -> void:
	for i in selected_buy_item_indexes:
		var item_to_buy = items_to_buy[i]
		var player = get_tree().get_first_node_in_group("Player") as Player
		
		(player.find_child("InventoryToggler") as Inventory).add_item(item_to_buy, item_to_buy.stacks) 
		
		var gold_to_add_to_merchant_inventory = item_to_buy.price * item_to_buy.stacks
		gold_coin_inventory_item.stacks = gold_to_add_to_merchant_inventory
		var merchant = get_tree().get_first_node_in_group("Merchant") as Merchant
		merchant.items_to_buy.erase(item_to_buy)
		merchant.items_to_buy.append(gold_coin_inventory_item)
		buying_grid_container.get_child(i).queue_free()
		selected_buy_item_indexes.erase(i)
	
	#TODO: remove gold from player inventory
	#TODO: check whether player can buy item based on amount of his gold
	setup_buying_grid()
	setup_selling_grid()
	buy_button.disabled = true


func _on_sell_button_pressed() -> void:
	var merchant = get_tree().get_first_node_in_group("Merchant") as Merchant
	var player = get_tree().get_first_node_in_group("Player") as Player
	var inventory = (player.find_child("InventoryToggler") as Inventory)
	
	for i in selected_sell_item_indexes:
		var item_to_sell = items_to_sell[i]
		selling_grid_container.get_child(i).queue_free()
		var current_items_in_player_inventory = inventory.items
		current_items_in_player_inventory.erase(item_to_sell)
		inventory.items = current_items_in_player_inventory
		inventory.clear_inventory_slot(i)
		selected_sell_item_indexes.erase(i)
		merchant.items_to_buy.append(item_to_sell)
		
		var gold_to_add_to_player = item_to_sell.price * item_to_sell.stacks
		inventory.add_item(gold_coin_inventory_item, gold_to_add_to_player)
	
	items_to_buy = merchant.items_to_buy
	setup_buying_grid()
	setup_selling_grid()
	sell_button.disabled = true
		
		
