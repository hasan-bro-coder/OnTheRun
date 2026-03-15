extends StaticBody3D
class_name BlockSpawner

@export var block_types: Array[PackedScene]
@export var pattern_length: int = 10
@export var block_count: int = 3
@export var block_length: float = 90
var _last_block: Block
#@export var speed:float = 1.0
#* 60
#var _blocks: Array[Block] = []
var _blocks_spawned_count := 0
@onready var warning_handler: WarningHandler = $WarningHandler

func _ready() -> void:
	for i in range(block_count):
		_spawn_block_at_position(i * block_length,0)

	

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
	#_blocks.erase(block)
	block.queue_free()
	@warning_ignore("integer_division")
	var block_type_index:int = floor(_blocks_spawned_count / pattern_length) % block_types.size()
	_spawn_block_at_position(_last_block.global_position.z+block_length-5,block_type_index)
	warning_handler.set_warning()
	#_spawn_block_at_position((block_count - 1) * block_length - (Global.speed),block_type_index)
