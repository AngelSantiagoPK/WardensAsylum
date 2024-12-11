# AUTHOR: ANGEL SANTIAGO - DEC 1, 2024
extends ProgressBar
class_name EnemyHealthBar

#VARIABLES
@export var health_system: HealthSystem
@export var enemy_audio: AudioStreamPlayer2D

#FUNCTIONS
func _ready() -> void:
	visible = false
	max_value = health_system.max_health
	value = max_value
	health_system.update_health.connect(hit_and_update)
	#end


func hit_and_update(current_health: int):
	if !visible:
		visible = true
	
	# animates the health bar for enemies
	var tween = create_tween()
	tween.tween_property(self, "value", current_health, 0.3)
	
	#value -= damage
	enemy_audio.stream = preload("res://assets/Sounds/Game/Hit6.wav")
	enemy_audio.play()
	#end


func heal_and_update(current_health: int):
	if !visible:
		visible = true
	
	# animates the health bar for enemies
	var tween = create_tween()
	tween.tween_property(self, "value", current_health, 0.3)
	#end
