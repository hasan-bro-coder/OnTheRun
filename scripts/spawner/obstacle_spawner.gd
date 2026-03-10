extends Node3D
class_name ObstacleSpawner

@export var obstacle_types: Array[PackedScene]
var _obstacles: Array[Obstacle] = []
var _obstacles_spawned_count := 0
func _ready() -> void:
	for i in range(1,4):
		if randf() > 0.5:
			_spawn_obstacles_at_position(i,randi_range(0,obstacle_types.size()-1))

func _spawn_obstacles_at_position(z_pos: float,obstacle_type:int) -> void:
	var obstacle: Obstacle = obstacle_types[obstacle_type].instantiate()
	add_child(obstacle)
	obstacle.position.x = 12-z_pos*6
	obstacle.position.y = 2
	_obstacles.append(obstacle)
	obstacle.hit_player.connect(_on_obstacle_hit_player.bind(obstacle))
	_obstacles_spawned_count+=1

func _on_obstacle_hit_player(obstacle: Obstacle) -> void:
	print("hit",obstacle)
	pass
	#_blocks.erase(block)
	#block.queue_free()
	#var obstacle_type_index = floor(_blocks_spawned_count / pattern_length) % obstacle_types.size()
	#_spawn_block_at_position((block_count - 1) * block_length - speed,obstacle_type_index)
