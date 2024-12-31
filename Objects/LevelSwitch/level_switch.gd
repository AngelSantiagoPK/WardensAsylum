class_name LevelSwitch
extends Area2D

enum STATES { UNTOUCHED, TOUCHED }
var state: STATES = STATES.UNTOUCHED
var previous_state: STATES = STATES.UNTOUCHED

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var switch_audio: AudioStreamPlayer2D = $SwitchAudio
const SFX = preload("res://assets/Sounds/Game/Explosion3.wav")

signal switch_touched

func is_touched() -> bool: return state == STATES.TOUCHED

func _on_body_entered(body: Node2D) -> void:
	if state == STATES.TOUCHED:
		return
	
	if body.is_in_group("Player"):
		state = STATES.TOUCHED
		switch_audio.stream = SFX
		switch_audio.play()
		sprite_2d.region_rect = Rect2(16, 16, 16, 16)
		switch_touched.emit()
