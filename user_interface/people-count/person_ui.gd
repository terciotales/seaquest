extends Sprite2D

const PERSON_EMPTY_UI_TEXTURE = preload("res://user_interface/people-count/person_empty_ui.png")
const PERSON_UI_TEXTURE = preload("res://user_interface/people-count/person_ui.png")

@export var order_number = 1

func _ready():
	GameEvent.connect("update_saved_people_count", Callable(self, "_on_update_saved_people_count"))

func _on_update_saved_people_count():
	if Global.saved_people_count >= order_number:
		texture = PERSON_UI_TEXTURE
	else:
		texture = PERSON_EMPTY_UI_TEXTURE
	if Global.saved_people_count == Global.FULL_CREW_COUNT:
		frame = 1
	else:
		frame = 0
