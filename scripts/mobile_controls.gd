extends Node3D

## Emitted when a swipe is detected
signal swiped(direction: String)

## Minimum distance to register as swipe (prevents taps)
@export var min_swipe_distance: float = 50.0

## Maximum time for a swipe (in seconds)
@export var max_swipe_time: float = 0.5

## Whether to detect swipes anywhere or only in this node's area
@export var detect_in_area_only: bool = false

var touch_start: Vector2 = Vector2.ZERO
var touch_start_time: float = 0.0
var touch_id: int = -1
var is_tracking: bool = false

func _input(event: InputEvent) -> void:
	# Touch began
	if event is InputEventScreenTouch and event.pressed:
		# Check if we should track this touch
		#if _should_track_touch(event):
		touch_start = event.position
		touch_start_time = Time.get_ticks_msec() / 1000.0
		touch_id = event.index
		is_tracking = true
	
	# Touch ended
	elif event is InputEventScreenTouch and not event.pressed and is_tracking and event.index == touch_id:
		_evaluate_swipe(event.position)
		is_tracking = false
		touch_id = -1

#func _should_track_touch(event: InputEventScreenTouch) -> bool:
	#if not detect_in_area_only:
		#return true
	#
	## Check if touch is within this node's area
	#if get_parent() is Control:
		#var rect = get_parent().get_global_rect()
		#return rect.has_point(event.position)
	#
	#return true

func _evaluate_swipe(touch_end: Vector2)->void:
	var swipe_vector := touch_end - touch_start
	var swipe_distance := swipe_vector.length()
	var swipe_time := (Time.get_ticks_msec() / 1000.0) - touch_start_time
	
	# Check if it meets swipe criteria
	if swipe_distance >= min_swipe_distance and swipe_time <= max_swipe_time:
		var direction := _get_direction(swipe_vector)
		swiped.emit(direction)
		
		# Also trigger input actions for game integration
		_trigger_swipe_action(direction)

func _get_direction(vector: Vector2) -> String:
	# Determine primary direction based on angle
	var angle:float = vector.angle()
	var abs_angle:float = abs(angle)
	
	# Convert angle to direction (4-directional)
	if abs_angle <= PI/4:  # Right
		return "right"
	elif abs_angle >= 3*PI/4:  # Left
		return "left"
	elif angle > 0:  # Down
		return "down"
	else:  # Up
		return "up"

func _trigger_swipe_action(direction: String) -> void:
	var event := InputEventAction.new()
	event.pressed = true
	
	match direction:
		"up":
			event.action = "jump"
		"down":
			event.action = "slide"
		"left", "right":
			pass
			# Could also trigger dash/roll actions
			#event.action = "dash_" + direction
	
	Input.parse_input_event(event)
	
	# Auto-release after one frame (for "just pressed" actions)
	await get_tree().process_frame
	event.pressed = false
	Input.parse_input_event(event)
