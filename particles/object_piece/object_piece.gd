extends Sprite2D

@export var max_rotation_speed: float = 10.0

var move_speed: float = 100.0
var direction = Vector2.RIGHT
var rotation_speed: float

func _ready() -> void:
	var rand_rotation = randf_range(0, TAU)
	direction = direction.rotated(rand_rotation)
	rotation_speed = randf_range(-max_rotation_speed, max_rotation_speed)

func _process(delta: float) -> void:
	self.global_position += direction * move_speed * delta
	self.rotation_degrees += rotation_speed
	move_speed = lerp(move_speed, 0.0, 6 * delta)

func init(_texture: Texture, _hframes: int, _frame: int, _position: Vector2) -> void:
	self.texture = _texture
	self.hframes = _hframes
	self.frame = _frame
	self.global_position = _position
