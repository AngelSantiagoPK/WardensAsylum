extends Area2D

class_name VisionArea

signal target_entered_area(global_position: Vector2)
signal target_left_area


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var target_position = body.global_position
		target_entered_area.emit(target_position)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_left_area.emit()
