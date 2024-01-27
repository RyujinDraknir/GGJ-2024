extends Node
class_name LegalityComponent

signal legality_changed(current_value, max_value)
signal lose()

@onready var state_component = $"../StateComponent"
@onready var audiomate_component = $"../AudiomateComponent"

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


@export var tempvar = 1
var ticksCount : int = 0;
func _process(delta):
	
	var temp : int = 1000
	ticksCount += 1
	if ticksCount >= 5:
		ticksCount = 0
		
		if state_component.bad:
			subtract((delta*2)*(audiomate_component.current_audiomate)/temp)
		elif state_component.neutral:
			subtract((delta*0.5)*(audiomate_component.current_audiomate)/temp)
		elif state_component.good:
			add((delta*0.5)*(audiomate_component.current_audiomate)/temp)

func on_lose():
	print("you lost")
