class_name NPC
extends CharacterBody2D 

# VARIABLES	
@export_group("Stats")
@export var max_health = 0
@export var max_speed = 40.0
@export var damage_to_player = 5
@export var acceleration = 50.0
@export_group("")

@export var target: Node2D

@export_group("Loot Options")
const PICKUP_ITEM_SCENE = preload("res://scenes/pickup_item.tscn")
@export var item_to_drop: InventoryItem
@export var loot_stacks: int
@export_group("")


# STATES
@onready var fsm: FiniteStateMachine = $FSM
@onready var wander: NPCWanderState = $FSM/wander
@onready var chase: NPCChaseState = $FSM/chase
@onready var hit: HitState = $FSM/hit
@onready var dead: DeadState = $FSM/dead


# REFERENCES
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_box: Area2D = $HurtBox

func _ready():
	#init health systems
	health_system.init(max_health)
	health_system.died.connect(fsm.change_state.bind(dead))
	health_system.hit.connect(fsm.change_state.bind(hit))
	hit.hit_finished.connect(fsm.change_state.bind(chase))
	dead.death_complete.connect(erase_instance)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(chase)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state.bind(wander)
		pass


func erase_instance():
	queue_free()
