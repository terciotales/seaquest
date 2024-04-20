extends Area2D

var velocity = Vector2.RIGHT

@export var bullet_speed = 300
@export var max_random_shooting_angle: float = 3.0

@onready var animated_sprite_2d = $AnimatedSprite2D

# This is ran after the instantiated scene is added to the tree
func _ready():
	rotation_degrees = randf_range(-max_random_shooting_angle, max_random_shooting_angle)

func init(pos: Vector2, offset: float, face_left: bool) -> void:
	var facing_scalar = -1 if (face_left) else 1

	global_position = pos
	global_position.x += offset * facing_scalar

	velocity.x = facing_scalar
	velocity.y *= facing_scalar
	velocity = velocity.rotated(rotation)

	animated_sprite_2d.flip_h = face_left

func _physics_process(delta):
	global_position += velocity * bullet_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
