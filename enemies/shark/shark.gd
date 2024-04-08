extends Area2D

const SPEED = 50
const MOVEMENT_FREQUENCY = 0.15
const MOVEMENTE_AMPLITUDE = 0.5

var velocity = Vector2(1, 0)

func _physics_process(delta):
	velocity.y = sin(global_position.x * MOVEMENT_FREQUENCY) * MOVEMENTE_AMPLITUDE
	global_position += velocity * SPEED * delta

func _on_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		area.queue_free()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass # Replace with function body.


func _on_screen_exited():
	queue_free()
