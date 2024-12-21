extends Node

class_name AsylumMode

var high_score: int = 0
var round_number: int = 0
var round_time_limit: int = 60

var skeletons_to_spawn: int = 0
var gold_knights_to_spawn: int = 0
var enemies_alive: int = 0

var player_spawn_point: Vector2 = Vector2.ZERO
var player_score: int = 0
var player_is_alive: bool = false
var player_victory: bool = false

signal victory
signal round_start


func game_reset():
	round_number= 0
	skeletons_to_spawn= 0
	gold_knights_to_spawn = 0
	enemies_alive = 0
	
	player_spawn_point = Vector2.ZERO
	player_score = 0
	player_is_alive = false
	player_victory = false
		

func skeleton_killed():
	player_score += 50
	enemies_alive -= 1
	check_game()


func check_game():
	if enemies_alive <= 0:
		victory.emit()


func start_round():
	round_number += 1
	
	skeletons_to_spawn = round_number * 2
	enemies_alive = skeletons_to_spawn
	
	player_is_alive = true
	player_victory = false
	
	round_start.emit()
