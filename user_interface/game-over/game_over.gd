extends Control

## Sounds
const GameOverSound = preload("res://player/game_over.ogg")

var enable_reload: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvent.connect("game_over", _on_game_over)
	self.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and self.enable_reload:
		Global.reset()
		get_tree().reload_current_scene()

func _on_game_over() -> void:
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		$HighScoreLabel.text = "HIGH SCORE " + str(Global.high_score)
	$ScoreLabel.text = "SCORE " + str(Global.score)

	$GameOverDelay.start()

func _on_game_over_delay_timeout():
	$"../OxygenBar".visible = false
	$"../ScoreDisplay".visible = false
	$"../PeopleCount".visible = false
	SoundManager.play_sound(GameOverSound)
	self.visible = true
	self.enable_reload = true
