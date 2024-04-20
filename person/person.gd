extends Area2D

const SPEED_PAUSED: float = 5.0
const SPEED_DEFAULT: float = 20.0
const SCORE_VALUE: int = 30

## Scenes
const PointValuePopupScene = preload("res://user_interface/point_value_popup/point_value_popup.tscn")

## Sounds
const SaveSound = preload("res://person/saving_person.ogg")
const DeathSound = preload("res://person/person_death.ogg")

var velocity = Vector2.RIGHT

enum PersonState {
	DEFAULT,
	PAUSED,
}
var state: PersonState = PersonState.DEFAULT

func _ready() -> void:
	GameEvent.connect("pause_enemies", _on_pause_enemies)

func _process(_delta: float) -> void:
	if global_position.x <= Global.SCREEN_BOUND_MIN_X or global_position.x >= Global.SCREEN_BOUND_MAX_X:
		queue_free()

func _physics_process(delta: float) -> void:
	match(state):
		PersonState.DEFAULT:
			move_person(SPEED_DEFAULT, delta)
		PersonState.PAUSED:
			move_person(SPEED_PAUSED, delta)

func move_person(speed: float, delta: float) -> void:
	global_position += velocity * speed * delta

func init(pos: Vector2, face_right: bool) -> void:
	global_position = pos
	if face_right:
		velocity = Vector2.RIGHT
	else:
		velocity = Vector2.LEFT
		$AnimatedSprite2D.flip_h = true

func _on_area_entered(area):
	if area.is_in_group("Player") and Global.saved_people_count <= Global.FULL_CREW_COUNT:
		Global.saved_people_count += 1
		GameEvent.emit_signal("update_saved_people_count")
		Global.score += SCORE_VALUE
		GameEvent.emit_signal("update_score")
		SoundManager.play_sound(SaveSound)
		create_point_value_popup()
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		SoundManager.play_sound(DeathSound)
		area.queue_free()
		queue_free()

func create_point_value_popup() -> void:
	var point_value_popup_instance = PointValuePopupScene.instantiate()
	point_value_popup_instance.init(SCORE_VALUE, self.global_position)
	get_tree().current_scene.add_child(point_value_popup_instance)

func _on_pause_enemies(pause: bool) -> void:
	if pause:
		state = PersonState.PAUSED
	else:
		state = PersonState.DEFAULT
