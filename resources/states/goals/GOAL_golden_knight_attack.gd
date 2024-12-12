extends State

class_name GoalGoldenKnightAttack

@export var object: CharacterBody2D

@onready var emote: Sprite2D = %Emote
@onready var combat_system: CombatSystem = $"../../CombatSystem"

signal success

func enter():
	set_physics_process(true)
	#await object.animator.animation_finished
	#object.animator.play_attack_animation()
	#await object.animator.animation_finished
	combat_system.perform_action(combat_system.right_weapon, combat_system.right_hand_weapon_sprite, combat_system.right_hand_collision_shape_2d)
	success.emit()

func _physics_process(delta: float) -> void:
	pass


func exit():
	set_physics_process(false)
