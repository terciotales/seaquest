extends Node

const SCREEN_BOUND_MAX_X: float = 300
const SCREEN_BOUND_MIN_X: float = -50

const INIT_SAVED_PEOPLE_COUNT: int = 0
var saved_people_count = INIT_SAVED_PEOPLE_COUNT

const INIT_OXYGEN_LEVEL: float = 100.0
var oxygen_level = INIT_OXYGEN_LEVEL

const FULL_CREW_COUNT: int = 7

const INIT_SCORE: int = 0
var score = INIT_SCORE

var high_score = INIT_SCORE

func reset():
	saved_people_count = INIT_SAVED_PEOPLE_COUNT
	oxygen_level = INIT_OXYGEN_LEVEL
	score = INIT_SCORE
