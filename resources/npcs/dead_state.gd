class_name DeadState
extends State

@export var animator: AnimatedSprite2D
@export var actor: NPC
@export var audio: AudioStreamPlayer2D
@export var hit_box: Area2D
@export var detection_area: Area2D

signal death_complete

func _ready() -> void:
	set_physics_process(false)


func enter():
	set_physics_process(true)
	
	hit_box.set_collision_layer_value(6, false)
	actor.set_collision_layer_value(6, false)
	detection_area.set_collision_layer_value(6, false)
	
	animator.play("dead")
	Global.score += 50
	
	if actor.item_to_drop == null:
		return
		
	var loot_drop = actor.PICKUP_ITEM_SCENE.instantiate()
	loot_drop.inventory_item = actor.item_to_drop
	loot_drop.stacks = actor.loot_stacks
		
	get_tree().root.add_child(loot_drop)
	loot_drop.global_position = actor.global_position


func exit():
	hit_box.set_collision_layer_value(6, true)
	actor.set_collision_layer_value(6, true)
	detection_area.set_collision_layer_value(6, true)
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	await animator.animation_finished
	death_complete.emit()
	pass
