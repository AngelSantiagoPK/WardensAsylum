class_name TheAsylumLevel
extends Node2D

# Variables
@export var player: Player
@export var switches: Array[LevelSwitch]
@export var boss: CharacterBody2D
@onready var western_cell_gates: TileMapLayer = $CellGates/WesternCellGates
@onready var eastern_cell_gates: TileMapLayer = $CellGates/EasternCellGates
@onready var boss_area: TileMapLayer = $Map/BossAreaLayer
@onready var level_portal: LevelPortal = $Objects/LevelPortal
@onready var sfx_audio: AudioStreamPlayer2D = $SFXAudio
const SFX = preload("res://assets/Sounds/Game/Secret1.wav")
# Components

# Functions
func _ready() -> void:
	boss.boss_died.connect(on_boss_died.bind())
	player.player_died.connect(on_player_died.bind())
	level_portal.player_activated_portal.connect(on_player_activated_portal.bind())
	
	for i in switches:
		i.switch_touched.connect(on_switch_touched)

func on_switch_touched():
	if switches[0].is_touched():
		western_cell_gates.collision_enabled = false
		western_cell_gates.visible = false
	
	if switches[1].is_touched():
		eastern_cell_gates.collision_enabled = false
		eastern_cell_gates.visible = false
	
	if switches[0].is_touched() and switches[1].is_touched():
		boss_area.collision_enabled = true
		boss_area.visible = true
		sfx_audio.stream = SFX
		sfx_audio.play()
		boss.enable()
		level_portal.reveal()

func on_boss_died():
	level_portal.activate()

func on_player_died():
	TransitionChangeManager.change_scene("res://UI/Game Over Screen/game_over.tscn")

func on_player_activated_portal():
	TransitionChangeManager.change_scene("res://UI/Ending Screen/ending_screen.tscn")
