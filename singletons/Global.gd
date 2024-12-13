extends Node


### GLOBAL DEFINITIONS
# resets the player stats and game if true
var RESET = true

# FIRST SPAWN MARKER, change if initial spawn does
const INITIAL_SPAWN = Vector2(51, -36)

var total_score: int = 0
var player_xp = 0
var player_level: int = 1
var xp_to_next_level: float = player_level * 100 * 1.25
var spawn_point: Vector2


### SIGNALS
signal level_up

### GETTERS
func get_game_reset(): return RESET
func get_score(): return total_score
func get_player_level(): return player_level
func get_spawn_point(): return spawn_point


### SETTERS
func set_game_reset(value: bool):
	self.RESET = value

func increase_score(score: int):
	self.total_score += score

func decrease_score(score: int):
	self.score -= score

func set_spawn_point(spawn_position: Vector2):
	self.spawn_point = spawn_position

func give_player_xp(xp: int):
	if xp < 0: return
	player_xp += xp

### GLOBAL FUNCTIONS
func update_level():
	if player_xp > xp_to_next_level:
		player_level += 1
		xp_to_next_level = player_level * 100 * 1.25
		player_xp = 0
		level_up.emit()

func game_reset():
	spawn_point = INITIAL_SPAWN
