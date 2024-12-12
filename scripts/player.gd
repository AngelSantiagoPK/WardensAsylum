# AUTHOR: ANGEL SANTIAGO - DEC 1, 2024
extends CharacterBody2D

class_name Player

# GLOBAL VARIABLES
@onready var animated_sprite_2D: AnimationController = $AnimatedSprite2D
@onready var inventory: Inventory = $InventoryToggler
@onready var health_system: HealthSystem = $HealthSystem
@onready var stamina_system: StaminaSystem = $StaminaSystem
@onready var on_screen_ui: OnScreenUI = $OnScreenUi
@onready var combat_system: CombatSystem = $CombatSystem
@onready var player_audio: AudioStreamPlayer2D = $PlayerAudio
@onready var area_2d: Area2D = $Area2D
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var hit_animator: AnimationPlayer = $HitAnimator

@export_group("Player Stats")
@export var SPEED = 4000.0
@export var max_health = 100
@export var stamina = 100
@export var knockback_force = 100
@export_group("")
var is_invincible = false

const PLAYER_BREADCRUMB_SCENE = preload("res://resources/player/player_breadcrumb.tscn")

# FUNCTIONS
func _ready() -> void:
	# init health system
	health_system.init(max_health)
	health_system.died.connect(on_player_dead)
	health_system.update_health.connect(on_damage_taken)
	# init stamina system
	stamina_system.init(stamina)
	stamina_system.drained.connect(on_stamina_drained)
	stamina_system.stamina_updated.connect(on_update_stamina)
	stamina_system.on_regen.connect(on_regen)
	# init ui bars
	on_screen_ui.init_health_bar(max_health)
	on_screen_ui.init_stamina_bar(stamina)
	# global init
	Global.level_up.connect(level_up)
	#end

func _physics_process(delta: float) -> void:
	
	if animated_sprite_2D.animation.contains("attack"):
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta)
		velocity.y = move_toward(velocity.y, 0, SPEED*delta)
	
	if velocity != Vector2.ZERO:
		animated_sprite_2D.play_movement_animation(velocity)
		if player_audio.playing == false:
			player_audio.stream =preload ("res://assets/Sounds/Game/footsteps/step_metal (2).ogg") 
			player_audio.play()
	else:
		animated_sprite_2D.play_idle_animation()
	
	move_and_slide()
	#end


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickupItem:
		inventory.add_item(area.inventory_item, area.stacks)
		
		player_audio.stream = preload("res://assets/Sounds/Game/Gold2.wav")
		player_audio.play()
			
		area.queue_free()
	
	# check for invincibility frame
	if is_invincible == true:
		return
	
	if area.get_parent().is_in_group("Enemy"):
		var damage_to_player = area.get_parent().damage_to_player
		health_system.apply_damage(damage_to_player)
		add_knockback(area.get_parent().velocity)
	#end


func on_damage_taken(current_health: int):
	FreezeEngineManager.frameFreeze()
	on_screen_ui.apply_damage(current_health)
	start_invincibility_frame()
	player_audio.stream = preload("res://assets/Sounds/Game/Explosion.wav")
	player_audio.play()
	hit_animator.play("hit_flash")
	
	#end


func on_player_dead():
	set_physics_process(false)
	combat_system.set_process_input(false)
	animated_sprite_2D.play('dead')
	await animated_sprite_2D.animation_finished
	TransitionChangeManager.change_scene("res://resources/UI/game_over/game_over.tscn")
	#end


func setup_test_inventory():
	const SWORD_INVENTORY_ITEM = preload("res://resources/weapons/sword/sword_inventory_item.tres")
	const GOLD_COIN = preload("res://resources/gold_coin/gold_coin.tres")
	
	inventory.add_item(SWORD_INVENTORY_ITEM, 1)
	inventory.add_item(GOLD_COIN, 100)


func on_update_stamina(current_stamina: int):
	on_screen_ui.update_stamina_bar(current_stamina)


func on_stamina_drained():
	on_screen_ui.update_stamina_bar(0)


func on_regen():
	on_screen_ui.update_stamina_bar(stamina)

func add_knockback(enemy_velocity: Vector2):
	# find other body direction
	var knock_direction = (enemy_velocity - velocity).normalized() * knockback_force
	velocity = knock_direction
	move_and_slide()
	pass

func start_invincibility_frame():
	area_2d.set_collision_layer_value(1, false)
	is_invincible = true
	invincibility_timer.start()


func _on_invincibility_timer_timeout() -> void:
	area_2d.set_collision_layer_value(1, true)
	is_invincible = false

func level_up():
	health_system.apply_heal(999)
