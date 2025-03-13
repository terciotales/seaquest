extends Camera2D

@export var follow_speed: float = 9
@export var min_camera_y_position: float = 70
@export var max_camera_y_position: float = 145

var target_y_position = global_position.y

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvent.connect("camera_follow_player", Callable(self, "_on_camera_follow_player"))

func _physics_process(delta: float) -> void:
	global_position.y = lerpf(global_position.y, target_y_position, follow_speed * delta)

func _on_camera_follow_player(y_position: float) -> void:
	target_y_position = clamp(y_position, min_camera_y_position, max_camera_y_position)
