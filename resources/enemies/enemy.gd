extends CharacterBody2D

class_name Enemy

@export var enemy_config: Resource
@export var patrol_path: Array[Marker2D] = []
var speed: float
var patrol_wait_time
var damage_to_player: int

var health: int = 0
var item_to_drop: InventoryItem
var loot_stacks: int = 1
var sprite_frames: SpriteFrames
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape_2d: CollisionShape2D = $Area2D/AreaCollisionShape2D
@onready var enemy_audio: AudioStreamPlayer2D = $EnemyAudio
@onready var vision_area_2d: VisionArea = $VisionArea2D

const PICKUP_ITEM = preload("res://scenes/pickup_item.tscn")

var current_patrol_target = 0
var wait_timer = 0.0
var agro = false

func _ready() -> void:
	config()
	
	health_system.init(health)
	health_bar.max_value = health
	health_bar.value = health
	
	
	if sprite_frames != null:
		animated_sprite_2d.sprite_frames = sprite_frames
	
	if patrol_path.size() > 0:
		position = patrol_path[0].position
	
	health_system.died.connect(on_died)
	vision_area_2d.target_entered_area.connect(chase_target)
	vision_area_2d.target_left_area.connect(lose_target)
	#end


func _physics_process(delta: float) -> void:
	if agro == false:
		if patrol_path.size() > 1:
			move_along_path(delta)
		
func config():
	#init monster stats
	if enemy_config != null:
		speed = enemy_config.speed
		patrol_wait_time = enemy_config.patrol_wait_time
		damage_to_player = enemy_config.damage_to_player
		health = enemy_config.health
		item_to_drop = enemy_config.item_to_drop
		loot_stacks = enemy_config.loot_stacks
		sprite_frames = enemy_config.sprite_frames
		collision_shape_2d.shape = enemy_config.collision_shape
		area_collision_shape_2d.shape = enemy_config.collision_shape
	#end
	


func move_along_path(delta: float):
	var target_position = patrol_path[current_patrol_target].global_position
	var direction = (target_position - position).normalized()
	var distance_to_target = position.distance_to((target_position))
	
	if distance_to_target > speed * delta:
		animated_sprite_2d.play_movement_animation(direction)
		velocity = direction * speed
		move_and_slide()
	else:
		animated_sprite_2d.play_idle_animation()
		position = target_position
		wait_timer += delta
		if wait_timer >= patrol_wait_time:
			wait_timer = 0.0
			current_patrol_target = (current_patrol_target + 1) % patrol_path.size()



func apply_damage(damage: int):
	health_system.apply_damage(damage)


func on_died():
	set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	area_collision_shape_2d.set_deferred("disabled", true)
	animated_sprite_2d.play("died")
	enemy_audio.stream = preload("res://assets/Sounds/Game/Explosion4.wav")
	enemy_audio.play()
	#end


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "died":
		var loot_drop = PICKUP_ITEM.instantiate() as PickupItem
		loot_drop.inventory_item = item_to_drop
		loot_drop.stacks = loot_stacks
		
		get_tree().root.add_child(loot_drop)
		loot_drop.global_position = position
		queue_free()


func chase_target(target_position: Vector2):
	look_at(target_position)
	agro = true


func lose_target():
	agro = false
