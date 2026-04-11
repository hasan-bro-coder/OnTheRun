extends Node

signal player_changed_lane(new_lane:int)
signal lane_changed(lane:int)
const MAXIMUM_ENEMY_ON_LANE := 2
const LANE_SIZE := 6.0

var lane: Array[Array] = [[],[],[]]
var player_lane := 0:
	set(val):
		player_lane = val
		player_changed_lane.emit(val)
		lane_changed.emit(val)


func add_to_lane(lane_num:int,enemy: Enemy) -> void:
	lane[lane_num].push_back(enemy)
	lane_changed.emit(lane_num)
	
	
func get_available_lanes() -> Array[int]:
	var available_lane:Array[int] = []
	for i in range(3):
		if len(lane[i]) < MAXIMUM_ENEMY_ON_LANE:
			available_lane.push_back(i)
	if available_lane.is_empty():
		return [TYPE_NIL]
	return available_lane

func has_space() -> bool:
	var available_lane:Array[Array] = lane.filter(func(v:Array)->bool: return len(v) < MAXIMUM_ENEMY_ON_LANE)
	return not available_lane.is_empty()

func spawn_on_lane(enemy:Enemy) -> int:
	var lane_num:int = get_available_lanes().pick_random()
	add_to_lane(lane_num,enemy)
	return lane_num

func switch_lane_enemy(prev_lane:int,new_lane:int,enemy: Enemy) -> void:
	remove_from_lane(prev_lane,enemy)
	add_to_lane(new_lane,enemy)

func remove_from_lane(lane_num:int,enemy: Enemy) -> void:
	if lane[lane_num] == []:
		push_error("error while removing enemy (lane empty)")
	else:
		lane[lane_num].erase(enemy)
		lane_changed.emit(lane_num)
