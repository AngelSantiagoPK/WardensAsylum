extends Node

class_name JutsuSystem

var jutsu_configs: Array[JutsuConfig] = [
	preload("res://resources/jutsus/fireball/fireball_jutsu_config.tres"),
	preload("res://resources/jutsus/kunai/kunai_jutsu_config.tres"),
	preload("res://resources/jutsus/heal/heal_jutsu_config.tres")
]

@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"
const JUTSU_SCENE = preload("res://resources/jutsus/jutsu.tscn")
@onready var inventory_toggler: Inventory = $"../InventoryToggler"
@onready var on_screen_ui: OnScreenUI = $"../OnScreenUi"
@onready var combat_system: CombatSystem = $"../CombatSystem"


var current_jutsu_cooldown = 0
var cooldown_timer = 999
var active_jutsu_index = -1

func _ready() -> void:
	inventory_toggler.jutsu_activated.connect(on_jutsu_activated)
	combat_system.cast_active_jutsu.connect(on_cast_active_jutsu)
	
	
	
func _process(delta: float) -> void:
	if current_jutsu_cooldown != null && cooldown_timer < current_jutsu_cooldown:
		cooldown_timer += delta
	return
	
	

func on_jutsu_activated(index: int):
	active_jutsu_index = index
	var jutsu_config = jutsu_configs[index]
	on_screen_ui.toggle_jutsu_slot(true, jutsu_config.ui_texture)
	current_jutsu_cooldown = jutsu_config.initial_cooldown
		
		
func on_cast_active_jutsu():
	var jutsu_direction = animated_sprite_2d.attack_vector
	var jutsu_config = jutsu_configs[active_jutsu_index]
	
	if cooldown_timer != 0 and cooldown_timer < current_jutsu_cooldown:
		return
	else:	
		cooldown_timer = 0
	
	var jutsu_rotation = get_jutsu_rotation(jutsu_direction, jutsu_config.initial_rotation)
	var jutsu : Jutsu = JUTSU_SCENE.instantiate()
	
	get_tree().root.add_child(jutsu)
	jutsu.init(jutsu_config)
	jutsu.position = get_parent().global_position
	if jutsu_config.target_self == false:
		jutsu.rotation_degrees = jutsu_rotation
		jutsu.direction = jutsu_direction
	
	
	on_screen_ui.jutsu_cooldown_activated(current_jutsu_cooldown)
	
	
	
func get_jutsu_rotation(jutsu_direction: Vector2, initial_rotation: int):
	match jutsu_direction:
		Vector2.LEFT:
			return -180 + initial_rotation
		Vector2.RIGHT:
			return 0 + initial_rotation
		Vector2.UP:
			return -90 + initial_rotation
		Vector2.DOWN:
			return 90 + initial_rotation
					
			
			
			
			