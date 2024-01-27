extends CharacterBody3D

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D
@onready var audio_stream = $Pivot/AudioStreamPlayer

@onready var raycast = $Pivot/Camera3D/RayCast3D

@onready var audiomate_component = $AudiomateComponent
@onready var state_component = $StateComponent

const BASE_AUDIO_PATH : String = "res://assets/sounds/camera/"

const SENS_SPEED = 3.0
const ZOOM_SENS_SPEED = 2.0
const LERP_ZOOM_SENS_SPEED = 0.5
const LERP_ZOOM_SPEED = 9.0
const CAMERA_ROTATION_OPTIONS : int = 8
const CAMERA_TURN_ANGLE_DEGREES = 360 / CAMERA_ROTATION_OPTIONS
#duration in seconds
const ROTATION_DURATION : float = 0.4
const SCENE_BOUNDARY : float = 500.0
const BASE_CAMERA_POS : Vector3 = Vector3(0,0,0)

var targetRotation : Vector3
var startRotation : Vector3
var lastMousePosition : Vector2
var zoom : bool
var willZoom : bool

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and zoom :
		lastMousePosition = event.relative
		lastMousePosition = clamp(lastMousePosition, Vector2(-SCENE_BOUNDARY,-SCENE_BOUNDARY), Vector2(SCENE_BOUNDARY,SCENE_BOUNDARY))

func _process(delta):
	willZoom = Input.is_action_pressed("zoom")
	if !zoom && willZoom :
		Input.warp_mouse(Vector2(0,0))
		lastMousePosition = Vector2(0,0)
	zoom =  willZoom

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
	if canRotate:
		audio_stream.stop()
	if canRotate && Input.is_action_just_pressed("left"):
		targetRotation = pivot.rotation
		targetRotation.y += deg_to_rad(CAMERA_TURN_ANGLE_DEGREES)
		var audioIndex = randi_range(1, 4)
		audio_stream.stream = load(BASE_AUDIO_PATH + "Rail cam " + str(audioIndex) + ".wav")
		audio_stream.play()
	if canRotate && Input.is_action_just_pressed("right"):
		targetRotation = pivot.rotation
		targetRotation.y -= deg_to_rad(CAMERA_TURN_ANGLE_DEGREES)
		var audioIndex = randi_range(1, 4)
		audio_stream.stream = load(BASE_AUDIO_PATH + "Rail cam " + str(audioIndex) + ".wav")
		audio_stream.play()

	var tween = get_tree().create_tween()
	tween.tween_property(pivot, "rotation", targetRotation, ROTATION_DURATION)

	var zoomSource
	if zoom:
		#print(camera.position)
		camera.position.z = lerp(camera.position.z,-10.0,delta*LERP_ZOOM_SPEED)

		camera.position.y = lerp(camera.position.y, -lastMousePosition.y, delta*LERP_ZOOM_SENS_SPEED)
		camera.position.x = lerp(camera.position.x, lastMousePosition.x, delta*LERP_ZOOM_SENS_SPEED)
	else:
		camera.position = lerp(camera.position,BASE_CAMERA_POS,delta*LERP_ZOOM_SPEED)
		#print("pas zoomed")
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
