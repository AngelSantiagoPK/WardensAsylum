extends CanvasLayer

class_name MerchantUI

var items_to_buy: Array[InventoryItem] = []
var items_to_sell: Array[InventoryItem] = []
var selected_sell_item_indexes: Array[int] = []
var selected_buy_item_indexes: Array[int]= []

@onready var buying_grid_container: GridContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MerchantColumn/BuyingGridContainer
@onready var selling_grid_container: GridContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/PlayerColumn/SellingGridContainer

@onready var buy_button: Button = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MerchantColumn/BuyButton
@onready var sell_button: Button = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/PlayerColumn/SellButton

@onready var merchant_currency_label: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/MerchantColumn/MerchantCurrencyLabel
@onready var player_currency_label: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/PlayerColumn/PlayerCurrencyLabel

const INVENTORY_SLOT = preload("res://UI/Inventory UI/inventory_slot.tscn")
var gold_coin_inventory_item = preload("res://Objects/Gold Coin/gold_coin.tres")


func setup_buying_grid():
	for child in buying_grid_container.get_children():
		child.queue_free()
	
	items_to_buy = Global.get_stock()
	
	for i in items_to_buy.size():
		var buying_slot = INVENTORY_SLOT.instantiate() as InventorySlot
		buying_slot.single_button_press = true
		buying_grid_container.add_child(buying_slot)
		buying_slot.add_item(items_to_buy[i])
		buying_slot.show_price_tag(items_to_buy[i].price * items_to_buy[i].stacks)
		buying_slot.slot_clicked.connect(on_buy_slot_clicked.bind(i))
	
	merchant_currency_label.text = "CURRENCY: " + str(Global.get_merchant_currency())


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

	player_currency_label.text = "CURRENCY: " + str(Global.get_currency())


func on_buy_slot_clicked(index: int):
	if selected_buy_item_indexes.has(index):
		buying_grid_container.get_child(index).toggle_button_selected_variation(false)
		selected_buy_item_indexes.erase(index)
	else:
		buying_grid_container.get_child(index).toggle_button_selected_variation(true)
		selected_buy_item_indexes.append(index)
		
	var total_price: int = 0
	for i in selected_buy_item_indexes:
		total_price += items_to_buy[i].price
	buy_button.disabled = selected_buy_item_indexes.size() == 0 || total_price > Global.get_currency()


func on_selling_slot_clicked(index: int):
	if selected_sell_item_indexes.has(index):
		selling_grid_container.get_child(index).toggle_button_selected_variation(false)
		selected_sell_item_indexes.erase(index)
	else:
		selling_grid_container.get_child(index).toggle_button_selected_variation(true)
		selected_sell_item_indexes.append(index)
	
	var total_price: int = 0
	for i in selected_sell_item_indexes:
		total_price += items_to_sell[i].price
	sell_button.disabled = selected_sell_item_indexes.size() == 0 || total_price > Global.get_merchant_currency()


func _on_buy_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	
	for i in selected_buy_item_indexes:
		var item_to_buy: InventoryItem = items_to_buy[i]
		buying_grid_container.get_child(i).queue_free()
		
		(player.find_child("Inventory") as Inventory).add_stackable_item_to_inventory(item_to_buy, item_to_buy.stacks) 
		
		selected_buy_item_indexes.erase(i)
		items_to_buy.erase(item_to_buy)
		
		var gold_to_add_to_merchant_purse = item_to_buy.price * item_to_buy.stacks
		Global.subtract_currency(gold_to_add_to_merchant_purse)
		Global.add_merchant_currency(gold_to_add_to_merchant_purse)
	
	items_to_buy.erase(items_to_buy[0])
	Global.update_stock(items_to_buy)
	setup_buying_grid()
	setup_selling_grid()
	buy_button.disabled = true


func _on_sell_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	var inventory = (player.find_child("Inventory") as Inventory)
	
	for i in selected_sell_item_indexes:
		var item_to_sell = items_to_sell[i]
		selling_grid_container.get_child(i).queue_free()
		var current_items_in_player_inventory = inventory.items
		current_items_in_player_inventory.erase(item_to_sell)
		inventory.items = current_items_in_player_inventory
		inventory.clear_inventory_slot(i)
		selected_sell_item_indexes.erase(i)
		
		items_to_buy.append(item_to_sell)
		var gold_to_add_to_player = item_to_sell.price * item_to_sell.stacks
		Global.add_currency(gold_to_add_to_player)
		Global.subtract_merchant_currency(gold_to_add_to_player)
	
	Global.update_stock(items_to_buy)
	setup_buying_grid()
	setup_selling_grid()
	sell_button.disabled = true
