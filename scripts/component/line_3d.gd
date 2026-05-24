extends MeshInstance3D
class_name Line3D

#@onready var mesh: MeshInstance3D = $MeshInstance3D

func draw_line(start: Vector3, end: Vector3, width := 0.03) -> void:

	var direction := end - start
	var length := direction.length()

	if length <= 0.001:
		return

	global_position = (start + end) * 0.5

	look_at(end, Vector3.LEFT)

	# Plane faces Z by default
	#rotate_x(deg_to_rad(90))

	mesh.size.y = length
	mesh.size.x = width


#var immediate_mesh := ImmediateMesh.new()
#
#func _ready() -> void:
	#mesh = immediate_mesh
#
#func draw_line(start: Vector3, end: Vector3, color: Color = Color.WHITE) -> void:
	#immediate_mesh.clear_surfaces()
#
	#immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
#
	#immediate_mesh.surface_set_color(color)
	#immediate_mesh.surface_add_vertex(start)
#
	#immediate_mesh.surface_set_color(color)
	#immediate_mesh.surface_add_vertex(end)
#
	#immediate_mesh.surface_end()
