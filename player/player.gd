extends Area2D

## Scenes
const PlayerBullet = preload("res://player/player_bullet/player_bullet.tscn")
const ObjectPieceScene = preload("res://particles/object_piece/object_piece.tscn")

## Sounds
const ShootSound = preload("res://player/player_bullet/player_shoot.ogg")
const DeathSound = preload("res://person/person_death.ogg")
const FullOxygenSound = preload("res://user_interface/oxygen-bar/full_oxygen_alert.ogg")

## Textures
const PlayerPiecesTexture = preload("res://player/player_pieces.png")
const PLAYER_PIECES_COUNT = 10

const SPEED = Vector2(125, 90)
const BULLET_OFFSET: float = 7.0

@export var oxygen_drain_speed: float = -2.5
@export var oxygen_replenish_speed: float = 60.0
@export var shoreline_speed: float = 40.0

@export var rotation_strength := 15.0
@export var rotation_speed := 15.0

const SHORELINE_Y_POSITION: float = 38

const MAX_X_POSITION: float = 248
const MIN_X_POSITION: float = 13
const MIN_Y_POSITION: float = SHORELINE_Y_POSITION
const MAX_Y_POSITION: float = 205

const MAX_REFUELING_OXYGEN_LEVEL: float = 80.0

var velocity = Vector2(0, 0)
var can_shoot := true
var is_shooting := false

enum PlayerState {
	DEFAULT,
	UNLOAD_PEOPLE,
	OXYGEN_REFUEL,
}
var state: PlayerState = PlayerState.DEFAULT

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var reload_timer = $ReloadTimer
@onready var unload_people_timer = $UnloadPeopleTimer

func _ready() -> void:
	GameEvent.connect("full_crew_oxygen_refuel", Callable(self, "_on_full_crew_oxygen_refuel"))
	GameEvent.connect("partial_crew_oxygen_refuel", Callable(self, "_on_partial_crew_oxygen_refuel"))
	GameEvent.connect("game_over", Callable(self, "_on_game_over"))

func _process(delta: float) -> void:
	match (state):
		PlayerState.DEFAULT:
			process_movement_input()
			# direction follows input, unless the player is shooting
			if !is_shooting and (velocity.x != 0):
				animated_sprite_2d.flip_h = (velocity.x < 0)

			process_shooting()
			lose_oxygen(delta)

			# death when oxygen reaches zero
			if Global.oxygen_level <= 0:
				GameEvent.emit_signal("game_over")

		PlayerState.OXYGEN_REFUEL:
			move_to_shore_line(delta)
			refuel_oxygen(delta)

		PlayerState.UNLOAD_PEOPLE:
			move_to_shore_line(delta)

func _physics_process(delta: float) -> void:
	var y_pos_before = global_position.y
	if state == PlayerState.DEFAULT:
		move_position(delta)
		rotate_follows_movement(delta)
	clamp_position()
	var y_pos_after = global_position.y
	if y_pos_after != y_pos_before:
		GameEvent.emit_signal("camera_follow_player", global_position.y)

###
### Utilities
###
func update_oxygen(speed: float, delta: float) -> void:
	Global.oxygen_level += speed * delta
	Global.oxygen_level = clamp(Global.oxygen_level, 0.0, 100.0)

func clamp_position():
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION, MAX_Y_POSITION)

func death_when_refueling_while_full():
	if Global.oxygen_level > MAX_REFUELING_OXYGEN_LEVEL:
		GameEvent.emit_signal("game_over")

###
### PlayerState.DEFAULT
###

func process_movement_input() -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()

func process_shooting() -> void:
	is_shooting = Input.is_action_pressed("shoot")
	if is_shooting and can_shoot:
		var bullet_instance = PlayerBullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.init(global_position, BULLET_OFFSET, animated_sprite_2d.flip_h)

		SoundManager.play_sound(ShootSound)

		# Handle reload
		reload_timer.start()
		can_shoot = false

func lose_oxygen(delta: float) -> void:
	update_oxygen(oxygen_drain_speed, delta)

func move_position(delta: float) -> void:
	global_position += velocity * SPEED * delta

func rotate_follows_movement(delta: float) -> void:
	var target_rotation:= 0.0
	if velocity.y == 0.0:
		target_rotation = velocity.x * rotation_strength
	else:
		target_rotation = velocity.y * rotation_strength
		target_rotation *= -1 if animated_sprite_2d.flip_h else 1
	rotation_degrees = lerp(rotation_degrees, target_rotation, rotation_speed * delta)
###
### PlayerState.OXYGEN_REFUEL
###

func refuel_oxygen(delta: float) -> void:
	update_oxygen(oxygen_replenish_speed, delta)
	if Global.oxygen_level == 100.0:
		SoundManager.play_sound(FullOxygenSound)
		state = PlayerState.DEFAULT
		animated_sprite_2d.play("default")

func move_to_shore_line(delta: float) -> void:
	global_position.y = move_toward(global_position.y, SHORELINE_Y_POSITION, shoreline_speed * delta)

###
### SIGNALS
###

func _on_reload_timer_timeout() -> void:
	can_shoot = true

func _on_full_crew_oxygen_refuel() -> void:
	death_when_refueling_while_full()
	GameEvent.pause_enemies.emit(true)
	GameEvent.kill_all_enemies.emit()
	animated_sprite_2d.play("flash")
	state = PlayerState.UNLOAD_PEOPLE
	unload_people_timer.start()

func _on_partial_crew_oxygen_refuel() -> void:
	death_when_refueling_while_full()
	if Global.saved_people_count == 0:
		state = PlayerState.OXYGEN_REFUEL
		return
	GameEvent.pause_enemies.emit(true)
	animated_sprite_2d.play("flash")
	state = PlayerState.UNLOAD_PEOPLE
	unload_people_timer.start()

func _on_unload_people_timer_timeout():
	Global.saved_people_count -= 1
	GameEvent.emit_signal("update_saved_people_count")
	if Global.saved_people_count == 0:
		GameEvent.pause_enemies.emit(false)
		state = PlayerState.OXYGEN_REFUEL
		unload_people_timer.stop()

func _on_game_over():
	SoundManager.play_sound(DeathSound)
	queue_free()
	create_object_pieces()

func create_object_pieces() -> void:
	for i in PLAYER_PIECES_COUNT:
		var object_piece_instance = ObjectPieceScene.instantiate()
		object_piece_instance.init(PlayerPiecesTexture, PLAYER_PIECES_COUNT, i, self.global_position)
		get_tree().current_scene.add_child(object_piece_instance)
