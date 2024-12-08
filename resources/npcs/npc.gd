class_name NPC
extends CharacterBody2D 

@export var max_health = 0
@export var max_speed = 40.0
@export var damage_to_player = 5
@export var acceleration = 50.0
@export var target: Node2D
const PICKUP_ITEM_SCENE = preload("res://scenes/pickup_item.tscn")
@export var item_to_drop: InventoryItem
@export var loot_stacks: int


@onready var fsm: FiniteStateMachine = $FSM
@onready var idle: NPCIdleState = $FSM/idle
@onready var wander: NPCWanderState = $FSM/wander
@onready var chase: NPCChaseState = $FSM/chase
@onready var close_to: Node = $FSM/close_to
@onready var dead: DeadState = $FSM/dead
@onready var hit: HitState = $FSM/hit
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_box: Area2D = $HurtBox

func _ready():
	#init health systems
	health_system.init(max_health)
	health_system.died.connect(fsm.change_state.bind(dead))
	health_system.hit.connect(fsm.change_state.bind(hit))
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
	if item_to_drop == null:
		queue_free()
		return
		
	var loot_drop = PICKUP_ITEM_SCENE.instantiate()
	loot_drop.inventory_item = item_to_drop
	loot_drop.stacks = loot_stacks
		
	get_tree().root.add_child(loot_drop)
	loot_drop.global_position = position
	Global.score += 50
	queue_free()
