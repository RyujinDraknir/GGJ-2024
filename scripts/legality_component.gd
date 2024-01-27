extends Node
class_name LegalityComponent

signal legality_changed(current_value, max_value)
signal lose()

@export var max_legality : float = 100
@export var start_legality : float = 10
var current_legality : float

func _ready():
	current_legality = start_legality

func add(amount):
	current_legality += amount
	
	if current_legality > max_legality:
		current_legality = max_legality
	emit_signal("legality_changed", current_legality, max_legality)
		
func subtract(amount):
	current_legality -= amount
	
	if current_legality <= 0:
		current_legality = 0
		emit_signal("lose")
		on_lose()
	emit_signal("legality_changed", current_legality, max_legality)

func on_lose():
	print("you lost")
