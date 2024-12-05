# AUTHOR: ANGEL SANTIAGO - DEC 1, 2024
extends ProgressBar

class_name EnemyHealthBar

#VARIABLES
@onready var health_system: HealthSystem = $"../HealthSystem"
@onready var enemy_audio: AudioStreamPlayer2D = $"../EnemyAudio"

#FUNCTIONS
func _ready() -> void:
	visible = false
	max_value = health_system.max_health
	value = max_value
	health_system.damage_taken.connect(on_damage_taken)
	#end


func on_damage_taken(damage: int):
	if !visible:
		visible = true
	
	# animates the health bar for enemies
	var tween = create_tween()
	tween.tween_property(self, "value", value - damage, 0.3)
	
	#value -= damage
	enemy_audio.stream = preload("res://assets/Sounds/Game/Hit6.wav")
	enemy_audio.play()
	#end
