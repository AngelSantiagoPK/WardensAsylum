extends Label

	
func _process(_delta: float) -> void:
	self.text = "SCORE: " + str(AsylumModeManager.high_score)
	
