class_name AIStateMachine
extends Node

@export var state: State
var previous_state: State


func _ready() -> void:
	change_state(state)

func change_state(new_state: State):
	# dont repeat states
	if new_state == previous_state:
		return
	
	if new_state is State:
		state.exit()
	
	new_state.enter()
	previous_state = new_state
	pass
