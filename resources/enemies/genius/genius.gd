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

var player_in_range: bool = false
var player_in_sight: bool = false


### REFERENCES
@onready var animator: AnimationController = $AnimatedSprite2D
@onready var hit_animator: AnimationPlayer = $HitAnimator
@onready var walk_animator: AnimationPlayer = $HitAnimator
@onready var context_map: ContextMap = $ContextMap
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var hurt_box: Area2D = $HurtBox
@onready var timer: Timer = $Timer
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var particle_fx: GPUParticles2D = $ParticleFX
@onready var detection_area: Area2D = $DetectionArea
@onready var detection_ray: RayCast2D = $DetectionRay
@onready var detection_ray_2: RayCast2D = $DetectionRay2
@onready var detection_ray_3: RayCast2D = $DetectionRay3
@onready var target_update: Timer = $TargetUpdate
@onready var target_position = Vector2.ZERO


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
	
	# load states
	for i in state_machine.get_children():
		STATES[i.name] = i
	# states hookup
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
	sight_check()
	manage_sight_check()
		
	detection_ray.force_raycast_update()
	detection_ray_2.force_raycast_update()
	detection_ray_3.force_raycast_update()

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


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false


func sight_check():
	if player_in_range:
		# Rotate the rays toward player
		detection_ray.rotation = global_position.angle_to_point(target.global_position)
		detection_ray_2.rotation = global_position.angle_to_point(target.global_position)
		detection_ray_3.rotation = global_position.angle_to_point(target.global_position)
		
		var los_1: bool = false
		var los_2: bool = false
		var los_3: bool = false
		
		# check for ray one for player line of site
		if detection_ray.is_colliding():
			if detection_ray.get_collider().is_in_group("Player"):
				los_1 = true
			else:
				los_1 = false
		
		# check for ray two for player line of site
		if detection_ray_2.is_colliding():
			if detection_ray_2.get_collider().is_in_group("Player"):
				los_2 = true
			else:
				los_2 = false
		
		# check for ray three for player line of site
		if detection_ray_3.is_colliding():
			if detection_ray_3.get_collider().is_in_group("Player"):
				los_3 = true
			else:
				los_3 = false
		
		if los_1 == true || los_2 == true || los_3 == true:
			player_in_sight = true
		else:
			player_in_sight = false
	else:
		player_in_sight = false


func manage_sight_check():
	if player_in_sight:
		state_machine.change_state(STATES.pursue)
	else:
		state_machine.change_state(STATES.wait)


func _on_target_update_timeout() -> void:
	target_position = target.global_position
	self.animator.play_movement_animation(velocity)
