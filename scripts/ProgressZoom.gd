extends Sprite2D

@onready var zoomBar : Sprite2D = get_parent()
#@onready var player = get_node("Player")

const MAX_HEIGHT_POURCENT : float = 0.8

var parentBarWidth : int
var parentBarHeight : int

# Called when the node enters the scene tree for the first time.
func _ready():
	parentBarHeight = zoomBar.texture.get_height()
	position.y = round(parentBarHeight/2 * MAX_HEIGHT_POURCENT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_parent().get_parent().get_parent();
	var barPosition : Vector2 = zoomBar.position
	var yTarget = 0;
	if player.zoom:
		yTarget = round(-(parentBarHeight/2 * MAX_HEIGHT_POURCENT))
	else:
		yTarget = round(parentBarHeight/2 * MAX_HEIGHT_POURCENT)
	barPosition.y = yTarget
	position.y = lerp(position.y, yTarget, 0.2)
		
