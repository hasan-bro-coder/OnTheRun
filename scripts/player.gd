extends CharacterBody3D
class_name Player



var jump_buffer := 0.0
var current_view := 0
var slide_timer := 1.0
var sliding := false

signal died()

@onready var health: HealthComponent = $Health
@onready var coin_handler: CoinComponent = $CoinHandler
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var camera: Camera3D = $Camera3D
@onready var camera_3d_2: Camera3D = $Camera3D2


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	Global.player = self





func _physics_process(delta: float) -> void:
	_camera_follow(delta)
	_handle_input(delta)
	_handle_gravity(delta)
	_handle_slide(delta)
	_handle_movement(delta)
	move_and_slide()
	Global.player_pos = global_position

func _camera_follow(delta: float) -> void:
	camera.rotation_degrees.y = lerp(
		camera.rotation_degrees.y,
		-90.0 + global_position.z / 2.0,
		3.0 * delta
	)

func _handle_input(delta: float) -> void:
	jump_buffer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer = Global.JUMP_BUFFER_TIME

	if Input.is_action_just_pressed("slide"):
		if not is_on_floor():
			velocity.y = -40.0
		sliding = true
		slide_timer = 1.0

	if Input.is_action_just_pressed("down"):
		Lane.player_lane = clamp(Lane.player_lane - 1, 0, 2)
	if Input.is_action_just_pressed("up"):
		Lane.player_lane = clamp(Lane.player_lane + 1, 0, 2)
	var dir := Input.get_axis("right","left")
	velocity.z = lerpf(velocity.z,-30 * dir,0.5)
	
	#if Input.is_action_pressed("left"):
		##current_view = clamp(current_view - 1, -1, 1)
	#else:
		#velocity.z = lerpf(velocity.z,0,delta*16)
	#if Input.is_action_pressed("right"):
		#velocity.z = lerpf(velocity.z,10,delta*2)
		##current_view = clamp(current_view + 1, -1, 1)
	#else:
		#velocity.z = lerpf(velocity.z,0,delta*8)
	
	

func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= Global.GRAVITY * Global.speed * delta

	if jump_buffer > 0.0 and is_on_floor():
		jump()
		slide_timer = 0.0

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
	global_position.x = lerp(global_position.x, Lane.LANE_SIZE * (Lane.player_lane - 1), 10 * delta)
	#global_position.z = lerp(global_position.z, VIEW_SIZE * current_view, VIEW_SNAP_SPEED * delta)
	if (global_position.z > 17 and velocity.z > 0) or (global_position.z < -17 and velocity.z < 0):
		velocity.z = 0

	if global_position.y >= 5.0:
		rotation_degrees.x = lerp(rotation_degrees.x, -25.0, delta * 8.0)
	else:
		rotation_degrees.x = lerp(rotation_degrees.x, 0.0, delta * 5.0)

	if Input.is_action_pressed("wheelie"):
		rotation_degrees.x = lerp(rotation_degrees.x, -45.0, delta * 5.0)

func jump() -> void:
	velocity.y = sqrt(2.0 * Global.GRAVITY * Global.speed * Global.JUMP_HEIGHT)
	jump_buffer = 0.0

func _on_health_died() -> void:
	died.emit()
