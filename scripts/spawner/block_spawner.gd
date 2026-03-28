extends StaticBody3D
class_name BlockSpawner

@export var block_types: Array[PackedScene]
@export var pattern_length: int = 10
@export var block_per_type: int = 10
@export var block_length: float = 90
var _last_block: Block
var _blocks_spawned_count := 0
var _total_block_types: = 0
#@export var speed:float = 1.0
#* 60
#var _blocks: Array[Block] = []
@onready var warning_handler: WarningHandler = $WarningHandler

func _ready() -> void:
	_total_block_types = len(block_types)
	for i in range(block_per_type):
		_spawn_block_at_position(i * block_length,1)
	

func _spawn_block_at_position(z_pos: float,block_type:int)-> void:
	var block: Block = block_types[block_type].instantiate()
	add_child(block)
	block.position = Vector3(0, 0, z_pos)
	block.speed = Global.speed
	#_blocks.append(block)
	block.reached_despawn_point.connect(_on_block_reached_despawn_point.bind(block))
	_blocks_spawned_count+=1
	_last_block = block

func _on_block_reached_despawn_point(block: Block)-> void:
	block.queue_free()
	@warning_ignore("integer_division")
	var block_type_index:int = _get_block_type(_blocks_spawned_count)
	#floor(_blocks_spawned_count / pattern_length) % block_types.size()
	_spawn_block_at_position(_last_block.global_position.z+block_length-5,block_type_index)
	warning_handler.set_warning()

func _get_block_type(count: int) -> int:
	var segment_size: int = block_per_type * 2  # 20
	var pos_in_segment: int = count % segment_size

	if pos_in_segment >= block_per_type:
		return 0  # connector
	else:
		var type_index: int = count / segment_size
		return 1 + (type_index % (_total_block_types - 1))
