extends CharacterBody3D
class_name Enemy

signal died()

enum Actions {
	JUMP,
	SLIDE,
	LEFT,
	RIGHT,
	UP,
	DOWN,
	NONE
}

@onready var health: HealthComponent = $Health
@onready var shoot_timer: Timer = $ShootTimer
@onready var lane_timer: Timer = $LaneTimer
@onready var move_timer: Timer = $MoveTimer
@onready var mesh: MeshInstance3D = $MeshInstance3D
@export var gunScene: Gun
@export var speed: float = 8.0
@export var shoot_delay: float = 2.0
@export var lane_switch_delay: float = 1.5
@onready var gun_handle: Node3D = $GunHandle
@onready var jump_ray: RayCast3D = $RayCast3D

var can_shoot: bool = true
var current_lane: int = 0
var slide_timer := 1.0
var sliding := false
var target_z := 0
func _ready() -> void:
	# Start timers
	shoot_timer.wait_time = shoot_delay
	shoot_timer.start()
	lane_timer.wait_time = lane_switch_delay
	lane_timer.start()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	#var direction := (Global.player_pos - global_position).normalized()
	#velocity = Vector3(direction.x * speed, 0, direction.z * speed)
	#global_position.x = lerp(global_position.x, 6.0 * (current_lane-1), 4 * delta)
	#if not is_on_floor():
		#velocity.y += -60 * delta
	if global_position.z < target_z - 5:
		_handle_input(Actions.LEFT,abs(global_position.z - target_z) / 4)
	elif global_position.z > target_z + 5:
		_handle_input(Actions.RIGHT,abs(global_position.z - target_z) / 4)
		
	_handle_yaxis(delta)
	_handle_slide(delta)
	_handle_movement(delta)
	move_and_slide()
	gun_handle.look_at(Vector3(Global.player_pos.x, global_position.y, Global.player_pos.z))



func _handle_input(input: Actions,amount:int = 0) -> void:
	match input:
		Actions.JUMP:
			if is_on_floor():
				velocity.y = sqrt(2.0 * Global.GRAVITY * Global.speed * Global.JUMP_HEIGHT)
		Actions.SLIDE:
			if not is_on_floor():
				velocity.y = -40.0
			sliding = true
			slide_timer = 1.0
		Actions.DOWN:
			current_lane = clamp(current_lane - 1, 0, 2)
		Actions.UP:
			current_lane = clamp(current_lane + 1, 0, 2)
		Actions.RIGHT:
			velocity.z = -amount
		Actions.LEFT:
			velocity.z = amount
		Actions.NONE:
			pass



func _handle_yaxis(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= Global.GRAVITY * Global.speed * delta
	if jump_ray.is_colliding():
		var body: Node3D = jump_ray.get_collider()
		if body is Obstacle and body.does_damage:
			_handle_input(Actions.JUMP)

func _handle_slide(delta: float) -> void:
	if sliding:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, deg_to_rad(90.0), 0.3)
		mesh.rotation.z = lerp_angle(mesh.rotation.z, deg_to_rad(-90.0), 0.3)
		slide_timer -= delta

	if slide_timer <= 0.0:
		mesh.rotation.y = 0.0
		mesh.rotation.z = 0.0
		if velocity.y < 0.0:
			velocity.y = 0.0
		slide_timer = 1.0
		sliding = false

func _handle_movement(delta: float) -> void:
	global_position.x = lerp(global_position.x, Lane.LANE_SIZE * (current_lane - 1), 10 * delta)
	#global_position.z = lerp(global_position.z, VIEW_SIZE * current_view, VIEW_SNAP_SPEED * delta)
	if (global_position.z > 17 and velocity.z > 0) or (global_position.z < -17 and velocity.z < 0):
		velocity.z = 0

	if global_position.y >= 5.0:
		rotation_degrees.x = lerp(rotation_degrees.x, -25.0, delta * 8.0)
	else:
		rotation_degrees.x = lerp(rotation_degrees.x, 0.0, delta * 5.0)
	
func jump() -> void:
	_handle_input(Actions.JUMP)

func _on_shoot_timer_timeout() -> void:
	if not can_shoot:
		return
	shoot()

func shoot() -> void:
	if gunScene:
		gunScene.shoot()

func _on_move_timer_timeout() -> void:
	target_z = randi_range(-12,12)

func _on_lane_switch_timer_timeout() -> void:
	if Lane.has_space():
		switch_lane()

func switch_lane() -> void:
	var new_lane:int = Lane.get_available_lanes().pick_random()
	if abs(current_lane - new_lane) > 1:
		return
	while current_lane != new_lane:
		var old_lane := current_lane
		_handle_input(Actions.UP if current_lane < new_lane else Actions.DOWN)
		Lane.switch_lane_enemy(old_lane,current_lane,self)
	
func die() -> void:
	Lane.remove_from_lane(current_lane,self)
	died.emit()
	queue_free()


func _on_health_died() -> void:
	die()
	pass # Replace with function body.
