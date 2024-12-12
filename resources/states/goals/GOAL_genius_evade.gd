extends State

class_name GoalGeniusEvade

@export var object: CharacterBody2D
@export var success_distance: int = 10

var target_position: Vector2
var target_vector: Vector2


var interest_array: Array[float] = [0,0,0,0,0,0,0,0]
var danger_array: Array[float] = [0,0,0,0,0,0,0,0]
@export var danger_weight = 5.0
@export var danger_padding_weight = 2.0

var context_array: Array[float] = [0,0,0,0,0,0,0,0]
var desired_direction: Vector2 = Vector2.ZERO
var resultant_force: Vector2 = Vector2.ZERO

@export var steering_force = 0.75


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


signal success
signal failure


func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)
	object.walk_animator.stop()



# FUNCTIONS
func _physics_process(delta: float) -> void:
	set_target_vector()
	calculate_interest_dot_product()
	set_danger_array()
	set_context_map()
	set_desired_direction()
	apply_context_steering(delta)
	
	if object.position.distance_to(object.target_position) > 50:
		success.emit()
	else:
		failure.emit()


func set_target_vector():
	var target_spawn = object.spawn_point.global_position
	target_vector = object.global_position.direction_to(target_spawn).normalized()


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
	object.velocity = object.velocity + resultant_force
	object.move_and_slide()
