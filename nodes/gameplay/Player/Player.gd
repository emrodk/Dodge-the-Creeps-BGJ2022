extends Area2D

signal hit

export var speed := 400 # How fast the player will move (pixels/sec).
var screen_size : Vector2 # Size of the game window.

export var start_position_path :NodePath
onready var start_position :Position2D = get_node_or_null(start_position_path)
onready var _animation := $AnimatedSprite

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _get_move_direction() -> Vector2:
	var direction = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	return direction.normalized()

func _update_animation(velocity:Vector2):
	if velocity.length() > 0:
		_animation.play()
		if velocity.x != 0:
			_animation.animation = "right"
			_animation.flip_v = false
			_animation.flip_h = velocity.x < 0
		elif velocity.y != 0:
			_animation.animation = "up"
			_animation.flip_v = velocity.y > 0
	else:
		_animation.stop()
	
	

func _process(delta):	
	var movement_direction := _get_move_direction() # The player's movement vector.
	var velocity := movement_direction * speed
	
	_update_animation(velocity)

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	


func start():
	if start_position:
		position = start_position.position
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_Gameplay_game_started():
	start()
