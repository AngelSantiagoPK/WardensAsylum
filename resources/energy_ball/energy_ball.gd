extends Area2D
class_name EnergyBall

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var life: float = 3.0
var damage_to_player: int = 10
var speed: int = 10
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(life).timeout
	queue_free()
	
func init(config):
	self.speed = config.speed
	self.damage_to_player = config.damage_to_player
	self.life = config.life

func _process(delta: float) -> void:
	self.position += self.speed * self.direction * delta
