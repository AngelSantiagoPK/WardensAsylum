extends CharacterBody2D

class_name Enemy

# EXPORTS
@export var enemy_config: Resource
@export var patrol_path: Array[Marker2D] = []

# VARIABLES
var speed: float
var patrol_wait_time
var damage_to_player: int

@export var max_health: int = 0
var item_to_drop: InventoryItem
var loot_stacks: int = 1
var sprite_frames: SpriteFrames

var current_patrol_target = 0
var wait_timer = 0.0
var agro = false

# ONREADY VARIABLES
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape_2d: CollisionShape2D = $Area2D/AreaCollisionShape2D
@onready var enemy_audio: AudioStreamPlayer2D = $EnemyAudio
@onready var vision_area_2d: VisionArea = $VisionArea2D
@onready var emote_sprite: Sprite2D = $EmoteSprite
@onready var sprite_animator: AnimationPlayer = $SpriteAnimator
@export var target: Node2D

# ITEM TO BE DROPPED SCENE
const PICKUP_ITEM = preload("res://scenes/pickup_item.tscn")


# FUNCTIONS
func _ready() -> void:
	config()
	
	health_system.init(max_health)
	health_bar.max_value = max_health
	health_bar.value = max_health
	
	
	if sprite_frames != null:
		animated_sprite_2d.sprite_frames = sprite_frames
	
	if patrol_path.size() > 0:
		position = patrol_path[0].position
	
	health_system.died.connect(on_died)
	vision_area_2d.target_entered_area.connect(spot_target)
	vision_area_2d.target_left_area.connect(lose_target)
	#end


func _physics_process(delta: float) -> void:
	if agro == false:
		if patrol_path.size() > 1:
			move_along_path(delta)
	else:
		chase_target(delta)


func config():
	#init monster stats
	if enemy_config != null:
		speed = enemy_config.speed
		patrol_wait_time = enemy_config.patrol_wait_time
		damage_to_player = enemy_config.damage_to_player
		max_health = enemy_config.health
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
	#end


func apply_damage(damage: int):
	FreezeEngineManager.frameFreeze()
	health_system.apply_damage(damage)
	sprite_animator.play('hit')
		#end


func on_died():
	set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	area_collision_shape_2d.set_deferred("disabled", true)
	
	# Enemy death animations
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


func chase_target(delta: float):
	if target == null:
		return
		
	velocity = position.direction_to(target.global_position) * speed * delta
	
	if position.distance_to(target.global_position) > 1:
		move_and_slide()
	#end


func spot_target(body: Node2D):
	# make noise only on first spot
	if agro == false:
		enemy_audio.stream = preload("res://assets/Sounds/Game/Voice3.wav")
		enemy_audio.play()
		emote_sprite.texture = preload("res://assets/Ui/Emote/emote22.png")
		emote_sprite.visible = true
		
	agro = true
	target = body as Node2D
	#end


func lose_target():
	await get_tree().create_timer(1.0).timeout
	agro = false
	
	# lose player animation
	emote_sprite.texture = preload("res://assets/Ui/Emote/emote21.png")
	await get_tree().create_timer(2.0).timeout
	emote_sprite.visible = false
	pass
