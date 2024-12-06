extends Node

class_name Inventory

@onready var inventory_ui: Inventory_UI = $"../InventoryUi"
@onready var on_screen_ui: OnScreenUI = $"../OnScreenUi"
@onready var combat_system: CombatSystem = $"../CombatSystem"
@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
signal jutsu_activated(index: int)


const PICKUP_ITEM_SCENE = preload("res://scenes/pickup_item.tscn")

# The items in our current inventory
@export var items: Array[InventoryItem] = []

var taken_inventory_slots_count: int = 0
var selected_jutsu_index = -1

func _ready() -> void:
	inventory_ui.equip_item.connect(on_item_equipped)
	inventory_ui.drop_item_on_the_ground.connect(on_item_dropped)
	inventory_ui.jutsu_slot_clicked.connect(on_jutsu_slot_clicked)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		inventory_ui.toggle()



func add_item(item: InventoryItem, stacks: int):
	if stacks && item.max_stacks > 1:
		add_stackable_item_to_inventory(item, stacks)
	else:
		var index = items.find(null)
		if index != -1:
			items[index] = item
		else:
			items.append(item)
		inventory_ui.add_item(item)
		taken_inventory_slots_count += 1
		
		
		
func add_stackable_item_to_inventory(item: InventoryItem, stacks: int):
	# reverse search for last item in inventory
	var item_index = -1
	for i in items.size():
		if items[i] != null and items[i].name == item.name:
			item_index = i
	if item_index != -1:
		var inventory_item = items[item_index]
		if inventory_item.stacks + stacks <= item.max_stacks:
			inventory_item.stacks += stacks
			items[item_index] = inventory_item
		else:
			var stacks_diff = inventory_item.stacks + stacks - item.max_stacks
			var additional_inventory_item = inventory_item.duplicate(true)
			inventory_item.stacks = item.max_stacks
			inventory_ui.update_stack_at_slot_index(inventory_item.max_stacks, item_index)
			additional_inventory_item.stacks = stacks_diff
			items.append(additional_inventory_item)
			inventory_ui.add_item(additional_inventory_item)
	else:
		item.stacks = stacks 
		items.append(item)
		inventory_ui.add_item(item)
		taken_inventory_slots_count += 1



func on_item_equipped(index: int, slot_to_equip):
	var item_to_equip = items[index]
	on_screen_ui.equip_item(item_to_equip, slot_to_equip)
	combat_system.set_active_weapon(item_to_equip.weapon_item, slot_to_equip)

	check_jutsu_ui_visibility()

func on_item_dropped(index: int):
	clear_inventory_slot(index)
	eject_item_to_ground(index)

	check_jutsu_ui_visibility()

func clear_inventory_slot(index: int):
	# prevents players from dropping their cakes and eating them too (weapon drops)
	# reduce inventory count or risk bad math
	taken_inventory_slots_count -= 1
	inventory_ui.clear_slot_at_index(index)
	pass

func eject_item(index):
	if index == null || index == -1:
		return
		
	items[index] = null
	clear_inventory_slot(index)
	
func eject_item_to_ground(index):
	# adds dropped weapon to world so things don't just dissapear into oblivion when you drop them
	var inventory_item_to_ejected = items[index]
	var item_to_eject_as_pickup =  PICKUP_ITEM_SCENE.instantiate() as PickupItem
	
	item_to_eject_as_pickup.inventory_item = inventory_item_to_ejected
	item_to_eject_as_pickup.stacks = inventory_item_to_ejected.stacks
	
	get_tree().root.add_child(item_to_eject_as_pickup)
	
	item_to_eject_as_pickup._disable_collision()
	item_to_eject_as_pickup.global_position = get_parent().global_position
	
	var eject_direction = animated_sprite_2d.item_eject_direction
	
	if eject_direction.x == 0:
		eject_direction.x = randf_range(-1,1)
	else:
		eject_direction.y = randf_range(-1,1)

	var eject_positon = get_parent().global_position + Vector2(20, 20) * eject_direction
	var ejection_tween = get_tree().create_tween()
	ejection_tween.set_trans(Tween.TRANS_BOUNCE)
	ejection_tween.tween_property(item_to_eject_as_pickup, "global_position", eject_positon, .2)
	ejection_tween.finished.connect(func(): item_to_eject_as_pickup._enable_collision())

	if combat_system.right_weapon == inventory_item_to_ejected.weapon_item:
		combat_system.right_weapon = null
		on_screen_ui.right_hand_slot.set_equipment_texture(null)
		
	if combat_system.left_weapon == inventory_item_to_ejected.weapon_item:
		combat_system.left_weapon = null
		on_screen_ui.left_hand_slot.set_equipment_texture(null)
	
	items[index] = null



func on_jutsu_slot_clicked(index: int):
	selected_jutsu_index = index
	inventory_ui.set_selected_jutsu_slot(selected_jutsu_index)
	jutsu_activated.emit(index)
	
	
	
func check_jutsu_ui_visibility():
	var should_show_magic_ui = (combat_system.left_weapon != null and \
	combat_system.left_weapon.attack_type == "Magic") or \
	(combat_system.right_weapon != null and \
	combat_system.right_weapon.attack_type == "Magic")
	inventory_ui.toggle_jutsu_ui(should_show_magic_ui)
	if should_show_magic_ui == false:
		on_screen_ui.toggle_jutsu_slot(false, null)
	
	
