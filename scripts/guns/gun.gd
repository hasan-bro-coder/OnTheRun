#class_name Gun
#extends Node3D
#
#
#@export var gun_name: String = "Pistol"
#@export var current_ammo: int = 12
#@export var max_ammo: int = 12
#@export var reserve_ammo: int = 60
#@export var fire_rate: float = 0.3
#@export var reload_time: float = 1.5
#
#@export var ammo_type: Ammo
#
#@export var muzzle_node: Marker3D
#@export var animation_player: AnimationPlayer
#@export var audio_player: AudioStreamPlayer3D
## State
#var _can_shoot: bool = true
#var _is_reloading: bool = false
#var _fire_timer: float = 0.0
#
#func _ready() -> void:
	#pass
#
#func _process(delta:float) -> void:
	#if not _can_shoot:
		#_fire_timer += delta
		#if _fire_timer >= fire_rate:
			#_can_shoot = true
			#_fire_timer = 0.0
#
#func shoot() -> bool:
	## Check if we can shoot
	#if not _can_shoot:
		#return false
	#if _is_reloading:
		#return false
	#if current_ammo <= 0:
		#_play_empty_sound()
		#return false
	#
	## Consume ammo
	#current_ammo -= 1
	#
	## Create the projectile/effect
	#_fire_projectile()
	#
	## Play animations and sounds
	#_play_shoot_effects()
	#
	## Start cooldown
	#_can_shoot = false
	#
	## Auto-reload if empty
	#if current_ammo == 0:
		#reload()
	#
	#return true
#
#func _fire_projectile() -> void:
	#var shoot_direction := -global_transform.basis.z  # Forward in 3D
#
	#if ammo_type.is_hitscan:
		## Hitscan weapon (instant hit)
		#_hitscan_shot()
	#else:
		## Projectile weapon
		#_spawn_projectile(shoot_direction)
#
#func _hitscan_shot() -> void:
	#if raycast.is_colliding():
		#var hit_object := raycast.get_collider()
		#if hit_object.has_method("take_damage"):
			#hit_object.take_damage(ammo_type.damage)
		#
		#if ammo_type.impact_effect:
			#var impact = ammo_type.impact_effect.instantiate()
			#impact.global_position = raycast.get_collision_point()
			#get_tree().current_scene.add_child(impact)
#
#func _spawn_projectile(direction: Vector3) -> void:
	#if not ammo_type.projectile_scene:
		#return
	#
	#var projectile = ammo_type.projectile_scene.instantiate()
	#projectile.global_position = muzzle_node.global_position
	#projectile.direction = direction
	#projectile.speed = ammo_type.bullet_speed
	#projectile.damage = ammo_type.damage
	#projectile.lifetime = ammo_type.bullet_lifetime
	#projectile.impact_effect = ammo_type.impact_effect
	#
	#get_tree().current_scene.add_child(projectile)
#
#func _play_shoot_effects() -> void:
	##if animation_player and animation_player.has_animation("shoot"):
	#animation_player.play("shoot")
	#
	## Play sound
	#if audio_player and ammo_type.shoot_sound:
		#audio_player.stream = ammo_type.shoot_sound
		#audio_player.play()
	#
	## Spawn muzzle flash
	#if ammo_type.muzzle_flash and muzzle_node:
		#var flash = ammo_type.muzzle_flash.instantiate()
		#muzzle_node.add_child(flash)
#
#func _play_empty_sound() -> void:
	## Play "click" sound for empty gun
	#pass
#
#func reload() -> bool:
	#if _is_reloading:
		#return false
	#if current_ammo == max_ammo:
		#return false
	#if reserve_ammo <= 0:
		#return false
	#
	#_is_reloading = true
	#
	## Play reload animation
	##if animation_player and animation_player.has_animation("reload"):
	#animation_player.play("reload")
	#
	## Wait for reload time
	#await get_tree().create_timer(reload_time).timeout
	#
	## Calculate ammo to reload
	#var needed := max_ammo - current_ammo
	#var to_reload: int = min(needed, reserve_ammo)
	#
	#current_ammo += to_reload
	#reserve_ammo -= to_reload
	#
	#_is_reloading = false
	#
	#return true
#
#func add_ammo(amount: int) -> void:
	#reserve_ammo += amount
#
#func get_ammo_info() -> String:
	#return "%d/%d" % [current_ammo, reserve_ammo]

class_name Gun
extends Node3D

@export var gun_name: String = "Pistol"
@export var current_ammo: int = 12
@export var max_ammo: int = 12
@export var reserve_ammo: int = 60
@export var fire_rate: float = 0.3
@export var reload_time: float = 1.5
@export var is_hitscan: bool = false 
@export var ammo_scene: PackedScene  # The ammo scene to spawn
@export var muzzle_node: Marker3D
@export var animation_player: AnimationPlayer
@export var audio_player: AudioStreamPlayer3D
@export var raycast: RayCast3D



var _can_shoot: bool = true
var _is_reloading: bool = false
var _fire_timer: float = 0.0

func _process(delta: float) -> void:
	if not _can_shoot:
		_fire_timer += delta
		if _fire_timer >= fire_rate:
			_can_shoot = true
			_fire_timer = 0.0

func shoot() -> bool:
	if not _can_shoot:
		return false
	if _is_reloading:
		return false
	if current_ammo <= 0:
		_play_empty_sound()
		return false
	
	current_ammo -= 1
	
	
	if is_hitscan:
		_hitscan_shot(_fire_projectile())
	else:
		_fire_projectile()
		
	_play_shoot_effects()
	
	_can_shoot = false
	
	if current_ammo == 0:
		reload()
	
	return true

func _hitscan_shot(ammo_instance:Ammo) -> void:
	if raycast.is_colliding() and ammo_instance:
		var hit_object := raycast.get_collider()
		if hit_object.has_method("take_damage"):
			hit_object.take_damage(ammo_instance.damage)

func _fire_projectile() -> Ammo:
	var shoot_direction := -global_transform.basis.z
	if ammo_scene.can_instantiate():
		var ammo_instance: Ammo = ammo_scene.instantiate()
		ammo_instance.direction = shoot_direction
		get_tree().current_scene.add_child(ammo_instance)
		ammo_instance.global_position = muzzle_node.global_position
		ammo_instance.global_rotation = global_rotation
		return ammo_instance
	return null
func _play_shoot_effects() -> void:
	if animation_player:
		animation_player.play("shoot")
	
	if audio_player:
		audio_player.play()
	
	# Muzzle flash (optional)
	# You can add this to the ammo scene or keep it here

func _play_empty_sound() -> void:
	pass

func reload() -> bool:
	if _is_reloading or current_ammo == max_ammo or reserve_ammo <= 0:
		return false
	
	_is_reloading = true
	
	if animation_player:
		animation_player.play("reload")
	
	await get_tree().create_timer(reload_time).timeout
	
	var needed = max_ammo - current_ammo
	var to_reload = min(needed, reserve_ammo)
	
	current_ammo += to_reload
	reserve_ammo -= to_reload
	
	_is_reloading = false
	
	return true

func add_ammo(amount: int) -> void:
	reserve_ammo += amount

func get_ammo_info() -> String:
	return "%d/%d" % [current_ammo, reserve_ammo]
