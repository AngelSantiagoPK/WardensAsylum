extends Node

class_name StaminaSystem

# SIGNALS
signal drained
signal stamina_updated(current_stamina: int)
signal on_regen

# VARIABLES
@export var max_stamina: int
var current_stamina: int
var is_stunned: bool
var in_recovery: bool

@onready var timer: Timer = $Timer
@onready var stamina_audio: AudioStreamPlayer2D = $stamina_audio

# FUNCTIONS
func _physics_process(delta: float) -> void:
	if in_recovery && !is_stunned:
		recovery()


func init(stamina: int):
	max_stamina = stamina
	current_stamina = stamina
	in_recovery = false
	is_stunned = false
	#end


func use_stamina(cost: int):
	#prevents negative stamina values
	if (current_stamina - cost) < 0:
		current_stamina = 0
	else:
		current_stamina -=  cost

	#decides which stamina state to go into quick recover, or slow recover
	if current_stamina <= 0 and !is_stunned:
		#player swings after having stamina and becomes stunned
		drained.emit()
	elif current_stamina <= 0 and is_stunned:
		timer.wait_time += 1.0
	else:
		#player swings and has left over energy
		in_recovery = false
		stamina_updated.emit(current_stamina)
		timer.stop()
		timer.wait_time = 1.0
		timer.start()


# stop recovery and stamina use
func set_stunned():
	is_stunned = true
	in_recovery = false
	stamina_audio.stream = preload("res://assets/Sounds/Game/Alert.wav")
	stamina_audio.play()
		
	timer.stop()
	timer.wait_time = 3.0
	timer.start()


# gradually recover stamina
func recovery():
	if current_stamina < max_stamina:
		current_stamina += 1
		on_regen.emit()
	else:
		in_recovery = false
		

# set recover back in motion on timeout
func _on_timer_timeout() -> void:
	is_stunned = false
	in_recovery = true
	stamina_audio.stream = preload("res://assets/Sounds/Game/Voice2.wav")
	stamina_audio.play()
	
