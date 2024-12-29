extends Node


### GLOBAL DEFINITIONS
# resets the player stats and game if true
var RESET: bool = true

func reset_game():
	RESET = true

func get_game():
	return RESET

func set_game():
	RESET = false

#region FIRST SPAWN MARKER, change if initial spawn does
const INITIAL_SPAWN: Vector2 = Vector2(51, -36)
var current_spawn_point: Vector2

func get_spawn_point(): return current_spawn_point
func set_spawn_point(position: Vector2): current_spawn_point = position
#endregion

#region ENEMY COUNT
var enemies_alive: int = 0

func get_enemies(): return enemies_alive
func set_enemies(number: int): enemies_alive = number
func add_enemy():
	enemies_alive += 1
func subtract_enemy():
	enemies_alive -= 1
func clear_enemies():
	enemies_alive = 0
#endregion

#region CURRENCY
var currency: int = 10

func add_currency(amount: int):
	currency += amount
func subtract_currency(amount: int):
	currency -= amount
func get_currency(): return currency
#endregion

#region MERCHANT
const INITIAL_CURRENCY: int = 100
const SWORD_INVENTORY_ITEM = preload("res://Objects/Weapons/sword/sword_inventory_item.tres")
const STICK_INVENTORY_ITEM = preload("res://Objects/Weapons/stick/stick_inventory_item.tres")
const SHIELD_INVENTORY_ITEM = preload("res://Objects/Weapons/shield/shield_inventory_item.tres")
const SCROLL_INVENTORY_ITEM = preload("res://Objects/Weapons/scroll/scroll_inventory_item.tres")
const KNIGHT_SWORD_INVENTORY_ITEM = preload("res://Objects/Weapons/knight_sword/knight_sword_inventory_item.tres")
const INITIAL_MERCHANT_STOCK: Array[InventoryItem] = [
	STICK_INVENTORY_ITEM,
	SHIELD_INVENTORY_ITEM,
	SWORD_INVENTORY_ITEM,
	SCROLL_INVENTORY_ITEM,
	KNIGHT_SWORD_INVENTORY_ITEM
]

var merchant_stock: Array[InventoryItem]
var merchant_currency: int = 0

func get_stock() -> Array[InventoryItem]:
	return merchant_stock

func get_merchant_currency():
	return merchant_currency
	
func add_merchant_currency(amount: int):
	merchant_currency += amount
	
func subtract_merchant_currency(amount: int):
	merchant_currency -= amount

func init_stock():
	merchant_stock = INITIAL_MERCHANT_STOCK
	merchant_currency = INITIAL_CURRENCY

func add_to_merchant_stock(item: InventoryItem):
	self.merchant_stock.append(item)

func remove_from_merchant_stock(item: InventoryItem):
	self.merchant_stock.erase(item)

func update_stock(items: Array[InventoryItem]):
	merchant_stock = items
#endregion
