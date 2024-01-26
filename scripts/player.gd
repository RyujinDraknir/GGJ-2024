extends CharacterBody3D

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D

@export var sens_speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	rotate_y(deg_to_rad(-input_dir.x))
	pivot.rotate_x(deg_to_rad(-input_dir.y))
	pivot.rotation.x = clamp(pivot.rotation.x,deg_to_rad(-50),deg_to_rad(50))
	move_and_slide()
