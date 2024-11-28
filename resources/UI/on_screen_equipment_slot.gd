extends VBoxContainer

class_name OnScreenEquipmentSlot

@onready var slot_label: Label = $SlotLabel
@onready var texture_rect: TextureRect = $NinePatchRect/CenterContainer/TextureRect
@onready var cooldown_rect: ColorRect = $NinePatchRect/CooldownRect

@export var slot_name: String

func _ready() -> void:
	slot_label.text = slot_name



func on_cooldown(cooldown_timer: float):
	cooldown_rect.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(cooldown_rect, "size", Vector2(40, 48), cooldown_timer)
	tween.tween_callback(on_tween_finished)
	
	
func on_tween_finished():
	cooldown_rect.size = Vector2(40, 0)
	cooldown_rect.visible = false	
	
	
func set_equipment_texture(texture: Texture):
	texture_rect.texture = texture
