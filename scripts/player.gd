extends CharacterBody2D

class_name Player

@onready var animated_sprite_2D: AnimationController = $AnimatedSprite2D
@onready var inventory: Inventory = $InventoryToggler

const SPEED = 5000.0

func _physics_process(delta: float) -> void:
	
	if animated_sprite_2D.animation.contains("attack"):
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta)
		velocity.y = move_toward(velocity.y, 0, SPEED*delta)
	
	if velocity != Vector2.ZERO:
		animated_sprite_2D.play_movement_animation(velocity)
	else:
		animated_sprite_2D.play_idle_animation(velocity)
	
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickupItem:
		inventory.add_item(area.inventory_item, area.stacks)
		area.queue_free()
