extends Area2D

var velocity = Vector2(1, 0)

const SPEED = 25

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	global_position += velocity * SPEED * delta
	
func flip_direction():
	velocity = -velocity
	sprite.flip_h = !	sprite.flip_h

func _on_area_entered(area):
	if area.is_in_group("Player"):
		Global.saved_people_count += 1
		GameEvent.emit_signal("update_collected_people_count")
		queue_free()
