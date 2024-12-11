extends Sprite2D


var EMOTES = {
	"wait": preload("res://assets/Ui/Emote/emote18.png"),
	"pursue": preload("res://assets/Ui/Emote/emote24.png"),
	"attack": preload("res://assets/Ui/Emote/emote22.png"),
	"evade": preload("res://assets/Ui/Emote/emote15.png"),
}

func change_emote(str: String):
	match str:
		"wait":
			self.texture = EMOTES["wait"]
			pass
		"pursue":
			self.texture = EMOTES["pursue"]
			pass
		"attack":
			self.texture = EMOTES["attack"]
			pass
		"evade":
			self.texture = EMOTES["evade"]
			pass
