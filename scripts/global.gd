extends Node

var player:Node3D
var player_pos:Vector3
var speed := 0.8
var warning_data: Array
var score := 0.0

func reset()->void:
	player = null
	player_pos = Vector3.ZERO
	speed = 0.8
	warning_data = []
	score = 0.0
