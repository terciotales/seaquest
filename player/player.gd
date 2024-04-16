extends Area2D

# Declara uma variável de velocidade inicialmente parada
var velocity = Vector2(0, 0)
var can_shoot = true

var state = "default"

# Define uma constante de velocidade máxima
const SPEED = Vector2(125, 90)
const OXYGEN_DECREASE_SPEED = 2.5
const BULLET_OFFSET = 7
const Bullet = preload("res://player/player_bullet/player_bullet.tscn")

@onready var reaload_timer = $ReloadTimer
@onready var sprite = $AnimatedSprite2D

func _ready():
	GameEvent.connect("full_crew_oxygen_refuel", Callable(self, "_full_crew_oxygen_refuel"))
	GameEvent.connect("less_people_oxygen_refuel", Callable(self, "_less_people_oxygen_refuel"))

func _process(delta):
	if state == "default":
		process_movement_input()
		direction_follows_input()
		process_shooting()
		lose_oxygen()	

func _physics_process(delta):
	if state == "default":
		movement()

func process_movement_input():
	# Define a velocidade horizontal baseada na entrada do jogador
	velocity.x = Input.get_axis("move_left", "move_right")
	# Define a velocidade vertical baseada na entrada do jogador
	velocity.y = Input.get_axis("move_up", "move_down")
	
	# Normaliza a direção do movimento para manter uma velocidade consistente
	# Independentemente da direção em que o objeto está se movendo (horizontal, vertical ou diagonal). 
	# A velocidade total do objeto permanece constante
	velocity = velocity.normalized()

func direction_follows_input():
	if velocity.x > 0:  # Verifica se o movimento é para a direita
		sprite.flip_h = false  # Se sim, o sprite se mantém "olhando" para a direita
	elif velocity.x < 0:  # Verifica se o movimento é para a esquerda
		sprite.flip_h = true  # Se sim, o sprite "olha" para a esquerda

func process_shooting():
	if Input.is_action_pressed("shoot") and can_shoot == true:
		var bullet_instance = Bullet.instantiate()
		bullet_instance.global_position = global_position
		get_tree().current_scene.add_child(bullet_instance)
		
		if sprite.flip_h == true:
			bullet_instance.flip_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		reaload_timer.start()
		can_shoot = false

func lose_oxygen():
	Global.oxygen_level -= OXYGEN_DECREASE_SPEED * get_process_delta_time()

func movement():
	global_position += velocity * SPEED  * get_physics_process_delta_time()
	
func _on_reload_timer_timeout():
	can_shoot = true	

func _full_crew_oxygen_refuel():
	state = "people_refuel"

func _less_people_oxygen_refueç():
	state = "less_people_refuel"
