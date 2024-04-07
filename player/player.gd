extends AnimatedSprite2D

# Declara uma variável de velocidade inicialmente parada
var velocity = Vector2(0, 0)

# Define uma constante de velocidade máxima
const SPEED = Vector2(100, 90)

func _process(delta):
	# Define a velocidade horizontal baseada na entrada do jogador
	velocity.x = Input.get_axis("move_left", "move_right")
	# Define a velocidade vertical baseada na entrada do jogador
	velocity.y = Input.get_axis("move_up", "move_down")
	
	# Normaliza a direção do movimento para manter uma velocidade consistente
	# Independentemente da direção em que o objeto está se movendo (horizontal, vertical ou diagonal). 
	# A velocidade total do objeto permanece constante
	velocity = velocity.normalized()

	if velocity.x > 0:  # Verifica se o movimento é para a direita
		flip_h = false  # Se sim, o sprite se mantém "olhando" para a direita
	elif velocity.x < 0:  # Verifica se o movimento é para a esquerda
		flip_h = true  # Se sim, o sprite "olha" para a esquerda

func _physics_process(delta):
	# Move o objeto no jogo de acordo com sua velocidade e tempo passado
	global_position += velocity * SPEED  * delta  
