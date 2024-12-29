extends CharacterBody2D

class_name SmallSlimeEnemy

#region ATTRIBUTE VARIABLES
@export var enemy_config: EnemyConfig
@export_group("Targeting")
@export var target: Player
# Imports
var spritesheet: SpriteFrames
var collision_shape: CollisionShape2D
var item_to_drop: InventoryItem
var loot_stack: int
# BASIC ATTRIBUTES
var npc_name: String
var health: int
var physical_attack: int
var physical_defense: int
var magical_attack: int
var magical_defense: int
var poise: int
# MOVEMENT ATTRIBUTES
var speed: int
var acceleration: int
var friction: int
@export_group("Knockback")
@export var knockback_force: int = 1000
@export var knockback_time: float = 0.50

var player_in_range: bool = false
var player_in_sight: bool = false

const MNSTR_1: AudioStream  = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr1.wav")
const MNSTR_2: AudioStream  = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr2.wav")
const MNSTR_3: AudioStream  = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr3.wav")
const MNSTR_4 = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr4.wav")
const MNSTR_5 = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr5.wav")
const MNSTR_6 = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr6.wav")
const MNSTR_7 = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr7.wav")
const MNSTR_8 = preload("res://assets/Sounds/Enemy/gutteral beast/mnstr8.wav")
const MONSTER_GURGLES: Array[AudioStream] = [MNSTR_1, MNSTR_2, MNSTR_3, MNSTR_4, MNSTR_5, MNSTR_6, MNSTR_7, MNSTR_8]
#endregion

#region REFERENCES
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_animator: AnimationPlayer = $HitAnimator
@onready var walk_animator: AnimationPlayer = $HitAnimator
@onready var ai_audio: AudioStreamPlayer2D = $AI_Audio

@onready var context_map: ContextMap = $ContextMap
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var target_update: Timer = $TargetUpdate
@onready var target_position = Vector2.ZERO
@onready var detection_system: DetectionSystem = $DetectionSystem

@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: ProgressBar = $HealthBar
@onready var hurt_box: Area2D = $HurtBox

@onready var timer: Timer = $Timer
@onready var knockback_timer: Timer = $KnockbackTimer

#endregion


@onready var state_machine: AIStateMachine = $StateMachine
var STATES = {}

signal dead
signal damaged

func init(_target: Player) -> void:
	self.target = _target

func config(config: EnemyConfig):
	self.spritesheet = config.spritesheet
	self.item_to_drop = config.item_to_drop
	self.loot_stack = config.loot_stacks
	self.npc_name = config.npc_name
	self.health = config.health
	self.physical_attack = config.physical_attack
	self.physical_defense = config.physical_defense
	self.magical_attack = config.magical_attack
	self.magical_defense = config.magical_defense
	self.poise = config.poise
	self.speed = config.speed
	self.acceleration = config.acceleration
	self.friction = config.friction


### FUNCTIONS
func _ready() -> void:
	if enemy_config:
		config(enemy_config)
	
	health_system.init(health)
	health_bar.max_value = health
	health_bar.value = health
	detection_system.init_detection()
	animator.play_idle_animation()

	
	for i in state_machine.get_children():
		STATES[i.name] = i
	
	# states hookup
	detection_system.target_in_sight.connect(state_machine.change_state.bind(STATES.pursue))
	detection_system.target_lost.connect(state_machine.change_state.bind(STATES.wait))
	# When close to player target, do attack
	STATES.pursue.close_to.connect(state_machine.change_state.bind(STATES.attack))
	# when attack attempted, go to pursue player target
	STATES.attack.success.connect(state_machine.change_state.bind(STATES.pursue))
	# when hit, do stagger
	health_system.hit.connect(state_machine.change_state.bind(STATES.stagger))
	#when stagger done, pursue the player target
	STATES.stagger.success.connect(state_machine.change_state.bind(STATES.wait))
	# when dead, do death
	health_system.died.connect(state_machine.change_state.bind(STATES.dead))
	# when done doing death, do more death
	STATES.dead.success.connect(cleanup)


func _physics_process(_delta: float) -> void:
	pass

#region Knockback!
func apply_knockback(player_position: Vector2):
	var knock_direction = -sign(global_position.direction_to(player_position))
	velocity += knock_direction * knockback_force
	knockback_timer.wait_time = knockback_time
	knockback_timer.start()
	move_and_slide()

func _on_knockback_timer_timeout() -> void:
	velocity = Vector2.ZERO
#endregion

#region Death n' Stuff
func enable_collisions():
	set_collision_layer_value(2, true)
	set_collision_layer_value(3, true)
	set_collision_layer_value(6, true)
	hurt_box.set_collision_layer_value(6, true)
	
	
func disable_collisions():
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(6, false)
	hurt_box.set_collision_layer_value(6, false)


func cleanup():
	dead.emit()
	set_physics_process(false)
	queue_free()
#endregion


func _on_target_update_timeout() -> void:
	if !target:
		return

	if target:
		target_position = target.global_position
		self.animator.play_movement_animation(velocity)
