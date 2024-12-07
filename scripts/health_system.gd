extends Node

class_name HealthSystem

signal died
signal damage_taken(current_health: int)

@export var max_health: int
var current_health: int


func init(health: int):
	max_health = health
	current_health = health


func apply_damage(damage: int):
	var tween = create_tween()
	tween.tween_property(self, "value", current_health - damage, 0.5)
	
	current_health = current_health - damage
	damage_taken.emit(damage)
	
	if current_health <= 0:
		died.emit()
	
