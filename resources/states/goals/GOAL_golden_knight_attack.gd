extends State

class_name GoalGoldenKnightAttack

@export var object: CharacterBody2D

@onready var emote: Sprite2D = %Emote
@onready var combat_system: EnemyCombatSystem = $"../../CombatSystem"

signal success

func enter():
	set_physics_process(true)
	var weapon = object.combat_system.right_weapon as WeaponItem
	object.animator.stop()
	await get_tree().create_timer(0.5).timeout
	combat_system.perform_attack("right")
	await get_tree().create_timer(0.5).timeout
	combat_system.on_attack_animation_finished()
	success.emit()


func _physics_process(delta: float) -> void:
	pass


func exit():
	set_physics_process(false)
