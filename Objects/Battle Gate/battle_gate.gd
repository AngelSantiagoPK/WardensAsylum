extends StaticBody2D

class_name BattleGate
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var gate_sprite: Sprite2D = $GateSprite
@onready var gate_audio: AudioStreamPlayer2D = $GateAudio


# Functions
func open_gate():
	collision.disabled = true
	gate_sprite.hide()

func close_gate():
	collision.disabled = false
	gate_sprite.show()
