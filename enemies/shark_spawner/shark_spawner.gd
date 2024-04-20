extends Node

const Shark = preload("res://enemies/shark/shark.tscn")
const Person = preload("res://person/person.tscn")

var spawn_points_count: int = -1

@onready var left_spawner = $LeftSpawner
@onready var right_spawner = $RightSpawner

@onready var person_spawn_timer = $PersonSpawnTimer
@onready var shark_spawn_timer = $SharkSpawnTimer

var used_spawn_points = []

func _ready():
	assert(left_spawner.get_child_count() == right_spawner.get_child_count())
	spawn_points_count = left_spawner.get_child_count()
	GameEvent.connect("pause_enemies", _on_pause_enemies)

func spawn_shark():
	var available_spawn_points = []
	for i in range(1, spawn_points_count + 1):
		if not used_spawn_points.has(i):
			available_spawn_points.append(i)

	var rand_spawn_point_index = randi_range(0, available_spawn_points.size() - 1)
	var rand_spawn_point_number = available_spawn_points[rand_spawn_point_index]
	used_spawn_points.append(rand_spawn_point_number)

	var left_or_right = bool(randi_range(0, 1))
	var spawner = left_spawner if left_or_right else right_spawner
	var rand_spawn_point = spawner.get_node(str(rand_spawn_point_number))

	var shark_instance = Shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	var shark_position = rand_spawn_point.global_position
	shark_instance.init(shark_position, left_or_right)

func _on_shark_spawn_timer_timeout():
	for i in spawn_points_count:
		spawn_shark()
	used_spawn_points.clear()


func _on_person_spawn_timer_timeout():
	var rand_spawn_point_number = randi_range(1, 4)

	var left_or_right = bool(randi_range(0, 1))
	var spawner = left_spawner if left_or_right else right_spawner
	var rand_spawn_point = spawner.get_node(str(rand_spawn_point_number))

	var person_instance = Person.instantiate()
	get_tree().current_scene.add_child(person_instance)
	var person_position = rand_spawn_point.global_position
	person_instance.init(person_position, left_or_right)

func _on_pause_enemies(pause: bool) -> void:
	if pause:
		shark_spawn_timer.stop()
		person_spawn_timer.stop()
	else:
		shark_spawn_timer.start()
		person_spawn_timer.start()
