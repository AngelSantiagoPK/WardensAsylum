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
func init(stamina: int):
	max_stamina = stamina
	current_stamina = stamina
	is_stunned = false
	#end


func use_stamina(cost: int):
	current_stamina -=  cost
	
	if current_stamina <= 0:
		is_stunned = true
		drained.emit()
	else:
		timer.stop()
		timer.start()
		stamina_updated.emit(current_stamina)
	#end


func stamina_regen():
	is_stunned = true
	stamina_audio.stream = preload("res://assets/Sounds/Game/Alert.wav")
	stamina_audio.play()
	timer.start()


func _on_timer_timeout() -> void:
	current_stamina = max_stamina
	is_stunned = false
	stamina_audio.stream = preload("res://assets/Sounds/Game/Alert2.wav")
	stamina_audio.play()
	on_regen.emit()
