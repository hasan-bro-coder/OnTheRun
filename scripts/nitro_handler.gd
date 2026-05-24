extends Node
class_name NitroHandler


@export var nitro_bar: ProgressBar

func _ready() -> void:
	if !nitro_bar:
		printerr("no nitro bar")
func _process(_delta: float) -> void:
	if Input.is_action_pressed("nitro") and Global.nitro_amount > 0:
		Global.nitro = true
		Global.speed = Global.speed_base * 2
		Global.nitro_amount -= 0.1
		nitro_bar.value = Global.nitro_amount
	else:
		Global.speed = Global.speed_base

func add_nitro(amount:int) -> void:
	Global.nitro_amount += amount
	nitro_bar.value = Global.nitro_amount

func remove_nitro(amount:int) -> void:
	Global.nitro_amount -= amount
	nitro_bar.value = Global.nitro_amount
	
