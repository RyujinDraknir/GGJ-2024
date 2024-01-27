extends Node
class_name AudiomateComponent

signal audiomate_changed(current_value, max_audiomate)

@onready var state_component = $"../StateComponent"

@export var max_audiomate : float = 800000
@export var min_audiomate : float = 10
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
	
	if current_audiomate <= min_audiomate:
		current_audiomate = min_audiomate
	emit_signal("audiomate_changed", current_audiomate, max_audiomate)

func _process(delta):
	if state_component.bad:
		add(1)
	elif state_component.neutral:
		subtract(1)
	elif state_component.good:
		subtract(2)
