extends CanvasLayer
class_name DeathScreen
@onready var score: Label = $Control/score
@onready var highscore: Label = $Control/highscore

func show_deathsceen()->void:
	show()
	score.text = "score: " + str(int(Global.score))
	highscore.text = "highscore: " + str(int(max(Saves.data.high_score,Global.score)))
	if Global.score > Saves.data.high_score:
		Saves.data.high_score = Global.score
	Saves.save()
	get_tree().paused = true
	
func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_player_died() -> void:
	show_deathsceen()
	pass # Replace with function body.
