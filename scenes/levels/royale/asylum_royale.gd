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

const SKELETON_MOB_SCENE = preload("res://resources/enemies/genius/genius.tscn")
const GOLD_KNIGHT_MOB_SCENE = preload("res://resources/enemies/golden_knight/golden_knight.tscn")


func _ready() -> void:
	AsylumModeManager.round_start.connect(on_start)
	AsylumModeManager.victory.connect(on_victory)
	player.player_died.connect(on_dead)
	setup_player_inventory()
	player.global_position = AsylumModeManager.player_spawn_point
	
	for i in enemy_spawn_points.get_child_count():
		enemy_markers[enemy_spawn_points.get_child(i).name] = enemy_spawn_points.get_child(i)

	
	AsylumModeManager.start_round()

func _physics_process(delta: float) -> void:
	if player:
		AsylumModeManager.player_spawn_point = player.global_position


func spawn_mob():
	var mob = SKELETON_MOB_SCENE.instantiate()
	var num = randi_range(0, enemy_markers.size() - 1)
	var enemy_marker = enemy_markers[enemy_spawn_points.get_child(num).name]
	
	mob.global_position = enemy_marker.global_position
	mob.init(player)
	get_tree().root.add_child(mob)


func spawn_knight():
	var mob = GOLD_KNIGHT_MOB_SCENE.instantiate()
	var num = randi_range(0, enemy_markers.size() - 1)
	var enemy_marker = enemy_markers[enemy_spawn_points.get_child(num).name]
	
	mob.global_position = enemy_marker.global_position
	mob.init(player)
	get_tree().root.add_child(mob)


func _on_timer_timeout() -> void:
	if knight_counter > 0:
		spawn_knight()
		knight_counter -= 1
	elif skeleton_counter > 0:
		spawn_mob()
		skeleton_counter -= 1


func on_start():
	knight_counter = AsylumModeManager.gold_knights_to_spawn
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
	AsylumModeManager.game_reset()
	TransitionChangeManager.change_scene("res://resources/UI/game_over/game_over.tscn")



func setup_player_inventory():
	const SWORD_INVENTORY_ITEM = preload("res://resources/weapons/sword/sword_inventory_item.tres")
	const SCROLL_INVENTORY_ITEM = preload("res://resources/weapons/scroll/scroll_inventory_item.tres")
	const SHIELD_INVENTORY_ITEM = preload("res://resources/weapons/shield/shield_inventory_item.tres")
	
	player.inventory.add_item(SWORD_INVENTORY_ITEM, 1)
	player.inventory.add_item(SCROLL_INVENTORY_ITEM, 1)
	player.inventory.add_item(SHIELD_INVENTORY_ITEM, 1)
	
	player.inventory.on_item_equipped(0, "Right_Hand")
	player.inventory.on_item_equipped(2, "Left_Hand")
	player.jutsu_system.on_jutsu_activated(0)
