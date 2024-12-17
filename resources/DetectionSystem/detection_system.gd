extends Node2D

class_name DetectionSystem

signal target_in_sight
signal target_lost

#region VARIABLES
@export var object: CharacterBody2D
var target: Player
@export var target_group: String = "Player"
var target_in_range: bool = false
@onready var rays: Node2D = $Rays
var RAYS = {}
#endregion


func init_detection() -> void:
	self.target = object.target
	self.target_group = target_group

func _ready() -> void:
	#get visioncast ray list
	for i in rays.get_children():
		RAYS[i.name] = i

func _physics_process(delta: float) -> void:
	sight_check()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(target_group):
		target_in_range = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group(target_group):
		target_in_range = false


func sight_check():
	if target == null:
		return
	
	# target is not seen beyond this object's sight distance
	if !target_in_range:
		return
	
	if target_in_range:
		# Rotate the rays toward their target
		for key in RAYS.keys():
			var ray = RAYS[key]
			ray.rotation = global_position.angle_to_point(target.global_position)
		
		var target_aquired = false
		
		# Update the rays and check them all for unobstructed view of their target
		for key in RAYS.keys():
			var ray = RAYS[key]
			ray.force_raycast_update()
			if ray.is_colliding():
				if ray.get_collider().is_in_group(target_group):
					target_aquired = true
		
		if target_aquired == true:
			target_in_sight.emit()
		else:
			target_lost.emit()
