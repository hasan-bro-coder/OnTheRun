extends Node3D

const parkour_scene = preload("uid://nph37kgqquk7")

func _ready() -> void:
	if randf() < 0.1:
		_spawn_obstacles()
	pass # Replace with function body.

func _spawn_obstacles() -> void:
	var parkour: Parkour = parkour_scene.instantiate()
	add_child(parkour)
	parkour.position.x = 0
	parkour.position.y = 8
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
