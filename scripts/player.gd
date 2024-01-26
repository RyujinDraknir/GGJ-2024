extends CharacterBody3D

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D

const SENS_SPEED = 3.0
const LERP_ZOOM_SPEED = 9.0

var zoom : bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("zoom"):
		zoom = !zoom
	
	if zoom:
		camera.position.z = lerp(camera.position.z,-2.0,delta*LERP_ZOOM_SPEED)
	else:
		camera.position.z = lerp(camera.position.z,pivot.position.z,delta*LERP_ZOOM_SPEED)
	
	rotate_y(deg_to_rad(-input_dir.x*SENS_SPEED))
	pivot.rotate_x(deg_to_rad(-input_dir.y*SENS_SPEED))
	pivot.rotation.x = clamp(pivot.rotation.x,deg_to_rad(0),deg_to_rad(50))
	move_and_slide()
