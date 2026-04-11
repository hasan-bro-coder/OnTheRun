extends Node3D

## Emitted when a swipe is detected
signal swiped(direction: String)
## Emitted when gyro tilt changes (tilt_amount: -1 to 1, speed: how fast the tilt changed)
signal gyro_moved(tilt_amount: float, tilt_speed: float)

## Minimum distance to register as swipe (prevents taps)
@export var min_swipe_distance: float = 50.0
## Maximum time for a swipe (in seconds)
@export var max_swipe_time: float = 0.5
## Whether to detect swipes anywhere or only in this node's area
@export var detect_in_area_only: bool = false

## Gyro sensitivity (higher = more responsive)
@export var gyro_sensitivity: float = 5.0
## Gyro smoothing (0 = no smoothing, higher = smoother but laggier)
@export var gyro_smoothing: float = 5.0
## Maximum tilt angle in radians
@export var max_tilt: float = 1.2

var touch_start: Vector2 = Vector2.ZERO
var touch_start_time: float = 0.0
var touch_id: int = -1
var is_tracking: bool = false

var tilt_angle: float = 0.0
var current_tilt: float = 0.0
var previous_tilt: float = 0.0


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		touch_start = event.position
		touch_start_time = Time.get_ticks_msec() / 1000.0
		touch_id = event.index
		is_tracking = true
	
	elif event is InputEventScreenTouch and not event.pressed and is_tracking and event.index == touch_id:
		_evaluate_swipe(event.position)
		is_tracking = false
		touch_id = -1

func _process(delta: float) -> void:
	#if not DisplayServer.is_touchscreen_available():
		#return
	
	var gyro: Vector3 = Input.get_gyroscope()
	var rotation_speed := gyro.y
	
	tilt_angle += rotation_speed * delta
	tilt_angle = clamp(tilt_angle, -max_tilt, max_tilt)
	
	current_tilt = lerp(current_tilt, tilt_angle, gyro_smoothing * delta)
	
	var tilt_speed := (current_tilt - previous_tilt) / delta
	gyro_moved.emit(current_tilt, tilt_speed)
	
	var event := InputEventAction.new()
	event.pressed = true
	
	if current_tilt > 0.1:
		event.action = "right"
		Input.parse_input_event(event)
		await get_tree().process_frame
		event.pressed = false
		Input.parse_input_event(event)
	elif current_tilt < -0.1:
		event.action = "left"
		Input.parse_input_event(event)
		await get_tree().process_frame
		event.pressed = false
		Input.parse_input_event(event)
	
	previous_tilt = current_tilt

func _evaluate_swipe(touch_end: Vector2) -> void:
	var swipe_vector := touch_end - touch_start
	var swipe_distance := swipe_vector.length()
	var swipe_time := (Time.get_ticks_msec() / 1000.0) - touch_start_time
	
	if swipe_distance >= min_swipe_distance and swipe_time <= max_swipe_time:
		var direction := _get_direction(swipe_vector)
		swiped.emit(direction)
		_trigger_swipe_action(direction)

func _get_direction(vector: Vector2) -> String:
	var angle: float = vector.angle()
	var abs_angle: float = abs(angle)
	
	if abs_angle <= PI/4:
		return "right"
	elif abs_angle >= 3 * PI/4:
		return "left"
	elif angle > 0:
		return "down"
	else:
		return "up"

func _trigger_swipe_action(direction: String) -> void:
	var event := InputEventAction.new()
	event.pressed = true
	
	match direction:
		"up":
			event.action = "jump"
		"down":
			event.action = "slide"
		"left":
			event.action = "left"
		"right":
			event.action = "right"
	
	Input.parse_input_event(event)
	await get_tree().process_frame
	event.pressed = false
	Input.parse_input_event(event)

func calibrate_gyro() -> void:
	var gravity: Vector3 = Input.get_gravity()
	var neutral_tilt: float = clamp(gravity.x / 9.81, -1.0, 1.0)
	tilt_angle = neutral_tilt
	current_tilt = neutral_tilt
	previous_tilt = neutral_tilt
