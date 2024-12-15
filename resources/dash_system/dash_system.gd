extends Node2D

class_name DashSystem


### VARIABLES
@export var object: CharacterBody2D
@export var animator: AnimationPlayer
@export var stamina_system: StaminaSystem
@export var dash_time: float = 0.5
@export var dash_multiplier: float = 4.0

var normal_speed: float
var normal_accel: float
var can_roll: bool = true


### FUNCTIONS
func _ready() -> void:
	normal_speed = object.SPEED
	normal_accel = object.acceleration


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("dash") :
		perform_dash()


func perform_dash():
	if !can_roll:
		return
	can_roll = false
	
	if stamina_system.current_stamina < 0:
		return
	else:
		stamina_system.use_stamina(50)
	
	object.SPEED = object.SPEED * dash_multiplier
	object.acceleration = object.acceleration * dash_multiplier
	animator.play("dash")
	get_tree().create_timer(dash_time).timeout.connect(on_dash_finished)
	object.start_invincibility_frame()


func on_dash_finished():
	object.acceleration = normal_accel
	object.SPEED = normal_speed
	object.velocity = Vector2.ZERO
	
	await get_tree().create_timer(1.0).timeout
	can_roll = true
	
