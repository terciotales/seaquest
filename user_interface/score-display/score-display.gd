extends Label

func _ready():
	GameEvent.connect("update_score", Callable(self, "_on_update_score"))
	_on_update_score()

func _on_update_score():
	text = str(Global.score)
