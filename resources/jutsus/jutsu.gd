extends Area2D

class_name Jutsu

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D

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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		(area.get_parent().find_child("HealthSystem") as HealthSystem).apply_damage(damage)
		audio_stream.play()
		queue_free()
