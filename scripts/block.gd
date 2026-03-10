extends StaticBody3D
class_name Block

signal reached_despawn_point

@export var scroll_speed: float = 60.0
@export var despawn_threshold: float = -90
@export var speed := 3
func _process(delta:float) -> void:
	position.z -= speed * delta
	if position.z <= despawn_threshold:
		reached_despawn_point.emit()
