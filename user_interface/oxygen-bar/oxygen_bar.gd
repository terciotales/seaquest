extends Node2D

const RESTORE_SPEED = 6.0
const SCALE_INIT = Vector2(1, 1)
const ROTATION_INIT = 0.0

## Sounds
const OxygenAlertSound = preload("res://user_interface/oxygen-bar/oxygen_alert.ogg")

var previous_oxygen_level: float = 100.0
# var previous_oxygen_level_rounded: int = -1

func _process(_delta: float) -> void:
	var current_oxygen_level = Global.oxygen_level
	$TextureProgressBar.value = current_oxygen_level

	if current_oxygen_level > previous_oxygen_level:
		## The player is recharging, don't alert
		return

	var current_oxygen_level_rounded: int = round(Global.oxygen_level)
	var previous_oxygen_level_rounded: int = round(previous_oxygen_level)
	if current_oxygen_level_rounded != previous_oxygen_level_rounded:
		match current_oxygen_level_rounded:
			25:
				alert(1.25, 5.0)
			15:
				alert(1.30, 7.0)
			10:
				alert(1.35, 10.0)
			10:
				alert(1.40, 15.0)
			5:
				alert(1.50, 20.0)
			2:
				alert(1.60, 20.0)
			1:
				alert(1.80, 35.0)
		previous_oxygen_level = current_oxygen_level

func alert(scale_value: float, max_rotation_value: float) -> void:
	SoundManager.play_sound(OxygenAlertSound)
	self.scale = Vector2(scale_value, scale_value)
	self.rotation_degrees = randf_range(-max_rotation_value, max_rotation_value)
	self.modulate = Color(50, 50, 50)
	$FlashTimer.start()

func _physics_process(delta: float) -> void:
	self.scale = lerp(self.scale, SCALE_INIT, RESTORE_SPEED * delta)
	self.rotation_degrees = lerpf(self.rotation_degrees, ROTATION_INIT, RESTORE_SPEED * delta)


func _on_flash_timer_timeout():
	self.modulate = Color(1, 1, 1)
