extends Node2D

export(PackedScene) var enemy_scene
onready var _spawn_location := $EnemyPath/SpawnLocation
onready var _spawn_timer := $SpawnTimer

func start(time_between_spawns:float):
	_spawn_timer.wait_time = time_between_spawns
	_spawn_timer.start()

func stop():
	_spawn_timer.stop()

func _get_random_position() -> Vector2:
	# Al setear la variable offset con un valor random de 0 a 1
	# el nodo SpawnLocation se va a mover a un punto ubicado en el path
	# que se ecuentra configurado en el nodo enemyPath
	_spawn_location.offset = randi()
	return _spawn_location.position

func _get_random_direction() -> float:
	# A la rotacion del punto de spawneo le sumamos 90º para que quede
	# perpendicular a la ruta de spawn, estos valores estan en radianes
	# PI/2 = 180º /2 = 90º
	var rotation :float = _spawn_location.rotation + PI / 2
	
	# Seguimos jugando un poco mas con el angulo
	# siguiendo la logica de antes le sumamos a la rotacion
	# valores random que vayan de -45º a 45º
	# Esto hace que nuestros enemigos puedan atacarnos en diagonal
	# PI/4 = 180º /4 = 45º
	rotation += rand_range(-PI / 4, PI / 4)
	return rotation

func _on_SpawnTimer_timeout():
	# Creamos una instancia del enemigo
	var enemy = enemy_scene.instance()

	# le seteamos una posicion random
	enemy.position = _get_random_position()
	
	# le seteamos una rotacion random
	var rotation = _get_random_direction()
	enemy.rotation = rotation

	# Le asignamos velocidades random a los enemigos
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(rotation)

	# agregamos el enemigo a este mismo nodo, la escena EnemySpawner
	# para que el enemigo pueda moverse
	add_child(enemy)
