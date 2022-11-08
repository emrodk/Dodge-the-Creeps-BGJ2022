extends Node2D

signal game_started
signal game_over

export(float,0,10,0.1) var spawn_time:float = 3

onready var _music := $Music
onready var _mob_spawner := $EnemySpawner

func _ready():
	randomize()

func game_over():
	_mob_spawner.stop()
	_music.stop()
	$DeathSound.play()
	emit_signal("game_over")

func new_game():
	emit_signal("game_started")
	# Hacemos un llamado a todos los nodos que pertenezcan al grupo enemigo
	# y los borramos con un queue_free asi nos aseguramos que al reiniciar
	# una partida no quedan enemigos
	get_tree().call_group("enemy", "queue_free") 
	_mob_spawner.start(spawn_time)
	_music.play()

func _on_MainMenu_start_game():
	new_game()

func _on_Player_hit():
	game_over()
