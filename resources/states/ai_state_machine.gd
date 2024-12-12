class_name AIStateMachine
extends Node

@export var state: State
var previous_state: State


func _ready() -> void:
	change_state(state)

func change_state(state: State):	
	if state is State:
		self.state.exit()
	
	state.enter()
	self.state = state
	pass
