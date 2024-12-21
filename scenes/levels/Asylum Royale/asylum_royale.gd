extends Node2D

@onready var player: Player = $Player
@onready var enemy_spawn_points: Node = $EnemySpawnPoints
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var round_timer: Timer = $RoundTimer
@onready var round_banner: CanvasLayer = $RoundBanner
@onready var level_music: AudioStreamPlayer2D = $LevelMusic


var enemy_markers = {}

var knight_counter = 0
var skeleton_counter = 0

const SKELETON_MOB_SCENE = preload("res://Actors/enemy/enemy.tscn")
const skeleton_config = preload("res://Actors/enemy/skeleton.tres")


func _ready() -> void:
	AsylumModeManager.round_start.connect(on_start)
	AsylumModeManager.victory.connect(on_victory)
	player.player_died.connect(on_dead)
	setup_player_inventory()
	player.global_position = AsylumModeManager.player_spawn_point
	
	for i in enemy_spawn_points.get_child_count():
		enemy_markers[enemy_spawn_points.get_child(i).name] = enemy_spawn_points.get_child(i)

	
	AsylumModeManager.start_round()

func _physics_process(_delta: float) -> void:
	if player:
		AsylumModeManager.player_spawn_point = player.global_position


func spawn_mob():
	var mob = SKELETON_MOB_SCENE.instantiate()
	var num = randi_range(0, enemy_markers.size() - 1)
	var enemy_marker = enemy_markers[enemy_spawn_points.get_child(num).name]
	
	mob.global_position = enemy_marker.global_position
	mob.init(player)
	mob.config(skeleton_config)
	get_tree().root.add_child(mob)


func _on_timer_timeout() -> void:
	if skeleton_counter > 0:
		spawn_mob()
		skeleton_counter -= 1


func on_start():
	skeleton_counter = AsylumModeManager.skeletons_to_spawn
	level_music.play_start()
	await level_music.finished
	enemy_spawn_timer.start()
	level_music.play_round()
	round_banner.show_banner("start")


func on_victory():
	enemy_spawn_timer.stop()
	level_music.play_victory()
	await level_music.finished
	await round_banner.show_banner("victory")
	get_tree().reload_current_scene()


func on_dead():
	AsylumModeManager.player_is_alive = false
	level_music.play_defeat()
	await round_banner.show_banner("defeat")
	AsylumModeManager.high_score = AsylumModeManager.player_score
	TransitionChangeManager.change_scene("res://resources/UI/game_over/game_over.tscn")
	AsylumModeManager.game_reset()


func setup_player_inventory():
	const SWORD_INVENTORY_ITEM = preload("res://Objects/Weapons/sword/sword_inventory_item.tres")
	const SCROLL_INVENTORY_ITEM = preload("res://Objects/Weapons/scroll/scroll_inventory_item.tres")
	const SHIELD_INVENTORY_ITEM = preload("res://Objects/Weapons/shield/shield_inventory_item.tres")
	
	player.inventory.add_item(SWORD_INVENTORY_ITEM, 1)
	player.inventory.add_item(SCROLL_INVENTORY_ITEM, 1)
	player.inventory.add_item(SHIELD_INVENTORY_ITEM, 1)
	
	player.inventory.on_item_equipped(0, "Right_Hand")
	player.inventory.on_item_equipped(2, "Left_Hand")
	player.jutsu_system.on_jutsu_activated(0)
