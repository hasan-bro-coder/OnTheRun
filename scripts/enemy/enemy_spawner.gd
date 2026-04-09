extends Node3D


@export var enemy_scene: PackedScene
@export var spawn_delay: float = 5.0
@export var spawn_distance_behind: float = 20.0
@onready var spawn_timer: Timer = $SpawnTimer
var can_spawn: bool = true
var enemy_count = 0
func _ready() -> void:
	spawn_enemy_on_lane()
	spawn_timer.wait_time = spawn_delay
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if not can_spawn:
		return
	spawn_enemy_on_lane()
	spawn_timer.start()
	

#func spawn_enemy_group() -> void:
	#spawn_enemy_on_lane(i)
	#var spawned_count := 0
	#
	## Try to spawn one enemy on each lane
	#for lane in range(3):
		#if Global.enemy_in_lanes[lane] < 2:
			#spawn_enemy_on_lane(lane)
			#spawned_count += 1
			#
	#if spawned_count == 0:
		#spawn_timer.start(spawn_delay * 0.5)

func spawn_enemy_on_lane() -> void:
	if enemy_count >= 4:
		return
	var enemy:Enemy = enemy_scene.instantiate()
	var lane := Lane.spawn_on_lane(enemy)
	var spawn_x := 6 * (lane - 1)
	var spawn_z := Global.player_pos.z - spawn_distance_behind
	var spawn_y := 10.0
	enemy.global_position = Vector3(spawn_x, spawn_y, spawn_z)
	enemy.current_lane = lane
	add_child(enemy)
	enemy.died.connect(func()->void: enemy_count-=1)
	enemy_count+=1
