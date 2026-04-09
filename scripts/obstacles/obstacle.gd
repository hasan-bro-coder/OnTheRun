extends Node3D
class_name Obstacle

signal hit_player

@export var does_damage: bool = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		hit_player.emit()
		player.health.take_damage(10)
	pass
