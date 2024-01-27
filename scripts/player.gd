extends CharacterBody3D

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D

@onready var raycast = $Pivot/Camera3D/RayCast3D

@onready var audiomate_component = $AudiomateComponent
@onready var state_component = $StateComponent

const SENS_SPEED = 3.0
const ZOOM_SENS_SPEED = 2.0
const LERP_ZOOM_SENS_SPEED = 2.0
const LERP_ZOOM_SPEED = 9.0
const CAMERA_ROTATION_OPTIONS : int = 8
const CAMERA_TURN_ANGLE_DEGREES = 360 / CAMERA_ROTATION_OPTIONS
#duration in seconds
const ROTATION_DURATION : float = 0.4

var zoom : bool = false
var targetRotation : Vector3
var startRotation : Vector3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("zoom"):
		zoom = !zoom
	
	if Input.is_action_just_pressed("add"):
		audiomate_component.add(10)
	if Input.is_action_just_pressed("subtract"):
		audiomate_component.subtract(10)
	
	
	if Input.is_action_just_pressed("bad"):
		state_component.state_is_bad()
	if Input.is_action_just_pressed("neutral"):
		state_component.state_is_neutral()
	if Input.is_action_just_pressed("good"):
		state_component.state_is_good()
	
	var canRotate = round(rad_to_deg(targetRotation.y)) == round(pivot.rotation_degrees.y)
	if canRotate && Input.is_action_just_pressed("left"):
		targetRotation = pivot.rotation
		targetRotation.y += deg_to_rad(CAMERA_TURN_ANGLE_DEGREES)
	if canRotate && Input.is_action_just_pressed("right"):
		targetRotation = pivot.rotation
		targetRotation.y -= deg_to_rad(CAMERA_TURN_ANGLE_DEGREES)
		
	var tween = get_tree().create_tween()
	tween.tween_property(pivot, "rotation", targetRotation, ROTATION_DURATION)
	#rotation.y = clamp(self.rotation.y, min(baseCRotYDeg, toAngle), max(baseCRotYDeg, toAngle))
	
	var zoomSource
	if zoom:
		camera.position.z = lerp(camera.position.z,-2.0,delta*LERP_ZOOM_SPEED)
		#camera.position.y = lerp(camera.position.y, input_dir.y*ZOOM_SENS_SPEED,delta*LERP_ZOOM_SENS_SPEED)
		#camera.position.x = lerp(camera.position.x, input_dir.x*ZOOM_SENS_SPEED,delta*LERP_ZOOM_SENS_SPEED)
	else:
		camera.position.z = lerp(camera.position.z,pivot.position.z,delta*LERP_ZOOM_SPEED)
		#rotate_y(deg_to_rad(-input_dir.x*SENS_SPEED))
		#pivot.rotate_x(deg_to_rad(-input_dir.y*SENS_SPEED))
		
	#pivot.rotation.x = clamp(pivot.rotation.x,deg_to_rad(0),deg_to_rad(50))
	
	#if raycast.is_colliding():
		#if raycast.get_collider().is_in_group("scene"):
			#print("scene detected")
		#else:
			#print("not a scene")
	#else:
		#print("not colliding")
	move_and_slide()

enum TypeBarre {
	Barre, Beurre
}
