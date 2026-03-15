extends Area3D
class_name Pickable

signal hit_player

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player picked", self)
		hit_player.emit()
	queue_free()
	pass # Replace with function body.
