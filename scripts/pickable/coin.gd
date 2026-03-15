extends Obstacle

func _ready() -> void:
	$AnimationPlayer.play("rotate")
	#$AnimationPlayer.
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		hit_player.emit()
		player.coin_handler.add_coins(1)
		queue_free()
	pass
