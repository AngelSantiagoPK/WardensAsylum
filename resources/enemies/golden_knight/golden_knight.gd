extends Genius

class_name GoldenKnight

### FUNCTIONS
func _ready() -> void:
	# initialize
	health_system.init(max_health)
	health_bar.max_value = max_health
	health_bar.value = max_health
	detection_system.init_detection()
	animator.play_idle_animation()
	
	# load states
	for i in state_machine.get_children():
		STATES[i.name] = i
	# states hookup
	detection_system.target_in_sight.connect(state_machine.change_state.bind(STATES.pursue))
	detection_system.target_lost.connect(state_machine.change_state.bind(STATES.wait))
	# When close to player target, do attack
	STATES.pursue.close_to.connect(state_machine.change_state.bind(STATES.wait))
	# when hit, do stagger
	health_system.hit.connect(state_machine.change_state.bind(STATES.stagger))
	#when stagger done, pursue the player target
	STATES.stagger.success.connect(state_machine.change_state.bind(STATES.wait))
	# when dead, do death
	health_system.died.connect(state_machine.change_state.bind(STATES.dead))
	# when done doing death, do more death
	STATES.dead.success.connect(cleanup)
