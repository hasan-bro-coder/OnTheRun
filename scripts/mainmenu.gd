extends Node3D

const MAIN = preload("uid://filuhcwd6hw")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
