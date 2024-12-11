extends Node

class_name ContextMap

# VARIABLES
var target_position: Vector2
var target_vector: Vector2
var reverse_target_vector: Vector2
var evade_target_enabled: bool = false

var spawn_point: Vector2
var spawn_point_vector: Vector2
@export var spawn_point_bias: float = 0.5

var interest_array: Array[float] = [0,0,0,0,0,0,0,0]
var danger_array: Array[float] = [0,0,0,0,0,0,0,0]
@export var danger_weight = 5.0
@export var danger_padding_weight = 2.0

var context_array: Array[float] = [0,0,0,0,0,0,0,0]
var desired_direction: Vector2 = Vector2.ZERO
var resultant_force: Vector2 = Vector2.ZERO

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
	set_spawn_point_vector()
	calculate_interest_dot_product()
	set_danger_array()
	set_context_map()
	set_desired_direction()
	set_resultant_force(delta)


### GET DESIRED DIRECTION
func get_resultant_force(): return resultant_force


### SETTERS
func set_target_position(target_position: Vector2):
	self.target_position = target_position


func set_target_vector():
	target_vector = get_parent().position.direction_to(target_position).normalized()


func set_reverse(value: bool):
	evade_target_enabled = value


func set_reverse_target_vector():
	reverse_target_vector = (get_parent().position.direction_to(target_position) * -1).normalized()


func set_spawn_point_position(spawn_position: Vector2):
	if not spawn_position:
		return
		
	self.spawn_point = spawn_position


func set_spawn_point_vector():
	spawn_point_vector = get_parent().global_position.direction_to(spawn_point).normalized()


func calculate_interest_dot_product():
	for i in NORMAL_VECTORS.size():
		var value = target_vector.dot(NORMAL_VECTORS[i])
		if spawn_point:
			value += spawn_point_vector.dot(NORMAL_VECTORS[i]) * spawn_point_bias
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


func set_resultant_force(delta:float):
	resultant_force = (steering_force * desired_direction) - get_parent().velocity * delta
	
