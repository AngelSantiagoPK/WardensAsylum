extends CharacterBody2D
class_name SlimeBoss

# BASIC ATTRIBUTES
var npc_name: String
@export var health: int
@export var physical_attack: int
@export var physical_defense: int
@export var magical_attack: int
@export var magical_defense: int
@export var poise: int

# MOVEMENT
@export var max_speed = 30.0
@export var damage_to_player = 5
@export var acceleration = 50.0

@export var target: Node2D
var target_position: Vector2

const PICKUP_ITEM_SCENE = preload("res://Objects/Pickup/pickup_item.tscn")
@export var item_to_drop: InventoryItem
@export var loot_stacks: int

@onready var fsm: AIStateMachine = $FSM
@onready var idle: SlimeBossIdleState = $FSM/idle
@onready var wander: SlimeBossWanderState = $FSM/wander
@onready var chase: SlimeBossChaseState = $FSM/chase
@onready var hit: SlimeBossHitState = $FSM/hit
@onready var slam: SlimeBossSlamState = $FSM/slam
@onready var dead: SlimeBossDeadState = $FSM/dead

@onready var context_map: ContextMap = $ContextMap
@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_box: Area2D = $HurtBox

func _ready():
	#init health systems
	health_system.init(health)
	health_system.hit.connect(fsm.change_state.bind(hit))
	health_system.died.connect(fsm.change_state.bind(dead))
	
	# behaviors
	chase.close_to.connect(fsm.change_state.bind(slam))
	slam.slam_finished.connect(fsm.change_state.bind(chase))
	
	# hit and deaths
	dead.death_finished.connect(on_dead)
	
	disable()


func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()


func make_path():
	nav_agent.target_position = target.global_position


func _on_timer_timeout() -> void:
	target_position = target.global_position

func apply_knockback(_body_position: Vector2):
	pass

func on_dead():
	var drop = PICKUP_ITEM_SCENE.instantiate()
	drop.position = position
	queue_free()

func disable():
	self.set_collision_layer_value(6, false)
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	self.visible = false
	%DetectionArea.set_collision_mask_value(1, false)
	%HurtBox.set_collision_layer_value(6, false)
	%HurtBox.set_collision_mask_value(1, false)
	
func enable():
	self.set_collision_layer_value(6, true)
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(2, true)
	self.set_collision_mask_value(3, true)
	%DetectionArea.set_collision_mask_value(1, true)
	%HurtBox.set_collision_layer_value(6, true)
	%HurtBox.set_collision_mask_value(1, true)
	self.visible = true

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(chase)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fsm.change_state(idle)
