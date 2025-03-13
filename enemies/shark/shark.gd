extends Area2D

const SPEED_PAUSED = 10.0
const SPEED_DEFAULT = 50.0
const MOVEMENT_FREQUENCY = 0.125
const MOVEMENT_AMPLITUDE = 0.5

## Sounds
const DeathSound = preload("res://enemies/shark/shark_death.ogg")

## Scenes
const ObjectPieceScene = preload("res://particles/object_piece/object_piece.tscn")
const PointValuePopupScene = preload("res://user_interface/point_value_popup/point_value_popup.tscn")

## Textures
const SharkPieceTexture = preload("res://enemies/shark/shark_pieces.png")
const SHARK_PIECES_COUNT = 2

var velocity = Vector2.RIGHT

@export var score_value: int = 25

enum SharkState {
	DEFAULT,
	PAUSED,
}
var state: SharkState = SharkState.DEFAULT

func _ready() -> void:
	GameEvent.connect("pause_enemies", on_pause_enemies)
	GameEvent.kill_all_enemies.connect(on_kill_all_enemies)

func init(pos: Vector2, face_right: bool) -> void:
	global_position = pos
	if face_right:
		velocity = Vector2.RIGHT
	else:
		velocity = Vector2.LEFT
		$AnimatedSprite2D.flip_h = true

func _process(_delta: float) -> void:
	if global_position.x <= Global.SCREEN_BOUND_MIN_X or global_position.x >= Global.SCREEN_BOUND_MAX_X:
		queue_free()

func _physics_process(delta: float) -> void:
	match(state):
		SharkState.DEFAULT:
			move_shark(SPEED_DEFAULT, delta)
		SharkState.PAUSED:
			move_shark(SPEED_PAUSED, delta)

func move_shark(speed: float, delta: float) -> void:
	velocity.y = sin(global_position.x * MOVEMENT_FREQUENCY) * MOVEMENT_AMPLITUDE
	global_position += velocity * speed * delta

func _on_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		area.queue_free()
		kill_shark()
	elif area.is_in_group("Player"):
		GameEvent.emit_signal("game_over")

func kill_shark():
	Global.score += score_value
	GameEvent.emit_signal("update_score")

	SoundManager.play_sound(DeathSound)
	queue_free()

	create_object_pieces()
	create_point_value_popup()

func create_object_pieces() -> void:
	for i in SHARK_PIECES_COUNT:
		var object_piece_instance = ObjectPieceScene.instantiate()
		object_piece_instance.init(SharkPieceTexture, SHARK_PIECES_COUNT, i, self.global_position)
		get_tree().current_scene.add_child(object_piece_instance)

func create_point_value_popup() -> void:
	var point_value_popup_instance = PointValuePopupScene.instantiate()
	point_value_popup_instance.init(score_value, self.global_position)
	get_tree().current_scene.add_child(point_value_popup_instance)

func on_pause_enemies(pause: bool) -> void:
	if pause:
		state = SharkState.PAUSED
	else:
		state = SharkState.DEFAULT

func on_kill_all_enemies():
	kill_shark()
