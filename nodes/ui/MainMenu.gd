extends Control

signal start_game

onready var _start_button := $StartButton
onready var _score_label := $ScoreLabel
onready var _message_label := $MessageLabel
onready var _message_timer := $MessageTimer
onready var _background := $Background

func show_message(text):
	_message_label.text = text
	_message_label.show()
	_message_timer.start()


func show_game_over():
	show_message("Game Over")
	yield(_message_timer, "timeout")
	_message_label.text = "Dodge the\nCreeps"
	_message_label.show()
	yield(get_tree().create_timer(1), "timeout")
	_start_button.show()


func update_score(score):
	_score_label.text = str(score)


func _on_StartButton_pressed():
	_start_button.hide()
	_background.hide()
	show_message("Get Ready")
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	_message_label.hide()

func _on_Gameplay_game_over():
	show_game_over()


func _on_Scoreboard_score_updated(new_score):
	update_score(new_score)
