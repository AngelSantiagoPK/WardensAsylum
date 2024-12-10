class_name FiniteStateMachine
extends Node

@export var state: State
var previous_state: State


func _ready() -> void:
	change_state(state)


func change_state(new_state: State):	
	if state is State and state != previous_state:
		state.exit()
	
	new_state.enter()
	state = new_state
	pass
