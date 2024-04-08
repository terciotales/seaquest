extends Area2D

var velocity = Vector2(1, 0)

var SPEED = 300

@onready var sprite = $AnimatedSprite2D

func _ready():
	rotation_degrees = randf_range(-7, 7)
	velocity = velocity.rotated(rotation)

func _process(delta):
	global_position += velocity * SPEED * delta

func flip_direction():
	velocity = -velocity
	sprite.flip_h = !sprite.flip_h
	
func _on_screen_exited():
	queue_free()
