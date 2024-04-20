extends AudioStreamPlayer

func _ready() -> void:
	self.connect("finished", _on_finished)

func _on_finished() -> void:
	queue_free()
