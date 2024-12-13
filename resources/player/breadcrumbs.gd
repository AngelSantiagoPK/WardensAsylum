extends Node

@onready var timer: Timer = $Timer
@onready var player: Player = $".."

func drop_breadcrumb():
	const crumb = preload("res://resources/player/player_breadcrumb.tscn")
	var node = crumb.instantiate()
	get_tree().root.add_child(node)
	node.global_position = player.global_position
	


func _on_timer_timeout() -> void:
	drop_breadcrumb()
