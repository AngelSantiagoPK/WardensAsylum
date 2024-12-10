extends CharacterBody2D
class_name SlimeBoss

@export var max_health = 100
@export var max_speed = 40.0
@export var damage_to_player = 5
@export var acceleration = 50.0
@export var target: Node2D
const PICKUP_ITEM_SCENE = preload("res://scenes/pickup_item.tscn")
@export var item_to_drop: InventoryItem
@export var loot_stacks: int

@onready var fsm: FiniteStateMachine = $FSM
@onready var idle: SlimeBossIdleState = $FSM/idle
@onready var wander: SlimeBossWanderState = $FSM/wander
@onready var chase: SlimeBossChaseState = $FSM/chase
@onready var hit: SlimeBossHitState = $FSM/hit
@onready var slam: SlimeBossSlamState = $FSM/slam
@onready var dead: SlimeBossDeadState = $FSM/dead

@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_box: Area2D = $HurtBox

func _ready():
	#init health systems
	health_system.init(max_health)
	health_system.hit.connect(fsm.change_state.bind(hit))
	health_system.died.connect(fsm.change_state.bind(dead))
	
	# behaviors
	chase.close_to.connect(fsm.change_state.bind(slam))
	slam.slam_finished.connect(fsm.change_state.bind(chase))
	
	# hit and deaths
	hit.hit_finished.connect(fsm.change_state.bind(slam))   
	dead.death_finished.connect(on_dead)



func on_dead():
	queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(chase)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(idle)
