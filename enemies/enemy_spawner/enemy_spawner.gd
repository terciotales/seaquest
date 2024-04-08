extends Marker2D

const Shark = preload("res://enemies/shark/shark.tscn")

func _on_timer_timeout():
	var shark_instance = Shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	shark_instance.global_position = global_position
	
