extends Control

@onready var legality_bar = $LegalityProgressBar
@onready var audiomate_bar = $AudiomateProgressBar

@onready var legality_component = $"../LegalityComponent"
@onready var audiomate_component = $"../AudiomateComponent"

func _ready():
	legality_bar.max_value = legality_component.max_legality
	legality_bar.value = legality_component.current_legality
	legality_component.legality_changed.connect(_on_legality_component_legality_changed)
	
	audiomate_bar.max_value = audiomate_component.max_audiomate
	audiomate_bar.value = audiomate_component.current_audiomate
	audiomate_component.legality_changed.connect(_on_audiomate_component_audiomate_component)

func _on_legality_component_legality_changed(new_legality, max_legality):
	legality_bar.max_value = max_legality
	legality_bar.value = new_legality

func _on_audiomate_component_audiomate_component(new_audiomate, max_audiomate):
	audiomate_bar.max_value = max_audiomate
	audiomate_bar.value = new_audiomate
