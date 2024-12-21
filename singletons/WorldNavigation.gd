extends Node

class_name WorldNavigation

var last_room_visited: String
var current_room: String
var current_spawn_location: Marker2D

func get_last_room_path() -> String:
	return last_room_visited

func get_current_room() -> String:
	return current_room

func get_current_spawn_location() -> Marker2D:
	return current_spawn_location

func set_last_room_visited(from_path: String):
	self.last_room_visited = from_path
	
func set_current_room(to_path: String):
	self.current_room = to_path

func set_current_spawn_location(marker: Marker2D):
	self.current_spawn_location = marker
