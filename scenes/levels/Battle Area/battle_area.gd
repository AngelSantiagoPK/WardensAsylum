extends Area2D

# Variables
@export var player: Player
@export var battle_gates: Array[BattleGate]
@export var min_mobs: int
@export var max_mobs: int
var SPAWNERS = {}
var battle_active: bool = false
var enemy_amount: int = 0
var enemies_alive: int = 0
var current_state
enum {
	LOCKED,
	UNLOCKED,
	CLEARED
}

#region SOUNDS
const DOOR_CLOSE: AudioStream = preload("res://assets/Sounds/Doors/qubodup-DoorClose10.ogg")
const SUCCESS: AudioStream = preload("res://assets/Sounds/Game/Success1.wav")
#endregion

#Components
@onready var collision_area: CollisionShape2D = $CollisionShape2D
@onready var spawners: Node2D = $Spawners
@onready var spawn_timer: Timer = $SpawnTimer
@onready var battle_audio: AudioStreamPlayer2D = $BattleAudio


# Functions
func _ready() -> void:
	current_state = UNLOCKED
	for i in spawners.get_child_count():
		SPAWNERS[spawners.get_child(i).name] = spawners.get_child(i)
		spawners.get_child(i).init_spawner(player)


func _physics_process(_delta: float) -> void:
	match current_state:
		UNLOCKED:
			pass
		LOCKED:
			if Global.get_enemies() <= 0:
				unlock_room()
				battle_audio.stream = SUCCESS
				battle_audio.play()
				current_state = CLEARED
			else:
				lock_room()
		CLEARED:
			pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if current_state != UNLOCKED:
			return
		current_state = LOCKED
		battle_audio.stream = DOOR_CLOSE
		battle_audio.play()
		enemy_amount = randi_range(min_mobs, max_mobs)
		enemies_alive = enemy_amount
		Global.set_enemies(enemies_alive)
		spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	if current_state != LOCKED:
		return
	
	if enemy_amount > 0:
		var rand_spawner_key = SPAWNERS.keys()[randi() % SPAWNERS.size()]
		var spawner = SPAWNERS[rand_spawner_key]
		spawner.spawn_mob()
		enemy_amount -= 1
	else:
		spawn_timer.stop()


func lock_room():
	for gate in battle_gates:
		gate.close_gate()


func unlock_room():
	for gate in battle_gates:
		gate.open_gate()
