extends StaticBody2D

class_name PlayerBreadcrumb

@export var duration = .25


func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()
