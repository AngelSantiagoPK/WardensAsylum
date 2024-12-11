class_name FiniteStateMachine
extends Node

@export var state: State
var previous_state: State


func _ready() -> void:
	change_state(state)


func change_state(new_state: State):
	if state == new_state:
		return
		
	if new_state is State and state != new_state:
		state.exit()
	
	new_state.enter()
	state = new_state
	pass
