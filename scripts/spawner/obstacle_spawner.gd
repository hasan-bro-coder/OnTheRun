extends Node3D
class_name ObstacleSpawner

enum ObstacleType { BOX,RAMP,EMPTY }
@export var obstacle_types: Array[PackedScene]
var _obstacles: Array[Obstacle] = []
var _obstacles_spawned_count := 0
@export var obstacle_patterns: Array[Array] = [
	[ObstacleType.RAMP,ObstacleType.RAMP,ObstacleType.RAMP],
	[ObstacleType.BOX,ObstacleType.RAMP,ObstacleType.BOX],
	[ObstacleType.BOX,ObstacleType.BOX,ObstacleType.BOX],
	[ObstacleType.EMPTY,ObstacleType.RAMP,ObstacleType.EMPTY],
	[ObstacleType.RAMP,ObstacleType.BOX,ObstacleType.RAMP],
	[ObstacleType.EMPTY,ObstacleType.BOX,ObstacleType.EMPTY],
	[ObstacleType.EMPTY,ObstacleType.EMPTY,ObstacleType.EMPTY],
	
]

func _ready() -> void:
	var pattern:Array = obstacle_patterns.pick_random() if randf() < 0.2 else [ObstacleType.EMPTY,ObstacleType.EMPTY,ObstacleType.EMPTY]
	Global.warning_data = pattern
	for i in range(3):
		
		if pattern[i] == ObstacleType.EMPTY:
			continue
		_spawn_obstacles(i+1,pattern[i])
	#for i in range(1,4):
		#if randf() > 0.5:
			#_spawn_obstacles(i,randi_range(0,obstacle_types.size()-1))

func _spawn_obstacles(z_pos: float,obstacle_type:int) -> void:
	var obstacle: Obstacle = obstacle_types[obstacle_type].instantiate()
	add_child(obstacle)
	obstacle.position.x = 12-z_pos*6
	obstacle.position.y = 2
	_obstacles.append(obstacle)
	obstacle.hit_player.connect(_on_obstacle_hit_player.bind(obstacle))
	_obstacles_spawned_count+=1

func _on_obstacle_hit_player(obstacle: Obstacle) -> void:
	#print("hit",obstacle)
	pass
	#_blocks.erase(block)
	#block.queue_free()
	#var obstacle_type_index = floor(_blocks_spawned_count / pattern_length) % obstacle_types.size()
	#_spawn_block_at_position((block_count - 1) * block_length - speed,obstacle_type_index)
