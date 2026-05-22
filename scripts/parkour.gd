extends Node3D
class_name Parkour

func _ready() -> void:
	await get_tree().process_frame 
	if Global.player == null:
		Global.player = $"/root/InfiniteMap/Player"
	Global.player.jumped.connect(check)

func check() -> void:
	var arr: Array[Node3D] = $"Area3D".get_overlapping_bodies()
	if (arr.has(Global.player)):
		Global.player.parkour()
		queue_free()
