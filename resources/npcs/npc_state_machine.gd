class_name FiniteStateMachine
extends Node

@export var state: State


func _ready() -> void:
	change_state(state)


func change_state(new_state: State):
	if state is State:
		state.exit()
	
	new_state.enter()
	state = new_state
	pass
