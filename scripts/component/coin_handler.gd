# SimpleCoinComponent.gd
extends Node
class_name CoinComponent

## Signal emitted when coin count changes
signal coins_changed(new_amount:int)

## Current number of coins
@export var coin_amount: int = 0:
	set(value):
		coin_amount = value
		coins_changed.emit(coin_amount)
		update_label()

## Optional label to display coin count
@export var coin_label: Label

func _ready() -> void:
	# Initial label update
	update_label()
	# Connect to our own signal for label updates
	coins_changed.connect(_on_coins_changed)

## Add coins to the total
func add_coins(amount: int) -> void:
	if amount > 0:
		coin_amount += amount
		update_label()

## Spend coins (returns true if successful)
func spend_coins(amount: int) -> bool:
	if amount <= 0:
		return false
	
	if coin_amount >= amount:
		coin_amount -= amount
		update_label()
		return true
	
	return false

## Check if enough coins
func has_coins(amount: int) -> bool:
	return coin_amount >= amount

## Update the connected label
func update_label() -> void:
	if coin_label:
		coin_label.text = "x" + str(coin_amount)

## Called when coins change
func _on_coins_changed(_new_amount) -> void:
	# You can connect to this signal from other scripts
	pass
