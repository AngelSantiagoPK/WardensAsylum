extends Area2D

class_name Jutsu

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2
var speed: float
var damage: int

# Called when the node enters the scene tree for the first time.
func init(config: JutsuConfig):
		collision_shape_2d.shape = config.collision_shape
		name = config.jutsu_name
		damage = config.damage
		speed = config.speed
		animated_sprite_2d.play(config.jutsu_name.to_lower())
		
		
func _process(delta: float) -> void:
	position += speed * direction * delta
