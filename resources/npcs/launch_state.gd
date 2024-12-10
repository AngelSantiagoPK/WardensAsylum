class_name NPCLaunchState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var energy_ball_config: ProjectileConfig
@export var hp_launch_threshold: int
@export var idle_timer: Timer
@export var wander_timer: Timer
const ENERGY_BALL = preload("res://resources/energy_ball/energy_ball.tscn")
var can_launch = true

signal launch_finished
signal launch_aborted

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	print_debug("Launch")
	print_debug("")
	
	if can_launch:
		var projectile = ENERGY_BALL.instantiate()
		can_launch = false
		get_tree().root.add_child(projectile)
		projectile.init(energy_ball_config)
		projectile.position = actor.global_position
		var launch_direction = actor.global_position.direction_to(actor.target.global_position).normalized()
		projectile.direction = launch_direction
		launch_finished.emit()

	#
	#if actor.health_system.current_health < hp_launch_threshold:
		#launch_aborted.emit()
		#return
	
	
 

func exit():
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	idle_timer.stop()
	wander_timer.stop()
	await get_tree().create_timer(randf_range(3.0, 5.0)).timeout
	can_launch = true
	pass
	
