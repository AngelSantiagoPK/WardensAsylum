extends CanvasLayer

class_name Inventory_UI

signal equip_item(index: int, slot_to_equip)
signal drop_item_on_the_ground(index: int)
signal jutsu_slot_clicked(index: int)

@export var object: Player
@onready var grid_container: GridContainer = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/GridContainer
@onready var jutsu_slots: Array[InventorySlot] = [
	$"%FireballSlot",
	$"%KunaiSlot",
	$"%HealSlot"
]
@onready var jutsu_ui: VBoxContainer = %"Jutsu Ui"
@onready var score_label: Label = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/ScoreLabel
@onready var player_level_label: Label = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PlayerLevelLabel


const INVENTORY_SLOT_SCENE = preload("res://resources/UI/inventory_slot.tscn")

@export var size = 8
@export var columns = 4



func _ready():
	grid_container.columns = 4
	
	for i in size:
		var inventory_slot = INVENTORY_SLOT_SCENE.instantiate()
		grid_container.add_child(inventory_slot)
		
		inventory_slot.equip_item.connect(func(slot_to_equip: String): equip_item.emit(i, slot_to_equip))
		inventory_slot.drop_item.connect(func (): drop_item_on_the_ground.emit(i))

	for i in jutsu_slots.size():
		# bind is an alternative to writing an inline func()
		jutsu_slots[i].slot_clicked.connect(on_jutsu_slot_clicked.bind(i))



func toggle():
		visible = !visible
		if visible:
			score_label.text = "SCORE: " + str(Global.get_score())
			player_level_label.text = "LEVEL: " + str(Global.get_player_level())



func add_item(item: InventoryItem):
	var slots = grid_container.get_children().filter(func (slot): return slot.is_empty)
	var first_empty_slot = slots.front() as InventorySlot
	first_empty_slot.add_item(item)



func update_stack_at_slot_index(stacks_value: int, inventory_slot_index: int):
	if inventory_slot_index == -1:
		return
	var inventory_slot: InventorySlot = grid_container.get_child(inventory_slot_index)
	inventory_slot.stacks_label.text = str(stacks_value)



func clear_slot_at_index(index: int):
	# clear the ui so that inventory ui matches the actual data
	var empty_inventory_slot = INVENTORY_SLOT_SCENE.instantiate()
	empty_inventory_slot.drop_item.connect(func (): drop_item_on_the_ground.emit(index))
	empty_inventory_slot.equip_item.connect(func (slot_to_equip: String): equip_item.emit(index, slot_to_equip))
	
	var child_to_remove = grid_container.get_child(index)
	grid_container.remove_child(child_to_remove)
	grid_container.add_child(empty_inventory_slot)
	grid_container.move_child(empty_inventory_slot, index)
	


func on_jutsu_slot_clicked(index: int):
	jutsu_slot_clicked.emit(index)
	
	
	
func set_selected_jutsu_slot(index: int):
	for i in jutsu_slots.size():
		jutsu_slots[i].toggle_button_selected_variation(index == i)



func toggle_jutsu_ui(ui_is_visible: bool):
	jutsu_ui.visible = ui_is_visible
