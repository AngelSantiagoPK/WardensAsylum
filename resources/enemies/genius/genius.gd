extends CharacterBody2D

class_name Genius

### ATTRIBUTE VARIABLES
@export var target: Player
@export var max_health: int = 100
@export var speed: int = 2000
@export var damage_to_player = 10

### REFERENCES
@onready var animator: AnimationController = $AnimatedSprite2D
@onready var context_map: ContextMap = $ContextMap
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var hit_animator: AnimationPlayer = $HitAnimator
@onready var hurt_box: Area2D = $HurtBox
@onready var timer: Timer = $Timer
@onready var particle_fx: GPUParticles2D = $ParticleFX

### FUNCTIONS
func _ready() -> void:
	health_system.init(max_health)
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_system.died.connect(on_died)
	health_system.hit.connect(on_hit)
	animator.play_idle_animation()


func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()

func make_path():
	nav_agent.target_position = target.global_position

func _on_timer_timeout() -> void:
	context_map.set_target_position(target.position)
	animator.play_movement_animation(velocity)
	pass # Replace with function body.

### HIT STATE
func on_hit():
	particle_fx.restart()
	particle_fx.emitting = true
	hit_animator.play("hit_flash")
	

### DEATH STATE
func on_died():
	timer.stop()
	set_collision_layer_value(6, false)
	hurt_box.set_collision_layer_value(6, false)
	health_bar.visible = false
	hit_animator.play("hit_flash")
	animator.play("death")
	await animator.animation_finished
	
