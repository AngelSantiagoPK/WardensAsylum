extends CanvasLayer

class_name PauseMenu

@onready var pause_menu: CanvasLayer = %PauseMenu
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton
var paused = false

func _ready() -> void:
	continue_button.grab_focus()
	if paused == false:
		hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and paused == false:
		pause()
	
	if event.is_action_pressed("pause") and paused == true:
		hide()
		get_tree().paused = false


func pause():
	paused = true
	get_tree().paused = true
	show()

func _on_continue_button_pressed() -> void:
	paused = false
	hide()
	get_tree().paused = false
