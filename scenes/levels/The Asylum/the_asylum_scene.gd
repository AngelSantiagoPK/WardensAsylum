class_name TheAsylumLevel
extends Node2D

# Variables
@export var player: Player
@export var switches: Array[LevelSwitch]
@export var boss: CharacterBody2D
@onready var western_cell_gates: TileMapLayer = $CellGates/WesternCellGates
@onready var eastern_cell_gates: TileMapLayer = $CellGates/EasternCellGates
@onready var boss_area: TileMapLayer = $Map/BossAreaLayer
@onready var sfx_audio: AudioStreamPlayer2D = $SFXAudio
const SFX = preload("res://assets/Sounds/Game/Secret1.wav")
# Components

# Functions
func _ready() -> void:
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
