extends Marker2D

class_name Spawner

# Variables
const ENEMY_SCENE = preload("res://Actors/enemy/enemy.tscn")
@export var enemy_config: Resource = preload("res://Actors/enemy/skeleton.tres")
@export var target: Player
@export var automatic_spawn_timer: float = 10.0

#region SOUNDS
const SHADE_1: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade1.wav")
const SHADE_2: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade2.wav")
const SHADE_3: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade3.wav")
const SHADE_4: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade4.wav")
const SHADE_5: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade5.wav")
const SHADE_6: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade6.wav")
const SHADE_7: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade7.wav")
const SHADE_8: AudioStream = preload("res://assets/Sounds/Enemy/shade/shade8.wav")
#endregion

const SPAWN_SOUNDS: Array[AudioStream] = [SHADE_1, SHADE_2, SHADE_3, SHADE_4, SHADE_5, SHADE_6, SHADE_7, SHADE_8]

# Components
@onready var spawner_sprite: AnimatedSprite2D = $SpawnerSprite
@onready var spawner_audio: AudioStreamPlayer2D = $SpawnerAudio
@onready var spawn_timer: Timer = $SpawnTimer

# Functions
func init_spawner(player: Player):
	self.target = player
	
func spawn_mob():
	var rand = randi_range(0, SPAWN_SOUNDS.size() - 1)
	spawner_sprite.show()
	spawner_sprite.play('spawn')
	spawner_audio.stream = SPAWN_SOUNDS[rand]
	spawner_audio.play()
	await spawner_sprite.animation_finished
	
	var mob = ENEMY_SCENE.instantiate()
	mob.init(target)
	mob.config(enemy_config)
	get_tree().root.add_child(mob)
	mob.disable_collisions()
	mob.position = self.position
	mob.enable_collisions()
	spawner_sprite.hide()

func _on_spawn_timer_timeout() -> void:
	spawn_mob()
