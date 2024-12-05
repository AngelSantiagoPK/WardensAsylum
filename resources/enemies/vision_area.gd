extends Area2D

class_name VisionArea

signal target_entered_area(body)
signal target_left_area


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_entered_area.emit(body)
	elif body.is_in_group("PlayerBreadcrumb"):
		target_entered_area.emit(body)
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_left_area.emit()
