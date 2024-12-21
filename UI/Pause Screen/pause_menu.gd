extends CanvasLayer

class_name PauseMenu



# REFERENCES
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton

func _ready() -> void:
	continue_button.grab_focus()
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var current_value: bool = get_tree().paused
		get_tree().paused = !current_value
		self.visible = !current_value

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()
