extends Node3D

var available_guns: Dictionary = {}
var current_gun_index: int = 0
@export var current_gun: Gun
@export var camera: Camera3D
@export var min_angle: float = -30.0
@export var max_angle: float = 210.0
@export var rotation_speed: float = 15.0
@onready var player: Player = $".."
@onready var crossheir: Sprite3D = $crossheir
@onready var crossheir2: Sprite2D = $crossheir2
var locked_enemy: Enemy
func _ready() -> void:
	if not camera:
		camera = get_viewport().get_camera_3d()
	
	Lane.lane_changed.connect(_lock_on_enemy)
	
	var guns := [preload("res://scenes/guns/pistol.tscn"),
		preload("res://scenes/guns/mp5.tscn"),
	]
	for i in range(guns.size()):
		var gun_instance: Gun = guns[i].instantiate()
		gun_instance.visible = false
		add_child(gun_instance)
		available_guns[i] = gun_instance
	equip_gun(0)

func equip_gun(index: int) -> void:
	if current_gun:
		current_gun.visible = false
	current_gun = available_guns[index]
	current_gun.visible = true
	current_gun_index = index

func _physics_process(delta: float) -> void:
	global_position = player.global_position 
	#_update_gun_rotation(delta)
	#_lock_on_enemy()
	if locked_enemy:
		current_gun.look_at(locked_enemy.global_position)
		crossheir.global_position.x = locked_enemy.global_position.x
		crossheir.global_position.y = locked_enemy.global_position.y
		crossheir.global_position.z = lerp(crossheir.global_position.z,locked_enemy.global_position.z,0.5)
		#var cam := get_viewport().get_camera_3d()
		#var dist := global_position.distance_to(cam.global_position)
		#var scale_factor := dist / 20.0
		#crossheir.scale = Vector3.ONE * scale_factor
		#crossheir2.global_position.y = locked_enemy.global_position.y
		#crossheir2.global_position.x = lerp(crossheir.global_position.x,locked_enemy.global_position.z,0.5)
		#rotation = Vector3(2*PI,2*PI,2*PI)
	else:
		_update_gun_rotation(delta)
		#crossheir.global_position.z = lerp(crossheir.global_position.z,global_position.z+10.0,0.5)
		rotation_degrees = Vector3(-180,0,0)
	crossheir.scale = Vector3.ONE * remap(crossheir.global_position.x, 9.0, -9.0, 2.0, 1.0)
	
		
	
	if Input.is_action_pressed("shoot"):
		if current_gun:
			current_gun.shoot()
	
	if Input.is_action_pressed("reload"):
		if current_gun:
			current_gun.reload()
			
	if Input.is_action_just_pressed("switch_gun"):
		current_gun_index += 1
		if current_gun_index > len(available_guns) - 1:
			current_gun_index = 0
		equip_gun(current_gun_index)


	
func _lock_on_enemy(lane:int) -> void:
	print(lane,Lane.lane)
	if Lane.lane[Lane.player_lane] == []:
		locked_enemy = null
		return
	var enemy = Lane.lane[Lane.player_lane][0]
	print(enemy)
	if !enemy:
		locked_enemy = null
		return
	locked_enemy = enemy
	#_look_at_smoothly(current_gun.global_position,enemy.global_position+Vector3(0,0,0),self)

func _update_gun_rotation(_delta:float) -> void:
	if not current_gun or not camera:
		return
	
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)
	
	# Create plane on X axis (since it's a side-scroller)
	var plane := Plane(Vector3(1, 0, 0), current_gun.global_position.x)
	var intersection: Variant = plane.intersects_ray(ray_origin, ray_dir)
	if intersection:
		var direction:Vector3 = (intersection-current_gun.global_position).normalized()
		var angle: float = atan2(direction.z,direction.y) - PI / 2
		crossheir.global_position.z = lerp(crossheir.global_position.z,intersection.z,0.5)
		crossheir.global_position.y = lerp(crossheir.global_position.y,intersection.y,0.5)
		current_gun.rotation.x = angle
		#if rad_to_deg(angle) < 0 and rad_to_deg(angle) > -180:
			#return
		#crossheir2.global_position.y = lerp(crossheir.global_position.y,intersection.y,0.5)

func _look_at_smoothly(from: Vector3,to:Vector3,of:Node3D)->void:
	var direction:Vector3 = (from - to).normalized()
	var angle: float = atan2(direction.z,direction.y) - PI / 2
	if rad_to_deg(angle) < -20 and rad_to_deg(angle) > -160:
		return
	of.rotation.x = angle
