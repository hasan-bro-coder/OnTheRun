extends Node3D
class_name PickableSpawner

const COIN = preload("uid://bn2wwlta24mdd")

@export var pickable_types: Array[PackedScene]
var _pickables: Array[Pickable] = []
var _pickables_spawned_count := 0


func _ready() -> void:
	#var x := 12-randi_range(1,3)*6
	#for i in range(-10,10):
		#if i >= -5 && i <= 5:
			#continue
		#_spawn_coin(Vector3(x,2,i*4))
	pass
	for i in range(1,4):
		if randf() > 0.9:
			_spawn_pickables(Vector3(12-i*6,1,45),randi_range(0,pickable_types.size()-1))

func _spawn_coin(pos: Vector3) -> void:
	var coin: Pickable = COIN.instantiate()
	add_child(coin)
	coin.position = pos
	coin.hit_player.connect(_picked_coin.bind(coin))

func _spawn_pickables(pos: Vector3,pickable_type:int) -> void:
	var pickable: Pickable = pickable_types[pickable_type].instantiate()
	add_child(pickable)
	pickable.position = pos
	#pickable.position.x = 12-z_pos*6
	#pickable.position.y = 2
	_pickables.append(pickable)
	pickable.hit_player.connect(_on_pickable_hit_player.bind(pickable))
	_pickables_spawned_count+=1

func _picked_coin(coin: Pickable) -> void:
	print("picked",coin)
	pass

func _on_pickable_hit_player(pickable: Pickable) -> void:
	print("picked",pickable)
	pass
