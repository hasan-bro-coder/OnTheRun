extends Obstacle

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		@warning_ignore("unsafe_property_access")
		body.velocity.y = 40
	pass # Replace with function body.
 
