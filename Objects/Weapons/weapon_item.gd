extends Resource

class_name WeaponItem

@export_group("Weapon Props")
@export var damage = 15
@export var stamina_cost = 10
@export var in_hand_texture: Texture2D
@export var side_in_hand_texture: Texture2D
@export var collision_shape: ConvexPolygonShape2D
@export_enum("Melee", "Ranged", "Magic", "Shield") var attack_type: String
@export var prefered_weapon_sound: AudioStream = preload("res://assets/Sounds/Game/Hit.wav")
@export var shield_resource: Resource
@export_group("")

@export_group("Attachment Postion")
@export var left_attachment_position: Vector2
@export var right_attachment_position: Vector2
@export var front_attachment_position: Vector2
@export var back_attachment_position: Vector2
@export_group("")

@export_group("Rotation")
@export var left_rotation: int
@export var right_rotation: int
@export var front_rotation: int
@export var back_rotation: int
@export_group("")

@export_group("Z-Index")
@export var left_z_index: int
@export var right_z_index: int
@export var front_z_index: int
@export var back_z_index: int
@export_group("")

func get_data_for_direction(direction: String):
	match direction:
		"left":
			return {
				"attachment_position": left_attachment_position,
				"rotation": left_rotation,
				"z_index": left_z_index
			}
		"right":
			return {
				"attachment_position": right_attachment_position,
				"rotation": right_rotation,
				"z_index": right_z_index
			}
		"front":
			return {
				"attachment_position": front_attachment_position,
				"rotation": front_rotation,
				"z_index": front_z_index
			}
		"back":
			return {
				"attachment_position": back_attachment_position,
				"rotation": back_rotation,
				"z_index":back_z_index
			}

func get_shield_resource():
	if shield_resource == null:
		return
	
	return shield_resource
