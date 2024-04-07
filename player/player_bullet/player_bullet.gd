extends AnimatedSprite2D

var velocity = Vector2(1, 0)

var SPEED = 300

func _process(delta):
	global_position += velocity * SPEED * delta
	
