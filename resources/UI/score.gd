extends Label


func _process(delta: float) -> void:
	self.text = "SCORE: " + str(Global.get_score())
