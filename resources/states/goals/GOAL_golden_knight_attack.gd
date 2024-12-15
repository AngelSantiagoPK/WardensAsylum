extends State

class_name GoalGoldenKnightAttack

@export var object: CharacterBody2D
@export var target_distance = 200
@export var dash_force = 2

@onready var combat_system: EnemyCombatSystem = $"../../CombatSystem"
@onready var animator: GoldenKnightAnimationController = $"../../AnimatedSprite2D"
@onready var attack_animator: AnimationPlayer = $"../../AnimatedSprite2D/AttackAnimator"

signal success

func _ready() -> void:
	set_physics_process(false)

func enter():
	set_physics_process(true)
	combat_system.perform_attack("right")
	

func _physics_process(delta: float) -> void:
	await get_tree().create_timer(1.0).timeout
	success.emit()
	pass


func exit():
	set_physics_process(false)
