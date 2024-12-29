extends State

class_name GoalSmallSlimePursue

### VARIABLES
@export_group("Target")
@export var object: CharacterBody2D

@export var target_distance = 10
var target_position: Vector2
var target_vector: Vector2

@export_group("Context Weight")
var interest_array: Array[float] = [0,0,0,0,0,0,0,0]
var danger_array: Array[float] = [0,0,0,0,0,0,0,0]
@export var danger_weight = 5.0
@export var danger_padding_weight = 2.0
@export var steering_force = 0.75
var context_array: Array[float] = [0,0,0,0,0,0,0,0]
var desired_direction: Vector2 = Vector2.ZERO
var resultant_force: Vector2 = Vector2.ZERO
var NORMAL_VECTORS = [
	Vector2(0,-1),
	Vector2(1,-1),
	Vector2(1,0),
	Vector2(1,1),
	Vector2(0,1),
	Vector2(-1,1),
	Vector2(-1,0),
	Vector2(-1,-1)
	]


### REFERENCES
@onready var target_update_interval_time = 1
@onready var target_update_timer
@onready var walk_animator: AnimationPlayer = $"../../WalkAnimator"


### SIGNALS
signal close_to


### FUNCTIONS
func _ready() -> void:
	set_physics_process(false)
	

func enter():
	set_physics_process(true)
	

func exit():
	set_physics_process(false)

func make_path():
	if object.target != null:
		object.nav_agent.target_position = object.target.global_position
	
# FUNCTIONS
func _physics_process(delta: float) -> void:
	make_path()
	set_target_position(object.target_position)
	set_target_vector()
	calculate_interest_dot_product()
	set_danger_array()
	set_context_map()
	set_desired_direction()
	apply_context_steering(delta)
	
	if object.global_position.distance_to(object.target_position) < target_distance:
		close_to.emit()


### GET DESIRED DIRECTION
func get_resultant_force(_delta: float): return resultant_force

### SETTERS
func set_target_position(_target_position: Vector2):
	self.target_position = _target_position


func set_target_vector():
	target_vector = object.global_position.direction_to(target_position).normalized()


func calculate_interest_dot_product():
	for i in NORMAL_VECTORS.size():
		var value = target_vector.dot(NORMAL_VECTORS[i])
		interest_array[i] = value


func set_danger_array():
	var rays = object.context_map.get_children()
	
	for i in rays.size():
		if rays[i].get_collider():
			danger_array[i] = danger_weight
			# add padding weight to values before and after
			if i-1 > 0:
				danger_array[i-1] = danger_padding_weight
			if i+1 < rays.size():
				danger_array[i+1] = danger_padding_weight


func set_context_map():
	# subtract interest array from danger array to get context values
	for i in danger_array.size():
		context_array[i] =  interest_array[i] - danger_array[i]


func set_desired_direction():
	var highest_context_value = context_array.max()
	var index = context_array.find(highest_context_value)
	desired_direction = NORMAL_VECTORS[index]


func apply_context_steering(delta:float):	
	resultant_force = (steering_force * desired_direction) - object.velocity * delta
	object.velocity += resultant_force * object.acceleration * delta
	object.velocity = object.velocity.limit_length(object.speed)
	object.move_and_slide()
