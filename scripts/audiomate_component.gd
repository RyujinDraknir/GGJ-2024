extends Node
class_name AudiomateComponent

signal legality_changed(current_value, max_value)
signal lose()

@export var max_audiomate : float = 100
@export var start_audiomate : float = 10
var current_audiomate : float

func _ready():
	current_audiomate = start_audiomate

func add(amount):
	current_audiomate += amount
	
	if current_audiomate > max_audiomate:
		current_audiomate = max_audiomate
	emit_signal("audiomate_changed", current_audiomate, max_audiomate)
		
func subtract(amount):
	current_audiomate -= amount
	emit_signal("audiomate_changed", current_audiomate, max_audiomate)
