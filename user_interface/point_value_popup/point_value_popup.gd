extends Node2D

const SPEED: float = 15.0

func _ready() -> void:
	self.rotation_degrees = randf_range(0, 360)

func _physics_process(delta: float) -> void:
	self.rotation_degrees = lerp(self.rotation_degrees, 0.0, 9 * delta)
	self.global_position.y -= SPEED * delta

# Called when the node enters the scene tree for the first time.
func init(score_value: int, spawn_position: Vector2) -> void:
	$Label.text = str(score_value)
	self.global_position = spawn_position
