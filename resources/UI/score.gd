extends Label

	
func _process(delta: float) -> void:
	self.text = "SCORE: " + str(AsylumModeManager.high_score)
	
