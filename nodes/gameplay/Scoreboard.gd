extends Node

signal score_updated(new_score)

onready var _score_timer := $ScoreTimer

var _score := 0 setget set_score,get_score

func set_score(new_score:int) -> void:
	_score = new_score
	emit_signal("score_updated",_score)

func get_score() -> int:
	return _score

func _on_Gameplay_game_over():
	_score_timer.stop()

func _on_Gameplay_game_started():
	set_score(0)
	_score_timer.start()

func _on_ScoreTimer_timeout():
	set_score(_score+1)
