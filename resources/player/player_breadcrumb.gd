extends StaticBody2D

class_name PlayerBreadcrumb

var duration = 7

func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()
