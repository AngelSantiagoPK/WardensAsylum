extends CanvasLayer

class_name OnScreenUI

@onready var left_hand_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/LeftHandSlot
@onready var right_hand_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/RightHandSlot
@onready var potion_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/PotionSlot
@onready var spell_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/SpellSlot

@onready var slots_dictionary = {
	"Right_Hand": right_hand_slot,
	"Left_Hand": left_hand_slot,
	"Potions": potion_slot,
}
func equip_item(item: InventoryItem, slot_to_equip: String):
	slots_dictionary[slot_to_equip].set_equipment_texture(item.texture)
