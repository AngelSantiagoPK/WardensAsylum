extends Node2D

class_name CombatSystem

# Signals
signal cast_active_jutsu
signal active_block

# Variables
@export var animated_sprite_2d: AnimationController
@export var player_audio: AudioStreamPlayer2D
@export var stamina_system: StaminaSystem
@export var on_screen_ui: OnScreenUI
@export var right_weapon: WeaponItem
@export var left_weapon: WeaponItem
var can_attack: bool = true

# Components
@onready var right_hand_weapon_sprite: Sprite2D = $RightHandWeaponSprite
@onready var right_hand_collision_shape_2d: CollisionShape2D = $RightHandWeaponSprite/Area2D/CollisionShape2D
@onready var left_hand_collision_shape_2d: CollisionShape2D = $LeftHandWeaponSprite/Area2D/CollisionShape2D
@onready var left_hand_weapon_sprite: Sprite2D = $LeftHandWeaponSprite
@onready var slice: AnimatedSprite2D = $RightHandWeaponSprite/Slice


func _ready() -> void:
	animated_sprite_2d.attack_animation_finished.connect(on_attack_animation_finished)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_hand_action"):
		perform_action(right_weapon, right_hand_weapon_sprite, right_hand_collision_shape_2d)
		
	if event.is_action_pressed("left_hand_action"):
		perform_action(left_weapon, left_hand_weapon_sprite, left_hand_collision_shape_2d)


func perform_action(weapon: WeaponItem, sprite: Sprite2D, collision_shape: CollisionShape2D):
		#region Check for attack conditions
		if !can_attack:
			return
		can_attack = false
		
		#region Play Attack Animations
		slice.play('circular_slice')
		animated_sprite_2d.play_attack_animation()
		var attack_direction = animated_sprite_2d.attack_direction
		#endregion
		
		#region TODO: add hand if weapon is empty, for now, just return
		if weapon == null:
			return
		#endregion
		
		#region Stamina System Interaction
		if stamina_system.is_stunned:
			return
		
		#TODO: Make a getter for stamina
		if stamina_system.current_stamina > 0:
			stamina_system.use_stamina(weapon.stamina_cost)
		else:
			stamina_system.set_stunned()
		#endregion
		#endregion


		#region Weapon Audio
		if weapon.prefered_weapon_sound != null:
			player_audio.stream = weapon.prefered_weapon_sound
			player_audio.pitch_scale = randf_range(0.8, 1.5)
			player_audio.play()
			#endregion


		#region Weapon Display and Activation
		var attack_data = weapon.get_data_for_direction(attack_direction)
		if weapon.side_in_hand_texture != null && ["left", "right"].has(attack_direction):
			sprite.texture = weapon.side_in_hand_texture
		else:
			sprite.texture = weapon.in_hand_texture
		
		sprite.position = attack_data.get("attachment_position")
		sprite.rotation_degrees = attack_data.get("rotation")
		sprite.z_index = attack_data.get("z_index")
		sprite.show()
		collision_shape.disabled = false
		#endregion
		
		
		#region Cast Magic Spells
		if weapon.attack_type == "Magic":
			cast_active_jutsu.emit()
		#endregion
		
		#region Shield Actions
		if weapon.shield_resource != null:
			var shield = weapon.shield_resource
			animated_sprite_2d.frame = 2
			animated_sprite_2d.pause()
			var dir = animated_sprite_2d.get_attack_vector(attack_direction)
			active_block.emit(shield, dir)
		#endregion


func set_active_weapon(weapon: WeaponItem, slot_to_equip: String):
	
	if slot_to_equip == "Left_Hand":
		if weapon.collision_shape != null:
			left_hand_collision_shape_2d.shape = weapon.collision_shape
			
		left_hand_weapon_sprite.texture = weapon.in_hand_texture
		left_weapon = weapon
	
	elif slot_to_equip == "Right_Hand":
		if weapon.collision_shape != null:
			right_hand_collision_shape_2d.shape = weapon.collision_shape
			
		right_hand_weapon_sprite.texture = weapon.in_hand_texture
		right_weapon = weapon


func on_attack_animation_finished():
	can_attack = true
	right_hand_weapon_sprite.hide()
	left_hand_weapon_sprite.hide()
	left_hand_collision_shape_2d.disabled = true
	right_hand_collision_shape_2d.disabled = true
	#end


func _on_area_2d_body_entered(body: Node2D, hand_type) -> void:
	if body.has_node("HealthSystem") and hand_type == "right":
		(body.find_child("HealthSystem") as HealthSystem).apply_damage(right_weapon.damage)
		body.apply_knockback(global_position)
		FreezeEngineManager.frameFreeze()
