extends CanvasLayer

class_name TransitionManager

# SIGNALS
signal transition_done

# VARIABLES
@export var fade_in_time = 0.5
@export var fade_out_time = 0.5
@export var transition_time = 1.0

@onready var color_rect: ColorRect = $ColorRect

var next_scene_path: String = "res://scenes/shop_scene.tscn"
var is_transitioning = false
var player_spawn_position = null

# FUNCTIONS
func _ready():
	color_rect.modulate.a = 0
	#end


func fade_out():
	is_transitioning = true
	color_rect.modulate.a = 0
	color_rect.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 1, fade_out_time)
	tween.finished.connect(on_fade_out_completed)
	
	#end


func on_fade_out_completed():
	get_tree().change_scene_to_file(next_scene_path)
	fade_in()
	#end


func fade_in():
	color_rect.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 0, fade_in_time)
	
	tween.finished.connect(on_fade_in_finished)
	
	#end


func on_fade_in_finished():
	is_transitioning = false
	transition_done.emit()
	#end


func change_scene(scene_path: String):
	if is_transitioning:
		return
	
	self.next_scene_path = scene_path
	fade_out()
	#end
