extends Node3D

var available_guns: Dictionary = {}
var current_gun_index: int = 0
@export var current_gun: Gun
@export var camera: Camera3D
@export var min_angle: float = -30.0
@export var max_angle: float = 210.0
@export var rotation_speed: float = 15.0
@onready var player: Player = $".."

func _ready() -> void:
	if not camera:
		camera = get_viewport().get_camera_3d()
	
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
	global_position = player.global_position + Vector3(-0.777,0,0)
	_update_gun_rotation(delta)
	
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

func _update_gun_rotation(_delta:float) -> void:
	if not current_gun or not camera:
		return
	
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)
	
	# Create plane on X axis (since it's a side-scroller)
	var plane := Plane(Vector3(1, 0, 0), current_gun.global_position.x)
	var intersection = plane.intersects_ray(ray_origin, ray_dir)
	if intersection:
		var direction:Vector3 = (current_gun.global_position - intersection).normalized()
		var angle: float = atan2(direction.z,direction.y) - PI / 2
		if rad_to_deg(angle) < -20 and rad_to_deg(angle) > -160:
			return
		rotation.x = angle
