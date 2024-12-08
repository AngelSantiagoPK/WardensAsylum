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

@onready var timer: Timer = $Timer
@onready var stamina_audio: AudioStreamPlayer2D = $stamina_audio

# FUNCTIONS
func _physics_process(delta: float) -> void:
	if is_stunned:
		recovery()

func init(stamina: int):
	max_stamina = stamina
	current_stamina = stamina
	is_stunned = false
	#end


func use_stamina(cost: int):
	current_stamina -=  cost
	
	if current_stamina <= 0 and !is_stunned:
		timer.wait_time = 3.0
		timer.stop()
		timer.start()
		drained.emit()
	elif current_stamina <= 0:
		timer.wait_time = 3.0
		timer.stop()
		timer.start()
	else:
		is_stunned = false
		timer.wait_time = 1.0
		timer.stop()
		timer.start()
		stamina_updated.emit(current_stamina)
	#end


func stamina_regen():
	stamina_audio.stream = preload("res://assets/Sounds/Game/Alert.wav")
	stamina_audio.play()
	timer.wait_time = 3.0
	timer.start()

func recovery():
	if current_stamina < max_stamina:
		current_stamina += 1
		on_regen.emit()
	else:
		is_stunned = false
		

func _on_timer_timeout() -> void:
	is_stunned = true
	stamina_audio.stream = preload("res://assets/Sounds/Game/Alert2.wav")
	stamina_audio.play()
	
