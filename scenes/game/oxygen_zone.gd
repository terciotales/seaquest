extends Area2D

func _on_area_entered(area):
	if area.is_in_group("Player"):
		if Global.saved_people_count >= 7:
			GameEvent.emit_signal("full_crew_oxygen_refuel")
		else:
			GameEvent.emit_signal("less_people_oxygen_refuel")
