extends Area2D

## Sounds
const PlayerSurfaceSound = preload("res://player/player_surface.ogg")

func _on_area_entered(area):
	if area.is_in_group("Player"):
		SoundManager.play_sound(PlayerSurfaceSound)
		if Global.saved_people_count >= Global.FULL_CREW_COUNT:
			GameEvent.emit_signal("full_crew_oxygen_refuel")
		else:
			GameEvent.emit_signal("partial_crew_oxygen_refuel")


func _on_flash_timer_timeout():
	pass # Replace with function body.
