extends VBoxContainer


class_name OnScreenEquipmentSlot

@onready var slot_label: Label = $SlotLabel
@onready var texture_rect: TextureRect = $NinePatchRect/CenterContainer/TextureRect

@export var slot_name: String

func _ready() -> void:
	slot_label.text = slot_name
	
func set_equipment_texture(texture: Texture):
	texture_rect.texture = texture
