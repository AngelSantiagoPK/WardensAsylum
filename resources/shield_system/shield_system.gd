extends Node2D

class_name ShieldSystem

@export var object: Player
@export var animator: AnimationController
var active: bool = false
var current_shield: ShieldItem
var current_direction: Vector2

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_hand_action"):
		deactivate_shield()

func activate_shield(shield: ShieldItem, direction: Vector2):
	self.current_shield = shield
	self.current_direction = direction
	active = true

func deactivate_shield():
	active = false
	animator.play_attack_animation()

func is_active(): return active

func is_blocking_angle_valid(area: Area2D):
	# Get the angle that the shield covers based on direction and shield props
	print("-+ Block Stats +-")
	var shield_direction_angle_in_radians = current_direction.angle()
	var shield_direction_angle_in_degrees = rad_to_deg(shield_direction_angle_in_radians)
	shield_direction_angle_in_degrees = wrap_angle(shield_direction_angle_in_degrees)
	print("shield direction: ", shield_direction_angle_in_degrees)
	var max_shield_angles = shield_direction_angle_in_degrees + current_shield.shield_angle_start
	max_shield_angles = wrap_angle(max_shield_angles)
	print("max cover: ", max_shield_angles)
	var min_shield_angles = shield_direction_angle_in_degrees + current_shield.shield_angle_end
	min_shield_angles = wrap_angle(min_shield_angles)
	print("min cover: ", min_shield_angles)
	# Get the angle of the attack and keep within 360 degrees too
	var attack_angle_in_radians = object.global_position.angle_to_point(area.global_position)
	var attack_angle_in_degrees = rad_to_deg(attack_angle_in_radians)
	attack_angle_in_degrees = wrap_angle(attack_angle_in_degrees)
	print("attack angle: ", attack_angle_in_degrees)
	if min_shield_angles <= max_shield_angles:
		if min_shield_angles <= attack_angle_in_degrees and attack_angle_in_degrees <= max_shield_angles:
			print("Hit Blocked")
			print("---")
			return true
	else:
		if attack_angle_in_degrees <= min_shield_angles or attack_angle_in_degrees >= max_shield_angles:
			print("Hit Blocked")
			print("---")
			return true
	
	return false


func wrap_angle(angle: float):
	return fposmod(angle, 360)

func process_enemy_attack(area: Area2D):
		area.get_parent().apply_knockback(object.global_position)
