class_name Ammo
extends Area3D


@export var ammo_name: String = "Standard"
@export var damage: float = 10.0
@export var speed: float = 50.0
@export var lifetime: float = 3.0
@export var impact_effect: PackedScene
@export var hit_sound: AudioStream
@export var trail_particles: GPUParticles3D


var direction: Vector3 = Vector3.BACK
var _velocity: Vector3

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

	_velocity = direction * speed
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += _velocity * delta

func _on_body_entered(body: Node) -> void:
	if body is Player:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	_spawn_impact(global_position)
	_destroy()

func _on_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent and parent.has_method("take_damage"):
		parent.take_damage(damage)
	
	_spawn_impact(global_position)
	_destroy()

func _spawn_impact(position: Vector3) -> void:
	if impact_effect:
		var impact = impact_effect.instantiate()
		impact.global_position = position
		get_tree().current_scene.add_child(impact)
	
	#if hit_sound:
		#var audio = AudioStreamPlayer3D.new()
		#audio.stream = hit_sound
		#audio.global_position = position
		#audio.autoplay = true
		#get_tree().current_scene.add_child(audio)

func _destroy() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	await get_tree().create_timer(0.1).timeout
	queue_free()
