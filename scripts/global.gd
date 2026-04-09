extends Node


const SPEED := 45.0
const GRAVITY := 120.0
const JUMP_HEIGHT := 8
const JUMP_BUFFER_TIME := 0.15
const VIEW_SIZE := 15.0


var player:Node3D
var player_pos:Vector3
var speed := 0.8
var warning_data: Array
var score := 0.0
var enemy_in_lanes :Array[int] = [0,0,0]

func reset()->void:
	player = null
	player_pos = Vector3.ZERO
	speed = 0.8
	warning_data = []
	score = 0.0
