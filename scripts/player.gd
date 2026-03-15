extends CharacterBody3D
class_name Player

const SPEED := 45.0
const JUMP_VELOCITY := 30.0

@onready var health: HealthComponent = $Health
@onready var coin_handler: CoinComponent = $CoinHandler
@onready var mesh: MeshInstance3D = $MeshInstance3D

@onready var camera: Camera3D = $Camera3D
@onready var camera_3d_2: Camera3D = $Camera3D2

@export var deathscreen: DeathScreen

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	Global.player = self

func camera_follow(delta:float) -> void:
	camera.rotation_degrees.y = lerp(camera.rotation_degrees.y,float(-90 + global_position.z /2),3 * delta)	
	pass
#
var slide_timer := 1.0
var sliding := false

func _physics_process(delta: float) -> void:
	camera_follow(delta)
	if not is_on_floor():
		velocity.y += -60.0 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("slide"):
		sliding = true
		slide_timer = 1
		velocity.y = -40
	if sliding:
		mesh.rotation.y = lerp_angle(mesh.rotation.y,deg_to_rad(90.0),0.3)
		mesh.rotation.z = lerp_angle(mesh.rotation.z,deg_to_rad(-90.0),0.3)
		#mesh.rotation.z = -90
		slide_timer -= delta
		#velocity.y = -40
		
	if slide_timer <= 0:
		#mesh.rotation.y = lerp_angle(mesh.rotation.y,deg_to_rad(1.0),0.3)
		#mesh.rotation.z = lerp_angle(mesh.rotation.z,deg_to_rad(-1.0),0.3)
		mesh.rotation.y = 0
		mesh.rotation.z = 0
		if velocity.y < 0:
			velocity.y = 0
		slide_timer = 1
		sliding = false
		
		
	
	var direction := Input.get_vector("down","up","left","right")
	
	velocity.x = direction.x * SPEED
	rotation_degrees.z = lerp(rotation_degrees.z,-25*direction.x,delta*5)
	velocity.z = direction.y * SPEED
	
	if (global_position.z >= 15 and direction.y > 0):
		velocity.z = 0
	if (global_position.z <= -15 and direction.y < 0):
		velocity.z = 0
	if (global_position.y >= 5):
		rotation_degrees.x = lerp(rotation_degrees.x,-25.0,delta*5)
	else:
		if Input.is_action_pressed("wheelie"):
			rotation_degrees.x = lerp(rotation_degrees.x,-45.0,delta*5)
		else:
			rotation_degrees.x = lerp(rotation_degrees.x,15*direction.y,delta*5)
	move_and_slide()
	Global.player_pos = global_position

func _on_health_died() -> void:
	deathscreen.show_deathsceen()
	pass # Replace with function body.
#extends CharacterBody3D
#
#
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("down","up","left", "right")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
