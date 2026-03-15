extends Node
class_name ScoreHandler


var score_update_timer := 0.1
@export var score_label: Label

func _physics_process(delta: float) -> void:
	Global.score += delta * 10
	score_update_timer -= delta
	if score_update_timer < 0.0:
		score_label.text = str(int(Global.score))
		score_update_timer = 0.1
		Global.speed = 0.8 + Global.score / 1000
