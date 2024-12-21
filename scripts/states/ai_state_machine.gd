class_name AIStateMachine
extends Node

@export var state: State
var previous_state: State


func _ready() -> void:
	change_state(state)

func change_state(new_state: State):	
	if new_state is State:
		self.state.exit()
	
	new_state.enter()
	self.state = new_state
	pass
