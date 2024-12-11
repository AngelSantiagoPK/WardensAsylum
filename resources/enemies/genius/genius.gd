extends CharacterBody2D

class_name Genius

### ATTRIBUTE VARIABLES
@export_group("Targeting")
@export var target: Player
@export var spawn_point: Marker2D
@export_group("Base Stats")
@export var max_health: int = 100
@export var speed: int = 1
@export var damage_to_player: int = 10
@export_group("Knockback")
@export var knockback_force: int = 8000
@export var knockback_time: float = 0.50


### REFERENCES
@onready var animator: AnimationController = $AnimatedSprite2D
@onready var context_map: ContextMap = $ContextMap
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var hit_animator: AnimationPlayer = $HitAnimator
@onready var hurt_box: Area2D = $HurtBox
@onready var timer: Timer = $Timer
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var particle_fx: GPUParticles2D = $ParticleFX
@onready var emote: Sprite2D = $Emote


### STATE MACHINE
@onready var state_machine: AIStateMachine = $StateMachine
var STATES = {}


### FUNCTIONS
func _ready() -> void:
	# initialize
	health_system.init(max_health)
	health_bar.max_value = max_health
	health_bar.value = max_health
	animator.play_idle_animation()
	if spawn_point:
		context_map.set_spawn_point_position(spawn_point.position)
	
	# load states
	for i in state_machine.get_children():
		STATES[i.name] = i
	# states hookup
	STATES["wait"].success.connect(state_machine.change_state.bind(STATES.pursue))
	STATES["pursue"].success.connect(state_machine.change_state.bind(STATES.attack))
	STATES["attack"].success.connect(state_machine.change_state.bind(STATES.pursue))
	STATES["evade"].success.connect(state_machine.change_state.bind(STATES.heal))
	STATES["heal"].success.connect(state_machine.change_state.bind(STATES.pursue))
	STATES["stagger"].success.connect(state_machine.change_state.bind(STATES.evade))
	health_system.hit.connect(state_machine.change_state.bind(STATES.stagger))
	health_system.died.connect(state_machine.change_state.bind(STATES.dead))
	STATES["dead"].success.connect(cleanup)


### KNOCKBACK
func apply_knockback(player_position: Vector2):
	var knock_direction = -sign(global_position.direction_to(player_position))
	velocity += knock_direction * knockback_force
	knockback_timer.wait_time = knockback_time
	knockback_timer.start()
	move_and_slide()


func _on_knockback_timer_timeout() -> void:
	velocity = Vector2.ZERO


func cleanup():
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(6, false)
	hurt_box.set_collision_layer_value(6, false)
	set_physics_process(false)
	await get_tree().create_timer(0.75).timeout
	queue_free()
