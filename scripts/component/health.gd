# HealthComponent.gd
extends Node
class_name HealthComponent

## Emitted when health reaches zero
signal died
## Emitted when health changes (current_health, old_health)
signal health_changed(new_health: int, old_health: int)
## Emitted when damaged (damage_amount, remaining_health)
signal damaged(damage_amount: int, remaining_health: int)
## Emitted when healed (heal_amount, remaining_health)
signal healed(heal_amount: int, remaining_health: int)

## Maximum health value
@export var max_health: float = 100.0
## Current health value
@export var current_health: float = 100.0
## Whether this entity can be damaged
@export var invulnerable: bool = false
## Whether to automatically queue_free the parent when health reaches zero
@export var auto_destroy_on_death: bool = true
## Optional delay before destroying (for death animations)
@export var death_destroy_delay: float = 0.0
# health bar ui
@export var health_bar: ProgressBar 
@export var deathscreen: CanvasLayer
## Track if we're already dead to prevent multiple death triggers
var is_dead: bool = false

func _ready() -> void:
	# Initialize current health to max if not set differently
	if current_health <= 0:
		current_health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

## Apply damage to this entity
func take_damage(amount: float) -> bool:
	if invulnerable or is_dead or amount <= 0:
		return false
	
	var old_health := current_health
	current_health = max(0, current_health - amount)
	
	# Emit signals
	damaged.emit(amount, current_health)
	health_changed.emit(current_health, old_health)
	
	if health_bar:
		health_bar.value = current_health
	
	print(name, " took ", amount, " damage. Health: ", current_health, "/", max_health)
	
	if current_health <= 0 and not is_dead:
		die()
	
	return true

## Heal this entity
func heal(amount: float) -> bool:
	if is_dead or amount <= 0 or current_health >= max_health:
		return false
	
	var old_health := current_health
	current_health = min(max_health, current_health + amount)
	
	# Emit signals
	healed.emit(amount, current_health)
	health_changed.emit(current_health, old_health)
	if health_bar:
		health_bar.value = current_health
		
	print(name, " healed ", amount, ". Health: ", current_health, "/", max_health)
	return true

## Instantly kill this entity
func kill() -> void:
	if not is_dead:
		take_damage(current_health)

## Handle death
func die() -> void:
	is_dead = true
	died.emit()
	
	if auto_destroy_on_death:
		if death_destroy_delay > 0:
			# Wait for delay then destroy
			var timer := get_tree().create_timer(death_destroy_delay)
			timer.timeout.connect(_destroy_parent)
		else:
			_destroy_parent()

## Destroy the parent node
func _destroy_parent() -> void:
	if get_parent() and is_instance_valid(get_parent()):
		get_parent().queue_free()

## Reset health to full
func reset_health() -> void:
	var old_health := current_health
	current_health = max_health
	health_changed.emit(current_health, old_health)
	if health_bar:
		health_bar.value = current_health
	is_dead = false

## Get health percentage (0.0 to 1.0)
func get_health_percent() -> float:
	return current_health / max_health

## Set max health (optionally adjust current health)
func set_max_health(new_max: float, adjust_current: bool = true) -> void:
	max_health = new_max
	if adjust_current:
		current_health = min(current_health, max_health)
	if health_bar:
		health_bar.value = current_health
		health_bar.max_value = max_health
