extends Resource

class_name EnemyConfig

@export var speed: float = 100
@export var patrol_wait_time = 1.0
@export var damage_to_player = 10
@export var health: int = 50
@export var item_to_drop: InventoryItem
@export var loot_stacks: int = 1
@export var sprite_frames: SpriteFrames = preload("res://resources/enemies/slime/enemy_slime_sprite.tres")
@export var collision_shape = RectangleShape2D
