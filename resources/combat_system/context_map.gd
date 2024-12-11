extends Node

class_name ContextMap

# VARIABLES
var target_position: Vector2
var target_vector

var interest_array: Array[float] = [0,0,0,0,0,0,0,0]
var danger_array: Array[float] = [0,0,0,0,0,0,0,0]
@export var danger_weight = 5.0
@export var danger_padding_weight = 2.0

var context_array: Array[float] = [0,0,0,0,0,0,0,0]
var desired_direction: Vector2 = Vector2.ZERO

@export var steering_force = 0.75
@export var animator: AnimationController

# CONSTANTS
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

# FUNCTIONS
func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	set_target_vector()
	set_interest_dot_product()
	set_danger_array()
	set_context_map()
	set_desired_direction()
	apply_context_steering(delta)



### SETTERS
func set_target_position(target_position: Vector2):
	self.target_position = target_position


func set_target_vector():
	target_vector = get_parent().position.direction_to(target_position).normalized()


func set_interest_dot_product():
	for i in NORMAL_VECTORS.size():
		var value = target_vector.dot(NORMAL_VECTORS[i])
		interest_array[i] = value


func set_danger_array():
	var rays = self.get_children()
	
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
	var resulting_force = (steering_force * desired_direction) - get_parent().velocity * delta
	get_parent().velocity = get_parent().velocity + resulting_force
	get_parent().move_and_slide()
