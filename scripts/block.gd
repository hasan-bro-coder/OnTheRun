extends StaticBody3D
class_name Block

signal reached_despawn_point


@export var despawn_threshold: float = -90
var speed := 1.0
func _physics_process(_delta: float) -> void:
	position.z -= Global.speed
	if position.z <= despawn_threshold:
		reached_despawn_point.emit()
