extends Obstacle

func _on_area_body_entered(body: Node3D) -> void:
	if body is Player or body is Enemy:
		body.jump()
	pass
 
