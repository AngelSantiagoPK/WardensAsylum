extends Area2D

class_name PickupItem

@export var inventory_item: InventoryItem

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2D: CollisionShape2D = $CollisionShape2D
@export var stacks: int = 1

func _ready() -> void:
	sprite_2d.texture = inventory_item.texture
	collision_shape_2D.shape = inventory_item.ground_collision_shape


func _process(delta: float) -> void:
	pass



func _disable_collision():
	collision_shape_2D.disabled = true
	
func _enable_collision():
	collision_shape_2D.disabled = false
