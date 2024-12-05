extends Area2D

class_name ShopDoorExterior
# VARIABLES

# FUNCTIONS
func _on_body_entered(body: Node2D) -> void:
	TransitionChangeManager.player_spawn_position = Vector2.ZERO
	TransitionChangeManager.change_scene("res://scenes/shop_scene.tscn")
	#end
