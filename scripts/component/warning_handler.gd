extends Node3D
class_name WarningHandler

@onready var mesh1: MeshInstance3D = $MeshInstance3D
@onready var mesh2: MeshInstance3D = $MeshInstance3D2
@onready var mesh3: MeshInstance3D = $MeshInstance3D3

@onready var meshes: Array[MeshInstance3D] = [mesh1,mesh2,mesh3]

func set_warning() -> void:
	for i in range(3):
		var color := get_color_from_obstacle(Global.warning_data[i])
		meshes[i].get_active_material(0).albedo_color = color
	pass

func _physics_process(delta: float) -> void:
	global_position.z = Global.player_pos.z + 20


func get_color_from_obstacle(data: ObstacleSpawner.ObstacleType) -> Color:
	match data:
		ObstacleSpawner.ObstacleType.EMPTY:
			return Color(0,0,0,0)
		ObstacleSpawner.ObstacleType.BOX:
			return Color(1.0, 0.0, 0.0)
		ObstacleSpawner.ObstacleType.RAMP:
			return Color(0.0, 0.0, 1.0, 1.0)
	return Color(0.0, 0.0, 1.0, 0.0)
		
