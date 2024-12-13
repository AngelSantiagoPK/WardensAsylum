extends CanvasLayer

class_name OnScreenUI

@onready var left_hand_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/LeftHandSlot
@onready var right_hand_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/RightHandSlot
@onready var potion_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/PotionSlot
@onready var jutsu_slot: OnScreenEquipmentSlot = $MarginContainer/HBoxContainer/JutsuSlot

@onready var player_health_bar: ProgressBar = $MarginContainer/PlayerHealthStaminaContainer/PlayerHealthBar
@onready var player_stamina_bar: ProgressBar = $MarginContainer/PlayerHealthStaminaContainer/PlayerStaminaBar

@onready var slots_dictionary = {
	"Right_Hand": right_hand_slot,
	"Left_Hand": left_hand_slot,
	"Potions": potion_slot,
	"Jutsu": jutsu_slot
}

func equip_item(item: InventoryItem, slot_to_equip: String):
	slots_dictionary[slot_to_equip].set_equipment_texture(item.texture)



func toggle_jutsu_slot(slot_is_visible: bool, ui_texture: Texture):
	jutsu_slot.visible = slot_is_visible
	if is_visible:
		jutsu_slot.set_equipment_texture(ui_texture)



func jutsu_cooldown_activated(cooldown: float):
	jutsu_slot.on_cooldown(cooldown)



func init_health_bar(max_health: int):
	player_health_bar.max_value = max_health



func apply_damage(current_health:int):
	var tween = create_tween()
	tween.tween_property(player_health_bar, "value", current_health, 0.5)


func init_stamina_bar(max_stamina: int):
	player_stamina_bar.max_value = max_stamina


func update_stamina_bar(new_value:int):
	var tween = create_tween()
	tween.tween_property(player_stamina_bar, "value", new_value, 0.4)
	
