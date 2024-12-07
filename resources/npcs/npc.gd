class_name NPC
extends CharacterBody2D 

@export var max_health = 0
@export var max_speed = 40.0
@export var acceleration = 50.0
@export var target: Node2D

@onready var fsm: FiniteStateMachine = $FSM
@onready var idle: NPCIdleState = $FSM/idle
@onready var wander: NPCWanderState = $FSM/wander
@onready var chase: NPCChaseState = $FSM/chase
@onready var close_to: Node = $FSM/close_to
@onready var dead: DeadState = $FSM/dead
@onready var hit: HitState = $FSM/hit
@onready var health_system: HealthSystem = $HealthSystem


func _ready():
	#init health systems
	health_system.init(max_health)
	health_system.died.connect(fsm.change_state.bind(dead))
	health_system.damage_taken.connect(fsm.change_state.bind(hit))
	hit.hit_finished.connect(fsm.change_state.bind(idle))
	dead.death_complete.connect(on_death_complete.bind())
	
	idle.idle_finished.connect(fsm.change_state.bind(wander))
	chase.close_to.connect(fsm.change_state.bind(close_to))
	chase.lost_target.connect(fsm.change_state.bind(wander))
	close_to.left_close_range.connect(fsm.change_state.bind(chase))
	


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(chase)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(wander)


func on_death_complete():
	#TODO: Item drop
	queue_free()
