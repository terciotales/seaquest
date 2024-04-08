extends AnimatedSprite2D

var velocity = Vector2(1, 0)

var SPEED = 300

func _ready():
	rotation_degrees = randf_range(-7, 7)
	velocity = velocity.rotated(rotation)

func _process(delta):
	global_position += velocity * SPEED * delta

func flip_direction():
	velocity = -velocity
	flip_h = !flip_h
	
func _screen_exited():
	queue_free()
