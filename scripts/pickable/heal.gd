extends Pickable


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		player.health.heal(10)
		hit_player.emit()
		queue_free()
