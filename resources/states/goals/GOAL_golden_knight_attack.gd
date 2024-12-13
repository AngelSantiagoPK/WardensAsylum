extends State

class_name GoalGoldenKnightAttack

@export var object: CharacterBody2D

@onready var emote: Sprite2D = %Emote
@onready var combat_system: EnemyCombatSystem = $"../../CombatSystem"
@onready var animator: AnimationController = $"../../AnimatedSprite2D"

signal success

func enter():
	set_physics_process(true)
	
	# perform an attack
	print("attacking...")
	combat_system.perform_attack("right")
	# stall for animation, since IDK why animation finished will not work here
	await get_tree().create_timer(1.0).timeout
	combat_system.on_attack_animation_finished()
	
	print("recovering...")
	# take a pause before moving on.
	await get_tree().create_timer(1.0).timeout
	success.emit()

func _physics_process(delta: float) -> void:
	pass


func exit():
	set_physics_process(false)
	
