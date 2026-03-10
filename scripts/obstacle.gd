extends Node3D
class_name Obstacle

signal hit_player

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		hit_player.emit()
	pass
