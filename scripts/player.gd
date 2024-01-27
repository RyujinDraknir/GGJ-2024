extends CharacterBody3D

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D
@onready var audio_stream = $Pivot/AudioStreamPlayer

@onready var raycast = $Pivot/Camera3D/RayCast3D

@onready var audiomate_component = $AudiomateComponent
@onready var state_component = $StateComponent

const BASE_AUDIO_PATH : String = "res://assets/sounds/camera/"

#const SENS_SPEED = 3.0
#const ZOOM_SENS_SPEED = 2.0
const LERP_ZOOM_SENS_SPEED = 0.5
const LERP_ZOOM_SPEED = 9.0
const CAMERA_ROTATION_OPTIONS : int = 8
const CAMERA_TURN_ANGLE_DEGREES = 360 / CAMERA_ROTATION_OPTIONS
#duration in seconds
const ROTATION_DURATION : float = 0.4
const SCENE_BOUNDARY : float = 5.0
const BASE_CAMERA_POS : Vector3 = Vector3(0,0,0)

var targetRotation : Vector3
var startRotation : Vector3
var lastMousePosition : Vector2
var zoom : bool
var willZoom : bool
var canZoom : bool = false

var isCameraMoving : bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and zoom :
		lastMousePosition = event.relative
		isCameraMoving = round(lastMousePosition.x) == round(event.relative.x) && round(lastMousePosition.y) == round(event.relative.y)
		#lastMousePosition = clamp(lastMousePosition, Vector2(-SCENE_BOUNDARY,-SCENE_BOUNDARY), Vector2(SCENE_BOUNDARY,SCENE_BOUNDARY))

func _process(delta):
	willZoom = Input.is_action_pressed("zoom")
	if !zoom && willZoom :
		Input.warp_mouse(Vector2(0,0))
		lastMousePosition = Vector2(0,0)
		playAudio(6, "Zoom caméra  ")
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
	print(isCameraMoving)
	if (canRotate && canZoom && !isCameraMoving):
		audio_stream.stop()
	if(!canZoom) :
		playAudio(5, "Zoom caméra ")
	if(isCameraMoving && !audio_stream.playing) :
		playAudio(4, "Zoom mouv cam ")
	if canRotate && Input.is_action_just_pressed("left"):
		targetRotation = pivot.rotation
		targetRotation.y += deg_to_rad(CAMERA_TURN_ANGLE_DEGREES)
		playAudio(4, "Rail cam ")
	if canRotate && Input.is_action_just_pressed("right"):
		targetRotation = pivot.rotation
		targetRotation.y -= deg_to_rad(CAMERA_TURN_ANGLE_DEGREES)
		playAudio(4, "Rail cam ")

	var tween = get_tree().create_tween()
	tween.tween_property(pivot, "rotation", targetRotation, ROTATION_DURATION)

	var zoomSource
	if zoom:
		#print(camera.position)
		camera.position.z = lerp(camera.position.z,-7.0,delta*LERP_ZOOM_SPEED)

		camera.position.y = lerp(camera.position.y, -lastMousePosition.y, delta*LERP_ZOOM_SENS_SPEED)
		camera.position.x = lerp(camera.position.x, lastMousePosition.x, delta*LERP_ZOOM_SENS_SPEED)
		camera.position.y = clamp(camera.position.y, -1, SCENE_BOUNDARY)
		camera.position.x = clamp(camera.position.x, -SCENE_BOUNDARY, SCENE_BOUNDARY)
	else:
		camera.position = lerp(camera.position,BASE_CAMERA_POS,delta*LERP_ZOOM_SPEED)
	var cameraZPos = round(camera.position.z)
	canZoom = (cameraZPos == -10 || cameraZPos == 0) && !cameraZPos > 0

func playAudio(nbOptions : int, fileName : String):
	audio_stream.stop()
	var audioIndex = randi_range(1, nbOptions)
	audio_stream.stream = load(BASE_AUDIO_PATH + fileName + str(audioIndex) + ".wav")
	audio_stream.play()
