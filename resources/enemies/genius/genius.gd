extends CharacterBody2D

class_name Genius

#region ATTRIBUTE VARIABLES
@export_group("Targeting")
@export var target: Player

@export_group("Base Stats")
@export var max_health: int = 100
@export var damage_to_player: int = 10

@export_group("Movement Physics")
@export var speed: float = 70
@export var acceleration = 100
@export var friction = 400

@export_group("Knockback")
@export var knockback_force: int = 1000
@export var knockback_time: float = 0.50

var player_in_range: bool = false
var player_in_sight: bool = false
#endregion

#region REFERENCES
@onready var animator: GoldenKnightAnimationController = $AnimatedSprite2D
@onready var hit_animator: AnimationPlayer = $HitAnimator
@onready var walk_animator: AnimationPlayer = $HitAnimator

@onready var context_map: ContextMap = $ContextMap
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var target_update: Timer = $TargetUpdate
@onready var target_position = Vector2.ZERO
@onready var detection_system: DetectionSystem = $DetectionSystem

@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var hurt_box: Area2D = $HurtBox

@onready var timer: Timer = $Timer
@onready var knockback_timer: Timer = $KnockbackTimer

#endregion


@onready var state_machine: AIStateMachine = $StateMachine
var STATES = {}

func init(target: Player) -> void:
	self.target = target

### FUNCTIONS
func _ready() -> void:
	health_system.init(max_health)
	health_bar.max_value = max_health
	health_bar.value = max_health
	detection_system.init_detection()
	animator.play_idle_animation()

	
	for i in state_machine.get_children():
		STATES[i.name] = i
	
	# states hookup
	detection_system.target_in_sight.connect(state_machine.change_state.bind(STATES.pursue))
	detection_system.target_lost.connect(state_machine.change_state.bind(STATES.wait))
	# When close to player target, do attack
	STATES.pursue.close_to.connect(state_machine.change_state.bind(STATES.attack))
	# when attack attempted, go to pursue player target
	STATES.attack.success.connect(state_machine.change_state.bind(STATES.pursue))
	# when hit, do stagger
	health_system.hit.connect(state_machine.change_state.bind(STATES.stagger))
	#when stagger done, pursue the player target
	STATES.stagger.success.connect(state_machine.change_state.bind(STATES.wait))
	# when dead, do death
	health_system.died.connect(state_machine.change_state.bind(STATES.dead))
	# when done doing death, do more death
	STATES.dead.success.connect(cleanup)


func _physics_process(delta: float) -> void:
	pass

#region Knockback!
func apply_knockback(player_position: Vector2):
	var knock_direction = -sign(global_position.direction_to(player_position))
	velocity += knock_direction * knockback_force
	knockback_timer.wait_time = knockback_time
	knockback_timer.start()
	move_and_slide()

func _on_knockback_timer_timeout() -> void:
	velocity = Vector2.ZERO
#endregion

#region Death n' Stuff
func enable_collisions():
	set_collision_layer_value(2, true)
	set_collision_layer_value(3, true)
	set_collision_layer_value(6, true)
	hurt_box.set_collision_layer_value(6, true)
	
	
func disable_collisions():
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(6, false)
	hurt_box.set_collision_layer_value(6, false)

func cleanup():
	set_physics_process(false)
	await get_tree().create_timer(0.75).timeout
	queue_free()
#endregion

func _on_target_update_timeout() -> void:
	if target:
		target_position = target.global_position
		self.animator.play_movement_animation(velocity)
