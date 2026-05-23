extends Pickable

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		var player:Player = body
		player.gun_handler.current_gun.add_ammo(10)
		hit_player.emit()
	queue_free()
